// =============================================================================
// aes_ca_accel.v — AES-256 Accelerator with 4 Cellular Automaton round ops
// Project  : INDIA_CRYPTO_SOC — AES-accelerated PDF encryption
//
// CA-1 : SubBytes  (sbox + neighbour XOR perturbation)
// CA-2 : ShiftRows (standard AES cyclic row-shift CA)
// CA-3 : MixColumns (standard AES GF(2^8) column-mix CA)
// CA-4 : AddRoundKey (Rule-90 bitwise XOR)
//
// FSM  : S_IDLE → S_KEYSCHED → S_ROUND → S_FINAL → S_DONE
// SCA  : 8-bit LFSR injects 0/1 dummy stall per round
//
// AXI-Lite registers (base 0x3000_0000, local offset):
//   0x00 CTRL       [0]=START [1]=DECRYPT
//   0x04-0x20 KEY[0..7]  256-bit key
//   0x24-0x30 DIN[0..3]  128-bit plaintext
//   0x34-0x40 DOUT[0..3] 128-bit ciphertext (read after DONE)
//   0x44 STATUS     [1]=busy [0]=done
//   0x48 CA_RULE    [7:0] current ca_rule1 (debug)
//
// Direct interface (for PDF engine, combinational output):
//   direct_key[255:0], direct_din[127:0], direct_start, direct_decrypt
//   direct_dout[127:0], direct_done (1-cycle pulse)
// =============================================================================

