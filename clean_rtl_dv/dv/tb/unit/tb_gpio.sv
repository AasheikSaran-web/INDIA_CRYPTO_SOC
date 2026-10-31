`timescale 1ns/1ps
`default_nettype none
// tb_gpio: hardware module definition
module tb_gpio;
    logic        clk;
    logic        rst_n;
    logic [31:0] gpio_in;
    wire  [31:0] gpio_out;
    wire  [31:0] gpio_dir;
    wire         irq;
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
    gpio dut (
        .clk           (clk),
        .rst_n         (rst_n),
        .gpio_in       (gpio_in),
        .gpio_out      (gpio_out),
        .gpio_dir      (gpio_dir),
        .irq           (irq),
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
    logic [31:0] rd;
    logic [1:0]  rresp_saved;

    // Simulation initialisation or stimulus block
    initial begin
        rst_n          = 1'b1;
        gpio_in        = 32'h0;
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
        check("TC01 gpio_out=0 after reset", gpio_out === 32'h0);
        check("TC02 gpio_dir=0 after reset", gpio_dir === 32'h0);
        check("TC03 irq=0 after reset", irq === 1'b0);
        axil_read(12'h00C, rd);
        check("TC04 IS=0 after reset", rd === 32'h0);
        axil_read(12'h008, rd);
        check("TC05 IE=0 after reset", rd === 32'h0);
        axil_write(12'h000, 32'hDEADBEEF, 4'hF);
        check("TC06 gpio_out=0xDEADBEEF after write", gpio_out === 32'hDEADBEEF);
        axil_write(12'h000, 32'h0, 4'hF);
        check("TC07 gpio_out=0 after clear", gpio_out === 32'h0);
        axil_write(12'h000, 32'hCAFEBABE, 4'hF);
        check("TC08 gpio_out=0xCAFEBABE", gpio_out === 32'hCAFEBABE);
        axil_write(12'h000, 32'h0000FF00, 4'h2);
        check("TC09 OUT byte1=0xFF after partial strb", gpio_out[15:8] === 8'hFF);
        check("TC09b OUT byte0 unchanged (0xBE)", gpio_out[7:0] === 8'hBE);
        axil_write(12'h000, 32'h0, 4'hF);
        check("TC10 OUT cleared to 0", gpio_out === 32'h0);
        axil_write(12'h004, 32'hFFFF0000, 4'hF);
        check("TC11 DIR=0xFFFF0000", gpio_dir === 32'hFFFF0000);
        check("TC12 gpio_out unchanged after DIR write", gpio_out === 32'h0);
        axil_write(12'h004, 32'h00000001, 4'hF);
        check("TC13 DIR[0]=1", gpio_dir[0] === 1'b1);
        axil_read(12'h004, rd);
        check("TC14 read DIR=0x1", rd === 32'h00000001);
        axil_write(12'h004, 32'h0, 4'hF);
        axil_read(12'h004, rd);
        check("TC15 DIR=0 after clear", rd === 32'h0);
        axil_write(12'h008, 32'hAA55AA55, 4'hF);
        axil_read(12'h008, rd);
        check("TC16 IE readback=0xAA55AA55", rd === 32'hAA55AA55);
        axil_write(12'h008, 32'h0, 4'hF);
        axil_read(12'h008, rd);
        check("TC17 IE=0 after clear", rd === 32'h0);
        axil_write(12'h008, 32'h00FF00FF, 4'hF);
        axil_read(12'h008, rd);
        check("TC18 IE=0x00FF00FF", rd === 32'h00FF00FF);
        axil_write(12'h008, 32'hAA000000, 4'h8);
        axil_read(12'h008, rd);
        check("TC19 IE after partial byte3 strobe = 0xAAFF00FF",
              rd === 32'hAAFF00FF);
        axil_write(12'h008, 32'h0, 4'hF);
        axil_read(12'h008, rd);
        check("TC20 IE cleared", rd === 32'h0);
        @(negedge clk); gpio_in = 32'hDEAD0000;
        tick(3);
        axil_read(12'h000, rd);
        check("TC21 sync'd input=0xDEAD0000", rd === 32'hDEAD0000);
        @(negedge clk); gpio_in = 32'hBEEFCAFE;
        tick(3);
        axil_read(12'h000, rd);
        check("TC22 sync'd input=0xBEEFCAFE", rd === 32'hBEEFCAFE);
        @(negedge clk); gpio_in = 32'h0;
        tick(3);
        axil_read(12'h000, rd);
        check("TC23 sync'd input=0", rd === 32'h0);
        @(negedge clk); gpio_in = 32'h80;
        tick(3);
        axil_read(12'h000, rd);
        check("TC24 sync'd bit7=1", rd[7] === 1'b1 && rd[31:8] === 24'h0);
        @(negedge clk); gpio_in = 32'hFFFFFFFF;
        tick(1);
        axil_read(12'h000, rd);
        check("TC25 sync1 not yet updated after 1 cycle (=0x80)", rd === 32'h80);
        tick(2);
        @(negedge clk); gpio_in = 32'h0;
        tick(4);
        axil_write(12'h00C, 32'hFFFFFFFF, 4'hF);
        tick(2);
        axil_write(12'h008, 32'h00000001, 4'hF);
        axil_write(12'h004, 32'h0, 4'hF);
        tick(2);
        @(negedge clk); gpio_in[0] = 1'b1;
        tick(4);
        check("TC26 irq asserts on bit0 rising edge", irq === 1'b1);
        axil_read(12'h00C, rd);
        check("TC27 IS[0]=1 after bit0 toggle", rd[0] === 1'b1);
        check("TC28 irq still asserted before IS clear", irq === 1'b1);
        axil_write(12'h00C, 32'h00000001, 4'hF);
        tick(2);
        check("TC29 irq deasserts after IS clear", irq === 1'b0);
        axil_read(12'h00C, rd);
        check("TC30 IS=0 after clear", rd === 32'h0);
        @(negedge clk); gpio_in = 32'h0;
        tick(4);
        axil_write(12'h008, 32'h00000007, 4'hF);
        axil_write(12'h00C, 32'hFFFFFFFF, 4'hF);
        tick(2);
        @(negedge clk); gpio_in[2:0] = 3'b111;
        tick(4);
        axil_read(12'h00C, rd);
        check("TC31 IS[2:0] set after 3-bit toggle", rd[2:0] === 3'b111);
        check("TC32 irq asserted with IS[2:0]=1", irq === 1'b1);
        axil_write(12'h00C, 32'h00000002, 4'hF);
        tick(2);
        axil_read(12'h00C, rd);
        check("TC33 IS[1] cleared, IS[0] and IS[2] still set", rd[2:0] === 3'b101);
        check("TC34 irq still high with IS[0,2]=1", irq === 1'b1);
        axil_write(12'h00C, 32'hFFFFFFFF, 4'hF);
        tick(3);
        check("TC35 irq deasserts after full IS clear", irq === 1'b0);

        @(negedge clk); gpio_in = 32'h0;
        tick(4);
        axil_write(12'h008, 32'hFFFFFFFF, 4'hF);
        axil_write(12'h004, 32'h0, 4'hF);
        axil_write(12'h00C, 32'hFFFFFFFF, 4'hF);
        tick(2);
        @(negedge clk); gpio_in = 32'h000000FF;
        tick(4);
        axil_read(12'h00C, rd);
        check("TC36 IS[7:0] all set after simultaneous 8-bit toggle", rd[7:0] === 8'hFF);
        check("TC37 irq asserted for 8-bit simultaneous edge", irq === 1'b1);
        axil_write(12'h00C, 32'hFFFFFFFF, 4'hF);
        tick(3);
        @(negedge clk); gpio_in = 32'hFF00FFFF;
        tick(4);
        axil_read(12'h00C, rd);
        check("TC38 IS[31:24]+[15:8] set after high/mid byte toggle", rd === 32'hFF00FF00);
        axil_write(12'h00C, 32'hFFFFFFFF, 4'hF);
        tick(3);
        @(negedge clk); gpio_in = 32'h0;
        tick(4);
        axil_read(12'h00C, rd);
        check("TC39 IS set again after falling edges on all bits", rd !== 32'h0);
        check("TC40 irq=1 after falling edge detects", irq === 1'b1);

        axil_write(12'h000, 32'h0, 4'hF);
        axil_write(12'h00C, 32'hFFFFFFFF, 4'hF);
        axil_write(12'h000, 32'hAABBCCDD, 4'h1);
        check("TC41 OUT[7:0]=0xDD (byte0 write)", gpio_out[7:0] === 8'hDD);
        check("TC41b OUT[31:8]=0 (bytes 1-3 unchanged)", gpio_out[31:8] === 24'h0);
        axil_write(12'h000, 32'hAABBCCDD, 4'h2);
        check("TC42 OUT[15:8]=0xCC (byte1 write)", gpio_out[15:8] === 8'hCC);
        check("TC42b OUT[7:0] unchanged (=0xDD)", gpio_out[7:0] === 8'hDD);
        axil_write(12'h000, 32'hAABBCCDD, 4'h4);
        check("TC43 OUT[23:16]=0xBB (byte2 write)", gpio_out[23:16] === 8'hBB);
        axil_write(12'h000, 32'hAABBCCDD, 4'h8);
        check("TC44 OUT[31:24]=0xAA (byte3 write)", gpio_out[31:24] === 8'hAA);
        check("TC45 OUT=0xAABBCCDD after 4 partial-strobe writes",
              gpio_out === 32'hAABBCCDD);
        axil_write(12'h010, 32'h12345678, 4'hF);
        axil_read(12'h010, rd);
        check("TC46 IEV readback=0x12345678", rd === 32'h12345678);
        axil_write(12'h010, 32'h0, 4'hF);
        axil_read(12'h010, rd);
        check("TC47 IEV=0 after clear", rd === 32'h0);
        axil_write(12'h010, 32'hABCDEF99, 4'h1);
        axil_read(12'h010, rd);
        check("TC48 IEV byte0=0x99 after partial write", rd[7:0] === 8'h99);
        @(negedge clk);
        s_axil_araddr  = 12'hFFF;
        s_axil_arvalid = 1'b1;
        s_axil_rready  = 1'b0;
        @(posedge clk);
        while (!s_axil_arready) @(posedge clk);
        @(negedge clk); s_axil_arvalid = 1'b0; s_axil_rready = 1'b1;
        @(posedge clk);
        while (!s_axil_rvalid) @(posedge clk);
        check("TC49 unknown addr rresp=SLVERR", s_axil_rresp === 2'b10);
        check("TC49b unknown addr rdata=0",     s_axil_rdata === 32'h0);
        @(negedge clk); s_axil_rready = 1'b0;
        @(posedge clk);
        @(negedge clk);
        s_axil_araddr  = 12'h020;
        s_axil_arvalid = 1'b1;
        s_axil_rready  = 1'b0;
        @(posedge clk);
        while (!s_axil_arready) @(posedge clk);
        @(negedge clk); s_axil_arvalid = 1'b0; s_axil_rready = 1'b1;
        @(posedge clk);
        while (!s_axil_rvalid) @(posedge clk);
        check("TC50 unknown addr 0x020 rresp=SLVERR", s_axil_rresp === 2'b10);
        @(negedge clk); s_axil_rready = 1'b0;
        @(posedge clk);
        $display("--------------------------------------------");
        $display("RESULT: %0d/50 passed", pass_count);
        $display("--------------------------------------------");
        $finish;
    end
    // Simulation initialisation or stimulus block
    initial begin
        #500000;
        $display("[ERROR] Simulation timeout");
        $finish;
    end

endmodule
`default_nettype wire
