`timescale 1ns/1ps

// tb_plic: hardware module definition
module tb_plic;
    logic clk = 0;
    // Combinational logic output computation
    always #5 clk = ~clk;
    logic        rst_n;
    logic [7:0]  irq_src;
    logic        irq_out;
    logic [11:0] s_axil_awaddr;
    logic        s_axil_awvalid;
    logic        s_axil_awready;
    logic [31:0] s_axil_wdata;
    logic [3:0]  s_axil_wstrb;
    logic        s_axil_wvalid;
    logic        s_axil_wready;
    logic [1:0]  s_axil_bresp;
    logic        s_axil_bvalid;
    logic        s_axil_bready;
    logic [11:0] s_axil_araddr;
    logic        s_axil_arvalid;
    logic        s_axil_arready;
    logic [31:0] s_axil_rdata;
    logic [1:0]  s_axil_rresp;
    logic        s_axil_rvalid;
    logic        s_axil_rready;
    plic #(.N_SRC(8)) dut (
        .clk           (clk),
        .rst_n         (rst_n),
        .irq_src       (irq_src),
        .irq_out       (irq_out),
        .s_axil_awaddr (s_axil_awaddr),
        .s_axil_awvalid(s_axil_awvalid),
        .s_axil_awready(s_axil_awready),
        .s_axil_wdata  (s_axil_wdata),
        .s_axil_wstrb  (s_axil_wstrb),
        .s_axil_wvalid (s_axil_wvalid),
        .s_axil_wready (s_axil_wready),
        .s_axil_bresp  (s_axil_bresp),
        .s_axil_bvalid (s_axil_bvalid),
        .s_axil_bready (s_axil_bready),
        .s_axil_araddr (s_axil_araddr),
        .s_axil_arvalid(s_axil_arvalid),
        .s_axil_arready(s_axil_arready),
        .s_axil_rdata  (s_axil_rdata),
        .s_axil_rresp  (s_axil_rresp),
        .s_axil_rvalid (s_axil_rvalid),
        .s_axil_rready (s_axil_rready)
    );
    int pass_count = 0;
    int fail_count = 0;

    // automatic: reusable simulation task
    task automatic check(input string name, input logic got, input logic exp);
        if (got === exp) begin
            $display("[PASS] %s  (got=%0b exp=%0b)", name, got, exp);
            pass_count++;
        end else begin
            $display("[FAIL] %s  (got=%0b exp=%0b)", name, got, exp);
            fail_count++;
        end
    endtask

    // automatic: reusable simulation task
    task automatic check32(input string name, input logic [31:0] got, input logic [31:0] exp);
        if (got === exp) begin
            $display("[PASS] %s  (got=0x%08h exp=0x%08h)", name, got, exp);
            pass_count++;
        end else begin
            $display("[FAIL] %s  (got=0x%08h exp=0x%08h)", name, got, exp);
            fail_count++;
        end
    endtask
    // automatic: reusable simulation task
    task automatic axil_write(input logic [11:0] addr,
                               input logic [31:0] data,
                               output logic [1:0] resp);
        @(negedge clk);
        s_axil_awaddr  = addr;
        s_axil_awvalid = 1'b1;
        s_axil_wdata   = data;
        s_axil_wstrb   = 4'hF;
        s_axil_wvalid  = 1'b1;
        s_axil_bready  = 1'b0;
        @(posedge clk);
        while (!(s_axil_awready && s_axil_wready)) @(posedge clk);
        @(negedge clk);
        s_axil_awvalid = 1'b0;
        s_axil_wvalid  = 1'b0;
        s_axil_bready  = 1'b1;
        @(posedge clk);
        while (!s_axil_bvalid) @(posedge clk);
        resp          = s_axil_bresp;
        @(negedge clk);
        s_axil_bready = 1'b0;
        @(posedge clk);
    endtask
    // automatic: reusable simulation task
    task automatic axil_read(input  logic [11:0] addr,
                              output logic [31:0] data,
                              output logic [1:0]  resp);
        @(negedge clk);
        s_axil_araddr  = addr;
        s_axil_arvalid = 1'b1;
        s_axil_rready  = 1'b0;

        @(posedge clk);
        while (!s_axil_arready) @(posedge clk);
        @(negedge clk);
        s_axil_arvalid = 1'b0;
        s_axil_rready  = 1'b1;

        @(posedge clk);
        while (!s_axil_rvalid) @(posedge clk);
        data           = s_axil_rdata;
        resp           = s_axil_rresp;
        @(negedge clk);
        s_axil_rready  = 1'b0;
        @(posedge clk);
    endtask
    // automatic: reusable simulation task
    task automatic axil_idle();
        s_axil_awaddr  = '0;
        s_axil_awvalid = 1'b0;
        s_axil_wdata   = '0;
        s_axil_wstrb   = 4'hF;
        s_axil_wvalid  = 1'b0;
        s_axil_bready  = 1'b0;
        s_axil_araddr  = '0;
        s_axil_arvalid = 1'b0;
        s_axil_rready  = 1'b0;
    endtask
    // automatic: combinational helper function
    function automatic logic [11:0] pri_addr(input int i);
        return 12'(i << 2);
    endfunction
    // automatic: reusable simulation task
    task automatic do_reset();
        rst_n  = 1'b0;
        irq_src = 8'h00;
        axil_idle();
        repeat(5) @(posedge clk);
        @(negedge clk);
        rst_n = 1'b1;
        @(posedge clk);
    endtask
    logic [31:0] rdata;
    logic [1:0]  resp;

    // Simulation initialisation or stimulus block
    initial begin
        $dumpfile("tb_plic.vcd");
        $dumpvars(0, tb_plic);

        do_reset();
        axil_read(pri_addr(0), rdata, resp);
        check32("TC01 pri[0]=0 after reset", rdata, 32'd0);
        axil_read(12'h200, rdata, resp);
        check32("TC02 ENABLE=0 after reset", rdata, 32'd0);
        axil_read(12'h300, rdata, resp);
        check32("TC03 THRESHOLD=0 after reset", rdata, 32'd0);
        axil_read(12'h100, rdata, resp);
        check32("TC04 PENDING=0 after reset", rdata, 32'd0);
        @(posedge clk);
        check("TC05 irq_out=0 after reset", irq_out, 1'b0);
        axil_write(pri_addr(0), 32'd1, resp);
        axil_read(pri_addr(0), rdata, resp);
        check32("TC06 pri[0] write/readback=1", rdata, 32'd1);
        axil_write(12'h200, 32'h01, resp);
        axil_read(12'h200, rdata, resp);
        check32("TC07 ENABLE bit0 set", rdata, 32'h01);
        irq_src = 8'h01;
        @(posedge clk); @(posedge clk);
        axil_read(12'h100, rdata, resp);
        check32("TC08 PENDING[0]=1 when irq_src[0]=1 & enabled", rdata, 32'h01);
        @(posedge clk);
        check("TC09 irq_out=1", irq_out, 1'b1);
        axil_read(12'h304, rdata, resp);
        check32("TC10 CLAIM_ID=0 for single pending src0", rdata, 32'd0);

        irq_src = 8'h00;
        @(posedge clk);
        axil_write(12'h300, 32'd2, resp);
        axil_read(12'h300, rdata, resp);
        check32("TC11 THRESHOLD write/readback=2", rdata, 32'd2);
        irq_src = 8'h01;
        @(posedge clk); @(posedge clk);
        check("TC12 irq_out=0 (threshold=2 suppresses priority=1)", irq_out, 1'b0);
        axil_read(12'h100, rdata, resp);
        check32("TC13 PENDING[0]=1 even when threshold suppresses", rdata, 32'h01);
        @(posedge clk);
        check("TC14 irq_out=0 (threshold>priority)", irq_out, 1'b0);
        axil_write(pri_addr(0), 32'd3, resp);
        @(posedge clk); @(posedge clk);
        check("TC15 irq_out=1 after raising priority above threshold", irq_out, 1'b1);

        irq_src = 8'h00;
        axil_write(12'h300, 32'd0, resp);
        @(posedge clk);
        axil_write(pri_addr(0), 32'd1, resp);
        axil_write(pri_addr(1), 32'd3, resp);
        axil_write(12'h200, 32'h03, resp);
        irq_src = 8'h03;
        @(posedge clk); @(posedge clk);
        check("TC16 irq_out=1 with two sources enabled (threshold=0)", irq_out, 1'b1);
        axil_read(12'h304, rdata, resp);
        check32("TC17 CLAIM_ID=1 (pri[1]=3 > pri[0]=1)", rdata, 32'd1);
        axil_read(12'h100, rdata, resp);
        check32("TC18 PENDING=0x03 with both sources active", rdata, 32'h03);
        @(posedge clk);
        check("TC19 irq_out=1 with two pending sources", irq_out, 1'b1);
        irq_src = 8'h00;
        @(posedge clk); @(posedge clk);
        check("TC20 irq_out=0 after irq_src cleared", irq_out, 1'b0);
        axil_write(12'h200, 32'h02, resp);
        irq_src = 8'h01;
        @(posedge clk); @(posedge clk);
        check("TC21 irq_out=0 (src0 disabled)", irq_out, 1'b0);
        axil_read(12'h100, rdata, resp);
        check32("TC22 PENDING=0 (src0 disabled, src1 not asserted)", rdata, 32'h00);
        irq_src = 8'h03;
        @(posedge clk); @(posedge clk);
        check("TC23 irq_out=1 (src1 enabled+asserted)", irq_out, 1'b1);
        axil_write(12'h200, 32'h00, resp);
        @(posedge clk); @(posedge clk);
        check("TC24 irq_out=0 after disabling src1", irq_out, 1'b0);
        axil_write(12'h200, 32'h02, resp);
        @(posedge clk); @(posedge clk);
        check("TC25 irq_out=1 after re-enabling src1", irq_out, 1'b1);

        irq_src = 8'h00;
        @(posedge clk);
        axil_write(12'h200, 32'h0F, resp);
        irq_src = 8'hAA;
        @(posedge clk); @(posedge clk);
        axil_read(12'h100, rdata, resp);
        check32("TC26 PENDING = irq_src(0xAA) & enable(0x0F) = 0x0A", rdata, 32'h0A);
        axil_write(12'h200, 32'hFF, resp);
        irq_src = 8'h55;
        @(posedge clk); @(posedge clk);
        axil_read(12'h100, rdata, resp);
        check32("TC27 PENDING=0x55 (enable=0xFF, irq_src=0x55)", rdata, 32'h55);
        axil_write(12'h200, 32'h00, resp);
        irq_src = 8'hFF;
        @(posedge clk); @(posedge clk);
        axil_read(12'h100, rdata, resp);
        check32("TC28 PENDING=0 (enable=0, all sources masked)", rdata, 32'h00);
        axil_write(12'h200, 32'h80, resp);
        irq_src = 8'h80;
        @(posedge clk); @(posedge clk);
        axil_read(12'h100, rdata, resp);
        check32("TC29 PENDING=0x80 (src7 only)", rdata, 32'h80);
        irq_src = 8'h00;
        @(posedge clk); @(posedge clk);
        axil_read(12'h100, rdata, resp);
        check32("TC30 PENDING=0 after irq_src clears", rdata, 32'h00);

        irq_src = 8'h00;
        axil_write(12'h200, 32'h00, resp);
        axil_write(pri_addr(0), 32'd1, resp);
        axil_write(pri_addr(1), 32'd2, resp);
        axil_write(pri_addr(2), 32'd3, resp);
        axil_write(pri_addr(3), 32'd4, resp);
        axil_write(pri_addr(4), 32'd5, resp);
        axil_write(pri_addr(5), 32'd6, resp);
        axil_write(pri_addr(6), 32'd7, resp);
        axil_write(pri_addr(7), 32'd1, resp);
        axil_write(12'h200, 32'hFF, resp);
        axil_write(12'h300, 32'd0, resp);
        irq_src = 8'hFF;
        @(posedge clk); @(posedge clk);
        axil_read(12'h304, rdata, resp);
        check32("TC31 CLAIM_ID=6 (highest pri=7 at src6)", rdata, 32'd6);
        axil_read(12'h100, rdata, resp);
        check32("TC32 PENDING=0xFF all sources active+enabled", rdata, 32'hFF);
        @(posedge clk);
        check("TC33 irq_out=1 all sources", irq_out, 1'b1);
        axil_write(12'h200, 32'hBF, resp);
        irq_src = 8'hFF;
        @(posedge clk); @(posedge clk);
        axil_read(12'h304, rdata, resp);
        check32("TC34 CLAIM_ID=5 after disabling src6", rdata, 32'd5);
        axil_write(12'h200, 32'h08, resp);
        @(posedge clk); @(posedge clk);
        axil_read(12'h304, rdata, resp);
        check32("TC35 CLAIM_ID=3 (only src3 enabled)", rdata, 32'd3);

        irq_src = 8'h00;
        @(posedge clk);
        axil_write(pri_addr(0), 32'd5, resp);
        axil_read(pri_addr(0), rdata, resp);
        check32("TC36 pri[0] = 5 readback", rdata, 32'd5);
        axil_write(pri_addr(2), 32'd7, resp);
        axil_read(pri_addr(2), rdata, resp);
        check32("TC37 pri[2] = 7 readback", rdata, 32'd7);
        axil_write(pri_addr(4), 32'd3, resp);
        axil_read(pri_addr(4), rdata, resp);
        check32("TC38 pri[4] = 3 readback", rdata, 32'd3);
        axil_write(pri_addr(7), 32'd6, resp);
        axil_read(pri_addr(7), rdata, resp);
        check32("TC39 pri[7] = 6 readback", rdata, 32'd6);
        axil_write(pri_addr(3), 32'd2, resp);
        axil_read(pri_addr(3), rdata, resp);
        check32("TC40 pri[3] = 2 readback", rdata, 32'd2);
        axil_write(12'h300, 32'd7, resp);
        axil_read(12'h300, rdata, resp);
        check32("TC41 THRESHOLD=7 readback", rdata, 32'd7);
        axil_write(12'h200, 32'hFF, resp);
        irq_src = 8'hFF;
        @(posedge clk); @(posedge clk);
        check("TC42 irq_out=0 (max_pri=7 not > threshold=7)", irq_out, 1'b0);
        axil_read(12'h100, rdata, resp);
        check32("TC43 PENDING=0xFF even though threshold blocks irq", rdata, 32'hFF);
        axil_write(12'h300, 32'd6, resp);
        @(posedge clk); @(posedge clk);
        check("TC44 irq_out=1 after lowering threshold to 6", irq_out, 1'b1);
        axil_write(12'h300, 32'd7, resp);
        @(posedge clk); @(posedge clk);
        check("TC45 irq_out=0 again with threshold=7", irq_out, 1'b0);

        irq_src = 8'h00;
        axil_write(12'h300, 32'd0, resp);
        @(posedge clk);
        axil_read(12'h400, rdata, resp);
        check("TC46 rresp=SLVERR for addr 0x400", resp[1], 1'b1);
        axil_read(12'h500, rdata, resp);
        check("TC47 rresp=SLVERR for addr 0x500", resp[1], 1'b1);
        axil_read(12'h800, rdata, resp);
        check("TC48 rresp=SLVERR for addr 0x800", resp[1], 1'b1);
        axil_read(12'hFFF, rdata, resp);
        check("TC49 rresp=SLVERR for addr 0xFFF", resp[1], 1'b1);
        axil_read(12'h200, rdata, resp);
        check("TC50 rresp=OKAY for valid addr 0x200", resp, 2'b00);
        $display("----------------------------------------");
        $display("RESULT: %0d/50 passed", pass_count);
        $display("----------------------------------------");

        $finish;
    end
    // Simulation initialisation or stimulus block
    initial begin
        #200000;
        $display("[TIMEOUT] Simulation exceeded 200us — aborting.");
        $finish;
    end

endmodule
