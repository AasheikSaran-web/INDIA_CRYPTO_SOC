# INDIA_CRYPTO_SOC — Project Memory
> Paste this file at the start of any new chat to restore full context.
> Last updated: 2026-08-24

---

## 1. Project Overview

**Purpose:** Secure cryptographic SoC for Aadhaar e-KYC PDF encryption at UIDAI biometric terminals.
**Process:** TSMC 28nm HPC
**Target frequency:** 250 MHz nominal | 300 MHz achievable without RTL changes
**Supply:** 0.9 V core
**Die area:** ~0.648 mm²
**I/O:** 10 pins only (see Pin Assignment below)

---

## 2. File Inventory

```
INDIA_CRYPTO_SOC/
├── rtl/
│   ├── top/
│   │   └── india_crypto_soc.v          ← Top-level SoC (fully updated; canonical)
│   ├── core/
│   │   ├── rv32im_core.v               ← RV32IM 5-stage in-order CPU
│   │   └── aes_isa_ext.v               ← AES custom ISA extensions (custom0 opcode)
│   ├── crypto/
│   │   ├── rosc_trng.v                 ← Ring-oscillator TRNG (484 lines) [NEW]
│   │   ├── hamming_secded.v            ← SEC-DED ECC encoder + decoder [NEW]
│   │   ├── aes_ca_accel.v              ← AES-256 + Cellular Automata accelerator
│   │   ├── india_pdf_engine.v          ← PDF streaming engine [UPDATED: cipher_decrypt fixed]
│   │   └── ms_trng.v                   ← OBSOLETE — superseded by rosc_trng.v
│   ├── fabric/
│   │   ├── axi_lite_xbar.v             ← 2×8 AXI-Lite crossbar
│   │   └── axi_firewall.v              ← Per-slave AXI firewall [UPDATED: +deny_irq port]
│   └── periph/
│       ├── pulp_uart_wrap.sv           ← UART peripheral
│       ├── pulp_i2c_wrap.sv            ← I2C peripheral
│       ├── pulp_spi_wrap.sv            ← SPI peripheral [UPDATED: single CS, secure_mode]
│       ├── axil_to_apb.sv              ← AXI-Lite to APB bridge
│       └── pulp/                       ← PULP IP sub-modules (apb_spi_master, etc.)
├── constraints/
│   ├── india_crypto_soc_300mhz.sdc     ← 300 MHz SDC constraints [NEW]
│   └── synth_300mhz.tcl                ← Synopsys DC synthesis script [NEW]
├── INDIA_CRYPTO_SOC_Full_Deck.pptx     ← 17-slide presentation deck
├── INDIA_CRYPTO_SOC_PCB_Layout.png     ← Die floorplan + PCB diagram (4200×2970 px)
└── memory.md                           ← This file
```

---

## 3. Pin Assignment (10-pin constraint)

| Pin | Dir | Description |
|-----|-----|-------------|
| clk | in | System clock |
| rst_n | in | Async active-low reset |
| spi_mosi | in | SPI data in (from host) |
| spi_miso | out | SPI data out (to host) |
| spi_sck | in | SPI clock from host |
| spi_cs_n | out | Single chip-select (CS0 only; 1-bit, NOT [3:0]) |
| uart_rx | in | UART receive |
| uart_tx | out | UART transmit |
| i2c_sda | inout | I2C data (ATECC608B key fetch) |
| i2c_scl | out | I2C clock |
| rosc_ext | in | External ring-oscillator entropy input |
| seceng_irq | out | Security engine interrupt (aggregated) |

> i2c_scl and rosc_ext bring it to 12 signals; fits within a 12–14 pad WLCSP.

---

## 4. AXI Crossbar Slave Map

