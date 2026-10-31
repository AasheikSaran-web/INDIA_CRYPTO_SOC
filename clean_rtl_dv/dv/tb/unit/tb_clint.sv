`timescale 1ns/1ps
`default_nettype none
// tb_clint: hardware module definition
module tb_clint;
    logic        clk;
    logic        rst_n;
    wire         timer_irq;
    wire         soft_irq;
    logic [11:0] s_axil_awaddr;
    logic        s_axil_awvalid;
    wire         s_axil_awready;
    logic [31:0] s_axil_wdata;
    logic [3:0]  s_axil_wstrb;
    logic        s_axil_wvalid;
    wire         s_axil_wready;
    wire  [1:0]  s_axil_bresp;
    wire         s_axil_bvalid;
    logic        s_axil_bready;
    logic [11:0] s_axil_araddr;
    logic        s_axil_arvalid;
    wire         s_axil_arready;
    wire  [31:0] s_axil_rdata;
    wire  [1:0]  s_axil_rresp;
    wire         s_axil_rvalid;
    logic        s_axil_rready;
    clint dut (
        .clk           (clk),
        .rst_n         (rst_n),
        .timer_irq     (timer_irq),
        .soft_irq      (soft_irq),
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
    // Simulation initialisation or stimulus block
    initial clk = 1'b0;
    // Combinational logic output computation
    always #5 clk = ~clk;
    int pass_count = 0;
    int fail_count = 0;

    // automatic: reusable simulation task
    task automatic check(input string tc, input logic cond);
        if (cond) begin
            $display("[PASS] %s", tc);
            pass_count++;
        end else begin
            $display("[FAIL] %s", tc);
            fail_count++;
        end
    endtask
    // automatic: reusable simulation task
    task automatic axil_write(input [11:0] addr, input [31:0] data, input [3:0] strb);
        @(negedge clk);
        s_axil_awaddr  = addr;
        s_axil_wdata   = data;
        s_axil_wstrb   = strb;
        s_axil_awvalid = 1'b1;
        s_axil_wvalid  = 1'b1;
        s_axil_bready  = 1'b1;

        @(negedge clk);
        while (!(s_axil_awready && s_axil_wready)) @(negedge clk);

        s_axil_awvalid = 1'b0;
        s_axil_wvalid  = 1'b0;

        while (!s_axil_bvalid) @(negedge clk);

        @(negedge clk);
        s_axil_bready = 1'b0;
        @(posedge clk);
    endtask
    // automatic: reusable simulation task
    task automatic axil_read(input [11:0] addr, output [31:0] rdata);
        @(negedge clk);
        s_axil_araddr  = addr;
        s_axil_arvalid = 1'b1;
        s_axil_rready  = 1'b1;

        @(negedge clk);
        while (!s_axil_arready) @(negedge clk);

        s_axil_arvalid = 1'b0;

        while (!s_axil_rvalid) @(negedge clk);

        rdata = s_axil_rdata;

        @(negedge clk);
        s_axil_rready = 1'b0;
        @(posedge clk);
    endtask
    // automatic: reusable simulation task
    task automatic tick(input int n);
        repeat (n) @(posedge clk);
    endtask
    longint unsigned cycle_cnt;
    // Clocked sequential logic register update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) cycle_cnt <= 0;
        else        cycle_cnt <= cycle_cnt + 1;
    end
    logic [31:0] rd;
    longint unsigned mtime_snapshot;

    // Simulation initialisation or stimulus block
    initial begin
        rst_n          = 1'b1;
        s_axil_awaddr  = 12'h0;
        s_axil_awvalid = 1'b0;
        s_axil_wdata   = 32'h0;
        s_axil_wstrb   = 4'hF;
        s_axil_wvalid  = 1'b0;
        s_axil_bready  = 1'b0;
        s_axil_araddr  = 12'h0;
        s_axil_arvalid = 1'b0;
        s_axil_rready  = 1'b0;
        @(negedge clk); rst_n = 1'b0;
        tick(5);
        @(negedge clk); rst_n = 1'b1;
        tick(2);
        axil_write(12'h010, 32'h0, 4'hF);
        axil_write(12'h014, 32'h0, 4'hF);
        tick(1);
        axil_read(12'h010, rd);
        check("TC01 mtime_lo reads a small positive value after reset-to-zero", rd < 32'h20);
        axil_read(12'h014, rd);
        check("TC02 mtime_hi=0 after reset", rd === 32'h0);
        axil_read(12'h008, rd);
        check("TC03 mtimecmp_lo=0 after reset", rd === 32'h0);
        check("TC04 timer_irq=0 after reset (mtimecmp=0)", timer_irq === 1'b0);
        check("TC05 soft_irq=0 after reset", soft_irq === 1'b0);
        axil_write(12'h010, 32'h0, 4'hF);
        axil_write(12'h014, 32'h0, 4'hF);
        axil_read(12'h010, rd);
        check("TC06 mtime_lo > 0 after reset-to-zero and immediate read", rd > 32'h0);
        axil_write(12'h010, 32'h0, 4'hF);
        axil_write(12'h014, 32'h0, 4'hF);
        tick(10);
        axil_read(12'h010, rd);
        check("TC07 mtime_lo advanced after 10 cycles", rd >= 32'h0A && rd < 32'h1E);
        axil_read(12'h010, rd);
        begin
            logic [31:0] rd2;
            tick(5);
            axil_read(12'h010, rd2);
            check("TC08 mtime_lo non-decreasing over time", rd2 >= rd);
        end
        axil_write(12'h010, 32'h100, 4'hF);
        axil_read(12'h010, rd);
        check("TC09 mtime_lo >= 0x100 after write of 0x100", rd >= 32'h100);
        axil_read(12'h014, rd);
        check("TC10 mtime_hi=0 (no 32-bit wrap yet)", rd === 32'h0);
        axil_write(12'h000, 32'h1, 4'hF);
        tick(2);
        check("TC11 soft_irq=1 after MSIP write", soft_irq === 1'b1);
        axil_read(12'h000, rd);
        check("TC12 MSIP readback=1", rd[0] === 1'b1);
        axil_write(12'h000, 32'h0, 4'hF);
        tick(2);
        check("TC13 soft_irq=0 after MSIP clear", soft_irq === 1'b0);
        axil_write(12'h000, 32'hFFFFFFFE, 4'hF);
        tick(2);
        check("TC14 soft_irq=0 when MSIP bit0=0 (upper bits masked)", soft_irq === 1'b0);
        axil_read(12'h000, rd);
        check("TC14b MSIP readback=0 (upper bits masked to 0)", rd === 32'h0);
        axil_write(12'h000, 32'h1, 4'hF); tick(2);
        check("TC15a soft_irq=1", soft_irq === 1'b1);
        axil_write(12'h000, 32'h0, 4'hF); tick(2);
        check("TC15b soft_irq=0", soft_irq === 1'b0);
        axil_write(12'h010, 32'h0, 4'hF);
        axil_write(12'h014, 32'h0, 4'hF);
        axil_write(12'h008, 32'h0, 4'hF);
        axil_write(12'h00C, 32'h0, 4'hF);
        tick(2);
        check("TC16 timer_irq=0 with mtimecmp=0 (disabled)", timer_irq === 1'b0);
        axil_write(12'h008, 32'hFFFFFFFF, 4'hF);
        axil_write(12'h00C, 32'hFFFFFFFF, 4'hF);
        tick(2);
        check("TC17 timer_irq=0 with mtimecmp far in future", timer_irq === 1'b0);
        axil_write(12'h010, 32'h0, 4'hF);
        axil_write(12'h014, 32'h0, 4'hF);
        axil_write(12'h00C, 32'h0, 4'hF);
        axil_write(12'h008, 32'h20, 4'hF);
        tick(50);
        check("TC18 timer_irq=1 after mtime>=mtimecmp", timer_irq === 1'b1);
        tick(10);
        check("TC19 timer_irq remains=1", timer_irq === 1'b1);
        axil_write(12'h008, 32'h0, 4'hF);
        axil_write(12'h00C, 32'h0, 4'hF);
        tick(3);
        check("TC20 timer_irq=0 after mtimecmp cleared to 0", timer_irq === 1'b0);
        axil_read(12'h010, rd);
        check("TC21 mtime > 0 (running)", rd > 32'h0);
        check("TC22 timer_irq=0 when mtimecmp=0 (even with mtime>0)", timer_irq === 1'b0);
        axil_write(12'h008, 32'h0, 4'hF);
        axil_write(12'h00C, 32'h0, 4'hF);
        tick(2);
        check("TC23 timer_irq=0 (mtimecmp=0 disables)", timer_irq === 1'b0);
        axil_write(12'h010, 32'hFFFFFF00, 4'hF);
        tick(3);
        check("TC24 timer_irq=0 with large mtime but mtimecmp=0", timer_irq === 1'b0);
        axil_write(12'h008, 32'h1, 4'hF);
        tick(3);
        check("TC25 timer_irq=1 when mtimecmp=1 and mtime>1", timer_irq === 1'b1);
        axil_write(12'h008, 32'h0, 4'hF);
        tick(2);
        axil_write(12'h010, 32'h500, 4'hF);
        axil_read(12'h010, rd);
        check("TC26 mtime_lo >= 0x500 after write", rd >= 32'h500);
        axil_read(12'h014, rd);
        check("TC27 mtime_hi=0 (no carry from lo write)", rd === 32'h0);
        axil_write(12'h010, 32'h0, 4'hF);
        axil_read(12'h010, rd);
        check("TC28 mtime_lo small after write-to-zero", rd < 32'h20);
        axil_write(12'h014, 32'h1, 4'hF);
        axil_write(12'h010, 32'h0, 4'hF);
        tick(2);
        axil_read(12'h014, rd);
        check("TC29 mtime_hi=1 after write", rd === 32'h1);
        axil_write(12'h014, 32'h0, 4'hF);
        axil_read(12'h014, rd);
        check("TC30 mtime_hi=0 after clear", rd === 32'h0);
        axil_write(12'h010, 32'h0, 4'hF);
        axil_write(12'h014, 32'h0, 4'hF);
        axil_write(12'h008, 32'hDEADBEEF, 4'hF);
        axil_write(12'h00C, 32'h0, 4'hF);
        tick(5);
        check("TC31 timer_irq=0 with mtimecmp=0xDEADBEEF (future)", timer_irq === 1'b0);
        tick(20);
        check("TC32 timer_irq=0 after 20 more cycles (mtime still << mtimecmp)", timer_irq === 1'b0);
        axil_read(12'h010, rd);
        check("TC33 mtime_lo < 0xDEADBEEF (far from threshold)", rd < 32'hDEADBEEF);
        axil_read(12'h008, rd);
        check("TC34 mtimecmp_lo readback=0xDEADBEEF", rd === 32'hDEADBEEF);
        axil_write(12'h008, 32'h0, 4'hF);
        axil_write(12'h00C, 32'h0, 4'hF);
        tick(2);
        check("TC35 timer_irq=0 after disabling large mtimecmp", timer_irq === 1'b0);
        axil_write(12'h008, 32'hAAAAAAAA, 4'hF);
        axil_read(12'h008, rd);
        check("TC36 mtimecmp_lo=0xAAAAAAAA readback", rd === 32'hAAAAAAAA);
        axil_write(12'h00C, 32'h55555555, 4'hF);
        axil_read(12'h00C, rd);
        check("TC37 mtimecmp_hi=0x55555555 readback", rd === 32'h55555555);
        axil_read(12'h008, rd);
        check("TC38 mtimecmp_lo still 0xAAAAAAAA (independent of hi write)",
              rd === 32'hAAAAAAAA);
        axil_write(12'h010, 32'h0, 4'hF);
        axil_write(12'h014, 32'h0, 4'hF);
        axil_write(12'h00C, 32'h0, 4'hF);
        axil_write(12'h008, 32'h50, 4'hF);
        tick(100);
        check("TC39 timer_irq=1 using combined 64-bit mtimecmp=0x50", timer_irq === 1'b1);
        axil_write(12'h008, 32'h0, 4'hF);
        axil_write(12'h00C, 32'h0, 4'hF);
        tick(3);
        check("TC40 timer_irq=0 after clearing combined mtimecmp", timer_irq === 1'b0);
        axil_write(12'h000, 32'hFFFFFFFF, 4'h1);
        tick(2);
        check("TC41 soft_irq=1 after strb[0] write with data[0]=1", soft_irq === 1'b1);
        axil_write(12'h000, 32'h0, 4'h0);
        tick(2);
        check("TC42 soft_irq unchanged (=1) when strb=0 write", soft_irq === 1'b1);
        axil_write(12'h000, 32'h0, 4'h1);
        tick(2);
        check("TC43 soft_irq=0 after strb[0] write with data[0]=0", soft_irq === 1'b0);
        axil_write(12'h000, 32'hFFFFFFFF, 4'hE);
        tick(2);
        check("TC44 soft_irq=0 (upper-byte-only strobe, bit0 unaffected)", soft_irq === 1'b0);
        axil_write(12'h000, 32'h1, 4'hF);
        tick(2);
        check("TC45 soft_irq=1 after full-strobe write", soft_irq === 1'b1);
        axil_write(12'h000, 32'h0, 4'hF); tick(2);
        @(negedge clk); s_axil_araddr=12'h004; s_axil_arvalid=1'b1; s_axil_rready=1'b0;
        @(posedge clk); while (!s_axil_arready) @(posedge clk);
        @(negedge clk); s_axil_arvalid=1'b0; s_axil_rready=1'b1;
        @(posedge clk); while (!s_axil_rvalid) @(posedge clk);
        check("TC46 unknown addr 0x004 rresp=SLVERR", s_axil_rresp === 2'b10);
        check("TC46b unknown addr 0x004 rdata=0",     s_axil_rdata === 32'h0);
        @(negedge clk); s_axil_rready=1'b0; @(posedge clk);
        @(negedge clk); s_axil_araddr=12'h018; s_axil_arvalid=1'b1; s_axil_rready=1'b0;
        @(posedge clk); while (!s_axil_arready) @(posedge clk);
        @(negedge clk); s_axil_arvalid=1'b0; s_axil_rready=1'b1;
        @(posedge clk); while (!s_axil_rvalid) @(posedge clk);
        check("TC47 unknown addr 0x018 rresp=SLVERR", s_axil_rresp === 2'b10);
        @(negedge clk); s_axil_rready=1'b0; @(posedge clk);
        @(negedge clk); s_axil_araddr=12'hFFF; s_axil_arvalid=1'b1; s_axil_rready=1'b0;
        @(posedge clk); while (!s_axil_arready) @(posedge clk);
        @(negedge clk); s_axil_arvalid=1'b0; s_axil_rready=1'b1;
        @(posedge clk); while (!s_axil_rvalid) @(posedge clk);
        check("TC48 unknown addr 0xFFF rresp=SLVERR", s_axil_rresp === 2'b10);
        check("TC48b rdata=0 for unknown addr",        s_axil_rdata === 32'h0);
        @(negedge clk); s_axil_rready=1'b0; @(posedge clk);
        @(negedge clk); s_axil_araddr=12'h000; s_axil_arvalid=1'b1; s_axil_rready=1'b0;
        @(posedge clk); while (!s_axil_arready) @(posedge clk);
        @(negedge clk); s_axil_arvalid=1'b0; s_axil_rready=1'b1;
        @(posedge clk); while (!s_axil_rvalid) @(posedge clk);
        check("TC49 valid addr 0x000 rresp=OKAY", s_axil_rresp === 2'b00);
        @(negedge clk); s_axil_rready=1'b0; @(posedge clk);
        @(negedge clk); s_axil_araddr=12'h100; s_axil_arvalid=1'b1; s_axil_rready=1'b0;
        @(posedge clk); while (!s_axil_arready) @(posedge clk);
        @(negedge clk); s_axil_arvalid=1'b0; s_axil_rready=1'b1;
        @(posedge clk); while (!s_axil_rvalid) @(posedge clk);
        check("TC50 unknown addr 0x100 rresp=SLVERR", s_axil_rresp === 2'b10);
        check("TC50b unknown addr 0x100 rdata=0",     s_axil_rdata === 32'h0);
        @(negedge clk); s_axil_rready=1'b0; @(posedge clk);
        $display("--------------------------------------------");
        $display("RESULT: %0d/50 passed", pass_count);
        $display("--------------------------------------------");
        $finish;
    end
    // Simulation initialisation or stimulus block
    initial begin
        #1000000;
        $display("[ERROR] Simulation timeout");
        $finish;
    end

endmodule
`default_nettype wire
