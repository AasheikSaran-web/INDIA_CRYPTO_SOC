module pulp_i2c_wrap (
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

    inout  wire         i2c_sda,
    inout  wire         i2c_scl,
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

    logic scl_pad_i, scl_pad_o, scl_padoen_o;
    logic sda_pad_i, sda_pad_o, sda_padoen_o;

    assign i2c_sda  = !sda_padoen_o ? sda_pad_o : 1'bz;
    assign i2c_scl  = !scl_padoen_o ? scl_pad_o : 1'bz;
    assign sda_pad_i = i2c_sda;
    assign scl_pad_i = i2c_scl;

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

    apb_i2c #(
        .APB_ADDR_WIDTH (12)
    ) u_i2c (
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

        .interrupt_o    (irq),

        .scl_pad_i      (scl_pad_i),
        .scl_pad_o      (scl_pad_o),
        .scl_padoen_o   (scl_padoen_o),

        .sda_pad_i      (sda_pad_i),
        .sda_pad_o      (sda_pad_o),
        .sda_padoen_o   (sda_padoen_o)
    );

endmodule
