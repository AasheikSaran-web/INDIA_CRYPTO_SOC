// =============================================================================
// soc_tb_aadhaar.sv — Aadhaar-specific SoC simulation testbench
//
// Purpose:
//   Loads aadhaar_firmware.hex (fw_gen_aadhaar.py output) into SRAM.
//   Firmware:
//     1. Writes sample Aadhaar XML data (<?xm magic + test pattern) to SRAM
//     2. Programs Aadhaar number "2000 5555 5554" BCD into engine validation CSRs
//     3. Writes document header word to engine CSR and reads validation status
//     4. If validation passes: encrypts + decrypts + compares
//     5. Writes PASS (0x900DDEAD) or FAIL (0xDEADF00D) to GPIO
//
// Validation checks performed by hardware:
//   - Verhoeff checksum on 12-digit Aadhaar number
//   - Leading digit in [2..9] (UIDAI rule)
//   - Document header word matches Aadhaar XML magic 0x6D783F3C ('<?xm' LE)
//
// Build (from dv/tb/):
//   python3 fw_gen_aadhaar.py        # generates aadhaar_firmware.hex
//   iverilog -g2012 -o soc_tb_aadhaar.vvp \
//       ../../rtl/top/india_crypto_soc.v    \
//       ../../rtl/core/rv32im_core.v        \
//       ../../rtl/core/aes_isa_ext.v        \
//       ../../rtl/crypto/aes_ca_accel.v     \
//       ../../rtl/crypto/india_pdf_engine.v \
//       ../../rtl/crypto/verhoeff_check.v   \
//       ../../rtl/crypto/aadhaar_id_check.v \
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
//       ../../rtl/periph/vendor/pulp_blackbox.v \
//       soc_tb_aadhaar.sv
//   vvp soc_tb_aadhaar.vvp
// =============================================================================

