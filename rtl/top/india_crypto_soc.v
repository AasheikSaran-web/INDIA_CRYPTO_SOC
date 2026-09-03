`timescale 1ns/1ps
`default_nettype none

module india_crypto_soc (

    input  logic        clk,
    input  logic        rst_n,

    input  logic        rosc_ext,

    input  logic        uart_rx,
    output logic        uart_tx,

    inout  wire         i2c_sda,
    inout  wire         i2c_scl,

    input  logic        spi_mosi,
    output logic        spi_miso,
    input  logic        spi_sck,
    output logic        spi_cs_n,

    output logic        seceng_irq
);

localparam SRAM_WORDS   = 16384;
localparam ROM_WORDS    = 8192;
localparam SRAM_AW      = 14;
localparam ROM_AW       = 13;

localparam [31:0] FW_CPU_ONLY    = 32'h0000_0001;

localparam KEY_REG_BASE  = 12'h010;
localparam IV_REG_BASE   = 12'h030;
localparam AES_CTRL_REG  = 12'h000;
localparam AES_STAT_REG  = 12'h004;

localparam PDF_CTRL_REG  = 12'h000;
localparam PDF_STAT_REG  = 12'h004;
localparam PDF_LEN_REG   = 12'h008;
localparam PDF_TAG_REG   = 12'h010;

localparam TRNG_DATA_REG = 12'h000;
localparam TRNG_STAT_REG = 12'h004;
localparam TRNG_CTRL_REG = 12'h008;

logic [31:0] cpu_imem_araddr;
logic        cpu_imem_arvalid, cpu_imem_arready;
logic [31:0] cpu_imem_rdata;
logic [1:0]  cpu_imem_rresp;
logic        cpu_imem_rvalid, cpu_imem_rready;

logic [31:0] cpu_dmem_awaddr, cpu_dmem_wdata;
logic [3:0]  cpu_dmem_wstrb;
logic        cpu_dmem_awvalid, cpu_dmem_awready;
logic        cpu_dmem_wvalid,  cpu_dmem_wready;
logic [1:0]  cpu_dmem_bresp;
logic        cpu_dmem_bvalid,  cpu_dmem_bready;
logic [31:0] cpu_dmem_araddr;
logic        cpu_dmem_arvalid, cpu_dmem_arready;
logic [31:0] cpu_dmem_rdata;
logic [1:0]  cpu_dmem_rresp;
logic        cpu_dmem_rvalid,  cpu_dmem_rready;

logic        cpu_custom_valid, cpu_custom_rd_valid;
logic [31:0] cpu_custom_instr, cpu_custom_rs1, cpu_custom_rs2, cpu_custom_rd;

