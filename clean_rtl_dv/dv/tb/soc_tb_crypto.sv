// =============================================================================
// soc_tb_crypto.sv — Full SoC simulation testbench for india_crypto_soc
//
// Purpose:
//   Loads firmware (fw_gen.py output) into SRAM starting at offset 0 (addr 0x20000000).
//   Loads 64 words of plaintext into SRAM at offset 0x800 (addr 0x20000800).
//   CPU boots at 0x20000000, drives the india_pdf_engine to encrypt then decrypt
//   the plaintext, compares output to input, and writes PASS/FAIL to GPIO.
//
// Build (from dv/tb/):
//   iverilog -g2012 -o soc_tb_crypto.vvp \
//       ../../rtl/top/india_crypto_soc.v   \
//       ../../rtl/core/rv32im_core.v        \
//       ../../rtl/core/aes_isa_ext.v        \
//       ../../rtl/crypto/aes_ca_accel.v     \
//       ../../rtl/crypto/india_pdf_engine.v \
//       ../../rtl/crypto/rosc_trng.v        \
//       ../../rtl/crypto/hamming_secded.v   \
//       ../../rtl/fabric/axi_lite_xbar.v    \
//       ../../rtl/mem/sram_ctrl.v           \
//       ../../rtl/mem/sram_sp_wrap.v        \
//       ../../rtl/periph/pulp_uart_wrap.sv  \
//       ../../rtl/periph/pulp_i2c_wrap.sv   \
//       ../../rtl/periph/pulp_spi_wrap.sv   \
//       ../../rtl/periph/axil_to_apb.sv     \
//       ../../rtl/periph/clint.v            \
//       ../../rtl/periph/plic.v             \
//       ../../rtl/periph/gpio.v             \
//       soc_tb_crypto.sv
//   vvp soc_tb_crypto.vvp
//
// Generated artifacts (git-ignored): soc_tb_crypto.vvp, firmware.hex, *.vcd
// =============================================================================

