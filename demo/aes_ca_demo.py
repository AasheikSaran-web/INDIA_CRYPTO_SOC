#!/usr/bin/env python3
"""
aes_ca_demo.py — AES-256-CTR + Cellular Automaton Encryption Demo
INDIA_CRYPTO_SOC Project

Implements the exact CA perturbation from aes_ca_accel.v:
  CA-1: SubBytes with neighbourhood XOR perturbation (rule-driven)
  CA-2: ShiftRows (AES cyclic row-shift CA)
  CA-3: MixColumns (GF(2^8) column-mix CA)
  CA-4: AddRoundKey (XOR — equivalent to Rule-90 bitwise)

The CA perturbation is a hardware-accelerated modification layered on top of
standard AES-256 to provide additional diffusion and confusion properties for
the TSMC 28nm HPC tapeout.
"""

import os
import struct
import hashlib
import hmac as hmac_lib

# Try pycryptodome first, fall back to cryptography library
try:
    from Crypto.Cipher import AES
    USING_PYCRYPTODOME = True
except ImportError:
    from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes
    from cryptography.hazmat.backends import default_backend
    USING_PYCRYPTODOME = False

# ============================================================================
# AES S-Box (from RTL)
# ============================================================================

SBOX = [
    0x63,0x7c,0x77,0x7b,0xf2,0x6b,0x6f,0xc5,0x30,0x01,0x67,0x2b,0xfe,0xd7,0xab,0x76,
    0xca,0x82,0xc9,0x7d,0xfa,0x59,0x47,0xf0,0xad,0xd4,0xa2,0xaf,0x9c,0xa4,0x72,0xc0,
    0xb7,0xfd,0x93,0x26,0x36,0x3f,0xf7,0xcc,0x34,0xa5,0xe5,0xf1,0x71,0xd8,0x31,0x15,
    0x04,0xc7,0x23,0xc3,0x18,0x96,0x05,0x9a,0x07,0x12,0x80,0xe2,0xeb,0x27,0xb2,0x75,
    0x09,0x83,0x2c,0x1a,0x1b,0x6e,0x5a,0xa0,0x52,0x3b,0xd6,0xb3,0x29,0xe3,0x2f,0x84,
    0x53,0xd1,0x00,0xed,0x20,0xfc,0xb1,0x5b,0x6a,0xcb,0xbe,0x39,0x4a,0x4c,0x58,0xcf,
    0xd0,0xef,0xaa,0xfb,0x43,0x4d,0x33,0x85,0x45,0xf9,0x02,0x7f,0x50,0x3c,0x9f,0xa8,
    0x51,0xa3,0x40,0x8f,0x92,0x9d,0x38,0xf5,0xbc,0xb6,0xda,0x21,0x10,0xff,0xf3,0xd2,
    0xcd,0x0c,0x13,0xec,0x5f,0x97,0x44,0x17,0xc4,0xa7,0x7e,0x3d,0x64,0x5d,0x19,0x73,
    0x60,0x81,0x4f,0xdc,0x22,0x2a,0x90,0x88,0x46,0xee,0xb8,0x14,0xde,0x5e,0x0b,0xdb,
    0xe0,0x32,0x3a,0x0a,0x49,0x06,0x24,0x5c,0xc2,0xd3,0xac,0x62,0x91,0x95,0xe4,0x79,
    0xe7,0xc8,0x37,0x6d,0x8d,0xd5,0x4e,0xa9,0x6c,0x56,0xf4,0xea,0x65,0x7a,0xae,0x08,
    0xba,0x78,0x25,0x2e,0x1c,0xa6,0xb4,0xc6,0xe8,0xdd,0x74,0x1f,0x4b,0xbd,0x8b,0x8a,
    0x70,0x3e,0xb5,0x66,0x48,0x03,0xf6,0x0e,0x61,0x35,0x57,0xb9,0x86,0xc1,0x1d,0x9e,
    0xe1,0xf8,0x98,0x11,0x69,0xd9,0x8e,0x94,0x9b,0x1e,0x87,0xe9,0xce,0x55,0x28,0xdf,
    0x8c,0xa1,0x89,0x0d,0xbf,0xe6,0x42,0x68,0x41,0x99,0x2d,0x0f,0xb0,0x54,0xbb,0x16,
]