`define AXIL_SLAVE_WIRES(N) \
logic [31:0] xb_s``N``_awaddr, xb_s``N``_wdata, xb_s``N``_araddr, xb_s``N``_rdata; \
logic [3:0]  xb_s``N``_wstrb; \
logic        xb_s``N``_awvalid, xb_s``N``_awready; \
logic        xb_s``N``_wvalid,  xb_s``N``_wready; \
logic [1:0]  xb_s``N``_bresp; \
logic        xb_s``N``_bvalid,  xb_s``N``_bready; \
logic        xb_s``N``_arvalid, xb_s``N``_arready; \
logic [1:0]  xb_s``N``_rresp; \
logic        xb_s``N``_rvalid,  xb_s``N``_rready

`AXIL_SLAVE_WIRES(0);
`AXIL_SLAVE_WIRES(1);
`AXIL_SLAVE_WIRES(2);
`AXIL_SLAVE_WIRES(3);
`AXIL_SLAVE_WIRES(4);
`AXIL_SLAVE_WIRES(5);
`AXIL_SLAVE_WIRES(6);
`AXIL_SLAVE_WIRES(7);

logic [31:0] dma_awaddr, dma_wdata, dma_araddr, dma_rdata;
logic [3:0]  dma_wstrb;
logic        dma_awvalid, dma_awready;
logic        dma_wvalid,  dma_wready;
logic [1:0]  dma_bresp;
logic        dma_bvalid,  dma_bready;
logic        dma_arvalid, dma_arready;
logic [1:0]  dma_rresp;
logic        dma_rvalid,  dma_rready;

logic [255:0] aes_key;
logic [127:0] aes_din;
logic [127:0] aes_dout;
logic         aes_start;
logic         aes_decrypt;
logic         aes_done;

logic [31:0]  trng_data;
logic         trng_valid;
logic         trng_rct_fail;
logic         trng_apt_fail;

logic         uart_irq;
logic         i2c_irq;
logic         spi_irq;
logic         pdf_irq;

assign seceng_irq = pdf_irq;

rv32im_core #(
    .RESET_ADDR    (32'h0000_0000)
) u_cpu (
    .clk             (clk),
    .rst_n           (rst_n),

    .timer_irq       (1'b0),
    .soft_irq        (1'b0),
    .ext_irq         (seceng_irq),

    .imem_araddr     (cpu_imem_araddr),
    .imem_arvalid    (cpu_imem_arvalid),
    .imem_arready    (cpu_imem_arready),
    .imem_rdata      (cpu_imem_rdata),
    .imem_rresp      (cpu_imem_rresp),
    .imem_rvalid     (cpu_imem_rvalid),
    .imem_rready     (cpu_imem_rready),

    .dmem_awaddr     (cpu_dmem_awaddr),
    .dmem_awvalid    (cpu_dmem_awvalid),
    .dmem_awready    (cpu_dmem_awready),
    .dmem_wdata      (cpu_dmem_wdata),
    .dmem_wstrb      (cpu_dmem_wstrb),
    .dmem_wvalid     (cpu_dmem_wvalid),
    .dmem_wready     (cpu_dmem_wready),
    .dmem_bresp      (cpu_dmem_bresp),
    .dmem_bvalid     (cpu_dmem_bvalid),
    .dmem_bready     (cpu_dmem_bready),
    .dmem_araddr     (cpu_dmem_araddr),
    .dmem_arvalid    (cpu_dmem_arvalid),
    .dmem_arready    (cpu_dmem_arready),
    .dmem_rdata      (cpu_dmem_rdata),
    .dmem_rresp      (cpu_dmem_rresp),
    .dmem_rvalid     (cpu_dmem_rvalid),
    .dmem_rready     (cpu_dmem_rready),

    .custom_valid    (cpu_custom_valid),
    .custom_instr    (cpu_custom_instr),
    .custom_rs1      (cpu_custom_rs1),
    .custom_rs2      (cpu_custom_rs2),
    .custom_rd       (cpu_custom_rd),
    .custom_rd_valid (cpu_custom_rd_valid)
);

aes_isa_ext u_aes_isa (
    .custom_valid    (cpu_custom_valid),
    .custom_instr    (cpu_custom_instr),
    .custom_rs1      (cpu_custom_rs1),
    .custom_rs2      (cpu_custom_rs2),
    .custom_rd       (cpu_custom_rd),
    .custom_rd_valid (cpu_custom_rd_valid)
);

rosc_trng u_trng (
    .clk             (clk),
    .rst_n           (rst_n),

    .rosc_ext        (rosc_ext),

    .trng_data       (trng_data),
    .trng_valid      (trng_valid),

    .rct_fail        (trng_rct_fail),
    .apt_fail        (trng_apt_fail),

    .s_axil_awaddr   (xb_s3_awaddr[11:0]),
    .s_axil_awvalid  (xb_s3_awvalid),
    .s_axil_awready  (xb_s3_awready),
    .s_axil_wdata    (xb_s3_wdata),
    .s_axil_wstrb    (xb_s3_wstrb),
    .s_axil_wvalid   (xb_s3_wvalid),
    .s_axil_wready   (xb_s3_wready),
    .s_axil_bresp    (xb_s3_bresp),
    .s_axil_bvalid   (xb_s3_bvalid),
    .s_axil_bready   (xb_s3_bready),
    .s_axil_araddr   (xb_s3_araddr[11:0]),
    .s_axil_arvalid  (xb_s3_arvalid),
    .s_axil_arready  (xb_s3_arready),
    .s_axil_rdata    (xb_s3_rdata),
    .s_axil_rresp    (xb_s3_rresp),
    .s_axil_rvalid   (xb_s3_rvalid),
    .s_axil_rready   (xb_s3_rready)
);

aes_ca_accel u_aes_ca (
    .clk             (clk),
    .rst_n           (rst_n),

    .direct_key      (aes_key),
    .direct_din      (aes_din),
    .direct_start    (aes_start),
    .direct_decrypt  (aes_decrypt),
    .direct_dout     (aes_dout),
    .direct_done     (aes_done),

    .s_axil_awaddr   (xb_s2_awaddr[11:0]),
    .s_axil_awvalid  (xb_s2_awvalid),
    .s_axil_awready  (xb_s2_awready),
    .s_axil_wdata    (xb_s2_wdata),
    .s_axil_wstrb    (xb_s2_wstrb),
    .s_axil_wvalid   (xb_s2_wvalid),
    .s_axil_wready   (xb_s2_wready),
    .s_axil_bresp    (xb_s2_bresp),
    .s_axil_bvalid   (xb_s2_bvalid),
    .s_axil_bready   (xb_s2_bready),
    .s_axil_araddr   (xb_s2_araddr[11:0]),
    .s_axil_arvalid  (xb_s2_arvalid),
    .s_axil_arready  (xb_s2_arready),
    .s_axil_rdata    (xb_s2_rdata),
    .s_axil_rresp    (xb_s2_rresp),
    .s_axil_rvalid   (xb_s2_rvalid),
    .s_axil_rready   (xb_s2_rready)
);

india_pdf_engine u_pdf (
    .clk             (clk),
    .rst_n           (rst_n),

    .s_awaddr        (xb_s4_awaddr[11:0]),
    .s_awvalid       (xb_s4_awvalid),
    .s_awready       (xb_s4_awready),
    .s_wdata         (xb_s4_wdata),
    .s_wstrb         (xb_s4_wstrb),
    .s_wvalid        (xb_s4_wvalid),
    .s_wready        (xb_s4_wready),
    .s_bresp         (xb_s4_bresp),
    .s_bvalid        (xb_s4_bvalid),
    .s_bready        (xb_s4_bready),
    .s_araddr        (xb_s4_araddr[11:0]),
    .s_arvalid       (xb_s4_arvalid),
    .s_arready       (xb_s4_arready),
    .s_rdata         (xb_s4_rdata),
    .s_rresp         (xb_s4_rresp),
    .s_rvalid        (xb_s4_rvalid),
    .s_rready        (xb_s4_rready),

    .m_awaddr        (dma_awaddr),
    .m_awvalid       (dma_awvalid),
    .m_awready       (dma_awready),
    .m_wdata         (dma_wdata),
    .m_wstrb         (dma_wstrb),
    .m_wvalid        (dma_wvalid),
    .m_wready        (dma_wready),
    .m_bresp         (dma_bresp),
    .m_bvalid        (dma_bvalid),
    .m_bready        (dma_bready),
    .m_araddr        (dma_araddr),
    .m_arvalid       (dma_arvalid),
    .m_arready       (dma_arready),
    .m_rdata         (dma_rdata),
    .m_rresp         (dma_rresp),
    .m_rvalid        (dma_rvalid),
    .m_rready        (dma_rready),

    .cipher_key      (aes_key),
    .cipher_din      (aes_din),
    .cipher_start    (aes_start),
    .cipher_decrypt  (aes_decrypt),
    .cipher_dout     (aes_dout),
    .cipher_done     (aes_done),

    .trng_data       (trng_data),
    .trng_valid      (trng_valid),

    .irq             (pdf_irq)
);

pulp_uart_wrap u_uart (
    .clk             (clk),
    .rst_n           (rst_n),
    .uart_rx         (uart_rx),
    .uart_tx         (uart_tx),
    .irq             (uart_irq),

    .s_awaddr        (xb_s5_awaddr[11:0]),
    .s_awvalid       (xb_s5_awvalid),
    .s_awready       (xb_s5_awready),
    .s_wdata         (xb_s5_wdata),
    .s_wstrb         (xb_s5_wstrb),
    .s_wvalid        (xb_s5_wvalid),
    .s_wready        (xb_s5_wready),
    .s_bresp         (xb_s5_bresp),
    .s_bvalid        (xb_s5_bvalid),
    .s_bready        (xb_s5_bready),
    .s_araddr        (xb_s5_araddr[11:0]),
    .s_arvalid       (xb_s5_arvalid),
    .s_arready       (xb_s5_arready),
    .s_rdata         (xb_s5_rdata),
    .s_rresp         (xb_s5_rresp),
    .s_rvalid        (xb_s5_rvalid),
    .s_rready        (xb_s5_rready)
);

pulp_i2c_wrap u_i2c (
    .clk             (clk),
    .rst_n           (rst_n),
    .i2c_sda         (i2c_sda),
    .i2c_scl         (i2c_scl),
    .irq             (i2c_irq),

    .s_awaddr        (xb_s6_awaddr[11:0]),
    .s_awvalid       (xb_s6_awvalid),
    .s_awready       (xb_s6_awready),
    .s_wdata         (xb_s6_wdata),
    .s_wstrb         (xb_s6_wstrb),
    .s_wvalid        (xb_s6_wvalid),
    .s_wready        (xb_s6_wready),
    .s_bresp         (xb_s6_bresp),
    .s_bvalid        (xb_s6_bvalid),
    .s_bready        (xb_s6_bready),
    .s_araddr        (xb_s6_araddr[11:0]),
    .s_arvalid       (xb_s6_arvalid),
    .s_arready       (xb_s6_arready),
    .s_rdata         (xb_s6_rdata),
    .s_rresp         (xb_s6_rresp),
    .s_rvalid        (xb_s6_rvalid),
    .s_rready        (xb_s6_rready)
);

pulp_spi_wrap u_spi (
    .clk             (clk),
    .rst_n           (rst_n),
    .spi_sck         (spi_sck),
    .spi_mosi        (spi_mosi),
    .spi_miso        (spi_miso),
    .spi_cs_n        (spi_cs_n),
    .irq             (spi_irq),

    .s_awaddr        (xb_s7_awaddr[11:0]),
    .s_awvalid       (xb_s7_awvalid),
    .s_awready       (xb_s7_awready),
    .s_wdata         (xb_s7_wdata),
    .s_wstrb         (xb_s7_wstrb),
    .s_wvalid        (xb_s7_wvalid),
    .s_wready        (xb_s7_wready),
    .s_bresp         (xb_s7_bresp),
    .s_bvalid        (xb_s7_bvalid),
    .s_bready        (xb_s7_bready),
    .s_araddr        (xb_s7_araddr[11:0]),
    .s_arvalid       (xb_s7_arvalid),
    .s_arready       (xb_s7_arready),
    .s_rdata         (xb_s7_rdata),
    .s_rresp         (xb_s7_rresp),
    .s_rvalid        (xb_s7_rvalid),
    .s_rready        (xb_s7_rready)
);

axi_lite_xbar u_xbar (
    .clk        (clk),
    .rst_n      (rst_n),

    .m0_awaddr  (cpu_dmem_awaddr),  .m0_awvalid (cpu_dmem_awvalid),
    .m0_awready (cpu_dmem_awready),
    .m0_wdata   (cpu_dmem_wdata),   .m0_wstrb   (cpu_dmem_wstrb),
    .m0_wvalid  (cpu_dmem_wvalid),  .m0_wready  (cpu_dmem_wready),
    .m0_bresp   (cpu_dmem_bresp),   .m0_bvalid  (cpu_dmem_bvalid),
    .m0_bready  (cpu_dmem_bready),
    .m0_araddr  (cpu_dmem_araddr),  .m0_arvalid (cpu_dmem_arvalid),
    .m0_arready (cpu_dmem_arready),
    .m0_rdata   (cpu_dmem_rdata),   .m0_rresp   (cpu_dmem_rresp),
    .m0_rvalid  (cpu_dmem_rvalid),  .m0_rready  (cpu_dmem_rready),

    .m1_awaddr  (dma_awaddr),  .m1_awvalid (dma_awvalid),
    .m1_awready (dma_awready),
    .m1_wdata   (dma_wdata),   .m1_wstrb   (dma_wstrb),
    .m1_wvalid  (dma_wvalid),  .m1_wready  (dma_wready),
    .m1_bresp   (dma_bresp),   .m1_bvalid  (dma_bvalid),
    .m1_bready  (dma_bready),
    .m1_araddr  (dma_araddr),  .m1_arvalid (dma_arvalid),
    .m1_arready (dma_arready),
    .m1_rdata   (dma_rdata),   .m1_rresp   (dma_rresp),
    .m1_rvalid  (dma_rvalid),  .m1_rready  (dma_rready),

    .s0_awaddr(xb_s0_awaddr),.s0_awvalid(xb_s0_awvalid),.s0_awready(xb_s0_awready),
    .s0_wdata(xb_s0_wdata),  .s0_wstrb(xb_s0_wstrb),    .s0_wvalid(xb_s0_wvalid),
    .s0_wready(xb_s0_wready),.s0_bresp(xb_s0_bresp),    .s0_bvalid(xb_s0_bvalid),
    .s0_bready(xb_s0_bready),.s0_araddr(xb_s0_araddr),  .s0_arvalid(xb_s0_arvalid),
    .s0_arready(xb_s0_arready),.s0_rdata(xb_s0_rdata),  .s0_rresp(xb_s0_rresp),
    .s0_rvalid(xb_s0_rvalid),.s0_rready(xb_s0_rready),

    .s1_awaddr(xb_s1_awaddr),.s1_awvalid(xb_s1_awvalid),.s1_awready(xb_s1_awready),
    .s1_wdata(xb_s1_wdata),  .s1_wstrb(xb_s1_wstrb),    .s1_wvalid(xb_s1_wvalid),
    .s1_wready(xb_s1_wready),.s1_bresp(xb_s1_bresp),    .s1_bvalid(xb_s1_bvalid),
    .s1_bready(xb_s1_bready),.s1_araddr(xb_s1_araddr),  .s1_arvalid(xb_s1_arvalid),
    .s1_arready(xb_s1_arready),.s1_rdata(xb_s1_rdata),  .s1_rresp(xb_s1_rresp),
    .s1_rvalid(xb_s1_rvalid),.s1_rready(xb_s1_rready),

    .s2_awaddr(xb_s2_awaddr),.s2_awvalid(xb_s2_awvalid),.s2_awready(xb_s2_awready),
    .s2_wdata(xb_s2_wdata),  .s2_wstrb(xb_s2_wstrb),    .s2_wvalid(xb_s2_wvalid),
    .s2_wready(xb_s2_wready),.s2_bresp(xb_s2_bresp),    .s2_bvalid(xb_s2_bvalid),
    .s2_bready(xb_s2_bready),.s2_araddr(xb_s2_araddr),  .s2_arvalid(xb_s2_arvalid),
    .s2_arready(xb_s2_arready),.s2_rdata(xb_s2_rdata),  .s2_rresp(xb_s2_rresp),
    .s2_rvalid(xb_s2_rvalid),.s2_rready(xb_s2_rready),

    .s3_awaddr(xb_s3_awaddr),.s3_awvalid(xb_s3_awvalid),.s3_awready(xb_s3_awready),
    .s3_wdata(xb_s3_wdata),  .s3_wstrb(xb_s3_wstrb),    .s3_wvalid(xb_s3_wvalid),
    .s3_wready(xb_s3_wready),.s3_bresp(xb_s3_bresp),    .s3_bvalid(xb_s3_bvalid),
    .s3_bready(xb_s3_bready),.s3_araddr(xb_s3_araddr),  .s3_arvalid(xb_s3_arvalid),
    .s3_arready(xb_s3_arready),.s3_rdata(xb_s3_rdata),  .s3_rresp(xb_s3_rresp),
    .s3_rvalid(xb_s3_rvalid),.s3_rready(xb_s3_rready),

    .s4_awaddr(xb_s4_awaddr),.s4_awvalid(xb_s4_awvalid),.s4_awready(xb_s4_awready),
    .s4_wdata(xb_s4_wdata),  .s4_wstrb(xb_s4_wstrb),    .s4_wvalid(xb_s4_wvalid),
    .s4_wready(xb_s4_wready),.s4_bresp(xb_s4_bresp),    .s4_bvalid(xb_s4_bvalid),
    .s4_bready(xb_s4_bready),.s4_araddr(xb_s4_araddr),  .s4_arvalid(xb_s4_arvalid),
    .s4_arready(xb_s4_arready),.s4_rdata(xb_s4_rdata),  .s4_rresp(xb_s4_rresp),
    .s4_rvalid(xb_s4_rvalid),.s4_rready(xb_s4_rready),

    .s5_awaddr(xb_s5_awaddr),.s5_awvalid(xb_s5_awvalid),.s5_awready(xb_s5_awready),
    .s5_wdata(xb_s5_wdata),  .s5_wstrb(xb_s5_wstrb),    .s5_wvalid(xb_s5_wvalid),
    .s5_wready(xb_s5_wready),.s5_bresp(xb_s5_bresp),    .s5_bvalid(xb_s5_bvalid),
    .s5_bready(xb_s5_bready),.s5_araddr(xb_s5_araddr),  .s5_arvalid(xb_s5_arvalid),
    .s5_arready(xb_s5_arready),.s5_rdata(xb_s5_rdata),  .s5_rresp(xb_s5_rresp),
    .s5_rvalid(xb_s5_rvalid),.s5_rready(xb_s5_rready),

    .s6_awaddr(xb_s6_awaddr),.s6_awvalid(xb_s6_awvalid),.s6_awready(xb_s6_awready),
    .s6_wdata(xb_s6_wdata),  .s6_wstrb(xb_s6_wstrb),    .s6_wvalid(xb_s6_wvalid),
    .s6_wready(xb_s6_wready),.s6_bresp(xb_s6_bresp),    .s6_bvalid(xb_s6_bvalid),
    .s6_bready(xb_s6_bready),.s6_araddr(xb_s6_araddr),  .s6_arvalid(xb_s6_arvalid),
    .s6_arready(xb_s6_arready),.s6_rdata(xb_s6_rdata),  .s6_rresp(xb_s6_rresp),
    .s6_rvalid(xb_s6_rvalid),.s6_rready(xb_s6_rready),

    .s7_awaddr(xb_s7_awaddr),.s7_awvalid(xb_s7_awvalid),.s7_awready(xb_s7_awready),
    .s7_wdata(xb_s7_wdata),  .s7_wstrb(xb_s7_wstrb),    .s7_wvalid(xb_s7_wvalid),
    .s7_wready(xb_s7_wready),.s7_bresp(xb_s7_bresp),    .s7_bvalid(xb_s7_bvalid),
    .s7_bready(xb_s7_bready),.s7_araddr(xb_s7_araddr),  .s7_arvalid(xb_s7_arvalid),
    .s7_arready(xb_s7_arready),.s7_rdata(xb_s7_rdata),  .s7_rresp(xb_s7_rresp),
    .s7_rvalid(xb_s7_rvalid),.s7_rready(xb_s7_rready)
);

logic        rom_rd_pending;

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        xb_s0_arready <= 1'b0;
        xb_s0_rvalid  <= 1'b0;
        xb_s0_rdata   <= 32'h0;
        xb_s0_rresp   <= 2'b00;
        rom_rd_pending <= 1'b0;
        xb_s0_awready <= 1'b0;
        xb_s0_wready  <= 1'b0;
        xb_s0_bvalid  <= 1'b0;
        xb_s0_bresp   <= 2'b10;
    end else begin
        xb_s0_arready <= 1'b0;
        xb_s0_awready <= 1'b0;
        xb_s0_wready  <= 1'b0;

        if (xb_s0_arvalid && !rom_rd_pending) begin
            xb_s0_arready  <= 1'b1;
            rom_rd_pending <= 1'b1;
        end
        if (rom_rd_pending) begin
            xb_s0_rvalid <= 1'b1;

            xb_s0_rdata  <= 32'h0000_0013;
            xb_s0_rresp  <= 2'b00;
            if (xb_s0_rready) begin
                xb_s0_rvalid   <= 1'b0;
                rom_rd_pending <= 1'b0;
            end
        end

        if (xb_s0_awvalid) xb_s0_awready <= 1'b1;
        if (xb_s0_wvalid)  xb_s0_wready  <= 1'b1;
        if (xb_s0_awvalid && xb_s0_wvalid) begin
            xb_s0_bvalid <= 1'b1;
            xb_s0_bresp  <= 2'b10;
        end
        if (xb_s0_bvalid && xb_s0_bready) xb_s0_bvalid <= 1'b0;
    end
end

logic [31:0] sram [0:SRAM_WORDS-1];

wire [31:0] sram_pb_merge;

assign sram_pb_merge[ 7: 0] = pb_wr_wstrb[0] ? pb_wr_wdata[ 7: 0] : sram[pb_wr_word_addr][ 7: 0];
assign sram_pb_merge[15: 8] = pb_wr_wstrb[1] ? pb_wr_wdata[15: 8] : sram[pb_wr_word_addr][15: 8];
assign sram_pb_merge[23:16] = pb_wr_wstrb[2] ? pb_wr_wdata[23:16] : sram[pb_wr_word_addr][23:16];
assign sram_pb_merge[31:24] = pb_wr_wstrb[3] ? pb_wr_wdata[31:24] : sram[pb_wr_word_addr][31:24];

logic pa_rd_pending;

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cpu_imem_arready <= 1'b0;
        cpu_imem_rvalid  <= 1'b0;
        cpu_imem_rdata   <= 32'h0;
        cpu_imem_rresp   <= 2'b00;
        pa_rd_pending    <= 1'b0;
    end else begin
        cpu_imem_arready <= 1'b0;
        if (cpu_imem_arvalid && !pa_rd_pending) begin
            cpu_imem_arready <= 1'b1;
            pa_rd_pending    <= 1'b1;
        end
        if (pa_rd_pending) begin
            cpu_imem_rvalid <= 1'b1;

            cpu_imem_rdata  <= sram[cpu_imem_araddr[15:2]];
            cpu_imem_rresp  <= 2'b00;
            if (cpu_imem_rready) begin
                cpu_imem_rvalid <= 1'b0;
                pa_rd_pending   <= 1'b0;
            end
        end
    end
end

logic        pb_rd_pending;
logic        pb_wr_aw_done, pb_wr_w_done;
logic [13:0] pb_wr_word_addr;
logic [31:0] pb_wr_wdata;
logic [3:0]  pb_wr_wstrb;

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        xb_s1_awready   <= 1'b0;
        xb_s1_wready    <= 1'b0;
        xb_s1_bvalid    <= 1'b0;
        xb_s1_bresp     <= 2'b00;
        xb_s1_arready   <= 1'b0;
        xb_s1_rvalid    <= 1'b0;
        xb_s1_rdata     <= 32'h0;
        xb_s1_rresp     <= 2'b00;
        pb_rd_pending   <= 1'b0;
        pb_wr_aw_done   <= 1'b0;
        pb_wr_w_done    <= 1'b0;
        pb_wr_word_addr <= 14'h0;
        pb_wr_wdata     <= 32'h0;
        pb_wr_wstrb     <= 4'h0;
    end else begin
        xb_s1_awready <= 1'b0;
        xb_s1_wready  <= 1'b0;
        xb_s1_arready <= 1'b0;

        if (xb_s1_awvalid && !pb_wr_aw_done) begin
            xb_s1_awready   <= 1'b1;
            pb_wr_aw_done   <= 1'b1;

            pb_wr_word_addr <= xb_s1_awaddr[15:2];
        end
        if (xb_s1_wvalid && !pb_wr_w_done) begin
            xb_s1_wready <= 1'b1;
            pb_wr_w_done <= 1'b1;
            pb_wr_wdata  <= xb_s1_wdata;
            pb_wr_wstrb  <= xb_s1_wstrb;
        end
        if (pb_wr_aw_done && pb_wr_w_done) begin

            sram[pb_wr_word_addr] <= sram_pb_merge;
            xb_s1_bvalid  <= 1'b1;
            xb_s1_bresp   <= 2'b00;
            pb_wr_aw_done <= 1'b0;
            pb_wr_w_done  <= 1'b0;
        end
        if (xb_s1_bvalid && xb_s1_bready) xb_s1_bvalid <= 1'b0;

        if (xb_s1_arvalid && !pb_rd_pending) begin
            xb_s1_arready <= 1'b1;
            pb_rd_pending <= 1'b1;
        end
        if (pb_rd_pending) begin
            xb_s1_rvalid <= 1'b1;

            xb_s1_rdata  <= sram[xb_s1_araddr[15:2]];
            xb_s1_rresp  <= 2'b00;
            if (xb_s1_rready) begin
                xb_s1_rvalid  <= 1'b0;
                pb_rd_pending <= 1'b0;
            end
        end
    end
end

initial begin
    $display("[INDIA_CRYPTO_SOC] uart_irq/i2c_irq/spi_irq available for poll.");
end

logic _unused_irqs;
assign _unused_irqs = uart_irq | i2c_irq | spi_irq;

endmodule