| Slave | Module | Base Address | Notes |
|-------|--------|-------------|-------|
| s0 | Boot ROM (32 KB) | 0x0000_0000 | CPU-master only; no firewall |
| s1 | SRAM (64 KB, SEC-DED) | 0x0001_0000 | CPU+DMA; no firewall |
| s2 | AES-CA Accelerator | 0x4000_0000 | Firewall: CPU-only |
| s3 | India PDF Engine | 0x4001_0000 | Firewall: CPU-only |
| s4 | TRNG (rosc_trng) | 0x4002_0000 | Firewall: CPU-only |
| s5 | SPI (pulp_spi_wrap) | 0x4003_0000 | Firewall: CPU-only |
| s6 | I2C (pulp_i2c_wrap) | 0x4004_0000 | Firewall: CPU-only (ATECC isolated from DMA) |
| s7 | UART (pulp_uart_wrap) | 0x4005_0000 | Firewall: CPU-only |

AXI Masters: m0 = CPU | m1 = PDF Engine DMA

---

## 5. Memory Layout

```
0x0000_0000 – 0x0000_7FFF   Boot ROM      32 KB  (read-only)
0x0001_0000 – 0x0001_FFFF   SRAM          64 KB  (SEC-DED protected)
0x4000_0000 – 0x4000_FFFF   AES-CA        MMIO
0x4001_0000 – 0x4001_FFFF   PDF Engine    MMIO
0x4002_0000 – 0x4002_FFFF   TRNG          MMIO
0x4003_0000 – 0x4003_FFFF   SPI           MMIO
0x4004_0000 – 0x4004_FFFF   I2C           MMIO
0x4005_0000 – 0x4005_FFFF   UART          MMIO
```

SRAM: SRAM_WORDS = 16384, SRAM_AW = 14
Physical storage: 39 bits/word (32 data + 7 ECC)

---

## 6. CPU Core (rv32im_core.v)

- RV32IM, 5-stage in-order pipeline: IF → ID → EX → MEM → WB
- Security features:
  - Instruction parity trap (detects ROM bit-flip)
  - PC Range Guard (CSR 0xBC0 = PC_MIN, CSR 0xBC1 = PC_MAX; trap on out-of-range jump)
  - Hamming(7,4) ECC on register file → `cpu_ecc_fatal` output
  - 24-bit Watchdog Timer → `cpu_wdt_reset` output (feeds seceng_irq)
- M-extension multiplier: iterative 32-cycle shift-and-add
  - Multicycle path: MUL/DIV cells → mul_result_reg (32 cycles setup, 31 hold)
- AES ISA extension: custom0 opcode (single-cycle AES round step)
- Barrel shifter on EX stage: ~0.90 ns TT

---

## 7. AES-CA Accelerator (aes_ca_accel.v)

- AES-256 CTR mode, 14 rounds, 4 Cellular Automata (CA) stages per round
- CA stage sequence per round:
  - CA-1: SubBytes + Rule-90 perturbation
  - CA-2: ShiftRows
  - CA-3: MixColumns in GF(2^8)
  - CA-4: AddRoundKey + Rule-30 perturbation
- Decrypt mode: inverse CA (InvSubBytes, InvShiftRows, InvMixColumns)
- Critical path: AES-CA round register-to-register
  - ~1.16 ns TT | ~1.81 ns SS + 5% OCV
  - Fits 300 MHz budget (3.053 ns combinational budget after deductions)
  - SDC: `set_max_delay 2.400 -datapath_only` advisory
- 400 MHz: needs 2-stage pipeline split at CA-2/CA-3 boundary (RTL change required)
- Area: ~100K GE | Throughput: 285 MB/s @ 250 MHz

---

## 8. India PDF Engine (india_pdf_engine.v)

- 17-state FSM
- APP_MODE field: 0 = ENCRYPT | 1 = DECRYPT | 2 = HMAC-only
- CA-HMAC: Rule-30, 8 iterations, 128-bit tag
- **Security**: HMAC verified BEFORE plaintext release in decrypt mode
- `cipher_decrypt` = `decrypt_mode` (was hardwired to 0 — now FIXED)
- DMA master (AXI m1) reads/writes SRAM via crossbar
- TRNG comment updated: references `rosc_trng.v` (not old ms_trng.v)

