#!/usr/bin/env python3
"""
fw_gen_image.py — Full SoC image encrypt/decrypt firmware for INDIA_CRYPTO_SOC.

Flow:
  1.  Validate Aadhaar "2000 5555 5554" with AADHAAR.CHECK custom instruction
  2.  Program PDF engine with fixed AES-256-CTR key + nonce
  3.  Set src_addr=0x20000400 (64-byte JPEG slice), enc_dst=0x20000800, len=64
  4.  Start encryption (CTRL = 0x01), poll STATUS bit[1] (done)
  5.  Read result_tag (0x68-0x74) → write to exp_tag (0x48-0x54)
  6.  Reconfigure dec_src=0x20000800 (full packet; engine skips 16B header internally), dec_dst=0x20001000
  7.  Start decryption (CTRL = 0x03 → decrypt_mode=1, start=1), poll done
  8.  Check STATUS bit[2] (auth_ok) → fail if not set
  9.  Compare 16 decrypted words against original at SRC_ADDR
 10.  Write PASS (0x900DDEAD) or FAIL (0xDEADF00D) to GPIO (0x40003000)

Memory layout:
  0x20000000  Firmware (this image)
  0x20000400  Image SRC — 64 bytes = 16 words (aadhar_slice.hex)
  0x20000800  Encrypted DST — 96 bytes (16B header + 64B cipher + 16B tag)
  0x20001000  Decrypted DST — 96 bytes (16B header + 64B decrypted)
  0x20001010  Decrypted DATA (first byte of recovered plaintext)

AES-256 key (deterministic, all-small to save instruction space):
  key[255:224] = 0x00000001 … key[31:0] = 0x00000008

Nonce (deterministic):
  nonce[127:96] = 0x00000001 … nonce[31:0] = 0x00000004

Custom AADHAAR.CHECK instruction:
  funct7=0x7F, rs2=x6, rs1=x5, funct3=0x7, rd=x7, opcode=0x0B
  Encoding: 0xFE62F38B
"""

import os

# ---------------------------------------------------------------------------
# Instruction encoders (identical set used in fw_gen_aadhaar.py)
# ---------------------------------------------------------------------------
def _uint32(v):
    return v & 0xFFFF_FFFF

def lui(rd, imm20):
    return _uint32((imm20 << 12) | (rd << 7) | 0x37)

def addi(rd, rs1, imm12):
    imm = imm12 & 0xFFF
    return _uint32((imm << 20) | (rs1 << 15) | (0 << 12) | (rd << 7) | 0x13)

def lw(rd, rs1, imm12):
    imm = imm12 & 0xFFF
    return _uint32((imm << 20) | (rs1 << 15) | (2 << 12) | (rd << 7) | 0x03)

def sw(rs2, rs1, imm12):
    imm = imm12 & 0xFFF
    return _uint32(((imm >> 5) << 25) | (rs2 << 20) | (rs1 << 15) |
                   (2 << 12) | ((imm & 0x1F) << 7) | 0x23)

def andi(rd, rs1, imm12):
    imm = imm12 & 0xFFF
    return _uint32((imm << 20) | (rs1 << 15) | (7 << 12) | (rd << 7) | 0x13)

def beq(rs1, rs2, byte_offset):
    imm   = byte_offset & 0x1FFF
    b12   = (imm >> 12) & 1
    b11   = (imm >> 11) & 1
    b10_5 = (imm >> 5) & 0x3F
    b4_1  = (imm >> 1) & 0xF
    return _uint32((b12 << 31) | (b10_5 << 25) | (rs2 << 20) | (rs1 << 15) |
                   (0 << 12) | (b4_1 << 8) | (b11 << 7) | 0x63)

def bne(rs1, rs2, byte_offset):
    imm   = byte_offset & 0x1FFF
    b12   = (imm >> 12) & 1
    b11   = (imm >> 11) & 1
    b10_5 = (imm >> 5) & 0x3F
    b4_1  = (imm >> 1) & 0xF
    return _uint32((b12 << 31) | (b10_5 << 25) | (rs2 << 20) | (rs1 << 15) |
                   (1 << 12) | (b4_1 << 8) | (b11 << 7) | 0x63)

def jal(rd, byte_offset):
    imm    = byte_offset & 0x1FFFFF
    b20    = (imm >> 20) & 1
    b10_1  = (imm >> 1) & 0x3FF
    b11    = (imm >> 11) & 1
    b19_12 = (imm >> 12) & 0xFF
    return _uint32((b20 << 31) | (b10_1 << 21) | (b11 << 20) | (b19_12 << 12) |
                   (rd << 7) | 0x6F)