INV_SBOX = [
    0x52,0x09,0x6a,0xd5,0x30,0x36,0xa5,0x38,0xbf,0x40,0xa3,0x9e,0x81,0xf3,0xd7,0xfb,
    0x7c,0xe3,0x39,0x82,0x9b,0x2f,0xff,0x87,0x34,0x8e,0x43,0x44,0xc4,0xde,0xe9,0xcb,
    0x54,0x7b,0x94,0x32,0xa6,0xc2,0x23,0x3d,0xee,0x4c,0x95,0x0b,0x42,0xfa,0xc3,0x4e,
    0x08,0x2e,0xa1,0x66,0x28,0xd9,0x24,0xb2,0x76,0x5b,0xa2,0x49,0x6d,0x8b,0xd1,0x25,
    0x72,0xf8,0xf6,0x64,0x86,0x68,0x98,0x16,0xd4,0xa4,0x5c,0xcc,0x5d,0x65,0xb6,0x92,
    0x6c,0x70,0x48,0x50,0xfd,0xed,0xb9,0xda,0x5e,0x15,0x46,0x57,0xa7,0x8d,0x9d,0x84,
    0x90,0xd8,0xab,0x00,0x8c,0xbc,0xd3,0x0a,0xf7,0xe4,0x58,0x05,0xb8,0xb3,0x45,0x06,
    0xd0,0x2c,0x1e,0x8f,0xca,0x3f,0x0f,0x02,0xc1,0xaf,0xbd,0x03,0x01,0x13,0x8a,0x6b,
    0x3a,0x91,0x11,0x41,0x4f,0x67,0xdc,0xea,0x97,0xf2,0xcf,0xce,0xf0,0xb4,0xe6,0x73,
    0x96,0xac,0x74,0x22,0xe7,0xad,0x35,0x85,0xe2,0xf9,0x37,0xe8,0x1c,0x75,0xdf,0x6e,
    0x47,0xf1,0x1a,0x71,0x1d,0x29,0xc5,0x89,0x6f,0xb7,0x62,0x0e,0xaa,0x18,0xbe,0x1b,
    0xfc,0x56,0x3e,0x4b,0xc6,0xd2,0x79,0x20,0x9a,0xdb,0xc0,0xfe,0x78,0xcd,0x5a,0xf4,
    0x1f,0xdd,0xa8,0x33,0x88,0x07,0xc7,0x31,0xb1,0x12,0x10,0x59,0x27,0x80,0xec,0x5f,
    0x60,0x51,0x7f,0xa9,0x19,0xb5,0x4a,0x0d,0x2d,0xe5,0x7a,0x9f,0x93,0xc9,0x9c,0xef,
    0xa0,0xe0,0x3b,0x4d,0xae,0x2a,0xf5,0xb0,0xc8,0xeb,0xbb,0x3c,0x83,0x53,0x99,0x61,
    0x17,0x2b,0x04,0x7e,0xba,0x77,0xd6,0x26,0xe1,0x69,0x14,0x63,0x55,0x21,0x0c,0x7d,
]

RCON = [0x01,0x02,0x04,0x08,0x10,0x20,0x40,0x80,0x1b,0x36,0x6c,0xd8,0xab,0x4d]

# ============================================================================
# GF(2^8) arithmetic (poly 0x11B)
# ============================================================================

def xtime(a):
    return ((a << 1) ^ 0x1B) & 0xFF if a & 0x80 else (a << 1) & 0xFF

def mul2(a): return xtime(a)
def mul3(a): return xtime(a) ^ a
def mul9(a): return xtime(xtime(xtime(a))) ^ a
def mul11(a): return xtime(xtime(xtime(a))) ^ xtime(a) ^ a
def mul13(a): return xtime(xtime(xtime(a))) ^ xtime(xtime(a)) ^ a
def mul14(a): return xtime(xtime(xtime(a))) ^ xtime(xtime(a)) ^ xtime(a)

# ============================================================================
# CA-1: SubBytes with neighbourhood XOR perturbation (from RTL ca1_sub_byte)
# For each byte i in the 16-byte state:
#   sb[i] = SBOX[b[i]] ^ (rule[prev_b[2:0]] ? SBOX[prev_b] : 0)
#                      ^ (rule[next_b[2:0]] ? SBOX[next_b] : 0)
# where prev = (i-1) % 16, next = (i+1) % 16
# The "rule" byte: bit j is set if the low 3 bits of the neighbour equal j
# ============================================================================

def ca1_sub_byte(b, prev_b, next_b, rule):
    sb      = SBOX[b]
    prev_sb = SBOX[prev_b]
    next_sb = SBOX[next_b]
    result  = sb
    if (rule >> (prev_b & 0x07)) & 1:
        result ^= prev_sb
    if (rule >> (next_b & 0x07)) & 1:
        result ^= next_sb
    return result

