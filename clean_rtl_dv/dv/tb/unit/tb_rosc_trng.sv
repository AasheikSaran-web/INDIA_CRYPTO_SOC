`timescale 1ns/1ps
`default_nettype none

// tb_rosc_trng: hardware module definition
module tb_rosc_trng;
localparam CLK_PERIOD = 10;

reg clk;
reg rst_n;
// Simulation initialisation or stimulus block
initial clk = 1'b0;
// Combinational logic output computation
always #(CLK_PERIOD/2) clk = ~clk;
reg         rosc_ext;
wire [31:0] trng_data;
wire        trng_valid;
wire        rct_fail;
wire        apt_fail;
reg  [11:0] s_axil_awaddr;
reg         s_axil_awvalid;
wire        s_axil_awready;
reg  [31:0] s_axil_wdata;
reg  [3:0]  s_axil_wstrb;
reg         s_axil_wvalid;
wire        s_axil_wready;
wire [1:0]  s_axil_bresp;
wire        s_axil_bvalid;
reg         s_axil_bready;
reg  [11:0] s_axil_araddr;
reg         s_axil_arvalid;
wire        s_axil_arready;
wire [31:0] s_axil_rdata;
wire [1:0]  s_axil_rresp;
wire        s_axil_rvalid;
reg         s_axil_rready;
rosc_trng #(
    .RCT_CUTOFF(30),
    .APT_WINDOW(512),
    .APT_THRESH(397)
) dut (
    .clk            (clk),
    .rst_n          (rst_n),
    .rosc_ext       (rosc_ext),
    .trng_data      (trng_data),
    .trng_valid     (trng_valid),
    .rct_fail       (rct_fail),
    .apt_fail       (apt_fail),
    .s_axil_awaddr  (s_axil_awaddr),
    .s_axil_awvalid (s_axil_awvalid),
    .s_axil_awready (s_axil_awready),
    .s_axil_wdata   (s_axil_wdata),
    .s_axil_wstrb   (s_axil_wstrb),
    .s_axil_wvalid  (s_axil_wvalid),
    .s_axil_wready  (s_axil_wready),
    .s_axil_bresp   (s_axil_bresp),
    .s_axil_bvalid  (s_axil_bvalid),
    .s_axil_bready  (s_axil_bready),
    .s_axil_araddr  (s_axil_araddr),
    .s_axil_arvalid (s_axil_arvalid),
    .s_axil_arready (s_axil_arready),
    .s_axil_rdata   (s_axil_rdata),
    .s_axil_rresp   (s_axil_rresp),
    .s_axil_rvalid  (s_axil_rvalid),
    .s_axil_rready  (s_axil_rready)
);
integer pass_count;
integer fail_count;
integer tc;

// pass_tc: reusable simulation task
task pass_tc;
    input integer n;
    begin
        $display("[PASS] TC%0d", n);
        pass_count = pass_count + 1;
    end
endtask

// fail_tc: reusable simulation task
task fail_tc;
    input integer n;
    input string  msg;
    begin
        $display("[FAIL] TC%0d : %s", n, msg);
        fail_count = fail_count + 1;
    end
endtask
// axil_write: reusable simulation task
task axil_write;
    input [11:0] addr;
    input [31:0] data;
    begin
        @(negedge clk);
        s_axil_awaddr  = addr;
        s_axil_awvalid = 1'b1;
        s_axil_wdata   = data;
        s_axil_wstrb   = 4'hF;
        s_axil_wvalid  = 1'b1;
        s_axil_bready  = 1'b0;
        @(posedge clk);
        while (!s_axil_awready) @(posedge clk);
        @(negedge clk);
        s_axil_awvalid = 1'b0;
        @(posedge clk);
        while (!s_axil_wready) @(posedge clk);
        @(negedge clk);
        s_axil_wvalid  = 1'b0;
        s_axil_bready  = 1'b1;
        @(posedge clk);
        while (!s_axil_bvalid) @(posedge clk);
        @(negedge clk);
        s_axil_bready = 1'b0;
        @(posedge clk);
    end
endtask
reg [31:0] axil_rdata_buf;

// axil_read: reusable simulation task
task axil_read;
    input  [11:0] addr;
    output [31:0] data;
    begin
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
        data = s_axil_rdata;
        @(negedge clk);
        s_axil_rready = 1'b0;
        @(posedge clk);
    end
endtask
// rosc_gen: reusable simulation task
task rosc_gen;
    input integer n_toggles;
    input integer period_clks;
    integer i;
    begin
        for (i = 0; i < n_toggles; i = i + 1) begin
            repeat(period_clks) @(posedge clk);
            rosc_ext = ~rosc_ext;
        end
    end
