// =============================================================================
// rosc_trng.v — Ring-Oscillator True Random Number Generator
// Project  : INDIA_CRYPTO_SOC — AES-accelerated PDF encryption
// Target   : TSMC 28nm HPC, 250 MHz system clock
// Spec     : ISSCC 2023 ring-osc TRNG architecture
//            NIST SP 800-90B health tests (RCT + APT)
// Interface: AXI-Lite slave (12-bit addr, 32-bit data)
//            0x000 TRNG_DATA (RO) — 32-bit entropy word; read = consume
//            0x004 TRNG_STAT (RO) — {28'h0, fifo_full, apt_fail, rct_fail, valid}
//            0x008 TRNG_CTRL (RW) — {29'h0, bypass_vn, test_mode, enable}
// =============================================================================

`timescale 1ns/1ps
`default_nettype none

module rosc_trng #(
    parameter RCT_CUTOFF  = 30,
    parameter APT_WINDOW  = 512,
    parameter APT_THRESH  = 397
)(
    input  wire        clk,
    input  wire        rst_n,

    // External ring-oscillator dither / entropy pin (rosc_ext, pin 10 of SoC)
    // This is a free-running asynchronous oscillator whose phase jitter provides entropy.
    input  wire        rosc_ext,

    // Direct entropy output to PDF engine (IV generation)
    output reg  [31:0] trng_data,
    output reg         trng_valid,

    // SP 800-90B health test failure flags (direct, not via AXI) -> aggregate to IRQ
    output wire        rct_fail,
    output wire        apt_fail,

    // AXI-Lite slave (12-bit address, 32-bit data)
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

// ===========================================================================
// 1. 4-stage synchroniser chain on rosc_ext
//
//    At 28nm HPC the thermal noise in the ring oscillator's free-running
//    phase accumulates as jitter. Capturing this asynchronous signal with a
//    synchroniser chain exposes jitter as metastability-resolved bit
//    transitions detectable between adjacent stages.
//
//    sync0 — first metastability-hardening stage (intentional metastable FF)
//    sync1 — second stage
//    sync2 — third stage  (used for edge detect)
//    sync3 — fourth stage (used for edge detect and delayed comparison)
//
//    All four registers carry (* ASYNC_REG = "TRUE" *) so the synthesiser
//    places them in adjacent flip-flops, preserving MTTR budget at 250 MHz.
// ===========================================================================

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

// ===========================================================================
// 2. Entropy extraction
//    Primary stream  : sync2 ^ sync3   — jitter as adjacent-stage flip events
//    Secondary stream: sync3 ^ sync3_d3 — 3-cycle self-XOR for decorrelation
//    Final raw_bit   : primary ^ secondary
// ===========================================================================

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

// ===========================================================================
// 3. Control register bits — driven from AXI write path (Section 10)
//    Declared here so downstream logic can reference them.
// ===========================================================================

reg ctrl_enable_r;
reg ctrl_test_mode_r;
reg ctrl_bypass_vn_r;
reg ctrl_rst_health_r;   // one-cycle pulse, self-clears in AXI write always block

wire ctrl_enable     = ctrl_enable_r;
wire ctrl_test_mode  = ctrl_test_mode_r;
wire ctrl_bypass_vn  = ctrl_bypass_vn_r;
wire ctrl_rst_health = ctrl_rst_health_r;

// ===========================================================================
// 4. SP 800-90B Health Tests — operate on raw_bit each clock cycle
//    Run unconditionally (independent of ctrl_enable) to always monitor
//    entropy source health.
// ===========================================================================

// ---------------------------------------------------------------------------
// 4a. RCT (Repetition Count Test)
//     Count consecutive identical raw_bit values.
//     Fail if run length >= RCT_CUTOFF.
// ---------------------------------------------------------------------------

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
                // Compare against RCT_CUTOFF-1 since we just incremented
                if (rct_run >= (RCT_CUTOFF[7:0] - 8'd1))
                    rct_fail_sticky <= 1'b1;
            end else begin
                rct_run  <= 8'd1;
                rct_prev <= raw_bit;
            end
        end
    end
end

// ---------------------------------------------------------------------------
// 4b. APT (Adaptive Proportion Test)
//     Over APT_WINDOW raw bits. First bit of each window is the reference.
//     Count occurrences of the reference bit.
//     Fail if count > APT_THRESH at end of window.
// ---------------------------------------------------------------------------

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
                // First sample: establish reference bit, begin counting
                apt_ref_bit    <= raw_bit;
                apt_pop_cnt    <= 10'd1;
                apt_win_cnt    <= 10'd1;
                apt_new_window <= 1'b0;
            end else begin
                apt_win_cnt <= apt_win_cnt + 10'd1;
                if (raw_bit == apt_ref_bit)
                    apt_pop_cnt <= apt_pop_cnt + 10'd1;

                // End of window: evaluate and reset
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

// Drive IRQ-aggregation outputs directly from sticky bits
assign rct_fail = rct_fail_sticky;
assign apt_fail = apt_fail_sticky;

// ===========================================================================
// 5. Galois LFSR whitener
//    Poly: x^32 + x^22 + x^2 + x + 1
//    Galois form: shift right; when LSB=1, XOR with tap mask 0x00400007
//      bit 22 → 0x00400000
//      bit  2 → 0x00000004
//      bit  1 → 0x00000002
//      bit  0 → 0x00000001
//    Combined: 0x00400007
//    Seed: 32'hDEAD_CAFE
//    Runs every clock — provides a fast whitening stream.
// ===========================================================================

reg [31:0] lfsr_state;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        lfsr_state <= 32'hDEAD_CAFE;
    end else begin
        lfsr_state <= {1'b0, lfsr_state[31:1]} ^
                      (lfsr_state[0] ? 32'h0040_0007 : 32'h0000_0000);
    end
end

// ===========================================================================
// 6. Von Neumann debiaser
//    Consume pairs of raw_bit: (1,0)→emit 1, (0,1)→emit 0, else discard.
//    ctrl_bypass_vn=1: pass raw_bit directly every clock (factory/bench test).
// ===========================================================================

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
                    vn_bit       <= vn_first;   // (1,0)→1  (0,1)→0
                end
            end
        end
    end
end

// ===========================================================================
// 7. 32-bit accumulator
//    Shift in debiased bits; release one 32-bit word when full.
//    Gated by ctrl_enable.
// ===========================================================================

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

// ===========================================================================
// 8. Output register and fifo_full sticky
//    test_mode=0 (normal)   : trng_data = accum_word XOR lfsr_state
//    test_mode=1 (self-test): trng_data = lfsr_state (deterministic)
//    fifo_full_sticky: set when accum_full arrives while trng_valid is still
//                      asserted (previous word not yet consumed).
//                      Cleared on AXI read of 0x000.
//    axi_consume: one-cycle pulse generated by AXI read channel (Section 10)
//                 to clear trng_valid and fifo_full_sticky.
// ===========================================================================

// Wire driven by AXI read channel always block (single driver)
reg axi_consume;

reg fifo_full_sticky;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        trng_data        <= 32'h0;
        trng_valid       <= 1'b0;
        fifo_full_sticky <= 1'b0;
    end else begin
        // fifo_full detection: new word arrived before old consumed
        if (accum_full && trng_valid)
            fifo_full_sticky <= 1'b1;

        // Capture new word
        if (accum_full && ctrl_enable) begin
            trng_data  <= ctrl_test_mode ? lfsr_state : (accum_word ^ lfsr_state);
            trng_valid <= 1'b1;
        end

        // AXI consume: clear valid and fifo_full
        if (axi_consume) begin
            trng_valid       <= 1'b0;
            fifo_full_sticky <= 1'b0;
        end
    end
end

// ===========================================================================
// 9. AXI-Lite write channel
//    Accept AW and W independently (standard AXI-Lite handshake).
//    Fire B response after both address and data are accepted.
//    ctrl_rst_health_r is a one-cycle pulse: set on qualifying write,
//    automatically cleared on the next clock — all within this single
//    always block to avoid multi-driver errors.
// ===========================================================================

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
        // Default: clear one-cycle signals
        s_axil_awready    <= 1'b0;
        s_axil_wready     <= 1'b0;
        ctrl_rst_health_r <= 1'b0;   // self-clear pulse each cycle

        // Accept write address
        if (s_axil_awvalid && !s_axil_awready && !aw_addr_pending) begin
            s_axil_awready  <= 1'b1;
            aw_addr_lat     <= s_axil_awaddr;
            aw_addr_pending <= 1'b1;
        end

        // Accept write data and perform register update
        if (s_axil_wvalid && aw_addr_pending && !s_axil_wready) begin
            s_axil_wready   <= 1'b1;
            aw_addr_pending <= 1'b0;
            s_axil_bvalid   <= 1'b1;
            s_axil_bresp    <= 2'b00;  // OKAY

            case (aw_addr_lat[11:0])
                12'h000: ;   // TRNG_DATA — read-only, ignore
                12'h004: ;   // TRNG_STAT — read-only, ignore
                12'h008: begin
                    // TRNG_CTRL — {29'h0, bypass_vn[2], test_mode[1], enable[0]}
                    // CTRL[3] = rst_health (write-1-to-pulse, not stored)
                    ctrl_enable_r    <= s_axil_wdata[0];
                    ctrl_test_mode_r <= s_axil_wdata[1];
                    ctrl_bypass_vn_r <= s_axil_wdata[2];
                    if (s_axil_wdata[3])
                        ctrl_rst_health_r <= 1'b1;
                end
                default: ;   // unmapped address — respond OKAY, no side effects
            endcase
        end

        // Hold bvalid until master accepts response
        if (s_axil_bvalid && s_axil_bready)
            s_axil_bvalid <= 1'b0;
    end
end

// ===========================================================================
// 10. AXI-Lite read channel
//     Accept AR and return data in the same clock cycle.
//     AXI read of 0x000 (TRNG_DATA) pulses axi_consume to clear trng_valid.
// ===========================================================================

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        s_axil_arready <= 1'b0;
        s_axil_rvalid  <= 1'b0;
        s_axil_rdata   <= 32'h0;
        s_axil_rresp   <= 2'b00;
        axi_consume    <= 1'b0;
    end else begin
        s_axil_arready <= 1'b0;
        axi_consume    <= 1'b0;   // default: no consume pulse

        if (s_axil_arvalid && !s_axil_arready) begin
            s_axil_arready <= 1'b1;
            s_axil_rvalid  <= 1'b1;
            s_axil_rresp   <= 2'b00;

            case (s_axil_araddr[11:0])
                12'h000: begin
                    // TRNG_DATA — consume semantics: read clears trng_valid
                    s_axil_rdata <= trng_data;
                    axi_consume  <= 1'b1;
                end
                12'h004: begin
                    // TRNG_STAT — {28'h0, fifo_full, apt_fail, rct_fail, valid}
                    s_axil_rdata <= {28'h0,
                                     fifo_full_sticky,
                                     apt_fail_sticky,
                                     rct_fail_sticky,
                                     trng_valid};
                end
                12'h008: begin
                    // TRNG_CTRL — {29'h0, bypass_vn, test_mode, enable}
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

        // Hold rvalid until master accepts data
        if (s_axil_rvalid && s_axil_rready)
            s_axil_rvalid <= 1'b0;
    end
end

endmodule

`default_nettype wire
