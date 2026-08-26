// =============================================================================
// hamming_secded.v — Hamming(39,32) SEC-DED Encoder / Decoder
// Project  : INDIA_CRYPTO_SOC — SRAM ECC protection
// Process  : TSMC 28nm HPC
//
// Protects against:
//   • Single-bit flips from cosmic rays (SEU), alpha particles, laser fault
//     injection targeting SRAM cells — automatically CORRECTED in hardware.
//   • Double-bit flips (EMFI / LFI with two targets) — DETECTED, fatal IRQ.
//
// Codeword format (39 bits stored per 32-bit SRAM word):
//   bits [31: 0] = data[31:0]
//   bits [37:32] = {p5, p4, p3, p2, p1, p0}  — 6 Hamming SEC parity bits
//   bit  [38]    = p6                          — 1 overall parity (DED)
//
// Hamming position map (1-indexed, powers-of-2 = parity):
//   Pos  1=p0  2=p1  3=d0  4=p2  5=d1  6=d2  7=d3  8=p3
//   Pos  9=d4 10=d5 11=d6 12=d7 13=d8 14=d9 15=d10 16=p4
//   Pos 17=d11 18=d12 19=d13 20=d14 21=d15 22=d16 23=d17
//   Pos 24=d18 25=d19 26=d20 27=d21 28=d22 29=d23 30=d24 31=d25
//   Pos 32=p5 33=d26 34=d27 35=d28 36=d29 37=d30 38=d31
//   Pos  0=p6 (overall parity, stored at bit[38] of codeword)
//
// Encoder area  : ~250 gates (XOR trees, combinational only)
// Decoder area  : ~450 gates (XOR trees + 32-mux corrector)
// Latency       : 0 pipeline stages (pure combinational)
// SRAM overhead : +21.9% bits (+7/32), ~+6% total SRAM area at 28nm
// =============================================================================

`timescale 1ns/1ps
`default_nettype none

// =============================================================================
// hamming_enc — Hamming(39,32) Encoder
// =============================================================================
module hamming_enc (
    input  wire [31:0] din,    // 32-bit raw data to store
    output wire [38:0] dout    // 39-bit SEC-DED codeword
);

// ---------------------------------------------------------------------------
// 6 Hamming parity bits (SEC)
// Each parity bit p[i] covers all positions where bit i of the position
// index is 1.  Positions that are powers-of-2 (the parity positions
// themselves) are excluded from each other's coverage.
// ---------------------------------------------------------------------------

// p0 covers positions where bit0=1: 3,5,7,9,11,13,15,17,19,21,23,25,27,29,31,33,35,37
// → data bits: d0 d1 d3 d4 d6 d8 d10 d11 d13 d15 d17 d19 d21 d23 d25 d26 d28 d30
wire p0 = din[ 0] ^ din[ 1] ^ din[ 3] ^ din[ 4] ^ din[ 6] ^ din[ 8] ^ din[10] ^
          din[11] ^ din[13] ^ din[15] ^ din[17] ^ din[19] ^ din[21] ^ din[23] ^
          din[25] ^ din[26] ^ din[28] ^ din[30];

// p1 covers positions where bit1=1: 3,6,7,10,11,14,15,18,19,22,23,26,27,30,31,34,35,38
// → data bits: d0 d2 d3 d5 d6 d9 d10 d12 d13 d16 d17 d20 d21 d24 d25 d27 d28 d31
wire p1 = din[ 0] ^ din[ 2] ^ din[ 3] ^ din[ 5] ^ din[ 6] ^ din[ 9] ^ din[10] ^
          din[12] ^ din[13] ^ din[16] ^ din[17] ^ din[20] ^ din[21] ^ din[24] ^
          din[25] ^ din[27] ^ din[28] ^ din[31];

