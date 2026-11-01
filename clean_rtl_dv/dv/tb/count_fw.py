#!/usr/bin/env python3
"""Count expected instructions and verify firmware.hex"""

def _uint32(v):
    return v & 0xFFFF_FFFF

def lui(rd, imm20):
    return _uint32((imm20 << 12) | (rd << 7) | 0x37)

def addi(rd, rs1, imm12):
    imm = imm12 & 0xFFF
    return _uint32((imm << 20) | (rs1 << 15) | (0 << 12) | (rd << 7) | 0x13)

def sw(rs2, rs1, imm12):
    imm = imm12 & 0xFFF
    return _uint32(((imm >> 5) << 25) | (rs2 << 20) | (rs1 << 15) | (2 << 12) | ((imm & 0x1F) << 7) | 0x23)

def lw(rd, rs1, imm12):
    imm = imm12 & 0xFFF
    return _uint32((imm << 20) | (rs1 << 15) | (2 << 12) | (rd << 7) | 0x03)

def andi(rd, rs1, imm12):
    imm = imm12 & 0xFFF
    return _uint32((imm << 20) | (rs1 << 15) | (7 << 12) | (rd << 7) | 0x13)

def srli(rd, rs1, shamt):
    return _uint32((shamt << 20) | (rs1 << 15) | (5 << 12) | (rd << 7) | 0x13)

def or_r(rd, rs1, rs2):
    return _uint32((rs2 << 20) | (rs1 << 15) | (6 << 12) | (rd << 7) | 0x33)

def beq(rs1, rs2, byte_offset):
    imm = byte_offset & 0x1FFF
    b12   = (imm >> 12) & 1
    b11   = (imm >> 11) & 1
    b10_5 = (imm >> 5) & 0x3F
    b4_1  = (imm >> 1) & 0xF
    return _uint32((b12 << 31) | (b10_5 << 25) | (rs2 << 20) | (rs1 << 15) |
                   (0 << 12) | (b4_1 << 8) | (b11 << 7) | 0x63)

def bne(rs1, rs2, byte_offset):
    imm = byte_offset & 0x1FFF
    b12   = (imm >> 12) & 1
    b11   = (imm >> 11) & 1
    b10_5 = (imm >> 5) & 0x3F
    b4_1  = (imm >> 1) & 0xF
    return _uint32((b12 << 31) | (b10_5 << 25) | (rs2 << 20) | (rs1 << 15) |
                   (1 << 12) | (b4_1 << 8) | (b11 << 7) | 0x63)

def jal(rd, byte_offset):
    imm = byte_offset & 0x1FFFFF
    b20    = (imm >> 20) & 1
    b10_1  = (imm >> 1) & 0x3FF
    b11    = (imm >> 11) & 1
    b19_12 = (imm >> 12) & 0xFF
    return _uint32((b20 << 31) | (b10_1 << 21) | (b11 << 20) | (b19_12 << 12) |
                   (rd << 7) | 0x6F)

def _compute_lui_addi(val32):
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

X0=0; X2=2; X5=5; X6=6; X7=7; X8=8; X9=9; X10=10; X11=11; X18=18; X19=19; X28=28; X29=29
PDF_BASE=0x30002000; SRC_BASE=0x20000800; DST_BASE=0x20002000; OUT_BASE=0x20004000
PAD_BYTES=256; TAG_ADDR=DST_BASE+16+PAD_BYTES
KEY=[0xdeadbeef,0xcafebabe,0x12345678,0x9abcdef0,0x0fedcba9,0x87654321,0xaabbccdd,0xeeff0011]
NONCE=[0x01234567,0x89abcdef,0xfedcba98,0x76543210]
META=[(0x58,0x20260001),(0x5C,0xC91A500C),(0x60,0x67200000),(0x64,0x2)]
KEY_OFF=[0x28,0x2C,0x30,0x34,0x38,0x3C,0x40,0x44]
NONCE_OFF=[0x18,0x1C,0x20,0x24]
PASS_VALUE=0x900DDEAD; FAIL_VALUE=0xDEADF00D

