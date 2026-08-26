`timescale 1ns/1ps
`default_nettype none

module rosc_trng #(
    parameter RCT_CUTOFF  = 30,
    parameter APT_WINDOW  = 512,
    parameter APT_THRESH  = 397
)(
    input  wire        clk,
    input  wire        rst_n,

    input  wire        rosc_ext,

    output reg  [31:0] trng_data,
    output reg         trng_valid,

    output wire        rct_fail,
    output wire        apt_fail,

    input  wire [11:0] s_axil_awaddr,
    input  wire        s_axil_awvalid,
    output reg         s_axil_awready,
    input  wire [31:0] s_axil_wdata,
    input  wire [3:0]  s_axil_wstrb,
    input  wire        s_axil_wvalid,
    output reg         s_axil_wready,
    output reg  [1:0]  s_axil_bresp,
    output reg         s_axil_bvalid,
    input  wire        s_axil_bready,
    input  wire [11:0] s_axil_araddr,
    input  wire        s_axil_arvalid,
    output reg         s_axil_arready,
    output reg  [31:0] s_axil_rdata,
    output reg  [1:0]  s_axil_rresp,
    output reg         s_axil_rvalid,
    input  wire        s_axil_rready
);

(* ASYNC_REG = "TRUE" *) reg sync0;
(* ASYNC_REG = "TRUE" *) reg sync1;
(* ASYNC_REG = "TRUE" *) reg sync2;
(* ASYNC_REG = "TRUE" *) reg sync3;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sync0 <= 1'b0;
        sync1 <= 1'b0;
        sync2 <= 1'b0;
        sync3 <= 1'b0;
    end else begin
        sync0 <= rosc_ext;
        sync1 <= sync0;
        sync2 <= sync1;
        sync3 <= sync2;
    end
end

reg sync3_d1, sync3_d2, sync3_d3;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sync3_d1 <= 1'b0;
        sync3_d2 <= 1'b0;
        sync3_d3 <= 1'b0;
    end else begin
        sync3_d1 <= sync3;
        sync3_d2 <= sync3_d1;
        sync3_d3 <= sync3_d2;
    end
end

wire primary_bit   = sync2 ^ sync3;
wire secondary_bit = sync3 ^ sync3_d3;
wire raw_bit       = primary_bit ^ secondary_bit;

reg ctrl_enable_r;
reg ctrl_test_mode_r;
reg ctrl_bypass_vn_r;
reg ctrl_rst_health_r;

wire ctrl_enable     = ctrl_enable_r;
wire ctrl_test_mode  = ctrl_test_mode_r;
wire ctrl_bypass_vn  = ctrl_bypass_vn_r;
wire ctrl_rst_health = ctrl_rst_health_r;