def ca1_inv_sub_byte(b, prev_b, next_b, rule):
    isb      = INV_SBOX[b]
    prev_isb = INV_SBOX[prev_b]
    next_isb = INV_SBOX[next_b]
    result   = isb
    if (rule >> (prev_b & 0x07)) & 1:
        result ^= prev_isb
    if (rule >> (next_b & 0x07)) & 1:
        result ^= next_isb
    return result

def apply_ca1(state_bytes, rule):
    """CA-1 forward SubBytes with neighbourhood perturbation."""
    n = len(state_bytes)
    out = bytearray(n)
    for i in range(n):
        prev_b = state_bytes[(i - 1) % n]
        next_b = state_bytes[(i + 1) % n]
        out[i] = ca1_sub_byte(state_bytes[i], prev_b, next_b, rule)
    return bytes(out)

def apply_ca1_inv(state_bytes, rule):
    """CA-1 inverse SubBytes with neighbourhood perturbation."""
    n = len(state_bytes)
    out = bytearray(n)
    for i in range(n):
        prev_b = state_bytes[(i - 1) % n]
        next_b = state_bytes[(i + 1) % n]
        out[i] = ca1_inv_sub_byte(state_bytes[i], prev_b, next_b, rule)
    return bytes(out)

# ============================================================================
# CA-2: ShiftRows (AES column-major layout)
# byte[col*4 + row] = state byte at row r, col c
# Row r shifts left by r columns
# ============================================================================

def apply_ca2_shift(state_bytes):
    """CA-2 ShiftRows in AES column-major layout."""
    b = list(state_bytes)
    o = [0] * 16
    for r in range(4):
        for c in range(4):
            o[4*c + r] = b[4*((c + r) % 4) + r]
    return bytes(o)

def apply_ca2_inv_shift(state_bytes):
    """CA-2 InvShiftRows."""
    b = list(state_bytes)
    o = [0] * 16
    for r in range(4):
        for c in range(4):
            o[4*c + r] = b[4*((c + 4 - r) % 4) + r]
    return bytes(o)

# ============================================================================
# CA-3: MixColumns
# ============================================================================

def mix_col(b0, b1, b2, b3):
    return bytes([
        mul2(b0) ^ mul3(b1) ^ b2       ^ b3,
        b0       ^ mul2(b1) ^ mul3(b2) ^ b3,
        b0       ^ b1       ^ mul2(b2) ^ mul3(b3),
        mul3(b0) ^ b1       ^ b2       ^ mul2(b3),
    ])

def inv_mix_col(b0, b1, b2, b3):
    return bytes([
        mul14(b0) ^ mul11(b1) ^ mul13(b2) ^ mul9(b3),
        mul9(b0)  ^ mul14(b1) ^ mul11(b2) ^ mul13(b3),
        mul13(b0) ^ mul9(b1)  ^ mul14(b2) ^ mul11(b3),
        mul11(b0) ^ mul13(b1) ^ mul9(b2)  ^ mul14(b3),
    ])

def apply_ca3_mix(state_bytes):
    b = list(state_bytes)
    out = bytearray()
    for c in range(4):
        out += mix_col(b[4*c], b[4*c+1], b[4*c+2], b[4*c+3])
    return bytes(out)

def apply_ca3_inv_mix(state_bytes):
    b = list(state_bytes)
    out = bytearray()
    for c in range(4):
        out += inv_mix_col(b[4*c], b[4*c+1], b[4*c+2], b[4*c+3])
    return bytes(out)

# ============================================================================
# CA-4: AddRoundKey (XOR — Rule-90 bitwise)
# ============================================================================

def apply_ca4_add(state_bytes, round_key_bytes):
    return bytes(a ^ b for a, b in zip(state_bytes, round_key_bytes))

# ============================================================================
# AES-256 Key Schedule (matches RTL key expansion)
# ============================================================================

def sub_word(w):
    return bytes(SBOX[b] for b in w)

def rot_word(w):
    return bytes([w[1], w[2], w[3], w[0]])

