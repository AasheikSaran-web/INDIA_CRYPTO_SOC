"""
INDIA_CRYPTO_SOC — Publication-quality microarchitecture diagram
Clean grid layout, minimal text, Canva-ready 300 dpi PNG + SVG.
"""
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
from matplotlib.patches import FancyBboxPatch, FancyArrowPatch
import matplotlib.patheffects as pe

# ─── canvas ────────────────────────────────────────────────────────────────
fig, ax = plt.subplots(figsize=(24, 16))
ax.set_xlim(0, 24); ax.set_ylim(0, 16)
ax.axis('off')
fig.patch.set_facecolor('#FAFAFA')

# ─── palette ───────────────────────────────────────────────────────────────
P = dict(
    core_h='#1A237E', core_s='#E8EAF6', core_b='#3949AB',
    mem_h ='#1B5E20', mem_s ='#E8F5E9', mem_b ='#388E3C',
    cry_h ='#880E4F', cry_s ='#FCE4EC', cry_b ='#AD1457',
    per_h ='#3E2723', per_s ='#FBE9E7', per_b ='#5D4037',
    xb_h  ='#1C313A', xb_s  ='#37474F',
    white ='#FFFFFF', bg='#FAFAFA',
    imem  ='#1565C0', dmem='#2E7D32',
    dma   ='#6A1B9A', irq ='#C62828',
    dim   ='#78909C', dark='#212121',
)

# ─── helpers ───────────────────────────────────────────────────────────────
def rb(x, y, w, h, fc, ec, lw=1.4, r=0.25, z=2, a=1.0):
    ax.add_patch(FancyBboxPatch((x,y), w, h,
        boxstyle=f'round,pad=0,rounding_size={r}',
        fc=fc, ec=ec, lw=lw, zorder=z, alpha=a))

def t(x, y, s, fs=8, fw='normal', c='#212121', ha='center', va='center',
      z=6, mono=False):
    kw = {'fontfamily':'monospace'} if mono else {}
    ax.text(x, y, s, fontsize=fs, fontweight=fw, color=c,
            ha=ha, va=va, zorder=z, **kw)

def block(x, y, w, h, hdr_txt, color_h, color_s, sub_lines=(),
          addr_txt=None, hdr_h=0.72, z=3, fs_hdr=9.5, fs_sub=7.2):
    """Rounded block with header band + optional sub-lines + address pill."""
    rb(x, y, w, h, color_s, color_h, lw=1.5, r=0.22, z=z)
    rb(x, y+h-hdr_h, w, hdr_h, color_h, color_h, lw=0, r=0.22, z=z+1)
    t(x+w/2, y+h-hdr_h/2, hdr_txt, fs=fs_hdr, fw='bold', c='white', z=z+2)
    if addr_txt:
        ax.text(x+w-0.18, y+h-hdr_h-0.28, addr_txt,
                fontsize=6, color='#546E7A', ha='right', va='center',
                zorder=z+3, fontfamily='monospace',
                bbox=dict(fc='#ECEFF1', ec='none', pad=1.5,
                          boxstyle='round,pad=0.2'))
    step = (h - hdr_h - 0.45) / max(len(sub_lines), 1)
    for i, line in enumerate(sub_lines):
        ty = y + h - hdr_h - 0.38 - i*step - step/2
        t(x+w/2, ty, line, fs=fs_sub, c=P['dim'], z=z+2)

def pill(x, y, w, h, txt, fc, tc, fs=6.5, z=6):
    rb(x, y, w, h, fc, tc, lw=0.8, r=0.12, z=z)
    t(x+w/2, y+h/2, txt, fs=fs, c=tc, z=z+1)

def arrow(x0,y0,x1,y1, c, lw=1.7, style='->', cs='arc3,rad=0', dash=False, z=5):
    ls = 'dashed' if dash else 'solid'
    ax.annotate('', xy=(x1,y1), xytext=(x0,y0),
        arrowprops=dict(arrowstyle=style, color=c, lw=lw,
                        connectionstyle=cs, linestyle=ls), zorder=z)

def bidir(x0,y0,x1,y1, c, lw=1.6, cs='arc3,rad=0', z=5):
    arrow(x0,y0,x1,y1, c, lw=lw, style='<->', cs=cs, z=z)

