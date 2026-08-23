// ============================================================================
// axil_to_apb.sv
// AXI-Lite Slave to APB Master Bridge
//
// FSM: IDLE -> SETUP -> ENABLE -> RESP
// Write takes priority over read when both arrive simultaneously.
// APB is single-channel so reads and writes are serialised.
// ============================================================================

module axil_to_apb (
    input  logic        clk,
    input  logic        rst_n,

    // ----------------------------------------------------------------
    // AXI-Lite Slave Interface
    // ----------------------------------------------------------------
    // Write address channel
    input  logic [11:0] s_awaddr,
    input  logic        s_awvalid,
    output logic        s_awready,

    // Write data channel
    input  logic [31:0] s_wdata,
    input  logic [3:0]  s_wstrb,
    input  logic        s_wvalid,
    output logic        s_wready,

    // Write response channel
    output logic [1:0]  s_bresp,
    output logic        s_bvalid,
    input  logic        s_bready,

    // Read address channel
    input  logic [11:0] s_araddr,
    input  logic        s_arvalid,
    output logic        s_arready,

    // Read data channel
    output logic [31:0] s_rdata,
    output logic [1:0]  s_rresp,
    output logic        s_rvalid,
    input  logic        s_rready,

    // ----------------------------------------------------------------
    // APB Master Interface
    // ----------------------------------------------------------------
    output logic [11:0] paddr,
    output logic        psel,
    output logic        penable,
    output logic        pwrite,
    output logic [31:0] pwdata,
    input  logic [31:0] prdata,
    input  logic        pready,
    input  logic        pslverr
);

    // ----------------------------------------------------------------
    // FSM encoding
    // ----------------------------------------------------------------
    typedef enum logic [1:0] {
        IDLE   = 2'b00,
        SETUP  = 2'b01,
        ENABLE = 2'b10,
        RESP   = 2'b11
    } state_t;

    state_t state_r, state_next;

    // ----------------------------------------------------------------
    // Internal registers to latch AXI transaction
    // ----------------------------------------------------------------
    logic [11:0] lat_addr_r;
    logic [31:0] lat_wdata_r;
    logic [3:0]  lat_wstrb_r;
    logic        lat_write_r;   // 1 = write, 0 = read

    // Captured APB response
    logic [31:0] rdata_r;
    logic        slverr_r;

    // Pending flags (set when AXI AW/AR arrive before we process them)
    logic        wr_pending_r;
    logic        rd_pending_r;

    // ----------------------------------------------------------------
    // Capture incoming AXI transactions into pending registers
    // Accepted whenever we assert ready in IDLE or whenever the channel
    // fires. We assert s_awready/s_wready/s_arready only in IDLE to
    // keep the handshake simple (one outstanding transaction).
    // ----------------------------------------------------------------

    // Write address accepted
    logic aw_fire;
    logic w_fire;
    logic ar_fire;
    assign aw_fire = s_awvalid & s_awready;
    assign w_fire  = s_wvalid  & s_wready;
    assign ar_fire = s_arvalid & s_arready;

    // Readies: only accept in IDLE state, and only when we don't already
    // have a pending transaction of that type queued.
    assign s_awready = (state_r == IDLE) & ~wr_pending_r;
    assign s_wready  = (state_r == IDLE) & ~wr_pending_r;
    assign s_arready = (state_r == IDLE) & ~rd_pending_r & ~(s_awvalid & s_wvalid);

    // ----------------------------------------------------------------
    // Pending registers
    // ----------------------------------------------------------------
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wr_pending_r  <= 1'b0;
            rd_pending_r  <= 1'b0;
            lat_addr_r    <= 12'h0;
            lat_wdata_r   <= 32'h0;
            lat_wstrb_r   <= 4'h0;
            lat_write_r   <= 1'b0;
        end else begin
            // Capture write request (need both AW and W to fire)
            if (aw_fire && w_fire) begin
                lat_addr_r   <= s_awaddr;
                lat_wdata_r  <= s_wdata;
                lat_wstrb_r  <= s_wstrb;
                lat_write_r  <= 1'b1;
                wr_pending_r <= 1'b1;
            end

            // Capture read request
            if (ar_fire) begin
                lat_addr_r   <= s_araddr;
                lat_write_r  <= 1'b0;
                rd_pending_r <= 1'b1;
            end

            // Clear pending flags when we start processing them (move IDLE->SETUP)
            if (state_r == IDLE && state_next == SETUP) begin
                if (lat_write_r || wr_pending_r) begin
                    wr_pending_r <= 1'b0;
                end else begin
                    rd_pending_r <= 1'b0;
                end
            end
        end
    end

    // ----------------------------------------------------------------
    // FSM — next-state logic
    // ----------------------------------------------------------------
    always_comb begin
        state_next = state_r;
        case (state_r)
            IDLE: begin
                if (wr_pending_r || rd_pending_r)
                    state_next = SETUP;
            end
            SETUP: begin
                state_next = ENABLE;
            end
            ENABLE: begin
                if (pready)
                    state_next = RESP;
            end
            RESP: begin
                // Wait for AXI handshake
                if (lat_write_r) begin
                    if (s_bvalid && s_bready)
                        state_next = IDLE;
                end else begin
                    if (s_rvalid && s_rready)
                        state_next = IDLE;
                end
            end
            default: state_next = IDLE;
        endcase
    end

    // ----------------------------------------------------------------
    // FSM — state register
    // ----------------------------------------------------------------
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) state_r <= IDLE;
        else        state_r <= state_next;
    end

    // ----------------------------------------------------------------
    // Latch APB response on ENABLE->RESP transition
    // ----------------------------------------------------------------
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rdata_r  <= 32'h0;
            slverr_r <= 1'b0;
        end else if (state_r == ENABLE && pready) begin
            rdata_r  <= prdata;
            slverr_r <= pslverr;
        end
    end

    // ----------------------------------------------------------------
    // APB outputs
    // ----------------------------------------------------------------
    always_comb begin
        psel    = 1'b0;
        penable = 1'b0;
        paddr   = lat_addr_r;
        pwrite  = lat_write_r;
        pwdata  = lat_wdata_r;

        case (state_r)
            SETUP: begin
                psel    = 1'b1;
                penable = 1'b0;
            end
            ENABLE: begin
                psel    = 1'b1;
                penable = 1'b1;
            end
            default: begin
                psel    = 1'b0;
                penable = 1'b0;
            end
        endcase
    end

    // ----------------------------------------------------------------
    // AXI response outputs
    // ----------------------------------------------------------------
    // Write response
    assign s_bvalid = (state_r == RESP) &&  lat_write_r;
    assign s_bresp  = slverr_r ? 2'b10 : 2'b00;  // SLVERR or OKAY

    // Read response
    assign s_rvalid = (state_r == RESP) && !lat_write_r;
    assign s_rdata  = rdata_r;
    assign s_rresp  = slverr_r ? 2'b10 : 2'b00;

endmodule
// ============================================================================
// End of axil_to_apb.sv
// ============================================================================
