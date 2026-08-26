module pulp_spi_wrap #(
    parameter int BUFFER_DEPTH    = 8,
    parameter int APB_ADDR_WIDTH  = 12
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

    logic [7:0]  max_len_r;
    logic        cs_lock_r;

    localparam logic [11:0] ADDR_MAX_LEN  = 12'hF8;
    localparam logic [11:0] ADDR_CS_LOCK  = 12'hFC;

    logic axil_local_wr;
    logic axil_local_rd;
    assign axil_local_wr = s_awvalid & ((s_awaddr == ADDR_MAX_LEN) | (s_awaddr == ADDR_CS_LOCK));
    assign axil_local_rd = s_arvalid & ((s_araddr == ADDR_MAX_LEN) | (s_araddr == ADDR_CS_LOCK));

    typedef enum logic [1:0] {
        LWR_IDLE  = 2'b00,
        LWR_WDATA = 2'b01,
        LWR_BRESP = 2'b10
    } lwr_state_t;

    lwr_state_t lwr_state_r, lwr_state_next;
    logic [11:0] lwr_addr_r;

    always_comb begin
        lwr_state_next = lwr_state_r;
        case (lwr_state_r)
            LWR_IDLE:  if (axil_local_wr && s_awvalid) lwr_state_next = LWR_WDATA;
            LWR_WDATA: if (s_wvalid)                   lwr_state_next = LWR_BRESP;
            LWR_BRESP: if (s_bready)                   lwr_state_next = LWR_IDLE;
            default:                                    lwr_state_next = LWR_IDLE;
        endcase
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            lwr_state_r <= LWR_IDLE;
            lwr_addr_r  <= 12'h0;
            max_len_r   <= 8'hFF;
            cs_lock_r   <= 1'b0;
        end else begin
            lwr_state_r <= lwr_state_next;

            if (lwr_state_r == LWR_IDLE && axil_local_wr && s_awvalid)
                lwr_addr_r <= s_awaddr;

            if (lwr_state_r == LWR_WDATA && s_wvalid) begin
                if (lwr_addr_r == ADDR_MAX_LEN)
                    max_len_r <= s_wdata[7:0];
                else if (lwr_addr_r == ADDR_CS_LOCK)

                    cs_lock_r <= cs_lock_r | s_wdata[0];
            end
        end
    end

    typedef enum logic [1:0] {
        LRD_IDLE = 2'b00,
        LRD_DATA = 2'b01
    } lrd_state_t;

    lrd_state_t lrd_state_r, lrd_state_next;
    logic [31:0] lrd_rdata_r;

    always_comb begin
        lrd_state_next = lrd_state_r;
        case (lrd_state_r)
            LRD_IDLE: if (axil_local_rd && s_arvalid) lrd_state_next = LRD_DATA;
            LRD_DATA: if (s_rready)                   lrd_state_next = LRD_IDLE;
            default:                                   lrd_state_next = LRD_IDLE;
        endcase
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            lrd_state_r <= LRD_IDLE;
            lrd_rdata_r <= 32'h0;
        end else begin
            lrd_state_r <= lrd_state_next;
            if (lrd_state_r == LRD_IDLE && axil_local_rd && s_arvalid) begin
                if (s_araddr == ADDR_MAX_LEN)
                    lrd_rdata_r <= {24'h0, max_len_r};
                else if (s_araddr == ADDR_CS_LOCK)
                    lrd_rdata_r <= {31'h0, cs_lock_r};
                else
                    lrd_rdata_r <= 32'h0;
            end
        end
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

    localparam logic [11:0] SPI_LEN_REG = 12'h008;

    logic [31:0] pwdata_gated;
    always_comb begin
        pwdata_gated = apb_pwdata;
        if (apb_pwrite && apb_psel && apb_penable &&
            apb_paddr == SPI_LEN_REG) begin
            if (apb_pwdata[7:0] > max_len_r)
                pwdata_gated[7:0] = max_len_r;
        end
    end

    logic        spi_sck_raw;
    logic        spi_mosi_raw;
    logic [3:0]  spi_csn_raw;
    logic [1:0]  spi_mode_nc;
    logic [1:0]  events_raw;

    assign irq = events_raw[1];

    always_comb begin
        if (secure_mode) begin
            spi_cs_n  = 1'b1;
            spi_sck   = 1'b0;
            spi_mosi  = 1'b0;
        end else begin
            spi_cs_n  = spi_csn_raw[0] | cs_lock_r;
            spi_sck   = spi_sck_raw;
            spi_mosi  = spi_mosi_raw;
        end
    end

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

    apb_spi_master #(
        .BUFFER_DEPTH   (BUFFER_DEPTH),
        .APB_ADDR_WIDTH (APB_ADDR_WIDTH)
    ) u_spi (
        .HCLK           (clk),
        .HRESETn        (rst_n),

        .PADDR          (apb_paddr),
        .PWDATA         (pwdata_gated),
        .PWRITE         (apb_pwrite),
        .PSEL           (apb_psel),
        .PENABLE        (apb_penable),
        .PRDATA         (apb_prdata),
        .PREADY         (apb_pready),
        .PSLVERR        (apb_pslverr),

        .events_o       (events_raw),

        .spi_clk        (spi_sck_raw),
        .spi_csn0       (spi_csn_raw[0]),
        .spi_csn1       (spi_csn_raw[1]),
        .spi_csn2       (spi_csn_raw[2]),
        .spi_csn3       (spi_csn_raw[3]),
        .spi_mode       (spi_mode_nc),

        .spi_sdo0       (spi_mosi_raw),
        .spi_sdo1       (),
        .spi_sdo2       (),
        .spi_sdo3       (),

        .spi_sdi0       (spi_miso),
        .spi_sdi1       (1'b0),
        .spi_sdi2       (1'b0),
        .spi_sdi3       (1'b0)
    );

endmodule