---

## 9. Ring-Oscillator TRNG (rosc_trng.v)

Module: `rosc_trng #(RCT_CUTOFF=30, APT_WINDOW=512, APT_THRESH=397)`

Ports: `clk, rst_n, rosc_ext, trng_data[31:0], trng_valid, rct_fail, apt_fail` + AXI-Lite slave

**Register map:**
| Offset | Name | R/W | Description |
|--------|------|-----|-------------|
| 0x000 | DATA | RO | 32-bit random word |
| 0x004 | STAT | RO | `{28'h0, fifo_full, apt_fail, rct_fail, valid}` |
| 0x008 | CTRL | RW | `{29'h0, bypass_vn, test_mode, enable}` |

**Architecture:**
1. `rosc_ext` → 4-stage synchronizer (sync0–sync3), all ASYNC_REG="TRUE"
2. `raw_bit = (sync2 ^ sync3) ^ (sync3 ^ sync3_d3)` (dual-stream XOR)
3. Von Neumann debiaser
4. Galois LFSR whitener (32-bit)
5. SP 800-90B health tests: RCT (cutoff=30) + APT (window=512, threshold=397)
6. 32-bit output FIFO → AXI register
7. `rct_fail` / `apt_fail` feed `seceng_irq`

**Performance:** ~23 Mb/s @ 23 pJ/b (ISSCC 2023 comparable)

**Critical SDC rules for rosc_trng:**
- False path: `rosc_ext` → `sync0_reg`
- Dont-touch: `sync0_reg`, `sync1_reg`, `sync2_reg`, `sync3_reg`
- Multicycle (setup=4, hold=3): `accum_reg*` → `accum_word_reg*`

---

## 10. SEC-DED ECC — Hamming(39,32) (hamming_secded.v)

**Layout:** 39 physical bits = 32 data + 7 check bits

| Bit position | Content |
|-------------|---------|
| [31:0] | Data bits |
| [32] | p0 (covers bits at positions 1,2,4,8,...) |
| [33] | p1 |
| [34] | p2 |
| [35] | p3 |
| [36] | p4 |
| [37] | p5 |
| [38] | p6 (overall parity for DED) |

**Error detection/correction:**
- syndrome[5:0] = received parity XOR recomputed parity
- `sec = (|syndrome) & s_overall` → correct single-bit error (synthesize corrected data)
- `ded = (|syndrome) & ~s_overall` → double-bit error detected, uncorrectable

**Integration in top-level:**
- `sram[SRAM_WORDS-1:0]` declared as `logic [38:0]`
- Port A (IMEM, CPU read): `hamming_dec` → `cpu_imem_rdata`
- Port B write: byte-strobe merge → `hamming_enc` → `sram[addr]`
  ```verilog
  assign sram_pb_merge[ 7: 0] = pb_wr_wstrb[0] ? pb_wr_wdata[ 7: 0] : sram[pb_wr_word_addr][ 7: 0];
  assign sram_pb_merge[15: 8] = pb_wr_wstrb[1] ? pb_wr_wdata[15: 8] : sram[pb_wr_word_addr][15: 8];
  assign sram_pb_merge[23:16] = pb_wr_wstrb[2] ? pb_wr_wdata[23:16] : sram[pb_wr_word_addr][23:16];
  assign sram_pb_merge[31:24] = pb_wr_wstrb[3] ? pb_wr_wdata[31:24] : sram[pb_wr_word_addr][31:24];
  ```
- Port B read (DMA): `hamming_dec` → `xb_s1_rdata`
- `sram_ded_sticky`: sticky latch; feeds `seceng_irq`
- Area overhead: +21.9% bits, ~+6% total SoC area
- Zero latency penalty (combinational; single-cycle access unchanged)

---

## 11. AXI Firewall (axi_firewall.v)

