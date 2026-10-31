

`timescale 1ns/1ps
`default_nettype none

// verhoeff_check: hardware module definition
module verhoeff_check (
    input  wire [47:0] digits,
    output wire        verhoeff_ok,
    output wire        first_digit_ok,
    output wire        valid
);
// d_lut: combinational helper function
function [3:0] d_lut;
    input [3:0] a, b;
    begin
        case ({a[3:0], b[3:0]})
            8'h00: d_lut=0; 8'h01: d_lut=1; 8'h02: d_lut=2; 8'h03: d_lut=3;
            8'h04: d_lut=4; 8'h05: d_lut=5; 8'h06: d_lut=6; 8'h07: d_lut=7;
            8'h08: d_lut=8; 8'h09: d_lut=9;
            8'h10: d_lut=1; 8'h11: d_lut=2; 8'h12: d_lut=3; 8'h13: d_lut=4;
            8'h14: d_lut=0; 8'h15: d_lut=6; 8'h16: d_lut=7; 8'h17: d_lut=8;
            8'h18: d_lut=9; 8'h19: d_lut=5;
            8'h20: d_lut=2; 8'h21: d_lut=3; 8'h22: d_lut=4; 8'h23: d_lut=0;
            8'h24: d_lut=1; 8'h25: d_lut=7; 8'h26: d_lut=8; 8'h27: d_lut=9;
            8'h28: d_lut=5; 8'h29: d_lut=6;
            8'h30: d_lut=3; 8'h31: d_lut=4; 8'h32: d_lut=0; 8'h33: d_lut=1;
            8'h34: d_lut=2; 8'h35: d_lut=8; 8'h36: d_lut=9; 8'h37: d_lut=5;
            8'h38: d_lut=6; 8'h39: d_lut=7;
            8'h40: d_lut=4; 8'h41: d_lut=0; 8'h42: d_lut=1; 8'h43: d_lut=2;
            8'h44: d_lut=3; 8'h45: d_lut=9; 8'h46: d_lut=5; 8'h47: d_lut=6;
            8'h48: d_lut=7; 8'h49: d_lut=8;
            8'h50: d_lut=5; 8'h51: d_lut=9; 8'h52: d_lut=8; 8'h53: d_lut=7;
            8'h54: d_lut=6; 8'h55: d_lut=0; 8'h56: d_lut=4; 8'h57: d_lut=3;
            8'h58: d_lut=2; 8'h59: d_lut=1;
            8'h60: d_lut=6; 8'h61: d_lut=5; 8'h62: d_lut=9; 8'h63: d_lut=8;
            8'h64: d_lut=7; 8'h65: d_lut=1; 8'h66: d_lut=0; 8'h67: d_lut=4;
            8'h68: d_lut=3; 8'h69: d_lut=2;
            8'h70: d_lut=7; 8'h71: d_lut=6; 8'h72: d_lut=5; 8'h73: d_lut=9;
            8'h74: d_lut=8; 8'h75: d_lut=2; 8'h76: d_lut=1; 8'h77: d_lut=0;
            8'h78: d_lut=4; 8'h79: d_lut=3;
            8'h80: d_lut=8; 8'h81: d_lut=7; 8'h82: d_lut=6; 8'h83: d_lut=5;
            8'h84: d_lut=9; 8'h85: d_lut=3; 8'h86: d_lut=2; 8'h87: d_lut=1;
            8'h88: d_lut=0; 8'h89: d_lut=4;
            8'h90: d_lut=9; 8'h91: d_lut=8; 8'h92: d_lut=7; 8'h93: d_lut=6;
            8'h94: d_lut=5; 8'h95: d_lut=4; 8'h96: d_lut=3; 8'h97: d_lut=2;
            8'h98: d_lut=1; 8'h99: d_lut=0;
            default: d_lut = 4'd0;
        endcase
    end