`timescale 1ns/1ps

module aes_ca_accel (
    input  wire         clk,
    input  wire         rst_n,

    // Direct wire interface
    input  wire [255:0] direct_key,
    input  wire [127:0] direct_din,
    input  wire         direct_start,
    input  wire         direct_decrypt,
    output wire [127:0] direct_dout,
    output wire         direct_done,

    // AXI-Lite slave
    input  wire [11:0]  s_axil_awaddr,
    input  wire         s_axil_awvalid,
    output reg          s_axil_awready,
    input  wire [31:0]  s_axil_wdata,
    input  wire [3:0]   s_axil_wstrb,
    input  wire         s_axil_wvalid,
    output reg          s_axil_wready,
    output reg  [1:0]   s_axil_bresp,
    output reg          s_axil_bvalid,
    input  wire         s_axil_bready,
    input  wire [11:0]  s_axil_araddr,
    input  wire         s_axil_arvalid,
    output reg          s_axil_arready,
    output reg  [31:0]  s_axil_rdata,
    output reg  [1:0]   s_axil_rresp,
    output reg          s_axil_rvalid,
    input  wire         s_axil_rready
);

// ---------------------------------------------------------------------------
// FSM state encoding
// ---------------------------------------------------------------------------
localparam S_IDLE     = 3'd0;
localparam S_KEYSCHED = 3'd1;
localparam S_ROUND    = 3'd2;
localparam S_FINAL    = 3'd3;
localparam S_DONE     = 3'd4;

// ---------------------------------------------------------------------------
// Registers
// ---------------------------------------------------------------------------
reg [2:0]   state_r;
reg [127:0] aes_state;
reg [255:0] key_r;
reg         decrypt_r;
reg [127:0] dout_reg;
reg         done_r;
reg         busy_r;
reg [3:0]   round_r;       // 0..14
reg [7:0]   ca_rule1_r;    // current round rule extracted from key schedule

// AXI-facing registers
reg [255:0] axi_key;
reg [127:0] axi_din;
reg         direct_mode_r;

// ---------------------------------------------------------------------------
// Key schedule storage — 60 words (w[0..59]) for AES-256 → 15 round keys
// ---------------------------------------------------------------------------
reg [31:0] w [0:59];
reg [5:0]  ks_idx;        // word index during key expansion (0..59)

// ---------------------------------------------------------------------------
// SCA LFSR — 8-bit, taps 7,5,4,3; generates stall signal
// ---------------------------------------------------------------------------
reg [7:0] sca_lfsr;
reg       sca_stall;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        sca_lfsr <= 8'hA5;
    else begin
        // Fibonacci LFSR taps at positions 7,5,4,3 (1-indexed from MSB = bit 7)
        sca_lfsr <= {sca_lfsr[6:0],
                     sca_lfsr[7] ^ sca_lfsr[5] ^ sca_lfsr[4] ^ sca_lfsr[3]};
    end
end

// ---------------------------------------------------------------------------
// GF(2^8) multiply functions — irreducible poly 0x11B
// ---------------------------------------------------------------------------

function [7:0] xtime;
    input [7:0] a;
    begin
        xtime = (a[7]) ? ((a << 1) ^ 8'h1B) : (a << 1);
    end
endfunction

function [7:0] mul2;
    input [7:0] a;
    begin mul2 = xtime(a); end
endfunction

function [7:0] mul3;
    input [7:0] a;
    begin mul3 = xtime(a) ^ a; end
endfunction

function [7:0] mul9;
    input [7:0] a;
    begin mul9 = xtime(xtime(xtime(a))) ^ a; end
endfunction

function [7:0] mul11;
    input [7:0] a;
    begin mul11 = xtime(xtime(xtime(a))) ^ xtime(a) ^ a; end
endfunction

function [7:0] mul13;
    input [7:0] a;
    begin mul13 = xtime(xtime(xtime(a))) ^ xtime(xtime(a)) ^ a; end
endfunction

function [7:0] mul14;
    input [7:0] a;
    begin mul14 = xtime(xtime(xtime(a))) ^ xtime(xtime(a)) ^ xtime(a); end
endfunction

// ---------------------------------------------------------------------------
// AES S-box (full 256-entry)
// ---------------------------------------------------------------------------
function [7:0] sbox;
    input [7:0] b;
    begin
        case (b)
            8'h00: sbox=8'h63; 8'h01: sbox=8'h7c; 8'h02: sbox=8'h77; 8'h03: sbox=8'h7b;
            8'h04: sbox=8'hf2; 8'h05: sbox=8'h6b; 8'h06: sbox=8'h6f; 8'h07: sbox=8'hc5;
            8'h08: sbox=8'h30; 8'h09: sbox=8'h01; 8'h0a: sbox=8'h67; 8'h0b: sbox=8'h2b;
            8'h0c: sbox=8'hfe; 8'h0d: sbox=8'hd7; 8'h0e: sbox=8'hab; 8'h0f: sbox=8'h76;
            8'h10: sbox=8'hca; 8'h11: sbox=8'h82; 8'h12: sbox=8'hc9; 8'h13: sbox=8'h7d;
            8'h14: sbox=8'hfa; 8'h15: sbox=8'h59; 8'h16: sbox=8'h47; 8'h17: sbox=8'hf0;
            8'h18: sbox=8'had; 8'h19: sbox=8'hd4; 8'h1a: sbox=8'ha2; 8'h1b: sbox=8'haf;
            8'h1c: sbox=8'h9c; 8'h1d: sbox=8'ha4; 8'h1e: sbox=8'h72; 8'h1f: sbox=8'hc0;
            8'h20: sbox=8'hb7; 8'h21: sbox=8'hfd; 8'h22: sbox=8'h93; 8'h23: sbox=8'h26;
            8'h24: sbox=8'h36; 8'h25: sbox=8'h3f; 8'h26: sbox=8'hf7; 8'h27: sbox=8'hcc;
            8'h28: sbox=8'h34; 8'h29: sbox=8'ha5; 8'h2a: sbox=8'he5; 8'h2b: sbox=8'hf1;
            8'h2c: sbox=8'h71; 8'h2d: sbox=8'hd8; 8'h2e: sbox=8'h31; 8'h2f: sbox=8'h15;
            8'h30: sbox=8'h04; 8'h31: sbox=8'hc7; 8'h32: sbox=8'h23; 8'h33: sbox=8'hc3;
            8'h34: sbox=8'h18; 8'h35: sbox=8'h96; 8'h36: sbox=8'h05; 8'h37: sbox=8'h9a;
            8'h38: sbox=8'h07; 8'h39: sbox=8'h12; 8'h3a: sbox=8'h80; 8'h3b: sbox=8'he2;
            8'h3c: sbox=8'heb; 8'h3d: sbox=8'h27; 8'h3e: sbox=8'hb2; 8'h3f: sbox=8'h75;
            8'h40: sbox=8'h09; 8'h41: sbox=8'h83; 8'h42: sbox=8'h2c; 8'h43: sbox=8'h1a;
            8'h44: sbox=8'h1b; 8'h45: sbox=8'h6e; 8'h46: sbox=8'h5a; 8'h47: sbox=8'ha0;
            8'h48: sbox=8'h52; 8'h49: sbox=8'h3b; 8'h4a: sbox=8'hd6; 8'h4b: sbox=8'hb3;
            8'h4c: sbox=8'h29; 8'h4d: sbox=8'he3; 8'h4e: sbox=8'h2f; 8'h4f: sbox=8'h84;
            8'h50: sbox=8'h53; 8'h51: sbox=8'hd1; 8'h52: sbox=8'h00; 8'h53: sbox=8'hed;
            8'h54: sbox=8'h20; 8'h55: sbox=8'hfc; 8'h56: sbox=8'hb1; 8'h57: sbox=8'h5b;
            8'h58: sbox=8'h6a; 8'h59: sbox=8'hcb; 8'h5a: sbox=8'hbe; 8'h5b: sbox=8'h39;
            8'h5c: sbox=8'h4a; 8'h5d: sbox=8'h4c; 8'h5e: sbox=8'h58; 8'h5f: sbox=8'hcf;
            8'h60: sbox=8'hd0; 8'h61: sbox=8'hef; 8'h62: sbox=8'haa; 8'h63: sbox=8'hfb;
            8'h64: sbox=8'h43; 8'h65: sbox=8'h4d; 8'h66: sbox=8'h33; 8'h67: sbox=8'h85;
            8'h68: sbox=8'h45; 8'h69: sbox=8'hf9; 8'h6a: sbox=8'h02; 8'h6b: sbox=8'h7f;
            8'h6c: sbox=8'h50; 8'h6d: sbox=8'h3c; 8'h6e: sbox=8'h9f; 8'h6f: sbox=8'ha8;
            8'h70: sbox=8'h51; 8'h71: sbox=8'ha3; 8'h72: sbox=8'h40; 8'h73: sbox=8'h8f;
            8'h74: sbox=8'h92; 8'h75: sbox=8'h9d; 8'h76: sbox=8'h38; 8'h77: sbox=8'hf5;
            8'h78: sbox=8'hbc; 8'h79: sbox=8'hb6; 8'h7a: sbox=8'hda; 8'h7b: sbox=8'h21;
            8'h7c: sbox=8'h10; 8'h7d: sbox=8'hff; 8'h7e: sbox=8'hf3; 8'h7f: sbox=8'hd2;
            8'h80: sbox=8'hcd; 8'h81: sbox=8'h0c; 8'h82: sbox=8'h13; 8'h83: sbox=8'hec;
            8'h84: sbox=8'h5f; 8'h85: sbox=8'h97; 8'h86: sbox=8'h44; 8'h87: sbox=8'h17;
            8'h88: sbox=8'hc4; 8'h89: sbox=8'ha7; 8'h8a: sbox=8'h7e; 8'h8b: sbox=8'h3d;
            8'h8c: sbox=8'h64; 8'h8d: sbox=8'h5d; 8'h8e: sbox=8'h19; 8'h8f: sbox=8'h73;
            8'h90: sbox=8'h60; 8'h91: sbox=8'h81; 8'h92: sbox=8'h4f; 8'h93: sbox=8'hdc;
            8'h94: sbox=8'h22; 8'h95: sbox=8'h2a; 8'h96: sbox=8'h90; 8'h97: sbox=8'h88;
            8'h98: sbox=8'h46; 8'h99: sbox=8'hee; 8'h9a: sbox=8'hb8; 8'h9b: sbox=8'h14;
            8'h9c: sbox=8'hde; 8'h9d: sbox=8'h5e; 8'h9e: sbox=8'h0b; 8'h9f: sbox=8'hdb;
            8'ha0: sbox=8'he0; 8'ha1: sbox=8'h32; 8'ha2: sbox=8'h3a; 8'ha3: sbox=8'h0a;
            8'ha4: sbox=8'h49; 8'ha5: sbox=8'h06; 8'ha6: sbox=8'h24; 8'ha7: sbox=8'h5c;
            8'ha8: sbox=8'hc2; 8'ha9: sbox=8'hd3; 8'haa: sbox=8'hac; 8'hab: sbox=8'h62;
            8'hac: sbox=8'h91; 8'had: sbox=8'h95; 8'hae: sbox=8'he4; 8'haf: sbox=8'h79;
            8'hb0: sbox=8'he7; 8'hb1: sbox=8'hc8; 8'hb2: sbox=8'h37; 8'hb3: sbox=8'h6d;
            8'hb4: sbox=8'h8d; 8'hb5: sbox=8'hd5; 8'hb6: sbox=8'h4e; 8'hb7: sbox=8'ha9;
            8'hb8: sbox=8'h6c; 8'hb9: sbox=8'h56; 8'hba: sbox=8'hf4; 8'hbb: sbox=8'hea;
            8'hbc: sbox=8'h65; 8'hbd: sbox=8'h7a; 8'hbe: sbox=8'hae; 8'hbf: sbox=8'h08;
            8'hc0: sbox=8'hba; 8'hc1: sbox=8'h78; 8'hc2: sbox=8'h25; 8'hc3: sbox=8'h2e;
            8'hc4: sbox=8'h1c; 8'hc5: sbox=8'ha6; 8'hc6: sbox=8'hb4; 8'hc7: sbox=8'hc6;
            8'hc8: sbox=8'he8; 8'hc9: sbox=8'hdd; 8'hca: sbox=8'h74; 8'hcb: sbox=8'h1f;
            8'hcc: sbox=8'h4b; 8'hcd: sbox=8'hbd; 8'hce: sbox=8'h8b; 8'hcf: sbox=8'h8a;
            8'hd0: sbox=8'h70; 8'hd1: sbox=8'h3e; 8'hd2: sbox=8'hb5; 8'hd3: sbox=8'h66;
            8'hd4: sbox=8'h48; 8'hd5: sbox=8'h03; 8'hd6: sbox=8'hf6; 8'hd7: sbox=8'h0e;
            8'hd8: sbox=8'h61; 8'hd9: sbox=8'h35; 8'hda: sbox=8'h57; 8'hdb: sbox=8'hb9;
            8'hdc: sbox=8'h86; 8'hdd: sbox=8'hc1; 8'hde: sbox=8'h1d; 8'hdf: sbox=8'h9e;
            8'he0: sbox=8'he1; 8'he1: sbox=8'hf8; 8'he2: sbox=8'h98; 8'he3: sbox=8'h11;
            8'he4: sbox=8'h69; 8'he5: sbox=8'hd9; 8'he6: sbox=8'h8e; 8'he7: sbox=8'h94;
            8'he8: sbox=8'h9b; 8'he9: sbox=8'h1e; 8'hea: sbox=8'h87; 8'heb: sbox=8'he9;
            8'hec: sbox=8'hce; 8'hed: sbox=8'h55; 8'hee: sbox=8'h28; 8'hef: sbox=8'hdf;
            8'hf0: sbox=8'h8c; 8'hf1: sbox=8'ha1; 8'hf2: sbox=8'h89; 8'hf3: sbox=8'h0d;
            8'hf4: sbox=8'hbf; 8'hf5: sbox=8'he6; 8'hf6: sbox=8'h42; 8'hf7: sbox=8'h68;
            8'hf8: sbox=8'h41; 8'hf9: sbox=8'h99; 8'hfa: sbox=8'h2d; 8'hfb: sbox=8'h0f;
            8'hfc: sbox=8'hb0; 8'hfd: sbox=8'h54; 8'hfe: sbox=8'hbb; 8'hff: sbox=8'h16;
            default: sbox=8'h00;
        endcase
    end
endfunction

// ---------------------------------------------------------------------------
// AES Inverse S-box (full 256-entry)
// ---------------------------------------------------------------------------
function [7:0] inv_sbox;
    input [7:0] b;
    begin
        case (b)
            8'h00: inv_sbox=8'h52; 8'h01: inv_sbox=8'h09; 8'h02: inv_sbox=8'h6a; 8'h03: inv_sbox=8'hd5;
            8'h04: inv_sbox=8'h30; 8'h05: inv_sbox=8'h36; 8'h06: inv_sbox=8'ha5; 8'h07: inv_sbox=8'h38;
            8'h08: inv_sbox=8'hbf; 8'h09: inv_sbox=8'h40; 8'h0a: inv_sbox=8'ha3; 8'h0b: inv_sbox=8'h9e;
            8'h0c: inv_sbox=8'h81; 8'h0d: inv_sbox=8'hf3; 8'h0e: inv_sbox=8'hd7; 8'h0f: inv_sbox=8'hfb;
            8'h10: inv_sbox=8'h7c; 8'h11: inv_sbox=8'he3; 8'h12: inv_sbox=8'h39; 8'h13: inv_sbox=8'h82;
            8'h14: inv_sbox=8'h9b; 8'h15: inv_sbox=8'h2f; 8'h16: inv_sbox=8'hff; 8'h17: inv_sbox=8'h87;
            8'h18: inv_sbox=8'h34; 8'h19: inv_sbox=8'h8e; 8'h1a: inv_sbox=8'h43; 8'h1b: inv_sbox=8'h44;
            8'h1c: inv_sbox=8'hc4; 8'h1d: inv_sbox=8'hde; 8'h1e: inv_sbox=8'he9; 8'h1f: inv_sbox=8'hcb;
            8'h20: inv_sbox=8'h54; 8'h21: inv_sbox=8'h7b; 8'h22: inv_sbox=8'h94; 8'h23: inv_sbox=8'h32;
            8'h24: inv_sbox=8'ha6; 8'h25: inv_sbox=8'hc2; 8'h26: inv_sbox=8'h23; 8'h27: inv_sbox=8'h3d;
            8'h28: inv_sbox=8'hee; 8'h29: inv_sbox=8'h4c; 8'h2a: inv_sbox=8'h95; 8'h2b: inv_sbox=8'h0b;
            8'h2c: inv_sbox=8'h42; 8'h2d: inv_sbox=8'hfa; 8'h2e: inv_sbox=8'hc3; 8'h2f: inv_sbox=8'h4e;
            8'h30: inv_sbox=8'h08; 8'h31: inv_sbox=8'h2e; 8'h32: inv_sbox=8'ha1; 8'h33: inv_sbox=8'h66;
            8'h34: inv_sbox=8'h28; 8'h35: inv_sbox=8'hd9; 8'h36: inv_sbox=8'h24; 8'h37: inv_sbox=8'hb2;
            8'h38: inv_sbox=8'h76; 8'h39: inv_sbox=8'h5b; 8'h3a: inv_sbox=8'ha2; 8'h3b: inv_sbox=8'h49;
            8'h3c: inv_sbox=8'h6d; 8'h3d: inv_sbox=8'h8b; 8'h3e: inv_sbox=8'hd1; 8'h3f: inv_sbox=8'h25;
            8'h40: inv_sbox=8'h72; 8'h41: inv_sbox=8'hf8; 8'h42: inv_sbox=8'hf6; 8'h43: inv_sbox=8'h64;
            8'h44: inv_sbox=8'h86; 8'h45: inv_sbox=8'h68; 8'h46: inv_sbox=8'h98; 8'h47: inv_sbox=8'h16;
            8'h48: inv_sbox=8'hd4; 8'h49: inv_sbox=8'ha4; 8'h4a: inv_sbox=8'h5c; 8'h4b: inv_sbox=8'hcc;
            8'h4c: inv_sbox=8'h5d; 8'h4d: inv_sbox=8'h65; 8'h4e: inv_sbox=8'hb6; 8'h4f: inv_sbox=8'h92;
            8'h50: inv_sbox=8'h6c; 8'h51: inv_sbox=8'h70; 8'h52: inv_sbox=8'h48; 8'h53: inv_sbox=8'h50;
            8'h54: inv_sbox=8'hfd; 8'h55: inv_sbox=8'hed; 8'h56: inv_sbox=8'hb9; 8'h57: inv_sbox=8'hda;
            8'h58: inv_sbox=8'h5e; 8'h59: inv_sbox=8'h15; 8'h5a: inv_sbox=8'h46; 8'h5b: inv_sbox=8'h57;
            8'h5c: inv_sbox=8'ha7; 8'h5d: inv_sbox=8'h8d; 8'h5e: inv_sbox=8'h9d; 8'h5f: inv_sbox=8'h84;
            8'h60: inv_sbox=8'h90; 8'h61: inv_sbox=8'hd8; 8'h62: inv_sbox=8'hab; 8'h63: inv_sbox=8'h00;
            8'h64: inv_sbox=8'h8c; 8'h65: inv_sbox=8'hbc; 8'h66: inv_sbox=8'hd3; 8'h67: inv_sbox=8'h0a;
            8'h68: inv_sbox=8'hf7; 8'h69: inv_sbox=8'he4; 8'h6a: inv_sbox=8'h58; 8'h6b: inv_sbox=8'h05;
            8'h6c: inv_sbox=8'hb8; 8'h6d: inv_sbox=8'hb3; 8'h6e: inv_sbox=8'h45; 8'h6f: inv_sbox=8'h06;
            8'h70: inv_sbox=8'hd0; 8'h71: inv_sbox=8'h2c; 8'h72: inv_sbox=8'h1e; 8'h73: inv_sbox=8'h8f;
            8'h74: inv_sbox=8'hca; 8'h75: inv_sbox=8'h3f; 8'h76: inv_sbox=8'h0f; 8'h77: inv_sbox=8'h02;
            8'h78: inv_sbox=8'hc1; 8'h79: inv_sbox=8'haf; 8'h7a: inv_sbox=8'hbd; 8'h7b: inv_sbox=8'h03;
            8'h7c: inv_sbox=8'h01; 8'h7d: inv_sbox=8'h13; 8'h7e: inv_sbox=8'h8a; 8'h7f: inv_sbox=8'h6b;
            8'h80: inv_sbox=8'h3a; 8'h81: inv_sbox=8'h91; 8'h82: inv_sbox=8'h11; 8'h83: inv_sbox=8'h41;
            8'h84: inv_sbox=8'h4f; 8'h85: inv_sbox=8'h67; 8'h86: inv_sbox=8'hdc; 8'h87: inv_sbox=8'hea;
            8'h88: inv_sbox=8'h97; 8'h89: inv_sbox=8'hf2; 8'h8a: inv_sbox=8'hcf; 8'h8b: inv_sbox=8'hce;
            8'h8c: inv_sbox=8'hf0; 8'h8d: inv_sbox=8'hb4; 8'h8e: inv_sbox=8'he6; 8'h8f: inv_sbox=8'h73;
            8'h90: inv_sbox=8'h96; 8'h91: inv_sbox=8'hac; 8'h92: inv_sbox=8'h74; 8'h93: inv_sbox=8'h22;
            8'h94: inv_sbox=8'he7; 8'h95: inv_sbox=8'had; 8'h96: inv_sbox=8'h35; 8'h97: inv_sbox=8'h85;
            8'h98: inv_sbox=8'he2; 8'h99: inv_sbox=8'hf9; 8'h9a: inv_sbox=8'h37; 8'h9b: inv_sbox=8'he8;
            8'h9c: inv_sbox=8'h1c; 8'h9d: inv_sbox=8'h75; 8'h9e: inv_sbox=8'hdf; 8'h9f: inv_sbox=8'h6e;
            8'ha0: inv_sbox=8'h47; 8'ha1: inv_sbox=8'hf1; 8'ha2: inv_sbox=8'h1a; 8'ha3: inv_sbox=8'h71;
            8'ha4: inv_sbox=8'h1d; 8'ha5: inv_sbox=8'h29; 8'ha6: inv_sbox=8'hc5; 8'ha7: inv_sbox=8'h89;
            8'ha8: inv_sbox=8'h6f; 8'ha9: inv_sbox=8'hb7; 8'haa: inv_sbox=8'h62; 8'hab: inv_sbox=8'h0e;
            8'hac: inv_sbox=8'haa; 8'had: inv_sbox=8'h18; 8'hae: inv_sbox=8'hbe; 8'haf: inv_sbox=8'h1b;
            8'hb0: inv_sbox=8'hfc; 8'hb1: inv_sbox=8'h56; 8'hb2: inv_sbox=8'h3e; 8'hb3: inv_sbox=8'h4b;
            8'hb4: inv_sbox=8'hc6; 8'hb5: inv_sbox=8'hd2; 8'hb6: inv_sbox=8'h79; 8'hb7: inv_sbox=8'h20;
            8'hb8: inv_sbox=8'h9a; 8'hb9: inv_sbox=8'hdb; 8'hba: inv_sbox=8'hc0; 8'hbb: inv_sbox=8'hfe;
            8'hbc: inv_sbox=8'h78; 8'hbd: inv_sbox=8'hcd; 8'hbe: inv_sbox=8'h5a; 8'hbf: inv_sbox=8'hf4;
            8'hc0: inv_sbox=8'h1f; 8'hc1: inv_sbox=8'hdd; 8'hc2: inv_sbox=8'ha8; 8'hc3: inv_sbox=8'h33;
            8'hc4: inv_sbox=8'h88; 8'hc5: inv_sbox=8'h07; 8'hc6: inv_sbox=8'hc7; 8'hc7: inv_sbox=8'h31;
            8'hc8: inv_sbox=8'hb1; 8'hc9: inv_sbox=8'h12; 8'hca: inv_sbox=8'h10; 8'hcb: inv_sbox=8'h59;
            8'hcc: inv_sbox=8'h27; 8'hcd: inv_sbox=8'h80; 8'hce: inv_sbox=8'hec; 8'hcf: inv_sbox=8'h5f;
            8'hd0: inv_sbox=8'h60; 8'hd1: inv_sbox=8'h51; 8'hd2: inv_sbox=8'h7f; 8'hd3: inv_sbox=8'ha9;
            8'hd4: inv_sbox=8'h19; 8'hd5: inv_sbox=8'hb5; 8'hd6: inv_sbox=8'h4a; 8'hd7: inv_sbox=8'h0d;
            8'hd8: inv_sbox=8'h2d; 8'hd9: inv_sbox=8'he5; 8'hda: inv_sbox=8'h7a; 8'hdb: inv_sbox=8'h9f;
            8'hdc: inv_sbox=8'h93; 8'hdd: inv_sbox=8'hc9; 8'hde: inv_sbox=8'h9c; 8'hdf: inv_sbox=8'hef;
            8'he0: inv_sbox=8'ha0; 8'he1: inv_sbox=8'he0; 8'he2: inv_sbox=8'h3b; 8'he3: inv_sbox=8'h4d;
            8'he4: inv_sbox=8'hae; 8'he5: inv_sbox=8'h2a; 8'he6: inv_sbox=8'hf5; 8'he7: inv_sbox=8'hb0;
            8'he8: inv_sbox=8'hc8; 8'he9: inv_sbox=8'heb; 8'hea: inv_sbox=8'hbb; 8'heb: inv_sbox=8'h3c;
            8'hec: inv_sbox=8'h83; 8'hed: inv_sbox=8'h53; 8'hee: inv_sbox=8'h99; 8'hef: inv_sbox=8'h61;
            8'hf0: inv_sbox=8'h17; 8'hf1: inv_sbox=8'h2b; 8'hf2: inv_sbox=8'h04; 8'hf3: inv_sbox=8'h7e;
            8'hf4: inv_sbox=8'hba; 8'hf5: inv_sbox=8'h77; 8'hf6: inv_sbox=8'hd6; 8'hf7: inv_sbox=8'h26;
            8'hf8: inv_sbox=8'he1; 8'hf9: inv_sbox=8'h69; 8'hfa: inv_sbox=8'h14; 8'hfb: inv_sbox=8'h63;
            8'hfc: inv_sbox=8'h55; 8'hfd: inv_sbox=8'h21; 8'hfe: inv_sbox=8'h0c; 8'hff: inv_sbox=8'h7d;
            default: inv_sbox=8'h00;
        endcase
    end
endfunction

// ---------------------------------------------------------------------------
// Round constant table (RCON) for key schedule
// ---------------------------------------------------------------------------
function [7:0] rcon;
    input [3:0] idx;
    begin
        case (idx)
            4'd0:  rcon = 8'h01; 4'd1:  rcon = 8'h02; 4'd2:  rcon = 8'h04;
            4'd3:  rcon = 8'h08; 4'd4:  rcon = 8'h10; 4'd5:  rcon = 8'h20;
            4'd6:  rcon = 8'h40; 4'd7:  rcon = 8'h80; 4'd8:  rcon = 8'h1b;
            4'd9:  rcon = 8'h36; 4'd10: rcon = 8'h6c; 4'd11: rcon = 8'hd8;
            4'd12: rcon = 8'hab; 4'd13: rcon = 8'h4d; default: rcon = 8'h00;
        endcase
    end
endfunction

// ---------------------------------------------------------------------------
// CA helper functions
// ---------------------------------------------------------------------------

// CA-1 forward SubBytes with neighbourhood perturbation
function [7:0] ca1_sub_byte;
    input [7:0]  b;
    input [7:0]  prev_b;
    input [7:0]  next_b;
    input [7:0]  rule;
    reg   [7:0]  sb, prev_sb, next_sb;
    begin
        sb      = sbox(b);
        prev_sb = sbox(prev_b);
        next_sb = sbox(next_b);
        ca1_sub_byte = sb
            ^ (rule[prev_b[2:0]] ? prev_sb : 8'h00)
            ^ (rule[next_b[2:0]] ? next_sb : 8'h00);
    end
endfunction

// CA-1 inverse: inv_sbox first, then same XOR perturbation with inv_sbox values
function [7:0] ca1_inv_sub_byte;
    input [7:0]  b;
    input [7:0]  prev_b;
    input [7:0]  next_b;
    input [7:0]  rule;
    reg   [7:0]  isb, prev_isb, next_isb;
    begin
        isb      = inv_sbox(b);
        prev_isb = inv_sbox(prev_b);
        next_isb = inv_sbox(next_b);
        ca1_inv_sub_byte = isb
            ^ (rule[prev_b[2:0]] ? prev_isb : 8'h00)
            ^ (rule[next_b[2:0]] ? next_isb : 8'h00);
    end
endfunction

// ---------------------------------------------------------------------------
// CA-3 MixColumns on one column (4 bytes)
// ---------------------------------------------------------------------------
function [31:0] mix_col;
    input [7:0] b0, b1, b2, b3;
    begin
        mix_col = {mul2(b0)^mul3(b1)^b2      ^b3,
                   b0      ^mul2(b1)^mul3(b2) ^b3,
                   b0      ^b1      ^mul2(b2) ^mul3(b3),
                   mul3(b0)^b1      ^b2       ^mul2(b3)};
    end
endfunction

// CA-3 InvMixColumns on one column
function [31:0] inv_mix_col;
    input [7:0] b0, b1, b2, b3;
    begin
        inv_mix_col = {mul14(b0)^mul11(b1)^mul13(b2)^mul9(b3),
                       mul9(b0) ^mul14(b1)^mul11(b2)^mul13(b3),
                       mul13(b0)^mul9(b1) ^mul14(b2)^mul11(b3),
                       mul11(b0)^mul13(b1)^mul9(b2) ^mul14(b3)};
    end
endfunction

// ---------------------------------------------------------------------------
// Extract round key from w[] array
// Round key r = {w[4r], w[4r+1], w[4r+2], w[4r+3]}  (128 bits)
// Stored MSB-first: byte[0]=w[4r][31:24]
// ---------------------------------------------------------------------------

// ---------------------------------------------------------------------------
// CA pipeline helpers — combinational round functions
// ---------------------------------------------------------------------------

// Apply CA-1 (SubBytes) to full 128-bit state, using byte array indexing
function [127:0] apply_ca1;
    input [127:0] st;
    input [7:0]   rule;
    reg   [7:0]   b  [0:15];
    reg   [7:0]   out[0:15];
    integer ii;
    begin
        for (ii = 0; ii < 16; ii = ii+1)
            b[ii] = st[127 - ii*8 -: 8];
        for (ii = 0; ii < 16; ii = ii+1)
            out[ii] = ca1_sub_byte(b[ii],
                                   b[(ii+15)%16],
                                   b[(ii+1)%16],
                                   rule);
        apply_ca1 = {out[0],out[1],out[2],out[3],
                     out[4],out[5],out[6],out[7],
                     out[8],out[9],out[10],out[11],
                     out[12],out[13],out[14],out[15]};
    end
endfunction

// Apply CA-1 inverse
function [127:0] apply_ca1_inv;
    input [127:0] st;
    input [7:0]   rule;
    reg   [7:0]   b  [0:15];
    reg   [7:0]   out[0:15];
    integer ii;
    begin
        for (ii = 0; ii < 16; ii = ii+1)
            b[ii] = st[127 - ii*8 -: 8];
        for (ii = 0; ii < 16; ii = ii+1)
            out[ii] = ca1_inv_sub_byte(b[ii],
                                       b[(ii+15)%16],
                                       b[(ii+1)%16],
                                       rule);
        apply_ca1_inv = {out[0],out[1],out[2],out[3],
                         out[4],out[5],out[6],out[7],
                         out[8],out[9],out[10],out[11],
                         out[12],out[13],out[14],out[15]};
    end
endfunction

// CA-2 ShiftRows — AES column-major layout
// State bytes in 128-bit word (MSB=byte0):
//  byte[0..3]  = col0  row0..3
//  byte[4..7]  = col1  row0..3
//  ...
// Row r shifts left by r positions (in column units)
// Byte position: row r, col c → index 4c+r
function [127:0] apply_ca2_shift;
    input [127:0] st;
    reg [7:0] b[0:15];
    reg [7:0] o[0:15];
    integer r, c;
    begin
        for (c = 0; c < 4; c = c+1)
            for (r = 0; r < 4; r = r+1)
                b[4*c+r] = st[127-(4*c+r)*8 -: 8];
        // ShiftRows: row r → source col = (c + r) % 4
        for (r = 0; r < 4; r = r+1)
            for (c = 0; c < 4; c = c+1)
                o[4*c+r] = b[4*((c+r)%4)+r];
        apply_ca2_shift = {o[0],o[1],o[2],o[3],
                           o[4],o[5],o[6],o[7],
                           o[8],o[9],o[10],o[11],
                           o[12],o[13],o[14],o[15]};
    end
endfunction

// CA-2 InvShiftRows
function [127:0] apply_ca2_inv_shift;
    input [127:0] st;
    reg [7:0] b[0:15];
    reg [7:0] o[0:15];
    integer r, c;
    begin
        for (c = 0; c < 4; c = c+1)
            for (r = 0; r < 4; r = r+1)
                b[4*c+r] = st[127-(4*c+r)*8 -: 8];
        // InvShiftRows: row r → source col = (c + 4 - r) % 4
        for (r = 0; r < 4; r = r+1)
            for (c = 0; c < 4; c = c+1)
                o[4*c+r] = b[4*((c+4-r)%4)+r];
        apply_ca2_inv_shift = {o[0],o[1],o[2],o[3],
                               o[4],o[5],o[6],o[7],
                               o[8],o[9],o[10],o[11],
                               o[12],o[13],o[14],o[15]};
    end
endfunction

// CA-3 MixColumns — apply to all 4 columns
function [127:0] apply_ca3_mix;
    input [127:0] st;
    reg [7:0] b[0:15];
    reg [31:0] mc[0:3];
    integer c;
    begin
        for (c = 0; c < 16; c = c+1)
            b[c] = st[127-c*8 -: 8];
        for (c = 0; c < 4; c = c+1)
            mc[c] = mix_col(b[4*c], b[4*c+1], b[4*c+2], b[4*c+3]);
        apply_ca3_mix = {mc[0], mc[1], mc[2], mc[3]};
    end
endfunction

// CA-3 InvMixColumns
function [127:0] apply_ca3_inv_mix;
    input [127:0] st;
    reg [7:0] b[0:15];
    reg [31:0] mc[0:3];
    integer c;
    begin
        for (c = 0; c < 16; c = c+1)
            b[c] = st[127-c*8 -: 8];
        for (c = 0; c < 4; c = c+1)
            mc[c] = inv_mix_col(b[4*c], b[4*c+1], b[4*c+2], b[4*c+3]);
        apply_ca3_inv_mix = {mc[0], mc[1], mc[2], mc[3]};
    end
endfunction

// CA-4 AddRoundKey (Rule-90 XOR)
function [127:0] apply_ca4_add;
    input [127:0] st;
    input [127:0] rk;
    begin
        apply_ca4_add = st ^ rk;
    end
endfunction

// Assemble round key from w[] for round r (128-bit)
// We cannot index an array inside a function in Verilog-2001, so this is done inline in the FSM

// ---------------------------------------------------------------------------
// Key schedule SubWord + RotWord helpers
// ---------------------------------------------------------------------------
function [31:0] sub_word;
    input [31:0] w;
    begin
        sub_word = {sbox(w[31:24]), sbox(w[23:16]), sbox(w[15:8]), sbox(w[7:0])};
    end
endfunction

function [31:0] rot_word;
    input [31:0] w;
    begin
        rot_word = {w[23:0], w[31:24]};
    end
endfunction

// ---------------------------------------------------------------------------
// Main FSM
// ---------------------------------------------------------------------------

reg [127:0] round_key;    // current round key assembled from w[]
reg [3:0]   ks_rcon_idx;  // rcon index during key schedule
reg         sca_stall_r;  // registered stall

always @(posedge clk or negedge rst_n) begin : fsm
    integer i;
    reg [127:0] tmp_state;
    reg [31:0]  rk0, rk1, rk2, rk3;

    if (!rst_n) begin
        state_r       <= S_IDLE;
        aes_state     <= 128'h0;
        key_r         <= 256'h0;
        decrypt_r     <= 1'b0;
        dout_reg      <= 128'h0;
        done_r        <= 1'b0;
        busy_r        <= 1'b0;
        round_r       <= 4'd0;
        ca_rule1_r    <= 8'h00;
        ks_idx        <= 6'd0;
        ks_rcon_idx   <= 4'd0;
        sca_stall_r   <= 1'b0;
        direct_mode_r <= 1'b0;
        for (i = 0; i < 60; i = i+1) w[i] <= 32'h0;
    end else begin
        done_r      <= 1'b0;
        sca_stall_r <= 1'b0;

        case (state_r)
            // ------------------------------------------------------------------
            S_IDLE: begin
                busy_r <= 1'b0;
                // Accept start from either interface
                if (direct_start) begin
                    key_r         <= direct_key;
                    aes_state     <= direct_din;
                    decrypt_r     <= direct_decrypt;
                    direct_mode_r <= 1'b1;
                    busy_r        <= 1'b1;
                    ks_idx        <= 6'd0;
                    ks_rcon_idx   <= 4'd0;
                    state_r       <= S_KEYSCHED;
                end else if (axi_start_pulse) begin
                    key_r         <= axi_key;
                    aes_state     <= axi_din;
                    decrypt_r     <= axi_decrypt;
                    direct_mode_r <= 1'b0;
                    busy_r        <= 1'b1;
                    ks_idx        <= 6'd0;
                    ks_rcon_idx   <= 4'd0;
                    state_r       <= S_KEYSCHED;
                end
            end

            // ------------------------------------------------------------------
            // Key schedule: AES-256 expands 8 words → 60 words
            // One group of 4 words per clock cycle
            // ks_idx tracks next word to write (0,4,8,...,56)
            // ------------------------------------------------------------------
            S_KEYSCHED: begin
                if (ks_idx < 6'd8) begin
                    // Load initial key material directly
                    // key_r[255:224]=w0, ..., key_r[31:0]=w7
                    w[ks_idx] <= key_r[255 - ks_idx*32 -: 32];
                    if (ks_idx == 6'd7) begin
                        ks_idx <= 6'd8;
                    end else begin
                        ks_idx <= ks_idx + 6'd1;
                    end
                end else if (ks_idx <= 6'd56) begin
                    // Expand 4 words at a time
                    // For AES-256: words at multiples of 8 use SubWord+Rcon+RotWord
                    //              words at multiples of 4 (not 8) use SubWord only
                    if (ks_idx[2:0] == 3'd0) begin
                        // ks_idx divisible by 8
                        w[ks_idx]   <= w[ks_idx-8] ^ sub_word(rot_word(w[ks_idx-1]))
                                       ^ {rcon(ks_rcon_idx), 24'h0};
                        w[ks_idx+1] <= w[ks_idx-7] ^ (w[ks_idx-8] ^ sub_word(rot_word(w[ks_idx-1]))
                                       ^ {rcon(ks_rcon_idx), 24'h0});
                        // Compute incrementally to avoid needing new w[]
                        // Actually compute sequentially — do one word only and increment
                        // Simplified: compute all 4 in one cycle using blocking
                    end
                    // To keep it simple and synthesisable: compute one word per cycle
                    if ((ks_idx % 8) == 0) begin
                        w[ks_idx] <= w[ks_idx-8]
                                     ^ sub_word(rot_word(w[ks_idx-1]))
                                     ^ {rcon(ks_rcon_idx), 24'h0};
                        ks_rcon_idx <= ks_rcon_idx + 4'd1;
                    end else if ((ks_idx % 8) == 4) begin
                        w[ks_idx] <= w[ks_idx-8] ^ sub_word(w[ks_idx-1]);
                    end else begin
                        w[ks_idx] <= w[ks_idx-8] ^ w[ks_idx-1];
                    end
                    ks_idx <= ks_idx + 6'd1;

                    if (ks_idx == 6'd59) begin
                        // Key schedule complete — set up first round
                        round_r <= 4'd0;
                        // Initial AddRoundKey with round key 0
                        rk0 = w[0]; rk1 = w[1]; rk2 = w[2]; rk3 = w[3];
                        round_key  = {rk0, rk1, rk2, rk3};
                        aes_state  <= apply_ca4_add(aes_state, {rk0,rk1,rk2,rk3});
                        ca_rule1_r <= w[0][31:24];
                        state_r    <= S_ROUND;
                        round_r    <= 4'd1;
                    end
                end
            end

            // ------------------------------------------------------------------
            // Round processing (rounds 1..13)
            // ------------------------------------------------------------------
            S_ROUND: begin
                // SCA stall: skip if LFSR LSB set
                if (sca_lfsr[0] && !sca_stall_r) begin
                    sca_stall_r <= 1'b1;
                end else begin
                    sca_stall_r <= 1'b0;

                    // Assemble round key for current round
                    rk0 = w[4*round_r];
                    rk1 = w[4*round_r+1];
                    rk2 = w[4*round_r+2];
                    rk3 = w[4*round_r+3];
                    round_key  = {rk0, rk1, rk2, rk3};
                    ca_rule1_r <= rk0[31:24];

                    if (!decrypt_r) begin
                        // Encrypt: CA1→CA2→CA3→CA4
                        tmp_state = apply_ca1(aes_state, ca_rule1_r);
                        tmp_state = apply_ca2_shift(tmp_state);
                        tmp_state = apply_ca3_mix(tmp_state);
                        tmp_state = apply_ca4_add(tmp_state, round_key);
                    end else begin
                        // Decrypt: CA4→CA3inv→CA2inv→CA1inv
                        tmp_state = apply_ca4_add(aes_state, round_key);
                        tmp_state = apply_ca3_inv_mix(tmp_state);
                        tmp_state = apply_ca2_inv_shift(tmp_state);
                        tmp_state = apply_ca1_inv(tmp_state, ca_rule1_r);
                    end
                    aes_state <= tmp_state;

                    if (round_r == 4'd13) begin
                        state_r <= S_FINAL;
                        round_r <= 4'd14;
                    end else begin
                        round_r <= round_r + 4'd1;
                    end
                end
            end

            // ------------------------------------------------------------------
            // Final round (round 14) — no MixColumns
            // ------------------------------------------------------------------
            S_FINAL: begin
                rk0 = w[56]; rk1 = w[57]; rk2 = w[58]; rk3 = w[59];
                round_key  = {rk0, rk1, rk2, rk3};
                ca_rule1_r <= rk0[31:24];

                if (!decrypt_r) begin
                    // Encrypt final: CA1→CA2→CA4 (no MixColumns)
                    tmp_state = apply_ca1(aes_state, ca_rule1_r);
                    tmp_state = apply_ca2_shift(tmp_state);
                    tmp_state = apply_ca4_add(tmp_state, round_key);
                end else begin
                    // Decrypt final: CA4(rk0)→CA2inv→CA1inv
                    rk0 = w[0]; rk1 = w[1]; rk2 = w[2]; rk3 = w[3];
                    tmp_state = apply_ca4_add(aes_state, {rk0,rk1,rk2,rk3});
                    tmp_state = apply_ca2_inv_shift(tmp_state);
                    tmp_state = apply_ca1_inv(tmp_state, w[0][31:24]);
                end

                dout_reg  <= tmp_state;
                aes_state <= tmp_state;
                done_r    <= 1'b1;
                busy_r    <= 1'b0;
                state_r   <= S_DONE;
            end

            // ------------------------------------------------------------------
            S_DONE: begin
                done_r  <= 1'b0;
                state_r <= S_IDLE;
            end

            default: state_r <= S_IDLE;
        endcase
    end
end

// ---------------------------------------------------------------------------
// Direct interface outputs
// ---------------------------------------------------------------------------
assign direct_dout = dout_reg;
assign direct_done = done_r & direct_mode_r;

// ---------------------------------------------------------------------------
// AXI-Lite register interface
// ---------------------------------------------------------------------------

reg  [255:0] axi_key_r;
reg  [127:0] axi_din_r;
reg          axi_decrypt;
reg          axi_start_pulse;
reg  [11:0]  axi_aw_addr_lat;
reg          axi_aw_addr_valid;

assign axi_key = axi_key_r;
assign axi_din = axi_din_r;

// Write channel
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        s_axil_awready   <= 1'b0;
        s_axil_wready    <= 1'b0;
        s_axil_bvalid    <= 1'b0;
        s_axil_bresp     <= 2'b00;
        axi_aw_addr_lat  <= 12'h0;
        axi_aw_addr_valid<= 1'b0;
        axi_key_r        <= 256'h0;
        axi_din_r        <= 128'h0;
        axi_decrypt      <= 1'b0;
        axi_start_pulse  <= 1'b0;
    end else begin
        axi_start_pulse <= 1'b0;

        if (s_axil_awvalid && !s_axil_awready) begin
            s_axil_awready   <= 1'b1;
            axi_aw_addr_lat  <= s_axil_awaddr;
            axi_aw_addr_valid<= 1'b1;
        end else begin
            s_axil_awready <= 1'b0;
        end

        if (s_axil_wvalid && axi_aw_addr_valid && !s_axil_wready) begin
            s_axil_wready    <= 1'b1;
            axi_aw_addr_valid<= 1'b0;
            s_axil_bvalid    <= 1'b1;
            s_axil_bresp     <= 2'b00;

            case (axi_aw_addr_lat[7:0])
                8'h00: begin // CTRL
                    if (s_axil_wdata[0] && state_r == S_IDLE)
                        axi_start_pulse <= 1'b1;
                    axi_decrypt <= s_axil_wdata[1];
                end
                // KEY[0..7] — 0x04..0x20
                8'h04: axi_key_r[255:224] <= s_axil_wdata;
                8'h08: axi_key_r[223:192] <= s_axil_wdata;
                8'h0C: axi_key_r[191:160] <= s_axil_wdata;
                8'h10: axi_key_r[159:128] <= s_axil_wdata;
                8'h14: axi_key_r[127:96]  <= s_axil_wdata;
                8'h18: axi_key_r[95:64]   <= s_axil_wdata;
                8'h1C: axi_key_r[63:32]   <= s_axil_wdata;
                8'h20: axi_key_r[31:0]    <= s_axil_wdata;
                // DIN[0..3] — 0x24..0x30
                8'h24: axi_din_r[127:96]  <= s_axil_wdata;
                8'h28: axi_din_r[95:64]   <= s_axil_wdata;
                8'h2C: axi_din_r[63:32]   <= s_axil_wdata;
                8'h30: axi_din_r[31:0]    <= s_axil_wdata;
                // DOUT and STATUS are read-only; ignore writes
                default: ;
            endcase
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
        s_axil_arready <= 1'b0;
        s_axil_rvalid  <= 1'b0;
        s_axil_rdata   <= 32'h0;
        s_axil_rresp   <= 2'b00;
    end else begin
        if (s_axil_arvalid && !s_axil_arready) begin
            s_axil_arready <= 1'b1;
            s_axil_rvalid  <= 1'b1;
            s_axil_rresp   <= 2'b00;

            case (s_axil_araddr[7:0])
                8'h00: s_axil_rdata <= {30'h0, axi_decrypt, 1'b0};
                8'h04: s_axil_rdata <= axi_key_r[255:224];
                8'h08: s_axil_rdata <= axi_key_r[223:192];
                8'h0C: s_axil_rdata <= axi_key_r[191:160];
                8'h10: s_axil_rdata <= axi_key_r[159:128];
                8'h14: s_axil_rdata <= axi_key_r[127:96];
                8'h18: s_axil_rdata <= axi_key_r[95:64];
                8'h1C: s_axil_rdata <= axi_key_r[63:32];
                8'h20: s_axil_rdata <= axi_key_r[31:0];
                8'h24: s_axil_rdata <= axi_din_r[127:96];
                8'h28: s_axil_rdata <= axi_din_r[95:64];
                8'h2C: s_axil_rdata <= axi_din_r[63:32];
                8'h30: s_axil_rdata <= axi_din_r[31:0];
                8'h34: s_axil_rdata <= dout_reg[127:96];
                8'h38: s_axil_rdata <= dout_reg[95:64];
                8'h3C: s_axil_rdata <= dout_reg[63:32];
                8'h40: s_axil_rdata <= dout_reg[31:0];
                8'h44: s_axil_rdata <= {30'h0, busy_r, done_r};
                8'h48: s_axil_rdata <= {24'h0, ca_rule1_r};
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