def li32(rd, val32):
    val32 = val32 & 0xFFFF_FFFF
    val32_s = val32 - 0x1_0000_0000 if val32 >= 0x8000_0000 else val32
    lower12 = val32_s & 0xFFF
    lower12_s = lower12 - 0x1000 if lower12 >= 0x800 else lower12
    upper20 = ((val32_s - lower12_s) >> 12) & 0xFFFFF
    if upper20 == 0:
        return [addi(rd, 0, lower12_s)]
    instrs = [lui(rd, upper20)]
    if lower12_s != 0:
        instrs.append(addi(rd, rd, lower12_s))
    return instrs

# ---------------------------------------------------------------------------
# Register aliases
# ---------------------------------------------------------------------------
X0  = 0   # zero
X5  = 5   # t0 — Aadhaar digits 0-7
X6  = 6   # t1 — Aadhaar digits 8-11
X7  = 7   # t2 — AADHAAR.CHECK result / PASS/FAIL value
X8  = 8   # s0 — PDF engine base address (0x30002000)
X9  = 9   # s1 — scratch
X10 = 10  # a0 — poll scratch
X11 = 11  # a1 — tag word 0
X12 = 12  # a2 — tag word 1
X13 = 13  # a3 — tag word 2
X14 = 14  # a4 — tag word 3
X15 = 15  # a5 — auth status
X20 = 20  # s4 — src pointer (compare)
X21 = 21  # s5 — dec pointer (compare)
X22 = 22  # s6 — loop counter
X23 = 23  # s7 — original word
X24 = 24  # s8 — decrypted word
X28 = 28  # t3 — comparison constant
X29 = 29  # t4 — GPIO base

# ---------------------------------------------------------------------------
# Constants
# ---------------------------------------------------------------------------
AADHAAR_D0_7        = 0x55555554    # digits 0-7 packed BCD
AADHAAR_D8_11       = 0x00002000    # digits 8-11 packed BCD
AADHAAR_CHECK_INSTR = 0xFE62F38B    # funct7=0x7F,rs2=x6,rs1=x5,funct3=7,rd=x7,op=0x0B

PASS_VAL  = 0x900D_DEAD
FAIL_VAL  = 0xDEAD_F00D
GPIO_BASE = 0x40003000

PDF_BASE  = 0x30002000

# SRAM memory addresses
SRC_ADDR  = 0x20000400   # original 64-byte JPEG slice (loaded by testbench)
ENC_DST   = 0x20000800   # encrypted output: 16B hdr + 64B cipher + 16B tag
DEC_SRC   = 0x20000800   # ENC_DST (full packet start; engine skips 16B header internally)
DEC_DST   = 0x20001000   # decrypt destination
DEC_DATA  = 0x20001010   # DEC_DST + 16 (actual decrypted payload)

PDF_LEN   = 64           # 16 words

# AES-256 key (deterministic; small values → single ADDI instruction each)
KEY_WORDS    = [1, 2, 3, 4, 5, 6, 7, 8]   # key[255:224..31:0] at offsets 0x28..0x44
KEY_OFFSETS  = [0x28, 0x2C, 0x30, 0x34, 0x38, 0x3C, 0x40, 0x44]

# Nonce (deterministic)
NONCE_WORDS   = [1, 2, 3, 4]              # nonce[127:96..31:0] at offsets 0x18..0x24
NONCE_OFFSETS = [0x18, 0x1C, 0x20, 0x24]

# PDF CSR offsets
PDF_CTRL   = 0x00
PDF_STATUS = 0x08
PDF_SRC    = 0x0C
PDF_DST    = 0x10
PDF_LEN_O  = 0x14
# result_tag CSR read offsets (0x68-0x74) can return zero due to crossbar
# combinational mux timing; instead read the tag from SRAM where it was
# written by S_WAIT_TAG at ENC_DST + 16 + PDF_LEN = 0x20000800+80 = 0x20000850
TAG_SRAM_BASE     = ENC_DST + 16 + PDF_LEN   # = 0x20000850
TAG_SRAM_OFFSETS  = [0, 4, 8, 12]            # word-0..3 relative to TAG_SRAM_BASE
PDF_EXP0   = [0x48, 0x4C, 0x50, 0x54]        # exp_tag write offsets in PDF engine

# ---------------------------------------------------------------------------
# Build firmware
# ---------------------------------------------------------------------------
instrs = []

# ── Phase 0: Aadhaar validation ────────────────────────────────────────────
instrs += li32(X5, AADHAAR_D0_7)        # [0-1]  LUI+ADDI x5 = 0x55555554
instrs += li32(X6, AADHAAR_D8_11)       # [2]    LUI x6, 2
instrs.append(AADHAAR_CHECK_INSTR)      # [3]    AADHAAR.CHECK x7, x5, x6
instrs.append(andi(X7, X7, 1))          # [4]    ANDI x7, x7, 1
instrs.append(addi(X28, X0, 1))         # [5]    ADDI x28, x0, 1

