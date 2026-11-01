// =============================================================================
// soc_tb_image.sv — Full SoC image encrypt/decrypt testbench
//
// Loads a 64-byte JPEG slice (first 64 bytes of Aadhaar JPEG) into SRAM,
// then lets the CPU firmware:
//   1.  Validate Aadhaar number via AADHAAR.CHECK custom instruction
//   2.  Encrypt the JPEG slice with AES-256-CTR via the PDF engine
//   3.  Decrypt the ciphertext back using the same key/nonce
//   4.  Compare decrypted bytes with the original word-by-word
//   5.  Write PASS (0x900DDEAD) or FAIL (0xDEADF00D) to GPIO
//
// Memory layout (SRAM base 0x20000000):
//   [0x000] Firmware         (image_firmware.hex, 94 instructions)
//   [0x100] Image SRC        (aadhar_slice.hex, 16 words = 64 bytes)
//   [0x200] Encrypted DST    (header + cipher + tag, engine writes here)
//   [0x400] Decrypted DST    (header + recovered plaintext, engine writes here)
//   [0x404] Decrypted DATA   (first recovered plaintext word)
//
// Build (from dv/tb/):
//   python3 image_to_hex.py        # generates test_vectors/aadhar/aadhar_slice.hex
//   python3 fw_gen_image.py        # generates image_firmware.hex
//   bash compile_image.sh          # compiles the SoC
//   vvp soc_tb_image.vvp
// =============================================================================

