`timescale 1ns/1ps

module tb_axi_firewall;
    reg clk=0, rst_n=0;
    always #5 clk = ~clk;

    reg  [1:0]  master_id=0;
    reg  [2:0]  slave_id=0;
    reg  [31:0] u_awaddr=0; reg u_awvalid=0; wire u_awready;
    reg  [31:0] u_wdata=0;  reg [3:0] u_wstrb=0; reg u_wvalid=0; wire u_wready;
    wire [1:0]  u_bresp;  wire u_bvalid; reg u_bready=0;
    reg  [31:0] u_araddr=0; reg u_arvalid=0; wire u_arready;
    wire [31:0] u_rdata;  wire [1:0] u_rresp; wire u_rvalid; reg u_rready=0;

    wire [31:0] d_awaddr; wire d_awvalid; reg d_awready=0;
    wire [31:0] d_wdata;  wire [3:0] d_wstrb; wire d_wvalid; reg d_wready=0;
    reg  [1:0]  d_bresp=0; reg d_bvalid=0; wire d_bready;
    wire [31:0] d_araddr; wire d_arvalid; reg d_arready=0;
    reg  [31:0] d_rdata=32'hABCD_EF00; reg [1:0] d_rresp=0; reg d_rvalid=0;
    wire        d_rready;
    wire        deny_irq;

    wire [31:0] f_awaddr=0, f_wdata=0, f_araddr=0;
    wire [3:0]  f_wstrb=0;
    wire        f_awvalid=0, f_wvalid=0, f_bready=0, f_arvalid=0, f_rready=0;

    axi_firewall #(
        .DEFAULT_PERM(32'h0000_0001),
        .LOCK_KEY    (32'hDEADBEEF),
        .LOG_DEPTH   (4)
    ) dut (
        .clk(clk), .rst_n(rst_n),
        .master_id(master_id), .slave_id(slave_id),
        .u_awaddr(u_awaddr), .u_awvalid(u_awvalid), .u_awready(u_awready),
        .u_wdata(u_wdata), .u_wstrb(u_wstrb), .u_wvalid(u_wvalid), .u_wready(u_wready),
        .u_bresp(u_bresp), .u_bvalid(u_bvalid), .u_bready(u_bready),
        .u_araddr(u_araddr), .u_arvalid(u_arvalid), .u_arready(u_arready),
        .u_rdata(u_rdata), .u_rresp(u_rresp), .u_rvalid(u_rvalid), .u_rready(u_rready),
        .d_awaddr(d_awaddr), .d_awvalid(d_awvalid), .d_awready(d_awready),
        .d_wdata(d_wdata), .d_wstrb(d_wstrb), .d_wvalid(d_wvalid), .d_wready(d_wready),
        .d_bresp(d_bresp), .d_bvalid(d_bvalid), .d_bready(d_bready),
        .d_araddr(d_araddr), .d_arvalid(d_arvalid), .d_arready(d_arready),
        .d_rdata(d_rdata), .d_rresp(d_rresp), .d_rvalid(d_rvalid), .d_rready(d_rready),
        .deny_irq(deny_irq),

        .f_awaddr(f_awaddr), .f_awvalid(f_awvalid), .f_awready(),
        .f_wdata(f_wdata), .f_wstrb(f_wstrb), .f_wvalid(f_wvalid), .f_wready(),
        .f_bresp(), .f_bvalid(), .f_bready(f_bready),
        .f_araddr(f_araddr), .f_arvalid(f_arvalid), .f_arready(),
        .f_rdata(), .f_rresp(), .f_rvalid(), .f_rready(f_rready)
    );

    initial begin
        forever begin
            @(posedge clk);

            if (d_awvalid && !d_awready) begin
                @(posedge clk); d_awready <= 1; @(posedge clk); d_awready <= 0;
            end

            if (d_wvalid && !d_wready) begin
                d_wready <= 1; @(posedge clk); d_wready <= 0;
                d_bvalid <= 1; d_bresp <= 0;
                @(posedge clk); while (!d_bready) @(posedge clk);
                d_bvalid <= 0;
            end

            if (d_arvalid && !d_arready) begin
                d_arready <= 1; @(posedge clk); d_arready <= 0;
                d_rdata <= 32'hABCD_EF00; d_rvalid <= 1; d_rresp <= 0;
                @(posedge clk); while (!d_rready) @(posedge clk);
                d_rvalid <= 0;
            end
        end
    end

    integer pass=0, fail=0;
    reg [1:0] bresp_r, rresp_r;
    reg [31:0] rdata_r;

    task do_write;
        input [1:0] mid; input [31:0] addr; input [31:0] data;
        output [1:0] bresp_out;
        begin
            master_id <= mid;
            @(negedge clk);
            u_awaddr <= addr; u_awvalid <= 1;
            u_wdata  <= data; u_wstrb <= 4'hF; u_wvalid <= 1;

            @(posedge clk); while (!(u_awready && u_wready)) @(posedge clk);
            @(negedge clk); u_awvalid <= 0; u_wvalid <= 0;

            @(posedge clk); while (!u_bvalid) @(posedge clk);
            bresp_out = u_bresp;

            @(negedge clk); u_bready <= 1;
            @(posedge clk);
            @(negedge clk); u_bready <= 0;
        end
    endtask

    task do_read;
        input [1:0] mid; input [31:0] addr;
        output [31:0] rdata_o; output [1:0] rresp_o;
        begin
            master_id <= mid;
            @(negedge clk); u_araddr <= addr; u_arvalid <= 1;

            @(posedge clk); while (!u_arready) @(posedge clk);
            @(negedge clk); u_arvalid <= 0;

            @(posedge clk); while (!u_rvalid) @(posedge clk);
            rdata_o = u_rdata; rresp_o = u_rresp;

            @(negedge clk); u_rready <= 1;
            @(posedge clk);
            @(negedge clk); u_rready <= 0;
        end
    endtask

    initial begin
        repeat(4) @(posedge clk); rst_n <= 1; @(posedge clk);
        $display("=== tb_axi_firewall tests ===");

        do_write(2'd0, 32'h1000, 32'hAABBCCDD, bresp_r);
        if (bresp_r === 2'b00) begin
            $display("[PASS] TC1 Allowed master write: BRESP=OKAY"); pass = pass + 1;
        end else begin
            $display("[FAIL] TC1 Allowed master write: BRESP=%b", bresp_r); fail = fail + 1;
        end

        do_write(2'd1, 32'h1000, 32'hDEADBEEF, bresp_r);
        if (bresp_r === 2'b10) begin
            $display("[PASS] TC2 Denied master write: BRESP=SLVERR"); pass = pass + 1;
        end else begin
            $display("[FAIL] TC2 Denied master write: BRESP=%b (expected 10)", bresp_r);
            fail = fail + 1;
        end

        do_write(2'd0, 32'h2000, 32'hCAFEBABE, bresp_r);
        if (bresp_r === 2'b00) begin
            $display("[PASS] TC3 Master-0 second write still passes: BRESP=OKAY");
            pass = pass + 1;
        end else begin
            $display("[FAIL] TC3 Master-0 second write: BRESP=%b", bresp_r); fail = fail + 1;
        end

        do_read(2'd1, 32'h2000, rdata_r, rresp_r);
        if (rresp_r === 2'b10) begin
            $display("[PASS] TC4 Denied master read: RRESP=SLVERR (perm_table enforced for reads)");
            pass = pass + 1;
        end else begin
            $display("[FAIL] TC4 Denied master read: RRESP=%b (expected SLVERR)", rresp_r);
            fail = fail + 1;
        end

        do_read(2'd0, 32'h3000, rdata_r, rresp_r);
        if (rresp_r === 2'b00) begin
            $display("[PASS] TC5 Master-0 read: RRESP=OKAY, data=0x%08h", rdata_r);
            pass = pass + 1;
        end else begin
            $display("[FAIL] TC5 Master-0 read: RRESP=%b", rresp_r); fail = fail + 1;
        end

        $display("=== tb_axi_firewall RESULTS: PASS=%0d FAIL=%0d ===", pass, fail);
        if (fail == 0) $display("[PASS] tb_axi_firewall ALL TESTS PASSED");
        else           $display("[FAIL] tb_axi_firewall %0d FAILED", fail);
        $finish;
    end
endmodule
