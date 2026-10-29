# CRIYA SoC Verification Framework

SoC-level simulation and assertion infrastructure for the `india_crypto_soc` design.

---

## Directory Layout

```
dv/
├── Makefile                     # unit TBs + SoC-level targets (appended)
├── README_FRAMEWORK.md          # this file
│
├── tb/
│   ├── soc_tb.sv                # top-level SoC testbench
│   └── bfm/
│       ├── uart_bfm.sv          # UART BFM (send/receive + FIFO monitor)
│       ├── spi_bfm.sv           # SPI slave BFM
│       └── i2c_bfm.sv           # I2C slave BFM
│
├── sva/
│   ├── axil_checker.sv          # AXI-Lite protocol assertions
│   ├── reset_checker.sv         # Reset behaviour assertions
│   └── irq_checker.sv           # IRQ stability / coverage assertions
│
├── cov/
│   └── soc_cov.sv               # Functional coverage model (covergroups)
│
├── tests/sw/
│   ├── common/
│   │   ├── crt0.S               # Minimal RISC-V startup (sets sp, calls main)
│   │   ├── link.ld              # Linker script — code at 0x00010000 (SRAM)
│   │   ├── uart_print.h         # Header declarations
│   │   └── uart_print.c         # Polled UART helpers (uart_pass / uart_fail)
│   │
│   ├── aes_selftest.c           # AES-CA accelerator self-test
│   ├── trng_health.c            # TRNG health-check test
│   ├── uart_loopback.c          # UART TX→RX loopback test
│   └── gpio_test.c              # GPIO read/write test
│
└── scripts/
    └── soc_regress.py           # Parse sim logs, print table, exit 0/1
```

---

## Quick Start

### 1 — Compile SW tests (requires riscv32-unknown-elf-gcc)

```bash
cd dv
make sw_all            # compiles all four tests to .hex
# or individually:
make sw_compile_gpio_test
```

### 2 — Build the SoC testbench

```bash
make soc_tb            # VCS or Icarus detected automatically
```

### 3 — Run a single test

```bash
make soc_gpio_test     # loads tests/sw/gpio_test.hex, runs sim
```

### 4 — Run the full regression

```bash
make soc_regress       # runs all 4 tests, calls scripts/soc_regress.py
```

---

## Testbench Operation (`soc_tb.sv`)

| Feature | Detail |
|---|---|
| Clock | 10 ns period (100 MHz, matches sim speed) |
| Reset | rst_n low for 20 cycles, then released |
| ROSC clock | Free-running 7 ns toggle (async to main clk) |
| UART | TX → RX loopback; UART BFM monitors uart_tx |
| UART baud | 115200 — 868 clock cycles per bit |
| SPI MISO | Tied 0; SPI slave BFM logs received bytes |
| I2C | Pull-ups via `pullup` primitives; I2C slave BFM at addr 0x50 |
| GPIO in | Driven to 0xDEAD_BEEF |
| SRAM preload | `$readmemh("tests/sw/<test>.hex", sram_mem)` then `force` into DUT |
| Pass/Fail | Monitor uart_tx for "PASS\n" → `$finish(0)`, "FAIL\n" → `$finish(1)` |
| Watchdog | 5,000,000 cycles → "WATCHDOG TIMEOUT" + `$finish(1)` |
| VCD | Enabled with `+dump` plusarg, written to `sim_out/soc_tb/tb.vcd` |

---

## SVA Checkers

### `axil_checker.sv`
Plug-in AXI-Lite protocol checker. Parameterised by `DATA_W` / `ADDR_W`.
- Valid signals must not go X/Z after reset
- AWVALID/WVALID/ARVALID must stay asserted until corresponding READY
- BVALID must appear within 32 cycles of a write address+data handshake
- RVALID must appear within 32 cycles of a read address handshake
- BRESP and RRESP must be `2'b00` (OKAY)

### `reset_checker.sv`
- AWVALID and ARVALID stay deasserted for at least 4 cycles after reset release
- `seceng_irq` is 0 during reset
- `uart_tx` is 1 (idle) during reset

### `irq_checker.sv`
- `seceng_irq` must be stable for at least 2 cycles before de-asserting
- Cover: `seceng_irq` goes high at least once

All SVA files use `default clocking @(posedge clk)` and `disable iff (!rst_n)`.
They are wrapped in `` `ifndef SYNTHESIS `` guards and instantiated in `soc_tb.sv`
under `` `ifndef IVERILOG `` (Icarus does not support SVA).

---

## Functional Coverage (`soc_cov.sv`)

| Covergroup | What is covered |
|---|---|
| `cg_aes_ops` | AES key length (128/256) × direction (enc/dec) |
| `cg_gpio_dir` | gpio_dir: all-input / all-output / mixed |
| `cg_irq_sources` | TRNG RCT, TRNG APT, PDF done, UART RX irq |
| `cg_reset_cycles` | Reset duration: short (<10), nominal (10-50), long (>50) |

---

## SW Test Protocol

Each C test follows the same pattern:
1. Call `uart_init()` to configure 115200 8N1
2. Perform the device-under-test sequence
3. Call `uart_pass()` or `uart_fail()` which transmits "PASS\n" or "FAIL\n"

The testbench UART monitor detects these strings and calls `$finish(0/1)`.

---

## Address Map (reference)

| Slave | Base Address |
|---|---|
| ROM (8K×32) | 0x0000_0000 |
| SRAM (16K×32) | 0x0001_0000 |
| AES-CA | 0x1000_0000 |
| ROSC TRNG | 0x1001_0000 |
| India PDF engine | 0x1002_0000 |
| UART (APB) | 0x2000_0000 |
| I2C (APB) | 0x2001_0000 |
| SPI (APB) | 0x2002_0000 |
| CLINT | 0x0200_0000 |
| PLIC | 0x0C00_0000 |
| GPIO | 0x4000_0000 |

---

## Requirements

- **Simulator**: Synopsys VCS (preferred) or Icarus Verilog ≥ 11
- **SW compiler**: `riscv32-unknown-elf-gcc` (RV32IM, ilp32 ABI)
- **Python**: 3.6+ for `scripts/soc_regress.py`
- **SVA / covergroups**: VCS only; Icarus silently skips via `\`ifndef IVERILOG`