instructions=[]
def emit(x):
    if isinstance(x, int): instructions.append(x)
    else: instructions.extend(x)

emit(li32(X2,0x2000FF00)); emit(lui(X5,0x30002))
for kv,koff in zip(KEY,KEY_OFF): emit(li32(X6,kv)); emit(sw(X6,X5,koff))
for nv,noff in zip(NONCE,NONCE_OFF): emit(li32(X6,nv)); emit(sw(X6,X5,noff))
emit(li32(X6,SRC_BASE)); emit(sw(X6,X5,0x0C))
emit(li32(X6,DST_BASE)); emit(sw(X6,X5,0x10))
emit(addi(X6,X0,PAD_BYTES)); emit(sw(X6,X5,0x14))
for moff,mval in META: emit(li32(X6,mval)); emit(sw(X6,X5,moff))
emit(addi(X6,X0,1)); emit(sw(X6,X5,0x04)); emit(sw(X6,X5,0x00))
emit(lw(X6,X5,0x08)); emit(andi(X6,X6,2)); emit(beq(X6,X0,-8))
emit(li32(X7,TAG_ADDR))
emit(lw(X8,X7,0)); emit(lw(X9,X7,4)); emit(lw(X18,X7,8)); emit(lw(X19,X7,12))
emit(sw(X8,X5,0x48)); emit(sw(X9,X5,0x4C)); emit(sw(X18,X5,0x50)); emit(sw(X19,X5,0x54))
emit(li32(X6,DST_BASE+16)); emit(sw(X6,X5,0x0C))
emit(li32(X6,OUT_BASE)); emit(sw(X6,X5,0x10))
emit(addi(X6,X0,PAD_BYTES)); emit(sw(X6,X5,0x14))
for moff,mval in META: emit(li32(X6,mval)); emit(sw(X6,X5,moff))
emit(addi(X6,X0,1)); emit(sw(X6,X5,0x04))
emit(addi(X6,X0,3)); emit(sw(X6,X5,0x00))
emit(lw(X6,X5,0x08)); emit(andi(X6,X6,2)); emit(beq(X6,X0,-8))
emit(lw(X6,X5,0x08)); emit(srli(X6,X6,3)); emit(andi(X6,X6,1))
emit(addi(X10,X0,0)); emit(or_r(X10,X10,X6)); emit(addi(X11,X0,64))
emit(li32(X28,SRC_BASE)); emit(li32(X29,OUT_BASE+16))
emit(lw(X6,X28,0)); emit(lw(X7,X29,0)); emit(beq(X6,X7,8))
emit(addi(X10,X10,1)); emit(addi(X28,X28,4)); emit(addi(X29,X29,4))
emit(addi(X11,X11,-1)); emit(bne(X11,X0,-28))
emit(lui(X28,0x40003)); emit(beq(X10,X0,20))
fu,fl=_compute_lui_addi(FAIL_VALUE); emit(lui(X6,fu)); emit(addi(X6,X6,fl))
emit(sw(X6,X28,0)); emit(jal(X0,16))
pu,pl=_compute_lui_addi(PASS_VALUE); emit(lui(X6,pu)); emit(addi(X6,X6,pl))
emit(sw(X6,X28,0)); emit(jal(X0,0))

print(f"Expected: {len(instructions)} instructions")

with open('/Users/aasheiksaran/Desktop/Productivity/INDIA_CRYPTO_SOC/dv/tb/firmware.hex') as f:
    actual=[l.strip() for l in f if l.strip()]
print(f"Actual firmware.hex: {len(actual)} lines")
expected=[f"{i:08x}" for i in instructions]
if expected==actual:
    print("firmware.hex matches fw_gen.py: OK")
else:
    print("MISMATCH:")
    for i,(e,a) in enumerate(zip(expected,actual)):
        if e!=a: print(f"  Word {i} addr 0x{0x20000000+i*4:08x}: want {e} got {a}")
    if len(expected)!=len(actual): print(f"  Lengths: want {len(expected)} got {len(actual)}")
