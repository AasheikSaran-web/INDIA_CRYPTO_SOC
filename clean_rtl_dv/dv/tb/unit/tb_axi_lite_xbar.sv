`timescale 1ns/1ps

// 50-test unit testbench for axi_lite_xbar covering routing, back-pressure, arbitration, and reset
module tb_axi_lite_xbar;

reg clk;
reg rst_n;
// Clock initial state
initial clk = 0;
// 100 MHz clock toggle
always #5 clk = ~clk;

reg [31:0] m0_awaddr;
reg        m0_awvalid;
reg [31:0] m0_wdata;
reg [3:0]  m0_wstrb;
reg        m0_wvalid;
reg        m0_bready;
reg [31:0] m0_araddr;
reg        m0_arvalid;
reg        m0_rready;

wire       m0_awready;
wire       m0_wready;
wire [1:0] m0_bresp;
wire       m0_bvalid;
wire       m0_arready;
wire [31:0]m0_rdata;
wire [1:0] m0_rresp;
wire       m0_rvalid;

reg [31:0] m1_awaddr;
reg        m1_awvalid;
reg [31:0] m1_wdata;
reg [3:0]  m1_wstrb;
reg        m1_wvalid;
reg        m1_bready;
reg [31:0] m1_araddr;
reg        m1_arvalid;
reg        m1_rready;

wire       m1_awready;
wire       m1_wready;
wire [1:0] m1_bresp;
wire       m1_bvalid;
wire       m1_arready;
wire [31:0]m1_rdata;
wire [1:0] m1_rresp;
wire       m1_rvalid;

wire [31:0] s0_awaddr,  s1_awaddr,  s2_awaddr,  s3_awaddr,  s4_awaddr;
wire [31:0] s5_awaddr,  s6_awaddr,  s7_awaddr,  s8_awaddr,  s9_awaddr,  s10_awaddr;
wire        s0_awvalid, s1_awvalid, s2_awvalid, s3_awvalid, s4_awvalid;
wire        s5_awvalid, s6_awvalid, s7_awvalid, s8_awvalid, s9_awvalid, s10_awvalid;
wire [31:0] s0_wdata,   s1_wdata,   s2_wdata,   s3_wdata,   s4_wdata;
wire [31:0] s5_wdata,   s6_wdata,   s7_wdata,   s8_wdata,   s9_wdata,   s10_wdata;
wire [3:0]  s0_wstrb,   s1_wstrb,   s2_wstrb,   s3_wstrb,   s4_wstrb;
wire [3:0]  s5_wstrb,   s6_wstrb,   s7_wstrb,   s8_wstrb,   s9_wstrb,   s10_wstrb;
wire        s0_wvalid,  s1_wvalid,  s2_wvalid,  s3_wvalid,  s4_wvalid;
wire        s5_wvalid,  s6_wvalid,  s7_wvalid,  s8_wvalid,  s9_wvalid,  s10_wvalid;
wire        s0_bready,  s1_bready,  s2_bready,  s3_bready,  s4_bready;
wire        s5_bready,  s6_bready,  s7_bready,  s8_bready,  s9_bready,  s10_bready;
wire [31:0] s0_araddr,  s1_araddr,  s2_araddr,  s3_araddr,  s4_araddr;
wire [31:0] s5_araddr,  s6_araddr,  s7_araddr,  s8_araddr,  s9_araddr,  s10_araddr;
wire        s0_arvalid, s1_arvalid, s2_arvalid, s3_arvalid, s4_arvalid;
wire        s5_arvalid, s6_arvalid, s7_arvalid, s8_arvalid, s9_arvalid, s10_arvalid;
wire        s0_rready,  s1_rready,  s2_rready,  s3_rready,  s4_rready;
wire        s5_rready,  s6_rready,  s7_rready,  s8_rready,  s9_rready,  s10_rready;

reg  s0_awready,  s1_awready,  s2_awready,  s3_awready,  s4_awready;
reg  s5_awready,  s6_awready,  s7_awready,  s8_awready,  s9_awready,  s10_awready;
reg  s0_wready,   s1_wready,   s2_wready,   s3_wready,   s4_wready;
reg  s5_wready,   s6_wready,   s7_wready,   s8_wready,   s9_wready,   s10_wready;
reg  [1:0] s0_bresp,  s1_bresp,  s2_bresp,  s3_bresp,  s4_bresp;
reg  [1:0] s5_bresp,  s6_bresp,  s7_bresp,  s8_bresp,  s9_bresp,  s10_bresp;
reg  s0_bvalid,   s1_bvalid,   s2_bvalid,   s3_bvalid,   s4_bvalid;
reg  s5_bvalid,   s6_bvalid,   s7_bvalid,   s8_bvalid,   s9_bvalid,   s10_bvalid;
reg  s0_arready,  s1_arready,  s2_arready,  s3_arready,  s4_arready;
reg  s5_arready,  s6_arready,  s7_arready,  s8_arready,  s9_arready,  s10_arready;
reg  [31:0] s0_rdata, s1_rdata, s2_rdata, s3_rdata, s4_rdata;
reg  [31:0] s5_rdata, s6_rdata, s7_rdata, s8_rdata, s9_rdata, s10_rdata;
reg  [1:0] s0_rresp,  s1_rresp,  s2_rresp,  s3_rresp,  s4_rresp;
reg  [1:0] s5_rresp,  s6_rresp,  s7_rresp,  s8_rresp,  s9_rresp,  s10_rresp;
reg  s0_rvalid,   s1_rvalid,   s2_rvalid,   s3_rvalid,   s4_rvalid;
reg  s5_rvalid,   s6_rvalid,   s7_rvalid,   s8_rvalid,   s9_rvalid,   s10_rvalid;

axi_lite_xbar dut (
    .clk(clk), .rst_n(rst_n),
    .m0_awaddr(m0_awaddr), .m0_awvalid(m0_awvalid), .m0_awready(m0_awready),
    .m0_wdata(m0_wdata),   .m0_wstrb(m0_wstrb),     .m0_wvalid(m0_wvalid),
    .m0_wready(m0_wready), .m0_bresp(m0_bresp),      .m0_bvalid(m0_bvalid),
    .m0_bready(m0_bready), .m0_araddr(m0_araddr),    .m0_arvalid(m0_arvalid),
    .m0_arready(m0_arready),.m0_rdata(m0_rdata),     .m0_rresp(m0_rresp),
    .m0_rvalid(m0_rvalid), .m0_rready(m0_rready),
    .m1_awaddr(m1_awaddr), .m1_awvalid(m1_awvalid), .m1_awready(m1_awready),
    .m1_wdata(m1_wdata),   .m1_wstrb(m1_wstrb),     .m1_wvalid(m1_wvalid),
    .m1_wready(m1_wready), .m1_bresp(m1_bresp),      .m1_bvalid(m1_bvalid),
    .m1_bready(m1_bready), .m1_araddr(m1_araddr),    .m1_arvalid(m1_arvalid),
    .m1_arready(m1_arready),.m1_rdata(m1_rdata),     .m1_rresp(m1_rresp),
    .m1_rvalid(m1_rvalid), .m1_rready(m1_rready),
    .s0_awaddr(s0_awaddr),  .s0_awvalid(s0_awvalid),  .s0_awready(s0_awready),
    .s0_wdata(s0_wdata),    .s0_wstrb(s0_wstrb),       .s0_wvalid(s0_wvalid),
    .s0_wready(s0_wready),  .s0_bresp(s0_bresp),        .s0_bvalid(s0_bvalid),
    .s0_bready(s0_bready),  .s0_araddr(s0_araddr),     .s0_arvalid(s0_arvalid),
    .s0_arready(s0_arready),.s0_rdata(s0_rdata),        .s0_rresp(s0_rresp),
    .s0_rvalid(s0_rvalid),  .s0_rready(s0_rready),
    .s1_awaddr(s1_awaddr),  .s1_awvalid(s1_awvalid),  .s1_awready(s1_awready),
    .s1_wdata(s1_wdata),    .s1_wstrb(s1_wstrb),       .s1_wvalid(s1_wvalid),
    .s1_wready(s1_wready),  .s1_bresp(s1_bresp),        .s1_bvalid(s1_bvalid),
    .s1_bready(s1_bready),  .s1_araddr(s1_araddr),     .s1_arvalid(s1_arvalid),
    .s1_arready(s1_arready),.s1_rdata(s1_rdata),        .s1_rresp(s1_rresp),
    .s1_rvalid(s1_rvalid),  .s1_rready(s1_rready),
    .s2_awaddr(s2_awaddr),  .s2_awvalid(s2_awvalid),  .s2_awready(s2_awready),
    .s2_wdata(s2_wdata),    .s2_wstrb(s2_wstrb),       .s2_wvalid(s2_wvalid),
    .s2_wready(s2_wready),  .s2_bresp(s2_bresp),        .s2_bvalid(s2_bvalid),
    .s2_bready(s2_bready),  .s2_araddr(s2_araddr),     .s2_arvalid(s2_arvalid),
    .s2_arready(s2_arready),.s2_rdata(s2_rdata),        .s2_rresp(s2_rresp),
    .s2_rvalid(s2_rvalid),  .s2_rready(s2_rready),
    .s3_awaddr(s3_awaddr),  .s3_awvalid(s3_awvalid),  .s3_awready(s3_awready),
    .s3_wdata(s3_wdata),    .s3_wstrb(s3_wstrb),       .s3_wvalid(s3_wvalid),
    .s3_wready(s3_wready),  .s3_bresp(s3_bresp),        .s3_bvalid(s3_bvalid),
    .s3_bready(s3_bready),  .s3_araddr(s3_araddr),     .s3_arvalid(s3_arvalid),
    .s3_arready(s3_arready),.s3_rdata(s3_rdata),        .s3_rresp(s3_rresp),
    .s3_rvalid(s3_rvalid),  .s3_rready(s3_rready),
    .s4_awaddr(s4_awaddr),  .s4_awvalid(s4_awvalid),  .s4_awready(s4_awready),
    .s4_wdata(s4_wdata),    .s4_wstrb(s4_wstrb),       .s4_wvalid(s4_wvalid),
    .s4_wready(s4_wready),  .s4_bresp(s4_bresp),        .s4_bvalid(s4_bvalid),
    .s4_bready(s4_bready),  .s4_araddr(s4_araddr),     .s4_arvalid(s4_arvalid),
    .s4_arready(s4_arready),.s4_rdata(s4_rdata),        .s4_rresp(s4_rresp),
    .s4_rvalid(s4_rvalid),  .s4_rready(s4_rready),
    .s5_awaddr(s5_awaddr),  .s5_awvalid(s5_awvalid),  .s5_awready(s5_awready),
    .s5_wdata(s5_wdata),    .s5_wstrb(s5_wstrb),       .s5_wvalid(s5_wvalid),
    .s5_wready(s5_wready),  .s5_bresp(s5_bresp),        .s5_bvalid(s5_bvalid),
    .s5_bready(s5_bready),  .s5_araddr(s5_araddr),     .s5_arvalid(s5_arvalid),
    .s5_arready(s5_arready),.s5_rdata(s5_rdata),        .s5_rresp(s5_rresp),
    .s5_rvalid(s5_rvalid),  .s5_rready(s5_rready),
    .s6_awaddr(s6_awaddr),  .s6_awvalid(s6_awvalid),  .s6_awready(s6_awready),
    .s6_wdata(s6_wdata),    .s6_wstrb(s6_wstrb),       .s6_wvalid(s6_wvalid),
    .s6_wready(s6_wready),  .s6_bresp(s6_bresp),        .s6_bvalid(s6_bvalid),
    .s6_bready(s6_bready),  .s6_araddr(s6_araddr),     .s6_arvalid(s6_arvalid),
    .s6_arready(s6_arready),.s6_rdata(s6_rdata),        .s6_rresp(s6_rresp),
    .s6_rvalid(s6_rvalid),  .s6_rready(s6_rready),
    .s7_awaddr(s7_awaddr),  .s7_awvalid(s7_awvalid),  .s7_awready(s7_awready),
    .s7_wdata(s7_wdata),    .s7_wstrb(s7_wstrb),       .s7_wvalid(s7_wvalid),
    .s7_wready(s7_wready),  .s7_bresp(s7_bresp),        .s7_bvalid(s7_bvalid),
    .s7_bready(s7_bready),  .s7_araddr(s7_araddr),     .s7_arvalid(s7_arvalid),
    .s7_arready(s7_arready),.s7_rdata(s7_rdata),        .s7_rresp(s7_rresp),
    .s7_rvalid(s7_rvalid),  .s7_rready(s7_rready),
    .s8_awaddr(s8_awaddr),  .s8_awvalid(s8_awvalid),  .s8_awready(s8_awready),
    .s8_wdata(s8_wdata),    .s8_wstrb(s8_wstrb),       .s8_wvalid(s8_wvalid),
    .s8_wready(s8_wready),  .s8_bresp(s8_bresp),        .s8_bvalid(s8_bvalid),
    .s8_bready(s8_bready),  .s8_araddr(s8_araddr),     .s8_arvalid(s8_arvalid),
    .s8_arready(s8_arready),.s8_rdata(s8_rdata),        .s8_rresp(s8_rresp),
    .s8_rvalid(s8_rvalid),  .s8_rready(s8_rready),
    .s9_awaddr(s9_awaddr),  .s9_awvalid(s9_awvalid),  .s9_awready(s9_awready),
    .s9_wdata(s9_wdata),    .s9_wstrb(s9_wstrb),       .s9_wvalid(s9_wvalid),
    .s9_wready(s9_wready),  .s9_bresp(s9_bresp),        .s9_bvalid(s9_bvalid),
    .s9_bready(s9_bready),  .s9_araddr(s9_araddr),     .s9_arvalid(s9_arvalid),
    .s9_arready(s9_arready),.s9_rdata(s9_rdata),        .s9_rresp(s9_rresp),
    .s9_rvalid(s9_rvalid),  .s9_rready(s9_rready),
    .s10_awaddr(s10_awaddr),  .s10_awvalid(s10_awvalid),  .s10_awready(s10_awready),
    .s10_wdata(s10_wdata),    .s10_wstrb(s10_wstrb),       .s10_wvalid(s10_wvalid),
    .s10_wready(s10_wready),  .s10_bresp(s10_bresp),        .s10_bvalid(s10_bvalid),
    .s10_bready(s10_bready),  .s10_araddr(s10_araddr),     .s10_arvalid(s10_arvalid),
    .s10_arready(s10_arready),.s10_rdata(s10_rdata),        .s10_rresp(s10_rresp),
    .s10_rvalid(s10_rvalid),  .s10_rready(s10_rready)
);

localparam [31:0] BASE0  = 32'h0000_0000, MASK0  = 32'hFFFF_8000;
localparam [31:0] BASE1  = 32'h2000_0000, MASK1  = 32'hFFFE_0000;
localparam [31:0] BASE2  = 32'h3000_0000, MASK2  = 32'hFFFF_F000;
localparam [31:0] BASE3  = 32'h3000_1000, MASK3  = 32'hFFFF_F000;
localparam [31:0] BASE4  = 32'h3000_2000, MASK4  = 32'hFFFF_F000;
localparam [31:0] BASE5  = 32'h4000_0000, MASK5  = 32'hFFFF_F000;
localparam [31:0] BASE6  = 32'h4000_1000, MASK6  = 32'hFFFF_F000;
localparam [31:0] BASE7  = 32'h4000_2000, MASK7  = 32'hFFFF_F000;
localparam [31:0] BASE8  = 32'h0200_0000, MASK8  = 32'hFFFF_F000;
localparam [31:0] BASE9  = 32'h0C00_0000, MASK9  = 32'hFFFF_F000;
localparam [31:0] BASE10 = 32'h4000_3000, MASK10 = 32'hFFFF_F000;

reg [31:0] base_addr [0:10];
wire [10:0] sx_awvalid_vec = {s10_awvalid, s9_awvalid, s8_awvalid, s7_awvalid,
                               s6_awvalid,  s5_awvalid, s4_awvalid, s3_awvalid,
                               s2_awvalid,  s1_awvalid, s0_awvalid};
wire [10:0] sx_arvalid_vec = {s10_arvalid, s9_arvalid, s8_arvalid, s7_arvalid,
                               s6_arvalid,  s5_arvalid, s4_arvalid, s3_arvalid,
                               s2_arvalid,  s1_arvalid, s0_arvalid};

integer pass_cnt;
integer fail_cnt;
integer tc;

// Task to assert synchronous reset for 2 cycles
task do_reset;
begin
    rst_n = 0;
    @(posedge clk); @(posedge clk);
    @(negedge clk);
    rst_n = 1;
    @(posedge clk);
end
endtask

// Task to deassert all master AXI-Lite signals
task idle_masters;
begin
    m0_awaddr  = 32'h0; m0_awvalid = 0;
    m0_wdata   = 32'h0; m0_wstrb   = 4'h0; m0_wvalid  = 0;
    m0_bready  = 0;
    m0_araddr  = 32'h0; m0_arvalid = 0; m0_rready = 0;
    m1_awaddr  = 32'h0; m1_awvalid = 0;
    m1_wdata   = 32'h0; m1_wstrb   = 4'h0; m1_wvalid  = 0;
    m1_bready  = 0;
    m1_araddr  = 32'h0; m1_arvalid = 0; m1_rready = 0;
end
endtask

// Task to configure all slave stubs as always-ready with distinct rdata values
task set_slaves_ready;
begin
    s0_awready=1;  s0_wready=1;  s0_bresp=2'b00; s0_bvalid=1;
    s0_arready=1;  s0_rdata=32'hAAAA_0000; s0_rresp=2'b00; s0_rvalid=0;
    s1_awready=1;  s1_wready=1;  s1_bresp=2'b00; s1_bvalid=1;
    s1_arready=1;  s1_rdata=32'hAAAA_0001; s1_rresp=2'b00; s1_rvalid=0;
    s2_awready=1;  s2_wready=1;  s2_bresp=2'b00; s2_bvalid=1;
    s2_arready=1;  s2_rdata=32'hAAAA_0002; s2_rresp=2'b00; s2_rvalid=0;
    s3_awready=1;  s3_wready=1;  s3_bresp=2'b00; s3_bvalid=1;
    s3_arready=1;  s3_rdata=32'hAAAA_0003; s3_rresp=2'b00; s3_rvalid=0;
    s4_awready=1;  s4_wready=1;  s4_bresp=2'b00; s4_bvalid=1;
    s4_arready=1;  s4_rdata=32'hAAAA_0004; s4_rresp=2'b00; s4_rvalid=0;
    s5_awready=1;  s5_wready=1;  s5_bresp=2'b00; s5_bvalid=1;
    s5_arready=1;  s5_rdata=32'hAAAA_0005; s5_rresp=2'b00; s5_rvalid=0;
    s6_awready=1;  s6_wready=1;  s6_bresp=2'b00; s6_bvalid=1;
    s6_arready=1;  s6_rdata=32'hAAAA_0006; s6_rresp=2'b00; s6_rvalid=0;
    s7_awready=1;  s7_wready=1;  s7_bresp=2'b00; s7_bvalid=1;
    s7_arready=1;  s7_rdata=32'hAAAA_0007; s7_rresp=2'b00; s7_rvalid=0;
    s8_awready=1;  s8_wready=1;  s8_bresp=2'b00; s8_bvalid=1;
    s8_arready=1;  s8_rdata=32'hAAAA_0008; s8_rresp=2'b00; s8_rvalid=0;
    s9_awready=1;  s9_wready=1;  s9_bresp=2'b00; s9_bvalid=1;
    s9_arready=1;  s9_rdata=32'hAAAA_0009; s9_rresp=2'b00; s9_rvalid=0;
    s10_awready=1; s10_wready=1; s10_bresp=2'b00; s10_bvalid=1;
    s10_arready=1; s10_rdata=32'hAAAA_000A; s10_rresp=2'b00; s10_rvalid=0;
end
endtask

// Task to report pass/fail result for a named test case
task report;
    input integer tnum;
    input         ok;
    input [127:0] name;
begin
    if (ok) begin
        $display("[PASS] TC%0d %s", tnum, name);
        pass_cnt = pass_cnt + 1;
    end else begin
        $display("[FAIL] TC%0d %s", tnum, name);
        fail_cnt = fail_cnt + 1;
    end
end
endtask

integer i;
reg ok;
reg [31:0] captured_rdata;

// Main test sequence: TC01-TC50
initial begin
    pass_cnt = 0;
    fail_cnt = 0;

    base_addr[0]  = BASE0;
    base_addr[1]  = BASE1;
    base_addr[2]  = BASE2;
    base_addr[3]  = BASE3;
    base_addr[4]  = BASE4;
    base_addr[5]  = BASE5;
    base_addr[6]  = BASE6;
    base_addr[7]  = BASE7;
    base_addr[8]  = BASE8;
    base_addr[9]  = BASE9;
    base_addr[10] = BASE10;

    idle_masters;
    set_slaves_ready;
    do_reset;

    for (i = 0; i < 11; i = i + 1) begin
        tc = i + 1;
        idle_masters;
        set_slaves_ready;
        @(negedge clk);
        m0_awaddr  = base_addr[i];
        m0_awvalid = 1;
        m0_wdata   = 32'hDEAD_0000 | i;
        m0_wstrb   = 4'hF;
        m0_wvalid  = 1;
        m0_bready  = 1;
        #1;
        ok = (sx_awvalid_vec[i] == 1) && ((sx_awvalid_vec & ~(11'h1 << i)) == 11'h0);
        report(tc, ok, "M0 write route to slave");
        @(negedge clk);
    end

    for (i = 0; i < 11; i = i + 1) begin
        tc = i + 12;
        idle_masters;
        set_slaves_ready;
        @(negedge clk);
        m0_araddr  = base_addr[i];
        m0_arvalid = 1;
        m0_rready  = 1;
        #1;
        ok = (sx_arvalid_vec[i] == 1) && ((sx_arvalid_vec & ~(11'h1 << i)) == 11'h0);
        report(tc, ok, "M0 read route to slave");
        @(negedge clk);
    end

    for (i = 0; i < 11; i = i + 1) begin
        tc = i + 23;
        idle_masters;
        set_slaves_ready;
        @(negedge clk);
        m0_awaddr  = 32'hFFFF_FFFF;
        m0_awvalid = 0;
        m1_awaddr  = base_addr[i];
        m1_awvalid = 1;
        m1_wdata   = 32'hBEEF_0000 | i;
        m1_wstrb   = 4'hF;
        m1_wvalid  = 1;
        m1_bready  = 1;
        #1;
        ok = (sx_awvalid_vec[i] == 1) && ((sx_awvalid_vec & ~(11'h1 << i)) == 11'h0);
        report(tc, ok, "M1 write route to slave");
        @(negedge clk);
    end

    begin
        tc = 34;
        idle_masters;
        set_slaves_ready;
        s0_awready = 0;
        @(negedge clk);
        m0_awaddr  = BASE0;
        m0_awvalid = 1;
        m0_wvalid  = 1;
        m0_wstrb   = 4'hF;
        #1;
        ok = (m0_awready == 0);
        report(tc, ok, "Back-pressure: S0 awready=0 holds m0_awready low");
        @(negedge clk);
    end

    begin
        tc = 35;
        idle_masters;
        set_slaves_ready;
        s5_awready = 0;
        @(negedge clk);
        m0_awaddr  = BASE5;
        m0_awvalid = 1;
        m0_wvalid  = 1;
        m0_wstrb   = 4'hF;
        #1;
        ok = (m0_awready == 0);
        report(tc, ok, "Back-pressure: S5 awready=0 holds m0_awready low");
        @(negedge clk);
    end

    begin
        tc = 36;
        idle_masters;
        set_slaves_ready;
        s9_wready = 0;
        @(negedge clk);
        m0_awaddr  = BASE9;
        m0_awvalid = 1;
        m0_wvalid  = 1;
        m0_wstrb   = 4'hF;
        #1;
        ok = (m0_wready == 0);
        report(tc, ok, "Back-pressure: S9 wready=0 holds m0_wready low");
        @(negedge clk);
    end

    begin
        tc = 37;
        idle_masters;
        set_slaves_ready;
        s1_arready = 0;
        @(negedge clk);
        m0_araddr  = BASE1;
        m0_arvalid = 1;
        #1;
        ok = (m0_arready == 0);
        report(tc, ok, "Back-pressure: S1 arready=0 holds m0_arready low");
        @(negedge clk);
    end

    begin
        tc = 38;
        idle_masters;
        set_slaves_ready;
        @(negedge clk);
        m0_araddr  = BASE2;
        m0_arvalid = 0;
        #1;
        ok = (s2_arvalid == 0);
        report(tc, ok, "Back-pressure: m0_arvalid=0 keeps s2_arvalid=0");
        @(negedge clk);
    end

    begin
        tc = 39;
        idle_masters;
        set_slaves_ready;
        s3_rdata   = 32'h1234_5678;
        s3_rvalid  = 0;
        s3_arready = 1;
        @(negedge clk);
        m0_araddr  = BASE3;
        m0_arvalid = 1;
        m0_rready  = 1;
        @(posedge clk); #1;
        m0_arvalid = 0;
        s3_rvalid  = 1;
        #1;
        ok = (m0_rdata == 32'h1234_5678) && (m0_rvalid == 1);
        report(tc, ok, "Rdata route: S3 rdata to m0_rdata");
        @(posedge clk); #1;
        s3_rvalid = 0;
        @(negedge clk);
    end

    begin
        tc = 40;
        idle_masters;
        set_slaves_ready;
        s7_rdata   = 32'hCAFE_BABE;
        s7_rvalid  = 0;
        s7_arready = 1;
        @(negedge clk);
        m0_araddr  = BASE7;
        m0_arvalid = 1;
        m0_rready  = 1;
        @(posedge clk); #1;
        m0_arvalid = 0;
        s7_rvalid  = 1;
        #1;
        ok = (m0_rdata == 32'hCAFE_BABE) && (m0_rvalid == 1);
        report(tc, ok, "Rdata route: S7 rdata to m0_rdata");
        @(posedge clk); #1;
        s7_rvalid = 0;
        @(negedge clk);
    end

    begin
        tc = 41;
        idle_masters;
        set_slaves_ready;
        s10_rdata   = 32'h5A5A_A5A5;
        s10_rvalid  = 0;
        s10_arready = 1;
        @(negedge clk);
        m0_araddr   = BASE10;
        m0_arvalid  = 1;
        m0_rready   = 1;
        @(posedge clk); #1;
        m0_arvalid  = 0;
        s10_rvalid  = 1;
        #1;
        ok = (m0_rdata == 32'h5A5A_A5A5) && (m0_rvalid == 1);
        report(tc, ok, "Rdata route: S10 rdata to m0_rdata");
        @(posedge clk); #1;
        s10_rvalid = 0;
        @(negedge clk);
    end

    begin
        tc = 42;
        idle_masters;
        set_slaves_ready;
        s0_rdata   = 32'h0BAD_F00D;
        s0_rvalid  = 0;
        s0_arready = 1;
        @(negedge clk);
        m0_araddr  = BASE0 | 32'h0000_0100;
        m0_arvalid = 1;
        m0_rready  = 1;
        @(posedge clk); #1;
        m0_arvalid = 0;
        s0_rvalid  = 1;
        #1;
        ok = (m0_rdata == 32'h0BAD_F00D) && (m0_rvalid == 1);
        report(tc, ok, "Rdata route: S0 rdata to m0_rdata (offset addr)");
        @(posedge clk); #1;
        s0_rvalid = 0;
        @(negedge clk);
    end

    begin
        tc = 43;
        idle_masters;
        set_slaves_ready;
        @(negedge clk);
        m0_awaddr  = BASE5;
        m0_awvalid = 1;
        m0_wvalid  = 1;
        m0_wstrb   = 4'hF;
        m0_bready  = 1;
        m1_awaddr  = BASE5;
        m1_awvalid = 1;
        m1_wvalid  = 1;
        m1_wstrb   = 4'hF;
        m1_bready  = 1;
        #1;
        ok = (s5_awvalid == 1) && (m1_awready == 0);
        report(tc, ok, "Arbitration: M0 wins write to S5, M1 stalled");
        @(negedge clk);
    end

    begin
        tc = 44;
        idle_masters;
        set_slaves_ready;
        @(negedge clk);
        m0_araddr  = BASE6;
        m0_arvalid = 1;
        m0_rready  = 1;
        m1_araddr  = BASE6;
        m1_arvalid = 1;
        m1_rready  = 1;
        #1;
        ok = (s6_arvalid == 1) && (m1_arready == 0);
        report(tc, ok, "Arbitration: M0 wins read from S6, M1 arready=0");
        @(negedge clk);
    end

    begin
        tc = 45;
        idle_masters;
        set_slaves_ready;
        s2_awready = 1;
        @(negedge clk);
        m0_awaddr  = BASE2;
        m0_awvalid = 1;
        m0_wvalid  = 1;
        m0_wstrb   = 4'hF;
        m1_awaddr  = BASE2;
        m1_awvalid = 1;
        m1_wvalid  = 1;
        m1_wstrb   = 4'hF;
        #1;
        ok = (m0_awready == 1) && (m1_awready == 0);
        report(tc, ok, "Arbitration: M0 awready=1 while M1 stalled on same slave");
        @(negedge clk);
    end

    begin
        tc = 46;
        idle_masters;
        set_slaves_ready;
        @(negedge clk);
        m0_awaddr  = BASE4;
        m0_awvalid = 1;
        m0_wvalid  = 1;
        m0_wstrb   = 4'hF;
        m1_awaddr  = BASE8;
        m1_awvalid = 1;
        m1_wvalid  = 1;
        m1_wstrb   = 4'hF;
        #1;
        ok = (s4_awvalid == 1) && (s8_awvalid == 1) &&
             (m0_awready == 1) && (m1_awready == 1);
        report(tc, ok, "Arbitration: M0->S4 and M1->S8 non-conflicting, both proceed");
        @(negedge clk);
    end

    begin
        tc = 47;
        idle_masters;
        set_slaves_ready;
        rst_n = 0;
        @(posedge clk); #1;
        ok = (sx_awvalid_vec == 11'h0);
        report(tc, ok, "Reset: all sx_awvalid = 0 during reset");
    end

    begin
        tc = 48;
        ok = (sx_arvalid_vec == 11'h0);
        report(tc, ok, "Reset: all sx_arvalid = 0 during reset");
        rst_n = 1;
        @(posedge clk); #1;
    end

    begin
        tc = 49;
        idle_masters;
        set_slaves_ready;
        @(negedge clk);
        #1;
        ok = (sx_awvalid_vec == 11'h0);
        report(tc, ok, "Post-reset idle: all sx_awvalid = 0 when masters idle");
    end

    begin
        tc = 50;
        ok = (sx_arvalid_vec == 11'h0);
        report(tc, ok, "Post-reset idle: all sx_arvalid = 0 when masters idle");
        @(negedge clk);
    end

    $display("----------------------------------------");
    $display("Results: %0d / 50 PASS,  %0d FAIL", pass_cnt, fail_cnt);
    $display("----------------------------------------");
    $finish;
end

endmodule
