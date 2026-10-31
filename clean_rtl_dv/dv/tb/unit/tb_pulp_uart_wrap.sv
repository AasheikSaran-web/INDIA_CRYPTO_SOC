`timescale 1ns/1ps
`default_nettype none

// PULP UART wrapper testbench with 50 test cases using external TX/RX loopback
module tb_pulp_uart_wrap;

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

    logic uart_tx, uart_rx;
    assign uart_rx = uart_tx;
    logic irq;

    pulp_uart_wrap dut (
        .clk       (clk),       .rst_n     (rst_n),
        .s_awaddr  (s_awaddr),  .s_awvalid (s_awvalid), .s_awready (s_awready),
        .s_wdata   (s_wdata),   .s_wstrb   (s_wstrb),
        .s_wvalid  (s_wvalid),  .s_wready  (s_wready),
        .s_bresp   (s_bresp),   .s_bvalid  (s_bvalid),  .s_bready  (s_bready),
        .s_araddr  (s_araddr),  .s_arvalid (s_arvalid), .s_arready (s_arready),
        .s_rdata   (s_rdata),   .s_rresp   (s_rresp),
        .s_rvalid  (s_rvalid),  .s_rready  (s_rready),
        .uart_rx   (uart_rx),   .uart_tx   (uart_tx),   .irq (irq)
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

    // AXI-Lite write with combinatorial awready/wready handshake
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

    // AXI-Lite read holding rready=0 until rvalid is seen
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

    // Main test body driving all 50 UART register and loopback test cases
    initial begin
        clk = 0; rst_n = 0;
        pass_cnt = 0; fail_cnt = 0;
        s_awaddr=0; s_awvalid=0; s_wdata=0; s_wstrb=0; s_wvalid=0; s_bready=0;
        s_araddr=0; s_arvalid=0; s_rready=0;

        repeat(4) @(posedge clk);
        rst_n = 1;
        repeat(4) @(posedge clk);

        axil_read(12'h00C, rdata);
        check("TC01 LCR reset=0x03",       rdata[7:0], 8'h03);

        axil_read(12'h010, rdata);
        check("TC02 MCR reset=0x00",       rdata[7:0], 8'h00);

        axil_read(12'h01C, rdata);
        check("TC03 SCR reset=0x00",       rdata[7:0], 8'h00);

        axil_read(12'h004, rdata);
        check("TC04 IER reset=0x00",       rdata[7:0], 8'h00);

        axil_read(12'h014, rdata);
        check("TC05 LSR reset=0x60",       rdata[7:0], 8'h60);

        axil_write(12'h01C, 32'hA5); axil_read(12'h01C, rdata);
        check("TC06 SCR=0xA5",             rdata[7:0], 8'hA5);

        axil_write(12'h01C, 32'h5A); axil_read(12'h01C, rdata);
        check("TC07 SCR=0x5A",             rdata[7:0], 8'h5A);

        axil_write(12'h01C, 32'hFF); axil_read(12'h01C, rdata);
        check("TC08 SCR=0xFF",             rdata[7:0], 8'hFF);

        axil_write(12'h01C, 32'h00); axil_read(12'h01C, rdata);
        check("TC09 SCR=0x00",             rdata[7:0], 8'h00);

        axil_write(12'h01C, 32'hBE); axil_read(12'h01C, rdata);
        check("TC10 SCR=0xBE",             rdata[7:0], 8'hBE);

        axil_write(12'h00C, 32'h03); axil_read(12'h00C, rdata);
        check("TC11 LCR 8N1=0x03",         rdata[7:0], 8'h03);

        axil_write(12'h00C, 32'h07); axil_read(12'h00C, rdata);
        check("TC12 LCR 8N2=0x07",         rdata[7:0], 8'h07);

        axil_write(12'h00C, 32'h1B); axil_read(12'h00C, rdata);
        check("TC13 LCR 8E1=0x1B",         rdata[7:0], 8'h1B);

        axil_write(12'h00C, 32'h80); axil_read(12'h00C, rdata);
        check("TC14 LCR DLAB=1",           rdata[7], 1'b1);

        axil_write(12'h00C, 32'h03); axil_read(12'h00C, rdata);
        check("TC15 LCR DLAB=0",           rdata[7], 1'b0);

        axil_write(12'h00C, 32'h83);
        axil_write(12'h000, 32'h09);
        axil_read (12'h000, rdata);
        check("TC16 DLL=0x09",             rdata[7:0], 8'h09);

        axil_write(12'h004, 32'h01);
        axil_read (12'h004, rdata);
        check("TC17 DLM=0x01",             rdata[7:0], 8'h01);

        axil_write(12'h000, 32'h0A);
        axil_read (12'h000, rdata);
        check("TC18 DLL=0x0A",             rdata[7:0], 8'h0A);

        axil_write(12'h004, 32'h00);
        axil_read (12'h004, rdata);
        check("TC19 DLM=0x00",             rdata[7:0], 8'h00);

        axil_write(12'h000, 32'h01);
        axil_read (12'h000, rdata);
        check("TC20 DLL=0x01 restored",    rdata[7:0], 8'h01);

        axil_write(12'h00C, 32'h03);

        axil_write(12'h004, 32'h01); axil_read(12'h004, rdata);
        check("TC21 IER RDA=1",            rdata[7:0], 8'h01);

        axil_write(12'h004, 32'h02); axil_read(12'h004, rdata);
        check("TC22 IER THRE=2",           rdata[7:0], 8'h02);

        axil_write(12'h004, 32'h04); axil_read(12'h004, rdata);
        check("TC23 IER RLS=4",            rdata[7:0], 8'h04);

        axil_write(12'h004, 32'h0F); axil_read(12'h004, rdata);
        check("TC24 IER all=0x0F",         rdata[7:0], 8'h0F);

        axil_write(12'h004, 32'h00); axil_read(12'h004, rdata);
        check("TC25 IER cleared=0x00",     rdata[7:0], 8'h00);

        axil_write(12'h010, 32'h01); axil_read(12'h010, rdata);
        check("TC26 MCR DTR=1",            rdata[7:0], 8'h01);

        axil_write(12'h010, 32'h02); axil_read(12'h010, rdata);
        check("TC27 MCR RTS=2",            rdata[7:0], 8'h02);

        axil_write(12'h010, 32'h08); axil_read(12'h010, rdata);
        check("TC28 MCR OUT2=8",           rdata[7:0], 8'h08);

        axil_write(12'h010, 32'h1F); axil_read(12'h010, rdata);
        check("TC29 MCR all5bits=0x1F",    rdata[7:0], 8'h1F);

        axil_write(12'h010, 32'h00); axil_read(12'h010, rdata);
        check("TC30 MCR cleared=0x00",     rdata[7:0], 8'h00);

        axil_read(12'h008, rdata);
        check("TC31 IIR no int IIR[0]=1",  rdata[0], 1'b1);

        axil_read(12'h008, rdata);
        check("TC32 IIR[7:6]=11 always",   rdata[7:6], 2'b11);

        axil_write(12'h004, 32'h02);
        axil_read(12'h008, rdata);
        check("TC33 IIR THRE int IIR[0]=0", rdata[0], 1'b0);

        check("TC34 IIR THRE code=0xC2",   rdata[7:0], 8'hC2);

        axil_write(12'h004, 32'h00);
        axil_read(12'h008, rdata);
        check("TC35 IIR after disable=0xC1", rdata[7:0], 8'hC1);

        axil_read(12'h014, rdata);
        check("TC36 LSR idle=0x60",        rdata[7:0], 8'h60);

        axil_read(12'h014, rdata);
        check("TC37 LSR THRE bit5=1",      rdata[5], 1'b1);

        axil_read(12'h014, rdata);
        check("TC38 LSR TEMT bit6=1",      rdata[6], 1'b1);

        axil_read(12'h018, rdata);
        check("TC39 MSR modem=0xF0",       rdata[7:0], 8'hF0);

        axil_read(12'h014, rdata);
        check("TC40 LSR no RX data",       rdata[0], 1'b0);

        axil_write(12'h000, 32'hA5);
        repeat(300) @(posedge clk);
        axil_read(12'h014, rdata);
        check("TC41a LSR DR=1 (0xA5)",     rdata[0], 1'b1);
        axil_read(12'h000, rdata);
        check("TC41b RBR=0xA5",            rdata[7:0], 8'hA5);

        axil_write(12'h000, 32'h5A);
        repeat(300) @(posedge clk);
        axil_read(12'h014, rdata);
        check("TC42a LSR DR=1 (0x5A)",     rdata[0], 1'b1);
        axil_read(12'h000, rdata);
        check("TC42b RBR=0x5A",            rdata[7:0], 8'h5A);

        axil_write(12'h000, 32'hFF);
        repeat(300) @(posedge clk);
        axil_read(12'h014, rdata);
        check("TC43a LSR DR=1 (0xFF)",     rdata[0], 1'b1);
        axil_read(12'h000, rdata);
        check("TC43b RBR=0xFF",            rdata[7:0], 8'hFF);

        axil_write(12'h000, 32'h00);
        repeat(300) @(posedge clk);
        axil_read(12'h014, rdata);
        check("TC44a LSR DR=1 (0x00)",     rdata[0], 1'b1);
        axil_read(12'h000, rdata);
        check("TC44b RBR=0x00",            rdata[7:0], 8'h00);

        axil_write(12'h000, 32'hAA);
        repeat(300) @(posedge clk);
        axil_read(12'h014, rdata);
        check("TC45a LSR DR=1 (0xAA)",     rdata[0], 1'b1);
        axil_read(12'h000, rdata);
        check("TC45b RBR=0xAA",            rdata[7:0], 8'hAA);

        axil_write(12'h000, 32'h12);
        repeat(300) @(posedge clk);
        axil_write(12'h000, 32'h34);
        repeat(300) @(posedge clk);
        axil_read(12'h000, rdata);
        check("TC46 RBR first byte=0x12",  rdata[7:0], 8'h12);
        axil_read(12'h000, rdata);
        check("TC47 RBR second byte=0x34", rdata[7:0], 8'h34);

        axil_read(12'h014, rdata);
        check("TC48 LSR no data=0",        rdata[0], 1'b0);

        axil_read(12'h014, rdata);
        check("TC49 LSR THRE/TEMT=0x60",   rdata[7:0], 8'h60);

        axil_write(12'h004, 32'h01);
        axil_write(12'h000, 32'h55);
        repeat(300) @(posedge clk);
        check("TC50 IRQ asserted",         irq, 1'b1);
        axil_read(12'h000, rdata);

        $display("");
        $display("=== tb_pulp_uart_wrap: %0d/50 PASS | %0d FAIL ===",
                 pass_cnt, fail_cnt);
        $finish;
    end

    // Simulation timeout watchdog
    initial #5000000 begin $display("TIMEOUT"); $finish; end

endmodule
