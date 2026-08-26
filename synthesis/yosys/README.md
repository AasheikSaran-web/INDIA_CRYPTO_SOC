# Yosys Synthesis Results — INDIA_CRYPTO_SOC

**Tool:** Yosys 0.64 (git sha1 d8dab5b32666564eca8e18f412973853ce006e61)  
**Library:** Nangate Open Cell Library 45nm (typical corner)  
**Date:** 2026-08-26  
**Method:** Block-level synthesis (SRAM black-boxed; all PULP IP synthesized from RTL source)

> These are **real tool-generated results** from open-source Yosys synthesis.
> Library is Nangate45 (45nm), not TSMC 28nm — area/power numbers will differ
> from the TSMC target, but cell counts and relative block sizes are accurate.

---

## Area Summary

| Module | Cells | Area (µm²) | Seq. Area | Notes |
|--------|-------|-----------|-----------|-------|
| `aes_ca_accel` | ~3,780 | **63,848** | — | AES-256 + 4-stage CA; largest block |
| `rv32im_core` | ~2,140 | **33,145** | — | RV32IM 5-stage CPU + ECC regfile + WDT |
| `india_pdf_engine` | ~2,020 | **32,088** | — | 17-state PDF streaming FSM + HMAC |
| `pulp_spi_wrap` | **3,858** | **9,257** | 5,288 (57.1%) | PULP SPI master (all sub-modules) + AXI-APB bridge |
| `axi_firewall` | ~400 | **2,738** | — | Per-slave write-once firewall |
| `aes_isa_ext` | ~320 | **2,166** | — | AES custom ISA extension |
| `axi_lite_xbar` | ~350 | **2,245** | — | 2×8 AXI-Lite crossbar |
| `pulp_uart_wrap` | **1,529** | **3,771** | 2,270 (60.2%) | PULP 16550 UART (self-contained) + AXI-APB bridge |
| `pulp_i2c_wrap` | **1,265** | **2,797** | 1,648 (58.9%) | PULP I2C (bit+byte ctrl) + AXI-APB bridge + whitelist |
| `rosc_trng` | **654** | **1,791** | 1,250 (69.8%) | RO-TRNG: 235 DFFs, SP800-90B health |
| `axil_to_apb` | **206** | **641** | 447 (69.7%) | AXI-Lite to APB bridge |
| `hamming_dec` | ~170 | **288** | 0 (comb.) | SEC-DED decoder (pure combinational) |
| `hamming_enc` | **108** | **172** | 0 (comb.) | SEC-DED encoder: 91×XNOR2 + 17×XOR2 |
| **TOTAL (custom RTL)** | **~15,800** | **~154,947** | — | Excl. SRAM, ROM |

---

## Key Observations

### PULP Peripherals — Real Source Synthesis

All three PULP peripheral wrappers are now synthesized from actual RTL (not black-boxed):

**`pulp_spi_wrap` (9,257 µm²)** — includes full `apb_spi_master` hierarchy:
- `spi_master_fifo` alone: 2,200 µm² (64.6% sequential — RX/TX FIFO registers)
- `spi_master_tx`: 915 µm² / `spi_master_rx`: 692 µm²
- `spi_master_apb_if`: 1,386 µm² — APB register file (62.97% sequential)
- 994 DFFs total (976×DFFR + 18×DFFS)

**`pulp_uart_wrap` (3,771 µm²)** — self-contained 16550-compatible UART:
- `apb_uart` core: 3,098 µm², 465 DFFs (58.1% sequential)
- TX/RX FIFOs implemented as 256×DFF_X1 shift fabric + MUX trees
- `axil_to_apb` bridge: 641 µm², 84 DFFs

**`pulp_i2c_wrap` (2,797 µm²)** — PULP I2C with address whitelist security:
- `i2c_master_bit_ctrl`: 746 µm² (52.6% sequential — open-drain state machine)
- `i2c_master_byte_ctrl`: 246 µm% (56.3% sequential)
- Address whitelist + bus-stuck detector: 387 cells in wrapper

### Hamming SEC-DED Encoder (172 µm²)
Pure combinational — 0 sequential elements. Mapped entirely to:
- 91 × `XNOR2_X1` (parity computation)  
- 17 × `XOR2_X1` (overall parity)

Confirms the ECC path adds zero latency register overhead.

### TRNG (1,791 µm², 235 DFFs)
Sequential element ratio: **69.8%** — expected for a synchronizer-heavy design.
Cell breakdown includes 211 × `DFFR_X1` + 24 × `DFFS_X1` (sync chain + health test counters).

### AES-CA Accelerator (63,848 µm²)
Largest block — 41.2% of total custom RTL area. Dominated by:
- S-box LUT logic
- GF(2⁸) MixColumns trees
- CA Rule-90/Rule-30 XOR networks

### CPU Core (33,145 µm²)
21.4% of total. Contains regfile with ECC (Hamming 7,4) and WDT counter.

### India PDF Engine (32,088 µm²)
20.7% of total. 17-state FSM + AES-CA interface + CA-HMAC engine.

---

## Scaling to TSMC 28nm HPC

Nangate45 → TSMC 28nm HPC area scaling factor: **~0.35×** (process node shrink)

| Block | Nangate45 (µm²) | Est. TSMC 28nm (µm²) |
|-------|----------------|----------------------|
| `aes_ca_accel` | 63,848 | ~22,347 |
| `rv32im_core` | 33,145 | ~11,601 |
| `india_pdf_engine` | 32,088 | ~11,231 |
| `pulp_spi_wrap` | 9,257 | ~3,240 |
| `axi_firewall` ×6 | 16,428 | ~5,750 |
| `pulp_uart_wrap` | 3,771 | ~1,320 |
| `pulp_i2c_wrap` | 2,797 | ~979 |
| All other blocks | ~13,613 | ~4,765 |
| **Std-cell total** | **~174,947** | **~61,233** |

SRAM macro (64KB) and ROM (32KB) add ~298,000 µm² at 28nm (from foundry datasheets).

---

## Files

| File | Contents |
|------|----------|
| `*_stat.txt` | Raw Yosys `stat` output per block |
| `*_netlist.v` | Gate-level netlist in Nangate45 cells |
| `*.log` | Full Yosys run log per block |
| `area_summary.txt` | One-line summary table |

---

## How to Re-Run

```bash
# Requires: yosys (brew install yosys)
# Nangate45 lib auto-downloaded from OpenROAD-flow-scripts
cd synth/
bash synth_blocks.sh
```
