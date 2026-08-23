// =============================================================================
// ms_trng.v — Metastable Flip-Flop True Random Number Generator
// Project  : INDIA_CRYPTO_SOC — AES-accelerated PDF encryption
// Spec     : NIST SP 800-90B compliant health tests (RCT + APT)
// Interface: AXI-Lite slave (12-bit addr, 32-bit data)
//            0x00 STATUS [0]=valid
//            0x04 DATA   [31:0] read clears valid
//            0x08 HEALTH [1]=apt_fail [0]=rct_fail  write-any clears
//            0x0C CTRL   [0]=enable  [1]=rst_health
// =============================================================================

`timescale 1ns/1ps

module ms_trng #(
    parameter RCT_CUTOFF  = 30,
    parameter APT_WINDOW  = 512,
    parameter APT_THRESH  = 397
)(
    // Clock / reset
    input  wire        clk,
    input  wire        rst_n,

    // 8 asynchronous entropy sources (metastable ring-osc taps)
    input  wire [7:0]  async_src,

    // Direct outputs
    output reg  [31:0] trng_data,
    output reg         trng_valid,

    // AXI-Lite slave
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

// ---------------------------------------------------------------------------
// 1. Dual-edge entropy capture — 8 channels
//    (* ASYNC_REG = "TRUE" *) marks metastability hardening registers
// ---------------------------------------------------------------------------

// posedge captures
(* ASYNC_REG = "TRUE" *) reg [7:0] cap_pos;

// negedge captures (raw), then re-synced to posedge domain
(* ASYNC_REG = "TRUE" *) reg [7:0] cap_neg_raw;
(* ASYNC_REG = "TRUE" *) reg [7:0] cap_neg_r1;   // first sync stage
(* ASYNC_REG = "TRUE" *) reg [7:0] cap_neg;       // second sync stage (used in logic)

always @(posedge clk) begin
    cap_pos <= async_src;
end

always @(negedge clk) begin
    cap_neg_raw <= async_src;
end

// Two-FF synchroniser to bring negedge data into posedge domain
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cap_neg_r1 <= 8'h00;
        cap_neg    <= 8'h00;
    end else begin
        cap_neg_r1 <= cap_neg_raw;
        cap_neg    <= cap_neg_r1;
    end
end

// Per-channel XOR combiner
wire [7:0] channel_raw;
genvar ci;
generate
    for (ci = 0; ci < 8; ci = ci + 1) begin : gen_ch
        assign channel_raw[ci] = cap_pos[ci] ^ cap_neg[ci];
    end
endgenerate

// XOR pool — single raw bit each cycle
wire raw_bit = ^channel_raw;

// ---------------------------------------------------------------------------
// 2. Von Neumann debiaser
//    Consumes pairs of raw_bit: 10→emit 1, 01→emit 0, else discard
// ---------------------------------------------------------------------------

reg        vn_phase;      // 0 = waiting for first bit, 1 = have first bit
reg        vn_first;      // stored first bit of pair
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
                vn_bit       <= vn_first;   // 10→1, 01→0
            end
        end
    end
end

// ---------------------------------------------------------------------------
// 3. 32-bit accumulator — shift debiased bits, release word when full
// ---------------------------------------------------------------------------

reg [31:0] accum;
reg [5:0]  accum_cnt;    // counts 0..31
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

// ---------------------------------------------------------------------------
// 4. Galois LFSR output mask — poly x^32+x^22+x^2+x+1, seed DEAD_CAFE
// ---------------------------------------------------------------------------

reg [31:0] lfsr_state;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        lfsr_state <= 32'hDEAD_CAFE;
    end else begin
        // Galois LFSR: feedback taps at bits 22, 2, 1, 0 (0-indexed from LSB)
        lfsr_state <= {1'b0, lfsr_state[31:1]} ^
                      (lfsr_state[0] ? 32'h0040_0007 : 32'h0);
    end
end

// ---------------------------------------------------------------------------
// 5. Health tests — SP 800-90B
// ---------------------------------------------------------------------------

// --- RCT (Repetition Count Test) ---
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

// --- APT (Adaptive Proportion Test) ---
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
                    // end of window
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

// ---------------------------------------------------------------------------
// 6. Output register — latch masked word, raise valid
// ---------------------------------------------------------------------------

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

// ---------------------------------------------------------------------------
// 7. AXI-Lite slave
// ---------------------------------------------------------------------------

// Internal control registers
reg ctrl_enable_r;
reg ctrl_rst_health_r;

assign ctrl_enable     = ctrl_enable_r;
assign ctrl_rst_health = ctrl_rst_health_r;

// Pulse rst_health for one cycle only
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        ctrl_rst_health_r <= 1'b0;
    else if (ctrl_rst_health_r)
        ctrl_rst_health_r <= 1'b0;
end

// Write channel
reg  [11:0] aw_addr_lat;
reg         aw_addr_valid;
reg         axi_read_data_reg;   // pulse: AXI read of DATA register

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
        // Accept address
        if (s_axil_awvalid && !s_axil_awready) begin
            s_axil_awready <= 1'b1;
            aw_addr_lat    <= s_axil_awaddr;
            aw_addr_valid  <= 1'b1;
        end else begin
            s_axil_awready <= 1'b0;
        end

        // Accept data and perform write
        if (s_axil_wvalid && aw_addr_valid && !s_axil_wready) begin
            s_axil_wready <= 1'b1;
            aw_addr_valid <= 1'b0;
            case (aw_addr_lat[3:0])
                4'h0: ; // STATUS is read-only
                4'h4: ; // DATA   is read-only
                4'h8: begin // HEALTH — any write clears sticky bits
                    // will be cleared via ctrl_rst_health pulse below
                    ctrl_rst_health_r <= 1'b1;
                end
                4'hC: begin // CTRL
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

// Read channel
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
                    axi_read_data_reg <= 1'b1;   // clears valid
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
