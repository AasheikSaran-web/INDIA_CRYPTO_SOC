# INDIA_CRYPTO_SOC

Secure cryptographic SoC for **Aadhaar e-KYC PDF encryption** at UIDAI biometric terminals.  
Implemented in synthesisable Verilog/SystemVerilog, targeting **TSMC 28nm HPC** at **300 MHz / 0.9 V**.

---

## Architecture

```
                    ┌─────────────────────────────────────────────────┐
                    │               INDIA_CRYPTO_SOC                  │
                    │                                                 │
  clk/rst_n ──────▶│  ┌──────────────┐   AXI-Lite   ┌────────────┐  │
  rosc_ext  ──────▶│  │  RV32IM CPU  │◀────2×8 ────▶│  AES-256   │  │
  spi_mosi  ──────▶│  │  5-stage     │   Crossbar    │  + CA      │  │
  spi_miso  ◀──────│  │  pipeline    │               │ Accel      │  │
  spi_sck   ──────▶│  └──────────────┘               └────────────┘  │
  spi_cs_n  ◀──────│                                                 │
  uart_rx   ──────▶│  ┌──────────────┐               ┌────────────┐  │
  uart_tx   ◀──────│  │ India PDF    │◀─── DMA ──────│  64 KB     │  │
  i2c_sda   ◀─────▶│  │ Engine (FSM) │               │  SRAM      │  │
  i2c_scl   ◀──────│  └──────────────┘               │  SEC-DED   │  │
  seceng_irq◀──────│                                 └────────────┘  │
                    │  ┌──────────────┐               ┌────────────┐  │
                    │  │ RO-TRNG      │               │  AXI       │  │
                    │  │ SP 800-90B   │               │  Firewall  │  │
                    │  └──────────────┘               └────────────┘  │
                    └─────────────────────────────────────────────────┘
```

---

## Key Specifications

| Parameter | Value |
|-----------|-------|
| Process | TSMC 28nm HPC |
| Frequency | 300 MHz (signoff), 250 MHz (nominal) |
| Supply | 0.9 V core |
| Die area | ~0.648 mm² |
| ISA | RISC-V RV32IM |
| Crypto | AES-256-CTR + Cellular Automata perturbation |
| Memory | 64 KB SRAM (SEC-DED ECC) + 32 KB Boot ROM |
| I/O | 10 functional pins |
| Key storage | ATECC608B external secure element (I2C) |

---

## RTL Structure

```
rtl/
├── top/
│   └── india_crypto_soc.v          # Top-level SoC integration
├── core/
│   ├── rv32im_core.v               # RV32IM 5-stage CPU (parity, PC guard, WDT, ECC regfile)
│   └── aes_isa_ext.v               # AES custom ISA extension (custom0 opcode)
├── crypto/
│   ├── aes_ca_accel.v              # AES-256-CTR + 4-stage CA rounds
│   ├── india_pdf_engine.v          # 17-state PDF streaming FSM
│   ├── rosc_trng.v                 # Ring-oscillator TRNG (SP 800-90B RCT+APT)
│   ├── hamming_secded.v            # SEC-DED ECC encoder + decoder
│   └── ms_trng.v                   # [archived] original metastable-FF TRNG
├── fabric/
│   ├── axi_lite_xbar.v             # 2-master × 8-slave AXI-Lite crossbar
│   └── axi_firewall.v              # Per-slave write-once firewall
└── periph/
    ├── pulp_spi_wrap.sv            # SPI (single CS, secure_mode, length guard)
    ├── pulp_uart_wrap.sv           # UART
    ├── pulp_i2c_wrap.sv            # I2C (ATECC608B key fetch)
    ├── axil_to_apb.sv              # AXI-Lite → APB bridge
    └── pulp/                       # PULP IP sub-modules
```

---

## Security Features

| Feature | Implementation |
|---------|---------------|
| AES-256-CTR | 14 rounds + CA perturbation (Rule-90 + Rule-30) |
| HMAC-before-decrypt | Plaintext never released before MAC verification |
| SEC-DED ECC | Hamming(39,32) on all 64 KB SRAM — single-bit correct, double-bit detect |
| AXI Firewall | Per-slave write-once master allow-list; deny logs to `seceng_irq` |
| PC Range Guard | CSR 0xBC0/0xBC1 trap on out-of-range jump |
| Instruction parity | ROM bit-flip detection |
| TRNG health tests | SP 800-90B RCT (cutoff=30) + APT (window=512, threshold=397) |
| Watchdog Timer | 24-bit HW WDT; expired → `seceng_irq` |
| SPI secure_mode | CS deassert + SCK/MOSI gate when security policy active |
| Key isolation | ATECC608B key never appears on SPI bus; I2C slave firewall-isolated from DMA |

---

## AXI Slave Memory Map

| Slave | Module | Base Address |
|-------|--------|-------------|
| s0 | Boot ROM (32 KB) | `0x0000_0000` |
| s1 | SRAM (64 KB, ECC) | `0x0001_0000` |
| s2 | AES-CA Accelerator | `0x4000_0000` |
| s3 | India PDF Engine | `0x4001_0000` |
| s4 | TRNG | `0x4002_0000` |
| s5 | SPI | `0x4003_0000` |
| s6 | I2C (key fetch) | `0x4004_0000` |
| s7 | UART | `0x4005_0000` |

---

## Critical-Path Timing (SS/125°C/0.81V + 5% OCV)

| Path | Delay | Budget | Margin |
|------|-------|--------|--------|
| AES-CA round (reg→reg) | 1.81 ns | 3.05 ns | +1.24 ns ✅ |
| CPU barrel shifter | 1.40 ns | 3.05 ns | +1.65 ns ✅ |
| SRAM + ECC decode | 2.09 ns | 3.05 ns | +0.96 ns ✅ |
| AXI crossbar | 0.95 ns | 3.05 ns | +2.10 ns ✅ |

See [`synthesis/`](synthesis/) for full reports.

---

## Synthesis

Tool: **Synopsys Design Compiler** · Library: **sc9_cln28hpc_base_svt**  
Corner: **SS / 125°C / 0.81V** (worst-case timing signoff)

```bash
cd constraints
dc_shell -f synth_300mhz.tcl | tee synth_300mhz.log
```

Outputs land in `synthesis/` — netlist, SDC, SDF, area, power, and QoR reports.

---

## Constraints

| File | Purpose |
|------|---------|
| `constraints/india_crypto_soc_300mhz.sdc` | Primary SDC — clock, I/O delays, multicycle, false paths, OCV |
| `constraints/synth_300mhz.tcl` | DC synthesis run script (two-pass `compile_ultra`) |

---

## Pin Assignment

| Pin | Dir | Function |
|-----|-----|---------|
| clk | in | 300 MHz system clock |
| rst_n | in | Async active-low reset |
| spi_mosi | in | SPI data in |
| spi_miso | out | SPI data out |
| spi_sck | in | SPI clock |
| spi_cs_n | out | Chip select (CS0 only) |
| uart_rx | in | UART receive |
| uart_tx | out | UART transmit |
| i2c_sda | inout | I2C data (ATECC608B) |
| i2c_scl | out | I2C clock |
| rosc_ext | in | External entropy (ring-oscillator) |
| seceng_irq | out | Aggregated security interrupt |

---

## License

MIT — see [LICENSE](LICENSE)
