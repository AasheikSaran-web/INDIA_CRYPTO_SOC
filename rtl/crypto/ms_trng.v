`timescale 1ns/1ps

module ms_trng #(
    parameter RCT_CUTOFF  = 30,
    parameter APT_WINDOW  = 512,
    parameter APT_THRESH  = 397
)(

    input  wire        clk,
    input  wire        rst_n,

    input  wire [7:0]  async_src,

    output reg  [31:0] trng_data,
    output reg         trng_valid,

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

(* ASYNC_REG = "TRUE" *) reg [7:0] cap_pos;

(* ASYNC_REG = "TRUE" *) reg [7:0] cap_neg_raw;
(* ASYNC_REG = "TRUE" *) reg [7:0] cap_neg_r1;
(* ASYNC_REG = "TRUE" *) reg [7:0] cap_neg;

always @(posedge clk) begin
    cap_pos <= async_src;
end

always @(negedge clk) begin
    cap_neg_raw <= async_src;
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cap_neg_r1 <= 8'h00;
        cap_neg    <= 8'h00;
    end else begin
        cap_neg_r1 <= cap_neg_raw;
        cap_neg    <= cap_neg_r1;
    end
end

wire [7:0] channel_raw;
genvar ci;
generate
    for (ci = 0; ci < 8; ci = ci + 1) begin : gen_ch
        assign channel_raw[ci] = cap_pos[ci] ^ cap_neg[ci];
    end
endgenerate

wire raw_bit = ^channel_raw;

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
        if (vn_bit_valid) begin
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

reg [31:0] lfsr_state;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        lfsr_state <= 32'hDEAD_CAFE;
    end else begin

        lfsr_state <= {1'b0, lfsr_state[31:1]} ^
                      (lfsr_state[0] ? 32'h0040_0007 : 32'h0);
    end
end

reg        rct_prev;
reg [7:0]  rct_count;
reg        rct_fail_sticky;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        rct_prev        <= 1'b0;
        rct_count       <= 8'd1;
        rct_fail_sticky <= 1'b0;
    end else begin
        if (ctrl_rst_health) begin
            rct_fail_sticky <= 1'b0;
            rct_count       <= 8'd1;
        end else if (vn_bit_valid) begin
            if (vn_bit == rct_prev) begin
                rct_count <= rct_count + 8'd1;
                if (rct_count >= RCT_CUTOFF[7:0])
                    rct_fail_sticky <= 1'b1;
            end else begin
                rct_count <= 8'd1;
                rct_prev  <= vn_bit;
            end
        end
    end
end

reg [9:0]  apt_window_cnt;
reg        apt_first_bit;
reg [9:0]  apt_pop_cnt;
reg        apt_fail_sticky;
reg        apt_first_sample;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        apt_window_cnt  <= 10'd0;
        apt_first_bit   <= 1'b0;
        apt_pop_cnt     <= 10'd0;
        apt_fail_sticky <= 1'b0;
        apt_first_sample<= 1'b1;
    end else begin
        if (ctrl_rst_health) begin
            apt_fail_sticky  <= 1'b0;
            apt_window_cnt   <= 10'd0;
            apt_first_sample <= 1'b1;
            apt_pop_cnt      <= 10'd0;
        end else if (vn_bit_valid) begin
            if (apt_first_sample) begin
                apt_first_bit    <= vn_bit;
                apt_pop_cnt      <= 10'd1;
                apt_window_cnt   <= 10'd1;
                apt_first_sample <= 1'b0;
            end else begin
                apt_window_cnt <= apt_window_cnt + 10'd1;
                if (vn_bit == apt_first_bit)
                    apt_pop_cnt <= apt_pop_cnt + 10'd1;
                if (apt_window_cnt == APT_WINDOW[9:0] - 10'd1) begin

                    if (apt_pop_cnt > APT_THRESH[9:0])
                        apt_fail_sticky <= 1'b1;
                    apt_window_cnt   <= 10'd0;
                    apt_first_sample <= 1'b1;
                    apt_pop_cnt      <= 10'd0;
                end
            end
        end
    end
end

wire        ctrl_enable;
wire        ctrl_rst_health;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        trng_data  <= 32'h0;
        trng_valid <= 1'b0;
    end else begin
        if (accum_full && ctrl_enable && !trng_valid) begin
            trng_data  <= accum_word ^ lfsr_state;
            trng_valid <= 1'b1;
        end else if (axi_read_data_reg) begin
            trng_valid <= 1'b0;
        end
    end
end

reg ctrl_enable_r;
reg ctrl_rst_health_r;

assign ctrl_enable     = ctrl_enable_r;
assign ctrl_rst_health = ctrl_rst_health_r;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        ctrl_rst_health_r <= 1'b0;
    else if (ctrl_rst_health_r)
        ctrl_rst_health_r <= 1'b0;
end

reg  [11:0] aw_addr_lat;
reg         aw_addr_valid;
reg         axi_read_data_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        s_axil_awready   <= 1'b0;
        s_axil_wready    <= 1'b0;
        s_axil_bvalid    <= 1'b0;
        s_axil_bresp     <= 2'b00;
        aw_addr_lat      <= 12'h0;
        aw_addr_valid    <= 1'b0;
        ctrl_enable_r    <= 1'b0;
    end else begin

        if (s_axil_awvalid && !s_axil_awready) begin
            s_axil_awready <= 1'b1;
            aw_addr_lat    <= s_axil_awaddr;
            aw_addr_valid  <= 1'b1;
        end else begin
            s_axil_awready <= 1'b0;
        end

        if (s_axil_wvalid && aw_addr_valid && !s_axil_wready) begin
            s_axil_wready <= 1'b1;
            aw_addr_valid <= 1'b0;
            case (aw_addr_lat[3:0])
                4'h0: ;
                4'h4: ;
                4'h8: begin

                    ctrl_rst_health_r <= 1'b1;
                end
                4'hC: begin
                    ctrl_enable_r <= s_axil_wdata[0];
                    if (s_axil_wdata[1])
                        ctrl_rst_health_r <= 1'b1;
                end
                default: ;
            endcase
            s_axil_bvalid <= 1'b1;
            s_axil_bresp  <= 2'b00;
        end else begin
            s_axil_wready <= 1'b0;
        end

        if (s_axil_bvalid && s_axil_bready)
            s_axil_bvalid <= 1'b0;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        s_axil_arready    <= 1'b0;
        s_axil_rvalid     <= 1'b0;
        s_axil_rdata      <= 32'h0;
        s_axil_rresp      <= 2'b00;
        axi_read_data_reg <= 1'b0;
    end else begin
        axi_read_data_reg <= 1'b0;

        if (s_axil_arvalid && !s_axil_arready) begin
            s_axil_arready <= 1'b1;
            s_axil_rvalid  <= 1'b1;
            s_axil_rresp   <= 2'b00;
            case (s_axil_araddr[3:0])
                4'h0: s_axil_rdata <= {31'h0, trng_valid};
                4'h4: begin
                    s_axil_rdata      <= trng_data;
                    axi_read_data_reg <= 1'b1;
                end
                4'h8: s_axil_rdata <= {30'h0, apt_fail_sticky, rct_fail_sticky};
                4'hC: s_axil_rdata <= {30'h0, ctrl_rst_health_r, ctrl_enable_r};
                default: s_axil_rdata <= 32'hDEAD_BEEF;
            endcase
        end else begin
            s_axil_arready <= 1'b0;
        end

        if (s_axil_rvalid && s_axil_rready)
            s_axil_rvalid <= 1'b0;
    end
end

endmodule