def lbl_arrow(x, y, txt, c, fs=7.2, bg='white', z=7):
    ax.text(x, y, txt, fontsize=fs, color=c, ha='center', va='center',
            fontweight='bold', zorder=z,
            bbox=dict(fc=bg, ec=c, lw=0.9, pad=2.5,
                      boxstyle='round,pad=0.3'))

# ═══════════════════════════════════════════════════════════════════════════
#  TITLE BAR
# ═══════════════════════════════════════════════════════════════════════════
rb(0, 15.05, 24, 0.95, '#1C313A', '#1C313A', lw=0, r=0, z=1)
t(12, 15.55, 'INDIA_CRYPTO_SOC  ·  Microarchitecture',
  fs=20, fw='bold', c='white', z=5)
t(12, 15.18,
  'AES-CA Accelerated RISC-V SoC   ·   TSMC 28nm HPC+   ·   '
  '300 MHz   ·   36,110 µm²   ·   6.13 mW',
  fs=9, c='#90A4AE', z=5)

# ═══════════════════════════════════════════════════════════════════════════
#  SECTION BACKGROUNDS  (subtle tint panels)
# ═══════════════════════════════════════════════════════════════════════════
# Core
rb(0.3, 2.55, 6.0, 12.3, P['core_s'], P['core_h'], lw=1.8, r=0.4, z=1)
t(3.3, 14.62, 'CORE  SUBSYSTEM', fs=8, fw='bold', c=P['core_h'], z=4)
# Memory
rb(14.5, 8.3, 9.2, 6.55, P['mem_s'], P['mem_h'], lw=1.8, r=0.4, z=1)
t(19.1, 14.62, 'MEMORY  SUBSYSTEM', fs=8, fw='bold', c=P['mem_h'], z=4)
# Crypto
rb(14.5, 2.55, 9.2, 5.6, P['cry_s'], P['cry_h'], lw=1.8, r=0.4, z=1)
t(19.1, 7.92, 'CRYPTO  SUBSYSTEM', fs=8, fw='bold', c=P['cry_h'], z=4)
# Peripheral
rb(0.3, 0.3, 23.4, 2.1, P['per_s'], P['per_h'], lw=1.8, r=0.4, z=1)
t(12.0, 0.56, 'PERIPHERAL  SUBSYSTEM', fs=8, fw='bold', c=P['per_h'], z=4)

# ═══════════════════════════════════════════════════════════════════════════
#  AXI-LITE CROSSBAR
# ═══════════════════════════════════════════════════════════════════════════
XBx, XBy, XBw, XBh = 6.55, 2.55, 2.4, 12.3
rb(XBx, XBy, XBw, XBh, P['xb_s'], P['xb_h'], lw=2.2, r=0.25, z=3)
# subtle scan lines
for i in range(20):
    yy = XBy + 0.6 + i * 0.62
    if yy < XBy + XBh - 0.3:
        ax.plot([XBx+0.12, XBx+XBw-0.12], [yy,yy],
                color='white', lw=0.35, alpha=0.12, zorder=4)
t(XBx+XBw/2, XBy+XBh/2+0.5, 'AXI-LITE',  fs=13, fw='bold', c='white', z=6)
t(XBx+XBw/2, XBy+XBh/2-0.15,'CROSSBAR', fs=13, fw='bold', c='white', z=6)
t(XBx+XBw/2, XBy+XBh/2-0.85,'2 Masters × 11 Slaves', fs=8, c='#B0BEC5', z=6)
t(XBx+XBw/2, XBy+XBh/2-1.3, 'AXI-Lite Protocol', fs=7.5, c='#78909C', z=6)
# master labels
t(XBx+0.18, XBy+XBh-1.1, 'm0', fs=7.5, fw='bold', c='#80DEEA', ha='left', z=7)
t(XBx+0.18, XBy+2.6,     'm1', fs=7.5, fw='bold', c='#CE93D8', ha='left', z=7)

# ═══════════════════════════════════════════════════════════════════════════
#  CPU  BLOCK
# ═══════════════════════════════════════════════════════════════════════════
Cx, Cy, Cw, Ch = 0.6, 6.7, 5.6, 8.0
rb(Cx, Cy, Cw, Ch, P['white'], P['core_h'], lw=1.6, r=0.25, z=3)
rb(Cx, Cy+Ch-0.82, Cw, 0.82, P['core_h'], P['core_h'], lw=0, r=0.25, z=4)
t(Cx+Cw/2, Cy+Ch-0.41, 'RV32IM  RISC-V  CPU',
  fs=11.5, fw='bold', c='white', z=5)