endfunction
// p_lut: combinational helper function
function [3:0] p_lut;
    input [2:0] pos;
    input [3:0] digit;
    begin
        case ({pos, digit[3:0]})
            7'h00: p_lut=0; 7'h01: p_lut=1; 7'h02: p_lut=2; 7'h03: p_lut=3;
            7'h04: p_lut=4; 7'h05: p_lut=5; 7'h06: p_lut=6; 7'h07: p_lut=7;
            7'h08: p_lut=8; 7'h09: p_lut=9;
            7'h10: p_lut=1; 7'h11: p_lut=5; 7'h12: p_lut=7; 7'h13: p_lut=6;
            7'h14: p_lut=2; 7'h15: p_lut=8; 7'h16: p_lut=3; 7'h17: p_lut=0;
            7'h18: p_lut=9; 7'h19: p_lut=4;
            7'h20: p_lut=5; 7'h21: p_lut=8; 7'h22: p_lut=0; 7'h23: p_lut=3;
            7'h24: p_lut=7; 7'h25: p_lut=9; 7'h26: p_lut=6; 7'h27: p_lut=1;
            7'h28: p_lut=4; 7'h29: p_lut=2;
            7'h30: p_lut=8; 7'h31: p_lut=9; 7'h32: p_lut=1; 7'h33: p_lut=6;
            7'h34: p_lut=0; 7'h35: p_lut=4; 7'h36: p_lut=3; 7'h37: p_lut=5;
            7'h38: p_lut=2; 7'h39: p_lut=7;
            7'h40: p_lut=9; 7'h41: p_lut=4; 7'h42: p_lut=5; 7'h43: p_lut=3;
            7'h44: p_lut=1; 7'h45: p_lut=2; 7'h46: p_lut=6; 7'h47: p_lut=8;
            7'h48: p_lut=7; 7'h49: p_lut=0;
            7'h50: p_lut=4; 7'h51: p_lut=2; 7'h52: p_lut=8; 7'h53: p_lut=6;
            7'h54: p_lut=5; 7'h55: p_lut=7; 7'h56: p_lut=3; 7'h57: p_lut=9;
            7'h58: p_lut=0; 7'h59: p_lut=1;
            7'h60: p_lut=2; 7'h61: p_lut=7; 7'h62: p_lut=9; 7'h63: p_lut=3;
            7'h64: p_lut=8; 7'h65: p_lut=0; 7'h66: p_lut=6; 7'h67: p_lut=4;
            7'h68: p_lut=1; 7'h69: p_lut=5;
            7'h70: p_lut=7; 7'h71: p_lut=0; 7'h72: p_lut=4; 7'h73: p_lut=6;
            7'h74: p_lut=9; 7'h75: p_lut=1; 7'h76: p_lut=3; 7'h77: p_lut=2;
            7'h78: p_lut=5; 7'h79: p_lut=8;
            default: p_lut = 4'd0;
        endcase
    end
endfunction
wire [3:0] rev [0:11];
assign rev[0]  = digits[3:0];
assign rev[1]  = digits[7:4];
assign rev[2]  = digits[11:8];
assign rev[3]  = digits[15:12];
assign rev[4]  = digits[19:16];
assign rev[5]  = digits[23:20];
assign rev[6]  = digits[27:24];
assign rev[7]  = digits[31:28];
assign rev[8]  = digits[35:32];
assign rev[9]  = digits[39:36];
assign rev[10] = digits[43:40];
assign rev[11] = digits[47:44];
wire [3:0] c [0:12];
assign c[0] = 4'd0;

genvar gi;
generate
    for (gi = 0; gi < 12; gi = gi + 1) begin : VH
        assign c[gi+1] = d_lut(c[gi], p_lut(gi[2:0], rev[gi]));
    end
endgenerate

assign verhoeff_ok    = (c[12] == 4'd0);
assign first_digit_ok = (rev[11] >= 4'd2);
assign valid          = verhoeff_ok & first_digit_ok;

endmodule
