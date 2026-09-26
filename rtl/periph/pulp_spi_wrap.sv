module pulp_spi_wrap #(
    parameter int BUFFER_DEPTH    = 8,
    parameter int APB_ADDR_WIDTH  = 12
) (
    input  logic        clk,
    input  logic        rst_n,

    input  logic [11:0] s_awaddr,
    input  logic        s_awvalid,
    output logic        s_awready,

    input  logic [31:0] s_wdata,
    input  logic [3:0]  s_wstrb,
    input  logic        s_wvalid,
    output logic        s_wready,

    output logic [1:0]  s_bresp,
    output logic        s_bvalid,
    input  logic        s_bready,

    input  logic [11:0] s_araddr,
    input  logic        s_arvalid,
    output logic        s_arready,

    output logic [31:0] s_rdata,
    output logic [1:0]  s_rresp,
    output logic        s_rvalid,
    input  logic        s_rready,

    output logic        spi_sck,
    output logic        spi_mosi,
    input  logic        spi_miso,
    output logic        spi_cs_n,
    output logic        irq
);

    logic [11:0] apb_paddr;
    logic        apb_psel;
    logic        apb_penable;
    logic        apb_pwrite;
    logic [31:0] apb_pwdata;
    logic [31:0] apb_prdata;
    logic        apb_pready;
    logic        apb_pslverr;

    logic [1:0]  spi_mode_nc;
    logic [3:0]  spi_csn_raw;
    logic [1:0]  events_raw;

    assign irq      = events_raw[1];
    assign spi_cs_n = spi_csn_raw[0];

    axil_to_apb u_bridge (
        .clk        (clk),
        .rst_n      (rst_n),

        .s_awaddr   (s_awaddr),
        .s_awvalid  (s_awvalid),
        .s_awready  (s_awready),

        .s_wdata    (s_wdata),
        .s_wstrb    (s_wstrb),
        .s_wvalid   (s_wvalid),
        .s_wready   (s_wready),

        .s_bresp    (s_bresp),
        .s_bvalid   (s_bvalid),
        .s_bready   (s_bready),

        .s_araddr   (s_araddr),
        .s_arvalid  (s_arvalid),
        .s_arready  (s_arready),

        .s_rdata    (s_rdata),
        .s_rresp    (s_rresp),
        .s_rvalid   (s_rvalid),
        .s_rready   (s_rready),

        .paddr      (apb_paddr),
        .psel       (apb_psel),
        .penable    (apb_penable),
        .pwrite     (apb_pwrite),
        .pwdata     (apb_pwdata),
        .prdata     (apb_prdata),
        .pready     (apb_pready),
        .pslverr    (apb_pslverr)
    );

    apb_spi_master #(
        .BUFFER_DEPTH   (BUFFER_DEPTH),
        .APB_ADDR_WIDTH (APB_ADDR_WIDTH)
    ) u_spi (
        .HCLK           (clk),
        .HRESETn        (rst_n),

        .PADDR          (apb_paddr),
        .PWDATA         (apb_pwdata),
        .PWRITE         (apb_pwrite),
        .PSEL           (apb_psel),
        .PENABLE        (apb_penable),
        .PRDATA         (apb_prdata),
        .PREADY         (apb_pready),
        .PSLVERR        (apb_pslverr),

        .events_o       (events_raw),

        .spi_clk        (spi_sck),
        .spi_csn0       (spi_csn_raw[0]),
        .spi_csn1       (spi_csn_raw[1]),
        .spi_csn2       (spi_csn_raw[2]),
        .spi_csn3       (spi_csn_raw[3]),
        .spi_mode       (spi_mode_nc),

        .spi_sdo0       (spi_mosi),
        .spi_sdo1       (),
        .spi_sdo2       (),
        .spi_sdo3       (),

        .spi_sdi0       (spi_miso),
        .spi_sdi1       (1'b0),
        .spi_sdi2       (1'b0),
        .spi_sdi3       (1'b0)
    );

endmodule
