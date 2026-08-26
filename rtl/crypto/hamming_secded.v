`timescale 1ns/1ps
`default_nettype none

module hamming_enc (
    input  wire [31:0] din,
    output wire [38:0] dout
);

wire p0 = din[ 0] ^ din[ 1] ^ din[ 3] ^ din[ 4] ^ din[ 6] ^ din[ 8] ^ din[10] ^
          din[11] ^ din[13] ^ din[15] ^ din[17] ^ din[19] ^ din[21] ^ din[23] ^
          din[25] ^ din[26] ^ din[28] ^ din[30];

wire p1 = din[ 0] ^ din[ 2] ^ din[ 3] ^ din[ 5] ^ din[ 6] ^ din[ 9] ^ din[10] ^
          din[12] ^ din[13] ^ din[16] ^ din[17] ^ din[20] ^ din[21] ^ din[24] ^
          din[25] ^ din[27] ^ din[28] ^ din[31];

wire p2 = din[ 1] ^ din[ 2] ^ din[ 3] ^ din[ 7] ^ din[ 8] ^ din[ 9] ^ din[10] ^
          din[14] ^ din[15] ^ din[16] ^ din[17] ^ din[22] ^ din[23] ^ din[24] ^
          din[25] ^ din[29] ^ din[30] ^ din[31];

wire p3 = din[ 4] ^ din[ 5] ^ din[ 6] ^ din[ 7] ^ din[ 8] ^ din[ 9] ^ din[10] ^
          din[18] ^ din[19] ^ din[20] ^ din[21] ^ din[22] ^ din[23] ^ din[24] ^
          din[25];

wire p4 = din[11] ^ din[12] ^ din[13] ^ din[14] ^ din[15] ^ din[16] ^ din[17] ^
          din[18] ^ din[19] ^ din[20] ^ din[21] ^ din[22] ^ din[23] ^ din[24] ^
          din[25];

wire p5 = din[26] ^ din[27] ^ din[28] ^ din[29] ^ din[30] ^ din[31];

wire p6 = p0 ^ p1 ^ p2 ^ p3 ^ p4 ^ p5 ^
          din[ 0] ^ din[ 1] ^ din[ 2] ^ din[ 3] ^ din[ 4] ^ din[ 5] ^ din[ 6] ^ din[ 7] ^
          din[ 8] ^ din[ 9] ^ din[10] ^ din[11] ^ din[12] ^ din[13] ^ din[14] ^ din[15] ^
          din[16] ^ din[17] ^ din[18] ^ din[19] ^ din[20] ^ din[21] ^ din[22] ^ din[23] ^
          din[24] ^ din[25] ^ din[26] ^ din[27] ^ din[28] ^ din[29] ^ din[30] ^ din[31];

assign dout = {p6, p5, p4, p3, p2, p1, p0, din[31:0]};

endmodule

module hamming_dec (
    input  wire [38:0] din,
    output wire [31:0] dout,
    output wire        sec,
    output wire        ded
);

wire [31:0] data_r  = din[31: 0];
wire        p0_r    = din[32];
wire        p1_r    = din[33];
wire        p2_r    = din[34];
wire        p3_r    = din[35];
wire        p4_r    = din[36];
wire        p5_r    = din[37];
wire        p6_r    = din[38];

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

wire [5:0] syndrome = {p5_r ^ p5_c,
                        p4_r ^ p4_c,
                        p3_r ^ p3_c,
                        p2_r ^ p2_c,
                        p1_r ^ p1_c,
                        p0_r ^ p0_c};

wire s_overall = ^din;

assign sec = (|syndrome) &  s_overall;
assign ded = (|syndrome) & ~s_overall;

wire corr = sec;

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
