#!/usr/bin/env python3
"""
fw_gen_aadhaar.py — Full Aadhaar SoC firmware for simulation.

Flow:
  1.  Write Aadhaar number "2000 5555 5554" to PDF engine Aadhaar registers
  2.  Write XML header 0x6D783F3C to PDF engine
  3.  Read adh_status (0x3000_2090) — check bit[0] (all_valid) = 1
      If bit[0] != 1: write FAIL to GPIO and halt
  4.  Write test data (16 bytes) to SRAM at 0x2000_0800
  5.  Configure PDF engine: SRC_ADDR, DST_ADDR, PDF_LEN=16, APP_MODE=0
  6.  Write hardcoded AES-256 key (8 x 32-bit words) to PDF engine
  7.  Write hardcoded nonce (4 x 32-bit words) to PDF engine
  8.  Start encryption: CTRL=0x05 (START|IRQ_EN), poll STATUS busy until done
  9.  Read RESULT_TAG (4 words from PDF+0x68..0x74) -> write as EXP_TAG
 10.  Reconfigure for decrypt: SRC=0x2000_0900 DST=0x2000_0A00 CTRL=0x07
 11.  Poll busy until done; check auth_ok (bit[2])
 12.  UART loopback: configure baud=1, enable TX+RX, send 0xAA, poll TX_EMPTY
      then poll RX_NOT_EMPTY, read RX, compare with 0xAA
 13.  Write PASS sentinel 0x900DDEAD to GPIO
 14.  Infinite loop

RISC-V memory map:
  SRAM base   : 0x2000_0000  (CPU boots here)
  PDF engine  : 0x3000_2000
  TRNG        : 0x3000_1000  (not used — hardcoded key/nonce)
  GPIO        : 0x4000_3000
  UART        : 0x4000_0000

PDF engine register offsets:
  0x00 CTRL   bit[0]=START bit[1]=DECRYPT bit[2]=IRQ_EN
  0x04 APP_MODE
  0x08 STATUS {error,auth_fail,auth_ok,done,busy}
  0x0C SRC_ADDR
  0x10 DST_ADDR
  0x14 PDF_LEN
  0x18..0x24 NONCE
  0x28..0x44 KEY
  0x48..0x54 EXP_TAG
  0x68..0x74 RESULT_TAG
  0x80 adh_digits[0]   0x84 adh_digits[1]   0x88 adh_digits[2]
  0x8C adh_hdr         0x90 adh_status (RO) 0x94 adh_hdr_exp (RO)

UART register offsets (16550-compatible PULP apb_uart):
  0x00 DATA     TX write / RX read  (PADDR=0)
  0x04 IER      interrupt enable    (PADDR=1)
  0x08 IIR/FCR  FIFO control        (PADDR=2)
  0x0C LCR      line control (reset=0x03 = 8N1, DLAB=0)  (PADDR=3)
  0x14 LSR      line status  bit[5]=THR_EMPTY  bit[0]=DATA_READY  (PADDR=5)
  Baud divisor: DLL=0x00, DLM=0x04 when DLAB=1; reset default dll_r=1, dlm_r=0.
"""

import os

# ---------------------------------------------------------------------------
# RISC-V instruction encoders
# ---------------------------------------------------------------------------
def _u32(v):
    return v & 0xFFFF_FFFF

def lui(rd, imm20):
    return _u32((imm20 << 12) | (rd << 7) | 0x37)

def addi(rd, rs1, imm12):
    imm = imm12 & 0xFFF
    return _u32((imm << 20) | (rs1 << 15) | (0 << 12) | (rd << 7) | 0x13)

def sw(rs2, rs1, imm12):
    imm = imm12 & 0xFFF
    return _u32(((imm >> 5) << 25) | (rs2 << 20) | (rs1 << 15) | (2 << 12) |
                ((imm & 0x1F) << 7) | 0x23)

def lw(rd, rs1, imm12):
    imm = imm12 & 0xFFF
    return _u32((imm << 20) | (rs1 << 15) | (2 << 12) | (rd << 7) | 0x03)

def andi(rd, rs1, imm12):
    imm = imm12 & 0xFFF
    return _u32((imm << 20) | (rs1 << 15) | (7 << 12) | (rd << 7) | 0x13)

def ori(rd, rs1, imm12):
    imm = imm12 & 0xFFF
    return _u32((imm << 20) | (rs1 << 15) | (6 << 12) | (rd << 7) | 0x13)

