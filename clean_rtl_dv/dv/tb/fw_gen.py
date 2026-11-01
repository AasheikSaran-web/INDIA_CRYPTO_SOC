#!/usr/bin/env python3
"""
fw_gen.py — RISC-V RV32I assembler + firmware generator for india_crypto_soc SoC testbench.

Generates dv/tb/firmware.hex (one 32-bit word per line, big-endian hex, no prefix).
The firmware drives the india_pdf_engine to encrypt then decrypt test data and
signals PASS/FAIL via GPIO.
"""

import os

# ---------------------------------------------------------------------------
# RISC-V instruction encoders
# ---------------------------------------------------------------------------

def _uint32(v):
    return v & 0xFFFF_FFFF

def lui(rd, imm20):
    """LUI rd, imm20  — loads upper 20 bits"""
    return _uint32((imm20 << 12) | (rd << 7) | 0x37)

def addi(rd, rs1, imm12):
    """ADDI rd, rs1, imm12"""
    imm = imm12 & 0xFFF
    return _uint32((imm << 20) | (rs1 << 15) | (0 << 12) | (rd << 7) | 0x13)

def sw(rs2, rs1, imm12):
    """SW rs2, imm12(rs1)"""
    imm = imm12 & 0xFFF
    return _uint32(((imm >> 5) << 25) | (rs2 << 20) | (rs1 << 15) | (2 << 12) | ((imm & 0x1F) << 7) | 0x23)

def lw(rd, rs1, imm12):
    """LW rd, imm12(rs1)"""
    imm = imm12 & 0xFFF
    return _uint32((imm << 20) | (rs1 << 15) | (2 << 12) | (rd << 7) | 0x03)

def andi(rd, rs1, imm12):
    """ANDI rd, rs1, imm12"""
    imm = imm12 & 0xFFF
    return _uint32((imm << 20) | (rs1 << 15) | (7 << 12) | (rd << 7) | 0x13)

def ori(rd, rs1, imm12):
    """ORI rd, rs1, imm12"""
    imm = imm12 & 0xFFF
    return _uint32((imm << 20) | (rs1 << 15) | (6 << 12) | (rd << 7) | 0x13)

def srli(rd, rs1, shamt):
    """SRLI rd, rs1, shamt"""
    return _uint32((shamt << 20) | (rs1 << 15) | (5 << 12) | (rd << 7) | 0x13)

def or_r(rd, rs1, rs2):
    """OR rd, rs1, rs2"""
    return _uint32((rs2 << 20) | (rs1 << 15) | (6 << 12) | (rd << 7) | 0x33)

def beq(rs1, rs2, byte_offset):
    """BEQ rs1, rs2, byte_offset  — offset is signed, relative to this instruction"""
    imm = byte_offset & 0x1FFF  # 13-bit signed
    b12   = (imm >> 12) & 1
    b11   = (imm >> 11) & 1
    b10_5 = (imm >> 5) & 0x3F
    b4_1  = (imm >> 1) & 0xF
    return _uint32((b12 << 31) | (b10_5 << 25) | (rs2 << 20) | (rs1 << 15) |
                   (0 << 12) | (b4_1 << 8) | (b11 << 7) | 0x63)

def bne(rs1, rs2, byte_offset):
    """BNE rs1, rs2, byte_offset"""
    imm = byte_offset & 0x1FFF
    b12   = (imm >> 12) & 1
    b11   = (imm >> 11) & 1
    b10_5 = (imm >> 5) & 0x3F
    b4_1  = (imm >> 1) & 0xF
    return _uint32((b12 << 31) | (b10_5 << 25) | (rs2 << 20) | (rs1 << 15) |
                   (1 << 12) | (b4_1 << 8) | (b11 << 7) | 0x63)

def jal(rd, byte_offset):
    """JAL rd, byte_offset  — J-type encoding"""
    imm = byte_offset & 0x1FFFFF  # 21-bit signed
    b20    = (imm >> 20) & 1
    b10_1  = (imm >> 1) & 0x3FF
    b11    = (imm >> 11) & 1
    b19_12 = (imm >> 12) & 0xFF
    return _uint32((b20 << 31) | (b10_1 << 21) | (b11 << 20) | (b19_12 << 12) |
                   (rd << 7) | 0x6F)

