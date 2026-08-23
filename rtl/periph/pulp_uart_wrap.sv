// ============================================================================
// pulp_uart_wrap.sv
// Security wrapper around the PULP apb_uart peripheral.
//
// Features:
//   1. AXI-Lite -> APB bridge (axil_to_apb)
//   2. apb_uart instantiation (PULP)
//   3. secure_mode lockout:
//        - Blocks APB writes (TX register cannot be modified)
//        - Gates SOUT high (UART idle/mark) while locked
//        - ORs bit[5] (LOCKED) into PRDATA when reading STATUS register
//   4. 3-stage glitch filter on uart_rx input
// ============================================================================

module pulp_uart_wrap (
    input  logic        clk,
    input  logic        rst_n,
    input  logic        secure_mode,    // 1 = security lockout active

    // ----------------------------------------------------------------
    // AXI-Lite Slave Interface (12-bit addr, 32-bit data)
    // ----------------------------------------------------------------
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

    // ----------------------------------------------------------------
    // Physical UART
    // ----------------------------------------------------------------
    input  logic        uart_rx,
    output logic        uart_tx,
    output logic        irq
);

    // ----------------------------------------------------------------
    // APB bus wires between bridge and apb_uart
    // ----------------------------------------------------------------
    logic [11:0] apb_paddr;
    logic        apb_psel;
    logic        apb_penable;
    logic        apb_pwrite;
    logic [31:0] apb_pwdata;
    logic [31:0] apb_prdata;
    logic        apb_pready;
    logic        apb_pslverr;

    // ----------------------------------------------------------------
    // Security: gate pwrite when secure_mode is asserted
    //   secure_mode=1 makes all APB transactions look like reads,
    //   preventing any TX register update.
    // ----------------------------------------------------------------
    logic        pwrite_gated;
    assign pwrite_gated = apb_pwrite & ~secure_mode;

    // ----------------------------------------------------------------
    // Security: override PRDATA to set LOCKED bit (bit 5) of STATUS
    //   register when secure_mode=1.
    //   apb_uart STATUS register is at word offset 1 -> paddr[4:2]==3'b001
    // ----------------------------------------------------------------
    logic [31:0] prdata_muxed;
    logic        reading_status;
    assign reading_status = (apb_paddr[4:2] == 3'b001);

    always_comb begin
        prdata_muxed = apb_prdata;
        if (secure_mode && reading_status)
            prdata_muxed[5] = 1'b1;   // OR in LOCKED bit
    end

    // ----------------------------------------------------------------
    // RX glitch filter: 3-stage shift register majority vote
    //   accepted as 0: all three stages are 0
    //   accepted as 1: all three stages are 1
    //   else: hold previous value
    // ----------------------------------------------------------------
    logic [2:0] rx_sr;
    logic       filtered_rx_r;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rx_sr       <= 3'b111;   // UART idle = high
            filtered_rx_r <= 1'b1;
        end else begin
            rx_sr <= {rx_sr[1:0], uart_rx};
            if (rx_sr == 3'b000)
                filtered_rx_r <= 1'b0;
            else if (rx_sr == 3'b111)
                filtered_rx_r <= 1'b1;
            // else hold previous
        end
    end

    // ----------------------------------------------------------------
    // SOUT gating: UART TX idles HIGH (mark state).
    //   When secure_mode=1 force TX high regardless of peripheral output.
    // ----------------------------------------------------------------
    logic sout_from_uart;

    assign uart_tx = secure_mode ? 1'b1 : sout_from_uart;

    // ----------------------------------------------------------------
    // AXI-Lite to APB bridge instantiation
    // ----------------------------------------------------------------
    axil_to_apb u_bridge (
        .clk        (clk),
        .rst_n      (rst_n),

        // AXI-Lite slave
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

        // APB master
        .paddr      (apb_paddr),
        .psel       (apb_psel),
        .penable    (apb_penable),
        .pwrite     (apb_pwrite),
        .pwdata     (apb_pwdata),
        .prdata     (prdata_muxed),   // feed security-modified PRDATA back
        .pready     (apb_pready),
        .pslverr    (apb_pslverr)
    );

    // ----------------------------------------------------------------
    // apb_uart instantiation (PULP)
    //
    // PADDR[2:0] = word offset; apb_uart has 8 word-addressable registers.
    // Bridge uses 12-bit byte addresses, so word offset = paddr[4:2].
    // ----------------------------------------------------------------
    apb_uart u_uart (
        .CLK        (clk),
        .RSTN       (rst_n),

        // APB
        .PSEL       (apb_psel),
        .PENABLE    (apb_penable),
        .PWRITE     (pwrite_gated),      // security-gated write
        .PADDR      (apb_paddr[4:2]),    // 3-bit word address
        .PWDATA     (apb_pwdata),
        .PRDATA     (apb_prdata),
        .PREADY     (apb_pready),
        .PSLVERR    (apb_pslverr),

        // Interrupt
        .INT        (irq),

        // Physical UART
        .SIN        (filtered_rx_r),     // glitch-filtered RX
        .SOUT       (sout_from_uart),    // gated by uart_tx assign above

        // Modem control outputs — leave unconnected
        .OUT1N      (),
        .OUT2N      (),
        .RTSN       (),
        .DTRN       (),

        // Modem control inputs — tie to inactive (asserted = low for these
        // active-low signals, i.e. tie high to mean "not asserted / always ready")
        .CTSN       (1'b1),
        .DSRN       (1'b1),
        .DCDN       (1'b1),
        .RIN        (1'b1)
    );

endmodule
// ============================================================================
// End of pulp_uart_wrap.sv
// ============================================================================