// p2 covers positions where bit2=1: 5,6,7,12,13,14,15,20,21,22,23,28,29,30,31,36,37,38
// → data bits: d1 d2 d3 d7 d8 d9 d10 d14 d15 d16 d17 d22 d23 d24 d25 d29 d30 d31
wire p2 = din[ 1] ^ din[ 2] ^ din[ 3] ^ din[ 7] ^ din[ 8] ^ din[ 9] ^ din[10] ^
          din[14] ^ din[15] ^ din[16] ^ din[17] ^ din[22] ^ din[23] ^ din[24] ^
          din[25] ^ din[29] ^ din[30] ^ din[31];

// p3 covers positions where bit3=1: 9,10,11,12,13,14,15,24,25,26,27,28,29,30,31
// → data bits: d4 d5 d6 d7 d8 d9 d10 d18 d19 d20 d21 d22 d23 d24 d25
wire p3 = din[ 4] ^ din[ 5] ^ din[ 6] ^ din[ 7] ^ din[ 8] ^ din[ 9] ^ din[10] ^
          din[18] ^ din[19] ^ din[20] ^ din[21] ^ din[22] ^ din[23] ^ din[24] ^
          din[25];

// p4 covers positions where bit4=1: 17..31
// → data bits: d11 d12 d13 d14 d15 d16 d17 d18 d19 d20 d21 d22 d23 d24 d25
wire p4 = din[11] ^ din[12] ^ din[13] ^ din[14] ^ din[15] ^ din[16] ^ din[17] ^
          din[18] ^ din[19] ^ din[20] ^ din[21] ^ din[22] ^ din[23] ^ din[24] ^
          din[25];

// p5 covers positions where bit5=1: 33,34,35,36,37,38
// → data bits: d26 d27 d28 d29 d30 d31
wire p5 = din[26] ^ din[27] ^ din[28] ^ din[29] ^ din[30] ^ din[31];

// ---------------------------------------------------------------------------
// Overall parity bit (DED)
// p6 = XOR of all 38 codeword bits (p0..p5 + d0..d31)
// Odd syndrome + p6=1 → single-bit error (correctable)
// Odd syndrome + p6=0 → double-bit error (uncorrectable)
// ---------------------------------------------------------------------------
wire p6 = p0 ^ p1 ^ p2 ^ p3 ^ p4 ^ p5 ^
          din[ 0] ^ din[ 1] ^ din[ 2] ^ din[ 3] ^ din[ 4] ^ din[ 5] ^ din[ 6] ^ din[ 7] ^
          din[ 8] ^ din[ 9] ^ din[10] ^ din[11] ^ din[12] ^ din[13] ^ din[14] ^ din[15] ^
          din[16] ^ din[17] ^ din[18] ^ din[19] ^ din[20] ^ din[21] ^ din[22] ^ din[23] ^
          din[24] ^ din[25] ^ din[26] ^ din[27] ^ din[28] ^ din[29] ^ din[30] ^ din[31];

// ---------------------------------------------------------------------------
// Pack codeword: [38]=p6  [37:32]={p5,p4,p3,p2,p1,p0}  [31:0]=data
// ---------------------------------------------------------------------------
assign dout = {p6, p5, p4, p3, p2, p1, p0, din[31:0]};

endmodule


// =============================================================================
// hamming_dec — Hamming(39,32) Decoder
// =============================================================================
module hamming_dec (
    input  wire [38:0] din,    // 39-bit SEC-DED codeword from SRAM
    output wire [31:0] dout,   // 32-bit corrected output data
    output wire        sec,    // 1 = single-bit error corrected (non-fatal)
    output wire        ded     // 1 = double-bit error detected  (fatal → IRQ)
);

// ---------------------------------------------------------------------------
// Unpack codeword
// ---------------------------------------------------------------------------
wire [31:0] data_r  = din[31: 0];   // received data bits
wire        p0_r    = din[32];      // received parity bit 0
wire        p1_r    = din[33];      // received parity bit 1
wire        p2_r    = din[34];
wire        p3_r    = din[35];
wire        p4_r    = din[36];
wire        p5_r    = din[37];
wire        p6_r    = din[38];      // received overall parity

