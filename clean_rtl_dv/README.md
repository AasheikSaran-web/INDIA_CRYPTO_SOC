# INDIA_CRYPTO_SOC — Clean RTL & DV Reference

AES-CA Accelerated RISC-V SoC for Indian Government Document Encryption  
Target applications: Aadhaar PDF (UIDAI), Government Documents (NIC/DigiLocker), Medical Records (ABDM/HL7 FHIR)

---

## Directory Structure

```
clean_rtl_dv/
├── rtl/
│   ├── top/                   SoC integration (entry point)
│   │   └── india_crypto_soc.v
│   ├── core/                  CPU and ISA extension
│   │   ├── rv32im_core.v
│   │   ├── aes_isa_ext.v
│   │   └── picorv32.v
│   ├── crypto/                Cryptographic engines
│   │   ├── aes_ca_accel.v
│   │   ├── india_pdf_engine.v
│   │   ├── rosc_trng.v
│   │   ├── hamming_secded.v
│   │   ├── verhoeff_check.v
│   │   └── aadhaar_id_check.v
│   ├── mem/                   Memory subsystem
│   │   ├── boot_rom.v
│   │   ├── sram_ctrl.v
│   │   └── sram_sp_wrap.v
│   ├── fabric/                Interconnect
│   │   └── axi_lite_xbar.v
│   └── periph/                Peripherals
│       ├── gpio.v
│       ├── clint.v
│       ├── plic.v
│       ├── axil_to_apb.sv
│       ├── pulp_uart_wrap.sv
│       ├── pulp_i2c_wrap.sv
│       ├── pulp_spi_wrap.sv
│       └── vendor/
│           ├── pulp_blackbox.v
│           ├── uart/
│           │   ├── apb_uart.sv
│           │   └── apb_uart_wrap.sv
│           ├── i2c/
│           │   ├── apb_i2c.sv
│           │   ├── i2c_master_bit_ctrl.sv
│           │   ├── i2c_master_byte_ctrl.sv
│           │   └── i2c_master_defines.sv
│           ├── spi/
│           │   ├── apb_spi_master.sv
│           │   ├── spi_master_apb_if.sv
│           │   ├── spi_master_clkgen.sv
│           │   ├── spi_master_controller.sv
│           │   ├── spi_master_fifo.sv
│           │   ├── spi_master_rx.sv
│           │   └── spi_master_tx.sv
│           └── include/apb/
│               ├── assign.svh
│               └── typedef.svh
└── dv/
    └── tb/
        └── unit/              Unit testbenches (one per RTL module)
            ├── tb_soc_aadhaar.sv
            ├── tb_aes_ca_accel.sv
            ├── tb_aes_isa_ext.sv
            ├── tb_india_pdf_engine.sv
            ├── tb_rosc_trng.sv
            ├── tb_hamming_secded.sv
            ├── tb_verhoeff_check.sv
            ├── tb_aadhaar_id_check.sv
            ├── tb_sram_sp_wrap.sv
            ├── tb_sram_ctrl.sv
            ├── tb_boot_rom.sv
            ├── tb_axi_lite_xbar.sv
            ├── tb_axil_to_apb.sv
            ├── tb_gpio.sv
            ├── tb_clint.sv
            ├── tb_plic.sv
            ├── tb_pulp_uart_wrap.sv
            ├── tb_pulp_i2c_wrap.sv
            ├── tb_pulp_spi_wrap.sv
            └── tb_rv32im_core.sv
```

---

## RTL Hierarchy — From Entry Point to Leaves

The design has a single top-level module. Every other module is instantiated directly or indirectly beneath it.