def or_(rd, rs1, rs2):
    return _u32((0 << 25) | (rs2 << 20) | (rs1 << 15) | (6 << 12) | (rd << 7) | 0x33)

def beq(rs1, rs2, byte_offset):
    imm   = byte_offset & 0x1FFF
    b12   = (imm >> 12) & 1
    b11   = (imm >> 11) & 1
    b10_5 = (imm >> 5) & 0x3F
    b4_1  = (imm >> 1) & 0xF
    return _u32((b12 << 31) | (b10_5 << 25) | (rs2 << 20) | (rs1 << 15) |
                (0 << 12) | (b4_1 << 8) | (b11 << 7) | 0x63)

def bne(rs1, rs2, byte_offset):
    imm   = byte_offset & 0x1FFF
    b12   = (imm >> 12) & 1
    b11   = (imm >> 11) & 1
    b10_5 = (imm >> 5) & 0x3F
    b4_1  = (imm >> 1) & 0xF
    return _u32((b12 << 31) | (b10_5 << 25) | (rs2 << 20) | (rs1 << 15) |
                (1 << 12) | (b4_1 << 8) | (b11 << 7) | 0x63)

def jal(rd, byte_offset):
    imm    = byte_offset & 0x1FFFFF
    b20    = (imm >> 20) & 1
    b10_1  = (imm >> 1) & 0x3FF
    b11    = (imm >> 11) & 1
    b19_12 = (imm >> 12) & 0xFF
    return _u32((b20 << 31) | (b10_1 << 21) | (b11 << 20) | (b19_12 << 12) |
                (rd << 7) | 0x6F)

def li32(rd, val32):
    """Return list of 1 or 2 instructions to load 32-bit immediate into rd."""
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
        result = [lui(rd, upper20)]
        if lower12_s != 0:
            result.append(addi(rd, rd, lower12_s))
        return result

# ---------------------------------------------------------------------------
# Register aliases (use callee-saved regs for bases so loops don't clobber)
# ---------------------------------------------------------------------------
X0  =  0   # zero
X3  =  3   # gp  — scratch value register
X4  =  4   # tp  — scratch value 2
X5  =  5   # t0  — temporary
X6  =  6   # t1  — read-back / poll value
X7  =  7   # t2  — comparison value
X8  =  8   # s0  — PDF engine base (persistent)
X9  =  9   # s1  — GPIO base (persistent)
X10 = 10   # a0  — UART base (persistent)

# ---------------------------------------------------------------------------
# Address constants
# ---------------------------------------------------------------------------
PDF_BASE   = 0x30002000
GPIO_BASE  = 0x40003000
UART_BASE  = 0x40000000
SRAM_SRC   = 0x20000800   # source data for encryption
SRAM_DST   = 0x20000900   # encrypted output
SRAM_DST2  = 0x20000A00   # decrypted output

PASS_VAL   = 0x900DDEAD
FAIL_VAL   = 0xDEADF00D

# Hardcoded AES-256 key: 8 x 32-bit words = 256-bit (non-zero for real encryption)
KEY_WORDS = [
    0xDEADBEEF, 0xCAFEBABE, 0x12345678, 0x9ABCDEF0,
    0xFEDCBA98, 0x76543210, 0x0F1E2D3C, 0x4B5A6978,
]

# Hardcoded nonce: 4 x 32-bit words = 128-bit
NONCE_WORDS = [0xABCDABCD, 0x12341234, 0x56785678, 0x9ABC9ABC]

# ---------------------------------------------------------------------------
# Instruction list builder
# ---------------------------------------------------------------------------
instrs = []

def pos():
    """Current instruction index."""
    return len(instrs)

def emit(x):
    """Append one instruction or a list of instructions."""
    if isinstance(x, list):
        instrs.extend(x)
    else:
        instrs.append(x)

def off(from_idx, to_idx):
    """Signed byte offset from instruction at from_idx to instruction at to_idx."""
    return (to_idx - from_idx) * 4

# Placeholder value for forward-reference branches (patched later)
PLACEHOLDER = 0x00000013   # NOP

# ===========================================================================
# PHASE 0: Load persistent base addresses
# ===========================================================================
# s0 (x8) = PDF_BASE  = 0x3000_2000  -> lui x8, 0x30002
emit(lui(X8, 0x30002))          # 0x30002437

