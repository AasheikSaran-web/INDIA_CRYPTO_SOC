// =============================================================================
// india_crypto_soc.v  —  Top-Level SoC Integration
// Project  : INDIA_CRYPTO_SOC
// Process  : TSMC 28nm HPC
// Target   : 250 MHz @ 0.9V  |  Core ~0.468 mm²  |  Die ~0.648 mm²
// Author   : Aadhaar Secure Element Design Team
//
// ─── MEMORY MAP ──────────────────────────────────────────────────────────────
//   0x0000_0000 – 0x0000_7FFF : Boot ROM          (32 KB)  — xbar slave 0
//   0x2000_0000 – 0x2000_FFFF : SRAM              (64 KB)  — xbar slave 1
//                                  Port A = CPU IMEM (32 KB, read-only, direct)
//                                  Port B = CPU DMEM + DMA (32 KB, R/W)
//   0x3000_0000 – 0x3000_0FFF : AES-CA Accel      (4 KB)   — xbar slave 2  [FW]
//   0x3000_1000 – 0x3000_1FFF : Ring-Osc TRNG     (4 KB)   — xbar slave 3  [FW]
//   0x3000_2000 – 0x3000_2FFF : India PDF Engine  (4 KB)   — xbar slave 4  [FW]
//   0x4000_0000 – 0x4000_0FFF : Secure UART       (4 KB)   — xbar slave 5  [FW]
//   0x4000_1000 – 0x4000_1FFF : Secure I2C        (4 KB)   — xbar slave 6  [FW]
//   0x4000_2000 – 0x4000_2FFF : Secure SPI        (4 KB)   — xbar slave 7  [FW]
//
// ─── CROSSBAR MASTERS ────────────────────────────────────────────────────────
//   m0 = rv32im_core dmem   (CPU data bus, priority master)
//   m1 = india_pdf_engine   (DMA master, SRAM-only by firewall policy)
//
// ─── 10-PIN I/O ASSIGNMENT ───────────────────────────────────────────────────
//   clk        (given, not counted)
//   1  rst_n        IN   Active-low async reset
//   2  spi_mosi     IN   PDF data from host (ENCRYPT input / DECRYPT input)
//   3  spi_miso     OUT  Processed PDF to host (ENCRYPT output / DECRYPT output)
//   4  spi_sck      IN   SPI clock
//   5  spi_cs_n     IN   SPI chip select (single CS)
//   6  uart_rx      IN   Command channel
//   7  uart_tx      OUT  Response + IRQ mux (idle-state IRQ signaling)
//   8  i2c_sda      BIDIR Key provisioning / ATECC608B secure element
//   9  i2c_scl      IN   I2C clock
//  10  rosc_ext     IN   Ring-oscillator external dither / TRNG entropy injection
//
// ─── SECURITY ARCHITECTURE ───────────────────────────────────────────────────
//   • AXI Firewall per protected slave (s2..s7): write-once lock 0xDEAD_BEEF
//   • CPU (master_id=0) allowed on all firewalled slaves by default
//   • PDF DMA (master_id=1) allowed on SRAM (s1) ONLY — denied on all others
//   • Firewall deny events → fw_deny_irq → aggregated to CPU ext_irq
//   • Key material arrives via I2C (ATECC608B) — never on SPI data bus
//   • TRNG IV generated fresh per AES-CTR session (SP 800-90B: RCT + APT)
//   • DECRYPT: CA-HMAC verified BEFORE plaintext released on SPI output
//
// ─── AES-CA ACCELERATOR ──────────────────────────────────────────────────────
//   AES-256 CTR, 14 rounds, each with 4 CA stages:
//     CA-1: SubBytes   + Rule-90 perturbation
//     CA-2: ShiftRows  (standard)
//     CA-3: MixColumns in GF(2^8)
//     CA-4: AddRoundKey + Rule-30 perturbation
//   Supports ENCRYPT (cipher_decrypt=0) and DECRYPT (cipher_decrypt=1) modes.
//   Decrypt uses inverse CA: InvSubBytes, InvShiftRows, InvMixColumns.
//
// ─── INDIA PDF ENGINE ────────────────────────────────────────────────────────
//   17-state FSM — APP_MODE register selects operation:
//     APP_MODE=0: ENCRYPT  (IV from TRNG, CA-HMAC appended)
//     APP_MODE=1: DECRYPT  (IV from ciphertext header, CA-HMAC verified first)
//     APP_MODE=2: HMAC-ONLY verification (no AES, tag check only)
//   CA-HMAC: Rule-30 based, 8 iterations, 256-bit output
//   Streams entire PDF binary (text + embedded images) as byte sequence.
//   On HMAC mismatch (APP_MODE=1): IRQ raised, SPI output blocked, deny logged.
//
// ─── RING-OSCILLATOR TRNG ────────────────────────────────────────────────────
//   Replaces metastable-FF design (28nm HPC: metastability window too narrow)
//   Per ISSCC 2023: synthesized ring-osc jitter → 23 Mb/s @ 23 pJ/b in 28nm
//   Stages: Ring-Osc → Jitter Sampler → Von Neumann Debiaser →
//           Galois LFSR → SP 800-90B Health Tests (RCT + APT) → Output FIFO
//   rosc_ext: external clock injection for frequency dithering
//
// ─── I2C / ATECC608B KEY LOADING ─────────────────────────────────────────────
//   ATECC608B (UDFN-8, 2x3mm) connected on i2c_sda/scl (I2C addr 0x60)
//   Key provisioned at factory via HSM; locked after write (read-back disabled)
//   Firmware key-load sequence (runs from IMEM):
//     1. I2C Wake token → send command → read 32-byte AES-256 key
//     2. Write key to AES-CA KEY register via AXI-Lite (addr 0x3000_0010..2C)
//     3. Write IV (from TRNG) to AES-CA IV register (addr 0x3000_0030..3C)
//     4. Write APP_MODE to PDF Engine (addr 0x3000_2000)
//     5. Assert PDF Engine START — hardware takes over
//   Key material NEVER appears on SPI bus (firewall blocks DMA from s6).
//
// ─── AREA ESTIMATES (28nm HPC, Trikarenos-calibrated) ────────────────────────
//   SRAM 64 KB    : 0.110 mm²   Boot ROM 32 KB : 0.017 mm²
//   AXI Crossbar  : 0.031 mm²   AXI Firewall   : 0.019 mm²
//   RV32IM CPU    : 0.070 mm²   AES-CA Accel   : 0.155 mm²
//   India PDF Eng : 0.023 mm²   Ring-Osc TRNG  : 0.005 mm²
//   APB Bridges×3 : 0.023 mm²   Pad ring       : 0.150 mm²
//   Core total    : 0.468 mm²   Total die       : 0.648 mm²
// =============================================================================

`timescale 1ns/1ps
`default_nettype none

module india_crypto_soc (
    // ── Clock & Reset ───────────────────────────────────────────────────────
    input  logic        clk,            // System clock (250 MHz target)
    input  logic        rst_n,          // Active-low async reset (pin 1)

    // ── TRNG Entropy Input ──────────────────────────────────────────────────
    input  logic        rosc_ext,       // Ring-osc dither / external entropy (pin 10)

    // ── UART (Control Plane) ────────────────────────────────────────────────
    input  logic        uart_rx,        // Command channel from host (pin 6)
    output logic        uart_tx,        // Response + IRQ mux idle-state (pin 7)

    // ── I2C (Key Management Plane) ──────────────────────────────────────────
    inout  wire         i2c_sda,        // Key provisioning / ATECC608B (pin 8)
    inout  wire         i2c_scl,        // I2C clock (pin 9)

    // ── SPI (PDF Data Plane) ────────────────────────────────────────────────
    input  logic        spi_mosi,       // PDF data in from host (pin 2)
    output logic        spi_miso,       // Processed PDF to host (pin 3)
    input  logic        spi_sck,        // SPI clock (pin 4)
    output logic        spi_cs_n,       // SPI chip select — single CS (pin 5)

    // ── Security IRQ (aggregated, available for debug) ──────────────────────
    output logic        seceng_irq      // PDF done + firewall deny + ECC fatal
);