```
india_crypto_soc                          rtl/top/india_crypto_soc.v
│
├── rv32im_core          (u_cpu)          rtl/core/rv32im_core.v
│   └── aes_isa_ext      (u_aes_isa)     rtl/core/aes_isa_ext.v
│                                         (custom opcode hook — wired directly into CPU)
│
├── axi_lite_xbar        (u_xbar)         rtl/fabric/axi_lite_xbar.v
│   └── (2 masters, 11 slaves — see Memory Map below)
│
├── ── CRYPTO BLOCK ──────────────────────────────────────────────
│   ├── rosc_trng        (u_trng)         rtl/crypto/rosc_trng.v
│   ├── aes_ca_accel     (u_aes_ca)       rtl/crypto/aes_ca_accel.v
│   │   └── hamming_secded               rtl/crypto/hamming_secded.v
│   └── india_pdf_engine (u_pdf)          rtl/crypto/india_pdf_engine.v
│       ├── verhoeff_check               rtl/crypto/verhoeff_check.v
│       └── aadhaar_id_check             rtl/crypto/aadhaar_id_check.v
│           └── verhoeff_check           rtl/crypto/verhoeff_check.v
│
├── ── MEMORY BLOCK ──────────────────────────────────────────────
│   ├── boot_rom         (u_boot_rom)     rtl/mem/boot_rom.v
│   └── sram_ctrl        (u_sram_ctrl)   rtl/mem/sram_ctrl.v
│       └── sram_sp_wrap (u_sram)        rtl/mem/sram_sp_wrap.v
│
├── ── PERIPHERAL BLOCK ──────────────────────────────────────────
│   ├── clint            (u_clint)        rtl/periph/clint.v
│   ├── plic             (u_plic)         rtl/periph/plic.v
│   ├── gpio             (u_gpio)         rtl/periph/gpio.v
│   ├── pulp_uart_wrap   (u_uart)         rtl/periph/pulp_uart_wrap.sv
│   │   └── axil_to_apb                  rtl/periph/axil_to_apb.sv
│   │       └── apb_uart_wrap            rtl/periph/vendor/uart/apb_uart_wrap.sv
│   │           └── apb_uart             rtl/periph/vendor/uart/apb_uart.sv
│   ├── pulp_i2c_wrap    (u_i2c)          rtl/periph/pulp_i2c_wrap.sv
│   │   └── axil_to_apb                  rtl/periph/axil_to_apb.sv
│   │       └── apb_i2c                  rtl/periph/vendor/i2c/apb_i2c.sv
│   │           ├── i2c_master_byte_ctrl rtl/periph/vendor/i2c/i2c_master_byte_ctrl.sv
│   │           │   └── i2c_master_bit_ctrl  rtl/periph/vendor/i2c/i2c_master_bit_ctrl.sv
│   │           └── i2c_master_defines   rtl/periph/vendor/i2c/i2c_master_defines.sv
│   └── pulp_spi_wrap    (u_spi)          rtl/periph/pulp_spi_wrap.sv
│       └── axil_to_apb                  rtl/periph/axil_to_apb.sv
│           └── apb_spi_master           rtl/periph/vendor/spi/apb_spi_master.sv
│               ├── spi_master_apb_if    rtl/periph/vendor/spi/spi_master_apb_if.sv
│               ├── spi_master_clkgen    rtl/periph/vendor/spi/spi_master_clkgen.sv
│               ├── spi_master_controller rtl/periph/vendor/spi/spi_master_controller.sv
│               ├── spi_master_fifo      rtl/periph/vendor/spi/spi_master_fifo.sv
│               ├── spi_master_rx        rtl/periph/vendor/spi/spi_master_rx.sv
│               └── spi_master_tx        rtl/periph/vendor/spi/spi_master_tx.sv
│
└── picorv32             (optional alt CPU)  rtl/core/picorv32.v
```

> **Shared include:** `rtl/periph/vendor/include/apb/assign.svh` and `typedef.svh` are SystemVerilog package headers included by `axil_to_apb.sv` and the APB peripheral wrappers.

---

## Memory Map (AXI-Lite Crossbar Slaves)