# Forward BEQ to PDF_SETUP: distance = (12 - 6) * 4 = 24
beq_aadhaar_idx = len(instrs)           #  = 6
instrs.append(beq(X7, X28, 24))         # [6]    BEQ x7, x28, +24 → [12]

# ── Phase 1: FAIL path (Aadhaar invalid) ───────────────────────────────────
instrs += li32(X7, FAIL_VAL)            # [7-8]  LUI+ADDI x7 = 0xDEADF00D
instrs += li32(X29, GPIO_BASE)          # [9]    LUI x29, 0x40003
instrs.append(sw(X7, X29, 0))           # [10]   SW x7, 0(x29)
instrs.append(jal(X0, 0))              # [11]   JAL x0, 0 (infinite loop)

# ── Phase 2: PDF engine configuration ──────────────────────────────────────
pdf_setup_idx = len(instrs)             #  = 12 (BEQ[6] target)
assert pdf_setup_idx == 12, f"BEQ target mismatch: expected 12, got {pdf_setup_idx}"

instrs += li32(X8, PDF_BASE)            # [12]   LUI x8, 0x30002 (PDF base)

# Write AES-256 key (8 × ADDI+SW = 16 instrs, key words 1..8 → single ADDI each)
for kw, koff in zip(KEY_WORDS, KEY_OFFSETS):
    instrs.append(addi(X9, X0, kw))     # ADDI x9, x0, N
    instrs.append(sw(X9, X8, koff))     # SW x9, offset(x8)

# Write nonce (4 × ADDI+SW = 8 instrs)
for nw, noff in zip(NONCE_WORDS, NONCE_OFFSETS):
    instrs.append(addi(X9, X0, nw))
    instrs.append(sw(X9, X8, noff))

# Write src_addr, enc_dst, pdf_len
instrs += li32(X9, SRC_ADDR)            # LUI x9, 0x20000; ADDI x9, x9, 0x400
instrs.append(sw(X9, X8, PDF_SRC))

instrs += li32(X9, ENC_DST)             # LUI x9, 0x20001; ADDI x9, x9, -2048
instrs.append(sw(X9, X8, PDF_DST))

instrs.append(addi(X9, X0, PDF_LEN))    # ADDI x9, x0, 64
instrs.append(sw(X9, X8, PDF_LEN_O))

# START encryption: CTRL = 1
instrs.append(addi(X9, X0, 1))
instrs.append(sw(X9, X8, PDF_CTRL))

# ── Phase 3: Poll encrypt done (STATUS bit1) ────────────────────────────────
poll_enc_idx = len(instrs)
instrs.append(lw(X10, X8, PDF_STATUS))  # LW x10, 0x08(x8)
instrs.append(andi(X10, X10, 2))        # ANDI x10, x10, 2 (bit1 = done)
instrs.append(beq(X10, X0, -8))         # BEQ x10, x0, -8 (back to poll_enc_idx)

# ── Phase 4: Capture result_tag from SRAM → exp_tag CSR ────────────────────
# The PDF engine's S_WAIT_TAG writes result_tag[127:96..31:0] to SRAM at
# ENC_DST+80 .. ENC_DST+92 (= 0x20000850..0x2000085C).  Reading from SRAM is
# more reliable than reading the AXI-Lite CSR at 0x30002068 because the
# crossbar's combinational response mux can mis-route the R-channel when the
# CPU de-asserts araddr one cycle after the AR handshake completes.
instrs += li32(X9, TAG_SRAM_BASE)       # x9 = ENC_DST + 80 = 0x20000850
for soff, eoff in zip(TAG_SRAM_OFFSETS, PDF_EXP0):
    instrs.append(lw(X11, X9, soff))    # LW x11, soff(x9)  [tag word from SRAM]
    instrs.append(sw(X11, X8, eoff))    # SW x11, eoff(x8)  [write to exp_tag CSR]

# ── Phase 5: Reconfigure for decryption ────────────────────────────────────
instrs += li32(X9, DEC_SRC)             # LUI+ADDI  dec_src = ENC_DST+16
instrs.append(sw(X9, X8, PDF_SRC))

instrs += li32(X9, DEC_DST)             # LUI only  dec_dst = 0x20001000
instrs.append(sw(X9, X8, PDF_DST))

# pdf_len stays same in engine registers

# CTRL = 3: decrypt_mode=1, start=1
instrs.append(addi(X9, X0, 3))
instrs.append(sw(X9, X8, PDF_CTRL))

# ── Phase 6: Poll decrypt done ──────────────────────────────────────────────
poll_dec_idx = len(instrs)
instrs.append(lw(X10, X8, PDF_STATUS))
instrs.append(andi(X10, X10, 2))
instrs.append(beq(X10, X0, -8))

