module pulp_uart_wrap (
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

    input  logic        uart_rx,
    output logic        uart_tx,
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

    logic sout_from_uart;
    assign uart_tx = sout_from_uart;

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

    apb_uart u_uart (
        .CLK        (clk),
        .RSTN       (rst_n),

        .PSEL       (apb_psel),
        .PENABLE    (apb_penable),
        .PWRITE     (apb_pwrite),
        .PADDR      (apb_paddr[4:2]),
        .PWDATA     (apb_pwdata),
        .PRDATA     (apb_prdata),
        .PREADY     (apb_pready),
        .PSLVERR    (apb_pslverr),

        .INT        (irq),

        .SIN        (uart_rx),
        .SOUT       (sout_from_uart),

        .OUT1N      (),
        .OUT2N      (),
        .RTSN       (),
        .DTRN       (),

        .CTSN       (1'b1),
        .DSRN       (1'b1),
        .DCDN       (1'b1),
        .RIN        (1'b1)
    );

endmodule