# Pipeline stages
PLy = Cy+Ch-1.82; PLw = 0.875
stage_colors = ['#0D47A1','#1565C0','#1976D2','#1E88E5','#2196F3']
for i, (nm, sc) in enumerate(zip(['IF','ID','EX','MEM','WB'], stage_colors)):
    sx = Cx + 0.22 + i*(PLw + 0.1)
    rb(sx, PLy, PLw, 0.78, sc, sc, lw=0, r=0.13, z=5)
    t(sx+PLw/2, PLy+0.39, nm, fs=9.5, fw='bold', c='white', z=6)
    if i < 4:
        arrow(sx+PLw, PLy+0.39, sx+PLw+0.08, PLy+0.39,
              '#90A4AE', lw=0.9, z=6)
t(Cx+Cw/2, PLy-0.28, '5-Stage In-Order Pipeline  ·  RV32IM ISA',
  fs=7.5, c=P['dim'], z=5)

# Divider
ax.plot([Cx+0.25, Cx+Cw-0.25], [Cy+Ch-2.3]*2, '#CFD8DC', lw=0.8, zorder=4)

# Protection features
PROT = [
    ('#E53935', 'Instruction Parity Check'),
    (P['imem'],  'PC Range Guard  (CSR 0xBC0 / 0xBC1)'),
    ('#388E3C', 'Register File ECC  (Hamming 7,4)'),
    ('#6A1B9A', '24-bit Watchdog Timer'),
]
t(Cx+Cw/2, Cy+Ch-2.58, 'Attack Protections', fs=7.5, fw='bold', c=P['dark'], z=5)
for j, (lc, lt) in enumerate(PROT):
    yp = Cy+Ch - 3.12 - j*0.58
    ax.plot([Cx+0.3, Cx+0.58], [yp,yp], color=lc, lw=3.5, zorder=5,
            solid_capstyle='round')
    t(Cx+0.72, yp, lt, fs=7.5, ha='left', va='center', c='#263238', z=6)

# Bus notes
ax.plot([Cx+0.25, Cx+Cw-0.25], [Cy+1.72]*2, '#CFD8DC', lw=0.8, zorder=4)
t(Cx+Cw/2, Cy+1.35, 'imem  →  SRAM  (direct, bypasses crossbar)',
  fs=7.5, fw='bold', c=P['imem'], z=5)
t(Cx+Cw/2, Cy+0.82, 'dmem  →  Crossbar  m0',
  fs=7.5, fw='bold', c=P['dmem'], z=5)
t(Cx+Cw/2, Cy+0.35, 'Reset @ 0x0000_0000  via dmem / crossbar',
  fs=7, c=P['dim'], z=5)

# ═══════════════════════════════════════════════════════════════════════════
#  AES ISA EXTENSION
# ═══════════════════════════════════════════════════════════════════════════
block(0.6, 4.5, 5.6, 1.96,
      'AES ISA Extension', P['core_h'], P['core_s'],
      sub_lines=('Combinational  ·  1-cycle  ·  custom-0 opcode',
                 'SubBytes / MixColumns / KeyExpand'),
      hdr_h=0.7, fs_hdr=9.5)

# Custom opcode label bridge
t(Cx+Cw+0.35, Cy+Ch-2.0, 'Custom\nOpcode\nHook',
  fs=7, fw='bold', c=P['core_h'], z=5)

# ═══════════════════════════════════════════════════════════════════════════
#  BOOT ROM  (Memory — crossbar s0 via dmem, NOT imem)
# ═══════════════════════════════════════════════════════════════════════════
block(14.7, 11.1, 3.8, 3.45,
      'Boot ROM', P['mem_h'], P['mem_s'],
      sub_lines=('32 KB  ·  Read-only',
                 'NOP sled + jump stub',
                 'Crossbar slave  s0  (CPU dmem)'),
      addr_txt='0x0000_0000',
      hdr_h=0.72, fs_hdr=9.5, fs_sub=7.5)