# ── Phase 7: Verify auth_ok (STATUS bit2) ──────────────────────────────────
instrs.append(lw(X15, X8, PDF_STATUS))  # LW x15, 0x08(x8)
instrs.append(andi(X15, X15, 4))        # bit2 = auth_ok
instrs.append(addi(X28, X0, 4))         # expected value = 4

bne_authok_idx = len(instrs)
instrs.append(0)                        # placeholder: BNE x15, x28, → FAIL_GPIO

# ── Phase 8: Memory comparison ─────────────────────────────────────────────
instrs += li32(X20, SRC_ADDR)           # x20 = original 0x20000400
instrs += li32(X21, DEC_DATA)           # x21 = decrypted 0x20001010
instrs.append(addi(X22, X0, 16))        # x22 = word count = 16

cmp_loop_idx = len(instrs)
instrs.append(lw(X23, X20, 0))          # LW x23, 0(x20)  — original word
instrs.append(lw(X24, X21, 0))          # LW x24, 0(x21)  — decrypted word

bne_mismatch_idx = len(instrs)
instrs.append(0)                        # placeholder: BNE x23, x24, → FAIL_GPIO

instrs.append(addi(X20, X20, 4))        # advance src
instrs.append(addi(X21, X21, 4))        # advance dec
instrs.append(addi(X22, X22, -1))       # decrement counter

bne_loop_idx = len(instrs)
loop_offset = (cmp_loop_idx - bne_loop_idx) * 4   # should be -24
instrs.append(bne(X22, X0, loop_offset))           # BNE x22, x0, -24

# ── PASS path ───────────────────────────────────────────────────────────────
pass_idx = len(instrs)
instrs += li32(X7, PASS_VAL)
instrs += li32(X29, GPIO_BASE)
instrs.append(sw(X7, X29, 0))
instrs.append(jal(X0, 0))

# ── FAIL_GPIO path ──────────────────────────────────────────────────────────
fail_gpio_idx = len(instrs)
instrs += li32(X7, FAIL_VAL)
instrs += li32(X29, GPIO_BASE)
instrs.append(sw(X7, X29, 0))
instrs.append(jal(X0, 0))

# ---------------------------------------------------------------------------
# Fix forward-branch placeholders
# ---------------------------------------------------------------------------
# BNE auth_ok check → FAIL_GPIO
instrs[bne_authok_idx]   = bne(X15, X28, (fail_gpio_idx - bne_authok_idx)  * 4)
# BNE word mismatch → FAIL_GPIO
instrs[bne_mismatch_idx] = bne(X23, X24, (fail_gpio_idx - bne_mismatch_idx) * 4)

# ---------------------------------------------------------------------------
# Sanity assertions
# ---------------------------------------------------------------------------
assert (pdf_setup_idx - beq_aadhaar_idx) * 4 == 24, "Aadhaar BEQ offset mismatch"
assert loop_offset == -24, f"Loop BNE offset mismatch: {loop_offset}"

# ---------------------------------------------------------------------------
# Write hex file
# ---------------------------------------------------------------------------
out_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "image_firmware.hex")
with open(out_path, "w") as f:
    for instr in instrs:
        f.write(f"{instr:08x}\n")

RESET_ADDR = 0x20000000
print(f"[fw_gen_image] Wrote {len(instrs)} instructions → {out_path}")
print(f"[fw_gen_image] AES-256 key   = {KEY_WORDS}")
print(f"[fw_gen_image] Nonce         = {NONCE_WORDS}")
print(f"[fw_gen_image] SRC_ADDR      = 0x{SRC_ADDR:08X}")
print(f"[fw_gen_image] ENC_DST       = 0x{ENC_DST:08X}")
print(f"[fw_gen_image] DEC_SRC       = 0x{DEC_SRC:08X}")
print(f"[fw_gen_image] DEC_DST       = 0x{DEC_DST:08X}")
print(f"[fw_gen_image] DEC_DATA      = 0x{DEC_DATA:08X}")
print(f"[fw_gen_image] PASS sentinel = 0x{PASS_VAL:08X}")
print(f"[fw_gen_image] FAIL sentinel = 0x{FAIL_VAL:08X}")
print()

labels = {
    beq_aadhaar_idx : "beq_aadhaar",
    pdf_setup_idx   : "pdf_setup",
    poll_enc_idx    : "poll_enc",
    bne_authok_idx  : "bne_authok",
    cmp_loop_idx    : "cmp_loop",
    bne_mismatch_idx: "bne_mismatch",
    bne_loop_idx    : "bne_loop",
    pass_idx        : "PASS",
    fail_gpio_idx   : "FAIL_GPIO",
}
for i, instr in enumerate(instrs):
    label = f" ← [{labels[i]}]" if i in labels else ""
    print(f"  [{i:3d}] 0x{RESET_ADDR + i*4:08X}: 0x{instr:08X}{label}")
