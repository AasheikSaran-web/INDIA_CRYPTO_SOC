// =============================================================================
// aes_isa_ext.v
// Custom AES ISA Extension Execution Unit
// Plugs into rv32im_core's custom-0 sideband port
//
// Opcode: 7'b0001011 (custom-0), R-type format
//
// Instructions (funct7 + funct3):
//   aes.esb   funct7=7'b0000000 funct3=3'b000 : Forward SubBytes on selected byte of rs1
//   aes.emx   funct7=7'b0000001 funct3=3'b000 : MixColumns byte on sbox(selected byte)
//   aes.esr   funct7=7'b0000010 funct3=3'b000 : ShiftRows partial: rotate-left 8 bits
//   aes.dsb   funct7=7'b0000100 funct3=3'b000 : Inverse SubBytes on selected byte
//   aes.dmx   funct7=7'b0000101 funct3=3'b000 : Inverse MixColumns byte on selected byte
//   aes.disr  funct7=7'b0000110 funct3=3'b000 : Rotate-right 8 bits (InvShiftRows partial)
//   aes.xk    funct7=7'b0000111 funct3=3'b000 : rs1 XOR rs2 (AddRoundKey)
//   aes.rcon  funct7=7'b0001000 funct3=3'b000 : RCON for round rs2[3:0]
//
// Purely combinational. custom_rd_valid is high whenever custom_valid is high.
// =============================================================================

`default_nettype none
`timescale 1ns/1ps

module aes_isa_ext (
    // Sideband from rv32im_core
    input  wire        custom_valid,
    input  wire [31:0] custom_instr,
    input  wire [31:0] custom_rs1,
    input  wire [31:0] custom_rs2,

    // Result back to rv32im_core
    output reg  [31:0] custom_rd,
    output wire        custom_rd_valid
);

// custom_rd_valid is purely combinational
assign custom_rd_valid = custom_valid;

// Decode instruction fields
wire [6:0] funct7 = custom_instr[31:25];
wire [2:0] funct3 = custom_instr[14:12];
wire [4:0] rs2f   = custom_instr[24:20]; // rs2 field in instruction encoding
// Byte selector: use rs2[1:0] runtime value for byte selection
wire [1:0] byte_sel = custom_rs2[1:0];

// =============================================================================
// GF(2^8) arithmetic (irreducible polynomial: x^8 + x^4 + x^3 + x + 1 = 0x11B)
// =============================================================================

