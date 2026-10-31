`timescale 1ns/1ps
`default_nettype none

// Boot ROM unit testbench covering 55 test cases across 11 groups
module tb_boot_rom;

    localparam CLK_HALF = 5;
    reg clk, rst_n;
    initial clk = 0;
    // 100 MHz clock toggle
    always #CLK_HALF clk = ~clk;

    reg  [31:0] s_araddr;
    reg         s_arvalid;
    wire        s_arready;
    wire [31:0] s_rdata;
    wire [1:0]  s_rresp;
    wire        s_rvalid;
    reg         s_rready;

    reg  [31:0] s_awaddr;
    reg         s_awvalid;
    wire        s_awready;
    reg  [31:0] s_wdata;
    reg  [3:0]  s_wstrb;
    reg         s_wvalid;
    wire        s_wready;
    wire [1:0]  s_bresp;
    wire        s_bvalid;
    reg         s_bready;

    boot_rom dut (
        .clk            (clk),
        .rst_n          (rst_n),
        .s_axil_araddr  (s_araddr),
        .s_axil_arvalid (s_arvalid),
        .s_axil_arready (s_arready),
        .s_axil_rdata   (s_rdata),
        .s_axil_rresp   (s_rresp),
        .s_axil_rvalid  (s_rvalid),
        .s_axil_rready  (s_rready),
        .s_axil_awaddr  (s_awaddr),
        .s_axil_awvalid (s_awvalid),
        .s_axil_awready (s_awready),
        .s_axil_wdata   (s_wdata),
        .s_axil_wstrb   (s_wstrb),
        .s_axil_wvalid  (s_wvalid),
        .s_axil_wready  (s_wready),
        .s_axil_bresp   (s_bresp),
        .s_axil_bvalid  (s_bvalid),
        .s_axil_bready  (s_bready)
    );

    integer pass_cnt, fail_cnt;

    `define CHECK(label, got, exp) \
        if ((got) === (exp)) begin \
            $display("  PASS  %s  got=0x%08X", label, got); \
            pass_cnt = pass_cnt + 1; \
        end else begin \
            $display("  FAIL  %s  got=0x%08X  exp=0x%08X", label, got, exp); \
            fail_cnt = fail_cnt + 1; \
        end

    `define CHECK1(label, got, exp) \
        if ((got) === (exp)) begin \
            $display("  PASS  %s  got=%0b", label, got); \
            pass_cnt = pass_cnt + 1; \
        end else begin \
            $display("  FAIL  %s  got=%0b  exp=%0b", label, got, exp); \
            fail_cnt = fail_cnt + 1; \
        end

    // Initialize firmware golden reference array for all 25 instruction words
    reg [31:0] FW [0:24];
    initial begin
        FW[0]  = 32'h400021B7;
        FW[1]  = 32'h20000237;
        FW[2]  = 32'h20010137;
        FW[3]  = 32'hFFC10113;
        FW[4]  = 32'h0001AA23;
        FW[5]  = 32'h00100313;
        FW[6]  = 32'h0061A223;
        FW[7]  = 32'h03000337;
        FW[8]  = 32'h0061A423;
        FW[9]  = 32'h0001A623;
        FW[10] = 32'h00202337;
        FW[11] = 32'h80830313;
        FW[12] = 32'h0061A823;
        FW[13] = 32'h02020293;
        FW[14] = 32'h10100313;
        FW[15] = 32'h0061A023;
        FW[16] = 32'h0001A383;
        FW[17] = 32'h0013F393;
        FW[18] = 32'hFE038CE3;
        FW[19] = 32'h0201A383;
        FW[20] = 32'h00722023;
        FW[21] = 32'h00420213;
        FW[22] = 32'hFE521AE3;
        FW[23] = 32'h200000B7;
        FW[24] = 32'h00008067;
    end

    localparam NOP = 32'h00000013;

    // AXI-Lite normal read: drive arvalid, wait arready, then assert rready
    task automatic axil_read;
        input  [31:0] addr;
        output [31:0] data;
        output [1:0]  resp;
        begin
            @(negedge clk);
            s_araddr  = addr;
            s_arvalid = 1'b1;
            s_rready  = 1'b0;
            @(posedge clk);
            while (!s_arready) @(posedge clk);
            @(negedge clk);
            s_arvalid = 1'b0;
            s_rready  = 1'b1;
            @(posedge clk);
            while (!s_rvalid) @(posedge clk);
            data = s_rdata;
            resp = s_rresp;
            @(negedge clk);
            s_rready = 1'b0;
            @(posedge clk);
        end
    endtask

    // AXI-Lite eager read: rready pre-asserted, capture rdata at arready posedge
    task automatic axil_read_eager;
        input  [31:0] addr;
        output [31:0] data;
        output [1:0]  resp;
        begin
            @(negedge clk);
            s_araddr  = addr;
            s_arvalid = 1'b1;
            s_rready  = 1'b1;
            @(posedge clk);
            while (!s_arready) @(posedge clk);
            data = s_rdata;
            resp = s_rresp;
            @(negedge clk);
            s_arvalid = 1'b0;
            s_rready  = 1'b0;
            @(posedge clk);
        end
    endtask

    // AXI-Lite write: bready NOT pre-asserted to ensure bvalid persists
    task automatic axil_write;
        input  [31:0] aw_addr;
        input  [31:0] w_data;
        input  [3:0]  w_strb;
        output [1:0]  resp;
        begin
            @(negedge clk);
            s_awaddr  = aw_addr;
            s_awvalid = 1'b1;
            s_wdata   = w_data;
            s_wstrb   = w_strb;
            s_wvalid  = 1'b1;
            s_bready  = 1'b0;
            @(posedge clk);
            while (!(s_awready && s_wready)) @(posedge clk);
            @(negedge clk);
            s_awvalid = 1'b0;
            s_wvalid  = 1'b0;
            @(posedge clk);
            while (!s_bvalid) @(posedge clk);
            resp = s_bresp;
            @(negedge clk);
            s_bready = 1'b1;
            @(posedge clk);
            @(negedge clk);
            s_bready = 1'b0;
            @(posedge clk);
        end
    endtask

    // Assert reset and initialize all AXI-Lite inputs to idle
    task do_reset;
        begin
            rst_n     = 1'b0;
            s_arvalid = 1'b0; s_araddr = 32'd0; s_rready = 1'b0;
            s_awvalid = 1'b0; s_awaddr = 32'd0;
            s_wvalid  = 1'b0; s_wdata  = 32'd0; s_wstrb  = 4'hF;
            s_bready  = 1'b0;
            repeat(4) @(posedge clk);
            @(negedge clk);
            rst_n = 1'b1;
            @(posedge clk);
        end
    endtask

    reg [31:0] rd_data;
    reg [1:0]  rd_resp, wr_resp;
    integer    idx;

    // Main test body exercising all 55 test cases
    initial begin
        pass_cnt = 0;
        fail_cnt = 0;
        do_reset;

        $display("\n=== G1: Firmware words 0-9 (normal read) ===");
        for (idx = 0; idx <= 9; idx = idx + 1) begin
            axil_read(idx * 4, rd_data, rd_resp);
            `CHECK($sformatf("TC%02d fw[%0d]", idx+1, idx), rd_data, FW[idx])
            `CHECK1($sformatf("TC%02d fw[%0d] rresp", idx+1, idx), rd_resp, 2'b00)
        end

        $display("\n=== G2: Firmware words 10-19 (eager read) ===");
        for (idx = 10; idx <= 19; idx = idx + 1) begin
            axil_read_eager(idx * 4, rd_data, rd_resp);
            `CHECK($sformatf("TC%02d fw[%0d]", idx+1, idx), rd_data, FW[idx])
            `CHECK1($sformatf("TC%02d fw[%0d] rresp", idx+1, idx), rd_resp, 2'b00)
        end

        $display("\n=== G3: Firmware words 20-24 (normal read) ===");
        for (idx = 20; idx <= 24; idx = idx + 1) begin
            axil_read(idx * 4, rd_data, rd_resp);
            `CHECK($sformatf("TC%02d fw[%0d]", idx+1, idx), rd_data, FW[idx])
            `CHECK1($sformatf("TC%02d fw[%0d] rresp", idx+1, idx), rd_resp, 2'b00)
        end

        $display("\n=== G4: NOP region words 25-29 ===");
        for (idx = 25; idx <= 29; idx = idx + 1) begin
            axil_read(idx * 4, rd_data, rd_resp);
            `CHECK($sformatf("TC%02d nop[%0d]", idx+1, idx), rd_data, NOP)
            `CHECK1($sformatf("TC%02d nop[%0d] rresp", idx+1, idx), rd_resp, 2'b00)
        end

        $display("\n=== G5: Boundary addresses & byte-lane aliasing ===");
        axil_read(32'h0000_0400, rd_data, rd_resp);
        `CHECK("TC31 nop@0x400", rd_data, NOP)
        `CHECK1("TC31 rresp", rd_resp, 2'b00)
        axil_read(32'h0000_4000, rd_data, rd_resp);
        `CHECK("TC32 nop@0x4000", rd_data, NOP)
        `CHECK1("TC32 rresp", rd_resp, 2'b00)
        axil_read(32'h0000_7FFC, rd_data, rd_resp);
        `CHECK("TC33 nop@0x7FFC", rd_data, NOP)
        `CHECK1("TC33 rresp", rd_resp, 2'b00)
        axil_read(32'h0000_0002, rd_data, rd_resp);
        `CHECK("TC34 FW[0] via addr 0x02", rd_data, FW[0])
        `CHECK1("TC34 rresp", rd_resp, 2'b00)
        axil_read(32'h0000_0005, rd_data, rd_resp);
        `CHECK("TC35 FW[1] via addr 0x05", rd_data, FW[1])
        `CHECK1("TC35 rresp", rd_resp, 2'b00)

        $display("\n=== G6: Write channel SLVERR ===");
        axil_write(32'h0000_0000, 32'hDEAD_BEEF, 4'hF, wr_resp);
        `CHECK1("TC36 wr@0x0000 bresp", wr_resp, 2'b10)
        axil_write(32'h0000_0028, 32'hCAFE_BABE, 4'hF, wr_resp);
        `CHECK1("TC37 wr@0x0028 bresp", wr_resp, 2'b10)
        axil_write(32'h0000_7FFC, 32'hFFFF_FFFF, 4'hF, wr_resp);
        `CHECK1("TC38 wr@0x7FFC bresp", wr_resp, 2'b10)
        axil_write(32'h0000_0004, 32'hAAAA_AAAA, 4'h3, wr_resp);
        `CHECK1("TC39 wr partial-strobe bresp", wr_resp, 2'b10)
        axil_write(32'h0000_2000, 32'h1234_5678, 4'hF, wr_resp);
        `CHECK1("TC40 wr@0x2000 bresp", wr_resp, 2'b10)

        $display("\n=== G7: AXI back-pressure ===");

        begin
            @(negedge clk);
            s_araddr  = 32'h0000_0000;
            s_arvalid = 1'b1;
            s_rready  = 1'b0;
            @(posedge clk); while (!s_arready) @(posedge clk);
            @(negedge clk); s_arvalid = 1'b0;
            repeat(3) @(posedge clk);
            `CHECK1("TC41 rvalid held during back-pressure", s_rvalid, 1'b1)
            @(negedge clk); s_rready = 1'b1;
            @(posedge clk);
            `CHECK("TC41 rdata correct after back-pressure", s_rdata, FW[0])
            @(negedge clk); s_rready = 1'b0;
            @(posedge clk);
        end

        begin
            @(negedge clk);
            s_araddr  = 32'h0000_0004;
            s_arvalid = 1'b1;
            s_rready  = 1'b0;
            @(posedge clk); while (!s_arready) @(posedge clk);
            @(negedge clk); s_arvalid = 1'b0; s_rready = 1'b1;
            @(posedge clk); while (!s_rvalid) @(posedge clk);
            @(posedge clk);
            `CHECK1("TC42 rvalid deasserted after rready", s_rvalid, 1'b0)
            @(negedge clk); s_rready = 1'b0; @(posedge clk);
        end

        begin
            axil_write(32'h0000_0000, 32'hAABBCCDD, 4'hF, wr_resp);
            `CHECK1("TC43a first write bresp", wr_resp, 2'b10)
            axil_write(32'h0000_0010, 32'h11223344, 4'hF, wr_resp);
            `CHECK1("TC43b second write bresp", wr_resp, 2'b10)
        end

        begin
            @(negedge clk);
            s_awaddr  = 32'h0000_0008;
            s_awvalid = 1'b1;
            s_wdata   = 32'h0;
            s_wstrb   = 4'hF;
            s_wvalid  = 1'b1;
            s_bready  = 1'b0;
            @(posedge clk); while (!(s_awready && s_wready)) @(posedge clk);
            @(negedge clk); s_awvalid = 1'b0; s_wvalid = 1'b0;
            @(posedge clk); while (!s_bvalid) @(posedge clk);
            repeat(4) @(posedge clk);
            `CHECK1("TC44 bvalid held under back-pressure", s_bvalid, 1'b1)
            `CHECK1("TC44 bresp SLVERR under back-pressure", s_bresp, 2'b10)
            @(negedge clk); s_bready = 1'b1;
            @(posedge clk);
            @(negedge clk); s_bready = 1'b0;
            @(posedge clk);
        end

        axil_read_eager(32'h0000_0000, rd_data, rd_resp);
        `CHECK("TC45a consecutive eager FW[0]", rd_data, FW[0])
        axil_read_eager(32'h0000_0004, rd_data, rd_resp);
        `CHECK("TC45b consecutive eager FW[1]", rd_data, FW[1])

        $display("\n=== G8: Reset behavior ===");

        do_reset;
        `CHECK1("TC46 arready=0 after reset", s_arready, 1'b0)
        `CHECK1("TC46b rvalid=0 after reset",  s_rvalid,  1'b0)
        `CHECK1("TC46c bvalid=0 after reset",  s_bvalid,  1'b0)

        axil_read(32'h0000_0000, rd_data, rd_resp);
        `CHECK("TC47 FW[0] correct after reset", rd_data, FW[0])

        begin
            @(negedge clk);
            s_araddr  = 32'h0000_0064;
            s_arvalid = 1'b1;
            s_rready  = 1'b0;
            @(posedge clk);
            rst_n = 1'b0;
            @(posedge clk);
            s_arvalid = 1'b0;
            @(posedge clk);
            rst_n = 1'b1;
            @(posedge clk);
            `CHECK1("TC48 rvalid=0 after mid-tx reset", s_rvalid, 1'b0)
        end

        axil_read(32'h0000_0060, rd_data, rd_resp);
        `CHECK("TC49 FW[24] jalr after reset", rd_data, FW[24])

        begin
            @(negedge clk);
            s_araddr  = 32'h0000_000C;
            s_arvalid = 1'b1;
            s_rready  = 1'b0;
            @(posedge clk); while (!s_arready) @(posedge clk);
            @(negedge clk); s_arvalid = 1'b0; s_rready = 1'b1;
            @(posedge clk); while (!s_rvalid) @(posedge clk);
            `CHECK("TC50 FW[3] addi via arvalid hold", s_rdata, FW[3])
            @(negedge clk); s_rready = 1'b0; @(posedge clk);
        end

        $display("\n=== G9: Protocol details ===");

        axil_read(32'h0000_0050, rd_data, rd_resp);
        `CHECK1("TC51 rresp=OKAY fw[20]", rd_resp, 2'b00)

        begin
            @(negedge clk);
            s_araddr  = 32'h0000_0054;
            s_arvalid = 1'b1;
            s_rready  = 1'b0;
            @(posedge clk); while (!s_arready) @(posedge clk);
            @(posedge clk);
            `CHECK1("TC52 arready single-cycle pulse", s_arready, 1'b0)
            @(negedge clk); s_arvalid = 1'b0; s_rready = 1'b1;
            @(posedge clk); while (!s_rvalid) @(posedge clk);
            @(negedge clk); s_rready = 1'b0; @(posedge clk);
        end

        $display("\n=== G10: Write-then-read — ROM data unchanged ===");

        axil_write(32'h0000_0000, 32'hDEAD_BEEF, 4'hF, wr_resp);
        `CHECK1("TC53 write bresp=SLVERR", wr_resp, 2'b10)
        axil_read(32'h0000_0000, rd_data, rd_resp);
        `CHECK("TC53 FW[0] unchanged after write", rd_data, FW[0])

        axil_write(32'h0000_0100, 32'hABCD_EF01, 4'hF, wr_resp);
        `CHECK1("TC54 NOP region write bresp=SLVERR", wr_resp, 2'b10)
        axil_read(32'h0000_0100, rd_data, rd_resp);
        `CHECK("TC54 NOP unchanged after write", rd_data, NOP)

        $display("\n=== G11: rvalid deasserts one cycle after rready ===");
        begin
            @(negedge clk);
            s_araddr  = 32'h0000_0058;
            s_arvalid = 1'b1;
            s_rready  = 1'b0;
            @(posedge clk); while (!s_arready) @(posedge clk);
            @(negedge clk); s_arvalid = 1'b0; s_rready = 1'b1;
            @(posedge clk); while (!s_rvalid) @(posedge clk);
            @(posedge clk);
            `CHECK1("TC55 rvalid deasserts one cycle after rready", s_rvalid, 1'b0)
            @(negedge clk); s_rready = 1'b0; @(posedge clk);
        end

        $display("\n============================================================");
        $display("  RESULTS: %0d PASSED  /  %0d FAILED  /  %0d TOTAL",
                 pass_cnt, fail_cnt, pass_cnt + fail_cnt);
        $display("============================================================");
        if (fail_cnt == 0)
            $display("  ALL TESTS PASSED");
        else
            $display("  *** FAILURES DETECTED ***");
        $finish;
    end

    // Simulation timeout watchdog
    initial begin
        #500_000;
        $display("WATCHDOG TIMEOUT");
        $finish;
    end

endmodule