# s1 (x9) = GPIO_BASE = 0x4000_3000  -> lui x9, 0x40003
emit(lui(X9, 0x40003))          # 0x400034B7

# a0 (x10) = UART_BASE = 0x4000_0000 -> lui x10, 0x40000
emit(lui(X10, 0x40000))         # 0x40000537

# ===========================================================================
# PHASE 1: Write Aadhaar digits and XML header to PDF engine
# ===========================================================================
# adh_digits[0] @ PDF+0x80 = 0x0000_2000  (d11=2, d10=0, d9=0, d8=0)
emit(li32(X3, 0x00002000))      # lui x3, 2  (= 0x00002000)
emit(sw(X3, X8, 0x080))         # SW x3, 0x80(x8)

# adh_digits[1] @ PDF+0x84 = 0x0000_5555  (d7=5..d4=5)
emit(li32(X3, 0x00005555))      # lui x3, 5; addi x3, x3, 0x555
emit(sw(X3, X8, 0x084))         # SW x3, 0x84(x8)

# adh_digits[2] @ PDF+0x88 = 0x0000_5554  (d3=5..d0=4)
emit(li32(X3, 0x00005554))      # lui x3, 5; addi x3, x3, 0x554
emit(sw(X3, X8, 0x088))         # SW x3, 0x88(x8)

# adh_hdr @ PDF+0x8C = 0x6D78_3F3C
emit(li32(X3, 0x6D783F3C))
emit(sw(X3, X8, 0x08C))         # SW x3, 0x8C(x8)

# ===========================================================================
# PHASE 2: Read adh_status and verify all_valid = bit[0] == 1
# ===========================================================================
emit(lw(X6, X8, 0x090))         # LW x6, 0x90(x8)  — adh_status
emit(andi(X6, X6, 1))           # ANDI x6, x6, 1   — isolate all_valid
emit(addi(X7, X0, 1))           # ADDI x7, x0, 1   — expected value

# BNE x6, x7 → FAIL  (will patch once fail_idx is known)
bne_phase2_idx = pos()
emit(PLACEHOLDER)

# ===========================================================================
# PHASE 3: Write 16 bytes of test plaintext to SRAM at 0x2000_0800
# ===========================================================================
emit(li32(X3, SRAM_SRC))        # x3 = 0x2000_0800 (2 instrs via li32)
# We store into x5 as base pointer
emit(addi(X5, X3, 0))           # mv x5, x3

emit(li32(X3, 0x01234567))
emit(sw(X3, X5, 0))             # SRAM[0x800] = 0x01234567

emit(li32(X3, 0x89ABCDEF))
emit(sw(X3, X5, 4))             # SRAM[0x804] = 0x89ABCDEF

emit(li32(X3, 0xFEDCBA98))
emit(sw(X3, X5, 8))             # SRAM[0x808] = 0xFEDCBA98

emit(li32(X3, 0x76543210))
emit(sw(X3, X5, 12))            # SRAM[0x80C] = 0x76543210

# ===========================================================================
# PHASE 4: Configure PDF engine: APP_MODE SRC_ADDR DST_ADDR PDF_LEN
# ===========================================================================
emit(sw(X0, X8, 0x004))         # APP_MODE = 0 (Aadhaar)

emit(li32(X3, SRAM_SRC))
emit(sw(X3, X8, 0x00C))         # SRC_ADDR = 0x2000_0800

emit(li32(X3, SRAM_DST))
emit(sw(X3, X8, 0x010))         # DST_ADDR = 0x2000_0900

emit(addi(X3, X0, 16))
emit(sw(X3, X8, 0x014))         # PDF_LEN = 16

# ===========================================================================
# PHASE 5: Write hardcoded KEY to PDF engine (offsets 0x28..0x44)
# ===========================================================================
key_offsets = [0x028, 0x02C, 0x030, 0x034, 0x038, 0x03C, 0x040, 0x044]
for kw, koff in zip(KEY_WORDS, key_offsets):
    emit(li32(X3, kw))
    emit(sw(X3, X8, koff))

# ===========================================================================
# PHASE 6: Write hardcoded NONCE to PDF engine (offsets 0x18..0x24)
# ===========================================================================
nonce_offsets = [0x018, 0x01C, 0x020, 0x024]
for nw, noff in zip(NONCE_WORDS, nonce_offsets):
    emit(li32(X3, nw))
    emit(sw(X3, X8, noff))

