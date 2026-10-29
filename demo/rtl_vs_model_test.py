"""
rtl_vs_model_test.py
────────────────────────────────────────────────────────────────────
Tests PDF encrypt → decrypt round-trip in TWO ways:

  MODEL A — Correct Python model (aes_ca_demo.py)
            Decryption: ARK(w[14]) → InvShift → InvSub → [InvMix · ARK]×13 → ARK(w[0])
            CTR mode:   always encrypts the counter (correct)

  MODEL B — RTL-faithful model (mirrors aes_ca_accel.v EXACTLY, bugs included)
            Bug 1: Initial ARK always uses w[0..3] for both encrypt AND decrypt
            Bug 2: Decrypt round keys go FORWARD w[4..7]→w[52..55] instead of reverse
            Bug 3: india_pdf_engine passes decrypt_mode → cipher_decrypt (CTR uses inv path)

Runs both on a real PDF, compares SHA-256 hashes, byte counts, header validity.
"""

import os, sys, hashlib

sys.path.insert(0, os.path.dirname(__file__))
from aes_ca_demo import (
    aes256_key_schedule,
    apply_ca1, apply_ca1_inv,
    apply_ca2_shift, apply_ca2_inv_shift,
    apply_ca3_mix, apply_ca3_inv_mix,
    apply_ca4_add,
    aes_ca_encrypt_block, aes_ca_decrypt_block,
    aes_ca_ctr_encrypt,
    SBOX, INV_SBOX,
)

DEMO_DIR  = os.path.dirname(os.path.abspath(__file__))
REPO_ROOT = os.path.dirname(DEMO_DIR)

# Try several candidate PDFs
CANDIDATES = [
    os.path.join(REPO_ROOT, "doc", "deliverables", "INDIA_CRYPTO_SOC_Demo.pdf"),
    os.path.join(REPO_ROOT, "India Crypto SoC PPA Analysis.pdf"),
    os.path.join(REPO_ROOT, "doc", "deliverables", "INDIA_CRYPTO_SOC_Technical_Reference.pdf"),
    os.path.join(REPO_ROOT, "doc", "deliverables", "INDIA_CRYPTO_SOC_FAQ.pdf"),
]
INPUT_PDF = next((p for p in CANDIDATES if os.path.exists(p)), None)

KEY = bytes([
    0xDE,0xAD,0xBE,0xEF, 0xCA,0xFE,0xBA,0xBE,
    0x12,0x34,0x56,0x78, 0x9A,0xBC,0xDE,0xF0,
    0x0F,0xED,0xCB,0xA9, 0x87,0x65,0x43,0x21,
    0xAA,0xBB,0xCC,0xDD, 0xEE,0xFF,0x00,0x11,
])
IV = bytes([
    0x01,0x23,0x45,0x67, 0x89,0xAB,0xCD,0xEF,
    0xFE,0xDC,0xBA,0x98, 0x76,0x54,0x32,0x10,
])

# ─────────────────────────────────────────────────────────────────────────────
# RTL-FAITHFUL MODEL  (mirrors aes_ca_accel.v exactly, with all three bugs)
# ─────────────────────────────────────────────────────────────────────────────

def rtl_encrypt_block(plaintext_bytes, key_bytes):
    """
    Faithful to aes_ca_accel.v S_KEYSCHED + S_ROUND + S_FINAL for encrypt.
    This is CORRECT (same as the demo model for encryption).
    """
    round_keys, w = aes256_key_schedule(key_bytes)

    # S_KEYSCHED end: initial ARK with w[0..3]
    state = apply_ca4_add(plaintext_bytes, round_keys[0])

    # S_ROUND: round_r = 1..13, keys w[4..55] forward
    for r in range(1, 14):
        ca_rule = w[4*r][0]
        state = apply_ca1(state, ca_rule)
        state = apply_ca2_shift(state)
        state = apply_ca3_mix(state)
        state = apply_ca4_add(state, round_keys[r])

    # S_FINAL encrypt: sub → shift → ARK(w[56..59])
    ca_rule = w[56][0]
    state = apply_ca1(state, ca_rule)
    state = apply_ca2_shift(state)
    state = apply_ca4_add(state, round_keys[14])

    return state