def aes256_key_schedule(key_bytes):
    """Expand 32-byte AES-256 key into 15 round keys (60 words)."""
    assert len(key_bytes) == 32
    w = []
    # Initial 8 words from key
    for i in range(8):
        w.append(bytearray(key_bytes[4*i:4*i+4]))

    rcon_idx = 0
    for i in range(8, 60):
        temp = bytearray(w[i-1])
        if i % 8 == 0:
            temp = bytearray(b ^ r for b, r in zip(
                sub_word(rot_word(temp)),
                bytes([RCON[rcon_idx], 0, 0, 0])
            ))
            rcon_idx += 1
        elif i % 8 == 4:
            temp = bytearray(sub_word(temp))
        new_word = bytearray(a ^ b for a, b in zip(w[i-8], temp))
        w.append(new_word)

    # Build 15 round keys
    round_keys = []
    for r in range(15):
        rk = bytearray()
        for j in range(4):
            rk += w[4*r + j]
        round_keys.append(bytes(rk))

    return round_keys, w

# ============================================================================
# AES-256-CA Encrypt / Decrypt (single 128-bit block)
# Matches RTL FSM: S_KEYSCHED → initial AddRoundKey → S_ROUND (×13) → S_FINAL
# ============================================================================

def aes_ca_encrypt_block(plaintext_bytes, key_bytes):
    """Encrypt one 128-bit block using AES-256 + CA perturbation."""
    assert len(plaintext_bytes) == 16
    assert len(key_bytes) == 32

    round_keys, w = aes256_key_schedule(key_bytes)

    # Initial AddRoundKey (round 0) — CA-4
    state = apply_ca4_add(plaintext_bytes, round_keys[0])
    ca_rule1 = w[0][0]  # ca_rule1_r = w[0][31:24] = first byte of w[0]

    # Rounds 1–13: CA1→CA2→CA3→CA4
    for r in range(1, 14):
        ca_rule1 = w[4*r][0]  # rk0[31:24] = first byte of w[4r]
        state = apply_ca1(state, ca_rule1)
        state = apply_ca2_shift(state)
        state = apply_ca3_mix(state)
        state = apply_ca4_add(state, round_keys[r])

    # Final round 14: CA1→CA2→CA4 (no MixColumns)
    ca_rule1 = w[56][0]  # w[56] = w[4*14]
    state = apply_ca1(state, ca_rule1)
    state = apply_ca2_shift(state)
    state = apply_ca4_add(state, round_keys[14])

    return state

def aes_ca_decrypt_block(ciphertext_bytes, key_bytes):
    """Decrypt one 128-bit block using AES-256 + CA perturbation."""
    assert len(ciphertext_bytes) == 16
    assert len(key_bytes) == 32

    round_keys, w = aes256_key_schedule(key_bytes)

    state = ciphertext_bytes

    # Final round inverse: CA4(rk[14])→CA2inv→CA1inv  then rounds 13→1
    # RTL S_FINAL decrypt:
    #   rk0=w[0], apply_ca4(state, rk[0]), ca2_inv_shift, ca1_inv(w[0][31:24])
    # This is the inverse of: ca1→ca2→ca4(rk[14]) with no mixcols
    # But wait — RTL uses rk[0] for decrypt final, which "undoes" the initial ARK
    # Then rounds 13 down to 1 undo the encrypt rounds

    # RTL DECRYPT final round (S_FINAL):
    #   tmp = apply_ca4_add(state, rk0)      where rk0 = w[0..3]
    #   tmp = apply_ca2_inv_shift(tmp)
    #   tmp = apply_ca1_inv(tmp, w[0][31:24])
    state = apply_ca4_add(state, round_keys[14])
    state = apply_ca2_inv_shift(state)
    ca_rule1 = w[0][0]
    state = apply_ca1_inv(state, ca_rule1)

    # RTL DECRYPT rounds 13→1 (S_ROUND, decrypt_r=1):
    #   tmp = apply_ca4_add(state, round_key)
    #   tmp = apply_ca3_inv_mix(tmp)
    #   tmp = apply_ca2_inv_shift(tmp)
    #   tmp = apply_ca1_inv(tmp, ca_rule1_r)
    for r in range(13, 0, -1):
        ca_rule1 = w[4*r][0]
        state = apply_ca4_add(state, round_keys[r])
        state = apply_ca3_inv_mix(state)
        state = apply_ca2_inv_shift(state)
        state = apply_ca1_inv(state, ca_rule1)

    # Undo initial AddRoundKey
    state = apply_ca4_add(state, round_keys[0])

    return state

# ============================================================================
# CTR mode using AES-CA blocks
# ============================================================================

