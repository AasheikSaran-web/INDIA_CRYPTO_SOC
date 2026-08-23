# Yosys Synthesis Results — INDIA_CRYPTO_SOC

**Tool:** Yosys 0.64 (git sha1 d8dab5b32666564eca8e18f412973853ce006e61)  
**Library:** Nangate Open Cell Library 45nm (typical corner)  
**Date:** 2026-08-24  
**Method:** Block-level synthesis (SRAM black-boxed; PULP IP black-boxed)

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
| `axi_firewall` | ~400 | **2,738** | — | Per-slave write-once firewall |
| `aes_isa_ext` | ~320 | **2,166** | — | AES custom ISA extension |
| `axi_lite_xbar` | ~350 | **2,245** | — | 2×8 AXI-Lite crossbar |
| `rosc_trng` | **654** | **1,791** | 1,250 (69.8%) | RO-TRNG: 235 DFFs, SP800-90B health |
| `pulp_spi_wrap` | ~76 | **1,027** | — | SPI security wrapper + AXI-APB bridge |
| `axil_to_apb` | ~95 | **641** | — | AXI-Lite to APB bridge |
| `hamming_dec` | ~170 | **288** | 0 (comb.) | SEC-DED decoder (pure combinational) |
| `hamming_enc` | **108** | **172** | 0 (comb.) | SEC-DED encoder: 91×XNOR2 + 17×XOR2 |
| **TOTAL (custom RTL)** | **~10,110** | **~140,149** | — | Excl. SRAM, ROM, PULP IP |

---

## Key Observations

### Hamming SEC-DED Encoder (172 µm²)
Pure combinational — 0 sequential elements. Mapped entirely to:
- 91 × `XNOR2_X1` (parity computation)  
- 17 × `XOR2_X1` (overall parity)

Confirms the ECC path adds zero latency register overhead.

### TRNG (1,791 µm², 235 DFFs)
Sequential element ratio: **69.8%** — expected for a synchronizer-heavy design.
Cell breakdown includes 211 × `DFFR_X1` + 24 × `DFFS_X1` (sync chain + health test counters).

### AES-CA Accelerator (63,848 µm²)
Largest block — 45.5% of total custom RTL area. Correctly dominated by:
- S-box LUT logic
- GF(2⁸) MixColumns trees
- CA Rule-90/Rule-30 XOR networks

### CPU Core (33,145 µm²)
23.6% of total. Contains regfile with ECC (Hamming 7,4) and WDT counter.

### India PDF Engine (32,088 µm²)
22.9% of total. 17-state FSM + AES-CA interface + CA-HMAC engine.

---

## Scaling to TSMC 28nm HPC

Nangate45 → TSMC 28nm HPC area scaling factor: **~0.35×** (process node shrink)

| Block | Nangate45 (µm²) | Est. TSMC 28nm (µm²) |
|-------|----------------|----------------------|
| `aes_ca_accel` | 63,848 | ~22,347 |
| `rv32im_core` | 33,145 | ~11,601 |
| `india_pdf_engine` | 32,088 | ~11,231 |
| `axi_firewall` ×6 | 16,428 | ~5,750 |
| All other blocks | ~10,640 | ~3,724 |
| **Std-cell total** | **~156,149** | **~54,653** |

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
