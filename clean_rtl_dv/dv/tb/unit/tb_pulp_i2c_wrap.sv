`timescale 1ns/1ps
`default_nettype none

// PULP I2C wrapper testbench with 50 test cases using open-drain bus with pullups
module tb_pulp_i2c_wrap;

    reg clk, rst_n;
    // 100 MHz clock toggle
    always #5 clk = ~clk;

    logic [11:0] s_awaddr;
    logic        s_awvalid, s_awready;
    logic [31:0] s_wdata;
    logic  [3:0] s_wstrb;
    logic        s_wvalid,  s_wready;
    logic  [1:0] s_bresp;
    logic        s_bvalid,  s_bready;
    logic [11:0] s_araddr;
    logic        s_arvalid, s_arready;
    logic [31:0] s_rdata;
    logic  [1:0] s_rresp;
    logic        s_rvalid,  s_rready;

    wire i2c_sda, i2c_scl;
    pullup (i2c_sda);
    pullup (i2c_scl);
    logic irq;

    pulp_i2c_wrap dut (
        .clk       (clk),       .rst_n     (rst_n),
        .s_awaddr  (s_awaddr),  .s_awvalid (s_awvalid), .s_awready (s_awready),
        .s_wdata   (s_wdata),   .s_wstrb   (s_wstrb),
        .s_wvalid  (s_wvalid),  .s_wready  (s_wready),
        .s_bresp   (s_bresp),   .s_bvalid  (s_bvalid),  .s_bready  (s_bready),
        .s_araddr  (s_araddr),  .s_arvalid (s_arvalid), .s_arready (s_arready),
        .s_rdata   (s_rdata),   .s_rresp   (s_rresp),
        .s_rvalid  (s_rvalid),  .s_rready  (s_rready),
        .i2c_sda   (i2c_sda),  .i2c_scl   (i2c_scl),   .irq (irq)
    );

    integer pass_cnt, fail_cnt;
    reg [31:0] rdata;

    // Self-checking task comparing 32-bit got vs exp values
    task automatic check;
        input [640-1:0] name;
        input [31:0] got, exp;
        if (got === exp) begin
            $display("PASS [%0s]  got=%h", name, got);
            pass_cnt = pass_cnt + 1;
        end else begin
            $display("FAIL [%0s]  got=%h  exp=%h", name, got, exp);
            fail_cnt = fail_cnt + 1;
        end
    endtask

    // AXI-Lite write task
    task automatic axil_write;
        input [11:0] addr;
        input [31:0] data;
        begin
            @(negedge clk);
            s_awaddr = addr; s_awvalid = 1'b1;
            s_wdata  = data; s_wstrb   = 4'hF; s_wvalid = 1'b1;
            s_bready = 1'b1;
            @(posedge clk);
            while (!(s_awready && s_wready)) @(posedge clk);
            @(negedge clk);
            s_awvalid = 1'b0; s_wvalid = 1'b0;
            @(posedge clk);
            while (!s_bvalid) @(posedge clk);
            @(negedge clk);
            s_bready = 1'b0;
        end
    endtask

    // AXI-Lite read task
    task automatic axil_read;
        input  [11:0] addr;
        output [31:0] data;
        begin
            @(negedge clk);
            s_araddr  = addr; s_arvalid = 1'b1;
            s_rready  = 1'b0;
            @(posedge clk);
            while (!s_arready) @(posedge clk);
            @(negedge clk);
            s_arvalid = 1'b0;
            @(posedge clk);
            while (!s_rvalid) @(posedge clk);
            data = s_rdata;
            @(negedge clk);
            s_rready = 1'b1;
            @(posedge clk);
            @(negedge clk);
            s_rready = 1'b0;
        end
    endtask

    // Poll STATUS[1] (tip) until transfer completes or timeout
    task automatic i2c_wait_done;
        integer i;
        reg [31:0] st;
        begin
            st = 32'hFF;
            for (i = 0; i < 2000 && st[1]; i = i + 1) begin
                repeat(5) @(posedge clk);
                axil_read(12'h00C, st);
            end
        end
    endtask

    // Main test body driving all 50 I2C register and bus test cases
    initial begin
        clk = 0; rst_n = 0;
        pass_cnt = 0; fail_cnt = 0;
        s_awaddr=0; s_awvalid=0; s_wdata=0; s_wstrb=0; s_wvalid=0; s_bready=0;
        s_araddr=0; s_arvalid=0; s_rready=0;

        repeat(4) @(posedge clk);
        rst_n = 1;
        repeat(4) @(posedge clk);

        axil_read(12'h000, rdata);
        check("TC01 PRESCALER reset=0",    rdata[15:0], 16'h0000);

        axil_read(12'h004, rdata);
        check("TC02 CTRL reset=0",         rdata[7:0],  8'h00);

        axil_read(12'h010, rdata);
        check("TC03 TX reset=0",           rdata[7:0],  8'h00);

        axil_read(12'h014, rdata);
        check("TC04 CMD reset=0",          rdata[7:0],  8'h00);

        axil_read(12'h00C, rdata);
        check("TC05 STATUS reset=0",       rdata[7:0],  8'h00);

        axil_write(12'h000, 32'h0001); axil_read(12'h000, rdata);
        check("TC06 PRESCALER=0x0001",     rdata[15:0], 16'h0001);

        axil_write(12'h000, 32'h0009); axil_read(12'h000, rdata);
        check("TC07 PRESCALER=0x0009",     rdata[15:0], 16'h0009);

        axil_write(12'h000, 32'h00FF); axil_read(12'h000, rdata);
        check("TC08 PRESCALER=0x00FF",     rdata[15:0], 16'h00FF);

        axil_write(12'h000, 32'hFFFF); axil_read(12'h000, rdata);
        check("TC09 PRESCALER=0xFFFF",     rdata[15:0], 16'hFFFF);

        axil_write(12'h000, 32'h0004); axil_read(12'h000, rdata);
        check("TC10 PRESCALER=0x0004",     rdata[15:0], 16'h0004);

        axil_write(12'h004, 32'h80); axil_read(12'h004, rdata);
        check("TC11 CTRL core enable",     rdata[7], 1'b1);

        axil_write(12'h004, 32'h40); axil_read(12'h004, rdata);
        check("TC12 CTRL IEN only",        rdata[7:0], 8'h40);

        axil_write(12'h004, 32'hC0); axil_read(12'h004, rdata);
        check("TC13 CTRL en+IEN",          rdata[7:0], 8'hC0);

        axil_write(12'h004, 32'h00); axil_read(12'h004, rdata);
        check("TC14 CTRL disabled",        rdata[7:0], 8'h00);

        axil_write(12'h004, 32'h80); axil_read(12'h004, rdata);
        check("TC15 CTRL re-enable",       rdata[7], 1'b1);

        axil_write(12'h010, 32'hA5); axil_read(12'h010, rdata);
        check("TC16 TX=0xA5",              rdata[7:0], 8'hA5);

        axil_write(12'h010, 32'h5A); axil_read(12'h010, rdata);
        check("TC17 TX=0x5A",              rdata[7:0], 8'h5A);

        axil_write(12'h010, 32'hFF); axil_read(12'h010, rdata);
        check("TC18 TX=0xFF",              rdata[7:0], 8'hFF);

        axil_write(12'h010, 32'h00); axil_read(12'h010, rdata);
        check("TC19 TX=0x00",              rdata[7:0], 8'h00);

        axil_write(12'h010, 32'h42); axil_read(12'h010, rdata);
        check("TC20 TX=0x42",              rdata[7:0], 8'h42);

        axil_write(12'h004, 32'h00);
        axil_write(12'h014, 32'h90);
        axil_read (12'h014, rdata);
        check("TC21 CMD ignored core off", rdata[7:0], 8'h00);

        axil_write(12'h014, 32'hFF);
        axil_read (12'h014, rdata);
        check("TC22 CMD still 0 core off", rdata[7:0], 8'h00);

        axil_write(12'h004, 32'h80);
        axil_write(12'h014, 32'h00);
        axil_read (12'h014, rdata);
        check("TC23 CMD=0 with core on",   rdata[7:0], 8'h00);

        axil_read(12'h014, rdata);
        check("TC24 CMD[2:1] always=0",    rdata[2:1], 2'b00);

        axil_read(12'h014, rdata);
        check("TC25 CMD[0] always=0",      rdata[0], 1'b0);

        axil_read(12'h00C, rdata);
        check("TC26 STATUS busy=0 idle",   rdata[6], 1'b0);

        axil_read(12'h00C, rdata);
        check("TC27 STATUS tip=0 idle",    rdata[1], 1'b0);

        axil_read(12'h00C, rdata);
        check("TC28 STATUS al=0 idle",     rdata[5], 1'b0);

        axil_read(12'h00C, rdata);
        check("TC29 STATUS irq_flag=0",    rdata[0], 1'b0);

        axil_write(12'h00C, 32'hFF);
        axil_read (12'h00C, rdata);
        check("TC30 STATUS write ignored", rdata[7:0], 8'h00);

        axil_write(12'h004, 32'h00);
        axil_write(12'h000, 32'h0004);
        axil_write(12'h004, 32'h80);

        axil_read(12'h000, rdata);
        check("TC31 PRESCALER=4 confirm",  rdata[15:0], 16'h0004);

        axil_read(12'h004, rdata);
        check("TC32 CTRL en=1 confirm",    rdata[7], 1'b1);

        repeat(20) @(posedge clk);
        check("TC33 SCL idle=1",           i2c_scl, 1'b1);

        check("TC34 SDA idle=1",           i2c_sda, 1'b1);

        axil_read(12'h00C, rdata);
        check("TC35 STATUS idle state",    rdata[7:0], 8'h00);

        axil_write(12'h010, 32'h50);
        axil_write(12'h014, 32'h90);

        repeat(10) @(posedge clk);
        axil_read(12'h00C, rdata);
        check("TC36 Bus busy after START", rdata[6] | rdata[1], 1'b1);

        repeat(400) @(posedge clk);
        axil_read(12'h00C, rdata);
        check("TC37 tip=0 after START+WRITE done", rdata[1], 1'b0);

        check("TC38 rxack=1 no device",   rdata[7], 1'b1);

        axil_read(12'h014, rdata);
        check("TC39 CMD cleared after done", rdata[7:4], 4'h0);

        axil_read(12'h00C, rdata);
        check("TC40 irq_flag set",        rdata[0], 1'b1);

        axil_write(12'h014, 32'h01);
        repeat(20) @(posedge clk);
        axil_read(12'h00C, rdata);
        check("TC41 irq_flag cleared",    rdata[0], 1'b0);

        axil_write(12'h014, 32'h40);
        repeat(200) @(posedge clk);

        axil_read(12'h00C, rdata);
        check("TC42 busy=0 after STOP",   rdata[6], 1'b0);

        check("TC43 SDA=1 after STOP",    i2c_sda, 1'b1);

        check("TC44 SCL=1 after STOP",    i2c_scl, 1'b1);

        axil_read(12'h00C, rdata);
        check("TC45 STATUS tip=0",        rdata[1], 1'b0);

        axil_write(12'h004, 32'hC0);

        axil_write(12'h010, 32'h48);
        axil_write(12'h014, 32'h90);

        repeat(400) @(posedge clk);
        check("TC46 IRQ asserted on done", irq, 1'b1);

        axil_read(12'h00C, rdata);
        check("TC47 irq_flag=1",          rdata[0], 1'b1);

        axil_write(12'h014, 32'h01);
        repeat(20) @(posedge clk);
        check("TC48 IRQ deasserted",       irq, 1'b0);

        axil_write(12'h014, 32'h40);
        repeat(300) @(posedge clk);
        axil_read(12'h00C, rdata);
        check("TC49 busy=0 after STOP",    rdata[6], 1'b0);

        axil_write(12'h004, 32'h00);
        axil_write(12'h000, 32'h0064);
        axil_read (12'h000, rdata);
        check("TC50 PRESCALER=100 readback", rdata[15:0], 16'h0064);

        $display("");
        $display("=== tb_pulp_i2c_wrap: %0d/50 PASS | %0d FAIL ===",
                 pass_cnt, fail_cnt);
        $finish;
    end

    // Simulation timeout watchdog
    initial #10000000 begin $display("TIMEOUT"); $finish; end

endmodule