// =============================================================================
// Local Parameters
// =============================================================================
localparam SRAM_WORDS   = 16384;   // 64 KB / 4B  (32 KB IMEM port A + 32 KB DMEM port B)
localparam ROM_WORDS    = 8192;    // 32 KB / 4B  boot ROM
localparam SRAM_AW      = 14;      // log2(16384) = 14-bit word address
localparam ROM_AW       = 13;      // log2(8192)  = 13-bit word address

// Firewall permission: bit[0]=CPU allowed, bit[1]=DMA allowed
// CPU (master_id=0) allowed on all firewalled slaves; DMA denied everywhere
localparam [31:0] FW_CPU_ONLY    = 32'h0000_0001;

// AES-CA register offsets (within 4KB slave window)
localparam KEY_REG_BASE  = 12'h010;  // 0x010..0x02C: AES-256 key (32 bytes, 8 regs)
localparam IV_REG_BASE   = 12'h030;  // 0x030..0x03C: IV / CTR (16 bytes, 4 regs)
localparam AES_CTRL_REG  = 12'h000;  // 0x000: {start, decrypt, mode[1:0]}
localparam AES_STAT_REG  = 12'h004;  // 0x004: {done, busy, hmac_ok, hmac_err}

// PDF Engine register offsets
localparam PDF_CTRL_REG  = 12'h000;  // 0x000: {start, app_mode[1:0], rst_fsm}
localparam PDF_STAT_REG  = 12'h004;  // 0x004: {done, hmac_ok, hmac_err, busy}
localparam PDF_LEN_REG   = 12'h008;  // 0x008: PDF byte length
localparam PDF_TAG_REG   = 12'h010;  // 0x010..0x02C: CA-HMAC tag (32 bytes, 8 regs)

// TRNG register offsets
localparam TRNG_DATA_REG = 12'h000;  // 0x000: 32-bit random word (read = consume)
localparam TRNG_STAT_REG = 12'h004;  // 0x004: {valid, rct_fail, apt_fail, fifo_full}
localparam TRNG_CTRL_REG = 12'h008;  // 0x008: {enable, test_mode, bypass_vn}

// =============================================================================
// Wire Declarations — CPU Buses
// =============================================================================

// CPU IMEM (read-only, Port A of SRAM — bypasses crossbar)
logic [31:0] cpu_imem_araddr;
logic        cpu_imem_arvalid, cpu_imem_arready;
logic [31:0] cpu_imem_rdata;
logic [1:0]  cpu_imem_rresp;
logic        cpu_imem_rvalid, cpu_imem_rready;

// CPU DMEM (R/W, crossbar master m0)
logic [31:0] cpu_dmem_awaddr, cpu_dmem_wdata;
logic [3:0]  cpu_dmem_wstrb;
logic        cpu_dmem_awvalid, cpu_dmem_awready;
logic        cpu_dmem_wvalid,  cpu_dmem_wready;
logic [1:0]  cpu_dmem_bresp;
logic        cpu_dmem_bvalid,  cpu_dmem_bready;
logic [31:0] cpu_dmem_araddr;
logic        cpu_dmem_arvalid, cpu_dmem_arready;
logic [31:0] cpu_dmem_rdata;
logic [1:0]  cpu_dmem_rresp;
logic        cpu_dmem_rvalid,  cpu_dmem_rready;

// AES ISA extension sideband (Custom-0)
logic        cpu_custom_valid, cpu_custom_rd_valid;
logic [31:0] cpu_custom_instr, cpu_custom_rs1, cpu_custom_rs2, cpu_custom_rd;

// CPU security status
logic        cpu_ecc_error, cpu_ecc_fatal, cpu_wdt_reset;

// =============================================================================
// Wire Declarations — AXI-Lite Crossbar Slave Ports (s0..s7)
// =============================================================================

// Macro: declare full AXI-Lite slave wire bundle
`define AXIL_SLAVE_WIRES(N) \
logic [31:0] xb_s``N``_awaddr, xb_s``N``_wdata, xb_s``N``_araddr, xb_s``N``_rdata; \
logic [3:0]  xb_s``N``_wstrb; \
logic        xb_s``N``_awvalid, xb_s``N``_awready; \
logic        xb_s``N``_wvalid,  xb_s``N``_wready; \
logic [1:0]  xb_s``N``_bresp; \
logic        xb_s``N``_bvalid,  xb_s``N``_bready; \
logic        xb_s``N``_arvalid, xb_s``N``_arready; \
logic [1:0]  xb_s``N``_rresp; \
logic        xb_s``N``_rvalid,  xb_s``N``_rready

`AXIL_SLAVE_WIRES(0);  // Boot ROM
`AXIL_SLAVE_WIRES(1);  // SRAM (port B)
`AXIL_SLAVE_WIRES(2);  // AES-CA    (→ fw2)
`AXIL_SLAVE_WIRES(3);  // TRNG      (→ fw3)
`AXIL_SLAVE_WIRES(4);  // PDF Eng   (→ fw4)
`AXIL_SLAVE_WIRES(5);  // UART      (→ fw5)
`AXIL_SLAVE_WIRES(6);  // I2C       (→ fw6)
`AXIL_SLAVE_WIRES(7);  // SPI       (→ fw7)

// =============================================================================
// Wire Declarations — Firewall Downstream Ports (fw2..fw7 → peripherals)
// =============================================================================
`define FW_DOWN_WIRES(N) \
logic [31:0] fw``N``_d_awaddr, fw``N``_d_wdata, fw``N``_d_araddr, fw``N``_d_rdata; \
logic [3:0]  fw``N``_d_wstrb; \
logic        fw``N``_d_awvalid, fw``N``_d_awready; \
logic        fw``N``_d_wvalid,  fw``N``_d_wready; \
logic [1:0]  fw``N``_d_bresp; \
logic        fw``N``_d_bvalid,  fw``N``_d_bready; \
logic        fw``N``_d_arvalid, fw``N``_d_arready; \
logic [1:0]  fw``N``_d_rresp; \
logic        fw``N``_d_rvalid,  fw``N``_d_rready; \
logic        fw``N``_deny_irq

`FW_DOWN_WIRES(2);
`FW_DOWN_WIRES(3);
`FW_DOWN_WIRES(4);
`FW_DOWN_WIRES(5);
`FW_DOWN_WIRES(6);
`FW_DOWN_WIRES(7);

// =============================================================================
// Wire Declarations — PDF DMA Master (crossbar m1)
// =============================================================================
logic [31:0] dma_awaddr, dma_wdata, dma_araddr, dma_rdata;
logic [3:0]  dma_wstrb;
logic        dma_awvalid, dma_awready;
logic        dma_wvalid,  dma_wready;
logic [1:0]  dma_bresp;
logic        dma_bvalid,  dma_bready;
logic        dma_arvalid, dma_arready;
logic [1:0]  dma_rresp;
logic        dma_rvalid,  dma_rready;

// =============================================================================
// Wire Declarations — AES-CA Direct Interface (PDF Engine ↔ AES-CA)
// =============================================================================
logic [255:0] aes_key;          // AES-256 key (from I2C/ATECC608B via firmware)
logic [127:0] aes_din;          // AES input block  (16 bytes)
logic [127:0] aes_dout;         // AES output block (16 bytes)
logic         aes_start;        // Pulse: begin one AES-256 operation
logic         aes_decrypt;      // 0=ENCRYPT, 1=DECRYPT (inverse CA rounds)
logic         aes_done;         // Pulse: operation complete, aes_dout valid

// =============================================================================
// Wire Declarations — TRNG Output
// =============================================================================
logic [31:0]  trng_data;        // 32-bit entropy word
logic         trng_valid;       // FIFO not empty; cleared on read
logic         trng_rct_fail;    // SP800-90B RCT health test failure
logic         trng_apt_fail;    // SP800-90B APT health test failure

// =============================================================================
// Wire Declarations — Peripheral IRQs
// =============================================================================
logic         uart_irq;         // UART TX empty / RX full
logic         i2c_irq;          // I2C transaction complete / error
logic         spi_irq;          // SPI transfer complete
logic         pdf_irq;          // PDF engine done / HMAC error

