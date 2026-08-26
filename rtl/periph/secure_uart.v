`timescale 1ns/1ps

module secure_uart #(
    parameter CLK_FREQ   = 50_000_000,
    parameter BAUD_DEF   = 434,
    parameter FIFO_DEPTH = 16,
    parameter STALL_LIM  = 1_000_000
) (
    input  wire        clk,
    input  wire        rst_n,

    input  wire        secure_mode,

    output reg         tx_pin,
    input  wire        rx_pin,

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

    localparam ADDR_DATA   = 5'h00;
    localparam ADDR_STATUS = 5'h04;
    localparam ADDR_BAUD   = 5'h08;
    localparam ADDR_CTRL   = 5'h0C;
    localparam ADDR_LOCK   = 5'h10;
    localparam ADDR_ALERT  = 5'h14;

    localparam FIFO_AW = 4;

    localparam TX_IDLE  = 2'd0;
    localparam TX_START = 2'd1;
    localparam TX_DATA  = 2'd2;
    localparam TX_STOP  = 2'd3;

    localparam RX_IDLE  = 3'd0;
    localparam RX_FILT  = 3'd1;
    localparam RX_START = 3'd2;
    localparam RX_DATA  = 3'd3;
    localparam RX_STOP  = 3'd4;

    reg [15:0] baud_div;
    reg        baud_locked;
    reg        tx_en, rx_en;
    reg        attack_alert;
    reg        stall_alert;
    reg        frame_err_flag;

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

    reg [15:0] baud_cnt;
    reg        baud_tick;

    reg [1:0]  tx_state;
    reg [3:0]  tx_bit_cnt;
    reg [7:0]  tx_shift;
    reg [15:0] tx_baud_cnt;

    reg [2:0]  rx_state;
    reg [3:0]  rx_bit_cnt;
    reg [7:0]  rx_shift;
    reg [15:0] rx_baud_cnt;
    reg [1:0]  rx_glitch_cnt;
    reg [4:0]  frame_err_cnt;
    reg [4:0]  valid_frame_cnt;

    reg [19:0] stall_cnt;

    reg        aw_active;
    reg [4:0]  aw_addr_lat;
    reg [31:0] w_data_lat;
    reg [3:0]  w_strb_lat;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            baud_cnt  <= 16'd0;
            baud_tick <= 1'b0;
        end else begin
            if (baud_cnt == baud_div - 1) begin
                baud_cnt  <= 16'd0;
                baud_tick <= 1'b1;
            end else begin
                baud_cnt  <= baud_cnt + 1'b1;
                baud_tick <= 1'b0;
            end
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            tx_state    <= TX_IDLE;
            tx_pin      <= 1'b1;
            tx_bit_cnt  <= 4'd0;
            tx_shift    <= 8'd0;
            tx_baud_cnt <= 16'd0;
            tx_rd_ptr   <= {(FIFO_AW+1){1'b0}};
        end else begin
            case (tx_state)
                TX_IDLE: begin
                    tx_pin <= 1'b1;
                    if (!tx_empty && tx_en && !secure_mode) begin
                        tx_shift    <= tx_fifo[tx_rd_ptr[FIFO_AW-1:0]];
                        tx_rd_ptr   <= tx_rd_ptr + 1'b1;
                        tx_baud_cnt <= 16'd0;
                        tx_state    <= TX_START;
                    end
                end
                TX_START: begin
                    tx_pin <= 1'b0;
                    if (baud_tick) begin
                        if (tx_baud_cnt == baud_div - 1) begin
                            tx_baud_cnt <= 16'd0;
                            tx_bit_cnt  <= 4'd0;
                            tx_state    <= TX_DATA;
                        end else begin
                            tx_baud_cnt <= tx_baud_cnt + 1'b1;
                        end
                    end
                end
                TX_DATA: begin
                    tx_pin <= tx_shift[0];
                    if (baud_tick) begin
                        if (tx_baud_cnt == baud_div - 1) begin
                            tx_baud_cnt <= 16'd0;
                            tx_shift    <= {1'b0, tx_shift[7:1]};
                            if (tx_bit_cnt == 4'd7) begin
                                tx_state <= TX_STOP;
                            end else begin
                                tx_bit_cnt <= tx_bit_cnt + 1'b1;
                            end
                        end else begin
                            tx_baud_cnt <= tx_baud_cnt + 1'b1;
                        end
                    end
                end
                TX_STOP: begin
                    tx_pin <= 1'b1;
                    if (baud_tick) begin
                        if (tx_baud_cnt == baud_div - 1) begin
                            tx_baud_cnt <= 16'd0;
                            tx_state    <= TX_IDLE;
                        end else begin
                            tx_baud_cnt <= tx_baud_cnt + 1'b1;
                        end
                    end
                end
                default: tx_state <= TX_IDLE;
            endcase

            if (secure_mode) begin
                tx_state <= TX_IDLE;
                tx_pin   <= 1'b1;
            end
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rx_state      <= RX_IDLE;
            rx_bit_cnt    <= 4'd0;
            rx_shift      <= 8'd0;
            rx_baud_cnt   <= 16'd0;
            rx_glitch_cnt <= 2'd0;
            rx_wr_ptr     <= {(FIFO_AW+1){1'b0}};
            frame_err_cnt  <= 5'd0;
            valid_frame_cnt<= 5'd0;
            frame_err_flag <= 1'b0;
            attack_alert   <= 1'b0;
        end else begin
            case (rx_state)
                RX_IDLE: begin
                    if (rx_pin == 1'b0 && rx_en && !secure_mode) begin
                        rx_glitch_cnt <= 2'd1;
                        rx_baud_cnt   <= 16'd0;
                        rx_state      <= RX_FILT;
                    end
                end

                RX_FILT: begin
                    if (rx_pin == 1'b1) begin

                        rx_state <= RX_IDLE;
                    end else if (baud_tick) begin
                        if (rx_glitch_cnt == 2'd3) begin

                            rx_baud_cnt <= 16'd0;
                            rx_state    <= RX_START;
                        end else begin
                            rx_glitch_cnt <= rx_glitch_cnt + 1'b1;
                        end
                    end
                end
                RX_START: begin

                    if (baud_tick) begin
                        if (rx_baud_cnt == (baud_div >> 1) - 1) begin
                            rx_baud_cnt <= 16'd0;
                            rx_bit_cnt  <= 4'd0;
                            rx_state    <= RX_DATA;
                        end else begin
                            rx_baud_cnt <= rx_baud_cnt + 1'b1;
                        end
                    end
                end
                RX_DATA: begin
                    if (baud_tick) begin
                        if (rx_baud_cnt == baud_div - 1) begin
                            rx_baud_cnt          <= 16'd0;
                            rx_shift             <= {rx_pin, rx_shift[7:1]};
                            if (rx_bit_cnt == 4'd7) begin
                                rx_state <= RX_STOP;
                            end else begin
                                rx_bit_cnt <= rx_bit_cnt + 1'b1;
                            end
                        end else begin
                            rx_baud_cnt <= rx_baud_cnt + 1'b1;
                        end
                    end
                end
                RX_STOP: begin
                    if (baud_tick) begin
                        if (rx_baud_cnt == baud_div - 1) begin
                            rx_baud_cnt <= 16'd0;
                            if (rx_pin == 1'b1) begin

                                frame_err_cnt   <= 5'd0;
                                frame_err_flag  <= 1'b0;
                                if (!rx_full && !secure_mode) begin
                                    rx_fifo[rx_wr_ptr[FIFO_AW-1:0]] <= rx_shift;
                                    rx_wr_ptr <= rx_wr_ptr + 1'b1;
                                end
                            end else begin

                                frame_err_flag <= 1'b1;
                                if (frame_err_cnt == 5'd16) begin
                                    attack_alert <= 1'b1;
                                end else begin
                                    frame_err_cnt <= frame_err_cnt + 1'b1;
                                end
                            end
                            rx_state <= RX_IDLE;
                        end else begin
                            rx_baud_cnt <= rx_baud_cnt + 1'b1;
                        end
                    end
                end
                default: rx_state <= RX_IDLE;
            endcase

            if (secure_mode) begin
                rx_wr_ptr <= rx_rd_ptr;
                rx_state  <= RX_IDLE;
            end
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stall_cnt   <= 20'd0;
            stall_alert <= 1'b0;
        end else begin
            if (!tx_empty && tx_en && !secure_mode) begin
                if (tx_state == TX_IDLE) begin
                    stall_cnt <= stall_cnt + 1'b1;
                    if (stall_cnt >= STALL_LIM[19:0]) begin
                        stall_alert <= 1'b1;
                    end
                end else begin
                    stall_cnt <= 20'd0;
                end
            end else begin
                stall_cnt <= 20'd0;
            end
        end
    end

    reg [4:0] wr_addr;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            s_axil_awready <= 1'b0;
            s_axil_wready  <= 1'b0;
            s_axil_bvalid  <= 1'b0;
            s_axil_bresp   <= 2'b00;
            aw_active      <= 1'b0;
            aw_addr_lat    <= 5'd0;
            w_data_lat     <= 32'd0;
            w_strb_lat     <= 4'd0;
            baud_div       <= BAUD_DEF[15:0];
            baud_locked    <= 1'b0;
            tx_en          <= 1'b1;
            rx_en          <= 1'b1;
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
                w_data_lat    <= s_axil_wdata;

                case (aw_addr_lat)
                    ADDR_DATA[4:0]: begin
                        if (!tx_full && tx_en) begin
                            tx_fifo[tx_wr_ptr[FIFO_AW-1:0]] <= s_axil_wdata[7:0];
                            tx_wr_ptr <= tx_wr_ptr + 1'b1;
                        end
                    end
                    ADDR_BAUD[4:0]: begin
                        if (!baud_locked)
                            baud_div <= s_axil_wdata[15:0];
                    end
                    ADDR_CTRL[4:0]: begin
                        tx_en <= s_axil_wdata[0];
                        rx_en <= s_axil_wdata[1];
                        if (s_axil_wdata[2]) begin
                            tx_wr_ptr <= tx_rd_ptr;
                            rx_wr_ptr <= rx_rd_ptr;
                        end
                    end
                    ADDR_LOCK[4:0]: begin
                        if (s_axil_wdata[7:0] == 8'hA5)
                            baud_locked <= 1'b1;
                    end
                    ADDR_ALERT[4:0]: begin
                        attack_alert <= 1'b0;
                        stall_alert  <= 1'b0;
                    end
                    default: ;
                endcase

                s_axil_bvalid <= 1'b1;
                s_axil_bresp  <= 2'b00;
            end

            if (s_axil_bvalid && s_axil_bready) begin
                s_axil_bvalid <= 1'b0;
            end
        end
    end

    reg [4:0] rd_addr;

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
                    ADDR_STATUS[4:0]: begin
                        s_axil_rdata <= {24'd0,
                            stall_alert,
                            attack_alert,
                            baud_locked,
                            frame_err_flag,
                            rx_full,
                            tx_empty,
                            rx_empty,
                            tx_full
                        };
                    end
                    ADDR_BAUD[4:0]: begin
                        s_axil_rdata <= {16'd0, baud_div};
                    end
                    ADDR_CTRL[4:0]: begin
                        s_axil_rdata <= {29'd0, 1'b0, rx_en, tx_en};
                    end
                    ADDR_LOCK[4:0]: begin
                        s_axil_rdata <= {31'd0, baud_locked};
                    end
                    ADDR_ALERT[4:0]: begin
                        s_axil_rdata <= {30'd0, stall_alert, attack_alert};
                    end
                    default: s_axil_rdata <= 32'hDEAD_BEEF;
                endcase
            end

            if (s_axil_rvalid && s_axil_rready) begin
                s_axil_rvalid <= 1'b0;
            end
        end
    end

    assign irq = !rx_empty | attack_alert | stall_alert;

endmodule
