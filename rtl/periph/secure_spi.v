`timescale 1ns/1ps

module secure_spi #(
    parameter FIFO_DEPTH = 16,
    parameter FIFO_AW    = 4
) (
    input  wire        clk,
    input  wire        rst_n,

    input  wire        secure_mode,

    output reg         sck,
    output reg         mosi,
    input  wire        miso,
    output reg  [3:0]  cs_n,

    output wire        irq,

    input  wire [31:0] s_axil_awaddr,
    input  wire        s_axil_awvalid,
    output reg         s_axil_awready,
    input  wire [31:0] s_axil_wdata,
    input  wire [3:0]  s_axil_wstrb,
    input  wire        s_axil_wvalid,
    output reg         s_axil_wready,
    output reg  [1:0]  s_axil_bresp,
    output reg         s_axil_bvalid,
    input  wire        s_axil_bready,
    input  wire [31:0] s_axil_araddr,
    input  wire        s_axil_arvalid,
    output reg         s_axil_arready,
    output reg  [31:0] s_axil_rdata,
    output reg  [1:0]  s_axil_rresp,
    output reg         s_axil_rvalid,
    input  wire        s_axil_rready
);

    localparam ADDR_DATA    = 5'h00;
    localparam ADDR_STATUS  = 5'h04;
    localparam ADDR_CTRL    = 5'h08;
    localparam ADDR_CS_SEL  = 5'h0C;
    localparam ADDR_DIVIDER = 5'h10;
    localparam ADDR_MAX_LEN = 5'h14;
    localparam ADDR_CS_LOCK = 5'h18;
    localparam ADDR_ALERT   = 5'h1C;

    localparam SPI_IDLE    = 3'd0;
    localparam SPI_CS_SETUP= 3'd1;
    localparam SPI_SHIFT   = 3'd2;
    localparam SPI_CS_HOLD = 3'd3;
    localparam SPI_CS_DES  = 3'd4;
    localparam SPI_DONE    = 3'd5;

    reg [3:0]  ctrl_reg;
    reg [3:0]  cs_sel_reg;
    reg [15:0] divider_reg;
    reg [7:0]  max_len_reg;
    reg [3:0]  cs_lock_reg;
    reg        overflow_alert;
    reg        cs_guard_viol;

    wire [15:0] eff_div = (divider_reg < 16'd2) ? 16'd2 : divider_reg;

    reg [7:0]  tx_fifo [0:FIFO_DEPTH-1];
    reg [FIFO_AW:0] tx_wr_ptr, tx_rd_ptr;
    wire tx_full  = (tx_wr_ptr[FIFO_AW] != tx_rd_ptr[FIFO_AW]) &&
                    (tx_wr_ptr[FIFO_AW-1:0] == tx_rd_ptr[FIFO_AW-1:0]);
    wire tx_empty = (tx_wr_ptr == tx_rd_ptr);

    reg [7:0]  rx_fifo [0:FIFO_DEPTH-1];
    reg [FIFO_AW:0] rx_wr_ptr, rx_rd_ptr;
    wire rx_full  = (rx_wr_ptr[FIFO_AW] != rx_rd_ptr[FIFO_AW]) &&
                    (rx_wr_ptr[FIFO_AW-1:0] == rx_rd_ptr[FIFO_AW-1:0]);
    wire rx_empty = (rx_wr_ptr == rx_rd_ptr);

    reg [2:0]  spi_state;
    reg [3:0]  bit_cnt;
    reg [7:0]  tx_shift;
    reg [7:0]  rx_shift;
    reg [15:0] clk_cnt;
    reg        clk_phase;
    reg [7:0]  byte_cnt;
    reg        busy;
    reg        underrun_flag;

    wire cpol = ctrl_reg[1];
    wire cpha = ctrl_reg[2];
    wire loopback = ctrl_reg[3];

    wire miso_in = loopback ? mosi : miso;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            spi_state   <= SPI_IDLE;
            sck         <= 1'b0;
            mosi        <= 1'b0;
            cs_n        <= 4'hF;
            bit_cnt     <= 4'd0;
            tx_shift    <= 8'd0;
            rx_shift    <= 8'd0;
            clk_cnt     <= 16'd0;
            clk_phase   <= 1'b0;
            byte_cnt    <= 8'd0;
            busy        <= 1'b0;
            underrun_flag <= 1'b0;
            tx_rd_ptr   <= {(FIFO_AW+1){1'b0}};
            rx_wr_ptr   <= {(FIFO_AW+1){1'b0}};
        end else begin

            if (secure_mode) begin
                cs_n      <= 4'hF;
                sck       <= cpol;
                spi_state <= SPI_IDLE;
                busy      <= 1'b0;
            end

            clk_cnt <= clk_cnt + 1'b1;

            case (spi_state)

                SPI_IDLE: begin
                    sck   <= cpol;
                    mosi  <= 1'b0;
                    cs_n  <= 4'hF;
                    busy  <= 1'b0;
                    if (ctrl_reg[0] && !secure_mode) begin

                        if ((cs_sel_reg != 4'b0000) &&
                            ((cs_sel_reg & cs_lock_reg) == 4'b0000) &&
                            (cs_sel_reg[3:0] & (cs_sel_reg[3:0] - 4'd1)) == 4'b0000) begin
                            busy      <= 1'b1;
                            byte_cnt  <= 8'd0;
                            clk_cnt   <= 16'd0;
                            clk_phase <= 1'b0;
                            spi_state <= SPI_CS_SETUP;
                        end else begin
                            cs_guard_viol <= 1'b1;
                        end
                        ctrl_reg[0] <= 1'b0;
                    end
                end

                SPI_CS_SETUP: begin
                    cs_n  <= ~cs_sel_reg | cs_lock_reg;
                    sck   <= cpol;
                    if (clk_cnt >= eff_div - 1) begin
                        clk_cnt   <= 16'd0;
                        if (!tx_empty) begin
                            tx_shift  <= tx_fifo[tx_rd_ptr[FIFO_AW-1:0]];
                            tx_rd_ptr <= tx_rd_ptr + 1'b1;
                            bit_cnt   <= 4'd7;
                            rx_shift  <= 8'd0;
                            spi_state <= SPI_SHIFT;
                        end else begin
                            underrun_flag <= 1'b1;
                            spi_state     <= SPI_CS_HOLD;
                        end
                    end
                end

                SPI_SHIFT: begin
                    if (clk_cnt >= eff_div - 1) begin
                        clk_cnt   <= 16'd0;
                        clk_phase <= ~clk_phase;

                        if (!clk_phase) begin

                            if (!cpha) begin

                                sck  <= ~cpol;
                                mosi <= tx_shift[7];
                            end else begin

                                sck      <= ~cpol;
                                rx_shift <= {rx_shift[6:0], miso_in};
                                if (bit_cnt == 4'd0) begin

                                end else begin
                                    tx_shift <= {tx_shift[6:0], 1'b0};
                                    bit_cnt  <= bit_cnt - 1'b1;
                                end
                            end
                        end else begin

                            if (!cpha) begin

                                sck      <= cpol;
                                rx_shift <= {rx_shift[6:0], miso_in};
                                if (bit_cnt == 4'd0) begin

                                    if (!rx_full) begin
                                        rx_fifo[rx_wr_ptr[FIFO_AW-1:0]] <= {rx_shift[6:0], miso_in};
                                        rx_wr_ptr <= rx_wr_ptr + 1'b1;
                                    end
                                    byte_cnt <= byte_cnt + 1'b1;
                                    if (!tx_empty && (byte_cnt + 1 < max_len_reg)) begin
                                        tx_shift  <= tx_fifo[tx_rd_ptr[FIFO_AW-1:0]];
                                        tx_rd_ptr <= tx_rd_ptr + 1'b1;
                                        bit_cnt   <= 4'd7;
                                        rx_shift  <= 8'd0;
                                    end else begin
                                        spi_state <= SPI_CS_HOLD;
                                    end
                                end else begin
                                    tx_shift <= {tx_shift[6:0], 1'b0};
                                    bit_cnt  <= bit_cnt - 1'b1;
                                    mosi     <= tx_shift[6];
                                end
                            end else begin

                                sck  <= cpol;
                                mosi <= tx_shift[7];
                                if (bit_cnt == 4'd0) begin
                                    if (!rx_full) begin
                                        rx_fifo[rx_wr_ptr[FIFO_AW-1:0]] <= rx_shift;
                                        rx_wr_ptr <= rx_wr_ptr + 1'b1;
                                    end
                                    byte_cnt <= byte_cnt + 1'b1;
                                    if (!tx_empty && (byte_cnt + 1 < max_len_reg)) begin
                                        tx_shift  <= tx_fifo[tx_rd_ptr[FIFO_AW-1:0]];
                                        tx_rd_ptr <= tx_rd_ptr + 1'b1;
                                        bit_cnt   <= 4'd7;
                                        rx_shift  <= 8'd0;
                                    end else begin
                                        spi_state <= SPI_CS_HOLD;
                                    end
                                end else begin
                                    tx_shift <= {tx_shift[6:0], 1'b0};
                                    bit_cnt  <= bit_cnt - 1'b1;
                                end
                            end
                        end
                    end
                end

                SPI_CS_HOLD: begin
                    sck <= cpol;
                    if (clk_cnt >= eff_div - 1) begin
                        clk_cnt   <= 16'd0;
                        spi_state <= SPI_CS_DES;
                    end
                end

                SPI_CS_DES: begin
                    cs_n <= 4'hF;
                    if (clk_cnt >= eff_div - 1) begin
                        clk_cnt   <= 16'd0;
                        spi_state <= SPI_DONE;
                    end
                end

                SPI_DONE: begin
                    busy      <= 1'b0;
                    spi_state <= SPI_IDLE;
                end
                default: spi_state <= SPI_IDLE;
            endcase
        end
    end

    reg        aw_active;
    reg [4:0]  aw_addr_lat;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            s_axil_awready <= 1'b0;
            s_axil_wready  <= 1'b0;
            s_axil_bvalid  <= 1'b0;
            s_axil_bresp   <= 2'b00;
            aw_active      <= 1'b0;
            aw_addr_lat    <= 5'd0;
            ctrl_reg       <= 4'd0;
            cs_sel_reg     <= 4'd0;
            divider_reg    <= 16'd4;
            max_len_reg    <= 8'd255;
            cs_lock_reg    <= 4'd0;
            overflow_alert <= 1'b0;
            cs_guard_viol  <= 1'b0;
            tx_wr_ptr      <= {(FIFO_AW+1){1'b0}};
        end else begin
            s_axil_awready <= 1'b0;
            s_axil_wready  <= 1'b0;

            if (s_axil_awvalid && !aw_active) begin
                s_axil_awready <= 1'b1;
                aw_addr_lat    <= s_axil_awaddr[6:2];
                aw_active      <= 1'b1;
            end

            if (s_axil_wvalid && aw_active && !s_axil_bvalid) begin
                s_axil_wready <= 1'b1;
                aw_active     <= 1'b0;

                case (aw_addr_lat)
                    ADDR_DATA[4:0]: begin

                        if (byte_cnt < max_len_reg) begin
                            if (!tx_full) begin
                                tx_fifo[tx_wr_ptr[FIFO_AW-1:0]] <= s_axil_wdata[7:0];
                                tx_wr_ptr <= tx_wr_ptr + 1'b1;
                            end else begin
                                overflow_alert <= 1'b1;
                            end
                        end else begin
                            overflow_alert <= 1'b1;
                        end
                    end
                    ADDR_CTRL[4:0]:    ctrl_reg    <= s_axil_wdata[3:0];
                    ADDR_CS_SEL[4:0]:  cs_sel_reg  <= s_axil_wdata[3:0];
                    ADDR_DIVIDER[4:0]: divider_reg <= s_axil_wdata[15:0];
                    ADDR_MAX_LEN[4:0]: max_len_reg <= s_axil_wdata[7:0];
                    ADDR_CS_LOCK[4:0]: cs_lock_reg <= cs_lock_reg | s_axil_wdata[3:0];
                    ADDR_ALERT[4:0]: begin
                        if (s_axil_wdata[0]) overflow_alert <= 1'b0;
                        if (s_axil_wdata[1]) cs_guard_viol  <= 1'b0;
                    end
                    default: ;
                endcase

                s_axil_bvalid <= 1'b1;
                s_axil_bresp  <= 2'b00;
            end

            if (s_axil_bvalid && s_axil_bready)
                s_axil_bvalid <= 1'b0;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            s_axil_arready <= 1'b0;
            s_axil_rvalid  <= 1'b0;
            s_axil_rdata   <= 32'd0;
            s_axil_rresp   <= 2'b00;
            rx_rd_ptr      <= {(FIFO_AW+1){1'b0}};
        end else begin
            s_axil_arready <= 1'b0;

            if (s_axil_arvalid && !s_axil_rvalid) begin
                s_axil_arready <= 1'b1;
                s_axil_rvalid  <= 1'b1;
                s_axil_rresp   <= 2'b00;

                case (s_axil_araddr[6:2])
                    ADDR_DATA[4:0]: begin
                        if (!rx_empty) begin
                            s_axil_rdata <= {24'd0, rx_fifo[rx_rd_ptr[FIFO_AW-1:0]]};
                            rx_rd_ptr    <= rx_rd_ptr + 1'b1;
                        end else begin
                            s_axil_rdata <= 32'hFF;
                        end
                    end
                    ADDR_STATUS[4:0]: s_axil_rdata <= {25'd0,
                                            underrun_flag,
                                            overflow_alert,
                                            rx_empty,
                                            tx_full,
                                            rx_full,
                                            tx_empty,
                                            busy
                                        };
                    ADDR_CTRL[4:0]:    s_axil_rdata <= {28'd0, ctrl_reg};
                    ADDR_CS_SEL[4:0]:  s_axil_rdata <= {28'd0, cs_sel_reg};
                    ADDR_DIVIDER[4:0]: s_axil_rdata <= {16'd0, divider_reg};
                    ADDR_MAX_LEN[4:0]: s_axil_rdata <= {24'd0, max_len_reg};
                    ADDR_CS_LOCK[4:0]: s_axil_rdata <= {28'd0, cs_lock_reg};
                    ADDR_ALERT[4:0]:   s_axil_rdata <= {30'd0, cs_guard_viol, overflow_alert};
                    default:           s_axil_rdata <= 32'hDEAD_BEEF;
                endcase
            end

            if (s_axil_rvalid && s_axil_rready)
                s_axil_rvalid <= 1'b0;
        end
    end

    assign irq = !rx_empty | overflow_alert | cs_guard_viol | underrun_flag;

endmodule