// =============================================================================
// Master-ID Sideband — Firewall Transaction Attribution
// =============================================================================
// The crossbar muxes master addresses onto slave ports without carrying master_id.
// We derive master_id at each firewall upstream port by comparing the active
// address against the registered DMA master's outstanding address.
// DMA (m1) is only granted SRAM (s1) under default policy, so all firewalled
// slave ports (s2..s7) should see master_id=0 (CPU) in normal operation.
// A locked firewall rejects any master_id=1 attempt on s2..s7.

logic [1:0] fw2_mid, fw3_mid, fw4_mid, fw5_mid, fw6_mid, fw7_mid;

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        {fw2_mid, fw3_mid, fw4_mid, fw5_mid, fw6_mid, fw7_mid} <= '0;
    end else begin
        // Latch master_id on AW handshake: DMA wins if its address matches
        if (xb_s2_awvalid && xb_s2_awready)
            fw2_mid <= (dma_awvalid && xb_s2_awaddr == dma_awaddr) ? 2'b01 : 2'b00;
        if (xb_s3_awvalid && xb_s3_awready)
            fw3_mid <= (dma_awvalid && xb_s3_awaddr == dma_awaddr) ? 2'b01 : 2'b00;
        if (xb_s4_awvalid && xb_s4_awready)
            fw4_mid <= (dma_awvalid && xb_s4_awaddr == dma_awaddr) ? 2'b01 : 2'b00;
        if (xb_s5_awvalid && xb_s5_awready)
            fw5_mid <= (dma_awvalid && xb_s5_awaddr == dma_awaddr) ? 2'b01 : 2'b00;
        if (xb_s6_awvalid && xb_s6_awready)
            fw6_mid <= (dma_awvalid && xb_s6_awaddr == dma_awaddr) ? 2'b01 : 2'b00;
        if (xb_s7_awvalid && xb_s7_awready)
            fw7_mid <= (dma_awvalid && xb_s7_awaddr == dma_awaddr) ? 2'b01 : 2'b00;
    end
end

// =============================================================================
// IRQ Aggregation
// =============================================================================
// seceng_irq = PDF done | FW deny | CPU ECC fatal | SRAM DED | TRNG health | WDT reset
// Also muxed onto uart_tx idle state in PCB-level design for 10-pin constraint
assign seceng_irq = pdf_irq
                  | fw2_deny_irq | fw3_deny_irq | fw4_deny_irq
                  | fw5_deny_irq | fw6_deny_irq | fw7_deny_irq
                  | cpu_ecc_fatal
                  | sram_ded_sticky          // SRAM double-bit error (uncorrectable)
                  | trng_rct_fail | trng_apt_fail
                  | cpu_wdt_reset;