// ---------------------------------------------------------------------------
// Recompute parity from received data (same equations as encoder)
// ---------------------------------------------------------------------------
wire p0_c = data_r[ 0] ^ data_r[ 1] ^ data_r[ 3] ^ data_r[ 4] ^ data_r[ 6] ^
            data_r[ 8] ^ data_r[10] ^ data_r[11] ^ data_r[13] ^ data_r[15] ^
            data_r[17] ^ data_r[19] ^ data_r[21] ^ data_r[23] ^ data_r[25] ^
            data_r[26] ^ data_r[28] ^ data_r[30];

wire p1_c = data_r[ 0] ^ data_r[ 2] ^ data_r[ 3] ^ data_r[ 5] ^ data_r[ 6] ^
            data_r[ 9] ^ data_r[10] ^ data_r[12] ^ data_r[13] ^ data_r[16] ^
            data_r[17] ^ data_r[20] ^ data_r[21] ^ data_r[24] ^ data_r[25] ^
            data_r[27] ^ data_r[28] ^ data_r[31];

wire p2_c = data_r[ 1] ^ data_r[ 2] ^ data_r[ 3] ^ data_r[ 7] ^ data_r[ 8] ^
            data_r[ 9] ^ data_r[10] ^ data_r[14] ^ data_r[15] ^ data_r[16] ^
            data_r[17] ^ data_r[22] ^ data_r[23] ^ data_r[24] ^ data_r[25] ^
            data_r[29] ^ data_r[30] ^ data_r[31];

wire p3_c = data_r[ 4] ^ data_r[ 5] ^ data_r[ 6] ^ data_r[ 7] ^ data_r[ 8] ^
            data_r[ 9] ^ data_r[10] ^ data_r[18] ^ data_r[19] ^ data_r[20] ^
            data_r[21] ^ data_r[22] ^ data_r[23] ^ data_r[24] ^ data_r[25];

wire p4_c = data_r[11] ^ data_r[12] ^ data_r[13] ^ data_r[14] ^ data_r[15] ^
            data_r[16] ^ data_r[17] ^ data_r[18] ^ data_r[19] ^ data_r[20] ^
            data_r[21] ^ data_r[22] ^ data_r[23] ^ data_r[24] ^ data_r[25];

wire p5_c = data_r[26] ^ data_r[27] ^ data_r[28] ^ data_r[29] ^ data_r[30] ^
            data_r[31];

// ---------------------------------------------------------------------------
// 6-bit syndrome = received XOR computed
// syndrome value = position of the flipped bit (1-indexed Hamming position)
// syndrome = 0 → no error in data or parity bits
// ---------------------------------------------------------------------------
wire [5:0] syndrome = {p5_r ^ p5_c,
                        p4_r ^ p4_c,
                        p3_r ^ p3_c,
                        p2_r ^ p2_c,
                        p1_r ^ p1_c,
                        p0_r ^ p0_c};

// ---------------------------------------------------------------------------
// Overall parity check: XOR of all 39 received bits.
// A valid codeword has even parity → result = 0 (no error).
// Any single-bit flip toggles this to 1 (odd), distinguishing SEC from DED.
//
// BUG FIX: the previous implementation recomputed p6_c from the recomputed
// (not received) parity bits, then did p6_r ^ p6_c.  For a data-bit flip,
// the recomputed parity bits absorb the error, so p6_c ends up equal to
// p6_r and s_overall becomes 0 — wrongly classifying every data-bit SBE
// as a double-bit error (DED).  Using ^din directly is correct and minimal.
// ---------------------------------------------------------------------------
wire s_overall = ^din;

// ---------------------------------------------------------------------------
// Error classification
//   syndrome == 0 && s_overall == 0  → no error
//   syndrome != 0 && s_overall == 1  → SEC: single-bit correctable
//   syndrome != 0 && s_overall == 0  → DED: double-bit uncorrectable
//   syndrome == 0 && s_overall == 1  → error in p6 itself, data OK
// ---------------------------------------------------------------------------
assign sec = (|syndrome) &  s_overall;
assign ded = (|syndrome) & ~s_overall;