`timescale 1ns/1ps

module soc_tb_crypto;

// ---------------------------------------------------------------------------
// Parameters
// ---------------------------------------------------------------------------
localparam CLK_PERIOD_NS   = 10;
localparam ROSC_PERIOD_NS  = 7;
localparam RESET_CYCLES    = 20;
localparam WATCHDOG_CYCLES = 2_000_000;
localparam SRAM_DEPTH      = 16384;

// SRAM base word indices
localparam FW_WORD_OFFSET  = 0;       // firmware loads at SRAM[0] = 0x20000000
localparam PT_WORD_OFFSET  = 512;     // plaintext at SRAM[512] = 0x20000800

// GPIO sentinel values
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
logic [31:0] gpio_in;
wire  [31:0] gpio_out;
wire  [31:0] gpio_dir;
wire         seceng_irq;

// ---------------------------------------------------------------------------
// Preload memory array — sized to match sram_sp_wrap depth
// ---------------------------------------------------------------------------
reg [31:0] sram_init [0:SRAM_DEPTH-1];
reg [31:0] pt_mem    [0:63];           // 64 words = 256 bytes of plaintext

// ---------------------------------------------------------------------------
// Clock generation
// ---------------------------------------------------------------------------
initial clk = 1'b0;
always #(CLK_PERIOD_NS/2) clk = ~clk;

// ROSC external (async, 7 ns period)
initial rosc_ext = 1'b0;
always #(ROSC_PERIOD_NS/2) rosc_ext = ~rosc_ext;

// ---------------------------------------------------------------------------
// I2C pull-ups
// ---------------------------------------------------------------------------
pullup(i2c_sda);
pullup(i2c_scl);

// ---------------------------------------------------------------------------
// DUT instantiation  — CPU boots at SRAM base 0x20000000
// ---------------------------------------------------------------------------
india_crypto_soc #(
    .RESET_ADDR (32'h2000_0000)
) dut (
    .clk        (clk),
    .rst_n      (rst_n),
    .rosc_ext   (rosc_ext),
    .uart_rx    (uart_tx_wire),       // UART loopback
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
// ---------------------------------------------------------------------------
integer i_init;

// Temporary combined hex file path — created at sim-time
// We use $readmemh directly into the DUT SRAM's internal mem array.
// Icarus supports $readmemh with hierarchical path targets.

initial begin : reset_and_preload
    // Drive reset low
    rst_n  = 1'b0;
    gpio_in = 32'h0;

    // Zero-fill the shadow array
    for (i_init = 0; i_init < SRAM_DEPTH; i_init = i_init + 1)
        sram_init[i_init] = 32'h0000_0013;   // NOP fill

    // Load firmware hex (fw_gen.py output) into shadow starting at word 0
    $display("[%0t] [tb] Loading firmware.hex", $time);
    $readmemh("firmware.hex", sram_init, 0);

    // Load first 64 words of plaintext into shadow at word offset 512 (0x20000800)
    $display("[%0t] [tb] Loading test_vectors/pdf/original.hex (64 words @ offset 512)", $time);
    $readmemh("test_vectors/pdf/original.hex", pt_mem, 0, 63);
    for (i_init = 0; i_init < 64; i_init = i_init + 1)
        sram_init[PT_WORD_OFFSET + i_init] = pt_mem[i_init];

    // Hold reset for RESET_CYCLES
    repeat (RESET_CYCLES) @(posedge clk);
    @(negedge clk);
    rst_n = 1'b1;
    @(posedge clk);

    // Preload DUT SRAM using $readmemh directly onto the internal array
    // This works in Icarus 12 without needing force on a whole array.
    $display("[%0t] [tb] Preloading DUT SRAM via $readmemh on internal mem", $time);
    $readmemh("firmware.hex",               dut.u_sram_ctrl.u_sram.mem, 0);
    $readmemh("test_vectors/pdf/original.hex", dut.u_sram_ctrl.u_sram.mem,
              PT_WORD_OFFSET, PT_WORD_OFFSET + 63);

    $display("[%0t] [tb] SRAM preload complete. CPU running at PC=0x20000000", $time);
    $display("[%0t] [tb] SRAM[0]=0x%08x SRAM[1]=0x%08x SRAM[2]=0x%08x",
             $time,
             dut.u_sram_ctrl.u_sram.mem[0],
             dut.u_sram_ctrl.u_sram.mem[1],
             dut.u_sram_ctrl.u_sram.mem[2]);
    $display("[%0t] [tb] SRAM[512]=0x%08x (plaintext[0])",
             $time, dut.u_sram_ctrl.u_sram.mem[512]);
end

// ---------------------------------------------------------------------------
// GPIO monitor — poll every cycle for PASS/FAIL sentinel
// ---------------------------------------------------------------------------
integer cycle_cnt;

initial begin : gpio_monitor
    cycle_cnt = 0;
    @(posedge rst_n);   // wait until reset released

    forever begin
        @(posedge clk);
        cycle_cnt = cycle_cnt + 1;

        // Detailed early diagnostics
        if (cycle_cnt <= 30)
            $display("[%0t] cyc=%0d imem_state=%0d stall_if=%0b trap_req=%0b stall_id=%0b flush_id=%0b ifid_valid=%0b idex_valid=%0b imem_rdata=0x%08x",
                     $time, cycle_cnt,
                     dut.u_cpu.imem_state,
                     dut.u_cpu.stall_if,
                     dut.u_cpu.trap_req,
                     dut.u_cpu.stall_id,
                     dut.u_cpu.flush_id,
                     dut.u_cpu.ifid_valid,
                     dut.u_cpu.idex_valid,
                     dut.u_cpu.imem_rdata);
        // First 60 cycles: watch regfile values, dmem, pipeline
        if (cycle_cnt <= 60)
            $display("[%0t] cyc=%0d x5=0x%08x x6=0x%08x idex_instr=0x%08x idex_rs1=%0d idex_rs2=%0d fwd_rs1=0x%08x fwd_rs2=0x%08x exmem_rd=%0d exmem_alu=0x%08x exmem_rs2v=0x%08x exmem_mw=%0b dmem_awaddr=0x%08x dmem_wdata=0x%08x dmem_pend_addr=0x%08x wr_st=%0d dmem_op=%0b",
                     $time, cycle_cnt,
                     dut.u_cpu.regfile[5],
                     dut.u_cpu.regfile[6],
                     dut.u_cpu.idex_instr,
                     dut.u_cpu.idex_rs1,
                     dut.u_cpu.idex_rs2,
                     dut.u_cpu.fwd_rs1,
                     dut.u_cpu.fwd_rs2,
                     dut.u_cpu.exmem_rd,
                     dut.u_cpu.exmem_alu_result,
                     dut.u_cpu.exmem_rs2_val,
                     dut.u_cpu.exmem_mem_write,
                     dut.u_cpu.dmem_awaddr,
                     dut.u_cpu.dmem_wdata,
                     dut.u_cpu.dmem_pending_addr,
                     dut.u_cpu.dmem_wr_state,
                     dut.u_cpu.dmem_op_pending);
        // AXI handshake diagnostics around first PDF store
        if (cycle_cnt >= 55 && cycle_cnt <= 90)
            $display("[%0t] cyc=%0d wr_st=%0d dmem_awvalid=%0b dmem_awaddr=0x%08x dmem_wvalid=%0b dmem_bvalid=%0b s4_awvalid=%0b s4_awready=%0b s4_wvalid=%0b s4_wready=%0b s4_bvalid=%0b s4_bready=%0b pdf_aw_valid_r=%0b",
                     $time, cycle_cnt,
                     dut.u_cpu.dmem_wr_state,
                     dut.u_cpu.dmem_awvalid,
                     dut.u_cpu.dmem_awaddr,
                     dut.u_cpu.dmem_wvalid,
                     dut.u_cpu.dmem_bvalid,
                     dut.xb_s4_awvalid,
                     dut.xb_s4_awready,
                     dut.xb_s4_wvalid,
                     dut.xb_s4_wready,
                     dut.xb_s4_bvalid,
                     dut.xb_s4_bready,
                     dut.u_pdf.aw_addr_valid_r);
        // PDF read path diagnostics: watch status register reads
        if (dut.u_cpu.dmem_araddr === 32'h30002008 && (dut.u_cpu.dmem_rd_state !== 0 || dut.u_cpu.dmem_op_pending))
            $display("[%0t] cyc=%0d RD_STATUS rd_st=%0d arvalid=%0b araddr=0x%08x arready=%0b rvalid=%0b rdata=0x%08x rready=%0b s4_arvalid=%0b s4_arready=%0b s4_rvalid=%0b s4_rdata=0x%08x pdf_done=%0b pdf_auth=%0b dmem_rdata_r=0x%08x",
                     $time, cycle_cnt,
                     dut.u_cpu.dmem_rd_state,
                     dut.u_cpu.dmem_arvalid,
                     dut.u_cpu.dmem_araddr,
                     dut.u_cpu.dmem_arready,
                     dut.u_cpu.dmem_rvalid,
                     dut.u_cpu.dmem_rdata,
                     dut.u_cpu.dmem_rready,
                     dut.xb_s4_arvalid,
                     dut.xb_s4_arready,
                     dut.xb_s4_rvalid,
                     dut.xb_s4_rdata,
                     dut.u_pdf.reg_done,
                     dut.u_pdf.reg_auth_ok,
                     dut.u_cpu.dmem_rdata_r);

        // Fine-grained heartbeat every 1K cycles in the critical window
        if ((cycle_cnt % 1_000) == 0 && cycle_cnt >= 80_000 && cycle_cnt <= 120_000)
            $display("[%0t] [tb1k] cyc=%0d imem_st=%0d imem_ar=0x%08x pc=0x%08x stall_if=%0b stall_id=%0b exmem_v=%0b exmem_mr=%0b exmem_mw=%0b dmem_op=%0b dmem_rs=%0d pdf_st=%0d reg_done=%0b reg_busy=%0b sram_cpu_rd_wait=%0b sram_axi_rd_wait=%0b sram_do_wr=%0b trap=%0b x6=0x%08x x7=0x%08x x8=0x%08x",
                     $time, cycle_cnt,
                     dut.u_cpu.imem_state,
                     dut.u_cpu.imem_araddr,
                     dut.u_cpu.pc,
                     dut.u_cpu.stall_if,
                     dut.u_cpu.stall_id,
                     dut.u_cpu.exmem_valid,
                     dut.u_cpu.exmem_mem_read,
                     dut.u_cpu.exmem_mem_write,
                     dut.u_cpu.dmem_op_pending,
                     dut.u_cpu.dmem_rd_state,
                     dut.u_pdf.state,
                     dut.u_pdf.reg_done,
                     dut.u_pdf.reg_busy,
                     dut.u_sram_ctrl.cpu_rd_wait,
                     dut.u_sram_ctrl.axi_rd_wait,
                     dut.u_sram_ctrl.do_wr,
                     dut.u_cpu.trap_req,
                     dut.u_cpu.regfile[6],
                     dut.u_cpu.regfile[7],
                     dut.u_cpu.regfile[8]);
        // Trap fire detector
        if (dut.u_cpu.trap_req && cycle_cnt > 100)
            $display("[%0t] [TRAP] cyc=%0d pc=0x%08x ifid_pc=0x%08x idex_pc=0x%08x exmem_pc=0x%08x trap_cause=0x%08x",
                     $time, cycle_cnt,
                     dut.u_cpu.pc,
                     dut.u_cpu.ifid_pc,
                     dut.u_cpu.idex_pc,
                     dut.u_cpu.exmem_pc,
                     dut.u_cpu.trap_cause);
        // PDF engine AR fire — capture exactly what s_rdata is set to
        if (dut.u_pdf.s_arvalid && !dut.u_pdf.s_arready)
            $display("[%0t] [PDF_AR] cyc=%0d s_araddr=0x%08x reg_done=%0b reg_busy=%0b reg_auth_ok=%0b reg_auth_fail=%0b reg_error=%0b pdf_state=%0d -> s_rdata_nxt=0x%08x",
                     $time, cycle_cnt,
                     dut.u_pdf.s_araddr,
                     dut.u_pdf.reg_done,
                     dut.u_pdf.reg_busy,
                     dut.u_pdf.reg_auth_ok,
                     dut.u_pdf.reg_auth_fail,
                     dut.u_pdf.reg_error,
                     dut.u_pdf.state,
                     {27'h0, dut.u_pdf.reg_error, dut.u_pdf.reg_auth_fail, dut.u_pdf.reg_auth_ok, dut.u_pdf.reg_done, dut.u_pdf.reg_busy});

        // Progress heartbeat
        if ((cycle_cnt % 100_000) == 0)
            $display("[%0t] [tb] cyc=%0d gpio=0x%08x CPU_imem=0x%08x dmem_ar=0x%08x rd_st=%0d dmem_rvalid=%0b dmem_op_pend=%0b pdf_state=%0d pdf_busy=%0b pdf_done=%0b pdf_auth=%0b x6=0x%08x",
                     $time, cycle_cnt, gpio_out,
                     dut.u_cpu.imem_araddr,
                     dut.u_cpu.dmem_araddr,
                     dut.u_cpu.dmem_rd_state,
                     dut.u_cpu.dmem_rvalid,
                     dut.u_cpu.dmem_op_pending,
                     dut.u_pdf.state,
                     dut.u_pdf.reg_busy,
                     dut.u_pdf.reg_done,
                     dut.u_pdf.reg_auth_ok,
                     dut.u_cpu.regfile[6]);

        // Check for PASS
        if (gpio_out === PASS_VALUE) begin
            $display("");
            $display("========================================================");
            $display("  *** SIMULATION PASSED ***");
            $display("  GPIO = 0x%08x = PASS after %0d cycles", gpio_out, cycle_cnt);
            $display("  Encrypt + Decrypt + Compare: all OK");
            $display("========================================================");
            $display("");
            $finish(0);
        end

        // Check for FAIL
        if (gpio_out === FAIL_VALUE) begin
            $display("");
            $display("========================================================");
            $display("  *** SIMULATION FAILED ***");
            $display("  GPIO = 0x%08x = FAIL after %0d cycles", gpio_out, cycle_cnt);
            $display("  Plaintext/decrypted mismatch or auth_fail detected");
            $display("  PDF engine state: busy=%0b done=%0b auth_ok=%0b auth_fail=%0b",
                     dut.u_pdf.reg_busy, dut.u_pdf.reg_done,
                     dut.u_pdf.reg_auth_ok, dut.u_pdf.reg_auth_fail);
            $display("========================================================");
            $display("");
            $finish(1);
        end

        // Watchdog
        if (cycle_cnt >= WATCHDOG_CYCLES) begin
            $display("");
            $display("========================================================");
            $display("  *** WATCHDOG TIMEOUT after %0d cycles ***", WATCHDOG_CYCLES);
            $display("  gpio_out = 0x%08x", gpio_out);
            $display("  PDF engine: state=%0d busy=%0b done=%0b auth_ok=%0b auth_fail=%0b error=%0b",
                     dut.u_pdf.state, dut.u_pdf.reg_busy, dut.u_pdf.reg_done,
                     dut.u_pdf.reg_auth_ok, dut.u_pdf.reg_auth_fail, dut.u_pdf.reg_error);
            $display("  CPU imem_araddr = 0x%08x", dut.u_cpu.imem_araddr);
            $display("  CPU dmem_araddr = 0x%08x", dut.u_cpu.dmem_araddr);
            $display("  CPU dmem_awaddr = 0x%08x", dut.u_cpu.dmem_awaddr);
            $display("========================================================");
            $display("");
            $finish(1);
        end
    end
end

// ---------------------------------------------------------------------------
// VCD dump (optional — compile with +define+DUMP or add plusarg support)
// ---------------------------------------------------------------------------
`ifdef DUMP
initial begin
    $dumpfile("soc_tb_crypto.vcd");
    $dumpvars(0, soc_tb_crypto);
    $display("[%0t] [tb] VCD dump enabled", $time);
end
`endif

endmodule