// =============================================================================
// 1. RV32IM CPU Core — 5-Stage Pipeline
//    Security: Instruction parity trap | PC Range Guard (CSR 0xBC0/0xBC1) |
//              Register file Hamming(7,4) ECC | 24-bit Watchdog Timer
// =============================================================================
rv32im_core #(
    .RESET_ADDR    (32'h0000_0000),  // Boot from start of Boot ROM / SRAM
    .WDT_BITS      (24),             // 24-bit watchdog: timeout = 2^24 / 250MHz ~ 67ms
    .ECC_EN        (1),              // Enable Hamming(7,4) on register file
    .PARITY_EN     (1),              // Enable instruction fetch parity trap
    .PC_GUARD_EN   (1)               // Enable PC range guard (CSR 0xBC0/0xBC1)
) u_cpu (
    .clk             (clk),
    .rst_n           (rst_n),
    // Interrupts: seceng_irq feeds ext_irq (PDF done, FW deny, ECC, TRNG fail)
    .timer_irq       (1'b0),
    .soft_irq        (1'b0),
    .ext_irq         (seceng_irq),
    // Security status outputs
    .ecc_error       (cpu_ecc_error),   // Correctable ECC error on reg file
    .ecc_fatal       (cpu_ecc_fatal),   // Uncorrectable double-bit ECC error
    .wdt_reset       (cpu_wdt_reset),   // WDT timeout — also drives rst_n tree
    // IMEM bus → SRAM Port A (read-only, direct, bypasses crossbar)
    .imem_araddr     (cpu_imem_araddr),
    .imem_arvalid    (cpu_imem_arvalid),
    .imem_arready    (cpu_imem_arready),
    .imem_rdata      (cpu_imem_rdata),
    .imem_rresp      (cpu_imem_rresp),
    .imem_rvalid     (cpu_imem_rvalid),
    .imem_rready     (cpu_imem_rready),
    // DMEM bus → crossbar master m0
    .dmem_awaddr     (cpu_dmem_awaddr),
    .dmem_awvalid    (cpu_dmem_awvalid),
    .dmem_awready    (cpu_dmem_awready),
    .dmem_wdata      (cpu_dmem_wdata),
    .dmem_wstrb      (cpu_dmem_wstrb),
    .dmem_wvalid     (cpu_dmem_wvalid),
    .dmem_wready     (cpu_dmem_wready),
    .dmem_bresp      (cpu_dmem_bresp),
    .dmem_bvalid     (cpu_dmem_bvalid),
    .dmem_bready     (cpu_dmem_bready),
    .dmem_araddr     (cpu_dmem_araddr),
    .dmem_arvalid    (cpu_dmem_arvalid),
    .dmem_arready    (cpu_dmem_arready),
    .dmem_rdata      (cpu_dmem_rdata),
    .dmem_rresp      (cpu_dmem_rresp),
    .dmem_rvalid     (cpu_dmem_rvalid),
    .dmem_rready     (cpu_dmem_rready),
    // AES Custom-0 sideband
    .custom_valid    (cpu_custom_valid),
    .custom_instr    (cpu_custom_instr),
    .custom_rs1      (cpu_custom_rs1),
    .custom_rs2      (cpu_custom_rs2),
    .custom_rd       (cpu_custom_rd),
    .custom_rd_valid (cpu_custom_rd_valid)
);

// =============================================================================
// 2. AES ISA Extension — Combinational Custom-0 Co-Processor
//    8 instructions: aes_enc_round, aes_dec_round, aes_keygen_assist,
//                    aes_subbytes, aes_shiftrows, aes_mixcols,
//                    aes_addkey, aes_ctr_inc
//    Zero pipeline stall — result available combinationally in same cycle
// =============================================================================
aes_isa_ext u_aes_isa (
    .custom_valid    (cpu_custom_valid),
    .custom_instr    (cpu_custom_instr),
    .custom_rs1      (cpu_custom_rs1),
    .custom_rs2      (cpu_custom_rs2),
    .custom_rd       (cpu_custom_rd),
    .custom_rd_valid (cpu_custom_rd_valid)
);

// =============================================================================
// 3. Ring-Oscillator TRNG
//    Architecture: rosc_ext dither → Ring-Osc Jitter Sampler →
//                  Von Neumann Debiaser → Galois LFSR (post-processor) →
//                  SP 800-90B Health Tests (RCT + APT) → 32-bit FIFO output
//    Reference: ISSCC 2023 — 23 Mb/s @ 23 pJ/b in 28nm CMOS
//    Note: rosc_ext injects external frequency dither to prevent
//          power-analysis-based prediction of ring-osc phase.
//    AXI-Lite registers (slave s3, behind firewall fw3):
//      0x3000_1000 : TRNG_DATA  (RO) — consume one 32-bit entropy word
//      0x3000_1004 : TRNG_STAT  (RO) — {valid, rct_fail, apt_fail, fifo_full}
//      0x3000_1008 : TRNG_CTRL  (RW) — {enable, test_mode, bypass_vn}
// =============================================================================
rosc_trng u_trng (
    .clk             (clk),
    .rst_n           (rst_n),
    // External ring-oscillator dither input (pin 10)
    .rosc_ext        (rosc_ext),
    // Entropy output to PDF engine (direct, for IV generation)
    .trng_data       (trng_data),
    .trng_valid      (trng_valid),
    // Health test failure flags (aggregate to IRQ)
    .rct_fail        (trng_rct_fail),
    .apt_fail        (trng_apt_fail),
    // AXI-Lite slave (behind firewall fw3) — 12-bit address [11:0]
    .s_axil_awaddr   (fw3_d_awaddr[11:0]),
    .s_axil_awvalid  (fw3_d_awvalid),
    .s_axil_awready  (fw3_d_awready),
    .s_axil_wdata    (fw3_d_wdata),
    .s_axil_wstrb    (fw3_d_wstrb),
    .s_axil_wvalid   (fw3_d_wvalid),
    .s_axil_wready   (fw3_d_wready),
    .s_axil_bresp    (fw3_d_bresp),
    .s_axil_bvalid   (fw3_d_bvalid),
    .s_axil_bready   (fw3_d_bready),
    .s_axil_araddr   (fw3_d_araddr[11:0]),
    .s_axil_arvalid  (fw3_d_arvalid),
    .s_axil_arready  (fw3_d_arready),
    .s_axil_rdata    (fw3_d_rdata),
    .s_axil_rresp    (fw3_d_rresp),
    .s_axil_rvalid   (fw3_d_rvalid),
    .s_axil_rready   (fw3_d_rready)
);

// =============================================================================
// 4. AES-CA Accelerator — AES-256 + Cellular Automaton Rounds
//    ENCRYPT (cipher_decrypt=0): Forward CA rounds
//      CA-1: SubBytes + Rule-90 XOR perturbation on state
//      CA-2: ShiftRows (standard AES)
//      CA-3: MixColumns in GF(2^8)
//      CA-4: AddRoundKey + Rule-30 nonlinear perturbation
//    DECRYPT (cipher_decrypt=1): Inverse CA rounds
//      CA-1: InvSubBytes + Rule-90 inverse perturbation
//      CA-2: InvShiftRows
//      CA-3: InvMixColumns in GF(2^8)
//      CA-4: AddRoundKey + Rule-30 inverse perturbation
//    14 rounds for AES-256 | ~100K gate equivalents | 285 MB/s @ 250 MHz
//    AXI-Lite registers (slave s2, behind firewall fw2):
//      0x3000_0000 : AES_CTRL  (RW) — {start[0], decrypt[1], mode[3:2]}
//      0x3000_0004 : AES_STAT  (RO) — {done[0], busy[1], hmac_ok[2], hmac_err[3]}
//      0x3000_0010 : AES_KEY0  (WO) — key[31:0]   ... 0x3000_002C: key[255:224]
//      0x3000_0030 : AES_IV0   (WO) — iv[31:0]    ... 0x3000_003C: iv[127:96]
// =============================================================================
aes_ca_accel u_aes_ca (
    .clk             (clk),
    .rst_n           (rst_n),
    // Direct interface — driven by india_pdf_engine
    .direct_key      (aes_key),
    .direct_din      (aes_din),
    .direct_start    (aes_start),
    .direct_decrypt  (aes_decrypt),  // 0=ENCRYPT, 1=DECRYPT
    .direct_dout     (aes_dout),
    .direct_done     (aes_done),
    // AXI-Lite slave (behind firewall fw2) — 12-bit address [11:0]
    .s_axil_awaddr   (fw2_d_awaddr[11:0]),
    .s_axil_awvalid  (fw2_d_awvalid),
    .s_axil_awready  (fw2_d_awready),
    .s_axil_wdata    (fw2_d_wdata),
    .s_axil_wstrb    (fw2_d_wstrb),
    .s_axil_wvalid   (fw2_d_wvalid),
    .s_axil_wready   (fw2_d_wready),
    .s_axil_bresp    (fw2_d_bresp),
    .s_axil_bvalid   (fw2_d_bvalid),
    .s_axil_bready   (fw2_d_bready),
    .s_axil_araddr   (fw2_d_araddr[11:0]),
    .s_axil_arvalid  (fw2_d_arvalid),
    .s_axil_arready  (fw2_d_arready),
    .s_axil_rdata    (fw2_d_rdata),
    .s_axil_rresp    (fw2_d_rresp),
    .s_axil_rvalid   (fw2_d_rvalid),
    .s_axil_rready   (fw2_d_rready)
);

// =============================================================================
// 5. India PDF Engine — Streaming Encrypt/Decrypt FSM
//    17-state FSM:
//      IDLE → HEADER_PARSE → KEY_LOAD → IV_GEN(enc)/IV_EXTRACT(dec) →
//      CTR_INIT → STREAM_IN → AES_PROC → CA_HMAC → STREAM_OUT →
//      HMAC_VERIFY(dec only) → VERIFY_OK/VERIFY_FAIL → DONE/ERROR
//    APP_MODE=0 (ENCRYPT):
//      IV from TRNG → AES-CTR encrypt 16B blocks → CA-HMAC appended at end
//      SPI out = ciphertext + 32B HMAC tag
//    APP_MODE=1 (DECRYPT):
//      IV from ciphertext header → AES-CTR decrypt 16B blocks →
//      CA-HMAC recomputed → compared with received tag
//      SPI out BLOCKED until HMAC verified; on mismatch: IRQ + deny_log
//    APP_MODE=2 (HMAC-ONLY):
//      No AES; recompute CA-HMAC and compare tag; report pass/fail via IRQ
//    CA-HMAC: Rule-30 based CA, 8 iterations, 256-bit tag
//    DMA master (m1): streams blocks to/from SRAM (slave s1 only, FW enforced)
// =============================================================================
india_pdf_engine u_pdf (
    .clk             (clk),
    .rst_n           (rst_n),
    // Config AXI-Lite slave (behind firewall fw4) — 12-bit address [11:0]
    .s_awaddr        (fw4_d_awaddr[11:0]),
    .s_awvalid       (fw4_d_awvalid),
    .s_awready       (fw4_d_awready),
    .s_wdata         (fw4_d_wdata),
    .s_wstrb         (fw4_d_wstrb),
    .s_wvalid        (fw4_d_wvalid),
    .s_wready        (fw4_d_wready),
    .s_bresp         (fw4_d_bresp),
    .s_bvalid        (fw4_d_bvalid),
    .s_bready        (fw4_d_bready),
    .s_araddr        (fw4_d_araddr[11:0]),
    .s_arvalid       (fw4_d_arvalid),
    .s_arready       (fw4_d_arready),
    .s_rdata         (fw4_d_rdata),
    .s_rresp         (fw4_d_rresp),
    .s_rvalid        (fw4_d_rvalid),
    .s_rready        (fw4_d_rready),
    // DMA AXI-Lite master → crossbar master m1
    .m_awaddr        (dma_awaddr),
    .m_awvalid       (dma_awvalid),
    .m_awready       (dma_awready),
    .m_wdata         (dma_wdata),
    .m_wstrb         (dma_wstrb),
    .m_wvalid        (dma_wvalid),
    .m_wready        (dma_wready),
    .m_bresp         (dma_bresp),
    .m_bvalid        (dma_bvalid),
    .m_bready        (dma_bready),
    .m_araddr        (dma_araddr),
    .m_arvalid       (dma_arvalid),
    .m_arready       (dma_arready),
    .m_rdata         (dma_rdata),
    .m_rresp         (dma_rresp),
    .m_rvalid        (dma_rvalid),
    .m_rready        (dma_rready),
    // AES-CA direct interface
    .cipher_key      (aes_key),
    .cipher_din      (aes_din),
    .cipher_start    (aes_start),
    .cipher_decrypt  (aes_decrypt),   // 0=ENCRYPT path, 1=DECRYPT path
    .cipher_dout     (aes_dout),
    .cipher_done     (aes_done),
    // TRNG (for IV generation in APP_MODE=0)
    .trng_data       (trng_data),
    .trng_valid      (trng_valid),
    // IRQ: done, HMAC pass/fail, or firewall deny during DMA
    .irq             (pdf_irq)
);

// =============================================================================
// 6. PULP UART Peripheral
//    Source: github.com/pulp-platform/apb_uart (Solderpad 0.51)
//    Wrapper: axil_to_apb bridge + apb_uart + security layer
//    Security: TX rate limiter, RX address whitelist (secure_mode=1)
//    AXI-Lite slave (s5, behind firewall fw5) — 12-bit address [11:0]
//    uart_tx idle-state: also used as IRQ signal mux in PCB design
// =============================================================================
pulp_uart_wrap u_uart (
    .clk             (clk),
    .rst_n           (rst_n),
    .secure_mode     (1'b0),     // TODO: drive from secure-boot CSR
    .uart_rx         (uart_rx),
    .uart_tx         (uart_tx),
    .irq             (uart_irq),
    // AXI-Lite slave — FW downstream address truncated to 12-bit
    .s_awaddr        (fw5_d_awaddr[11:0]),
    .s_awvalid       (fw5_d_awvalid),
    .s_awready       (fw5_d_awready),
    .s_wdata         (fw5_d_wdata),
    .s_wstrb         (fw5_d_wstrb),
    .s_wvalid        (fw5_d_wvalid),
    .s_wready        (fw5_d_wready),
    .s_bresp         (fw5_d_bresp),
    .s_bvalid        (fw5_d_bvalid),
    .s_bready        (fw5_d_bready),
    .s_araddr        (fw5_d_araddr[11:0]),
    .s_arvalid       (fw5_d_arvalid),
    .s_arready       (fw5_d_arready),
    .s_rdata         (fw5_d_rdata),
    .s_rresp         (fw5_d_rresp),
    .s_rvalid        (fw5_d_rvalid),
    .s_rready        (fw5_d_rready)
);

// =============================================================================
// 7. PULP I2C Peripheral  (Key Management Plane — ATECC608B Interface)
//    Source: github.com/pulp-platform/apb_i2c (Solderpad 0.51)
//    Wrapper: axil_to_apb bridge + apb_i2c + security layer
//    Security: 4-entry address whitelist, bus-stuck recovery (500K cycles)
//    i2c_sda/scl: BIDIR — tristate handled inside pulp_i2c_wrap
//    ATECC608B at I2C address 0x60:
//      Key Slot 0: AES-256 key (provisioned at factory, read-locked after write)
//      Firmware reads key → writes to AES-CA KEY register via AXI-Lite
//      Key NEVER appears on SPI bus (FW6 → FW7 crossing blocked by firewall)
//    AXI-Lite slave (s6, behind firewall fw6) — 12-bit address [11:0]
// =============================================================================
pulp_i2c_wrap u_i2c (
    .clk             (clk),
    .rst_n           (rst_n),
    .secure_mode     (1'b0),     // TODO: drive from secure-boot CSR
    .i2c_sda         (i2c_sda),
    .i2c_scl         (i2c_scl),
    .irq             (i2c_irq),
    // AXI-Lite slave — FW downstream address truncated to 12-bit
    .s_awaddr        (fw6_d_awaddr[11:0]),
    .s_awvalid       (fw6_d_awvalid),
    .s_awready       (fw6_d_awready),
    .s_wdata         (fw6_d_wdata),
    .s_wstrb         (fw6_d_wstrb),
    .s_wvalid        (fw6_d_wvalid),
    .s_wready        (fw6_d_wready),
    .s_bresp         (fw6_d_bresp),
    .s_bvalid        (fw6_d_bvalid),
    .s_bready        (fw6_d_bready),
    .s_araddr        (fw6_d_araddr[11:0]),
    .s_arvalid       (fw6_d_arvalid),
    .s_arready       (fw6_d_arready),
    .s_rdata         (fw6_d_rdata),
    .s_rresp         (fw6_d_rresp),
    .s_rvalid        (fw6_d_rvalid),
    .s_rready        (fw6_d_rready)
);

// =============================================================================
// 8. PULP SPI Peripheral  (PDF Data Plane)
//    Source: github.com/pulp-platform/apb_spi_master (Solderpad 0.51)
//            Sub-modules: github.com/pulp-platform/axi_spi_master
//    Wrapper: axil_to_apb bridge + apb_spi_master + security layer
//    Security: CS guard, transfer-length limiter, per-CS lock
//    spi_cs_n: single chip select (reduced from [3:0] for 10-pin constraint)
//    Data plane: Host sends encrypted/plaintext PDF over spi_mosi;
//                SoC returns processed output over spi_miso.
//    PDF DMA accesses SRAM only — SPI peripheral itself does not DMA;
//    the india_pdf_engine DMA master (m1) handles all bulk transfer.
//    AXI-Lite slave (s7, behind firewall fw7) — 12-bit address [11:0]
// =============================================================================
pulp_spi_wrap u_spi (
    .clk             (clk),
    .rst_n           (rst_n),
    .secure_mode     (1'b0),     // TODO: drive from secure-boot CSR
    .spi_sck         (spi_sck),
    .spi_mosi        (spi_mosi),
    .spi_miso        (spi_miso),
    .spi_cs_n        (spi_cs_n),
    .irq             (spi_irq),
    // AXI-Lite slave — FW downstream address truncated to 12-bit
    .s_awaddr        (fw7_d_awaddr[11:0]),
    .s_awvalid       (fw7_d_awvalid),
    .s_awready       (fw7_d_awready),
    .s_wdata         (fw7_d_wdata),
    .s_wstrb         (fw7_d_wstrb),
    .s_wvalid        (fw7_d_wvalid),
    .s_wready        (fw7_d_wready),
    .s_bresp         (fw7_d_bresp),
    .s_bvalid        (fw7_d_bvalid),
    .s_bready        (fw7_d_bready),
    .s_araddr        (fw7_d_araddr[11:0]),
    .s_arvalid       (fw7_d_arvalid),
    .s_arready       (fw7_d_arready),
    .s_rdata         (fw7_d_rdata),
    .s_rresp         (fw7_d_rresp),
    .s_rvalid        (fw7_d_rvalid),
    .s_rready        (fw7_d_rready)
);

// =============================================================================
// 9. AXI-Lite Crossbar  — 2 Masters × 8 Slaves
//    Priority: m0 (CPU) > m1 (DMA) on all slaves
//    Address decode:
//      0x0000_xxxx → s0 (Boot ROM)
//      0x2000_xxxx → s1 (SRAM)
//      0x3000_0xxx → s2 (AES-CA)
//      0x3000_1xxx → s3 (TRNG)
//      0x3000_2xxx → s4 (PDF Engine)
//      0x4000_0xxx → s5 (UART)
//      0x4000_1xxx → s6 (I2C)
//      0x4000_2xxx → s7 (SPI)
// =============================================================================
axi_lite_xbar u_xbar (
    .clk        (clk),
    .rst_n      (rst_n),
    // Master 0 — CPU DMEM
    .m0_awaddr  (cpu_dmem_awaddr),  .m0_awvalid (cpu_dmem_awvalid),
    .m0_awready (cpu_dmem_awready),
    .m0_wdata   (cpu_dmem_wdata),   .m0_wstrb   (cpu_dmem_wstrb),
    .m0_wvalid  (cpu_dmem_wvalid),  .m0_wready  (cpu_dmem_wready),
    .m0_bresp   (cpu_dmem_bresp),   .m0_bvalid  (cpu_dmem_bvalid),
    .m0_bready  (cpu_dmem_bready),
    .m0_araddr  (cpu_dmem_araddr),  .m0_arvalid (cpu_dmem_arvalid),
    .m0_arready (cpu_dmem_arready),
    .m0_rdata   (cpu_dmem_rdata),   .m0_rresp   (cpu_dmem_rresp),
    .m0_rvalid  (cpu_dmem_rvalid),  .m0_rready  (cpu_dmem_rready),
    // Master 1 — PDF Engine DMA
    .m1_awaddr  (dma_awaddr),  .m1_awvalid (dma_awvalid),
    .m1_awready (dma_awready),
    .m1_wdata   (dma_wdata),   .m1_wstrb   (dma_wstrb),
    .m1_wvalid  (dma_wvalid),  .m1_wready  (dma_wready),
    .m1_bresp   (dma_bresp),   .m1_bvalid  (dma_bvalid),
    .m1_bready  (dma_bready),
    .m1_araddr  (dma_araddr),  .m1_arvalid (dma_arvalid),
    .m1_arready (dma_arready),
    .m1_rdata   (dma_rdata),   .m1_rresp   (dma_rresp),
    .m1_rvalid  (dma_rvalid),  .m1_rready  (dma_rready),
    // Slave 0 — Boot ROM
    .s0_awaddr(xb_s0_awaddr),.s0_awvalid(xb_s0_awvalid),.s0_awready(xb_s0_awready),
    .s0_wdata(xb_s0_wdata),  .s0_wstrb(xb_s0_wstrb),    .s0_wvalid(xb_s0_wvalid),
    .s0_wready(xb_s0_wready),.s0_bresp(xb_s0_bresp),    .s0_bvalid(xb_s0_bvalid),
    .s0_bready(xb_s0_bready),.s0_araddr(xb_s0_araddr),  .s0_arvalid(xb_s0_arvalid),
    .s0_arready(xb_s0_arready),.s0_rdata(xb_s0_rdata),  .s0_rresp(xb_s0_rresp),
    .s0_rvalid(xb_s0_rvalid),.s0_rready(xb_s0_rready),
    // Slave 1 — SRAM Port B
    .s1_awaddr(xb_s1_awaddr),.s1_awvalid(xb_s1_awvalid),.s1_awready(xb_s1_awready),
    .s1_wdata(xb_s1_wdata),  .s1_wstrb(xb_s1_wstrb),    .s1_wvalid(xb_s1_wvalid),
    .s1_wready(xb_s1_wready),.s1_bresp(xb_s1_bresp),    .s1_bvalid(xb_s1_bvalid),
    .s1_bready(xb_s1_bready),.s1_araddr(xb_s1_araddr),  .s1_arvalid(xb_s1_arvalid),
    .s1_arready(xb_s1_arready),.s1_rdata(xb_s1_rdata),  .s1_rresp(xb_s1_rresp),
    .s1_rvalid(xb_s1_rvalid),.s1_rready(xb_s1_rready),
    // Slave 2 — AES-CA (→ fw2)
    .s2_awaddr(xb_s2_awaddr),.s2_awvalid(xb_s2_awvalid),.s2_awready(xb_s2_awready),
    .s2_wdata(xb_s2_wdata),  .s2_wstrb(xb_s2_wstrb),    .s2_wvalid(xb_s2_wvalid),
    .s2_wready(xb_s2_wready),.s2_bresp(xb_s2_bresp),    .s2_bvalid(xb_s2_bvalid),
    .s2_bready(xb_s2_bready),.s2_araddr(xb_s2_araddr),  .s2_arvalid(xb_s2_arvalid),
    .s2_arready(xb_s2_arready),.s2_rdata(xb_s2_rdata),  .s2_rresp(xb_s2_rresp),
    .s2_rvalid(xb_s2_rvalid),.s2_rready(xb_s2_rready),
    // Slave 3 — TRNG (→ fw3)
    .s3_awaddr(xb_s3_awaddr),.s3_awvalid(xb_s3_awvalid),.s3_awready(xb_s3_awready),
    .s3_wdata(xb_s3_wdata),  .s3_wstrb(xb_s3_wstrb),    .s3_wvalid(xb_s3_wvalid),
    .s3_wready(xb_s3_wready),.s3_bresp(xb_s3_bresp),    .s3_bvalid(xb_s3_bvalid),
    .s3_bready(xb_s3_bready),.s3_araddr(xb_s3_araddr),  .s3_arvalid(xb_s3_arvalid),
    .s3_arready(xb_s3_arready),.s3_rdata(xb_s3_rdata),  .s3_rresp(xb_s3_rresp),
    .s3_rvalid(xb_s3_rvalid),.s3_rready(xb_s3_rready),
    // Slave 4 — PDF Engine (→ fw4)
    .s4_awaddr(xb_s4_awaddr),.s4_awvalid(xb_s4_awvalid),.s4_awready(xb_s4_awready),
    .s4_wdata(xb_s4_wdata),  .s4_wstrb(xb_s4_wstrb),    .s4_wvalid(xb_s4_wvalid),
    .s4_wready(xb_s4_wready),.s4_bresp(xb_s4_bresp),    .s4_bvalid(xb_s4_bvalid),
    .s4_bready(xb_s4_bready),.s4_araddr(xb_s4_araddr),  .s4_arvalid(xb_s4_arvalid),
    .s4_arready(xb_s4_arready),.s4_rdata(xb_s4_rdata),  .s4_rresp(xb_s4_rresp),
    .s4_rvalid(xb_s4_rvalid),.s4_rready(xb_s4_rready),
    // Slave 5 — UART (→ fw5)
    .s5_awaddr(xb_s5_awaddr),.s5_awvalid(xb_s5_awvalid),.s5_awready(xb_s5_awready),
    .s5_wdata(xb_s5_wdata),  .s5_wstrb(xb_s5_wstrb),    .s5_wvalid(xb_s5_wvalid),
    .s5_wready(xb_s5_wready),.s5_bresp(xb_s5_bresp),    .s5_bvalid(xb_s5_bvalid),
    .s5_bready(xb_s5_bready),.s5_araddr(xb_s5_araddr),  .s5_arvalid(xb_s5_arvalid),
    .s5_arready(xb_s5_arready),.s5_rdata(xb_s5_rdata),  .s5_rresp(xb_s5_rresp),
    .s5_rvalid(xb_s5_rvalid),.s5_rready(xb_s5_rready),
    // Slave 6 — I2C (→ fw6)
    .s6_awaddr(xb_s6_awaddr),.s6_awvalid(xb_s6_awvalid),.s6_awready(xb_s6_awready),
    .s6_wdata(xb_s6_wdata),  .s6_wstrb(xb_s6_wstrb),    .s6_wvalid(xb_s6_wvalid),
    .s6_wready(xb_s6_wready),.s6_bresp(xb_s6_bresp),    .s6_bvalid(xb_s6_bvalid),
    .s6_bready(xb_s6_bready),.s6_araddr(xb_s6_araddr),  .s6_arvalid(xb_s6_arvalid),
    .s6_arready(xb_s6_arready),.s6_rdata(xb_s6_rdata),  .s6_rresp(xb_s6_rresp),
    .s6_rvalid(xb_s6_rvalid),.s6_rready(xb_s6_rready),
    // Slave 7 — SPI (→ fw7)
    .s7_awaddr(xb_s7_awaddr),.s7_awvalid(xb_s7_awvalid),.s7_awready(xb_s7_awready),
    .s7_wdata(xb_s7_wdata),  .s7_wstrb(xb_s7_wstrb),    .s7_wvalid(xb_s7_wvalid),
    .s7_wready(xb_s7_wready),.s7_bresp(xb_s7_bresp),    .s7_bvalid(xb_s7_bvalid),
    .s7_bready(xb_s7_bready),.s7_araddr(xb_s7_araddr),  .s7_arvalid(xb_s7_arvalid),
    .s7_arready(xb_s7_arready),.s7_rdata(xb_s7_rdata),  .s7_rresp(xb_s7_rresp),
    .s7_rvalid(xb_s7_rvalid),.s7_rready(xb_s7_rready)
);

// =============================================================================
// 10. AXI Firewall Instances (s2..s7 — one per protected slave)
//     Permission table: 16 entries (2 masters × 8 slaves), each 32-bit
//     [15:0]  = read_mask  (per-byte, 0=deny 1=allow)
//     [31:16] = write_mask (per-byte, 0=deny 1=allow)
//     Write-once lock: write 0xDEAD_BEEF to lock register → table read-only
//     Deny action: SLVERR returned + deny_irq asserted + event logged
//     Default: CPU (master_id=0) full R/W; DMA (master_id=1) denied
// =============================================================================

`define FW_INST(NUM, SID) \
axi_firewall #( \
    .DEFAULT_PERM (FW_CPU_ONLY), \
    .LOCK_KEY     (32'hDEAD_BEEF), \
    .LOG_DEPTH    (4) \
) u_fw``NUM ( \
    .clk        (clk), \
    .rst_n      (rst_n), \
    .master_id  (fw``NUM``_mid), \
    .slave_id   (3'd``SID), \
    /* upstream — from crossbar */ \
    .u_awaddr   (xb_s``NUM``_awaddr),   .u_awvalid  (xb_s``NUM``_awvalid), \
    .u_awready  (xb_s``NUM``_awready), \
    .u_wdata    (xb_s``NUM``_wdata),    .u_wstrb    (xb_s``NUM``_wstrb), \
    .u_wvalid   (xb_s``NUM``_wvalid),   .u_wready   (xb_s``NUM``_wready), \
    .u_bresp    (xb_s``NUM``_bresp),    .u_bvalid   (xb_s``NUM``_bvalid), \
    .u_bready   (xb_s``NUM``_bready), \
    .u_araddr   (xb_s``NUM``_araddr),   .u_arvalid  (xb_s``NUM``_arvalid), \
    .u_arready  (xb_s``NUM``_arready), \
    .u_rdata    (xb_s``NUM``_rdata),    .u_rresp    (xb_s``NUM``_rresp), \
    .u_rvalid   (xb_s``NUM``_rvalid),   .u_rready   (xb_s``NUM``_rready), \
    /* downstream — to peripheral */ \
    .d_awaddr   (fw``NUM``_d_awaddr),   .d_awvalid  (fw``NUM``_d_awvalid), \
    .d_awready  (fw``NUM``_d_awready), \
    .d_wdata    (fw``NUM``_d_wdata),    .d_wstrb    (fw``NUM``_d_wstrb), \
    .d_wvalid   (fw``NUM``_d_wvalid),   .d_wready   (fw``NUM``_d_wready), \
    .d_bresp    (fw``NUM``_d_bresp),    .d_bvalid   (fw``NUM``_d_bvalid), \
    .d_bready   (fw``NUM``_d_bready), \
    .d_araddr   (fw``NUM``_d_araddr),   .d_arvalid  (fw``NUM``_d_arvalid), \
    .d_arready  (fw``NUM``_d_arready), \
    .d_rdata    (fw``NUM``_d_rdata),    .d_rresp    (fw``NUM``_d_rresp), \
    .d_rvalid   (fw``NUM``_d_rvalid),   .d_rready   (fw``NUM``_d_rready), \
    /* deny IRQ */ \
    .deny_irq   (fw``NUM``_deny_irq), \
    /* firewall config port — tied idle (future: route to xbar slave 8) */ \
    .f_awaddr(32'h0),.f_awvalid(1'b0),.f_awready(), \
    .f_wdata(32'h0),.f_wstrb(4'h0),.f_wvalid(1'b0),.f_wready(), \
    .f_bresp(),.f_bvalid(),.f_bready(1'b1), \
    .f_araddr(32'h0),.f_arvalid(1'b0),.f_arready(), \
    .f_rdata(),.f_rresp(),.f_rvalid(),.f_rready(1'b1) \
)

`FW_INST(2, 2);   // AES-CA Accelerator
`FW_INST(3, 3);   // Ring-Osc TRNG
`FW_INST(4, 4);   // India PDF Engine
`FW_INST(5, 5);   // UART
`FW_INST(6, 6);   // I2C  (key management — DMA access denied at all times)
`FW_INST(7, 7);   // SPI  (data plane — DMA never reaches here; CPU configures)

// =============================================================================
// 11. Boot ROM — 32 KB (8192 × 32-bit words)
//     Read-only: returns SLVERR on write attempts
//     Content: NOP sled (0x0000_0013 = ADDI x0,x0,0) followed by
//              a jump-to-SRAM vector (firmware loaded into SRAM by host).
//     In production: replace NOP sled with actual secure boot code
//     (measured boot, attestation, key-load sequence).
// =============================================================================
logic        rom_rd_pending;

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        xb_s0_arready <= 1'b0;
        xb_s0_rvalid  <= 1'b0;
        xb_s0_rdata   <= 32'h0;
        xb_s0_rresp   <= 2'b00;
        rom_rd_pending <= 1'b0;
        xb_s0_awready <= 1'b0;
        xb_s0_wready  <= 1'b0;
        xb_s0_bvalid  <= 1'b0;
        xb_s0_bresp   <= 2'b10;  // SLVERR default for writes
    end else begin
        xb_s0_arready <= 1'b0;
        xb_s0_awready <= 1'b0;
        xb_s0_wready  <= 1'b0;

        // Read path — return NOP instruction
        if (xb_s0_arvalid && !rom_rd_pending) begin
            xb_s0_arready  <= 1'b1;
            rom_rd_pending <= 1'b1;
        end
        if (rom_rd_pending) begin
            xb_s0_rvalid <= 1'b1;
            // Uniform NOP sled; TODO: replace with ROM array for real boot code
            xb_s0_rdata  <= 32'h0000_0013;   // ADDI x0, x0, 0 (canonical NOP)
            xb_s0_rresp  <= 2'b00;
            if (xb_s0_rready) begin
                xb_s0_rvalid   <= 1'b0;
                rom_rd_pending <= 1'b0;
            end
        end

        // Write path — always SLVERR (ROM is read-only)
        if (xb_s0_awvalid) xb_s0_awready <= 1'b1;
        if (xb_s0_wvalid)  xb_s0_wready  <= 1'b1;
        if (xb_s0_awvalid && xb_s0_wvalid) begin
            xb_s0_bvalid <= 1'b1;
            xb_s0_bresp  <= 2'b10;
        end
        if (xb_s0_bvalid && xb_s0_bready) xb_s0_bvalid <= 1'b0;
    end
end

// =============================================================================
// 12. Dual-Port SRAM — 64 KB logical (16384 × 39-bit physical words)
//     Physical storage: 16384 × 39 bits = 76,176 bytes ≈ 0.120 mm² @ 28nm
//     Logical data:     16384 × 32 bits = 64 KB (presented to CPU/DMA)
//     ECC overhead:     +7 bits/word (+21.9% bits, ~+6% area)
//     ECC protection:   hamming_secded.v — Hamming(39,32) SEC-DED
//                       Single-bit flip → auto-corrected (transparent)
//                       Double-bit flip → sram_ded_sticky → seceng_irq
//     Port A: CPU IMEM — read-only, direct (bypasses crossbar and firewall)
//             Byte address → word address: cpu_imem_araddr[15:2]
//             Effective range: 0x0000_0000..0x0000_7FFF (lower 32 KB)
//     Port B: CPU DMEM + PDF DMA — R/W via crossbar slave s1
//             Byte address → word address: xb_s1_addr[15:2]
//             Effective range: 0x2000_0000..0x2000_FFFF (full 64 KB)
//
//     IMPORTANT: Port A (IMEM) and Port B (DMEM) share the same SRAM array.
//     In a real 28nm implementation, this is a dual-port SRAM macro with
//     separate A/B port address and data buses. Collision (same word, both
//     ports active simultaneously) is resolved by the SRAM macro;
//     firmware must not write IMEM range from Port B while CPU is fetching.
//
//     Address mapping (64 KB = 16384 words, 14-bit word address):
//       Port A: word_addr = cpu_imem_araddr[15:2]   (up to 32 KB = 8192 words)
//       Port B: word_addr = xb_s1_awaddr[15:2]      (full 64 KB = 16384 words)
//     Lower 32 KB (word_addr[13]=0): IMEM region (shared with Port A)
//     Upper 32 KB (word_addr[13]=1): DMEM-only region
// =============================================================================
// Each SRAM word is 39 bits: [31:0]=data, [37:32]={p5..p0} SEC parity, [38]=p6 DED
// hamming_enc/dec in hamming_secded.v implement Hamming(39,32) SEC-DED.
// Reset value = 39'h0 → valid all-zero codeword (p0..p6 = 0 for all-zero data).
logic [38:0] sram [0:SRAM_WORDS-1];

// ── ECC wires ──────────────────────────────────────────────────────────────
// Port A (IMEM, CPU fetch)
wire [31:0] sram_pa_corrected;   // corrected 32-bit instruction word
wire        sram_pa_sec;         // single-bit error corrected (non-fatal)
wire        sram_pa_ded;         // double-bit error detected  (fatal)
// Port B (DMEM, AXI slave s1)
wire [31:0] sram_pb_corrected;   // corrected 32-bit data word
wire        sram_pb_sec;         // single-bit error corrected
wire        sram_pb_ded;         // double-bit error detected (fatal)
// Write path — byte-strobe merge then encode
wire [31:0] sram_pb_merge;       // merged write word (new bytes | old bytes)
wire [38:0] sram_pb_encoded;     // encoded 39-bit write codeword

// Sticky DED flags — latch on first fatal error, cleared only by reset
logic sram_ded_sticky;

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) sram_ded_sticky <= 1'b0;
    else if (sram_pa_ded | sram_pb_ded) sram_ded_sticky <= 1'b1;
end

// ── ECC combinational modules ──────────────────────────────────────────────

// Port A decoder: combinational on the current fetch address
hamming_dec u_dec_pa (
    .din  (sram[cpu_imem_araddr[15:2]]),
    .dout (sram_pa_corrected),
    .sec  (sram_pa_sec),
    .ded  (sram_pa_ded)
);

// Port B decoder: combinational on the current AXI read address
hamming_dec u_dec_pb (
    .din  (sram[xb_s1_araddr[15:2]]),
    .dout (sram_pb_corrected),
    .sec  (sram_pb_sec),
    .ded  (sram_pb_ded)
);

// Port B write merge: apply byte strobe against current stored data
// For full-word writes (wstrb=4'hF) the old bytes are overridden entirely.
// For sub-word writes, old bytes preserved → re-encoded correctly.
assign sram_pb_merge[ 7: 0] = pb_wr_wstrb[0] ? pb_wr_wdata[ 7: 0] : sram[pb_wr_word_addr][ 7: 0];
assign sram_pb_merge[15: 8] = pb_wr_wstrb[1] ? pb_wr_wdata[15: 8] : sram[pb_wr_word_addr][15: 8];
assign sram_pb_merge[23:16] = pb_wr_wstrb[2] ? pb_wr_wdata[23:16] : sram[pb_wr_word_addr][23:16];
assign sram_pb_merge[31:24] = pb_wr_wstrb[3] ? pb_wr_wdata[31:24] : sram[pb_wr_word_addr][31:24];

// Port B write encoder: encode the merged 32-bit word → 39-bit codeword
hamming_enc u_enc_pb (
    .din  (sram_pb_merge),
    .dout (sram_pb_encoded)
);

// ── Port A : CPU IMEM (read-only) ─────────────────────────────────────────
logic pa_rd_pending;

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cpu_imem_arready <= 1'b0;
        cpu_imem_rvalid  <= 1'b0;
        cpu_imem_rdata   <= 32'h0;
        cpu_imem_rresp   <= 2'b00;
        pa_rd_pending    <= 1'b0;
    end else begin
        cpu_imem_arready <= 1'b0;
        if (cpu_imem_arvalid && !pa_rd_pending) begin
            cpu_imem_arready <= 1'b1;
            pa_rd_pending    <= 1'b1;
        end
        if (pa_rd_pending) begin
            cpu_imem_rvalid <= 1'b1;
            // ECC-corrected instruction word from hamming_dec u_dec_pa
            // SEC (single-bit error) → transparently corrected, CPU sees clean data
            // DED (double-bit error) → sram_ded_sticky latched → seceng_irq fires
            cpu_imem_rdata  <= sram_pa_corrected;
            cpu_imem_rresp  <= 2'b00;
            if (cpu_imem_rready) begin
                cpu_imem_rvalid <= 1'b0;
                pa_rd_pending   <= 1'b0;
            end
        end
    end
end

// ── Port B : Crossbar Slave s1 (R/W — CPU DMEM + PDF DMA) ─────────────────
logic        pb_rd_pending;
logic        pb_wr_aw_done, pb_wr_w_done;
logic [13:0] pb_wr_word_addr;   // 14-bit: covers full 64KB (16384 words)
logic [31:0] pb_wr_wdata;
logic [3:0]  pb_wr_wstrb;

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        xb_s1_awready   <= 1'b0;
        xb_s1_wready    <= 1'b0;
        xb_s1_bvalid    <= 1'b0;
        xb_s1_bresp     <= 2'b00;
        xb_s1_arready   <= 1'b0;
        xb_s1_rvalid    <= 1'b0;
        xb_s1_rdata     <= 32'h0;
        xb_s1_rresp     <= 2'b00;
        pb_rd_pending   <= 1'b0;
        pb_wr_aw_done   <= 1'b0;
        pb_wr_w_done    <= 1'b0;
        pb_wr_word_addr <= 14'h0;
        pb_wr_wdata     <= 32'h0;
        pb_wr_wstrb     <= 4'h0;
    end else begin
        xb_s1_awready <= 1'b0;
        xb_s1_wready  <= 1'b0;
        xb_s1_arready <= 1'b0;

        // ── Write path ──────────────────────────────────────────────────────
        if (xb_s1_awvalid && !pb_wr_aw_done) begin
            xb_s1_awready   <= 1'b1;
            pb_wr_aw_done   <= 1'b1;
            // Strip SRAM base 0x2000_0000; extract 14-bit word address
            pb_wr_word_addr <= xb_s1_awaddr[15:2];
        end
        if (xb_s1_wvalid && !pb_wr_w_done) begin
            xb_s1_wready <= 1'b1;
            pb_wr_w_done <= 1'b1;
            pb_wr_wdata  <= xb_s1_wdata;
            pb_wr_wstrb  <= xb_s1_wstrb;
        end
        if (pb_wr_aw_done && pb_wr_w_done) begin
            // ECC write: byte-strobe merge (combinational, via sram_pb_merge)
            // then Hamming encode (combinational, via sram_pb_encoded) →
            // write full 39-bit codeword atomically.
            // Sub-word writes (wstrb != 4'hF): old bytes from sram[] merged in
            // before re-encoding — no data corruption even on partial writes.
            sram[pb_wr_word_addr] <= sram_pb_encoded;
            xb_s1_bvalid  <= 1'b1;
            xb_s1_bresp   <= 2'b00;  // OKAY
            pb_wr_aw_done <= 1'b0;
            pb_wr_w_done  <= 1'b0;
        end
        if (xb_s1_bvalid && xb_s1_bready) xb_s1_bvalid <= 1'b0;

        // ── Read path ───────────────────────────────────────────────────────
        if (xb_s1_arvalid && !pb_rd_pending) begin
            xb_s1_arready <= 1'b1;
            pb_rd_pending <= 1'b1;
        end
        if (pb_rd_pending) begin
            xb_s1_rvalid <= 1'b1;
            // ECC-corrected data word from hamming_dec u_dec_pb
            xb_s1_rdata  <= sram_pb_corrected;
            xb_s1_rresp  <= 2'b00;
            if (xb_s1_rready) begin
                xb_s1_rvalid  <= 1'b0;
                pb_rd_pending <= 1'b0;
            end
        end
    end
end

// =============================================================================
// Unused IRQ suppression (uart_irq, i2c_irq, spi_irq available for firmware
// polling via UART/I2C/SPI status registers; not connected to seceng_irq
// to avoid spurious wakeups during key-load and data-transfer phases).
// =============================================================================
// synthesis translate_off
initial begin
    $display("[INDIA_CRYPTO_SOC] uart_irq/i2c_irq/spi_irq available for poll.");
end
// synthesis translate_on

// Tie off to avoid lint warnings (firmware polls status registers directly)
logic _unused_irqs;
assign _unused_irqs = uart_irq | i2c_irq | spi_irq;

// SEC flags: correctable errors are silent (CPU sees fixed data automatically).
// Firmware can poll a future ECC status register; for now suppress lint warning.
logic _unused_sec;
assign _unused_sec = sram_pa_sec | sram_pb_sec;

endmodule
// =============================================================================
// End of india_crypto_soc.v
// =============================================================================