reg        rct_prev;
reg [7:0]  rct_run;
reg        rct_fail_sticky;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        rct_prev        <= 1'b0;
        rct_run         <= 8'd1;
        rct_fail_sticky <= 1'b0;
    end else begin
        if (ctrl_rst_health) begin
            rct_fail_sticky <= 1'b0;
            rct_run         <= 8'd1;
            rct_prev        <= raw_bit;
        end else begin
            if (raw_bit == rct_prev) begin
                if (rct_run < 8'hFF)
                    rct_run <= rct_run + 8'd1;

                if (rct_run >= (RCT_CUTOFF[7:0] - 8'd1))
                    rct_fail_sticky <= 1'b1;
            end else begin
                rct_run  <= 8'd1;
                rct_prev <= raw_bit;
            end
        end
    end
end

reg [9:0]  apt_win_cnt;
reg        apt_ref_bit;
reg [9:0]  apt_pop_cnt;
reg        apt_fail_sticky;
reg        apt_new_window;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        apt_win_cnt     <= 10'd0;
        apt_ref_bit     <= 1'b0;
        apt_pop_cnt     <= 10'd0;
        apt_fail_sticky <= 1'b0;
        apt_new_window  <= 1'b1;
    end else begin
        if (ctrl_rst_health) begin
            apt_fail_sticky <= 1'b0;
            apt_win_cnt     <= 10'd0;
            apt_pop_cnt     <= 10'd0;
            apt_new_window  <= 1'b1;
        end else begin
            if (apt_new_window) begin

                apt_ref_bit    <= raw_bit;
                apt_pop_cnt    <= 10'd1;
                apt_win_cnt    <= 10'd1;
                apt_new_window <= 1'b0;
            end else begin
                apt_win_cnt <= apt_win_cnt + 10'd1;
                if (raw_bit == apt_ref_bit)
                    apt_pop_cnt <= apt_pop_cnt + 10'd1;

                if (apt_win_cnt == (APT_WINDOW[9:0] - 10'd1)) begin
                    if (apt_pop_cnt > APT_THRESH[9:0])
                        apt_fail_sticky <= 1'b1;
                    apt_win_cnt    <= 10'd0;
                    apt_pop_cnt    <= 10'd0;
                    apt_new_window <= 1'b1;
                end
            end
        end
    end
end

assign rct_fail = rct_fail_sticky;
assign apt_fail = apt_fail_sticky;

reg [31:0] lfsr_state;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        lfsr_state <= 32'hDEAD_CAFE;
    end else begin
        lfsr_state <= {1'b0, lfsr_state[31:1]} ^
                      (lfsr_state[0] ? 32'h0040_0007 : 32'h0000_0000);
    end
end

reg        vn_phase;
reg        vn_first;
reg        vn_bit_valid;
reg        vn_bit;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        vn_phase     <= 1'b0;
        vn_first     <= 1'b0;
        vn_bit_valid <= 1'b0;
        vn_bit       <= 1'b0;
    end else begin
        if (ctrl_bypass_vn) begin
            vn_bit_valid <= 1'b1;
            vn_bit       <= raw_bit;
            vn_phase     <= 1'b0;
        end else begin
            vn_bit_valid <= 1'b0;
            if (vn_phase == 1'b0) begin
                vn_first <= raw_bit;
                vn_phase <= 1'b1;
            end else begin
                vn_phase <= 1'b0;
                if (vn_first != raw_bit) begin
                    vn_bit_valid <= 1'b1;
                    vn_bit       <= vn_first;
                end
            end
        end
    end
end

reg [31:0] accum;
reg [5:0]  accum_cnt;
reg        accum_full;
reg [31:0] accum_word;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        accum      <= 32'h0;
        accum_cnt  <= 6'd0;
        accum_full <= 1'b0;
        accum_word <= 32'h0;
    end else begin
        accum_full <= 1'b0;
        if (ctrl_enable && vn_bit_valid) begin
            accum     <= {accum[30:0], vn_bit};
            accum_cnt <= accum_cnt + 6'd1;
            if (accum_cnt == 6'd31) begin
                accum_word <= {accum[30:0], vn_bit};
                accum_full <= 1'b1;
                accum_cnt  <= 6'd0;
            end
        end
    end
end

reg axi_consume;

reg fifo_full_sticky;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        trng_data        <= 32'h0;
        trng_valid       <= 1'b0;
        fifo_full_sticky <= 1'b0;
    end else begin

        if (accum_full && trng_valid)
            fifo_full_sticky <= 1'b1;

        if (accum_full && ctrl_enable) begin
            trng_data  <= ctrl_test_mode ? lfsr_state : (accum_word ^ lfsr_state);
            trng_valid <= 1'b1;
        end

        if (axi_consume) begin
            trng_valid       <= 1'b0;
            fifo_full_sticky <= 1'b0;
        end
    end
end

reg [11:0] aw_addr_lat;
reg        aw_addr_pending;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        s_axil_awready   <= 1'b0;
        s_axil_wready    <= 1'b0;
        s_axil_bvalid    <= 1'b0;
        s_axil_bresp     <= 2'b00;
        aw_addr_lat      <= 12'h0;
        aw_addr_pending  <= 1'b0;
        ctrl_enable_r    <= 1'b0;
        ctrl_test_mode_r <= 1'b0;
        ctrl_bypass_vn_r <= 1'b0;
        ctrl_rst_health_r <= 1'b0;
    end else begin

        s_axil_awready    <= 1'b0;
        s_axil_wready     <= 1'b0;
        ctrl_rst_health_r <= 1'b0;

        if (s_axil_awvalid && !s_axil_awready && !aw_addr_pending) begin
            s_axil_awready  <= 1'b1;
            aw_addr_lat     <= s_axil_awaddr;
            aw_addr_pending <= 1'b1;
        end

        if (s_axil_wvalid && aw_addr_pending && !s_axil_wready) begin
            s_axil_wready   <= 1'b1;
            aw_addr_pending <= 1'b0;
            s_axil_bvalid   <= 1'b1;
            s_axil_bresp    <= 2'b00;

            case (aw_addr_lat[11:0])
                12'h000: ;
                12'h004: ;
                12'h008: begin

                    ctrl_enable_r    <= s_axil_wdata[0];
                    ctrl_test_mode_r <= s_axil_wdata[1];
                    ctrl_bypass_vn_r <= s_axil_wdata[2];
                    if (s_axil_wdata[3])
                        ctrl_rst_health_r <= 1'b1;
                end
                default: ;
            endcase
        end

        if (s_axil_bvalid && s_axil_bready)
            s_axil_bvalid <= 1'b0;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        s_axil_arready <= 1'b0;
        s_axil_rvalid  <= 1'b0;
        s_axil_rdata   <= 32'h0;
        s_axil_rresp   <= 2'b00;
        axi_consume    <= 1'b0;
    end else begin
        s_axil_arready <= 1'b0;
        axi_consume    <= 1'b0;

        if (s_axil_arvalid && !s_axil_arready) begin
            s_axil_arready <= 1'b1;
            s_axil_rvalid  <= 1'b1;
            s_axil_rresp   <= 2'b00;

            case (s_axil_araddr[11:0])
                12'h000: begin

                    s_axil_rdata <= trng_data;
                    axi_consume  <= 1'b1;
                end
                12'h004: begin

                    s_axil_rdata <= {28'h0,
                                     fifo_full_sticky,
                                     apt_fail_sticky,
                                     rct_fail_sticky,
                                     trng_valid};
                end
                12'h008: begin

                    s_axil_rdata <= {29'h0,
                                     ctrl_bypass_vn_r,
                                     ctrl_test_mode_r,
                                     ctrl_enable_r};
                end
                default: begin
                    s_axil_rdata <= 32'hDEAD_BEEF;
                end
            endcase
        end

        if (s_axil_rvalid && s_axil_rready)
            s_axil_rvalid <= 1'b0;
    end
end

endmodule

`default_nettype wire