// ---------------------------------------------------------------------------
// Single-bit correction
// For each data bit di at Hamming position pos[i], flip it if syndrome==pos[i]
// Parity-bit positions (1,2,4,8,16,32) — if syndrome points there, data is fine
// ---------------------------------------------------------------------------
// Syndrome → Hamming position → data index mapping:
//   syndrome 6'd03 → d0   6'd05 → d1   6'd06 → d2   6'd07 → d3
//   syndrome 6'd09 → d4   6'd10 → d5   6'd11 → d6   6'd12 → d7
//   syndrome 6'd13 → d8   6'd14 → d9   6'd15 → d10
//   syndrome 6'd17 → d11  6'd18 → d12  6'd19 → d13  6'd20 → d14
//   syndrome 6'd21 → d15  6'd22 → d16  6'd23 → d17
//   syndrome 6'd24 → d18  6'd25 → d19  6'd26 → d20  6'd27 → d21
//   syndrome 6'd28 → d22  6'd29 → d23  6'd30 → d24  6'd31 → d25
//   syndrome 6'd33 → d26  6'd34 → d27  6'd35 → d28
//   syndrome 6'd36 → d29  6'd37 → d30  6'd38 → d31

wire corr = sec;   // only correct when exactly single-bit error

assign dout[ 0] = data_r[ 0] ^ (corr & (syndrome == 6'd3 ));
assign dout[ 1] = data_r[ 1] ^ (corr & (syndrome == 6'd5 ));
assign dout[ 2] = data_r[ 2] ^ (corr & (syndrome == 6'd6 ));
assign dout[ 3] = data_r[ 3] ^ (corr & (syndrome == 6'd7 ));
assign dout[ 4] = data_r[ 4] ^ (corr & (syndrome == 6'd9 ));
assign dout[ 5] = data_r[ 5] ^ (corr & (syndrome == 6'd10));
assign dout[ 6] = data_r[ 6] ^ (corr & (syndrome == 6'd11));
assign dout[ 7] = data_r[ 7] ^ (corr & (syndrome == 6'd12));
assign dout[ 8] = data_r[ 8] ^ (corr & (syndrome == 6'd13));
assign dout[ 9] = data_r[ 9] ^ (corr & (syndrome == 6'd14));
assign dout[10] = data_r[10] ^ (corr & (syndrome == 6'd15));
assign dout[11] = data_r[11] ^ (corr & (syndrome == 6'd17));
assign dout[12] = data_r[12] ^ (corr & (syndrome == 6'd18));
assign dout[13] = data_r[13] ^ (corr & (syndrome == 6'd19));
assign dout[14] = data_r[14] ^ (corr & (syndrome == 6'd20));
assign dout[15] = data_r[15] ^ (corr & (syndrome == 6'd21));
assign dout[16] = data_r[16] ^ (corr & (syndrome == 6'd22));
assign dout[17] = data_r[17] ^ (corr & (syndrome == 6'd23));
assign dout[18] = data_r[18] ^ (corr & (syndrome == 6'd24));
assign dout[19] = data_r[19] ^ (corr & (syndrome == 6'd25));
assign dout[20] = data_r[20] ^ (corr & (syndrome == 6'd26));
assign dout[21] = data_r[21] ^ (corr & (syndrome == 6'd27));
assign dout[22] = data_r[22] ^ (corr & (syndrome == 6'd28));
assign dout[23] = data_r[23] ^ (corr & (syndrome == 6'd29));
assign dout[24] = data_r[24] ^ (corr & (syndrome == 6'd30));
assign dout[25] = data_r[25] ^ (corr & (syndrome == 6'd31));
assign dout[26] = data_r[26] ^ (corr & (syndrome == 6'd33));
assign dout[27] = data_r[27] ^ (corr & (syndrome == 6'd34));
assign dout[28] = data_r[28] ^ (corr & (syndrome == 6'd35));
assign dout[29] = data_r[29] ^ (corr & (syndrome == 6'd36));
assign dout[30] = data_r[30] ^ (corr & (syndrome == 6'd37));
assign dout[31] = data_r[31] ^ (corr & (syndrome == 6'd38));

endmodule
`default_nettype wire
