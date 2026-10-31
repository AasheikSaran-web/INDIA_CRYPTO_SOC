`timescale 1ns/1ps

// tb_india_pdf_engine: hardware module definition
module tb_india_pdf_engine;
reg clk;
reg rst_n;

// Simulation initialisation or stimulus block
initial clk = 1'b0;
// Combinational logic output computation
always #5 clk = ~clk;
reg  [11:0] s_awaddr;
reg         s_awvalid;
wire        s_awready;
reg  [31:0] s_wdata;
reg  [3:0]  s_wstrb;
reg         s_wvalid;
wire        s_wready;
wire [1:0]  s_bresp;
wire        s_bvalid;
reg         s_bready;
reg  [11:0] s_araddr;
reg         s_arvalid;
wire        s_arready;
wire [31:0] s_rdata;
wire [1:0]  s_rresp;
wire        s_rvalid;
reg         s_rready;
wire [31:0] m_araddr;
wire        m_arvalid;
reg         m_arready;
reg  [31:0] m_rdata;
reg  [1:0]  m_rresp;
reg         m_rvalid;
wire        m_rready;
wire [31:0] m_awaddr;
wire        m_awvalid;
reg         m_awready;
wire [31:0] m_wdata;
wire [3:0]  m_wstrb;
wire        m_wvalid;
reg         m_wready;
reg  [1:0]  m_bresp;
reg         m_bvalid;
wire        m_bready;
wire [255:0] cipher_key;
wire [127:0] cipher_din;
wire         cipher_start;
wire         cipher_decrypt;
reg  [127:0] cipher_dout;
reg          cipher_done;
reg  [31:0] trng_data;
reg         trng_valid;
wire irq;
india_pdf_engine dut (
    .clk          (clk),
    .rst_n        (rst_n),

    .s_awaddr     (s_awaddr),
    .s_awvalid    (s_awvalid),
    .s_awready    (s_awready),
    .s_wdata      (s_wdata),
    .s_wstrb      (s_wstrb),
    .s_wvalid     (s_wvalid),
    .s_wready     (s_wready),
    .s_bresp      (s_bresp),
    .s_bvalid     (s_bvalid),
    .s_bready     (s_bready),
    .s_araddr     (s_araddr),
    .s_arvalid    (s_arvalid),
    .s_arready    (s_arready),
    .s_rdata      (s_rdata),
    .s_rresp      (s_rresp),
    .s_rvalid     (s_rvalid),
    .s_rready     (s_rready),

    .m_araddr     (m_araddr),
    .m_arvalid    (m_arvalid),
    .m_arready    (m_arready),
    .m_rdata      (m_rdata),
    .m_rresp      (m_rresp),
    .m_rvalid     (m_rvalid),
    .m_rready     (m_rready),

    .m_awaddr     (m_awaddr),
    .m_awvalid    (m_awvalid),
    .m_awready    (m_awready),
    .m_wdata      (m_wdata),
    .m_wstrb      (m_wstrb),
    .m_wvalid     (m_wvalid),
    .m_wready     (m_wready),
    .m_bresp      (m_bresp),
    .m_bvalid     (m_bvalid),
    .m_bready     (m_bready),

    .cipher_key   (cipher_key),
    .cipher_din   (cipher_din),
    .cipher_start (cipher_start),
    .cipher_decrypt(cipher_decrypt),
    .cipher_dout  (cipher_dout),
    .cipher_done  (cipher_done),

    .trng_data    (trng_data),
    .trng_valid   (trng_valid),

    .irq          (irq)
);
// Simulation initialisation or stimulus block
initial begin
    m_arready = 1'b1;
    m_rdata   = 32'h0;
    m_rresp   = 2'b00;
    m_rvalid  = 1'b0;
    m_awready = 1'b1;
    m_wready  = 1'b1;
    m_bresp   = 2'b00;
    m_bvalid  = 1'b0;
    cipher_dout = 128'h0;
    cipher_done = 1'b0;
    trng_data   = 32'h0;
    trng_valid  = 1'b0;
end
integer pass_count;
integer fail_count;
reg [31:0] rdata_cap;
// Simulation initialisation or stimulus block
initial begin
    #2_000_000;
    $display("[TIMEOUT] Watchdog expired after 2ms");
    $finish;
end
// axil_write: reusable simulation task
task axil_write;
    input [11:0] addr;
    input [31:0] data;
    begin
        @(negedge clk);
        s_awaddr  = addr;
        s_awvalid = 1'b1;
        s_wvalid  = 1'b0;
        s_bready  = 1'b0;
        @(posedge clk);
        while (!s_awready) @(posedge clk);
        @(negedge clk);
        s_awvalid = 1'b0;
        s_wdata  = data;
        s_wstrb  = 4'hF;
        s_wvalid = 1'b1;
        @(posedge clk);
        while (!s_wready) @(posedge clk);
        @(negedge clk);
        s_wvalid = 1'b0;
        @(posedge clk);
        while (!s_bvalid) @(posedge clk);
        @(negedge clk);
        s_bready = 1'b1;
        @(posedge clk);
        @(negedge clk);
        s_bready = 1'b0;
    end
endtask
// axil_read: reusable simulation task
task axil_read;
    input [11:0] addr;
    begin
        @(negedge clk);
        s_araddr  = addr;
        s_arvalid = 1'b1;
        s_rready  = 1'b0;
        @(posedge clk);
        while (!s_arready) @(posedge clk);
        rdata_cap = s_rdata;
        @(negedge clk);
        s_arvalid = 1'b0;
        s_rready  = 1'b1;
        @(posedge clk);
        while (s_rvalid) @(posedge clk);
        @(negedge clk);
        s_rready = 1'b0;
    end
endtask
// check_reg: reusable simulation task
task check_reg;
    input integer       tcnum;
    input [127:0]       label;
    input [31:0]        got;
    input [31:0]        exp;
    begin
        if (got === exp) begin
            $display("[PASS] TC%02d  got=0x%08h  exp=0x%08h", tcnum, got, exp);
            pass_count = pass_count + 1;
        end else begin
            $display("[FAIL] TC%02d  got=0x%08h  exp=0x%08h", tcnum, got, exp);
            fail_count = fail_count + 1;
        end
    end
endtask
// Simulation initialisation or stimulus block
initial begin
    rst_n     = 1'b0;
    s_awaddr  = 12'h0;
    s_awvalid = 1'b0;
    s_wdata   = 32'h0;
    s_wstrb   = 4'hF;
    s_wvalid  = 1'b0;
    s_bready  = 1'b0;
    s_araddr  = 12'h0;
    s_arvalid = 1'b0;
    s_rready  = 1'b0;
    pass_count = 0;
    fail_count = 0;
    repeat(4) @(posedge clk);
    @(negedge clk);
    rst_n = 1'b1;
    repeat(2) @(posedge clk);
    axil_read(12'h08);
    check_reg(1, "STATUS reset    ", rdata_cap, 32'h0000_0000);
    axil_read(12'h00);
    check_reg(2, "CTRL reset      ", rdata_cap, 32'h0000_0000);
    axil_read(12'h04);
    check_reg(3, "APP_MODE reset  ", rdata_cap, 32'h0000_0000);
    axil_read(12'h0C);
    check_reg(4, "SRC_ADDR reset  ", rdata_cap, 32'h0000_0000);
    axil_read(12'h10);
    check_reg(5, "DST_ADDR reset  ", rdata_cap, 32'h0000_0000);
    axil_write(12'h0C, 32'hDEAD_0001);
    axil_read (12'h0C);
    check_reg(6, "SRC_ADDR RW     ", rdata_cap, 32'hDEAD_0001);
    axil_write(12'h10, 32'hBEEF_0002);
    axil_read (12'h10);
    check_reg(7, "DST_ADDR RW     ", rdata_cap, 32'hBEEF_0002);
    axil_write(12'h14, 32'h0000_1000);
    axil_read (12'h14);
    check_reg(8, "PDF_LEN RW      ", rdata_cap, 32'h0000_1000);
    axil_write(12'h60, 32'h6789_ABCD);
    axil_read (12'h60);
    check_reg(9, "TIMESTAMP RW    ", rdata_cap, 32'h6789_ABCD);
    axil_write(12'h04, 32'h0000_0003);
    axil_read (12'h04);
    check_reg(10, "APP_MODE RW     ", rdata_cap, 32'h0000_0003);
    axil_write(12'h28, 32'hAABBCCDD);
    axil_read (12'h28);
    check_reg(11, "KEY[7] 0x28     ", rdata_cap, 32'hAABBCCDD);
    axil_write(12'h2C, 32'h11223344);
    axil_read (12'h2C);
    check_reg(12, "KEY[6] 0x2C     ", rdata_cap, 32'h11223344);
    axil_write(12'h30, 32'hCAFEBABE);
    axil_read (12'h30);
    check_reg(13, "KEY[5] 0x30     ", rdata_cap, 32'hCAFEBABE);
    axil_write(12'h38, 32'h5A5A5A5A);
    axil_read (12'h38);
    check_reg(14, "KEY[3] 0x38     ", rdata_cap, 32'h5A5A5A5A);
    axil_write(12'h44, 32'h0000_FFFF);
    axil_read (12'h44);
    check_reg(15, "KEY[0] 0x44     ", rdata_cap, 32'h0000_FFFF);
    axil_write(12'h18, 32'h1234_5678);
    axil_read (12'h18);
    check_reg(16, "NONCE[3] 0x18   ", rdata_cap, 32'h1234_5678);
    axil_write(12'h1C, 32'h9ABC_DEF0);
    axil_read (12'h1C);
    check_reg(17, "NONCE[2] 0x1C   ", rdata_cap, 32'h9ABC_DEF0);
    axil_write(12'h20, 32'hFEDC_BA98);
    axil_read (12'h20);
    check_reg(18, "NONCE[1] 0x20   ", rdata_cap, 32'hFEDC_BA98);
    axil_write(12'h24, 32'h7654_3210);
    axil_read (12'h24);
    check_reg(19, "NONCE[0] 0x24   ", rdata_cap, 32'h7654_3210);
    axil_write(12'h14, 32'hABCD_EF00);
    axil_read (12'h14);
    check_reg(20, "PDF_LEN rewrt   ", rdata_cap, 32'hABCD_EF00);
    axil_write(12'h58, 32'hDEAD_CAFE);
    axil_read (12'h58);
    check_reg(21, "DOC_ID_LO RW    ", rdata_cap, 32'hDEAD_CAFE);
    axil_write(12'h5C, 32'h0000_1234);
    axil_read (12'h5C);
    check_reg(22, "DOC_ID_HI RW    ", rdata_cap, 32'h0000_1234);
    axil_write(12'h64, 32'h0000_0002);
    axil_read (12'h64);
    check_reg(23, "AUTH_LEVEL RW   ", rdata_cap, 32'h0000_0002);
    axil_write(12'h00, 32'h0000_0004);
    axil_read (12'h00);
    check_reg(24, "IRQ_EN bit      ", rdata_cap, 32'h0000_0004);
    axil_write(12'h00, 32'h0000_0006);
    axil_read (12'h00);
    check_reg(25, "DECRYPT_MODE bit", rdata_cap, 32'h0000_0006);
    axil_read(12'h94);
    check_reg(26, "ADH_HDR_EXP ro  ", rdata_cap, 32'h6D78_3F3C);
    axil_write(12'h8C, 32'h6D78_3F3C);
    axil_read (12'h8C);
    check_reg(27, "ADH_HDR WR bk   ", rdata_cap, 32'h6D78_3F3C);
    axil_read(12'h90);
    check_reg(28, "ADH_STATUS id_ok", rdata_cap[3], 1'b1);
    axil_write(12'h8C, 32'hDEAD_BEEF);
    axil_read (12'h90);
    check_reg(29, "ADH_STATUS no id", rdata_cap[3], 1'b0);
    axil_write(12'h8C, 32'h6D78_3F3C);
    axil_read (12'h90);
    check_reg(30, "ADH_STATUS id rs", rdata_cap[3], 1'b1);
    axil_write(12'h80, 32'h0000_2000);
    axil_write(12'h84, 32'h0000_5555);
    axil_write(12'h88, 32'h0000_5554);
    axil_read(12'h80);
    check_reg(31, "ADH digits0 RB  ", rdata_cap, 32'h0000_2000);
    axil_read(12'h84);
    check_reg(32, "ADH digits1 RB  ", rdata_cap, 32'h0000_5555);
    axil_read(12'h88);
    check_reg(33, "ADH digits2 RB  ", rdata_cap, 32'h0000_5554);
    axil_read(12'h90);
    check_reg(34, "verhoeff_ok=1   ", rdata_cap[1], 1'b1);
    axil_read(12'h90);
    check_reg(35, "all_valid=1     ", rdata_cap[0], 1'b1);

    axil_write(12'h88, 32'h0000_5555);
    axil_read(12'h88);
    check_reg(36, "ADH digs2 corpt ", rdata_cap, 32'h0000_5555);
    axil_read(12'h90);
    check_reg(37, "verhoeff_ok=0   ", rdata_cap[1], 1'b0);
    axil_read(12'h90);
    check_reg(38, "all_valid=0 bad ", rdata_cap[0], 1'b0);
    axil_read(12'h90);
    check_reg(39, "fdig_ok still 1 ", rdata_cap[2], 1'b1);
    axil_read(12'h90);
    check_reg(40, "id_ok still 1   ", rdata_cap[3], 1'b1);

    axil_write(12'h80, 32'h0000_0000);
    axil_write(12'h84, 32'h0000_5555);
    axil_write(12'h88, 32'h0000_5554);
    axil_read(12'h80);
    check_reg(41, "ADH digs0 0-led ", rdata_cap, 32'h0000_0000);
    axil_read(12'h90);
    check_reg(42, "fdig_ok=0 d11=0 ", rdata_cap[2], 1'b0);
    axil_read(12'h90);
    check_reg(43, "all_valid=0 fdig", rdata_cap[0], 1'b0);
    axil_read(12'h90);
    check_reg(44, "id_ok unaffected", rdata_cap[3], 1'b1);
    axil_write(12'h80, 32'h0000_2000);
    axil_write(12'h88, 32'h0000_5554);
    axil_read (12'h90);
    check_reg(45, "fdig_ok recovers", rdata_cap[2], 1'b1);
    axil_read(12'h0A0);
    check_reg(46, "default 0xA0    ", rdata_cap, 32'hDEAD_BEEF);
    axil_read(12'h0B4);
    check_reg(47, "default 0xB4    ", rdata_cap, 32'hDEAD_BEEF);
    axil_read(12'h0C8);
    check_reg(48, "default 0xC8    ", rdata_cap, 32'hDEAD_BEEF);
    axil_read(12'h0FC);
    check_reg(49, "default 0xFC    ", rdata_cap, 32'hDEAD_BEEF);
    axil_read(12'h0D0);
    check_reg(50, "default 0xD0    ", rdata_cap, 32'hDEAD_BEEF);
    $display("RESULT: %0d/50 passed, %0d failed", pass_count, fail_count);
    $finish;
end

endmodule