`timescale 1ns/1ps

module soc_tb_image;

// ---------------------------------------------------------------------------
// Parameters
// ---------------------------------------------------------------------------
localparam CLK_PERIOD_NS   = 10;
localparam ROSC_PERIOD_NS  = 7;
localparam RESET_CYCLES    = 20;
localparam WATCHDOG_CYCLES = 5_000_000;     // ~50 ms simulated @ 100 MHz
localparam SRAM_DEPTH      = 16384;

// SRAM word offsets for each region
localparam IMG_WORD_OFFSET  = 32'h100;     // 0x20000400 / 4 = 0x80000100; relative = 0x100
localparam ENC_WORD_OFFSET  = 32'h200;     // 0x20000800 = enc_dst
localparam DEC_WORD_OFFSET  = 32'h400;     // 0x20001000 = dec_dst
localparam DEC_DATA_OFFSET  = 32'h404;     // 0x20001010 = dec_dst + 16 (actual payload)

localparam PASS_VALUE = 32'h900D_DEAD;
localparam FAIL_VALUE = 32'hDEAD_F00D;

// ---------------------------------------------------------------------------
// Signals
// ---------------------------------------------------------------------------
logic        clk;
logic        rst_n;
logic        rosc_ext;
wire         uart_tx_wire;
wire         i2c_sda;
wire         i2c_scl;
wire  [31:0] gpio_out;
wire  [31:0] gpio_dir;
wire         seceng_irq;

// ---------------------------------------------------------------------------
// Clock generation
// ---------------------------------------------------------------------------
initial clk = 1'b0;
always #(CLK_PERIOD_NS/2) clk = ~clk;

initial rosc_ext = 1'b0;
always #(ROSC_PERIOD_NS/2) rosc_ext = ~rosc_ext;

// ---------------------------------------------------------------------------
// I2C pull-ups
// ---------------------------------------------------------------------------
pullup(i2c_sda);
pullup(i2c_scl);

// ---------------------------------------------------------------------------
// DUT
// ---------------------------------------------------------------------------
india_crypto_soc #(
    .RESET_ADDR (32'h2000_0000)
) dut (
    .clk        (clk),
    .rst_n      (rst_n),
    .rosc_ext   (rosc_ext),
    .uart_rx    (uart_tx_wire),
    .uart_tx    (uart_tx_wire),
    .i2c_sda    (i2c_sda),
    .i2c_scl    (i2c_scl),
    .spi_miso   (1'b0),
    .gpio_in    (32'h0),
    .gpio_out   (gpio_out),
    .gpio_dir   (gpio_dir),
    .spi_mosi   (),
    .spi_sck    (),
    .spi_cs_n   (),
    .seceng_irq (seceng_irq)
);

// ---------------------------------------------------------------------------
// Reset + SRAM preload
//   [0]      ← image_firmware.hex     (firmware)
//   [0x100]  ← aadhar_slice.hex       (64-byte JPEG slice = 16 words)
// ---------------------------------------------------------------------------
reg [31:0] sram_init [0:SRAM_DEPTH-1];
integer    i_init;

initial begin : reset_and_preload
    rst_n = 1'b0;

    // NOP fill
    for (i_init = 0; i_init < SRAM_DEPTH; i_init = i_init + 1)
        sram_init[i_init] = 32'h0000_0013;

    // Load firmware at offset 0
    $display("[%0t] [tb] Loading image_firmware.hex", $time);
    $readmemh("image_firmware.hex", sram_init, 0);

    // Load JPEG slice at SRAM word offset 0x100 (= byte offset 0x400 = address 0x20000400)
    $display("[%0t] [tb] Loading aadhar_slice.hex at SRAM[0x100]", $time);
    $readmemh("test_vectors/aadhar/aadhar_slice.hex", sram_init, 32'h100);

    repeat (RESET_CYCLES) @(posedge clk);
    @(negedge clk);
    rst_n = 1'b1;
    @(posedge clk);

    // Push to DUT SRAM
    $display("[%0t] [tb] Preloading DUT SRAM", $time);
    $readmemh("image_firmware.hex",                         dut.u_sram_ctrl.u_sram.mem, 0);
    $readmemh("test_vectors/aadhar/aadhar_slice.hex",       dut.u_sram_ctrl.u_sram.mem, 32'h100);

    $display("[%0t] [tb] CPU released. FW[0]=0x%08x  IMG[0]=0x%08x  IMG[1]=0x%08x",
             $time,
             dut.u_sram_ctrl.u_sram.mem[0],
             dut.u_sram_ctrl.u_sram.mem[32'h100],
             dut.u_sram_ctrl.u_sram.mem[32'h101]);
end

// ---------------------------------------------------------------------------
// Diagnostic helpers
// ---------------------------------------------------------------------------

// Track encryption + decryption completions
reg enc_done_seen;
reg dec_done_seen;

initial begin
    enc_done_seen = 0;
    dec_done_seen = 0;
end

// ---------------------------------------------------------------------------
// Main monitor loop
// ---------------------------------------------------------------------------
integer cycle_cnt;

initial begin : main_monitor
    cycle_cnt = 0;
    @(posedge rst_n);

    forever begin
        @(posedge clk);
        cycle_cnt = cycle_cnt + 1;

        // ── Early pipeline dump ─────────────────────────────────────────────
        if (cycle_cnt <= 20)
            $display("[%0t] cyc=%0d axi_st=%0d if_de_v=%b de_ex_v=%b pc=0x%08x",
                     $time, cycle_cnt,
                     dut.u_cpu.imem_state,
                     dut.u_cpu.ifid_valid,
                     dut.u_cpu.idex_valid,
                     dut.u_cpu.pc);

        // ── Aadhaar custom instruction phase (cycles 21-100) ─────────────
        if (cycle_cnt > 20 && cycle_cnt <= 100)
            $display("[%0t] cyc=%0d pc=0x%08x x7=%08x x28=%08x pcpi_v=%0b pcpi_rd=%08x",
                     $time, cycle_cnt,
                     dut.u_cpu.pc,
                     dut.u_cpu.regfile[7],
                     dut.u_cpu.regfile[28],
                     dut.u_cpu.custom_valid,
                     dut.u_cpu.custom_rd);

        // ── PDF engine writes (AXI-Lite to PDF engine at 0x30002000) ─────
        if (dut.u_cpu.dmem_awaddr >= 32'h3000_2000 &&
            dut.u_cpu.dmem_awaddr <= 32'h3000_20FF &&
            dut.u_cpu.dmem_awvalid)
            $display("[%0t] [PDF_CFG] cyc=%0d awaddr=0x%08x wdata=0x%08x",
                     $time, cycle_cnt,
                     dut.u_cpu.dmem_awaddr,
                     dut.u_cpu.dmem_wdata);

        // ── PDF STATUS reads (firmware polling) ─────────────────────────
        if (dut.u_cpu.dmem_araddr === 32'h3000_2008 &&
            dut.u_pdf.s_rvalid && dut.u_pdf.s_rready)
            $display("[%0t] [POLL] cyc=%0d status=0x%08x [busy=%b done=%b auth_ok=%b]",
                     $time, cycle_cnt,
                     dut.u_pdf.s_rdata,
                     dut.u_pdf.reg_busy,
                     dut.u_pdf.reg_done,
                     dut.u_pdf.reg_auth_ok);

        // ── PDF engine state trace every 50 cycles (cyc 350-1100) ──────────
        if ((cycle_cnt % 50 == 0) && cycle_cnt >= 350 && cycle_cnt <= 1100)
            $display("[%0t] [ST50] cyc=%0d  pdf_st=%0d  busy=%b  done=%b  dec=%b  auth_ok=%b  auth_fail=%b  pc=0x%08x  sram_tag0=0x%08x",
                     $time, cycle_cnt,
                     dut.u_pdf.state,
                     dut.u_pdf.reg_busy,
                     dut.u_pdf.reg_done,
                     dut.u_pdf.decrypt_mode,
                     dut.u_pdf.reg_auth_ok,
                     dut.u_pdf.reg_auth_fail,
                     dut.u_cpu.pc,
                     dut.u_sram_ctrl.u_sram.mem[32'h214]);

        // ── Fine-grained CPU+AXI trace (cyc 350-550) ──────────
        if ((cycle_cnt >= 350 && cycle_cnt <= 550)) begin
            $display("[%0t] [DBG] cyc=%0d pc=%08x x10=%08x x11=%08x | axi=%0d if=%b ex=%b | ar:v=%b a=%08x r=%b d=%08x | aw:v=%b a=%08x w=%08x | pdf:b=%b d=%b st=%0d",
                     $time, cycle_cnt,
                     dut.u_cpu.pc,
                     dut.u_cpu.regfile[10],
                     dut.u_cpu.regfile[11],
                     dut.u_cpu.imem_state,
                     dut.u_cpu.ifid_valid,
                     dut.u_cpu.idex_valid,
                     dut.u_cpu.dmem_arvalid,
                     dut.u_cpu.dmem_araddr,
                     dut.u_cpu.dmem_rvalid,
                     dut.u_cpu.dmem_rdata,
                     dut.u_cpu.dmem_awvalid,
                     dut.u_cpu.dmem_awaddr,
                     dut.u_cpu.dmem_wdata,
                     dut.u_pdf.reg_busy,
                     dut.u_pdf.reg_done,
                     dut.u_pdf.state);
        end

        // ── Encryption done ──────────────────────────────────────────────
        if (dut.u_pdf.reg_done && !enc_done_seen && !dut.u_pdf.decrypt_mode) begin
            enc_done_seen = 1;
            $display("");
            $display("[%0t] [ENC] Encryption complete after %0d cycles", $time, cycle_cnt);
            $display("[%0t] [ENC] PDF engine result_tag (CSR) = 0x%08x_%08x_%08x_%08x",
                     $time,
                     dut.u_pdf.result_tag[127:96],
                     dut.u_pdf.result_tag[95:64],
                     dut.u_pdf.result_tag[63:32],
                     dut.u_pdf.result_tag[31:0]);
            // Tag is written to SRAM at ENC_DST+80..92 = word indices 0x214..0x217
            $display("[%0t] [ENC] SRAM tag (0x20000850) = 0x%08x 0x%08x 0x%08x 0x%08x",
                     $time,
                     dut.u_sram_ctrl.u_sram.mem[32'h214],
                     dut.u_sram_ctrl.u_sram.mem[32'h215],
                     dut.u_sram_ctrl.u_sram.mem[32'h216],
                     dut.u_sram_ctrl.u_sram.mem[32'h217]);
            $display("[%0t] [ENC] SRAM[ENC_DST+0]  = 0x%08x  (encrypted header w0)",
                     $time, dut.u_sram_ctrl.u_sram.mem[32'h200]);
            $display("[%0t] [ENC] SRAM[ENC_DST+4]  = 0x%08x  (encrypted content w0)",
                     $time, dut.u_sram_ctrl.u_sram.mem[32'h204]);
            $display("");
        end

        // ── Decryption done ──────────────────────────────────────────────
        if (dut.u_pdf.reg_done && !dec_done_seen && dut.u_pdf.decrypt_mode) begin
            dec_done_seen = 1;
            $display("");
            $display("[%0t] [DEC] Decryption complete after %0d cycles", $time, cycle_cnt);
            $display("[%0t] [DEC] auth_ok=%b  auth_fail=%b  error=%b",
                     $time,
                     dut.u_pdf.reg_auth_ok,
                     dut.u_pdf.reg_auth_fail,
                     dut.u_pdf.reg_error);
            $display("[%0t] [DEC] Original  SRAM[0x100] = 0x%08x  SRAM[0x101] = 0x%08x",
                     $time,
                     dut.u_sram_ctrl.u_sram.mem[32'h100],
                     dut.u_sram_ctrl.u_sram.mem[32'h101]);
            $display("[%0t] [DEC] Recovered SRAM[0x404] = 0x%08x  SRAM[0x405] = 0x%08x",
                     $time,
                     dut.u_sram_ctrl.u_sram.mem[32'h404],
                     dut.u_sram_ctrl.u_sram.mem[32'h405]);
            $display("");
        end

        // ── PDF engine state heartbeat ───────────────────────────────────
        if ((cycle_cnt % 1_000) == 0 && cycle_cnt >= 5_000 && cycle_cnt <= 500_000)
            $display("[%0t] [HB] cyc=%0d  pdf_st=%0d  busy=%b  done=%b  dec=%b  auth_ok=%b  pc=0x%08x",
                     $time, cycle_cnt,
                     dut.u_pdf.state,
                     dut.u_pdf.reg_busy,
                     dut.u_pdf.reg_done,
                     dut.u_pdf.decrypt_mode,
                     dut.u_pdf.reg_auth_ok,
                     dut.u_cpu.pc);

        // ── 100K progress heartbeat ──────────────────────────────────────
        if ((cycle_cnt % 100_000) == 0)
            $display("[%0t] [tb] cyc=%0d  gpio=0x%08x  pdf_st=%0d  pc=0x%08x",
                     $time, cycle_cnt, gpio_out, dut.u_pdf.state, dut.u_cpu.pc);

        // ── PASS ─────────────────────────────────────────────────────────
        if (gpio_out === PASS_VALUE) begin
            $display("");
            $display("=================================================================");
            $display("  *** IMAGE ENCRYPT/DECRYPT SIMULATION PASSED ***");
            $display("  GPIO = 0x%08x after %0d cycles", gpio_out, cycle_cnt);
            $display("");
            $display("  Step 1 — Aadhaar validation  : PASS  (2000 5555 5554)");
            $display("  Step 2 — AES-256-CTR encrypt : PASS  (64-byte JPEG slice)");
            $display("  Step 3 — AES-256-CTR decrypt : PASS  (same key/nonce)");
            $display("  Step 4 — Auth tag verify     : PASS  (exp_tag matched)");
            $display("  Step 5 — Byte-level compare  : PASS  (16 words match)");
            $display("");
            $display("  Key    = [1,2,3,4,5,6,7,8] (AES-256)");
            $display("  Nonce  = [1,2,3,4]");
            $display("  SRC    = 0x20000400  (original JPEG slice)");
            $display("  ENC    = 0x20000800  (encrypted output)");
            $display("  DEC    = 0x20001010  (decrypted output)");
            $display("=================================================================");
            $display("");
            $finish(0);
        end

        // ── FAIL ─────────────────────────────────────────────────────────
        if (gpio_out === FAIL_VALUE) begin
            $display("");
            $display("=================================================================");
            $display("  *** IMAGE ENCRYPT/DECRYPT SIMULATION FAILED ***");
            $display("  GPIO = 0x%08x after %0d cycles", gpio_out, cycle_cnt);
            $display("");
            $display("  PDF state=%0d busy=%b done=%b auth_ok=%b auth_fail=%b error=%b",
                     dut.u_pdf.state,
                     dut.u_pdf.reg_busy,
                     dut.u_pdf.reg_done,
                     dut.u_pdf.reg_auth_ok,
                     dut.u_pdf.reg_auth_fail,
                     dut.u_pdf.reg_error);
            $display("  CPU pc=0x%08x", dut.u_cpu.pc);
            $display("  Aadhaar: verhoeff=%b first_digit=%b",
                     dut.u_pdf.adh_verhoeff_ok, dut.u_pdf.adh_first_digit_ok);
            $display("=================================================================");
            $display("");
            $finish(1);
        end

        // ── Watchdog ─────────────────────────────────────────────────────
        if (cycle_cnt >= WATCHDOG_CYCLES) begin
            $display("");
            $display("=================================================================");
            $display("  *** WATCHDOG TIMEOUT after %0d cycles ***", WATCHDOG_CYCLES);
            $display("  gpio_out = 0x%08x", gpio_out);
            $display("  PDF: state=%0d busy=%b done=%b auth_ok=%b auth_fail=%b error=%b",
                     dut.u_pdf.state,
                     dut.u_pdf.reg_busy,
                     dut.u_pdf.reg_done,
                     dut.u_pdf.reg_auth_ok,
                     dut.u_pdf.reg_auth_fail,
                     dut.u_pdf.reg_error);
            $display("  CPU: pc=0x%08x  x7=0x%08x  x8=0x%08x",
                     dut.u_cpu.pc,
                     dut.u_cpu.regfile[7],
                     dut.u_cpu.regfile[8]);
            $display("=================================================================");
            $display("");
            $finish(1);
        end

    end // forever
end // initial main_monitor

endmodule