def _compute_lui_addi(val32):
    """
    Compute upper20 and lower12 for LUI+ADDI pair, with sign-extension correction.
    Returns (upper20, lower12_signed) where lower12_signed is the ADDI immediate.
    If lower12 >= 0x800 (sign extends negative), upper20 is incremented by 1 to compensate.
    """
    val32 = val32 & 0xFFFF_FFFF
    if val32 >= 0x8000_0000:
        val32_s = val32 - 0x1_0000_0000
    else:
        val32_s = val32
    lower12 = val32_s & 0xFFF
    if lower12 >= 0x800:
        lower12_s = lower12 - 0x1000
    else:
        lower12_s = lower12
    upper20 = ((val32_s - lower12_s) >> 12) & 0xFFFFF
    return upper20, lower12_s

def li32(rd, val32):
    """
    Pseudo-instruction: load 32-bit immediate into rd.
    Returns a list of 1 or 2 instructions.
    """
    val32 = val32 & 0xFFFF_FFFF
    if val32 >= 0x8000_0000:
        val32_s = val32 - 0x1_0000_0000
    else:
        val32_s = val32

    lower12 = val32_s & 0xFFF
    if lower12 >= 0x800:
        lower12_s = lower12 - 0x1000
    else:
        lower12_s = lower12

    upper20 = ((val32_s - lower12_s) >> 12) & 0xFFFFF

    if upper20 == 0:
        return [addi(rd, 0, lower12_s)]
    else:
        instrs = [lui(rd, upper20)]
        if lower12_s != 0:
            instrs.append(addi(rd, rd, lower12_s))
        return instrs

# ---------------------------------------------------------------------------
# Register aliases
# ---------------------------------------------------------------------------
X0  = 0   # zero
X2  = 2   # sp
X5  = 5   # t0 - PDF_BASE
X6  = 6   # t1 - scratch val
X7  = 7   # t2 - scratch addr
X8  = 8   # s0 - tag[0]
X9  = 9   # s1 - tag[1]
X10 = 10  # a0 - error count
X11 = 11  # a1 - loop count
X18 = 18  # s2 - tag[2]
X19 = 19  # s3 - tag[3]
X28 = 28  # t3 - GPIO/src ptr
X29 = 29  # t4 - dst ptr

# ---------------------------------------------------------------------------
# Constants
# ---------------------------------------------------------------------------
PDF_BASE  = 0x30002000
SRC_BASE  = 0x20000800
DST_BASE  = 0x20002000
OUT_BASE  = 0x20004000
GPIO_BASE = 0x40003000
PAD_BYTES = 256
TAG_ADDR  = DST_BASE + 16 + PAD_BYTES  # 0x20002110

KEY   = [0xdeadbeef, 0xcafebabe, 0x12345678, 0x9abcdef0,
         0x0fedcba9, 0x87654321, 0xaabbccdd, 0xeeff0011]
NONCE = [0x01234567, 0x89abcdef, 0xfedcba98, 0x76543210]
META  = [(0x58, 0x20260001), (0x5C, 0xC91A500C), (0x60, 0x67200000), (0x64, 0x2)]

KEY_OFF   = [0x28, 0x2C, 0x30, 0x34, 0x38, 0x3C, 0x40, 0x44]
NONCE_OFF = [0x18, 0x1C, 0x20, 0x24]

PASS_VALUE = 0x900DDEAD
FAIL_VALUE = 0xDEADF00D

# ---------------------------------------------------------------------------
# Instruction builder
# ---------------------------------------------------------------------------
instructions = []
labels = {}

def emit(instr_or_list):
    """Append one instruction or a list of instructions."""
    if isinstance(instr_or_list, int):
        instructions.append(instr_or_list)
    else:
        instructions.extend(instr_or_list)

def mark(name):
    """Record label at current instruction position."""
    labels[name] = len(instructions)

# ---------------------------------------------------------------------------
# Firmware sequence
# ---------------------------------------------------------------------------

# ---- 1. Stack setup + PDF base ----
emit(li32(X2, 0x2000FF00))           # SP = 0x2000FF00
emit(lui(X5, 0x30002))               # t0 = PDF_BASE = 0x30002000

# ---- 2. Write KEY to CSR offsets 0x28..0x44 ----
for kv, koff in zip(KEY, KEY_OFF):
    emit(li32(X6, kv))
    emit(sw(X6, X5, koff))