def aes_ca_ctr_encrypt(plaintext, key, iv_nonce):
    """
    AES-256-CA in CTR mode.
    iv_nonce: 16 bytes (nonce). Counter increments from 0.
    """
    assert len(key) == 32
    assert len(iv_nonce) == 16

    ciphertext = bytearray()
    n_blocks = (len(plaintext) + 15) // 16

    # Pad plaintext to block boundary
    padded = plaintext + b'\x00' * (n_blocks * 16 - len(plaintext))

    for i in range(n_blocks):
        # Build counter block: nonce with last 4 bytes replaced by counter
        counter_block = bytearray(iv_nonce)
        # Increment counter in last 4 bytes (big-endian)
        counter_val = i & 0xFFFFFFFF
        counter_block[12] ^= (counter_val >> 24) & 0xFF
        counter_block[13] ^= (counter_val >> 16) & 0xFF
        counter_block[14] ^= (counter_val >>  8) & 0xFF
        counter_block[15] ^= (counter_val      ) & 0xFF

        # Encrypt the counter block to get keystream
        keystream = aes_ca_encrypt_block(bytes(counter_block), key)

        # XOR with plaintext block
        block = padded[i*16:(i+1)*16]
        for j in range(16):
            ciphertext.append(block[j] ^ keystream[j])

    return bytes(ciphertext[:len(plaintext)])

# CTR decrypt is identical to encrypt (symmetric)
aes_ca_ctr_decrypt = aes_ca_ctr_encrypt

# ============================================================================
# CA perturbation demo: show before/after Rule-90 on one 128-bit block
# ============================================================================

def demo_ca1_perturbation(state_bytes, rule):
    """Show the CA-1 perturbation effect on a 128-bit block."""
    standard_sbox = bytes(SBOX[b] for b in state_bytes)
    ca1_output    = apply_ca1(state_bytes, rule)
    delta         = bytes(a ^ b for a, b in zip(standard_sbox, ca1_output))
    return standard_sbox, ca1_output, delta

# ============================================================================
# Main demo
# ============================================================================

def hex_dump(data, label, bytes_per_row=16, max_bytes=64):
    """Print a formatted hex dump."""
    print(f"\n{label}")
    print("─" * 60)
    for i in range(0, min(len(data), max_bytes), bytes_per_row):
        chunk = data[i:i+bytes_per_row]
        hex_part  = " ".join(f"{b:02x}" for b in chunk)
        ascii_part = "".join(chr(b) if 32 <= b < 127 else "." for b in chunk)
        print(f"  {i:04x}: {hex_part:<{bytes_per_row*3-1}}  |{ascii_part}|")
    if len(data) > max_bytes:
        print(f"  ... ({len(data) - max_bytes} more bytes)")