endtask
// wait_for_valid: reusable simulation task
task wait_for_valid;
    input  integer max_cycles;
    output integer timed_out;
    integer k;
    begin
        timed_out = 0;
        k = 0;
        while (!trng_valid && k < max_cycles) begin
            @(posedge clk);
            k = k + 1;
        end
        if (k >= max_cycles) timed_out = 1;
    end
endtask
// apply_reset: reusable simulation task
task apply_reset;
    begin
        rst_n = 1'b0;
        repeat(5) @(posedge clk);
        @(negedge clk);
        rst_n = 1'b1;
        @(posedge clk);
    end
endtask
// idle_axil: reusable simulation task
task idle_axil;
    begin
        s_axil_awaddr  = 12'h0;
        s_axil_awvalid = 1'b0;
        s_axil_wdata   = 32'h0;
        s_axil_wstrb   = 4'h0;
        s_axil_wvalid  = 1'b0;
        s_axil_bready  = 1'b0;
        s_axil_araddr  = 12'h0;
        s_axil_arvalid = 1'b0;
        s_axil_rready  = 1'b0;
    end
endtask
reg [31:0] rdata;
integer    timed_out;
integer    word_idx;
reg [31:0] prev_data;

// Simulation initialisation or stimulus block
initial begin
    pass_count = 0;
    fail_count = 0;
    rosc_ext   = 1'b0;
    idle_axil();
    apply_reset();
    repeat(2) @(posedge clk);
    tc = 1;
    if (trng_valid === 1'b0) pass_tc(tc); else fail_tc(tc, "trng_valid not 0 after reset");
    tc = 2;
    if (rct_fail === 1'b0) pass_tc(tc); else fail_tc(tc, "rct_fail not 0 after reset");
    tc = 3;
    if (apt_fail === 1'b0) pass_tc(tc); else fail_tc(tc, "apt_fail not 0 after reset");
    tc = 4;
    axil_read(12'h008, rdata);
    if (rdata === 32'h00000000) pass_tc(tc); else fail_tc(tc, $sformatf("CTRL=0x%08X, expected 0", rdata));
    tc = 5;
    axil_read(12'h004, rdata);
    if (rdata[0] === 1'b0 && rdata[1] === 1'b0 && rdata[2] === 1'b0)
        pass_tc(tc);
    else
        fail_tc(tc, $sformatf("STATUS=0x%08X, expected all-zero health bits", rdata));
    tc = 6;
    axil_write(12'h008, 32'h00000007);
    axil_read(12'h008, rdata);
    if (rdata[2:0] === 3'b111) pass_tc(tc); else fail_tc(tc, $sformatf("CTRL readback=0x%08X", rdata));
    tc = 7;
    rosc_gen(300, 3);
    wait_for_valid(500, timed_out);
    if (!timed_out && trng_valid === 1'b1)
        pass_tc(tc);
    else
        fail_tc(tc, "trng_valid did not assert after 128 toggles in bypass+test mode");
    tc = 8;
    axil_read(12'h000, rdata);
    if (rdata !== 32'h00000000) pass_tc(tc); else fail_tc(tc, "TRNG_DATA = 0 in test_mode");
    tc = 9;
    repeat(2) @(posedge clk);
    if (trng_valid === 1'b0) pass_tc(tc); else fail_tc(tc, "trng_valid still set after read");
    tc = 10;
    if (rdata !== 32'hDEADCAFE)
        pass_tc(tc);
    else
        fail_tc(tc, "TRNG_DATA unexpectedly equals LFSR reset seed");
    rosc_gen(300, 3);
    wait_for_valid(500, timed_out);
    tc = 11;
    axil_read(12'h004, rdata);
    if (rdata[0] === 1'b1) pass_tc(tc); else fail_tc(tc, $sformatf("STATUS[0]=0 but trng_valid from port=%0b", trng_valid));
    tc = 12;
    if (rdata[0] === trng_valid) pass_tc(tc); else fail_tc(tc, "STATUS[0] != trng_valid output port");
    axil_read(12'h000, rdata);
    repeat(2) @(posedge clk);
    tc = 13;
    axil_read(12'h004, rdata);
    if (rdata[0] === 1'b0) pass_tc(tc); else fail_tc(tc, "STATUS[0] still 1 after TRNG_DATA read");
    tc = 14;
    if (rdata[1] === 1'b0) pass_tc(tc); else fail_tc(tc, "rct_fail unexpectedly set");
    tc = 15;
    if (rdata[2] === 1'b0) pass_tc(tc); else fail_tc(tc, "apt_fail unexpectedly set");
    tc = 16;
    axil_write(12'h008, 32'h00000001);
    axil_read (12'h008, rdata);
    if (rdata[2:0] === 3'b001) pass_tc(tc); else fail_tc(tc, $sformatf("CTRL=0x%08X expected 0x1", rdata));
    tc = 17;
    axil_write(12'h008, 32'h00000003);
    axil_read (12'h008, rdata);
    if (rdata[2:0] === 3'b011) pass_tc(tc); else fail_tc(tc, $sformatf("CTRL=0x%08X expected 0x3", rdata));
    tc = 18;
    axil_write(12'h008, 32'h00000005);
    axil_read (12'h008, rdata);
    if (rdata[2:0] === 3'b101) pass_tc(tc); else fail_tc(tc, $sformatf("CTRL=0x%08X expected 0x5", rdata));
    tc = 19;
    axil_write(12'h008, 32'h00000007);
    axil_read (12'h008, rdata);
    if (rdata[2:0] === 3'b111) pass_tc(tc); else fail_tc(tc, $sformatf("CTRL=0x%08X expected 0x7", rdata));
    tc = 20;
    axil_write(12'h008, 32'h00000000);
    axil_read (12'h008, rdata);
    if (rdata[2:0] === 3'b000) pass_tc(tc); else fail_tc(tc, $sformatf("CTRL=0x%08X expected 0x0", rdata));
    axil_write(12'h008, 32'h00000007);
    prev_data = 32'hFFFFFFFF;

    for (word_idx = 21; word_idx <= 25; word_idx = word_idx + 1) begin
        rosc_gen(300, 3);
        wait_for_valid(600, timed_out);
        if (timed_out) begin
            fail_tc(word_idx, "trng_valid timeout on consecutive word");
        end else begin
            axil_read(12'h000, rdata);
            if (rdata !== 32'h0)
                pass_tc(word_idx);
            else
                fail_tc(word_idx, "TRNG_DATA word is zero");
            prev_data = rdata;
        end
        repeat(4) @(posedge clk);
    end
    apply_reset();
    idle_axil();
    axil_write(12'h008, 32'h00000001);
    repeat(2) @(posedge clk);
    rosc_ext = 1'b0;
    repeat(60) @(posedge clk);
    tc = 26;
    if (rct_fail === 1'b1) pass_tc(tc); else fail_tc(tc, "rct_fail not asserted after constant input");
    tc = 27;
    axil_read(12'h004, rdata);
    if (rdata[1] === 1'b1) pass_tc(tc); else fail_tc(tc, $sformatf("STATUS[1]=0, STATUS=0x%08X", rdata));
    tc = 28;
    if (rdata[2] === 1'b0) pass_tc(tc); else fail_tc(tc, "apt_fail prematurely set");
    tc = 29;
    if (trng_valid === 1'b0) pass_tc(tc); else fail_tc(tc, "trng_valid unexpectedly set during constant input");
    tc = 30;
    rosc_ext = 1'b1;
    repeat(2) @(posedge clk);
    rosc_ext = 1'b0;
    repeat(2) @(posedge clk);
    if (rct_fail === 1'b1) pass_tc(tc); else fail_tc(tc, "rct_fail not sticky after single toggle");
    tc = 31;
    axil_write(12'h008, 32'h0000000D);
    repeat(3) @(posedge clk);
    if (rct_fail === 1'b0) pass_tc(tc); else fail_tc(tc, "rct_fail not cleared by ctrl_rst_health");
    tc = 32;
    axil_read(12'h004, rdata);
    if (rdata[1] === 1'b0) pass_tc(tc); else fail_tc(tc, $sformatf("STATUS[1] still set after health reset, STATUS=0x%08X", rdata));
    tc = 33;
    axil_read(12'h008, rdata);
    if (rdata[3] === 1'b0) pass_tc(tc); else fail_tc(tc, "ctrl_rst_health should be self-clearing");
    tc = 34;
    rosc_ext = 1'b0;
    repeat(5) @(posedge clk);
    begin : rct34_loop
        integer k;
        for (k = 0; k < 40; k = k + 1) begin
            rosc_ext = ~rosc_ext;
            repeat(3) @(posedge clk);
        end
    end
    if (rct_fail === 1'b0) pass_tc(tc); else fail_tc(tc, "rct_fail re-asserted on oscillating input after reset");
    tc = 35;
    axil_read(12'h004, rdata);
    if (rdata[2] === 1'b0) pass_tc(tc); else fail_tc(tc, "apt_fail set prematurely");

    apply_reset();
    idle_axil();
    axil_write(12'h008, 32'h00000003);
    repeat(2) @(posedge clk);
    tc = 36;
    axil_read(12'h008, rdata);
    if (rdata[2:0] === 3'b011) pass_tc(tc); else fail_tc(tc, $sformatf("CTRL=0x%08X expected 0x3", rdata));
    begin : vn36
        integer k;
        rosc_ext = 1'b0;
        for (k = 0; k < 256; k = k + 1) begin
            rosc_ext = ~rosc_ext;
            repeat(3) @(posedge clk);
        end
    end
    wait_for_valid(800, timed_out);
    tc = 37;
    if (!timed_out && trng_valid === 1'b1)
        pass_tc(tc);
    else
        fail_tc(tc, "trng_valid never asserted in test_mode without bypass_vn");
    tc = 38;
    axil_read(12'h000, rdata);
    if (rdata !== 32'h0) pass_tc(tc); else fail_tc(tc, "TRNG_DATA zero in test_mode/no-bypass");
    tc = 39;
    repeat(2) @(posedge clk);
    if (trng_valid === 1'b0) pass_tc(tc); else fail_tc(tc, "trng_valid still set after TRNG_DATA read");
    tc = 40;
    begin : vn40
        integer k;
        for (k = 0; k < 256; k = k + 1) begin
            rosc_ext = ~rosc_ext;
            repeat(3) @(posedge clk);
        end
    end
    wait_for_valid(800, timed_out);
    if (!timed_out) begin
        axil_read(12'h000, rdata);
        pass_tc(tc);
    end else
        fail_tc(tc, "second word timeout in test_mode/no-bypass");

    apply_reset();
    idle_axil();
    axil_write(12'h008, 32'h00000000);
    repeat(2) @(posedge clk);
    tc = 41;
    axil_read(12'h008, rdata);
    if (rdata[2:0] === 3'b000) pass_tc(tc); else fail_tc(tc, $sformatf("CTRL=0x%08X should be 0", rdata));
    begin : dis41
        integer k;
        rosc_ext = 1'b0;
        for (k = 0; k < 256; k = k + 1) begin
            rosc_ext = ~rosc_ext;
            @(posedge clk);
        end
    end
    repeat(10) @(posedge clk);
    tc = 42;
    if (trng_valid === 1'b0) pass_tc(tc); else fail_tc(tc, "trng_valid set while TRNG disabled");
    tc = 43;
    axil_read(12'h004, rdata);
    if (rdata[0] === 1'b0) pass_tc(tc); else fail_tc(tc, "STATUS[0] set while disabled");
    tc = 44;
    axil_write(12'h008, 32'h00000007);
    begin : en44
        integer k;
        for (k = 0; k < 200; k = k + 1) begin
            rosc_ext = ~rosc_ext;
            @(posedge clk);
        end
    end
    wait_for_valid(600, timed_out);
    if (!timed_out && trng_valid === 1'b1)
        pass_tc(tc);
    else
        fail_tc(tc, "trng_valid did not assert after re-enable");
    axil_read(12'h000, rdata);
    repeat(2) @(posedge clk);
    tc = 45;
    axil_write(12'h008, 32'h00000000);
    begin : dis45
        integer k;
        for (k = 0; k < 256; k = k + 1) begin
            rosc_ext = ~rosc_ext;
            @(posedge clk);
        end
    end
    repeat(10) @(posedge clk);
    if (trng_valid === 1'b0) pass_tc(tc); else fail_tc(tc, "trng_valid asserted after re-disable");
    tc = 46;
    axil_read(12'h010, rdata);
    if (rdata === 32'hDEADBEEF) pass_tc(tc); else fail_tc(tc, $sformatf("addr 0x010 returned 0x%08X", rdata));
    tc = 47;
    axil_read(12'h100, rdata);
    if (rdata === 32'hDEADBEEF) pass_tc(tc); else fail_tc(tc, $sformatf("addr 0x100 returned 0x%08X", rdata));
    tc = 48;
    axil_read(12'h200, rdata);
    if (rdata === 32'hDEADBEEF) pass_tc(tc); else fail_tc(tc, $sformatf("addr 0x200 returned 0x%08X", rdata));
    tc = 49;
    axil_read(12'hFFC, rdata);
    if (rdata === 32'hDEADBEEF) pass_tc(tc); else fail_tc(tc, $sformatf("addr 0xFFC returned 0x%08X", rdata));
    tc = 50;
    axil_read(12'h00C, rdata);
    if (rdata === 32'hDEADBEEF) pass_tc(tc); else fail_tc(tc, $sformatf("addr 0x00C returned 0x%08X", rdata));
    $display("");
    $display("RESULT: %0d/50 passed", pass_count);
    $finish;
end
// Simulation initialisation or stimulus block
initial begin
    #2_000_000;
    $display("[FAIL] Simulation watchdog expired");
    $display("RESULT: %0d/50 passed", pass_count);
    $finish;
end

endmodule
`default_nettype wire