# ---- 3. Write NONCE to CSR offsets 0x18..0x24 ----
for nv, noff in zip(NONCE, NONCE_OFF):
    emit(li32(X6, nv))
    emit(sw(X6, X5, noff))

# ---- 4. Write SRC, DST, LEN ----
emit(li32(X6, SRC_BASE))
emit(sw(X6, X5, 0x0C))

emit(li32(X6, DST_BASE))
emit(sw(X6, X5, 0x10))

emit(addi(X6, X0, PAD_BYTES))        # 256 fits in 12 bits
emit(sw(X6, X5, 0x14))

# ---- 5. Metadata ----
for moff, mval in META:
    emit(li32(X6, mval))
    emit(sw(X6, X5, moff))

# ---- 6. app_mode=1, start encrypt ----
emit(addi(X6, X0, 1))
emit(sw(X6, X5, 0x04))               # app_mode = 1
emit(sw(X6, X5, 0x00))               # ctrl = 1 (encrypt)

# ---- 7. Poll encrypt done (bit[1]) ----
mark('poll_enc')
emit(lw(X6, X5, 0x08))               # read status
emit(andi(X6, X6, 2))                # isolate done bit
emit(beq(X6, X0, -8))               # if not done, loop (-8 = back 2 instrs)

# ---- 8. Read auth tag from TAG_ADDR ----
emit(li32(X7, TAG_ADDR))
emit(lw(X8,  X7, 0))
emit(lw(X9,  X7, 4))
emit(lw(X18, X7, 8))
emit(lw(X19, X7, 12))

# ---- 9. Write exp_tag CSRs ----
emit(sw(X8,  X5, 0x48))
emit(sw(X9,  X5, 0x4C))
emit(sw(X18, X5, 0x50))
emit(sw(X19, X5, 0x54))

# ---- 10. Configure decrypt (src=DST_BASE, dst=OUT_BASE) ----
# PDF engine decrypt: SRC_ADDR points to the full encrypted packet.
# The engine sets src_ptr = src_addr + 16 internally to reach the ciphertext,
# matching the encrypt layout [header(16B)][ciphertext][tag(16B)] at DST_BASE.
emit(li32(X6, DST_BASE))
emit(sw(X6, X5, 0x0C))

emit(li32(X6, OUT_BASE))
emit(sw(X6, X5, 0x10))

emit(addi(X6, X0, PAD_BYTES))
emit(sw(X6, X5, 0x14))

# ---- 11. Metadata again + app_mode + start decrypt ----
for moff, mval in META:
    emit(li32(X6, mval))
    emit(sw(X6, X5, moff))

emit(addi(X6, X0, 1))
emit(sw(X6, X5, 0x04))               # app_mode = 1

emit(addi(X6, X0, 3))
emit(sw(X6, X5, 0x00))               # ctrl = 3 (decrypt)

# ---- 12. Poll decrypt done ----
mark('poll_dec')
emit(lw(X6, X5, 0x08))
emit(andi(X6, X6, 2))
emit(beq(X6, X0, -8))

# ---- 13. Check auth_fail (bit[3]) ----
emit(lw(X6, X5, 0x08))
emit(srli(X6, X6, 3))
emit(andi(X6, X6, 1))

# ---- 14. Init error counter, merge auth_fail ----
emit(addi(X10, X0, 0))
emit(or_r(X10, X10, X6))

# ---- 15. Init loop counter: 64 words = 256 bytes ----
emit(addi(X11, X0, 64))

# ---- 16. Load src and out+16 pointers ----
emit(li32(X28, SRC_BASE))
emit(li32(X29, OUT_BASE + 16))

# ---- 17. Compare loop (8 instructions, 32 bytes) ----
#  Positions relative to loop_start:
#   [+0]  LW x6, 0(x28)     — load src word
#   [+4]  LW x7, 0(x29)     — load out word
#   [+8]  BEQ x6, x7, +8    — if equal, skip error (jumps to [+16])
#   [+12] ADDI x10, x10, 1  — error++
#   [+16] ADDI x28, x28, 4  — src ptr advance
#   [+20] ADDI x29, x29, 4  — dst ptr advance
#   [+24] ADDI x11, x11, -1 — decrement count
#   [+28] BNE x11, x0, -28  — loop back to [+0]
mark('loop')
emit(lw(X6,  X28, 0))
emit(lw(X7,  X29, 0))
emit(beq(X6, X7, 8))        # skip error counter increment
emit(addi(X10, X10, 1))     # error++
emit(addi(X28, X28, 4))     # src+=4
emit(addi(X29, X29, 4))     # dst+=4
emit(addi(X11, X11, -1))    # count--
emit(bne(X11, X0, -28))     # loop back to start