def rtl_decrypt_block_BUGGY(ciphertext_bytes, key_bytes):
    """
    RTL-faithful decrypt — mirrors aes_ca_accel.v with ALL THREE BUGS:

    BUG 1: Initial ARK uses w[0..3] (should use w[56..59])
    BUG 2: Round keys go FORWARD w[4..7]→w[52..55] (should be reverse)
    BUG 3: (applied at CTR level — see rtl_pdf_decrypt_BUGGY)
    """
    round_keys, w = aes256_key_schedule(key_bytes)

    # ── BUG 1: Initial ARK with w[0..3] instead of w[56..59] ──────────────
    state = apply_ca4_add(ciphertext_bytes, round_keys[0])   # BUG: should be round_keys[14]

    # S_ROUND for decrypt: round_r counts UP 1→13 (BUG 2: should count down)
    for r in range(1, 14):
        ca_rule = w[4*r][0]                              # BUG 2: forward key order
        state = apply_ca4_add(state, round_keys[r])      # ARK with wrong key
        state = apply_ca3_inv_mix(state)
        state = apply_ca2_inv_shift(state)
        state = apply_ca1_inv(state, ca_rule)

    # S_FINAL decrypt in RTL: ARK(w[0..3]) → InvShift → InvSub
    # (note: w[0..3] was already XORed at start — double-ARK with same key = no-op XOR)
    state = apply_ca4_add(state, round_keys[0])
    state = apply_ca2_inv_shift(state)
    ca_rule = w[0][0]
    state = apply_ca1_inv(state, ca_rule)

    return state


def rtl_ctr_encrypt_BUGGY(data, key, iv, decrypt_mode=False):
    """
    RTL-faithful CTR mode from india_pdf_engine.v.

    BUG 3: cipher_decrypt = decrypt_mode
           When decrypt_mode=True, counter blocks go through the broken
           rtl_decrypt_block_BUGGY() instead of always using encryption.
    """
    result = bytearray()
    n_blocks = (len(data) + 15) // 16
    padded = data + b'\x00' * (n_blocks * 16 - len(data))

    for i in range(n_blocks):
        counter_block = bytearray(iv)
        counter_val = i & 0xFFFFFFFF
        counter_block[12] ^= (counter_val >> 24) & 0xFF
        counter_block[13] ^= (counter_val >> 16) & 0xFF
        counter_block[14] ^= (counter_val >>  8) & 0xFF
        counter_block[15] ^= (counter_val      ) & 0xFF

        if decrypt_mode:
            # BUG 3: uses the broken decrypt path on the counter
            keystream = rtl_decrypt_block_BUGGY(bytes(counter_block), key)
        else:
            keystream = rtl_encrypt_block(bytes(counter_block), key)

        block = padded[i*16:(i+1)*16]
        for j in range(16):
            result.append(block[j] ^ keystream[j])

    return bytes(result[:len(data)])


# ─────────────────────────────────────────────────────────────────────────────
# HELPERS
# ─────────────────────────────────────────────────────────────────────────────

def sha256(data):
    return hashlib.sha256(data).hexdigest()

def hex32(data):
    return ' '.join(f'{b:02x}' for b in data[:32])

def bar(pct, width=40):
    filled = int(width * pct / 100)
    return '█' * filled + '░' * (width - filled)

SEP = '═' * 72

# ─────────────────────────────────────────────────────────────────────────────
# MAIN TEST
# ─────────────────────────────────────────────────────────────────────────────

