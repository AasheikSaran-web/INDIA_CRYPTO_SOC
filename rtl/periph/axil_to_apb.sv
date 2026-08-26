module axil_to_apb (
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

    output logic [11:0] paddr,
    output logic        psel,
    output logic        penable,
    output logic        pwrite,
    output logic [31:0] pwdata,
    input  logic [31:0] prdata,
    input  logic        pready,
    input  logic        pslverr
);

    typedef enum logic [1:0] {
        IDLE   = 2'b00,
        SETUP  = 2'b01,
        ENABLE = 2'b10,
        RESP   = 2'b11
    } state_t;

    state_t state_r, state_next;

    logic [11:0] lat_addr_r;
    logic [31:0] lat_wdata_r;
    logic [3:0]  lat_wstrb_r;
    logic        lat_write_r;

    logic [31:0] rdata_r;
    logic        slverr_r;

    logic        wr_pending_r;
    logic        rd_pending_r;

    logic aw_fire;
    logic w_fire;
    logic ar_fire;
    assign aw_fire = s_awvalid & s_awready;
    assign w_fire  = s_wvalid  & s_wready;
    assign ar_fire = s_arvalid & s_arready;

    assign s_awready = (state_r == IDLE) & ~wr_pending_r;
    assign s_wready  = (state_r == IDLE) & ~wr_pending_r;
    assign s_arready = (state_r == IDLE) & ~rd_pending_r & ~(s_awvalid & s_wvalid);

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wr_pending_r  <= 1'b0;
            rd_pending_r  <= 1'b0;
            lat_addr_r    <= 12'h0;
            lat_wdata_r   <= 32'h0;
            lat_wstrb_r   <= 4'h0;
            lat_write_r   <= 1'b0;
        end else begin

            if (aw_fire && w_fire) begin
                lat_addr_r   <= s_awaddr;
                lat_wdata_r  <= s_wdata;
                lat_wstrb_r  <= s_wstrb;
                lat_write_r  <= 1'b1;
                wr_pending_r <= 1'b1;
            end

            if (ar_fire) begin
                lat_addr_r   <= s_araddr;
                lat_write_r  <= 1'b0;
                rd_pending_r <= 1'b1;
            end

            if (state_r == IDLE && state_next == SETUP) begin
                if (lat_write_r || wr_pending_r) begin
                    wr_pending_r <= 1'b0;
                end else begin
                    rd_pending_r <= 1'b0;
                end
            end
        end
    end

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

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) state_r <= IDLE;
        else        state_r <= state_next;
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rdata_r  <= 32'h0;
            slverr_r <= 1'b0;
        end else if (state_r == ENABLE && pready) begin
            rdata_r  <= prdata;
            slverr_r <= pslverr;
        end
    end

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

    assign s_bvalid = (state_r == RESP) &&  lat_write_r;
    assign s_bresp  = slverr_r ? 2'b10 : 2'b00;

    assign s_rvalid = (state_r == RESP) && !lat_write_r;
    assign s_rdata  = rdata_r;
    assign s_rresp  = slverr_r ? 2'b10 : 2'b00;

endmodule