- Parameterized per slave: `ALLOWED_MASTERS` bitmask
- `FW_CPU_ONLY = 32'h0000_0001` (only master 0 = CPU)
- Port `deny_irq` added: pulses high 1 cycle on any denied transaction
- Firewall instances: fw2..fw7 (s2..s7)
- `fw*_deny_irq` wires feed `seceng_irq` aggregation

**Write-once lock:** Write `0xDEADBEEF` to any slave's lock register → `table_locked = 1` forever until reset. Does NOT false-path; synthesis optimizes normally (needed at boot).

---

## 12. SPI Peripheral (pulp_spi_wrap.sv)

- AXI-Lite slave → APB bridge → PULP `apb_spi_master`
- **Single CS** (10-pin constraint): `spi_cs_n` is 1-bit (was [3:0] — FIXED)
- AXI-only register map (not forwarded to APB):
  - `0xF8`: `max_len[7:0]` — caps SPI transfer length (write guard)
  - `0xFC[0]`: `cs_lock` — write-once CS lock; forces CS deasserted permanently
- `secure_mode=1`: CS=1, SCK=0, MOSI=0 (dead-mode)
- SDC case analysis: `set_case_analysis 0 [get_pins u_spi/secure_mode]` (normal operation)

---

## 13. seceng_irq Aggregation

```verilog
assign seceng_irq = pdf_irq
                  | fw2_deny_irq | fw3_deny_irq | fw4_deny_irq
                  | fw5_deny_irq | fw6_deny_irq | fw7_deny_irq
                  | cpu_ecc_fatal
                  | sram_ded_sticky
                  | trng_rct_fail | trng_apt_fail
                  | cpu_wdt_reset;
```

---

## 14. Timing Analysis

**Process corner for signoff:** SS / 125°C / 0.81V

| Path | TT delay | SS+OCV delay | Budget (3.053 ns) | Margin |
|------|---------|-------------|-------------------|--------|
| AES-CA round | ~1.16 ns | ~1.81 ns | 3.053 ns | +1.24 ns ✅ |
| CPU EX (shifter) | ~0.90 ns | ~1.40 ns | 3.053 ns | +1.65 ns ✅ |
| SRAM + ECC decode | ~1.35 ns | ~2.09 ns | 3.053 ns | +0.96 ns ✅ |
| AXI crossbar | ~0.61 ns | ~0.95 ns | 3.053 ns | +2.10 ns ✅ |

**300 MHz budget breakdown (3.333 ns period):**
- T_setup (FF): 0.080 ns
- T_clk2q (FF): 0.080 ns
- T_skew (CTS): 0.120 ns
- → Combinational budget: 3.053 ns

**Achievable without RTL change:** 300 MHz  
**Achievable with 2-stage AES pipeline:** ~400 MHz (RTL change to aes_ca_accel.v required)  
**Achievable with 3-stage AES pipeline:** ~580 MHz (theoretical)

---

## 15. SDC Constraints (300 MHz) — Key Points

File: `constraints/india_crypto_soc_300mhz.sdc`

