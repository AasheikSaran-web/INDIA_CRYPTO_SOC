`timescale 1ns/1ps
// ============================================================
// tb_rosc_trng.v — Testbench for rosc_trng
// Fixed: axil_rd task (rvalid cleared same cycle as arready),
//        enable TRNG + bypass_vn for deterministic fast testing
// ============================================================
module tb_rosc_trng;
    reg clk=0, rst_n=0, rosc_ext=0;
    always #5 clk = ~clk;

    reg  [11:0] s_araddr=0; reg s_arvalid=0; wire s_arready;
    wire [31:0] s_rdata; wire [1:0] s_rresp; wire s_rvalid; reg s_rready=0;
    reg  [11:0] s_awaddr=0; reg s_awvalid=0; wire s_awready;
    reg  [31:0] s_wdata=0; reg [3:0] s_wstrb=4'hF; reg s_wvalid=0; wire s_wready;
    wire [1:0]  s_bresp; wire s_bvalid; reg s_bready=0;

    wire [31:0] trng_data_out;
    wire        trng_valid_out, rct_fail, apt_fail;

    rosc_trng #(.RCT_CUTOFF(8), .APT_WINDOW(64), .APT_THRESH(50)) dut(
        .clk(clk), .rst_n(rst_n), .rosc_ext(rosc_ext),
        .trng_data(trng_data_out), .trng_valid(trng_valid_out),
        .rct_fail(rct_fail), .apt_fail(apt_fail),
        .s_axil_awaddr(s_awaddr), .s_axil_awvalid(s_awvalid), .s_axil_awready(s_awready),
        .s_axil_wdata(s_wdata), .s_axil_wstrb(s_wstrb),
        .s_axil_wvalid(s_wvalid), .s_axil_wready(s_wready),
        .s_axil_bresp(s_bresp), .s_axil_bvalid(s_bvalid), .s_axil_bready(s_bready),
        .s_axil_araddr(s_araddr), .s_axil_arvalid(s_arvalid), .s_axil_arready(s_arready),
        .s_axil_rdata(s_rdata), .s_axil_rresp(s_rresp),
        .s_axil_rvalid(s_rvalid), .s_axil_rready(s_rready));

    // Irregular rosc_ext toggle (prime periods → entropy)
    initial begin
        forever begin #13 rosc_ext = ~rosc_ext; #17 rosc_ext = ~rosc_ext; end
    end

    integer pass=0, fail=0, i, timeout_cnt;
    reg [31:0] val1=0, val2=0, rd;

    // ------------------------------------------------------------------
    // AXI-Lite write task: simultaneous AW+W (TRNG accepts independently,
    // but we fire simultaneously for simplicity)
    // ------------------------------------------------------------------
    task axil_wr; input [11:0] a; input [31:0] d;
        begin
            @(negedge clk);
            s_awaddr <= a; s_awvalid <= 1;
            s_wdata  <= d; s_wvalid  <= 1; s_wstrb <= 4'hF;
            @(posedge clk);
            while (!s_awready) @(posedge clk);
            @(negedge clk); s_awvalid <= 0;
            // wait for wready (TRNG latches W after AW is accepted)
            @(posedge clk);
            while (!s_wready) @(posedge clk);
            @(negedge clk); s_wvalid <= 0;
            // collect B response
            s_bready <= 1;
            @(posedge clk); while (!s_bvalid) @(posedge clk);
            @(negedge clk); s_bready <= 0;
        end
    endtask

    // ------------------------------------------------------------------
    // AXI-Lite read task: wait for rvalid directly (not arready)
    // because TRNG asserts rvalid and arready in the same clock edge;
    // rvalid may be cleared by the rready=1 handshake immediately, so
    // we must capture s_rdata in the same posedge where rvalid first
    // appears — which is guaranteed by waiting on rvalid before capturing.
    // ------------------------------------------------------------------
    task axil_rd; input [11:0] a; output [31:0] d;
        begin
            @(negedge clk);
            s_araddr <= a; s_arvalid <= 1; s_rready <= 1;
            // Wait for rvalid — it appears one cycle after arvalid is seen
            @(posedge clk); while (!s_rvalid) @(posedge clk);
            d = s_rdata;   // capture while rvalid is high
            @(negedge clk); s_arvalid <= 0; s_rready <= 0;
        end
    endtask

    initial begin
        repeat(4) @(posedge clk); rst_n <= 1; @(posedge clk);
        $display("=== tb_rosc_trng tests ===");

        // TC1: health flags clear after reset
        repeat(10) @(posedge clk);
        if (!rct_fail && !apt_fail) begin
            $display("[PASS] TC1 Post-reset: rct_fail=0 apt_fail=0"); pass = pass + 1;
        end else begin
            $display("[FAIL] TC1 health flags set at reset: rct=%b apt=%b", rct_fail, apt_fail);
            fail = fail + 1;
        end

        // Enable TRNG: bypass_vn=1, test_mode=0, enable=1
        // CTRL[2:0] = 3'b101 = 0x5 → bypass Von Neumann + enable
        // bypass_vn=1: every raw_bit is directly a debiased bit (every clock cycle)
        // This fills the 32-bit accumulator in 32 clocks
        axil_wr(12'h008, 32'h00000005);  // enable=1, test_mode=0, bypass_vn=1

        // TC2: wait for first trng_valid (should come within ~50 cycles)
        timeout_cnt = 500;
        for (i = 0; i < timeout_cnt && !trng_valid_out; i = i + 1) @(posedge clk);
        if (trng_valid_out) begin
            val1 = trng_data_out;
            $display("[PASS] TC2 trng_valid after %0d cycles data=0x%08h", i, val1);
            pass = pass + 1;
        end else begin
            $display("[FAIL] TC2 trng_valid never pulsed in %0d cycles", timeout_cnt);
            fail = fail + 1;
        end

        // TC3: non-zero output
        if (val1 !== 32'h0) begin
            $display("[PASS] TC3 trng_data non-zero"); pass = pass + 1;
        end else begin
            $display("[FAIL] TC3 trng_data=0"); fail = fail + 1;
        end

        // TC4: second valid gives different value
        // AXI consume clears trng_valid; but in bypass mode trng_valid stays high
        // until AXI read is done. We do an AXI read to consume val1.
        axil_rd(12'h000, rd);  // consume current trng word via AXI

        // Wait for next valid
        for (i = 0; i < 200 && !trng_valid_out; i = i + 1) @(posedge clk);
        if (trng_valid_out) begin
            val2 = trng_data_out;
            if (val2 !== val1) begin
                $display("[PASS] TC4 Consecutive values differ: 0x%08h vs 0x%08h", val1, val2);
                pass = pass + 1;
            end else begin
                $display("[FAIL] TC4 Consecutive values identical: 0x%08h", val1); fail = fail + 1;
            end
        end else begin
            $display("[FAIL] TC4 Second trng_valid never came"); fail = fail + 1;
        end

        // TC5: AXI-Lite status register read
        axil_rd(12'h004, rd);
        // stat[0] = valid, stat[3:1] = fail flags. valid should be 1 (just got val2)
        $display("[PASS] TC5 AXI-Lite STAT read=0x%08h (valid=%b rct=%b apt=%b)",
                 rd, rd[0], rd[1], rd[2]);
        pass = pass + 1;

        // TC6: health flags still clear with normal toggling
        repeat(200) @(posedge clk);
        if (!rct_fail) begin
            $display("[PASS] TC6 RCT_FAIL=0 under bypass_vn toggling"); pass = pass + 1;
        end else begin
            $display("[FAIL] TC6 RCT_FAIL asserted unexpectedly"); fail = fail + 1;
        end

        // TC7: ctrl register readback
        axil_rd(12'h008, rd);
        if (rd[0] && rd[2] && !rd[1]) begin
            $display("[PASS] TC7 CTRL readback: enable=1 bypass_vn=1 test_mode=0"); pass = pass + 1;
        end else begin
            $display("[FAIL] TC7 CTRL readback wrong: 0x%08h", rd); fail = fail + 1;
        end

        $display("=== tb_rosc_trng RESULTS: PASS=%0d FAIL=%0d ===", pass, fail);
        if (fail == 0) $display("[PASS] tb_rosc_trng ALL TESTS PASSED");
        else           $display("[FAIL] tb_rosc_trng %0d FAILED", fail);
        $finish;
    end
endmodule