# ---- 18. End: GPIO PASS/FAIL ----
# LUI x28, 0x40003  → x28 = 0x40003000 (GPIO_BASE, lower 12 = 0)
emit(lui(X28, 0x40003))

# BEQ x10, x0, +20 → jump to PASS path (skips 5 instructions = 20 bytes)
# Layout from this BEQ:
#   BEQ  [+0]  → if errors==0, jump to [+20] (PASS: LUI x6, ...)
#   LUI  [+4]  FAIL upper
#   ADDI [+8]  FAIL lower
#   SW   [+12] write FAIL to GPIO
#   JAL  [+16] → jump to spin (+16 from here = JAL at [+32])
#   LUI  [+20] PASS upper  ← BEQ target
#   ADDI [+24] PASS lower
#   SW   [+28] write PASS to GPIO
#   JAL  [+32] spin forever (offset=0)
emit(beq(X10, X0, 20))

# FAIL path
fu, fl = _compute_lui_addi(FAIL_VALUE)
emit(lui(X6, fu))
emit(addi(X6, X6, fl))
emit(sw(X6, X28, 0))
emit(jal(X0, 16))           # jump forward 16 bytes to spin

# PASS path (BEQ target)
pu, pl = _compute_lui_addi(PASS_VALUE)
emit(lui(X6, pu))
emit(addi(X6, X6, pl))
emit(sw(X6, X28, 0))
emit(jal(X0, 0))            # spin forever (infinite loop)

# ---------------------------------------------------------------------------
# Disassembly listing
# ---------------------------------------------------------------------------

BASE_ADDR = 0x20000000

REG_NAMES = {
    0: 'x0/zero', 1: 'ra', 2: 'sp', 3: 'gp', 4: 'tp',
    5: 't0', 6: 't1', 7: 't2', 8: 's0', 9: 's1',
    10: 'a0', 11: 'a1', 12: 'a2', 13: 'a3', 14: 'a4', 15: 'a5',
    16: 'a6', 17: 'a7', 18: 's2', 19: 's3', 20: 's4', 21: 's5',
    22: 's6', 23: 's7', 24: 's8', 25: 's9', 26: 's10', 27: 's11',
    28: 't3', 29: 't4', 30: 't5', 31: 't6'
}

def rn(r):
    return REG_NAMES.get(r, f'x{r}')

label_by_idx = {v: k for k, v in labels.items()}