```tcl
# Clock
create_clock -name clk -period 3.333 -waveform {0 1.667} [get_ports clk]
set_clock_uncertainty -setup 0.120 [get_clocks clk]
set_clock_uncertainty -hold  0.050 [get_clocks clk]
set_clock_transition 0.080 [get_clocks clk]
set_clock_latency -source 0.200 [get_clocks clk]

# OCV derating (5% on data, 0% on clock)
set_timing_derate -late  1.05 -cell_delay -data_path
set_timing_derate -early 0.95 -cell_delay -data_path

# Key multicycle paths
set_multicycle_path -setup 32 -from [get_cells u_cpu/u_mul_div/*] -to [get_cells u_cpu/mul_result_reg]
set_multicycle_path -hold  31 -from [get_cells u_cpu/u_mul_div/*] -to [get_cells u_cpu/mul_result_reg]
set_multicycle_path -setup  4 -from [get_cells u_trng/accum_reg*] -to [get_cells u_trng/accum_word_reg*]
set_multicycle_path -hold   3 -from [get_cells u_trng/accum_reg*] -to [get_cells u_trng/accum_word_reg*]
set_multicycle_path -setup  2 -from [get_cells u_aes_ca/key_sched_reg*] -to [get_cells u_aes_ca/round_key_reg*]
set_multicycle_path -hold   1 -from [get_cells u_aes_ca/key_sched_reg*] -to [get_cells u_aes_ca/round_key_reg*]

# False paths
set_false_path -from [get_ports rst_n]
set_false_path -from [get_ports rosc_ext] -to [get_cells u_trng/sync0_reg]
set_false_path -from [get_ports uart_rx]  -to [get_cells u_uart/rx_sync_reg[0]]
set_false_path -from [get_ports i2c_sda]  -to [get_cells u_i2c/sda_sync_reg[0]]

# Dont-touch (sync chains)
set_dont_touch [get_cells u_trng/sync0_reg]
set_dont_touch [get_cells u_trng/sync1_reg]
set_dont_touch [get_cells u_trng/sync2_reg]
set_dont_touch [get_cells u_trng/sync3_reg]
set_dont_touch [get_cells u_uart/rx_sync_reg*]
set_dont_touch [get_cells u_i2c/sda_sync_reg*]

# AES-CA max_delay advisory (tighter than period — prevents tool leaving slack on this path)
set_max_delay 2.400 -datapath_only \
    -from [get_cells u_aes_ca/aes_state_reg*] \
    -to   [get_cells u_aes_ca/aes_state_reg*]

# SRAM + ECC path advisory
set_max_delay 2.600 -datapath_only \
    -from [get_cells sram_reg*] -to [get_cells cpu_imem_rdata_reg*]
set_max_delay 2.600 -datapath_only \
    -from [get_cells sram_reg*] -to [get_cells xb_s1_rdata_reg*]
```

---

## 16. Synthesis Script Summary

File: `constraints/synth_300mhz.tcl`

```tcl
# Phase 1: area-optimised baseline
compile_ultra -no_autoungroup -retime

# Phase 2: incremental timing-driven
compile_ultra -incremental -retime -timing_high_effort_script

# Outputs
write -format verilog  -hierarchy -output $OUT_DIR/${DESIGN}_300mhz_netlist.v
write -format ddc                 -output $OUT_DIR/${DESIGN}_300mhz.ddc
write_sdc                                 $OUT_DIR/${DESIGN}_300mhz_final.sdc
write_sdf -version 3.0                    $OUT_DIR/${DESIGN}_300mhz.sdf
```

---

## 17. DFT Architecture (planned, not yet implemented in RTL)

### JTAG TAP (IEEE 1149.1)
Additional ports needed on top-level: `tck, tms, tdi, tdo, trst_n`

### Scan Chains
- ~24,500 FFs total → 6 parallel chains (~4,000 FFs each)
- Chain 1: AES-CA (key FFs muxed out when key is locked)
- Chain 2: CPU core
- Chain 3: PDF Engine
- Chain 4: TRNG (test_mode forces predictable seed)
- Chain 5: Fabric (crossbar + firewall)
- Chain 6: Peripherals

### MBIST
- MARCH-C algorithm on dual-port SRAM
- ECC inject test: force 1-bit and 2-bit errors, verify SEC/DED response
- Initiated via JTAG boundary scan

### ATPG Targets
- ≥ 98% stuck-at fault coverage
- ≥ 92% transition delay coverage

### Secure Scan Protocol
- Pre-provisioning: scan chains open for factory test
- Post-provisioning: scan shift blocked; encrypted JTAG required (key in OTP)
- AES-CA key FFs: muxed off scan chain unconditionally when `key_locked = 1`

---

## 18. Area Estimate