# ═══════════════════════════════════════════════════════════════════════════
#  SRAM  (Memory — s1 AXI + direct imem port)
# ═══════════════════════════════════════════════════════════════════════════
block(19.0, 8.55, 4.4, 5.95,
      '512 KB SRAM', P['mem_h'], P['mem_s'],
      sub_lines=('Single-Port  ·  sram_sp_wrap',
                 '131,072 × 32-bit words',
                 'TSMC 28nm HPC macro',
                 ''),
      addr_txt='0x2000_0000–0x2007_FFFF',
      hdr_h=0.72, fs_hdr=9.5, fs_sub=7.5)
# SRAM controller sub-block
rb(19.2, 8.72, 4.0, 1.3, '#E8F5E9', P['mem_h'], lw=1.0, r=0.15, z=4)
t(21.2, 9.62, 'SRAM Controller', fs=8.5, fw='bold', c=P['mem_h'], z=5)
t(21.2, 9.16, 'imem port  +  AXI-Lite port (s1)', fs=7.2, c=P['dim'], z=5)

# ═══════════════════════════════════════════════════════════════════════════
#  AES-CA ACCELERATOR
# ═══════════════════════════════════════════════════════════════════════════
block(14.7, 6.05, 3.8, 2.5,
      'AES-CA Accelerator', P['cry_h'], P['cry_s'],
      sub_lines=('AES-256  +  CA-1 SubBytes Perturbation', ''),
      addr_txt='0x3000_0000', hdr_h=0.72, fs_hdr=9.5, fs_sub=7.5)
pill(14.9, 6.22, 3.4, 0.55,
     'Hamming SEC-DED ECC on key registers',
     P['cry_s'], P['cry_h'], fs=6.8, z=5)

# ═══════════════════════════════════════════════════════════════════════════
#  INDIA PDF ENGINE
# ═══════════════════════════════════════════════════════════════════════════
block(19.0, 3.9, 4.4, 4.45,
      'India PDF Engine', P['cry_h'], P['cry_s'],
      sub_lines=('DMA streaming encrypt / decrypt',
                 'Aadhaar  ·  GovDoc  ·  Medical',
                 'HMAC auth-tag  ·  IRQ on done',
                 ''),
      addr_txt='0x3000_2000', hdr_h=0.72, fs_hdr=9.5, fs_sub=7.5)
# Validation sub-blocks
rb(19.2, 4.05, 1.9, 0.95, P['cry_s'], P['cry_h'], lw=0.9, r=0.13, z=5)
t(20.15, 4.53, 'Aadhaar ID Check', fs=7, fw='bold', c=P['cry_h'], z=6)
rb(21.3, 4.05, 1.9, 0.95, P['cry_s'], P['cry_h'], lw=0.9, r=0.13, z=5)
t(22.25, 4.53, 'Verhoeff Check', fs=7, fw='bold', c=P['cry_h'], z=6)
t(21.2, 4.3, 'Validation Engine', fs=6.5, c=P['dim'], z=5)

# ═══════════════════════════════════════════════════════════════════════════
#  ROSC-TRNG
# ═══════════════════════════════════════════════════════════════════════════
block(14.7, 2.75, 3.8, 3.1,
      'ROSC-TRNG', P['cry_h'], P['cry_s'],
      sub_lines=('Ring-Oscillator metastable',
                 'NIST SP 800-90B health tests'),
      addr_txt='0x3000_1000', hdr_h=0.72, fs_hdr=9.5, fs_sub=7.5)
pill(14.9, 2.9,  1.6, 0.55, 'RCT', P['cry_s'], P['cry_h'], fs=7.5, z=5)
pill(16.7, 2.9,  1.6, 0.55, 'APT', P['cry_s'], P['cry_h'], fs=7.5, z=5)

# ═══════════════════════════════════════════════════════════════════════════
#  PERIPHERAL — native AXI-Lite (NO APB)
# ═══════════════════════════════════════════════════════════════════════════
NAT = [
    ('CLINT  s8',  '0x0200_0000', 'Timer / Soft IRQ\nmtime · mtimecmp',   0.6),
    ('PLIC  s9',   '0x0C00_0000', '8-Source IRQ Ctrl\nPriority · Threshold', 5.05),
    ('GPIO  s10',  '0x4000_3000', '32-pin · Edge IRQ\nDir / IE / IS regs',  9.5),
]
ax.text(0.78, 2.44, '▸ Native AXI-Lite  (no APB bridge)',
        fontsize=6.8, color='#546E7A', style='italic', zorder=5)