| Address Range | Size | Slave | RTL File |
|---|---|---|---|
| `0x0000_0000 – 0x0000_7FFF` | 32 KB | Boot ROM | `rtl/mem/boot_rom.v` |
| `0x0200_0000 – 0x0200_0FFF` | 4 KB | CLINT | `rtl/periph/clint.v` |
| `0x0C00_0000 – 0x0C00_0FFF` | 4 KB | PLIC | `rtl/periph/plic.v` |
| `0x2000_0000 – 0x2007_FFFF` | 512 KB | SRAM | `rtl/mem/sram_ctrl.v` → `sram_sp_wrap.v` |
| `0x3000_0000 – 0x3000_0FFF` | 4 KB | AES-CA Accel | `rtl/crypto/aes_ca_accel.v` |
| `0x3000_1000 – 0x3000_1FFF` | 4 KB | ROSC-TRNG | `rtl/crypto/rosc_trng.v` |
| `0x3000_2000 – 0x3000_2FFF` | 4 KB | India PDF Engine | `rtl/crypto/india_pdf_engine.v` |
| `0x4000_0000 – 0x4000_0FFF` | 4 KB | Secure UART | `rtl/periph/pulp_uart_wrap.sv` |
| `0x4000_1000 – 0x4000_1FFF` | 4 KB | Secure I2C | `rtl/periph/pulp_i2c_wrap.sv` |
| `0x4000_2000 – 0x4000_2FFF` | 4 KB | Secure SPI | `rtl/periph/pulp_spi_wrap.sv` |
| `0x4000_3000 – 0x4000_3FFF` | 4 KB | GPIO | `rtl/periph/gpio.v` |

**AXI Masters:**
- `m0` — CPU data bus (`rv32im_core` dmem port) — trusted, HIGH priority
- `m1` — India PDF Engine DMA — semi-trusted, LOW priority

---

## Data Flow: Aadhaar PDF Encryption

This is the path data takes through the RTL from boot to ciphertext output.

```
1. RESET
   CPU starts at 0x0000_0000
   → boot_rom.v  (rtl/mem/boot_rom.v)
     returns NOP sled + jump to SRAM firmware

2. ENTROPY COLLECTION
   CPU polls ROSC-TRNG STATUS register (0x3000_1000)
   → rosc_trng.v  (rtl/crypto/rosc_trng.v)
     reads 12 × 32-bit words → 256-bit KEY + 128-bit NONCE

3. DOCUMENT LOAD
   PDF bytes DMA'd or CPU-written into SRAM (0x2000_0000)
   → sram_ctrl.v → sram_sp_wrap.v  (rtl/mem/)
     512 KB single-port SRAM holds plaintext source + ciphertext destination

4. ENCRYPTION TRIGGER
   CPU writes India PDF Engine registers (0x3000_2000):
     APP_MODE, SRC_ADDR, DST_ADDR, PDF_LEN, KEY[0..7], NONCE[0..3]
   → india_pdf_engine.v  (rtl/crypto/india_pdf_engine.v)
       ├── verhoeff_check.v    Verhoeff checksum on Aadhaar UID digits
       └── aadhaar_id_check.v  12-digit UID format validation
             └── verhoeff_check.v

5. AES BLOCK CIPHER CORE
   PDF engine streams 128-bit blocks to AES-CA accelerator (0x3000_0000)
   → aes_ca_accel.v  (rtl/crypto/aes_ca_accel.v)
       └── hamming_secded.v    ECC on register file (fault injection hardening)
     AES-256 with CA-1 cellular automaton SubBytes perturbation
     Ciphertext written back to SRAM DST_ADDR via AXI DMA

6. INTERRUPT & STATUS
   PDF engine fires pdf_irq → PLIC (0x0C00_0000) → CPU ext_irq
   → plic.v  (rtl/periph/plic.v)
   CPU reads STATUS, reads RESULT_TAG[0..3] (128-bit HMAC tag)

7. OUTPUT / COMMS
   Ciphertext at DST_ADDR in SRAM; CPU can forward via:
   → pulp_uart_wrap.sv → axil_to_apb.sv → apb_uart_wrap.sv → apb_uart.sv
   → pulp_i2c_wrap.sv  → axil_to_apb.sv → apb_i2c.sv → i2c_master_*.sv
   → pulp_spi_wrap.sv  → axil_to_apb.sv → apb_spi_master.sv → spi_master_*.sv

8. TIMER / WATCHDOG
   Free-running mtime counter, mtimecmp compare → timer_irq to CPU
   → clint.v  (rtl/periph/clint.v)

9. GPIO
   32-pin interrupt-on-change I/O for status LEDs / external triggers
   → gpio.v  (rtl/periph/gpio.v)
```