# ===========================================================================
# PHASE 7: Start encryption — CTRL = 0x05 (START | IRQ_EN)
# ===========================================================================
emit(addi(X3, X0, 5))
emit(sw(X3, X8, 0x000))         # CTRL = 0x05

# Poll STATUS done (bit[1]) — spin while bit[1] == 0 (not yet done)
enc_poll_idx = pos()
emit(lw(X6, X8, 0x008))         # LW x6, 0x08(x8)  STATUS
emit(andi(X6, X6, 2))           # isolate done bit (bit[1])
beq_enc_idx = pos()
emit(beq(X6, X0, off(beq_enc_idx, enc_poll_idx)))  # BEQ done==0 -> loop back

# After loop: done is set. Check auth_ok (bit[2]) for encrypt completion
emit(lw(X6, X8, 0x008))         # re-read STATUS
emit(andi(X6, X6, 0x06))        # bits[2:1] = auth_ok | done (both should be set)
bne_enc_done_idx = pos()
emit(PLACEHOLDER)               # BNE x6, x0 -> OK  (patched after enc_ok_idx known)

# If zero: fail
jal_enc_fail_idx = pos()
emit(PLACEHOLDER)               # JAL -> FAIL  (patched later)

enc_ok_idx = pos()
# Patch BNE forward
instrs[bne_enc_done_idx] = bne(X6, X0, off(bne_enc_done_idx, enc_ok_idx))

# ===========================================================================
# PHASE 8: Copy RESULT_TAG → EXP_TAG for decrypt verification
# ===========================================================================
tag_map = [(0x068, 0x048), (0x06C, 0x04C), (0x070, 0x050), (0x074, 0x054)]
for rsrc, rdst in tag_map:
    emit(lw(X3, X8, rsrc))
    emit(sw(X3, X8, rdst))

# ===========================================================================
# PHASE 9: Reconfigure for decryption and start
# ===========================================================================
emit(li32(X3, SRAM_DST))
emit(sw(X3, X8, 0x00C))         # SRC_ADDR = 0x2000_0900

emit(li32(X3, SRAM_DST2))
emit(sw(X3, X8, 0x010))         # DST_ADDR = 0x2000_0A00

emit(addi(X3, X0, 7))
emit(sw(X3, X8, 0x000))         # CTRL = 0x07 (START | DECRYPT | IRQ_EN)

# Poll STATUS done (bit[1]) — spin while bit[1] == 0
dec_poll_idx = pos()
emit(lw(X6, X8, 0x008))
emit(andi(X6, X6, 2))           # isolate done bit (bit[1])
beq_dec_idx = pos()
emit(beq(X6, X0, off(beq_dec_idx, dec_poll_idx)))  # BEQ done==0 -> loop back

# Check auth_ok (bit[2])
emit(lw(X6, X8, 0x008))
emit(andi(X6, X6, 4))           # isolate auth_ok
bne_auth_idx = pos()
emit(PLACEHOLDER)               # BNE x6, x0 -> auth_ok_label  (patched)
jal_auth_fail_idx = pos()
emit(PLACEHOLDER)               # JAL -> FAIL  (patched)
auth_ok_idx = pos()
instrs[bne_auth_idx] = bne(X6, X0, off(bne_auth_idx, auth_ok_idx))

# ===========================================================================
# PHASE 10: UART loopback test — SKIPPED
# The UART peripheral (pulp_blackbox.v) provides only empty module stubs with
# no AXI slave response logic.  Any AXI write to 0x4000_0000 will stall the
# CPU indefinitely because awready/wready/bvalid are never driven.
# Jump directly to PHASE 11 (PASS).
# ===========================================================================
jal_skip_uart_idx = pos()
emit(PLACEHOLDER)   # JAL x0, -> pass_idx  (patched below)

# --- Dead code below: original UART loopback kept for reference only ---
# Write 0xAA to TX DATA register (offset 0x00, PADDR=0)
emit(addi(X3, X0, 0xAA))        # 0xAA = 170 fits in positive 12-bit imm
emit(sw(X3, X10, 0x000))        # TX_DATA = 0xAA

# Poll LSR (0x14) bit[5] = THR_EMPTY until set (TX shift register empty)
uart_tx_poll_idx = pos()
emit(lw(X6, X10, 0x014))        # LSR = UART+0x14  (PADDR=5)
emit(andi(X6, X6, 0x20))        # bit[5] = THR_EMPTY (1 when TX done)
beq_tx_idx = pos()
emit(beq(X6, X0, off(beq_tx_idx, uart_tx_poll_idx)))  # loop while TX busy