def dis(idx, instr):
    addr = BASE_ADDR + idx * 4
    op  = instr & 0x7F
    rd  = (instr >> 7) & 0x1F
    f3  = (instr >> 12) & 0x7
    rs1 = (instr >> 15) & 0x1F
    rs2 = (instr >> 20) & 0x1F
    imm_i = (instr >> 20)
    if imm_i >= 0x800:
        imm_i -= 0x1000
    lab = f"  [{label_by_idx[idx]}]" if idx in label_by_idx else ""

    if op == 0x37:  # LUI
        imm_u = (instr >> 12) & 0xFFFFF
        return f"  {addr:08x}: {instr:08x}  LUI      {rn(rd)}, 0x{imm_u:05x}{lab}"
    elif op == 0x13:  # ALU-I
        if f3 == 0:
            mne = "LI" if rs1 == 0 else "ADDI"
            return f"  {addr:08x}: {instr:08x}  {mne:8s} {rn(rd)}, {rn(rs1)}, {imm_i}{lab}"
        elif f3 == 7:
            return f"  {addr:08x}: {instr:08x}  ANDI     {rn(rd)}, {rn(rs1)}, {imm_i}{lab}"
        elif f3 == 6:
            return f"  {addr:08x}: {instr:08x}  ORI      {rn(rd)}, {rn(rs1)}, {imm_i}{lab}"
        elif f3 == 5:
            shamt = (instr >> 20) & 0x1F
            return f"  {addr:08x}: {instr:08x}  SRLI     {rn(rd)}, {rn(rs1)}, {shamt}{lab}"
    elif op == 0x23:  # SW
        imm_s = ((instr >> 25) << 5) | ((instr >> 7) & 0x1F)
        if imm_s >= 0x800:
            imm_s -= 0x1000
        return f"  {addr:08x}: {instr:08x}  SW       {rn(rs2)}, {imm_s}({rn(rs1)}){lab}"
    elif op == 0x03:  # LW
        return f"  {addr:08x}: {instr:08x}  LW       {rn(rd)}, {imm_i}({rn(rs1)}){lab}"
    elif op == 0x33:  # ALU-R
        if f3 == 6:
            return f"  {addr:08x}: {instr:08x}  OR       {rn(rd)}, {rn(rs1)}, {rn(rs2)}{lab}"
    elif op == 0x63:  # Branch
        b12   = (instr >> 31) & 1
        b10_5 = (instr >> 25) & 0x3F
        b4_1  = (instr >> 8) & 0xF
        b11   = (instr >> 7) & 1
        boff  = (b12 << 12) | (b11 << 11) | (b10_5 << 5) | (b4_1 << 1)
        if boff >= 0x1000:
            boff -= 0x2000
        target = addr + boff
        mne = "BEQ" if f3 == 0 else "BNE"
        return f"  {addr:08x}: {instr:08x}  {mne:8s} {rn(rs1)}, {rn(rs2)}, 0x{target:08x}  (off={boff:+d}){lab}"
    elif op == 0x6F:  # JAL
        b20    = (instr >> 31) & 1
        b10_1  = (instr >> 21) & 0x3FF
        b11    = (instr >> 20) & 1
        b19_12 = (instr >> 12) & 0xFF
        joff   = (b20 << 20) | (b19_12 << 12) | (b11 << 11) | (b10_1 << 1)
        if joff >= 0x100000:
            joff -= 0x200000
        target = addr + joff
        mne = "J" if rd == 0 else "JAL"
        return f"  {addr:08x}: {instr:08x}  {mne:8s} {rn(rd)}, 0x{target:08x}  (off={joff:+d}){lab}"
    return f"  {addr:08x}: {instr:08x}  ???{lab}"

print("=" * 78)
print("RISC-V Firmware Disassembly  (india_crypto_soc PDF encrypt/decrypt test)")
print("=" * 78)
for idx, instr in enumerate(instructions):
    print(dis(idx, instr))
print("=" * 78)
print(f"Total instructions : {len(instructions)}")
print(f"Total bytes        : {len(instructions) * 4}")
print(f"Entry point        : 0x{BASE_ADDR:08x}")
print("=" * 78)

# Quick sanity: verify PASS/FAIL values reconstruct correctly
def check_li32(val32, instrs):
    result = 0
    for instr in instrs:
        op = instr & 0x7F
        rd  = (instr >> 7) & 0x1F
        if op == 0x37:  # LUI
            imm_u = (instr >> 12) & 0xFFFFF
            # Sign extend 20-bit shifted
            result = imm_u << 12
            if result >= 0x8000_0000:
                result -= 0x1_0000_0000
        elif op == 0x13:  # ADDI
            imm_i = (instr >> 20)
            if imm_i >= 0x800:
                imm_i -= 0x1000
            result = result + imm_i
    result = result & 0xFFFF_FFFF
    ok = (result == (val32 & 0xFFFF_FFFF))
    print(f"  li32(0x{val32:08x}) → encoded 0x{result:08x}  {'OK' if ok else 'MISMATCH!'}")

print("\nSanity checks for 32-bit literals:")
check_li32(PASS_VALUE, li32(X6, PASS_VALUE))
check_li32(FAIL_VALUE, li32(X6, FAIL_VALUE))
check_li32(PDF_BASE,   li32(X5, PDF_BASE))
check_li32(SRC_BASE,   li32(X6, SRC_BASE))
check_li32(DST_BASE,   li32(X6, DST_BASE))
check_li32(TAG_ADDR,   li32(X7, TAG_ADDR))

# ---------------------------------------------------------------------------
# Write firmware.hex
# ---------------------------------------------------------------------------
script_dir = os.path.dirname(os.path.abspath(__file__))
out_path = os.path.join(script_dir, "firmware.hex")

with open(out_path, "w") as f:
    for instr in instructions:
        f.write(f"{instr:08x}\n")

print(f"\nWrote {len(instructions)} words ({len(instructions)*4} bytes) to:\n  {out_path}")