// xtime: multiply by x in GF(2^8)
function [7:0] xtime;
    input [7:0] b;
    begin
        xtime = (b[7]) ? ((b << 1) ^ 8'h1B) : (b << 1);
    end
endfunction

// GF multiply by 2
function [7:0] gf_mul2;
    input [7:0] b;
    begin
        gf_mul2 = xtime(b);
    end
endfunction

// GF multiply by 3 = xtime(b) ^ b
function [7:0] gf_mul3;
    input [7:0] b;
    begin
        gf_mul3 = xtime(b) ^ b;
    end
endfunction

// GF multiply by 9 = mul8(b) ^ b = xtime(xtime(xtime(b))) ^ b
function [7:0] gf_mul9;
    input [7:0] b;
    reg [7:0] t2, t4, t8;
    begin
        t2 = xtime(b);
        t4 = xtime(t2);
        t8 = xtime(t4);
        gf_mul9 = t8 ^ b;
    end
endfunction

// GF multiply by 11 (0x0B) = mul8 ^ mul2 ^ b
function [7:0] gf_mul11;
    input [7:0] b;
    reg [7:0] t2, t4, t8;
    begin
        t2 = xtime(b);
        t4 = xtime(t2);
        t8 = xtime(t4);
        gf_mul11 = t8 ^ t2 ^ b;
    end
endfunction

// GF multiply by 13 (0x0D) = mul8 ^ mul4 ^ b
function [7:0] gf_mul13;
    input [7:0] b;
    reg [7:0] t2, t4, t8;
    begin
        t2 = xtime(b);
        t4 = xtime(t2);
        t8 = xtime(t4);
        gf_mul13 = t8 ^ t4 ^ b;
    end
endfunction

// GF multiply by 14 (0x0E) = mul8 ^ mul4 ^ mul2
function [7:0] gf_mul14;
    input [7:0] b;
    reg [7:0] t2, t4, t8;
    begin
        t2 = xtime(b);
        t4 = xtime(t2);
        t8 = xtime(t4);
        gf_mul14 = t8 ^ t4 ^ t2;
    end
endfunction

// =============================================================================
// AES Forward S-box (256 entries)
// =============================================================================
function [7:0] sbox_fwd;
    input [7:0] x;
    begin
        case (x)
            8'h00:sbox_fwd=8'h63; 8'h01:sbox_fwd=8'h7c; 8'h02:sbox_fwd=8'h77; 8'h03:sbox_fwd=8'h7b;
            8'h04:sbox_fwd=8'hf2; 8'h05:sbox_fwd=8'h6b; 8'h06:sbox_fwd=8'h6f; 8'h07:sbox_fwd=8'hc5;
            8'h08:sbox_fwd=8'h30; 8'h09:sbox_fwd=8'h01; 8'h0a:sbox_fwd=8'h67; 8'h0b:sbox_fwd=8'h2b;
            8'h0c:sbox_fwd=8'hfe; 8'h0d:sbox_fwd=8'hd7; 8'h0e:sbox_fwd=8'hab; 8'h0f:sbox_fwd=8'h76;
            8'h10:sbox_fwd=8'hca; 8'h11:sbox_fwd=8'h82; 8'h12:sbox_fwd=8'hc9; 8'h13:sbox_fwd=8'h7d;
            8'h14:sbox_fwd=8'hfa; 8'h15:sbox_fwd=8'h59; 8'h16:sbox_fwd=8'h47; 8'h17:sbox_fwd=8'hf0;
            8'h18:sbox_fwd=8'had; 8'h19:sbox_fwd=8'hd4; 8'h1a:sbox_fwd=8'ha2; 8'h1b:sbox_fwd=8'haf;
            8'h1c:sbox_fwd=8'h9c; 8'h1d:sbox_fwd=8'ha4; 8'h1e:sbox_fwd=8'h72; 8'h1f:sbox_fwd=8'hc0;
            8'h20:sbox_fwd=8'hb7; 8'h21:sbox_fwd=8'hfd; 8'h22:sbox_fwd=8'h93; 8'h23:sbox_fwd=8'h26;
            8'h24:sbox_fwd=8'h36; 8'h25:sbox_fwd=8'h3f; 8'h26:sbox_fwd=8'hf7; 8'h27:sbox_fwd=8'hcc;
            8'h28:sbox_fwd=8'h34; 8'h29:sbox_fwd=8'ha5; 8'h2a:sbox_fwd=8'he5; 8'h2b:sbox_fwd=8'hf1;
            8'h2c:sbox_fwd=8'h71; 8'h2d:sbox_fwd=8'hd8; 8'h2e:sbox_fwd=8'h31; 8'h2f:sbox_fwd=8'h15;
            8'h30:sbox_fwd=8'h04; 8'h31:sbox_fwd=8'hc7; 8'h32:sbox_fwd=8'h23; 8'h33:sbox_fwd=8'hc3;
            8'h34:sbox_fwd=8'h18; 8'h35:sbox_fwd=8'h96; 8'h36:sbox_fwd=8'h05; 8'h37:sbox_fwd=8'h9a;
            8'h38:sbox_fwd=8'h07; 8'h39:sbox_fwd=8'h12; 8'h3a:sbox_fwd=8'h80; 8'h3b:sbox_fwd=8'he2;
            8'h3c:sbox_fwd=8'heb; 8'h3d:sbox_fwd=8'h27; 8'h3e:sbox_fwd=8'hb2; 8'h3f:sbox_fwd=8'h75;
            8'h40:sbox_fwd=8'h09; 8'h41:sbox_fwd=8'h83; 8'h42:sbox_fwd=8'h2c; 8'h43:sbox_fwd=8'h1a;
            8'h44:sbox_fwd=8'h1b; 8'h45:sbox_fwd=8'h6e; 8'h46:sbox_fwd=8'h5a; 8'h47:sbox_fwd=8'ha0;
            8'h48:sbox_fwd=8'h52; 8'h49:sbox_fwd=8'h3b; 8'h4a:sbox_fwd=8'hd6; 8'h4b:sbox_fwd=8'hb3;
            8'h4c:sbox_fwd=8'h29; 8'h4d:sbox_fwd=8'he3; 8'h4e:sbox_fwd=8'h2f; 8'h4f:sbox_fwd=8'h84;
            8'h50:sbox_fwd=8'h53; 8'h51:sbox_fwd=8'hd1; 8'h52:sbox_fwd=8'h00; 8'h53:sbox_fwd=8'hed;
            8'h54:sbox_fwd=8'h20; 8'h55:sbox_fwd=8'hfc; 8'h56:sbox_fwd=8'hb1; 8'h57:sbox_fwd=8'h5b;
            8'h58:sbox_fwd=8'h6a; 8'h59:sbox_fwd=8'hcb; 8'h5a:sbox_fwd=8'hbe; 8'h5b:sbox_fwd=8'h39;
            8'h5c:sbox_fwd=8'h4a; 8'h5d:sbox_fwd=8'h4c; 8'h5e:sbox_fwd=8'h58; 8'h5f:sbox_fwd=8'hcf;
            8'h60:sbox_fwd=8'hd0; 8'h61:sbox_fwd=8'hef; 8'h62:sbox_fwd=8'haa; 8'h63:sbox_fwd=8'hfb;
            8'h64:sbox_fwd=8'h43; 8'h65:sbox_fwd=8'h4d; 8'h66:sbox_fwd=8'h33; 8'h67:sbox_fwd=8'h85;
            8'h68:sbox_fwd=8'h45; 8'h69:sbox_fwd=8'hf9; 8'h6a:sbox_fwd=8'h02; 8'h6b:sbox_fwd=8'h7f;
            8'h6c:sbox_fwd=8'h50; 8'h6d:sbox_fwd=8'h3c; 8'h6e:sbox_fwd=8'h9f; 8'h6f:sbox_fwd=8'ha8;
            8'h70:sbox_fwd=8'h51; 8'h71:sbox_fwd=8'ha3; 8'h72:sbox_fwd=8'h40; 8'h73:sbox_fwd=8'h8f;
            8'h74:sbox_fwd=8'h92; 8'h75:sbox_fwd=8'h9d; 8'h76:sbox_fwd=8'h38; 8'h77:sbox_fwd=8'hf5;
            8'h78:sbox_fwd=8'hbc; 8'h79:sbox_fwd=8'hb6; 8'h7a:sbox_fwd=8'hda; 8'h7b:sbox_fwd=8'h21;
            8'h7c:sbox_fwd=8'h10; 8'h7d:sbox_fwd=8'hff; 8'h7e:sbox_fwd=8'hf3; 8'h7f:sbox_fwd=8'hd2;
            8'h80:sbox_fwd=8'hcd; 8'h81:sbox_fwd=8'h0c; 8'h82:sbox_fwd=8'h13; 8'h83:sbox_fwd=8'hec;
            8'h84:sbox_fwd=8'h5f; 8'h85:sbox_fwd=8'h97; 8'h86:sbox_fwd=8'h44; 8'h87:sbox_fwd=8'h17;
            8'h88:sbox_fwd=8'hc4; 8'h89:sbox_fwd=8'ha7; 8'h8a:sbox_fwd=8'h7e; 8'h8b:sbox_fwd=8'h3d;
            8'h8c:sbox_fwd=8'h64; 8'h8d:sbox_fwd=8'h5d; 8'h8e:sbox_fwd=8'h19; 8'h8f:sbox_fwd=8'h73;
            8'h90:sbox_fwd=8'h60; 8'h91:sbox_fwd=8'h81; 8'h92:sbox_fwd=8'h4f; 8'h93:sbox_fwd=8'hdc;
            8'h94:sbox_fwd=8'h22; 8'h95:sbox_fwd=8'h2a; 8'h96:sbox_fwd=8'h90; 8'h97:sbox_fwd=8'h88;
            8'h98:sbox_fwd=8'h46; 8'h99:sbox_fwd=8'hee; 8'h9a:sbox_fwd=8'hb8; 8'h9b:sbox_fwd=8'h14;
            8'h9c:sbox_fwd=8'hde; 8'h9d:sbox_fwd=8'h5e; 8'h9e:sbox_fwd=8'h0b; 8'h9f:sbox_fwd=8'hdb;
            8'ha0:sbox_fwd=8'he0; 8'ha1:sbox_fwd=8'h32; 8'ha2:sbox_fwd=8'h3a; 8'ha3:sbox_fwd=8'h0a;
            8'ha4:sbox_fwd=8'h49; 8'ha5:sbox_fwd=8'h06; 8'ha6:sbox_fwd=8'h24; 8'ha7:sbox_fwd=8'h5c;
            8'ha8:sbox_fwd=8'hc2; 8'ha9:sbox_fwd=8'hd3; 8'haa:sbox_fwd=8'hac; 8'hab:sbox_fwd=8'h62;
            8'hac:sbox_fwd=8'h91; 8'had:sbox_fwd=8'h95; 8'hae:sbox_fwd=8'he4; 8'haf:sbox_fwd=8'h79;
            8'hb0:sbox_fwd=8'he7; 8'hb1:sbox_fwd=8'hc8; 8'hb2:sbox_fwd=8'h37; 8'hb3:sbox_fwd=8'h6d;
            8'hb4:sbox_fwd=8'h8d; 8'hb5:sbox_fwd=8'hd5; 8'hb6:sbox_fwd=8'h4e; 8'hb7:sbox_fwd=8'ha9;
            8'hb8:sbox_fwd=8'h6c; 8'hb9:sbox_fwd=8'h56; 8'hba:sbox_fwd=8'hf4; 8'hbb:sbox_fwd=8'hea;
            8'hbc:sbox_fwd=8'h65; 8'hbd:sbox_fwd=8'h7a; 8'hbe:sbox_fwd=8'hae; 8'hbf:sbox_fwd=8'h08;
            8'hc0:sbox_fwd=8'hba; 8'hc1:sbox_fwd=8'h78; 8'hc2:sbox_fwd=8'h25; 8'hc3:sbox_fwd=8'h2e;
            8'hc4:sbox_fwd=8'h1c; 8'hc5:sbox_fwd=8'ha6; 8'hc6:sbox_fwd=8'hb4; 8'hc7:sbox_fwd=8'hc6;
            8'hc8:sbox_fwd=8'he8; 8'hc9:sbox_fwd=8'hdd; 8'hca:sbox_fwd=8'h74; 8'hcb:sbox_fwd=8'h1f;
            8'hcc:sbox_fwd=8'h4b; 8'hcd:sbox_fwd=8'hbd; 8'hce:sbox_fwd=8'h8b; 8'hcf:sbox_fwd=8'h8a;
            8'hd0:sbox_fwd=8'h70; 8'hd1:sbox_fwd=8'h3e; 8'hd2:sbox_fwd=8'hb5; 8'hd3:sbox_fwd=8'h66;
            8'hd4:sbox_fwd=8'h48; 8'hd5:sbox_fwd=8'h03; 8'hd6:sbox_fwd=8'hf6; 8'hd7:sbox_fwd=8'h0e;
            8'hd8:sbox_fwd=8'h61; 8'hd9:sbox_fwd=8'h35; 8'hda:sbox_fwd=8'h57; 8'hdb:sbox_fwd=8'hb9;
            8'hdc:sbox_fwd=8'h86; 8'hdd:sbox_fwd=8'hc1; 8'hde:sbox_fwd=8'h1d; 8'hdf:sbox_fwd=8'h9e;
            8'he0:sbox_fwd=8'he1; 8'he1:sbox_fwd=8'hf8; 8'he2:sbox_fwd=8'h98; 8'he3:sbox_fwd=8'h11;
            8'he4:sbox_fwd=8'h69; 8'he5:sbox_fwd=8'hd9; 8'he6:sbox_fwd=8'h8e; 8'he7:sbox_fwd=8'h94;
            8'he8:sbox_fwd=8'h9b; 8'he9:sbox_fwd=8'h1e; 8'hea:sbox_fwd=8'h87; 8'heb:sbox_fwd=8'he9;
            8'hec:sbox_fwd=8'hce; 8'hed:sbox_fwd=8'h55; 8'hee:sbox_fwd=8'h28; 8'hef:sbox_fwd=8'hdf;
            8'hf0:sbox_fwd=8'h8c; 8'hf1:sbox_fwd=8'ha1; 8'hf2:sbox_fwd=8'h89; 8'hf3:sbox_fwd=8'h0d;
            8'hf4:sbox_fwd=8'hbf; 8'hf5:sbox_fwd=8'he6; 8'hf6:sbox_fwd=8'h42; 8'hf7:sbox_fwd=8'h68;
            8'hf8:sbox_fwd=8'h41; 8'hf9:sbox_fwd=8'h99; 8'hfa:sbox_fwd=8'h2d; 8'hfb:sbox_fwd=8'h0f;
            8'hfc:sbox_fwd=8'hb0; 8'hfd:sbox_fwd=8'h54; 8'hfe:sbox_fwd=8'hbb; 8'hff:sbox_fwd=8'h16;
        endcase
    end
endfunction

// =============================================================================
// AES Inverse S-box (256 entries)
// =============================================================================
function [7:0] sbox_inv;
    input [7:0] x;
    begin
        case (x)
            8'h00:sbox_inv=8'h52; 8'h01:sbox_inv=8'h09; 8'h02:sbox_inv=8'h6a; 8'h03:sbox_inv=8'hd5;
            8'h04:sbox_inv=8'h30; 8'h05:sbox_inv=8'h36; 8'h06:sbox_inv=8'ha5; 8'h07:sbox_inv=8'h38;
            8'h08:sbox_inv=8'hbf; 8'h09:sbox_inv=8'h40; 8'h0a:sbox_inv=8'ha3; 8'h0b:sbox_inv=8'h9e;
            8'h0c:sbox_inv=8'h81; 8'h0d:sbox_inv=8'hf3; 8'h0e:sbox_inv=8'hd7; 8'h0f:sbox_inv=8'hfb;
            8'h10:sbox_inv=8'h7c; 8'h11:sbox_inv=8'he3; 8'h12:sbox_inv=8'h39; 8'h13:sbox_inv=8'h82;
            8'h14:sbox_inv=8'h9b; 8'h15:sbox_inv=8'h2f; 8'h16:sbox_inv=8'hff; 8'h17:sbox_inv=8'h87;
            8'h18:sbox_inv=8'h34; 8'h19:sbox_inv=8'h8e; 8'h1a:sbox_inv=8'h43; 8'h1b:sbox_inv=8'h44;
            8'h1c:sbox_inv=8'hc4; 8'h1d:sbox_inv=8'hde; 8'h1e:sbox_inv=8'he9; 8'h1f:sbox_inv=8'hcb;
            8'h20:sbox_inv=8'h54; 8'h21:sbox_inv=8'h7b; 8'h22:sbox_inv=8'h94; 8'h23:sbox_inv=8'h32;
            8'h24:sbox_inv=8'ha6; 8'h25:sbox_inv=8'hc2; 8'h26:sbox_inv=8'h23; 8'h27:sbox_inv=8'h3d;
            8'h28:sbox_inv=8'hee; 8'h29:sbox_inv=8'h4c; 8'h2a:sbox_inv=8'h95; 8'h2b:sbox_inv=8'h0b;
            8'h2c:sbox_inv=8'h42; 8'h2d:sbox_inv=8'hfa; 8'h2e:sbox_inv=8'hc3; 8'h2f:sbox_inv=8'h4e;
            8'h30:sbox_inv=8'h08; 8'h31:sbox_inv=8'h2e; 8'h32:sbox_inv=8'ha1; 8'h33:sbox_inv=8'h66;
            8'h34:sbox_inv=8'h28; 8'h35:sbox_inv=8'hd9; 8'h36:sbox_inv=8'h24; 8'h37:sbox_inv=8'hb2;
            8'h38:sbox_inv=8'h76; 8'h39:sbox_inv=8'h5b; 8'h3a:sbox_inv=8'ha2; 8'h3b:sbox_inv=8'h49;
            8'h3c:sbox_inv=8'h6d; 8'h3d:sbox_inv=8'h8b; 8'h3e:sbox_inv=8'hd1; 8'h3f:sbox_inv=8'h25;
            8'h40:sbox_inv=8'h72; 8'h41:sbox_inv=8'hf8; 8'h42:sbox_inv=8'hf6; 8'h43:sbox_inv=8'h64;
            8'h44:sbox_inv=8'h86; 8'h45:sbox_inv=8'h68; 8'h46:sbox_inv=8'h98; 8'h47:sbox_inv=8'h16;
            8'h48:sbox_inv=8'hd4; 8'h49:sbox_inv=8'ha4; 8'h4a:sbox_inv=8'h5c; 8'h4b:sbox_inv=8'hcc;
            8'h4c:sbox_inv=8'h5d; 8'h4d:sbox_inv=8'h65; 8'h4e:sbox_inv=8'hb6; 8'h4f:sbox_inv=8'h92;
            8'h50:sbox_inv=8'h6c; 8'h51:sbox_inv=8'h70; 8'h52:sbox_inv=8'h48; 8'h53:sbox_inv=8'h50;
            8'h54:sbox_inv=8'hfd; 8'h55:sbox_inv=8'hed; 8'h56:sbox_inv=8'hb9; 8'h57:sbox_inv=8'hda;
            8'h58:sbox_inv=8'h5e; 8'h59:sbox_inv=8'h15; 8'h5a:sbox_inv=8'h46; 8'h5b:sbox_inv=8'h57;
            8'h5c:sbox_inv=8'ha7; 8'h5d:sbox_inv=8'h8d; 8'h5e:sbox_inv=8'h9d; 8'h5f:sbox_inv=8'h84;
            8'h60:sbox_inv=8'h90; 8'h61:sbox_inv=8'hd8; 8'h62:sbox_inv=8'hab; 8'h63:sbox_inv=8'h00;
            8'h64:sbox_inv=8'h8c; 8'h65:sbox_inv=8'hbc; 8'h66:sbox_inv=8'hd3; 8'h67:sbox_inv=8'h0a;
            8'h68:sbox_inv=8'hf7; 8'h69:sbox_inv=8'he4; 8'h6a:sbox_inv=8'h58; 8'h6b:sbox_inv=8'h05;
            8'h6c:sbox_inv=8'hb8; 8'h6d:sbox_inv=8'hb3; 8'h6e:sbox_inv=8'h45; 8'h6f:sbox_inv=8'h06;
            8'h70:sbox_inv=8'hd0; 8'h71:sbox_inv=8'h2c; 8'h72:sbox_inv=8'h1e; 8'h73:sbox_inv=8'h8f;
            8'h74:sbox_inv=8'hca; 8'h75:sbox_inv=8'h3f; 8'h76:sbox_inv=8'h0f; 8'h77:sbox_inv=8'h02;
            8'h78:sbox_inv=8'hc1; 8'h79:sbox_inv=8'haf; 8'h7a:sbox_inv=8'hbd; 8'h7b:sbox_inv=8'h03;
            8'h7c:sbox_inv=8'h01; 8'h7d:sbox_inv=8'h13; 8'h7e:sbox_inv=8'h8a; 8'h7f:sbox_inv=8'h6b;
            8'h80:sbox_inv=8'h3a; 8'h81:sbox_inv=8'h91; 8'h82:sbox_inv=8'h11; 8'h83:sbox_inv=8'h41;
            8'h84:sbox_inv=8'h4f; 8'h85:sbox_inv=8'h67; 8'h86:sbox_inv=8'hdc; 8'h87:sbox_inv=8'hea;
            8'h88:sbox_inv=8'h97; 8'h89:sbox_inv=8'hf2; 8'h8a:sbox_inv=8'hcf; 8'h8b:sbox_inv=8'hce;
            8'h8c:sbox_inv=8'hf0; 8'h8d:sbox_inv=8'hb4; 8'h8e:sbox_inv=8'he6; 8'h8f:sbox_inv=8'h73;
            8'h90:sbox_inv=8'h96; 8'h91:sbox_inv=8'hac; 8'h92:sbox_inv=8'h74; 8'h93:sbox_inv=8'h22;
            8'h94:sbox_inv=8'he7; 8'h95:sbox_inv=8'had; 8'h96:sbox_inv=8'h35; 8'h97:sbox_inv=8'h85;
            8'h98:sbox_inv=8'he2; 8'h99:sbox_inv=8'hf9; 8'h9a:sbox_inv=8'h37; 8'h9b:sbox_inv=8'he8;
            8'h9c:sbox_inv=8'h1c; 8'h9d:sbox_inv=8'h75; 8'h9e:sbox_inv=8'hdf; 8'h9f:sbox_inv=8'h6e;
            8'ha0:sbox_inv=8'h47; 8'ha1:sbox_inv=8'hf1; 8'ha2:sbox_inv=8'h1a; 8'ha3:sbox_inv=8'h71;
            8'ha4:sbox_inv=8'h1d; 8'ha5:sbox_inv=8'h29; 8'ha6:sbox_inv=8'hc5; 8'ha7:sbox_inv=8'h89;
            8'ha8:sbox_inv=8'h6f; 8'ha9:sbox_inv=8'hb7; 8'haa:sbox_inv=8'h62; 8'hab:sbox_inv=8'h0e;
            8'hac:sbox_inv=8'haa; 8'had:sbox_inv=8'h18; 8'hae:sbox_inv=8'hbe; 8'haf:sbox_inv=8'h1b;
            8'hb0:sbox_inv=8'hfc; 8'hb1:sbox_inv=8'h56; 8'hb2:sbox_inv=8'h3e; 8'hb3:sbox_inv=8'h4b;
            8'hb4:sbox_inv=8'hc6; 8'hb5:sbox_inv=8'hd2; 8'hb6:sbox_inv=8'h79; 8'hb7:sbox_inv=8'h20;
            8'hb8:sbox_inv=8'h9a; 8'hb9:sbox_inv=8'hdb; 8'hba:sbox_inv=8'hc0; 8'hbb:sbox_inv=8'hfe;
            8'hbc:sbox_inv=8'h78; 8'hbd:sbox_inv=8'hcd; 8'hbe:sbox_inv=8'h5a; 8'hbf:sbox_inv=8'hf4;
            8'hc0:sbox_inv=8'h1f; 8'hc1:sbox_inv=8'hdd; 8'hc2:sbox_inv=8'ha8; 8'hc3:sbox_inv=8'h33;
            8'hc4:sbox_inv=8'h88; 8'hc5:sbox_inv=8'h07; 8'hc6:sbox_inv=8'hc7; 8'hc7:sbox_inv=8'h31;
            8'hc8:sbox_inv=8'hb1; 8'hc9:sbox_inv=8'h12; 8'hca:sbox_inv=8'h10; 8'hcb:sbox_inv=8'h59;
            8'hcc:sbox_inv=8'h27; 8'hcd:sbox_inv=8'h80; 8'hce:sbox_inv=8'hec; 8'hcf:sbox_inv=8'h5f;
            8'hd0:sbox_inv=8'h60; 8'hd1:sbox_inv=8'h51; 8'hd2:sbox_inv=8'h7f; 8'hd3:sbox_inv=8'ha9;
            8'hd4:sbox_inv=8'h19; 8'hd5:sbox_inv=8'hb5; 8'hd6:sbox_inv=8'h4a; 8'hd7:sbox_inv=8'h0d;
            8'hd8:sbox_inv=8'h2d; 8'hd9:sbox_inv=8'he5; 8'hda:sbox_inv=8'h7a; 8'hdb:sbox_inv=8'h9f;
            8'hdc:sbox_inv=8'h93; 8'hdd:sbox_inv=8'hc9; 8'hde:sbox_inv=8'h9c; 8'hdf:sbox_inv=8'hef;
            8'he0:sbox_inv=8'ha0; 8'he1:sbox_inv=8'he0; 8'he2:sbox_inv=8'h3b; 8'he3:sbox_inv=8'h4d;
            8'he4:sbox_inv=8'hae; 8'he5:sbox_inv=8'h2a; 8'he6:sbox_inv=8'hf5; 8'he7:sbox_inv=8'hb0;
            8'he8:sbox_inv=8'hc8; 8'he9:sbox_inv=8'heb; 8'hea:sbox_inv=8'hbb; 8'heb:sbox_inv=8'h3c;
            8'hec:sbox_inv=8'h83; 8'hed:sbox_inv=8'h53; 8'hee:sbox_inv=8'h99; 8'hef:sbox_inv=8'h61;
            8'hf0:sbox_inv=8'h17; 8'hf1:sbox_inv=8'h2b; 8'hf2:sbox_inv=8'h04; 8'hf3:sbox_inv=8'h7e;
            8'hf4:sbox_inv=8'hba; 8'hf5:sbox_inv=8'h77; 8'hf6:sbox_inv=8'hd6; 8'hf7:sbox_inv=8'h26;
            8'hf8:sbox_inv=8'he1; 8'hf9:sbox_inv=8'h69; 8'hfa:sbox_inv=8'h14; 8'hfb:sbox_inv=8'h63;
            8'hfc:sbox_inv=8'h55; 8'hfd:sbox_inv=8'h21; 8'hfe:sbox_inv=8'h0c; 8'hff:sbox_inv=8'h7d;
        endcase
    end
endfunction

// =============================================================================
// RCON table (AES key schedule round constants)
// =============================================================================
function [7:0] rcon_byte;
    input [3:0] rnd;
    begin
        case (rnd)
            4'd0:  rcon_byte = 8'h8d;
            4'd1:  rcon_byte = 8'h01;
            4'd2:  rcon_byte = 8'h02;
            4'd3:  rcon_byte = 8'h04;
            4'd4:  rcon_byte = 8'h08;
            4'd5:  rcon_byte = 8'h10;
            4'd6:  rcon_byte = 8'h20;
            4'd7:  rcon_byte = 8'h40;
            4'd8:  rcon_byte = 8'h80;
            4'd9:  rcon_byte = 8'h1b;
            4'd10: rcon_byte = 8'h36;
            4'd11: rcon_byte = 8'h6c;
            4'd12: rcon_byte = 8'hd8;
            4'd13: rcon_byte = 8'hab;
            4'd14: rcon_byte = 8'h4d;
            4'd15: rcon_byte = 8'h9a;
        endcase
    end
endfunction

// =============================================================================
// MixColumns: operate on a single word (4 bytes = one column)
// Standard AES MixColumns matrix multiply in GF(2^8):
//   [2 3 1 1] [b0]
//   [1 2 3 1] [b1]
//   [1 1 2 3] [b2]
//   [3 1 1 2] [b3]
// =============================================================================
function [31:0] mix_col_fwd;
    input [31:0] col; // col[31:24]=b0, col[23:16]=b1, col[15:8]=b2, col[7:0]=b3
    reg [7:0] b0, b1, b2, b3;
    reg [7:0] r0, r1, r2, r3;
    begin
        b0 = col[31:24]; b1 = col[23:16]; b2 = col[15:8]; b3 = col[7:0];
        r0 = gf_mul2(b0) ^ gf_mul3(b1) ^ b2         ^ b3;
        r1 = b0         ^ gf_mul2(b1) ^ gf_mul3(b2) ^ b3;
        r2 = b0         ^ b1          ^ gf_mul2(b2)  ^ gf_mul3(b3);
        r3 = gf_mul3(b0)^ b1          ^ b2           ^ gf_mul2(b3);
        mix_col_fwd = {r0, r1, r2, r3};
    end
endfunction

// =============================================================================
// InvMixColumns word
// Matrix:
//   [14  11  13   9]
//   [ 9  14  11  13]
//   [13   9  14  11]
//   [11  13   9  14]
// =============================================================================
function [31:0] mix_col_inv;
    input [31:0] col;
    reg [7:0] b0, b1, b2, b3;
    reg [7:0] r0, r1, r2, r3;
    begin
        b0 = col[31:24]; b1 = col[23:16]; b2 = col[15:8]; b3 = col[7:0];
        r0 = gf_mul14(b0) ^ gf_mul11(b1) ^ gf_mul13(b2) ^ gf_mul9(b3);
        r1 = gf_mul9(b0)  ^ gf_mul14(b1) ^ gf_mul11(b2) ^ gf_mul13(b3);
        r2 = gf_mul13(b0) ^ gf_mul9(b1)  ^ gf_mul14(b2) ^ gf_mul11(b3);
        r3 = gf_mul11(b0) ^ gf_mul13(b1) ^ gf_mul9(b2)  ^ gf_mul14(b3);
        mix_col_inv = {r0, r1, r2, r3};
    end
endfunction

// =============================================================================
// Byte extraction helper
// =============================================================================
function [7:0] get_byte;
    input [31:0] word;
    input [1:0]  sel; // 0=byte[7:0], 1=byte[15:8], 2=byte[23:16], 3=byte[31:24]
    begin
        case (sel)
            2'd0: get_byte = word[7:0];
            2'd1: get_byte = word[15:8];
            2'd2: get_byte = word[23:16];
            2'd3: get_byte = word[31:24];
        endcase
    end
endfunction

// Insert byte into word at position sel, keeping other bytes from base
function [31:0] set_byte;
    input [31:0] base;
    input [7:0]  bval;
    input [1:0]  sel;
    begin
        set_byte = base;
        case (sel)
            2'd0: set_byte[7:0]   = bval;
            2'd1: set_byte[15:8]  = bval;
            2'd2: set_byte[23:16] = bval;
            2'd3: set_byte[31:24] = bval;
        endcase
    end
endfunction

// =============================================================================
// Combinational decode and execute
// =============================================================================
reg [7:0] src_byte;
reg [7:0] sub_byte;
reg [31:0] mix_word;
reg [31:0] mix_inv_word;

always @(*) begin
    custom_rd = 32'd0;

    // Extract selected byte from rs1
    src_byte  = get_byte(custom_rs1, byte_sel);
    sub_byte  = sbox_fwd(src_byte);

    // MixColumns on the full rs1 word (treated as one column)
    mix_word     = mix_col_fwd(custom_rs1);
    mix_inv_word = mix_col_inv(custom_rs1);

    if (custom_valid) begin
        casez ({funct7, funct3})
            // aes.esb: Forward SubBytes on byte[rs2[1:0]] of rs1
            10'b0000000_000: begin
                custom_rd = set_byte(custom_rs1, sbox_fwd(src_byte), byte_sel);
            end

            // aes.emx: MixColumns byte: apply sbox then full MixColumns on column
            // Returns full column MixColumns result after sbox on selected byte
            10'b0000001_000: begin
                // Apply sbox to selected byte, reconstruct word, then MixColumns
                begin
                    reg [31:0] tmp;
                    tmp = set_byte(custom_rs1, sbox_fwd(src_byte), byte_sel);
                    custom_rd = mix_col_fwd(tmp);
                end
            end

            // aes.esr: ShiftRows partial - rotate word left by 8 bits
            10'b0000010_000: begin
                custom_rd = {custom_rs1[23:0], custom_rs1[31:24]};
            end

            // aes.dsb: Inverse SubBytes on byte[rs2[1:0]] of rs1
            10'b0000100_000: begin
                custom_rd = set_byte(custom_rs1, sbox_inv(src_byte), byte_sel);
            end

            // aes.dmx: Inverse MixColumns on full word
            10'b0000101_000: begin
                custom_rd = mix_col_inv(custom_rs1);
            end

            // aes.disr: Rotate word right by 8 bits (InvShiftRows partial)
            10'b0000110_000: begin
                custom_rd = {custom_rs1[7:0], custom_rs1[31:8]};
            end

            // aes.xk: AddRoundKey - XOR rs1 with rs2
            10'b0000111_000: begin
                custom_rd = custom_rs1 ^ custom_rs2;
            end

            // aes.rcon: RCON byte for round index rs2[3:0]
            // Returns {rcon_byte, 0x00, 0x00, 0x00} (standard AES RCON word)
            10'b0001000_000: begin
                custom_rd = {rcon_byte(custom_rs2[3:0]), 24'h000000};
            end

            default: begin
                custom_rd = 32'd0;
            end
        endcase
    end
end

endmodule
`default_nettype wire