for nm, ad, desc, bx in NAT:
    rb(bx, 0.5, 4.0, 1.72, P['white'], P['per_h'], lw=1.3, r=0.18, z=3)
    rb(bx, 0.5+1.15, 4.0, 0.57, P['per_h'], P['per_h'], lw=0, r=0.18, z=4)
    t(bx+2.0, 0.5+1.43, nm, fs=8.5, fw='bold', c='white', z=5)
    ax.text(bx+3.82, 0.5+0.82, ad, fontsize=6, color='#546E7A',
            ha='right', va='center', zorder=6, fontfamily='monospace',
            bbox=dict(fc='#ECEFF1', ec='none', pad=1.3, boxstyle='round,pad=0.2'))
    t(bx+2.0, 0.5+0.55, desc, fs=7, c=P['dim'], z=5)

# PERIPHERAL — APB
APB = [
    ('Secure UART  s5', '0x4000_0000', 'Glitch Filter · Baud Lock',   14.0),
    ('Secure I2C   s6', '0x4000_1000', 'Device Whitelist · Recovery',  17.7),
    ('Secure SPI   s7', '0x4000_2000', 'CS Guard · Length Limit',      21.4),
]
rb(13.6, 0.42, 10.1, 1.88, '#FFF8E1', P['per_h'], lw=1.0, r=0.18, z=2, a=0.9)
ax.text(13.78, 2.2, '▸ axil_to_apb bridge  (inside each wrapper)  →  APB',
        fontsize=6.8, color='#795548', fontweight='bold', style='italic', zorder=5)
for nm, ad, desc, bx in APB:
    rb(bx-1.3, 0.5, 3.5, 1.72, P['white'], P['per_h'], lw=1.3, r=0.18, z=3)
    rb(bx-1.3, 0.5+1.15, 3.5, 0.57, P['per_h'], P['per_h'], lw=0, r=0.18, z=4)
    t(bx+0.45, 0.5+1.43, nm, fs=8.5, fw='bold', c='white', z=5)
    ax.text(bx+2.12, 0.5+0.83, ad, fontsize=6, color='#546E7A',
            ha='right', va='center', zorder=6, fontfamily='monospace',
            bbox=dict(fc='#ECEFF1', ec='none', pad=1.3, boxstyle='round,pad=0.2'))
    t(bx+0.45, 0.5+0.5, desc, fs=7, c=P['dim'], z=5)

# ═══════════════════════════════════════════════════════════════════════════
#  ARROWS
# ═══════════════════════════════════════════════════════════════════════════

# imem: CPU → SRAM (direct, blue dashed)
ax.annotate('', xy=(19.0, 9.22),
            xytext=(Cx+Cw, Cy+1.1),
            arrowprops=dict(arrowstyle='->', color=P['imem'], lw=2.0,
                            connectionstyle='arc3,rad=-0.18',
                            linestyle='dashed'), zorder=5)
lbl_arrow(15.4, 8.1, 'imem  (direct)', P['imem'])

# dmem: CPU → Crossbar m0
arrow(Cx+Cw, Cy+5.8, XBx, XBy+XBh-1.25, P['dmem'], lw=2.2, z=5)
lbl_arrow(6.3, 11.5, 'm0  dmem', P['dmem'])

# AES ISA ↔ CPU custom opcode
ax.annotate('', xy=(0.6+5.6, 4.5+1.3),
            xytext=(Cx+Cw, Cy+Ch-2.05),
            arrowprops=dict(arrowstyle='<->', color=P['core_b'], lw=1.7,
                            connectionstyle='arc3,rad=0'), zorder=5)

# Xbar s0 → Boot ROM
arrow(XBx+XBw, XBy+XBh-1.5, 14.7, 12.82, P['mem_b'], lw=1.7, z=5)
ax.text(12.9, 13.3, 's0', fontsize=7, fontweight='bold',
        color=P['mem_b'], ha='center', zorder=6)

# Xbar s1 ↔ SRAM AXI
bidir(XBx+XBw, XBy+XBh-4.0, 19.0, 10.3, P['mem_b'], lw=1.7)
ax.text(15.2, 11.0, 's1  AXI', fontsize=7, fontweight='bold',
        color=P['mem_b'], ha='center', zorder=6)