def run():
    print(SEP)
    print('  INDIA_CRYPTO_SOC — PDF Encrypt/Decrypt Round-Trip Verification')
    print('  Correct Python Model  vs  RTL-Faithful Model (aes_ca_accel.v)')
    print(SEP)

    if INPUT_PDF is None:
        print('[ERROR] No PDF found. Checked:')
        for c in CANDIDATES:
            print(f'        {c}')
        sys.exit(1)

    with open(INPUT_PDF, 'rb') as f:
        original = f.read()

    orig_sha = sha256(original)
    print(f'\n[INPUT PDF]')
    print(f'  File  : {os.path.basename(INPUT_PDF)}')
    print(f'  Size  : {len(original):,} bytes  ({len(original)/1024:.1f} KB)')
    print(f'  SHA256: {orig_sha}')
    print(f'  Header: {original[:8]}  (valid PDF: {original[:4] == b"%PDF"})')
    print(f'  Key   : {KEY.hex()}')
    print(f'  IV    : {IV.hex()}')

    # ── ENCRYPT (same for both models — only decrypt diverges) ────────────
    print(f'\n{"─"*72}')
    print(f'  STEP 1 — ENCRYPT  (CTR mode, always uses forward AES — both models)')
    print(f'{"─"*72}')

    ciphertext = aes_ca_ctr_encrypt(original, KEY, IV)
    enc_sha    = sha256(ciphertext)

    diff = sum(1 for a,b in zip(original, ciphertext) if a!=b)
    print(f'  Ciphertext size  : {len(ciphertext):,} bytes')
    print(f'  SHA256           : {enc_sha}')
    print(f'  Bytes changed    : {diff:,}/{len(original):,} ({diff*100//len(original)}%)')
    print(f'  Diffusion bar    : [{bar(diff*100//len(original))}]')
    print(f'  First 32 bytes   : {hex32(ciphertext)}')
    assert ciphertext != original, 'BUG: ciphertext == plaintext!'
    print(f'  Ciphertext ≠ plaintext: ✅')

    # ── MODEL A: CORRECT decrypt ──────────────────────────────────────────
    print(f'\n{"─"*72}')
    print(f'  STEP 2A — DECRYPT  Model A: Correct Python Model')
    print(f'  (ARK w[56..59] first, round keys reversed, CTR always encrypts counter)')
    print(f'{"─"*72}')

    dec_A    = aes_ca_ctr_encrypt(ciphertext, KEY, IV)   # CTR: same op
    sha_A    = sha256(dec_A)
    match_A  = (dec_A == original)
    diff_A   = sum(1 for a,b in zip(original, dec_A) if a!=b)

    print(f'  Decrypted size   : {len(dec_A):,} bytes')
    print(f'  SHA256           : {sha_A}')
    print(f'  SHA256 match     : {"✅  MATCH" if sha_A == orig_sha else "❌  MISMATCH"}')
    print(f'  Byte-for-byte    : {"✅  IDENTICAL" if match_A else "❌  DIFFERENT"}')
    print(f'  Bytes wrong      : {diff_A:,}')
    print(f'  First 32 bytes   : {hex32(dec_A)}')
    print(f'  Header valid     : {"✅  %PDF" if dec_A[:4] == b"%PDF" else "❌  " + repr(dec_A[:4])}')

    # Save Model A output
    out_A = os.path.join(DEMO_DIR, 'decrypted_model_A_correct.pdf')
    with open(out_A, 'wb') as f:
        f.write(dec_A)
    print(f'  Saved            : {os.path.basename(out_A)}')

    # ── MODEL B: RTL-FAITHFUL (buggy) decrypt ─────────────────────────────
    print(f'\n{"─"*72}')
    print(f'  STEP 2B — DECRYPT  Model B: RTL-Faithful (aes_ca_accel.v with bugs)')
    print(f'  Bug 1: Initial ARK uses w[0..3] instead of w[56..59]')
    print(f'  Bug 2: Round keys applied FORWARD w[4..55] instead of reversed')
    print(f'  Bug 3: cipher_decrypt=decrypt_mode → broken inv path on CTR counter')
    print(f'{"─"*72}')

    dec_B   = rtl_ctr_encrypt_BUGGY(ciphertext, KEY, IV, decrypt_mode=True)
    sha_B   = sha256(dec_B)
    match_B = (dec_B == original)
    diff_B  = sum(1 for a,b in zip(original, dec_B) if a!=b)

    print(f'  Decrypted size   : {len(dec_B):,} bytes')
    print(f'  SHA256           : {sha_B}')
    print(f'  SHA256 match     : {"✅  MATCH" if sha_B == orig_sha else "❌  MISMATCH"}')
    print(f'  Byte-for-byte    : {"✅  IDENTICAL" if match_B else "❌  DIFFERENT"}')
    print(f'  Bytes wrong      : {diff_B:,}  ({diff_B*100//len(original) if len(original) else 0}% corrupted)')
    print(f'  Corruption bar   : [{bar(diff_B*100//len(original) if len(original) else 0)}]')
    print(f'  First 32 bytes   : {hex32(dec_B)}')
    print(f'  Header valid     : {"✅  %PDF" if dec_B[:4] == b"%PDF" else "❌  " + repr(dec_B[:4])}')

    # Save Model B output
    out_B = os.path.join(DEMO_DIR, 'decrypted_model_B_rtl_buggy.bin')
    with open(out_B, 'wb') as f:
        f.write(dec_B)
    print(f'  Saved            : {os.path.basename(out_B)}')

    # ── SIDE-BY-SIDE COMPARISON ───────────────────────────────────────────
    print(f'\n{SEP}')
    print(f'  COMPARISON SUMMARY')
    print(f'{SEP}')
    print(f'  {"Metric":<30} {"Model A (Correct)":<28} {"Model B (RTL)":<28}')
    print(f'  {"─"*30} {"─"*28} {"─"*28}')

    def yn(v): return '✅  YES' if v else '❌  NO'

    print(f'  {"SHA256 matches original":<30} {yn(match_A):<28} {yn(match_B):<28}')
    print(f'  {"Bytes wrong":<30} {str(diff_A):<28} {str(diff_B):<28}')
    print(f'  {"Header (%PDF) valid":<30} {yn(dec_A[:4]==b"%PDF"):<28} {yn(dec_B[:4]==b"%PDF"):<28}')
    print(f'  {"Openable as PDF":<30} {yn(match_A):<28} {yn(match_B):<28}')

    # ── BUG ISOLATION: which bug causes how much damage ───────────────────
    print(f'\n{SEP}')
    print(f'  BUG ISOLATION — Impact of each bug individually')
    print(f'{SEP}')

    # Test Bug 3 alone (CTR uses decrypt path but with CORRECT block decrypt)
    def ctr_bug3_only(data, key, iv):
        result = bytearray()
        n_blocks = (len(data) + 15) // 16
        padded = data + b'\x00' * (n_blocks * 16 - len(data))
        for i in range(n_blocks):
            cb = bytearray(iv)
            cv = i & 0xFFFFFFFF
            cb[12] ^= (cv >> 24) & 0xFF; cb[13] ^= (cv >> 16) & 0xFF
            cb[14] ^= (cv >>  8) & 0xFF; cb[15] ^= cv & 0xFF
            # Bug 3: uses correct aes_ca_decrypt_block (not the RTL version)
            keystream = aes_ca_decrypt_block(bytes(cb), key)
            block = padded[i*16:(i+1)*16]
            for j in range(16):
                result.append(block[j] ^ keystream[j])
        return bytes(result[:len(data)])

    dec_bug3 = ctr_bug3_only(ciphertext, KEY, IV)
    diff_bug3 = sum(1 for a,b in zip(original, dec_bug3) if a!=b)
    print(f'  Bug 3 alone  (CTR counter uses correct inv cipher):  {diff_bug3:,} bytes wrong  ({diff_bug3*100//len(original)}% corrupted)')

    # Test Bugs 1+2 alone (CTR always encrypts counter = correct, but block decrypt is buggy)
    def ctr_bugs12_only(data, key, iv):
        result = bytearray()
        n_blocks = (len(data) + 15) // 16
        padded = data + b'\x00' * (n_blocks * 16 - len(data))
        for i in range(n_blocks):
            cb = bytearray(iv)
            cv = i & 0xFFFFFFFF
            cb[12] ^= (cv >> 24) & 0xFF; cb[13] ^= (cv >> 16) & 0xFF
            cb[14] ^= (cv >>  8) & 0xFF; cb[15] ^= cv & 0xFF
            # Always encrypt (correct for CTR) but counter is encrypted with rtl buggy decrypt
            # Actually for CTR the counter is always encrypted, so bugs 1+2 don't apply here
            # Bugs 1+2 only matter for standalone AES decrypt mode
            keystream = rtl_encrypt_block(bytes(cb), key)  # correct CTR
            block = padded[i*16:(i+1)*16]
            for j in range(16):
                result.append(block[j] ^ keystream[j])
        return bytes(result[:len(data)])

    dec_correct_ctr = ctr_bugs12_only(ciphertext, KEY, IV)
    diff_correct_ctr = sum(1 for a,b in zip(original, dec_correct_ctr) if a!=b)
    print(f'  CTR correct  (encrypt counter, ignore bugs 1+2):     {diff_correct_ctr:,} bytes wrong  ({diff_correct_ctr*100//len(original)}% corrupted)')

    # Standalone block decrypt bugs 1+2
    test_block = original[:16]
    enc_block  = rtl_encrypt_block(test_block, KEY)
    dec_correct_block  = aes_ca_decrypt_block(enc_block, KEY)
    dec_buggy_block    = rtl_decrypt_block_BUGGY(enc_block, KEY)

    print(f'\n  Single-block decrypt check (first 16 bytes of PDF):')
    print(f'  Original block : {test_block.hex()}')
    print(f'  Encrypted      : {enc_block.hex()}')
    print(f'  Decrypted (correct model): {dec_correct_block.hex()}  {"✅ MATCH" if dec_correct_block == test_block else "❌ MISMATCH"}')
    print(f'  Decrypted (RTL buggy)    : {dec_buggy_block.hex()}  {"✅ MATCH" if dec_buggy_block == test_block else "❌ MISMATCH"}')

    # ── FINAL VERDICT ─────────────────────────────────────────────────────
    print(f'\n{SEP}')
    print(f'  FINAL VERDICT')
    print(f'{SEP}')

    if match_A:
        print(f'\n  Model A (Correct) : ✅  PASS — PDF decrypts perfectly, byte-for-byte identical')
    else:
        print(f'\n  Model A (Correct) : ❌  FAIL — {diff_A:,} bytes wrong')

    if not match_B:
        print(f'  Model B (RTL)     : ❌  FAIL — {diff_B:,}/{len(original):,} bytes corrupted ({diff_B*100//len(original)}%)')
        print(f'                       PDF header: {repr(dec_B[:8])}')
        print(f'                       File is unreadable garbage')
    else:
        print(f'  Model B (RTL)     : ✅  PASS (unexpected!)')

    print(f'\n  Root cause: 3 bugs in aes_ca_accel.v + india_pdf_engine.v:')
    print(f'    Bug 1 — aes_ca_accel.v S_KEYSCHED: initial ARK uses w[0..3] for decrypt')
    print(f'             (should use w[56..59])')
    print(f'    Bug 2 — aes_ca_accel.v S_ROUND: round keys forward w[4..55] for decrypt')
    print(f'             (should be reversed: w[52..55]→w[4..7])')
    print(f'    Bug 3 — india_pdf_engine.v: assign cipher_decrypt = decrypt_mode')
    print(f'             (CTR mode must ALWAYS encrypt the counter — fix: assign 1\'b0)')

    print(f'\n  Fix summary:')
    print(f'    aes_ca_accel.v S_KEYSCHED:')
    print(f'      if (!decrypt_r) aes_state <= aes_state ^ {{w[0],w[1],w[2],w[3]}}; ')
    print(f'      else            aes_state <= aes_state ^ {{w[56],w[57],w[58],w[59]}};')
    print(f'    aes_ca_accel.v S_ROUND:')
    print(f'      wire [5:0] rk_sel = decrypt_r ? (6\'d14 - round_r) : round_r;')
    print(f'      rk0 = w[4*rk_sel]; ... ')
    print(f'    india_pdf_engine.v:')
    print(f'      assign cipher_decrypt = 1\'b0;  // CTR always encrypts counter')

    print(f'\n{SEP}')
    return match_A, match_B

if __name__ == '__main__':
    ok_A, ok_B = run()
    sys.exit(0 if (ok_A and not ok_B) else 1)