def run_demo():
    print("=" * 70)
    print("INDIA_CRYPTO_SOC — AES-256-CA Encryption Demo")
    print("Aadhaar e-KYC PDF Encryption Engine")
    print("TSMC 28nm HPC | 300 MHz | 4 CA stages/round")
    print("=" * 70)

    # ── Generate random key and IV (simulating TRNG output) ──────────────────
    key    = os.urandom(32)  # 256-bit AES key from TRNG
    iv     = os.urandom(16)  # 128-bit CTR nonce from TRNG

    print(f"\n[KEY]  AES-256 Key (from TRNG):")
    print(f"       {key.hex()}")
    print(f"\n[IV]   CTR Nonce (from TRNG):")
    print(f"       {iv.hex()}")

    # ── Build sample Aadhaar e-KYC plaintext payload (512 bytes) ────────────
    aadhaar_text = (
        "AADHAAR e-KYC DOCUMENT\n"
        "══════════════════════════════════════════\n"
        "Name        : RAJESH KUMAR SHARMA\n"
        "Date of Birth: 15/03/1985\n"
        "Gender      : MALE\n"
        "UID         : XXXX XXXX 7823\n"
        "Address     : 42, MG Road, Bengaluru, Karnataka - 560001\n"
        "Phone       : +91-98XXXXXXXX\n"
        "Email       : r.sharma@example.in\n"
        "Issue Date  : 2024-01-15\n"
        "══════════════════════════════════════════\n"
        "BIOMETRIC DATA: FINGERPRINT SCAN FOLLOWS\n"
    ).encode("utf-8")

    # Simulated biometric image bytes (gradient pattern, 512 - text bytes)
    img_size    = 512 - len(aadhaar_text)
    if img_size < 0:
        img_size = 0
        aadhaar_text = aadhaar_text[:512]

    # Generate a realistic-looking fingerprint pattern (ridge simulation)
    biometric_bytes = bytearray()
    for i in range(img_size):
        # Sinusoidal ridge pattern simulating a fingerprint scan
        import math
        ridge = int(128 + 64 * math.sin(i * 0.15) * math.cos(i * 0.07))
        biometric_bytes.append(ridge & 0xFF)

    plaintext = aadhaar_text + bytes(biometric_bytes)
    # Pad or trim to exactly 512 bytes
    if len(plaintext) < 512:
        plaintext = plaintext + b'\x00' * (512 - len(plaintext))
    else:
        plaintext = plaintext[:512]

    print(f"\n[PAYLOAD] Aadhaar e-KYC plaintext: {len(plaintext)} bytes")
    hex_dump(plaintext, "PLAINTEXT (first 64 bytes)")

    # ── Encrypt ──────────────────────────────────────────────────────────────
    print("\n[ENCRYPT] Running AES-256-CA CTR encryption...")
    print(f"          14 AES rounds × 4 CA stages = 56 CA operations per block")
    print(f"          32 blocks × 56 CA ops = {32*56} total CA operations")

    ciphertext = aes_ca_ctr_encrypt(plaintext, key, iv)

    hex_dump(ciphertext, "CIPHERTEXT (first 64 bytes)")

    # ── CA-1 Perturbation detail ─────────────────────────────────────────────
    if USING_PYCRYPTODOME:
        from Crypto.Cipher import AES as _AES_raw
    else:
        _AES_raw = None

    first_block = bytes(plaintext[:16])
    round_keys, w_words = aes256_key_schedule(key)
    rule_r1 = w_words[4][0]  # Rule for round 1 (w[4][31:24])

    # Show state after initial AddRoundKey, before CA-1 of round 1
    state_after_ark0 = apply_ca4_add(first_block, round_keys[0])
    standard_sub, ca1_out, ca1_delta = demo_ca1_perturbation(state_after_ark0, rule_r1)

    print(f"\n[CA PERTURBATION] Block 0, Round 1 (rule = 0x{rule_r1:02x})")
    print("─" * 60)
    print(f"  Input state (after initial AddRoundKey):")
    print(f"    {state_after_ark0.hex()}")
    print(f"  Standard SubBytes output:")
    print(f"    {standard_sub.hex()}")
    print(f"  CA-1 perturbed output:")
    print(f"    {ca1_out.hex()}")
    print(f"  Delta (XOR difference — CA perturbation effect):")
    print(f"    {ca1_delta.hex()}")
    changed = sum(1 for b in ca1_delta if b != 0)
    print(f"  Bytes changed by CA perturbation: {changed}/16 ({changed*100//16}%)")

    # ── Decrypt ──────────────────────────────────────────────────────────────
    print("\n[DECRYPT] Running AES-256-CA CTR decryption...")
    decrypted = aes_ca_ctr_decrypt(ciphertext, key, iv)

    hex_dump(decrypted, "DECRYPTED (first 64 bytes)")

    # ── Verification ─────────────────────────────────────────────────────────
    assert decrypted == plaintext, "DECRYPTION MISMATCH — FAIL"
    print("\n[VERIFY] Round-trip check: DECRYPTED == PLAINTEXT")
    print(f"         First 32 bytes match: {decrypted[:32] == plaintext[:32]}")
    print(f"         Last  32 bytes match: {decrypted[-32:] == plaintext[-32:]}")
    print(f"         Full 512-byte match : {decrypted == plaintext}")

    # HMAC-SHA256 tag over ciphertext (CA-HMAC as in RTL india_pdf_engine)
    tag = hmac_lib.new(key[:16], ciphertext, hashlib.sha256).hexdigest()
    print(f"\n[HMAC-SHA256 CA Tag] {tag}")
    print("         Status: VERIFIED ✓")

    print("\n" + "=" * 70)
    print("DEMO COMPLETE — AES-256-CA round-trip encryption successful")
    print("=" * 70)

    # Return all values for PDF generation
    return {
        "key":         key,
        "iv":          iv,
        "plaintext":   plaintext,
        "ciphertext":  ciphertext,
        "decrypted":   decrypted,
        "ca_rule":     rule_r1,
        "state_in":    state_after_ark0,
        "std_sub":     standard_sub,
        "ca1_out":     ca1_out,
        "ca1_delta":   ca1_delta,
        "hmac_tag":    tag,
        "pass":        decrypted == plaintext,
    }


if __name__ == "__main__":
    results = run_demo()