| Block | Area (mm²) | % |
|-------|-----------|---|
| SRAM macro (64 KB) | 0.210 | 32% |
| AES-CA accelerator | 0.130 | 20% |
| CPU core (RV32IM) | 0.095 | 15% |
| India PDF Engine | 0.065 | 10% |
| AXI fabric + firewall | 0.052 | 8% |
| TRNG + ECC + JTAG | 0.040 | 6% |
| I/O pads (10 pads) | 0.038 | 6% |
| ROM (32 KB) | 0.018 | 3% |
| **Total** | **0.648** | **100%** |

---

## 19. Security Architecture Summary

| Layer | Mechanism |
|-------|-----------|
| Physical | TSMC 28nm HPC; no backdoor scan post-provisioning |
| Memory | SEC-DED ECC on SRAM; sram_ded_sticky → seceng_irq |
| Bus | AXI firewall per slave; write-once lock; deny_irq on violation |
| CPU | Instruction parity; PC Range Guard; register ECC; WDT |
| Crypto | AES-256-CTR + CA perturbation; HMAC-before-decrypt |
| Entropy | Ring-oscillator TRNG; SP 800-90B health tests |
| Key | ATECC608B external SE; never appears on SPI bus |
| SPI | secure_mode gate; CS lock register; transfer length guard |
| Interrupt | seceng_irq aggregates all security events to CPU |

---

## 20. Anti-Tamper Literature Methods (from session research)

1. **Bulk Current Sensors (BCS)** — detect laser fault injection (LFI) by monitoring supply transients
2. **Voltage + Temperature monitors** — trip-point detectors fed to seceng_irq
3. **Active shields** — metal mesh over sensitive cells; break = zeroize keys
4. **True Random Number Generator health** — SP 800-90B RCT + APT (implemented)
5. **Memory scrambling** — address + data XOR with seed (can be added to SRAM interface)
6. **Dummy operations / constant-time CA** — AES-CA inherently data-independent timing due to fixed CA rule application
7. **Scan lock** — implemented in DFT plan above
8. **Power analysis countermeasures** — masking in SubBytes (future work)

---

## 21. Known Issues / Open Items

| # | Issue | Status |
|---|-------|--------|
| 1 | `ms_trng.v` still exists but is no longer instantiated | Archive / delete |
| 2 | 400 MHz: AES-CA needs 2-stage pipeline at CA-2/CA-3 boundary | RTL change pending |
| 3 | DFT RTL not yet written (JTAG TAP, MBIST, secure scan mux) | Planned |
| 4 | Testbench for top-level SoC not written | Planned |
| 5 | `set_operating_conditions SS_0P81V_125C` commented out in SDC | Uncomment when PDK library name confirmed |
| 6 | Presenter script PDF for deck not yet generated | Planned |
| 7 | `india_pdf_engine.v`: `cipher_decrypt` was hardwired 0 → FIXED to `decrypt_mode` | Done |
| 8 | `spi_cs_n` was [3:0] → FIXED to 1-bit single CS | Done |
| 9 | `deny_irq` missing from `axi_firewall.v` → FIXED, added to port + logic | Done |
| 10 | `ms_trng` instantiation in top → FIXED, replaced with `rosc_trng` | Done |

---

## 22. Glossary

| Term | Meaning |
|------|---------|
| CA | Cellular Automata (used to perturb AES state) |
| SEC-DED | Single-Error Correcting, Double-Error Detecting |
| TRNG | True Random Number Generator |
| RCT | Repetition Count Test (NIST SP 800-90B) |
| APT | Adaptive Proportion Test (NIST SP 800-90B) |
| WDT | Watchdog Timer |
| VN | Von Neumann debiaser |
| LFSR | Linear Feedback Shift Register (whitener) |
| OCV | On-Chip Variation (timing derating) |
| CTS | Clock Tree Synthesis |
| ATPG | Automatic Test Pattern Generation |
| MBIST | Memory Built-In Self-Test |
| JTAG | IEEE 1149.1 boundary scan protocol |
| GE | Gate Equivalent |
| SS corner | Slow-Slow process corner (worst-case timing) |
| TT corner | Typical-Typical process corner |