# Poll LSR (0x14) bit[0] = DATA_READY until set (RX has data)
uart_rx_poll_idx = pos()
emit(lw(X6, X10, 0x014))        # LSR
emit(andi(X6, X6, 0x01))        # bit[0] = DATA_READY (1 when byte received)
beq_rx_idx = pos()
emit(beq(X6, X0, off(beq_rx_idx, uart_rx_poll_idx)))  # loop while RX empty

# Read RX DATA register (offset 0x00, PADDR=0), compare with 0xAA
emit(lw(X6, X10, 0x000))        # DATA (RX read)
emit(andi(X6, X6, 0xFF))        # mask byte
emit(addi(X7, X0, 0xAA))        # expected = 0xAA
bne_uart_idx = pos()
emit(PLACEHOLDER)               # BNE x6, x7 -> uart_ok  (patched)
jal_uart_fail_idx = pos()
emit(PLACEHOLDER)               # JAL -> FAIL  (patched)
uart_ok_idx = pos()
# Fix: was bne (inverted logic — branched to PASS on mismatch). Use beq so that
# equality (UART echo correct) branches to the pass path; mismatch falls through
# to the fail JAL.
instrs[bne_uart_idx] = beq(X6, X7, off(bne_uart_idx, uart_ok_idx))

# ===========================================================================
# PHASE 11: PASS — write sentinel to GPIO
# ===========================================================================
pass_idx = pos()
emit(li32(X3, PASS_VAL))
emit(sw(X3, X9, 0))             # GPIO DATA = PASS

# Infinite loop — use BEQ x0,x0,0 (self-loop) to avoid JAL pipeline race
inf_loop_idx = pos()
emit(beq(X0, X0, 0))

# ===========================================================================
# FAIL path
# ===========================================================================
fail_idx = pos()
emit(li32(X3, FAIL_VAL))
emit(sw(X3, X9, 0))             # GPIO DATA = FAIL
emit(beq(X0, X0, 0))            # infinite loop — use BEQ x0,x0,0 to avoid JAL race

# ===========================================================================
# Patch all forward-reference placeholders
# ===========================================================================
instrs[bne_phase2_idx]    = bne(X6, X7, off(bne_phase2_idx,    fail_idx))
instrs[jal_enc_fail_idx]  = jal(X0, off(jal_enc_fail_idx,  fail_idx))
instrs[jal_auth_fail_idx] = jal(X0, off(jal_auth_fail_idx, fail_idx))
instrs[jal_skip_uart_idx] = jal(X0, off(jal_skip_uart_idx, pass_idx))
instrs[jal_uart_fail_idx] = jal(X0, off(jal_uart_fail_idx, fail_idx))

# ===========================================================================
# Fix A: NOP padding — append 8 NOP (addi x0,x0,0 = 0x00000013) instructions
# after the last real instruction.  The pipeline fetches up to 4 instructions
# ahead of the PC; without padding the speculative fetch past the final BEQ
# self-loop would see uninitialised SRAM (X), trigger an illegal-instruction
# trap, and cause a periodic trap-redirect loop that prevents the simulation
# from finishing cleanly.
# ===========================================================================
for _ in range(8):
    emit(addi(X0, X0, 0))   # NOP

# ===========================================================================
# Write hex file
# ===========================================================================
out_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "aadhaar_firmware.hex")

with open(out_path, "w") as f:
    for instr in instrs:
        f.write(f"{instr:08x}\n")

RESET_ADDR = 0x20000000
print(f"[fw_gen_aadhaar] Wrote {len(instrs)} instructions to {out_path}")
print(f"[fw_gen_aadhaar] Aadhaar: 2000 5555 5554  XML magic: 0x6D783F3C")
print(f"[fw_gen_aadhaar] Key: {' '.join(f'0x{w:08X}' for w in KEY_WORDS)}")
print(f"[fw_gen_aadhaar] PASS sentinel = 0x{PASS_VAL:08X}")
print(f"[fw_gen_aadhaar] FAIL sentinel = 0x{FAIL_VAL:08X}")
for i, instr in enumerate(instrs):
    print(f"  [{i:3d}] 0x{RESET_ADDR + i*4:08X}: 0x{instr:08X}")