# Xbar s2 ↔ AES-CA
bidir(XBx+XBw, XBy+5.2, 14.7, 7.3, P['cry_b'], lw=1.6)
ax.text(12.4, 7.6, 's2', fontsize=7, fontweight='bold',
        color=P['cry_b'], ha='center', zorder=6)

# Xbar s3 ↔ TRNG
bidir(XBx+XBw, XBy+2.8, 14.7, 4.3, P['cry_b'], lw=1.6)
ax.text(12.4, 4.8, 's3', fontsize=7, fontweight='bold',
        color=P['cry_b'], ha='center', zorder=6)

# Xbar s4 ↔ PDF Engine
bidir(XBx+XBw, XBy+4.0, 19.0, 6.12, P['cry_b'], lw=1.6)
ax.text(15.4, 6.4, 's4', fontsize=7, fontweight='bold',
        color=P['cry_b'], ha='center', zorder=6)

# PDF DMA → Xbar m1
ax.annotate('', xy=(XBx+XBw, XBy+2.6),
            xytext=(19.0, 6.6),
            arrowprops=dict(arrowstyle='->', color=P['dma'], lw=1.8,
                            connectionstyle='arc3,rad=0.25'), zorder=5)
lbl_arrow(16.5, 5.1, 'DMA  m1', P['dma'])

# Xbar → UART/I2C/SPI + CLINT/PLIC/GPIO
# Native AXI-Lite
for px in [2.6, 7.05, 11.5]:
    arrow(XBx+XBw/2, XBy, px, 2.22, P['per_b'], lw=1.4, z=4)
# APB path
for px in [13.45, 17.15, 20.85]:
    arrow(XBx+XBw/2, XBy, px, 2.22, P['per_b'], lw=1.4, z=4)

# CLINT/PLIC → CPU IRQ
ax.annotate('', xy=(Cx+0.55, Cy),
            xytext=(7.05, 2.22),
            arrowprops=dict(arrowstyle='->', color=P['irq'], lw=1.8,
                            connectionstyle='arc3,rad=-0.28'), zorder=5)
lbl_arrow(3.0, 4.0, 'IRQ  (ext · timer · soft)', P['irq'], bg='white')

# ═══════════════════════════════════════════════════════════════════════════
#  SIGNAL LEGEND
# ═══════════════════════════════════════════════════════════════════════════
Lx, Ly = 0.6, 2.7
rb(Lx, Ly, 5.6, 1.65, '#FFFFFF', '#B0BEC5', lw=0.9, r=0.18, z=3, a=0.96)
t(Lx+2.8, Ly+1.46, 'SIGNAL LEGEND', fs=7.5, fw='bold', c='#546E7A', z=5)
LEG = [
    (P['imem'], '--', 'imem  —  Instruction fetch  →  SRAM  (direct)'),
    (P['dmem'], '-',  'dmem  —  CPU data bus  →  Crossbar  m0'),
    (P['dma'],  '-',  'DMA   —  PDF Engine  →  Crossbar  m1'),
    (P['irq'],  '-',  'IRQ   —  CLINT / PLIC  →  CPU'),
]
for k, (lc, ls, lt) in enumerate(LEG):
    ry = Ly + 1.12 - k * 0.33
    ax.plot([Lx+0.22, Lx+0.68], [ry,ry], color=lc, lw=2.5,
            linestyle=ls, zorder=5, solid_capstyle='round')
    ax.plot(Lx+0.68, ry, '>', color=lc, markersize=4.5, zorder=5)
    t(Lx+0.82, ry, lt, fs=7.2, ha='left', va='center', c='#37474F', z=6)

# ═══════════════════════════════════════════════════════════════════════════
#  SAVE
# ═══════════════════════════════════════════════════════════════════════════
OUT = '/Users/aasheiksaran/Desktop/Productivity/INDIA_CRYPTO_SOC/doc/india_crypto_soc_arch'
plt.tight_layout(pad=0.05)
plt.savefig(OUT+'.png', dpi=300, bbox_inches='tight', facecolor='#FAFAFA')
plt.savefig(OUT+'.svg', format='svg', bbox_inches='tight', facecolor='#FAFAFA')
plt.close()
print(f'✓  PNG → {OUT}.png')
print(f'✓  SVG → {OUT}.svg')