---

## Module Reference

### `rtl/top/india_crypto_soc.v`
Top-level integration module. Instantiates all subsystems, wires the AXI-Lite crossbar, connects interrupts (CLINT → timer_irq/soft_irq, PLIC → ext_irq), and routes custom ISA opcode signals between CPU and AES ISA extension.

### `rtl/core/rv32im_core.v`
RV32IM 5-stage pipeline (IF/ID/EX/MEM/WB). Features: instruction parity check, PC range guard (CSRs `0xBC0`/`0xBC1`), register file ECC, 24-bit watchdog. Exposes two AXI-Lite ports (imem read-only, dmem read-write) and a custom instruction hook for `aes_isa_ext`.

### `rtl/core/aes_isa_ext.v`
Combinational custom opcode extension. Decodes custom-0 encoded AES round instructions and returns results in a single cycle back to the CPU pipeline via the `custom_rd` / `custom_rd_valid` handshake.

### `rtl/core/picorv32.v`
Alternative compact RV32IMC soft-core (PicoRV32). Not used in the default SoC build; included for resource-constrained variants.

### `rtl/crypto/aes_ca_accel.v`
AES-256 block cipher accelerator with CA-1 cellular automaton rule perturbation in SubBytes. Register interface at `0x3000_0000`: write KEY/DIN, assert START, poll STATUS done, read DOUT. Also contains the `hamming_secded` sub-instance for register-file ECC.

### `rtl/crypto/india_pdf_engine.v`
DMA-driven streaming encrypt/decrypt engine. Reads PDF blocks from SRAM SRC_ADDR, passes them through AES-CA, writes ciphertext to DST_ADDR. Generates HMAC tag stored in RESULT_TAG. Supports three APP_MODEs: Aadhaar (0), GovDoc (1), Medical (2). Fires `pdf_irq` on completion.

### `rtl/crypto/rosc_trng.v`
Ring-oscillator metastable TRNG. Passes NIST SP 800-90B Repetition Count Test (RCT) and Adaptive Proportion Test (APT) health checks. `trng_fail` interrupt fires on health-test failure.

### `rtl/crypto/hamming_secded.v`
Hamming (7,4) SEC-DED ECC encoder/decoder. Used inside `aes_ca_accel` to protect the AES key schedule register file against single-event upsets and fault injection.

### `rtl/crypto/verhoeff_check.v`
Hardware Verhoeff checksum calculator for the 12-digit Aadhaar UID. Used by `india_pdf_engine` and `aadhaar_id_check` to validate document IDs before encryption.

### `rtl/crypto/aadhaar_id_check.v`
Validates full Aadhaar UID format: 12-digit length, numeric digits only, Verhoeff checksum. Returns `valid` / `invalid` to the PDF engine before it processes any document.

### `rtl/mem/boot_rom.v`
32 KB read-only boot ROM at `0x0000_0000`. Returns NOP (`0x00000013`) for uninitialized addresses. CPU fetches first instruction here at reset.

### `rtl/mem/sram_ctrl.v`
AXI-Lite slave controller for the single-port SRAM. Arbitrates between CPU data-bus (master 0) and PDF Engine DMA (master 1) with write-priority, 2-cycle read pipeline. 17-bit word-address bus for 512 KB (131,072 × 32-bit words).

### `rtl/mem/sram_sp_wrap.v`
Single-port SRAM wrapper. In simulation (`HARD_MACRO` not defined) uses a Verilog register array. In silicon uses the `TS1N28HPCPSVTB131072X32M8SW` TSMC 28nm HPC macro. Byte-write enables on 4 lanes.

