module pulp_i2c_wrap #(
    parameter int unsigned BUS_STUCK_THRESH = 24'd500_000
) (
    input  logic        clk,
    input  logic        rst_n,
    input  logic        secure_mode,

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

    logic [6:0]  whitelist_addr [3:0];
    logic        whitelist_en;
    logic        clr_stuck;

    logic [23:0] stuck_cnt_r;
    logic        bus_stuck_r;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stuck_cnt_r <= 24'h0;
            bus_stuck_r <= 1'b0;
        end else begin
            if (clr_stuck)
                bus_stuck_r <= 1'b0;

            if (secure_mode || scl_pad_i) begin
                stuck_cnt_r <= 24'h0;
            end else begin
                if (!bus_stuck_r) begin
                    if (stuck_cnt_r >= BUS_STUCK_THRESH[23:0])
                        bus_stuck_r <= 1'b1;
                    else
                        stuck_cnt_r <= stuck_cnt_r + 24'h1;
                end
            end
        end
    end

    logic axil_local_wr;
    assign axil_local_wr = s_awvalid && (s_awaddr == 12'hF0 || s_awaddr == 12'hF4);

    logic axil_local_rd;
    assign axil_local_rd = s_arvalid && (s_araddr == 12'hF0 || s_araddr == 12'hF4);

    typedef enum logic [1:0] {
        LWR_IDLE  = 2'b00,
        LWR_WDATA = 2'b01,
        LWR_BRESP = 2'b10
    } lwr_state_t;

    lwr_state_t lwr_state_r, lwr_state_next;
    logic [11:0] lwr_addr_r;
    logic [31:0] lwr_wdata_r;

    logic clr_stuck_r;
    assign clr_stuck = clr_stuck_r;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            lwr_state_r    <= LWR_IDLE;
            lwr_addr_r     <= 12'h0;
            lwr_wdata_r    <= 32'h0;
            whitelist_en   <= 1'b0;
            clr_stuck_r    <= 1'b0;
            for (int i = 0; i < 4; i++) whitelist_addr[i] <= 7'h0;
        end else begin
            clr_stuck_r <= 1'b0;
            lwr_state_r <= lwr_state_next;

            if (lwr_state_r == LWR_IDLE && axil_local_wr && s_awvalid)
                lwr_addr_r <= s_awaddr;

            if (lwr_state_r == LWR_WDATA && s_wvalid) begin
                lwr_wdata_r <= s_wdata;
                if (lwr_addr_r == 12'hF0) begin

                    whitelist_addr[s_wdata[9:8]] <= s_wdata[6:0];
                end else if (lwr_addr_r == 12'hF4) begin
                    whitelist_en <= s_wdata[0];
                    if (s_wdata[1]) clr_stuck_r <= 1'b1;
                end
            end
        end
    end

    always_comb begin
        lwr_state_next = lwr_state_r;
        case (lwr_state_r)
            LWR_IDLE:  if (axil_local_wr && s_awvalid) lwr_state_next = LWR_WDATA;
            LWR_WDATA: if (s_wvalid)                   lwr_state_next = LWR_BRESP;
            LWR_BRESP: if (s_bready)                   lwr_state_next = LWR_IDLE;
            default:                                    lwr_state_next = LWR_IDLE;
        endcase
    end

    typedef enum logic [1:0] {
        LRD_IDLE = 2'b00,
        LRD_DATA = 2'b01
    } lrd_state_t;

    lrd_state_t lrd_state_r, lrd_state_next;
    logic [31:0] lrd_rdata_r;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            lrd_state_r  <= LRD_IDLE;
            lrd_rdata_r  <= 32'h0;
        end else begin
            lrd_state_r <= lrd_state_next;
            if (lrd_state_r == LRD_IDLE && axil_local_rd) begin
                if (s_araddr == 12'hF4)
                    lrd_rdata_r <= {30'h0, bus_stuck_r, whitelist_en};
                else
                    lrd_rdata_r <= 32'h0;
            end
        end
    end

    always_comb begin
        lrd_state_next = lrd_state_r;
        case (lrd_state_r)
            LRD_IDLE: if (axil_local_rd && s_arvalid) lrd_state_next = LRD_DATA;
            LRD_DATA: if (s_rready)                   lrd_state_next = LRD_IDLE;
            default:                                   lrd_state_next = LRD_IDLE;
        endcase
    end

    logic        fwd_awvalid, fwd_awready;
    logic        fwd_wvalid,  fwd_wready;
    logic [1:0]  fwd_bresp;
    logic        fwd_bvalid;
    logic        fwd_arvalid, fwd_arready;
    logic [31:0] fwd_rdata;
    logic [1:0]  fwd_rresp;
    logic        fwd_rvalid;

    assign fwd_awvalid = s_awvalid & ~axil_local_wr;
    assign fwd_wvalid  = s_wvalid  & (lwr_state_r == LWR_IDLE);
    assign fwd_arvalid = s_arvalid & ~axil_local_rd;

    assign s_awready = axil_local_wr  ? (lwr_state_r == LWR_IDLE) : fwd_awready;

    assign s_wready  = (lwr_state_r == LWR_WDATA) ? 1'b1 : fwd_wready;

    assign s_bvalid  = (lwr_state_r == LWR_BRESP) ? 1'b1 : fwd_bvalid;
    assign s_bresp   = (lwr_state_r == LWR_BRESP) ? 2'b00 : fwd_bresp;

    assign s_arready = axil_local_rd  ? (lrd_state_r == LRD_IDLE) : fwd_arready;

    assign s_rvalid  = (lrd_state_r == LRD_DATA) ? 1'b1 : fwd_rvalid;
    assign s_rdata   = (lrd_state_r == LRD_DATA) ? lrd_rdata_r : fwd_rdata;
    assign s_rresp   = (lrd_state_r == LRD_DATA) ? 2'b00 : fwd_rresp;

    localparam logic [11:0] I2C_ADDR_REG = 12'h004;

    logic [6:0]  captured_i2c_addr;
    logic        addr_blocked;
    logic        addr_in_whitelist;
    logic [3:0]  wl_match;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) captured_i2c_addr <= 7'h0;
        else if (apb_psel && apb_penable && apb_pwrite &&
                 apb_paddr == I2C_ADDR_REG)
            captured_i2c_addr <= apb_pwdata[6:0];
    end

    always_comb begin
        wl_match = 4'b0;
        for (int k = 0; k < 4; k++)
            wl_match[k] = (captured_i2c_addr == whitelist_addr[k]);
        addr_in_whitelist = |wl_match;
    end

    assign addr_blocked = whitelist_en && !addr_in_whitelist &&
                          apb_psel && apb_penable && apb_pwrite &&
                          (apb_paddr == I2C_ADDR_REG);

    logic        i2c_psel_gated;
    logic        i2c_penable_gated;
    logic [31:0] i2c_prdata_raw;
    logic        i2c_pready_raw;
    logic        i2c_pslverr_raw;

    assign i2c_psel_gated    = apb_psel    & ~addr_blocked & ~bus_stuck_r;
    assign i2c_penable_gated = apb_penable & ~addr_blocked & ~bus_stuck_r;

    assign apb_pready  = addr_blocked ? 1'b1 :
                         bus_stuck_r  ? 1'b1 : i2c_pready_raw;
    assign apb_pslverr = addr_blocked ? 1'b1 :
                         bus_stuck_r  ? 1'b1 : i2c_pslverr_raw;
    assign apb_prdata  = i2c_prdata_raw;

    logic bus_safe;
    assign bus_safe = ~secure_mode & ~bus_stuck_r;

    assign i2c_sda = (!sda_padoen_o && bus_safe) ? sda_pad_o : 1'bz;
    assign i2c_scl = (!scl_padoen_o && bus_safe) ? scl_pad_o : 1'bz;

    assign sda_pad_i = i2c_sda;
    assign scl_pad_i = i2c_scl;

    axil_to_apb u_bridge (
        .clk        (clk),
        .rst_n      (rst_n),

        .s_awaddr   (s_awaddr),
        .s_awvalid  (fwd_awvalid),
        .s_awready  (fwd_awready),

        .s_wdata    (s_wdata),
        .s_wstrb    (s_wstrb),
        .s_wvalid   (fwd_wvalid),
        .s_wready   (fwd_wready),

        .s_bresp    (fwd_bresp),
        .s_bvalid   (fwd_bvalid),
        .s_bready   (s_bready),

        .s_araddr   (s_araddr),
        .s_arvalid  (fwd_arvalid),
        .s_arready  (fwd_arready),

        .s_rdata    (fwd_rdata),
        .s_rresp    (fwd_rresp),
        .s_rvalid   (fwd_rvalid),
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
        .PSEL           (i2c_psel_gated),
        .PENABLE        (i2c_penable_gated),
        .PRDATA         (i2c_prdata_raw),
        .PREADY         (i2c_pready_raw),
        .PSLVERR        (i2c_pslverr_raw),

        .interrupt_o    (irq),

        .scl_pad_i      (scl_pad_i),
        .scl_pad_o      (scl_pad_o),
        .scl_padoen_o   (scl_padoen_o),

        .sda_pad_i      (sda_pad_i),
        .sda_pad_o      (sda_pad_o),
        .sda_padoen_o   (sda_padoen_o)
    );

endmodule
