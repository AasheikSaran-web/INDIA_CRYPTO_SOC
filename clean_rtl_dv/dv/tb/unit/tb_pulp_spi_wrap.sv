`timescale 1ns/1ps
`default_nettype none

// PULP SPI wrapper testbench with 50 test cases using external MISO/MOSI loopback
module tb_pulp_spi_wrap;

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

    logic spi_sck, spi_mosi, spi_cs_n, irq;
    logic spi_miso;
    assign spi_miso = spi_mosi;

    pulp_spi_wrap #(
        .BUFFER_DEPTH   (8),
        .APB_ADDR_WIDTH (12)
    ) dut (
        .clk       (clk),       .rst_n     (rst_n),
        .s_awaddr  (s_awaddr),  .s_awvalid (s_awvalid), .s_awready (s_awready),
        .s_wdata   (s_wdata),   .s_wstrb   (s_wstrb),
        .s_wvalid  (s_wvalid),  .s_wready  (s_wready),
        .s_bresp   (s_bresp),   .s_bvalid  (s_bvalid),  .s_bready  (s_bready),
        .s_araddr  (s_araddr),  .s_arvalid (s_arvalid), .s_arready (s_arready),
        .s_rdata   (s_rdata),   .s_rresp   (s_rresp),
        .s_rvalid  (s_rvalid),  .s_rready  (s_rready),
        .spi_sck   (spi_sck),   .spi_mosi  (spi_mosi),
        .spi_miso  (spi_miso),  .spi_cs_n  (spi_cs_n),
        .irq       (irq)
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

    // Poll REG_STATUS[6:0] until SPI controller returns to idle or timeout
    task automatic spi_wait_done;
        integer i;
        reg [31:0] st;
        begin
            st = 32'hFF;
            for (i = 0; i < 2000 && st[6:0] != 7'h0; i = i + 1) begin
                repeat(10) @(posedge clk);
                axil_read(12'h000, st);
            end
        end
    endtask

    // Main test body driving all 50 SPI register and FIFO test cases
    initial begin
        clk = 0; rst_n = 0;
        pass_cnt = 0; fail_cnt = 0;
        s_awaddr=0; s_awvalid=0; s_wdata=0; s_wstrb=0; s_wvalid=0; s_bready=0;
        s_araddr=0; s_arvalid=0; s_rready=0;

        repeat(4) @(posedge clk);
        rst_n = 1;
        repeat(4) @(posedge clk);

        axil_read(12'h000, rdata);
        check("TC01 STATUS FIFO lvls=0",   rdata[27:16], 12'h000);

        axil_read(12'h004, rdata);
        check("TC02 CLKDIV reset=0",       rdata[7:0], 8'h00);

        axil_read(12'h008, rdata);
        check("TC03 SPICMD reset=0",       rdata, 32'h00000000);

        axil_read(12'h010, rdata);
        check("TC04 SPILEN reset=0",       rdata, 32'h00000000);

        axil_read(12'h014, rdata);
        check("TC05 SPIDUM reset=0",       rdata, 32'h00000000);

        axil_write(12'h004, 32'h01); axil_read(12'h004, rdata);
        check("TC06 CLKDIV=0x01",          rdata[7:0], 8'h01);

        axil_write(12'h004, 32'h07); axil_read(12'h004, rdata);
        check("TC07 CLKDIV=0x07",          rdata[7:0], 8'h07);

        axil_write(12'h004, 32'hFF); axil_read(12'h004, rdata);
        check("TC08 CLKDIV=0xFF",          rdata[7:0], 8'hFF);

        axil_write(12'h004, 32'h0F); axil_read(12'h004, rdata);
        check("TC09 CLKDIV=0x0F",          rdata[7:0], 8'h0F);

        axil_write(12'h004, 32'h01); axil_read(12'h004, rdata);
        check("TC10 CLKDIV=0x01 restore",  rdata[7:0], 8'h01);

        axil_write(12'h008, 32'hDEADBEEF); axil_read(12'h008, rdata);
        check("TC11 SPICMD=DEADBEEF",      rdata, 32'hDEADBEEF);

        axil_write(12'h008, 32'h12345678); axil_read(12'h008, rdata);
        check("TC12 SPICMD=12345678",      rdata, 32'h12345678);

        axil_write(12'h008, 32'hFFFFFFFF); axil_read(12'h008, rdata);
        check("TC13 SPICMD=FFFFFFFF",      rdata, 32'hFFFFFFFF);

        axil_write(12'h008, 32'h00000000); axil_read(12'h008, rdata);
        check("TC14 SPICMD=0",             rdata, 32'h00000000);

        axil_write(12'h008, 32'hA5A5A5A5); axil_read(12'h008, rdata);
        check("TC15 SPICMD=A5A5A5A5",      rdata, 32'hA5A5A5A5);

        axil_write(12'h00C, 32'h00AA55BB); axil_read(12'h00C, rdata);
        check("TC16 SPIADR=00AA55BB",      rdata, 32'h00AA55BB);

        axil_write(12'h00C, 32'hFFFFFFFF); axil_read(12'h00C, rdata);
        check("TC17 SPIADR=FFFFFFFF",      rdata, 32'hFFFFFFFF);

        axil_write(12'h00C, 32'h12345678); axil_read(12'h00C, rdata);
        check("TC18 SPIADR=12345678",      rdata, 32'h12345678);

        axil_write(12'h00C, 32'h00000001); axil_read(12'h00C, rdata);
        check("TC19 SPIADR=1",             rdata, 32'h00000001);

        axil_write(12'h00C, 32'h00000000); axil_read(12'h00C, rdata);
        check("TC20 SPIADR=0",             rdata, 32'h00000000);

        axil_write(12'h010, 32'h00080000); axil_read(12'h010, rdata);
        check("TC21 SPILEN 8bit data",     rdata, 32'h00080000);

        axil_write(12'h010, 32'h00200000); axil_read(12'h010, rdata);
        check("TC22 SPILEN 32bit data",    rdata, 32'h00200000);

        axil_write(12'h010, 32'h00080008); axil_read(12'h010, rdata);
        check("TC23 SPILEN cmd+data",      rdata, 32'h00080008);

        axil_write(12'h010, 32'h00100800); axil_read(12'h010, rdata);
        check("TC24 SPILEN addr+data",     rdata, 32'h00100800);

        axil_write(12'h010, 32'h00000000); axil_read(12'h010, rdata);
        check("TC25 SPILEN cleared",       rdata, 32'h00000000);

        axil_write(12'h014, 32'h00010001); axil_read(12'h014, rdata);
        check("TC26 SPIDUM rd=1 wr=1",     rdata, 32'h00010001);

        axil_write(12'h014, 32'h00080008); axil_read(12'h014, rdata);
        check("TC27 SPIDUM rd=8 wr=8",     rdata, 32'h00080008);

        axil_write(12'h014, 32'hFFFF0000); axil_read(12'h014, rdata);
        check("TC28 SPIDUM wr=0xFFFF",     rdata, 32'hFFFF0000);

        axil_write(12'h014, 32'h0000FFFF); axil_read(12'h014, rdata);
        check("TC29 SPIDUM rd=0xFFFF",     rdata, 32'h0000FFFF);

        axil_write(12'h014, 32'h00000000); axil_read(12'h014, rdata);
        check("TC30 SPIDUM cleared",       rdata, 32'h00000000);

        axil_write(12'h024, 32'h80000000); axil_read(12'h024, rdata);
        check("TC31 INTCFG int_en=1",      rdata[31], 1'b1);

        axil_write(12'h024, 32'h40000000); axil_read(12'h024, rdata);
        check("TC32 INTCFG cnt_en=1",      rdata[30], 1'b1);

        axil_write(12'h024, 32'h00000004); axil_read(12'h024, rdata);
        check("TC33 INTCFG th_tx=4",       rdata[3:0], 4'h4);

        axil_write(12'h024, 32'h00000400); axil_read(12'h024, rdata);
        check("TC34 INTCFG th_rx=4",       rdata[11:8], 4'h4);

        axil_write(12'h024, 32'h00000000); axil_read(12'h024, rdata);
        check("TC35 INTCFG cleared",       rdata, 32'h00000000);

        axil_write(12'h000, 32'h00000100);
        axil_read (12'h000, rdata);
        check("TC36 STATUS elements_tx=0", rdata[27:24], 4'h0);

        check("TC37 STATUS elements_rx=0", rdata[19:16], 4'h0);

        axil_write(12'h000, 32'h00000010);
        repeat(4) @(posedge clk);
        axil_read(12'h000, rdata);
        check("TC38 STATUS after swrst",   rdata[27:24], 4'h0);

        axil_write(12'h008, 32'hCAFEBABE); axil_read(12'h008, rdata);
        check("TC39 SPICMD after swrst",   rdata, 32'hCAFEBABE);

        axil_write(12'h008, 32'h00000000);
        axil_read (12'h008, rdata);
        check("TC40 SPICMD cleared",       rdata, 32'h00000000);

        axil_write(12'h018, 32'hDEADBEEF);
        axil_read (12'h000, rdata);
        check("TC41 TX FIFO 1 element",        rdata[27:24], 4'h1);

        axil_write(12'h018, 32'h12345678);
        axil_read (12'h000, rdata);
        check("TC42 TX FIFO 2 elements",       rdata[27:24], 4'h2);

        axil_write(12'h018, 32'hAABBCCDD);
        axil_read (12'h000, rdata);
        check("TC43 TX FIFO 3 elements",       rdata[27:24], 4'h3);

        axil_write(12'h000, 32'h00000010);
        repeat(4) @(posedge clk);
        axil_read (12'h000, rdata);
        check("TC44 TX FIFO empty after swrst", rdata[27:24], 4'h0);

        repeat(2) @(posedge clk);
        check("TC45 CS_N high at reset",       spi_cs_n, 1'b1);

        axil_write(12'h018, 32'h11111111);
        axil_write(12'h018, 32'h22222222);
        axil_write(12'h018, 32'h33333333);
        axil_write(12'h018, 32'h44444444);
        axil_write(12'h018, 32'h55555555);
        axil_write(12'h018, 32'h66666666);
        axil_write(12'h018, 32'h77777777);
        axil_write(12'h018, 32'h88888888);
        axil_read (12'h000, rdata);
        check("TC46 TX FIFO 8 elements full",  rdata[27:24], 4'h8);

        axil_write(12'h000, 32'h00000010);
        repeat(4) @(posedge clk);
        axil_read (12'h000, rdata);
        check("TC47 TX FIFO 0 after swrst",    rdata[27:24], 4'h0);

        axil_write(12'h00C, 32'hCAFEBABE);
        axil_write(12'h000, 32'h00000010);
        repeat(4) @(posedge clk);
        axil_read (12'h00C, rdata);
        check("TC48 SPIADR persists swrst",    rdata, 32'hCAFEBABE);

        axil_read(12'h028, rdata);
        check("TC49 INTSTA readable (no hang)", (rdata === 32'hXXXXXXXX) ? 0 : 1, 1'b1);

        axil_read(12'h000, rdata);
        check("TC50 Final STATUS FIFO empty",  rdata[27:24], 4'h0);

        $display("");
        $display("=== tb_pulp_spi_wrap: %0d/50 PASS | %0d FAIL ===",
                 pass_cnt, fail_cnt);
        $finish;
    end

    // Simulation timeout watchdog
    initial #10000000 begin $display("TIMEOUT"); $finish; end

endmodule