### `rtl/fabric/axi_lite_xbar.v`
2-master × 11-slave AXI-Lite crossbar. Decodes target slave by address using base/mask pairs. CPU (m0) has priority over DMA (m1) when both target the same slave.

### `rtl/periph/clint.v`
RISC-V Core Local Interruptor. 64-bit free-running `mtime` counter and `mtimecmp` compare register. Asserts `timer_irq` when `mtime >= mtimecmp`. Also drives `soft_irq` via `msip`.

### `rtl/periph/plic.v`
Platform-Level Interrupt Controller. 8 interrupt sources (UART, I2C, SPI, PDF Engine, GPIO, TRNG fail, 2× reserved). Priority arbitration with threshold; `claim_complete` handshake to CPU.

### `rtl/periph/gpio.v`
32-bit general-purpose I/O. Per-pin direction control, interrupt-on-any-edge with status and enable registers.

### `rtl/periph/axil_to_apb.sv`
AXI-Lite to APB bridge. Converts AXI-Lite read/write transactions into APB PSEL/PENABLE/PREADY cycles. Used by all three peripheral wrappers (UART, I2C, SPI).

### `rtl/periph/pulp_uart_wrap.sv` → `vendor/uart/apb_uart_wrap.sv` → `vendor/uart/apb_uart.sv`
Secure UART chain. The wrapper bridges AXI-Lite to APB, then `apb_uart_wrap` adapts the APB interface to the `apb_uart` PULP core. Features: RX glitch filter, baud-rate lock, frame-error attack detection, secure-mode lockout.

### `rtl/periph/pulp_i2c_wrap.sv` → `vendor/i2c/apb_i2c.sv` → `i2c_master_byte_ctrl.sv` → `i2c_master_bit_ctrl.sv`
Secure I2C master chain. `apb_i2c` implements the byte-level state machine; `i2c_master_byte_ctrl` manages START/STOP/ACK; `i2c_master_bit_ctrl` drives the SCL/SDA bit-level timing. Features: device whitelist (4 entries), bus-stuck recovery (9-pulse), SDA glitch filter.

### `rtl/periph/pulp_spi_wrap.sv` → `vendor/spi/apb_spi_master.sv` → (6 sub-modules)
Secure SPI master chain. `apb_spi_master` orchestrates the APB interface; sub-modules handle clock generation, TX/RX FIFOs, controller state machine, and APB IF. Features: hardware CS guard, transfer-length enforcement, per-CS lockout.

---

## Testbench — Unit Test Coverage

All testbenches live in `dv/tb/unit/`. Run with **iverilog + vvp** (SystemVerilog 2012).

| Testbench | DUT | Tests |
|---|---|---|
| `tb_soc_aadhaar.sv` | Full AES-CA + PDF Engine integration | 150 (TC0–TC149; includes GROUP 8: full 31,568-block JPEG image encrypt+decrypt) |
| `tb_aes_ca_accel.sv` | `aes_ca_accel.v` | AES-256 encrypt/decrypt, CA rule variants |
| `tb_aes_isa_ext.sv` | `aes_isa_ext.v` | Custom opcode decode and round results |
| `tb_india_pdf_engine.sv` | `india_pdf_engine.v` | Aadhaar/GovDoc/Medical APP_MODE flows |
| `tb_rosc_trng.sv` | `rosc_trng.v` | Entropy output, RCT/APT health tests |
| `tb_hamming_secded.sv` | `hamming_secded.v` | Single-bit correction, double-bit detection |
| `tb_verhoeff_check.sv` | `verhoeff_check.v` | Valid/invalid UID checksums |
| `tb_aadhaar_id_check.sv` | `aadhaar_id_check.v` | UID format + Verhoeff validation |
| `tb_sram_sp_wrap.sv` | `sram_sp_wrap.v` | 50 read/write/byte-enable tests |
| `tb_sram_ctrl.sv` | `sram_ctrl.v` | 50 AXI-Lite arbitration and pipeline tests |
| `tb_boot_rom.sv` | `boot_rom.v` | Read-only, NOP return, boundary checks |
| `tb_axi_lite_xbar.sv` | `axi_lite_xbar.v` | Master arbitration, address decode |
| `tb_axil_to_apb.sv` | `axil_to_apb.sv` | AXI→APB transaction bridging |
| `tb_gpio.sv` | `gpio.v` | Direction, data, interrupt edge detection |
| `tb_clint.sv` | `clint.v` | mtime count, mtimecmp compare, IRQ |
| `tb_plic.sv` | `plic.v` | Priority arbitration, claim/complete |
| `tb_pulp_uart_wrap.sv` | `pulp_uart_wrap.sv` + vendor chain | TX/RX loopback, baud, error detection |
| `tb_pulp_i2c_wrap.sv` | `pulp_i2c_wrap.sv` + vendor chain | START/STOP, ACK, whitelist enforcement |
| `tb_pulp_spi_wrap.sv` | `pulp_spi_wrap.sv` + vendor chain | Full-duplex transfer, CS guard, length limit |
| `tb_rv32im_core.sv` | `rv32im_core.v` | RV32IM instruction set, PC guard, WDT |