`timescale 1ns/1ps

module soc_tb_aadhaar;

// ---------------------------------------------------------------------------
// Parameters
// ---------------------------------------------------------------------------
localparam CLK_PERIOD_NS   = 10;
localparam ROSC_PERIOD_NS  = 7;
localparam RESET_CYCLES    = 20;
localparam WATCHDOG_CYCLES = 2_000_000;
localparam SRAM_DEPTH      = 131072;

localparam FW_WORD_OFFSET  = 0;    // firmware at SRAM[0] = 0x20000000

// GPIO sentinel values
localparam PASS_VALUE = 32'h900D_DEAD;
localparam FAIL_VALUE = 32'hDEAD_F00D;

// Aadhaar validation CSR addresses (AXI address space)
localparam ADH_STATUS_ADDR = 32'h3000_2090;  // REG_ADH_STATUS

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
// Reset + SRAM preload — firmware only (no original.hex; firmware writes data)
// ---------------------------------------------------------------------------
reg [31:0] sram_init [0:SRAM_DEPTH-1];
integer i_init;

initial begin : reset_and_preload
    rst_n   = 1'b0;
    gpio_in = 32'h0;

    for (i_init = 0; i_init < SRAM_DEPTH; i_init = i_init + 1)
        sram_init[i_init] = 32'h0000_0013;   // NOP fill

    $display("[%0t] [tb] Loading aadhaar_firmware.hex", $time);
    $readmemh("aadhaar_firmware.hex", sram_init, 0);

    // Note: no original.hex load — the Aadhaar firmware itself writes the
    // test data (XML magic + pattern) into SRAM at SRC_BASE (0x20000800).

    repeat (RESET_CYCLES) @(posedge clk);
    @(negedge clk);
    rst_n = 1'b1;
    @(posedge clk);

    $display("[%0t] [tb] Preloading DUT SRAM", $time);
    $readmemh("aadhaar_firmware.hex", dut.u_sram_ctrl.u_sram.mem, 0);

    $display("[%0t] [tb] CPU running. SRAM[0]=0x%08x SRAM[1]=0x%08x SRAM[2]=0x%08x",
             $time,
             dut.u_sram_ctrl.u_sram.mem[0],
             dut.u_sram_ctrl.u_sram.mem[1],
             dut.u_sram_ctrl.u_sram.mem[2]);
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

        // ---- Early pipeline diagnostics (first 30 cycles) ----------------
        if (cycle_cnt <= 30)
            $display("[%0t] cyc=%0d imem_st=%0d stall_if=%0b trap_req=%0b ifid_valid=%0b idex_valid=%0b imem_rdata=0x%08x",
                     $time, cycle_cnt,
                     dut.u_cpu.imem_state,
                     dut.u_cpu.stall_if,
                     dut.u_cpu.trap_req,
                     dut.u_cpu.ifid_valid,
                     dut.u_cpu.idex_valid,
                     dut.u_cpu.imem_rdata);

        // ---- Dense per-cycle dump cycles 1-60 (fill loop debug) ----------
        if (cycle_cnt >= 1 && cycle_cnt <= 60)
            $display("[%0t] cyc=%0d exmem_v=%0b exmem_rd=%0d exmem_ar=0x%08x exmem_rw=%0b memwb_v=%0b memwb_rd=%0d memwb_ar=0x%08x memwb_rw=%0b x8=0x%08x x9=0x%08x x3=0x%08x",
                     $time, cycle_cnt,
                     dut.u_cpu.exmem_valid, dut.u_cpu.exmem_rd, dut.u_cpu.exmem_alu_result, dut.u_cpu.exmem_reg_write,
                     dut.u_cpu.memwb_valid, dut.u_cpu.memwb_rd, dut.u_cpu.memwb_alu_result, dut.u_cpu.memwb_reg_write,
                     dut.u_cpu.regfile[8], dut.u_cpu.regfile[9], dut.u_cpu.regfile[3]);

        // ---- AXI write handshake diagnostics (cycles 30-60) ----
        if (cycle_cnt >= 30 && cycle_cnt <= 60)
            $display("[%0t] [AXI_WR] cyc=%0d wr_st=%0d awv=%0b awr=%0b wv=%0b wr=%0b bv=%0b br=%0b awaddr=0x%08x wdata=0x%08x pending_addr=0x%08x dmop=%0b fwd_rs1=0x%08x idex_imm=0x%08x idex_mw=%0b",
                     $time, cycle_cnt,
                     dut.u_cpu.dmem_wr_state,
                     dut.u_cpu.dmem_awvalid, dut.u_cpu.dmem_awready,
                     dut.u_cpu.dmem_wvalid,  dut.u_cpu.dmem_wready,
                     dut.u_cpu.dmem_bvalid,  dut.u_cpu.dmem_bready,
                     dut.u_cpu.dmem_awaddr,
                     dut.u_cpu.dmem_wdata,
                     dut.u_cpu.dmem_pending_addr,
                     dut.u_cpu.dmem_op_pending,
                     dut.u_cpu.fwd_rs1,
                     dut.u_cpu.idex_imm,
                     dut.u_cpu.idex_mem_write);

        // ---- Aadhaar validation register writes: watch CSRs 0x80-0x8C ----
        if (dut.u_cpu.dmem_awaddr >= 32'h3000_2080 &&
            dut.u_cpu.dmem_awaddr <= 32'h3000_208C &&
            dut.u_cpu.dmem_awvalid)
            $display("[%0t] [ADH_WR] cyc=%0d awaddr=0x%08x wdata=0x%08x",
                     $time, cycle_cnt,
                     dut.u_cpu.dmem_awaddr,
                     dut.u_cpu.dmem_wdata);

        // ---- PDF CTRL write (PDF+0x000): watch for START bit ---------------
        if (dut.u_pdf.s_awvalid && !dut.u_pdf.s_awready)
            $display("[%0t] [PDF_AW] cyc=%0d s_awaddr=0x%03x pdf_state=%0d key[255:224]=0x%08x nonce[127:96]=0x%08x",
                     $time, cycle_cnt,
                     dut.u_pdf.s_awaddr,
                     dut.u_pdf.state,
                     dut.u_pdf.key[255:224],
                     dut.u_pdf.nonce[127:96]);

        if (dut.u_pdf.s_wvalid && dut.u_pdf.aw_addr_valid_r && !dut.u_pdf.s_wready)
            $display("[%0t] [PDF_W]  cyc=%0d aw_addr=0x%03x s_wdata=0x%08x pdf_state=%0d key!=0=%0b nonce!=0=%0b",
                     $time, cycle_cnt,
                     dut.u_pdf.aw_addr_lat,
                     dut.u_pdf.s_wdata,
                     dut.u_pdf.state,
                     (dut.u_pdf.key != 256'h0),
                     (dut.u_pdf.nonce != 128'h0));

        // ---- PDF engine start_pulse -------------------------------------------
        if (dut.u_pdf.start_pulse)
            $display("[%0t] [PDF_START] cyc=%0d start_pulse=1 key[0]=0x%08x nonce[0]=0x%08x src=0x%08x dst=0x%08x len=%0d",
                     $time, cycle_cnt,
                     dut.u_pdf.key[31:0],
                     dut.u_pdf.nonce[31:0],
                     dut.u_pdf.src_addr,
                     dut.u_pdf.dst_addr,
                     dut.u_pdf.pdf_len);

        // ---- PDF engine state transitions ------------------------------------
        if (dut.u_pdf.state != 0 || dut.u_pdf.reg_busy)
            if (cycle_cnt % 100 == 0 || dut.u_pdf.reg_done)
                $display("[%0t] [PDF_ST]  cyc=%0d state=%0d busy=%0b done=%0b auth_ok=%0b auth_fail=%0b error=%0b bytes_rem=%0d",
                         $time, cycle_cnt,
                         dut.u_pdf.state,
                         dut.u_pdf.reg_busy,
                         dut.u_pdf.reg_done,
                         dut.u_pdf.reg_auth_ok,
                         dut.u_pdf.reg_auth_fail,
                         dut.u_pdf.reg_error,
                         dut.u_pdf.bytes_remaining);

        // ---- Aadhaar status register read: show validation result ----------
        if (dut.u_pdf.s_arvalid && !dut.u_pdf.s_arready &&
            dut.u_pdf.s_araddr == 12'h090)
            $display("[%0t] [ADH_STATUS] cyc=%0d verhoeff_ok=%0b first_digit_ok=%0b id_ok=%0b all_valid=%0b",
                     $time, cycle_cnt,
                     dut.u_pdf.adh_verhoeff_ok,
                     dut.u_pdf.adh_first_digit_ok,
                     dut.u_pdf.adh_id_ok,
                     dut.u_pdf.adh_id_ok & dut.u_pdf.adh_all_valid);

        // ---- PDF status register reads (0x3000_2008) -----------------------
        if (dut.u_cpu.dmem_araddr === 32'h3000_2008 &&
            (dut.u_cpu.dmem_rd_state !== 0 || dut.u_cpu.dmem_op_pending))
            $display("[%0t] [PDF_STATUS] cyc=%0d rd_st=%0d arready=%0b rvalid=%0b rdata=0x%08x pdf_st=%0d done=%0b busy=%0b",
                     $time, cycle_cnt,
                     dut.u_cpu.dmem_rd_state,
                     dut.u_cpu.dmem_arready,
                     dut.u_cpu.dmem_rvalid,
                     dut.u_cpu.dmem_rdata,
                     dut.u_pdf.state,
                     dut.u_pdf.reg_done,
                     dut.u_pdf.reg_busy);

        // ---- PDF engine AR fires (all registers) ---------------------------
        if (dut.u_pdf.s_arvalid && !dut.u_pdf.s_arready)
            $display("[%0t] [PDF_AR] cyc=%0d s_araddr=0x%03x reg_done=%0b reg_busy=%0b pdf_state=%0d -> s_rdata=0x%08x",
                     $time, cycle_cnt,
                     dut.u_pdf.s_araddr,
                     dut.u_pdf.reg_done,
                     dut.u_pdf.reg_busy,
                     dut.u_pdf.state,
                     dut.u_pdf.s_rdata);

        // ---- AXI read path debug for cycles 110-135 ------------------------
        if (cycle_cnt >= 110 && cycle_cnt <= 135)
            $display("[%0t] [AXI_RD] cyc=%0d rd_st=%0d arv=%0b arr=%0b rv=%0b rr=%0b araddr=0x%08x rdata=0x%08x | pdf_sarv=%0b sarr=%0b srv=%0b srr=%0b srdata=0x%08x",
                     $time, cycle_cnt,
                     dut.u_cpu.dmem_rd_state,
                     dut.u_cpu.dmem_arvalid,
                     dut.u_cpu.dmem_arready,
                     dut.u_cpu.dmem_rvalid,
                     dut.u_cpu.dmem_rready,
                     dut.u_cpu.dmem_araddr,
                     dut.u_cpu.dmem_rdata,
                     dut.u_pdf.s_arvalid,
                     dut.u_pdf.s_arready,
                     dut.u_pdf.s_rvalid,
                     dut.u_pdf.s_rready,
                     dut.u_pdf.s_rdata);
        // ---- PDF engine read DATA returned to CPU --------------------------
        if (dut.u_pdf.s_rvalid && dut.u_pdf.s_rready)
            $display("[%0t] [PDF_RD] cyc=%0d s_rdata=0x%08x adh_hdr=0x%08x id_ok=%0b",
                     $time, cycle_cnt,
                     dut.u_pdf.s_rdata,
                     dut.u_pdf.adh_hdr,
                     dut.u_pdf.adh_id_ok);

        // ---- Trap detector -------------------------------------------------
        if (dut.u_cpu.trap_req && cycle_cnt > 100)
            $display("[%0t] [TRAP] cyc=%0d pc=0x%08x ifid_pc=0x%08x idex_pc=0x%08x exmem_pc=0x%08x trap_cause=0x%08x",
                     $time, cycle_cnt,
                     dut.u_cpu.pc,
                     dut.u_cpu.ifid_pc,
                     dut.u_cpu.idex_pc,
                     dut.u_cpu.exmem_pc,
                     dut.u_cpu.trap_cause);

        // ---- Dense pipeline dump: cycles 635-850 (enc_poll window) -----------
        if (cycle_cnt >= 635 && cycle_cnt <= 850)
            $display("[%0t] [PL] cyc=%0d pc=0x%08x stif=%0b stex=%0b fex=%0b idv=%0b idmr=%0b dmop=%0b dmrd_st=%0d dmav=%0b dmardy=%0b dmrv=%0b dmaddr=0x%08x pdf_done=%0b pdf_busy=%0b x6=0x%08x",
                     $time, cycle_cnt,
                     dut.u_cpu.pc,
                     dut.u_cpu.stall_if,
                     dut.u_cpu.stall_ex,
                     dut.u_cpu.flush_ex,
                     dut.u_cpu.idex_valid,
                     dut.u_cpu.idex_mem_read,
                     dut.u_cpu.dmem_op_pending,
                     dut.u_cpu.dmem_rd_state,
                     dut.u_cpu.dmem_arvalid,
                     dut.u_cpu.dmem_arready,
                     dut.u_cpu.dmem_rvalid,
                     dut.u_cpu.dmem_araddr,
                     dut.u_pdf.reg_done,
                     dut.u_pdf.reg_busy,
                     dut.u_cpu.regfile[6]);

        // ---- 1K heartbeat in crypto-heavy window ---------------------------
        if ((cycle_cnt % 1_000) == 0 && cycle_cnt >= 640 && cycle_cnt <= 200_000)
            $display("[%0t] [HB1K] cyc=%0d pc=0x%08x pdf_st=%0d done=%0b busy=%0b auth=%0b x6=0x%08x dmop=%0b dmrd=%0d",
                     $time, cycle_cnt,
                     dut.u_cpu.pc,
                     dut.u_pdf.state,
                     dut.u_pdf.reg_done,
                     dut.u_pdf.reg_busy,
                     dut.u_pdf.reg_auth_ok,
                     dut.u_cpu.regfile[6],
                     dut.u_cpu.dmem_op_pending,
                     dut.u_cpu.dmem_rd_state);

        // ---- 100K progress heartbeat ----------------------------------------
        if ((cycle_cnt % 100_000) == 0)
            $display("[%0t] [tb] cyc=%0d gpio=0x%08x pdf_st=%0d busy=%0b done=%0b auth_ok=%0b",
                     $time, cycle_cnt, gpio_out,
                     dut.u_pdf.state,
                     dut.u_pdf.reg_busy,
                     dut.u_pdf.reg_done,
                     dut.u_pdf.reg_auth_ok);

        // ---- PASS ----------------------------------------------------------
        if (gpio_out === PASS_VALUE) begin
            $display("");
            $display("================================================================");
            $display("  *** AADHAAR SIMULATION PASSED ***");
            $display("  GPIO = 0x%08x after %0d cycles", gpio_out, cycle_cnt);
            $display("  Aadhaar number validated: 2000 5555 5554");
            $display("  Verhoeff checksum : PASS");
            $display("  Leading digit     : PASS  (first digit = 2)");
            $display("  Document identity : PASS  (<?xml header matched)");
            $display("  Encrypt + Decrypt : PASS  (round-trip match)");
            $display("================================================================");
            $display("");
            $finish(0);
        end

        // ---- FAIL ----------------------------------------------------------
        if (gpio_out === FAIL_VALUE) begin
            $display("");
            $display("================================================================");
            $display("  *** AADHAAR SIMULATION FAILED ***");
            $display("  GPIO = 0x%08x after %0d cycles", gpio_out, cycle_cnt);
            $display("  Validation / encrypt / decrypt step failed.");
            $display("  PDF engine: state=%0d busy=%0b done=%0b auth_ok=%0b auth_fail=%0b error=%0b",
                     dut.u_pdf.state,
                     dut.u_pdf.reg_busy,
                     dut.u_pdf.reg_done,
                     dut.u_pdf.reg_auth_ok,
                     dut.u_pdf.reg_auth_fail,
                     dut.u_pdf.reg_error);
            $display("  Aadhaar: verhoeff=%0b first_digit=%0b id_ok=%0b",
                     dut.u_pdf.adh_verhoeff_ok,
                     dut.u_pdf.adh_first_digit_ok,
                     dut.u_pdf.adh_id_ok);
            $display("================================================================");
            $display("");
            $finish(1);
        end

        // ---- Watchdog ------------------------------------------------------
        if (cycle_cnt >= WATCHDOG_CYCLES) begin
            $display("");
            $display("================================================================");
            $display("  *** WATCHDOG TIMEOUT after %0d cycles ***", WATCHDOG_CYCLES);
            $display("  gpio_out = 0x%08x", gpio_out);
            $display("  PDF: state=%0d busy=%0b done=%0b auth_ok=%0b auth_fail=%0b error=%0b",
                     dut.u_pdf.state, dut.u_pdf.reg_busy, dut.u_pdf.reg_done,
                     dut.u_pdf.reg_auth_ok, dut.u_pdf.reg_auth_fail, dut.u_pdf.reg_error);
            $display("  CPU pc=0x%08x imem=0x%08x dmem_ar=0x%08x dmem_aw=0x%08x",
                     dut.u_cpu.pc,
                     dut.u_cpu.imem_araddr,
                     dut.u_cpu.dmem_araddr,
                     dut.u_cpu.dmem_awaddr);
            $display("  Aadhaar: verhoeff=%0b first_digit=%0b id_ok=%0b",
                     dut.u_pdf.adh_verhoeff_ok,
                     dut.u_pdf.adh_first_digit_ok,
                     dut.u_pdf.adh_id_ok);
            $display("================================================================");
            $display("");
            $finish(1);
        end

    end // forever
end // initial main_monitor

endmodule