### How to compile and run (from `dv/tb/unit/`)

```bash
# Integration testbench (AES + PDF Engine)
iverilog -g2012 \
  ../../../rtl/crypto/aes_ca_accel.v \
  ../../../rtl/crypto/india_pdf_engine.v \
  ../../../rtl/crypto/verhoeff_check.v \
  ../../../rtl/crypto/aadhaar_id_check.v \
  tb_soc_aadhaar.sv && vvp a.out

# SRAM controller
iverilog -g2012 \
  ../../../rtl/mem/sram_ctrl.v \
  ../../../rtl/mem/sram_sp_wrap.v \
  tb_sram_ctrl.sv && vvp a.out

# UART (with full vendor chain)
iverilog -g2012 \
  -I ../../../rtl/periph/vendor/include \
  ../../../rtl/periph/axil_to_apb.sv \
  ../../../rtl/periph/vendor/uart/apb_uart_wrap.sv \
  ../../../rtl/periph/vendor/uart/apb_uart.sv \
  ../../../rtl/periph/pulp_uart_wrap.sv \
  tb_pulp_uart_wrap.sv && vvp a.out
```

---

## Signal Flow Diagram

```
  External Pins
  ─────────────
  clk / rst_n ──────────────────────────────────┐
  uart_rx/tx ────────────────────────────────┐  │
  i2c_sda/scl ────────────────────────────┐  │  │
  spi_mosi/miso/sck/cs_n ──────────────┐  │  │  │
  gpio_in[31:0] / gpio_out / gpio_dir ─┤  │  │  │
  rosc_ext (TRNG entropy source) ──────┤  │  │  │
                                        │  │  │  │
        ┌───────────────────────────────┼──┼──┼──┼──────┐
        │          india_crypto_soc     │  │  │  │      │
        │                               │  │  │  │      │
        │  ┌──────────────┐  imem   ┌───┘  │  │  │      │
        │  │ rv32im_core  ├─────────► boot_rom │  │      │
        │  │   + aes_isa  │  dmem   │      │  │  │      │
        │  │   _ext       ├─────────► axi_lite_xbar      │
        │  └──────────────┘         └──────┬──┬──┬──┐   │
        │                                  │  │  │  │   │
        │          ┌───────────────────────┘  │  │  │   │
        │          │  ┌────────────────────────┘  │  │   │
        │          │  │  ┌─────────────────────────┘  │   │
        │          │  │  │  ┌──────────────────────────┘   │
        │          │  │  │  │                              │
        │        sram  aes  pdf  uart/i2c/spi  clint plic gpio
        │        ctrl  ca   eng  wrappers                  │
        │          │   accel ine  └──┬──────               │
        │          │        │       └─────── vendor cores  │
        │        sram_sp    │                              │
        │        _wrap    trng                             │
        └────────────────────────────────────────────────-┘
```

---

*All files in `clean_rtl_dv/` have block comments removed and carry one-liner function annotations. Source of truth for full comments: `rtl/` and `dv/` in the project root.*
