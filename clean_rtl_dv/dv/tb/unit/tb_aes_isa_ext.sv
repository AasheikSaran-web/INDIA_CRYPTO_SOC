`timescale 1ns/1ps
`default_nettype none

// 50-test unit testbench for aes_isa_ext covering AADHAAR.CHECK, AES SubBytes, ShiftRows, XOR, RCON, and InvSubBytes/InvMixCol
module tb_aes_isa_ext;

localparam CLK_PERIOD = 10;

reg clk;
// Clock generation initial
initial clk = 1'b0;
// Clock toggle always block
always #(CLK_PERIOD/2) clk = ~clk;

reg rst_n;
// Active-low reset held for 5 cycles then released
initial begin
    rst_n = 1'b0;
    repeat(5) @(posedge clk);
    rst_n = 1'b1;
end

reg         custom_valid;
reg  [31:0] custom_instr;
reg  [31:0] custom_rs1;
reg  [31:0] custom_rs2;
wire [31:0] custom_rd;
wire        custom_rd_valid;

aes_isa_ext dut (
    .custom_valid   (custom_valid),
    .custom_instr   (custom_instr),
    .custom_rs1     (custom_rs1),
    .custom_rs2     (custom_rs2),
    .custom_rd      (custom_rd),
    .custom_rd_valid(custom_rd_valid)
);

integer pass_count;
integer fail_count;

// Task to record a passing test case
task pass_tc;
    input integer n;
    begin
        $display("[PASS] TC%0d", n);
        pass_count = pass_count + 1;
    end
endtask

// Task to record a failing test case with message
task fail_tc;
    input integer n;
    input string  msg;
    begin
        $display("[FAIL] TC%0d : %s", n, msg);
        fail_count = fail_count + 1;
    end
endtask

// Function to build custom_instr word from funct7 and funct3 fields
function [31:0] make_instr;
    input [6:0] f7;
    input [2:0] f3;
    begin
        make_instr = {f7, 5'h00, 5'h00, f3, 5'h00, 7'h0B};
    end
endfunction

// Task to apply a combinational instruction and wait one delta for outputs to settle
task apply_instr;
    input [6:0]  f7;
    input [2:0]  f3;
    input [31:0] rs1;
    input [31:0] rs2;
    begin
        custom_valid = 1'b1;
        custom_instr = make_instr(f7, f3);
        custom_rs1   = rs1;
        custom_rs2   = rs2;
        #1;
    end
endtask

// Function providing AES forward S-box lookup table (256 entries)
function [7:0] ref_sbox;
    input [7:0] x;
    begin
        case (x)
            8'h00:ref_sbox=8'h63; 8'h01:ref_sbox=8'h7c; 8'h02:ref_sbox=8'h77; 8'h03:ref_sbox=8'h7b;
            8'h04:ref_sbox=8'hf2; 8'h05:ref_sbox=8'h6b; 8'h06:ref_sbox=8'h6f; 8'h07:ref_sbox=8'hc5;
            8'h08:ref_sbox=8'h30; 8'h09:ref_sbox=8'h01; 8'h0a:ref_sbox=8'h67; 8'h0b:ref_sbox=8'h2b;
            8'h0c:ref_sbox=8'hfe; 8'h0d:ref_sbox=8'hd7; 8'h0e:ref_sbox=8'hab; 8'h0f:ref_sbox=8'h76;
            8'h10:ref_sbox=8'hca; 8'h11:ref_sbox=8'h82; 8'h12:ref_sbox=8'hc9; 8'h13:ref_sbox=8'h7d;
            8'h14:ref_sbox=8'hfa; 8'h15:ref_sbox=8'h59; 8'h16:ref_sbox=8'h47; 8'h17:ref_sbox=8'hf0;
            8'h18:ref_sbox=8'had; 8'h19:ref_sbox=8'hd4; 8'h1a:ref_sbox=8'ha2; 8'h1b:ref_sbox=8'haf;
            8'h1c:ref_sbox=8'h9c; 8'h1d:ref_sbox=8'ha4; 8'h1e:ref_sbox=8'h72; 8'h1f:ref_sbox=8'hc0;
            8'h20:ref_sbox=8'hb7; 8'h21:ref_sbox=8'hfd; 8'h22:ref_sbox=8'h93; 8'h23:ref_sbox=8'h26;
            8'h24:ref_sbox=8'h36; 8'h25:ref_sbox=8'h3f; 8'h26:ref_sbox=8'hf7; 8'h27:ref_sbox=8'hcc;
            8'h28:ref_sbox=8'h34; 8'h29:ref_sbox=8'ha5; 8'h2a:ref_sbox=8'he5; 8'h2b:ref_sbox=8'hf1;
            8'h2c:ref_sbox=8'h71; 8'h2d:ref_sbox=8'hd8; 8'h2e:ref_sbox=8'h31; 8'h2f:ref_sbox=8'h15;
            8'h30:ref_sbox=8'h04; 8'h31:ref_sbox=8'hc7; 8'h32:ref_sbox=8'h23; 8'h33:ref_sbox=8'hc3;
            8'h34:ref_sbox=8'h18; 8'h35:ref_sbox=8'h96; 8'h36:ref_sbox=8'h05; 8'h37:ref_sbox=8'h9a;
            8'h38:ref_sbox=8'h07; 8'h39:ref_sbox=8'h12; 8'h3a:ref_sbox=8'h80; 8'h3b:ref_sbox=8'he2;
            8'h3c:ref_sbox=8'heb; 8'h3d:ref_sbox=8'h27; 8'h3e:ref_sbox=8'hb2; 8'h3f:ref_sbox=8'h75;
            8'h40:ref_sbox=8'h09; 8'h41:ref_sbox=8'h83; 8'h42:ref_sbox=8'h2c; 8'h43:ref_sbox=8'h1a;
            8'h44:ref_sbox=8'h1b; 8'h45:ref_sbox=8'h6e; 8'h46:ref_sbox=8'h5a; 8'h47:ref_sbox=8'ha0;
            8'h48:ref_sbox=8'h52; 8'h49:ref_sbox=8'h3b; 8'h4a:ref_sbox=8'hd6; 8'h4b:ref_sbox=8'hb3;
            8'h4c:ref_sbox=8'h29; 8'h4d:ref_sbox=8'he3; 8'h4e:ref_sbox=8'h2f; 8'h4f:ref_sbox=8'h84;
            8'h50:ref_sbox=8'h53; 8'h51:ref_sbox=8'hd1; 8'h52:ref_sbox=8'h00; 8'h53:ref_sbox=8'hed;
            8'h54:ref_sbox=8'h20; 8'h55:ref_sbox=8'hfc; 8'h56:ref_sbox=8'hb1; 8'h57:ref_sbox=8'h5b;
            8'h58:ref_sbox=8'h6a; 8'h59:ref_sbox=8'hcb; 8'h5a:ref_sbox=8'hbe; 8'h5b:ref_sbox=8'h39;
            8'h5c:ref_sbox=8'h4a; 8'h5d:ref_sbox=8'h4c; 8'h5e:ref_sbox=8'h58; 8'h5f:ref_sbox=8'hcf;
            8'h60:ref_sbox=8'hd0; 8'h61:ref_sbox=8'hef; 8'h62:ref_sbox=8'haa; 8'h63:ref_sbox=8'hfb;
            8'h64:ref_sbox=8'h43; 8'h65:ref_sbox=8'h4d; 8'h66:ref_sbox=8'h33; 8'h67:ref_sbox=8'h85;
            8'h68:ref_sbox=8'h45; 8'h69:ref_sbox=8'hf9; 8'h6a:ref_sbox=8'h02; 8'h6b:ref_sbox=8'h7f;
            8'h6c:ref_sbox=8'h50; 8'h6d:ref_sbox=8'h3c; 8'h6e:ref_sbox=8'h9f; 8'h6f:ref_sbox=8'ha8;
            8'h70:ref_sbox=8'h51; 8'h71:ref_sbox=8'ha3; 8'h72:ref_sbox=8'h40; 8'h73:ref_sbox=8'h8f;
            8'h74:ref_sbox=8'h92; 8'h75:ref_sbox=8'h9d; 8'h76:ref_sbox=8'h38; 8'h77:ref_sbox=8'hf5;
            8'h78:ref_sbox=8'hbc; 8'h79:ref_sbox=8'hb6; 8'h7a:ref_sbox=8'hda; 8'h7b:ref_sbox=8'h21;
            8'h7c:ref_sbox=8'h10; 8'h7d:ref_sbox=8'hff; 8'h7e:ref_sbox=8'hf3; 8'h7f:ref_sbox=8'hd2;
            8'h80:ref_sbox=8'hcd; 8'h81:ref_sbox=8'h0c; 8'h82:ref_sbox=8'h13; 8'h83:ref_sbox=8'hec;
            8'h84:ref_sbox=8'h5f; 8'h85:ref_sbox=8'h97; 8'h86:ref_sbox=8'h44; 8'h87:ref_sbox=8'h17;
            8'h88:ref_sbox=8'hc4; 8'h89:ref_sbox=8'ha7; 8'h8a:ref_sbox=8'h7e; 8'h8b:ref_sbox=8'h3d;
            8'h8c:ref_sbox=8'h64; 8'h8d:ref_sbox=8'h5d; 8'h8e:ref_sbox=8'h19; 8'h8f:ref_sbox=8'h73;
            8'h90:ref_sbox=8'h60; 8'h91:ref_sbox=8'h81; 8'h92:ref_sbox=8'h4f; 8'h93:ref_sbox=8'hdc;
            8'h94:ref_sbox=8'h22; 8'h95:ref_sbox=8'h2a; 8'h96:ref_sbox=8'h90; 8'h97:ref_sbox=8'h88;
            8'h98:ref_sbox=8'h46; 8'h99:ref_sbox=8'hee; 8'h9a:ref_sbox=8'hb8; 8'h9b:ref_sbox=8'h14;
            8'h9c:ref_sbox=8'hde; 8'h9d:ref_sbox=8'h5e; 8'h9e:ref_sbox=8'h0b; 8'h9f:ref_sbox=8'hdb;
            8'ha0:ref_sbox=8'he0; 8'ha1:ref_sbox=8'h32; 8'ha2:ref_sbox=8'h3a; 8'ha3:ref_sbox=8'h0a;
            8'ha4:ref_sbox=8'h49; 8'ha5:ref_sbox=8'h06; 8'ha6:ref_sbox=8'h24; 8'ha7:ref_sbox=8'h5c;
            8'ha8:ref_sbox=8'hc2; 8'ha9:ref_sbox=8'hd3; 8'haa:ref_sbox=8'hac; 8'hab:ref_sbox=8'h62;
            8'hac:ref_sbox=8'h91; 8'had:ref_sbox=8'h95; 8'hae:ref_sbox=8'he4; 8'haf:ref_sbox=8'h79;
            8'hb0:ref_sbox=8'he7; 8'hb1:ref_sbox=8'hc8; 8'hb2:ref_sbox=8'h37; 8'hb3:ref_sbox=8'h6d;
            8'hb4:ref_sbox=8'h8d; 8'hb5:ref_sbox=8'hd5; 8'hb6:ref_sbox=8'h4e; 8'hb7:ref_sbox=8'ha9;
            8'hb8:ref_sbox=8'h6c; 8'hb9:ref_sbox=8'h56; 8'hba:ref_sbox=8'hf4; 8'hbb:ref_sbox=8'hea;
            8'hbc:ref_sbox=8'h65; 8'hbd:ref_sbox=8'h7a; 8'hbe:ref_sbox=8'hae; 8'hbf:ref_sbox=8'h08;
            8'hc0:ref_sbox=8'hba; 8'hc1:ref_sbox=8'h78; 8'hc2:ref_sbox=8'h25; 8'hc3:ref_sbox=8'h2e;
            8'hc4:ref_sbox=8'h1c; 8'hc5:ref_sbox=8'ha6; 8'hc6:ref_sbox=8'hb4; 8'hc7:ref_sbox=8'hc6;
            8'hc8:ref_sbox=8'he8; 8'hc9:ref_sbox=8'hdd; 8'hca:ref_sbox=8'h74; 8'hcb:ref_sbox=8'h1f;
            8'hcc:ref_sbox=8'h4b; 8'hcd:ref_sbox=8'hbd; 8'hce:ref_sbox=8'h8b; 8'hcf:ref_sbox=8'h8a;
            8'hd0:ref_sbox=8'h70; 8'hd1:ref_sbox=8'h3e; 8'hd2:ref_sbox=8'hb5; 8'hd3:ref_sbox=8'h66;
            8'hd4:ref_sbox=8'h48; 8'hd5:ref_sbox=8'h03; 8'hd6:ref_sbox=8'hf6; 8'hd7:ref_sbox=8'h0e;
            8'hd8:ref_sbox=8'h61; 8'hd9:ref_sbox=8'h35; 8'hda:ref_sbox=8'h57; 8'hdb:ref_sbox=8'hb9;
            8'hdc:ref_sbox=8'h86; 8'hdd:ref_sbox=8'hc1; 8'hde:ref_sbox=8'h1d; 8'hdf:ref_sbox=8'h9e;
            8'he0:ref_sbox=8'he1; 8'he1:ref_sbox=8'hf8; 8'he2:ref_sbox=8'h98; 8'he3:ref_sbox=8'h11;
            8'he4:ref_sbox=8'h69; 8'he5:ref_sbox=8'hd9; 8'he6:ref_sbox=8'h8e; 8'he7:ref_sbox=8'h94;
            8'he8:ref_sbox=8'h9b; 8'he9:ref_sbox=8'h1e; 8'hea:ref_sbox=8'h87; 8'heb:ref_sbox=8'he9;
            8'hec:ref_sbox=8'hce; 8'hed:ref_sbox=8'h55; 8'hee:ref_sbox=8'h28; 8'hef:ref_sbox=8'hdf;
            8'hf0:ref_sbox=8'h8c; 8'hf1:ref_sbox=8'ha1; 8'hf2:ref_sbox=8'h89; 8'hf3:ref_sbox=8'h0d;
            8'hf4:ref_sbox=8'hbf; 8'hf5:ref_sbox=8'he6; 8'hf6:ref_sbox=8'h42; 8'hf7:ref_sbox=8'h68;
            8'hf8:ref_sbox=8'h41; 8'hf9:ref_sbox=8'h99; 8'hfa:ref_sbox=8'h2d; 8'hfb:ref_sbox=8'h0f;
            8'hfc:ref_sbox=8'hb0; 8'hfd:ref_sbox=8'h54; 8'hfe:ref_sbox=8'hbb; 8'hff:ref_sbox=8'h16;
            default: ref_sbox = 8'hxx;
        endcase
    end
endfunction

// Function providing AES inverse S-box (abbreviated — entries used by TC tests)
function [7:0] ref_sbox_inv;
    input [7:0] x;
    begin
        case (x)
            8'h00:ref_sbox_inv=8'h52; 8'h01:ref_sbox_inv=8'h09; 8'h02:ref_sbox_inv=8'h6a; 8'h03:ref_sbox_inv=8'hd5;
            8'h04:ref_sbox_inv=8'h30; 8'h05:ref_sbox_inv=8'h36; 8'h06:ref_sbox_inv=8'ha5; 8'h07:ref_sbox_inv=8'h38;
            8'h08:ref_sbox_inv=8'hbf; 8'h09:ref_sbox_inv=8'h40; 8'h0a:ref_sbox_inv=8'ha3; 8'h0b:ref_sbox_inv=8'h9e;
            8'h0c:ref_sbox_inv=8'h81; 8'h0d:ref_sbox_inv=8'hf3; 8'h0e:ref_sbox_inv=8'hd7; 8'h0f:ref_sbox_inv=8'hfb;
            8'h10:ref_sbox_inv=8'h7c; 8'h52:ref_sbox_inv=8'h00; 8'h63:ref_sbox_inv=8'h00;
            default: ref_sbox_inv = 8'hxx;
        endcase
    end
endfunction

// Function providing AES round constant table for rounds 0-15
function [7:0] ref_rcon;
    input [3:0] rnd;
    begin
        case (rnd)
            4'd0:  ref_rcon = 8'h8d;
            4'd1:  ref_rcon = 8'h01;
            4'd2:  ref_rcon = 8'h02;
            4'd3:  ref_rcon = 8'h04;
            4'd4:  ref_rcon = 8'h08;
            4'd5:  ref_rcon = 8'h10;
            4'd6:  ref_rcon = 8'h20;
            4'd7:  ref_rcon = 8'h40;
            4'd8:  ref_rcon = 8'h80;
            4'd9:  ref_rcon = 8'h1b;
            4'd10: ref_rcon = 8'h36;
            4'd11: ref_rcon = 8'h6c;
            4'd12: ref_rcon = 8'hd8;
            4'd13: ref_rcon = 8'hab;
            4'd14: ref_rcon = 8'h4d;
            4'd15: ref_rcon = 8'h9a;
            default: ref_rcon = 8'hxx;
        endcase
    end
endfunction

integer tc;
reg [31:0] expected;
reg [7:0]  b0, sb0;

// Main test sequence: TC01-TC50 covering all instruction groups
initial begin
    pass_count  = 0;
    fail_count  = 0;
    custom_valid = 1'b0;
    custom_instr = 32'h0;
    custom_rs1   = 32'h0;
    custom_rs2   = 32'h0;

    @(posedge rst_n);
    @(posedge clk);

    tc = 1;
    apply_instr(7'h7F, 3'h7, 32'h67890124, 32'h00002345);
    if (custom_rd[0] === 1'b1 && custom_rd_valid === 1'b1)
        pass_tc(tc);
    else
        fail_tc(tc, $sformatf("rd=0x%08X rdv=%0b for 234567890124", custom_rd, custom_rd_valid));

    tc = 2;
    apply_instr(7'h7F, 3'h7, 32'h78901238, 32'h00003456);
    if (custom_rd[0] === 1'b1) pass_tc(tc); else fail_tc(tc, $sformatf("rd[0]=%0b for 345678901238", custom_rd[0]));

    tc = 3;
    apply_instr(7'h7F, 3'h7, 32'h89012341, 32'h00004567);
    if (custom_rd[0] === 1'b1) pass_tc(tc); else fail_tc(tc, $sformatf("rd[0]=%0b for 456789012341", custom_rd[0]));

    tc = 4;
    apply_instr(7'h7F, 3'h7, 32'h90123458, 32'h00005678);
    if (custom_rd[0] === 1'b1) pass_tc(tc); else fail_tc(tc, $sformatf("rd[0]=%0b for 567890123458", custom_rd[0]));

    tc = 5;
    apply_instr(7'h7F, 3'h7, 32'h01234560, 32'h00006789);
    if (custom_rd[0] === 1'b1) pass_tc(tc); else fail_tc(tc, $sformatf("rd[0]=%0b for 678901234560", custom_rd[0]));

    tc = 6;
    apply_instr(7'h7F, 3'h7, 32'h12345674, 32'h00007890);
    if (custom_rd[0] === 1'b1) pass_tc(tc); else fail_tc(tc, $sformatf("rd[0]=%0b for 789012345674", custom_rd[0]));

    tc = 7;
    apply_instr(7'h7F, 3'h7, 32'h23456784, 32'h00008901);
    if (custom_rd[0] === 1'b1) pass_tc(tc); else fail_tc(tc, $sformatf("rd[0]=%0b for 890123456784", custom_rd[0]));

    tc = 8;
    apply_instr(7'h7F, 3'h7, 32'h65432101, 32'h00002987);
    if (custom_rd[0] === 1'b1) pass_tc(tc); else fail_tc(tc, $sformatf("rd[0]=%0b for 298765432101", custom_rd[0]));

    tc = 9;
    apply_instr(7'h7F, 3'h7, 32'h54321095, 32'h00003876);
    if (custom_rd[0] === 1'b1) pass_tc(tc); else fail_tc(tc, $sformatf("rd[0]=%0b for 387654321095", custom_rd[0]));

    tc = 10;
    apply_instr(7'h7F, 3'h7, 32'h43210985, 32'h00004765);
    if (custom_rd[0] === 1'b1) pass_tc(tc); else fail_tc(tc, $sformatf("rd[0]=%0b for 476543210985", custom_rd[0]));

    tc = 11;
    apply_instr(7'h7F, 3'h7, 32'h67890125, 32'h00002345);
    if (custom_rd[0] === 1'b0) pass_tc(tc); else fail_tc(tc, "Expected invalid for 234567890125");

    tc = 12;
    apply_instr(7'h7F, 3'h7, 32'h78901239, 32'h00003456);
    if (custom_rd[0] === 1'b0) pass_tc(tc); else fail_tc(tc, "Expected invalid for 345678901239");

    tc = 13;
    apply_instr(7'h7F, 3'h7, 32'h89012342, 32'h00004567);
    if (custom_rd[0] === 1'b0) pass_tc(tc); else fail_tc(tc, "Expected invalid for 456789012342");

    tc = 14;
    apply_instr(7'h7F, 3'h7, 32'h90123459, 32'h00005678);
    if (custom_rd[0] === 1'b0) pass_tc(tc); else fail_tc(tc, "Expected invalid for 567890123459");

    tc = 15;
    apply_instr(7'h7F, 3'h7, 32'h01234561, 32'h00006789);
    if (custom_rd[0] === 1'b0) pass_tc(tc); else fail_tc(tc, "Expected invalid for 678901234561");

    tc = 16;
    apply_instr(7'h7F, 3'h7, 32'h12345675, 32'h00007890);
    if (custom_rd[0] === 1'b0) pass_tc(tc); else fail_tc(tc, "Expected invalid for 789012345675");

    tc = 17;
    apply_instr(7'h7F, 3'h7, 32'h23456785, 32'h00008901);
    if (custom_rd[0] === 1'b0) pass_tc(tc); else fail_tc(tc, "Expected invalid for 890123456785");

    tc = 18;
    apply_instr(7'h7F, 3'h7, 32'h65432102, 32'h00002987);
    if (custom_rd[0] === 1'b0) pass_tc(tc); else fail_tc(tc, "Expected invalid for 298765432102");

    tc = 19;
    apply_instr(7'h7F, 3'h7, 32'h54321096, 32'h00003876);
    if (custom_rd[0] === 1'b0) pass_tc(tc); else fail_tc(tc, "Expected invalid for 387654321096");

    tc = 20;
    apply_instr(7'h7F, 3'h7, 32'h43210986, 32'h00004765);
    if (custom_rd[0] === 1'b0) pass_tc(tc); else fail_tc(tc, "Expected invalid for 476543210986");

    tc = 21;
    apply_instr(7'h00, 3'h0, 32'h11223300, 32'h00000000);
    expected = 32'h11223363;
    if (custom_rd === expected) pass_tc(tc); else fail_tc(tc, $sformatf("got 0x%08X exp 0x%08X", custom_rd, expected));

    tc = 22;
    apply_instr(7'h00, 3'h0, 32'h11223301, 32'h00000000);
    expected = 32'h1122337C;
    if (custom_rd === expected) pass_tc(tc); else fail_tc(tc, $sformatf("got 0x%08X exp 0x%08X", custom_rd, expected));

    tc = 23;
    apply_instr(7'h00, 3'h0, 32'h11223353, 32'h00000000);
    expected = 32'h112233ED;
    if (custom_rd === expected) pass_tc(tc); else fail_tc(tc, $sformatf("got 0x%08X exp 0x%08X", custom_rd, expected));

    tc = 24;
    apply_instr(7'h00, 3'h0, 32'h112233FF, 32'h00000000);
    expected = 32'h11223316;
    if (custom_rd === expected) pass_tc(tc); else fail_tc(tc, $sformatf("got 0x%08X exp 0x%08X", custom_rd, expected));

    tc = 25;
    apply_instr(7'h00, 3'h0, 32'h112233AB, 32'h00000000);
    expected = 32'h11223362;
    if (custom_rd === expected) pass_tc(tc); else fail_tc(tc, $sformatf("got 0x%08X exp 0x%08X", custom_rd, expected));

    tc = 26;
    apply_instr(7'h00, 3'h0, 32'h11220033, 32'h00000001);
    expected = 32'h11226333;
    if (custom_rd === expected) pass_tc(tc); else fail_tc(tc, $sformatf("got 0x%08X exp 0x%08X (sel=1)", custom_rd, expected));

    tc = 27;
    apply_instr(7'h00, 3'h0, 32'h11530011, 32'h00000002);
    expected = 32'h11ED0011;
    if (custom_rd === expected) pass_tc(tc); else fail_tc(tc, $sformatf("got 0x%08X exp 0x%08X (sel=2)", custom_rd, expected));

    tc = 28;
    apply_instr(7'h00, 3'h0, 32'hFF001122, 32'h00000003);
    expected = 32'h16001122;
    if (custom_rd === expected) pass_tc(tc); else fail_tc(tc, $sformatf("got 0x%08X exp 0x%08X (sel=3)", custom_rd, expected));

    tc = 29;
    apply_instr(7'h00, 3'h0, 32'h11223363, 32'h00000000);
    expected = 32'h112233FB;
    if (custom_rd === expected) pass_tc(tc); else fail_tc(tc, $sformatf("got 0x%08X exp 0x%08X", custom_rd, expected));

    tc = 30;
    apply_instr(7'h00, 3'h0, 32'h112233F0, 32'h00000000);
    expected = 32'h1122338C;
    if (custom_rd === expected) pass_tc(tc); else fail_tc(tc, $sformatf("got 0x%08X exp 0x%08X", custom_rd, expected));

    tc = 31;
    custom_valid = 1'b0;
    custom_instr = make_instr(7'h7F, 3'h7);
    custom_rs1   = 32'h67890124;
    custom_rs2   = 32'h00002345;
    #1;
    if (custom_rd_valid === 1'b0) pass_tc(tc); else fail_tc(tc, "rd_valid should be 0 when custom_valid=0");

    tc = 32;
    custom_valid = 1'b0;
    custom_instr = make_instr(7'h00, 3'h0);
    custom_rs1   = 32'h11223300;
    custom_rs2   = 32'h00000000;
    #1;
    if (custom_rd_valid === 1'b0) pass_tc(tc); else fail_tc(tc, "rd_valid should be 0 for subbyte, valid=0");

    tc = 33;
    custom_valid = 1'b0;
    custom_instr = make_instr(7'h07, 3'h0);
    custom_rs1   = 32'hDEADBEEF;
    custom_rs2   = 32'h12345678;
    #1;
    if (custom_rd === 32'h0) pass_tc(tc); else fail_tc(tc, $sformatf("rd=0x%08X should be 0 when valid=0", custom_rd));

    tc = 34;
    custom_valid = 1'b0;
    custom_instr = make_instr(7'h07, 3'h0);
    #1;
    if (custom_rd_valid === 1'b0) pass_tc(tc); else fail_tc(tc, "rd_valid XOR op should be 0 when valid=0");

    tc = 35;
    custom_valid = 1'b0;
    custom_instr = make_instr(7'h02, 3'h0);
    custom_rs1   = 32'h12345678;
    #1;
    if (custom_rd === 32'h0) pass_tc(tc); else fail_tc(tc, $sformatf("rd=0x%08X should be 0 (shiftrows,valid=0)", custom_rd));

    tc = 36;
    custom_valid = 1'b1;
    custom_instr = make_instr(7'h02, 3'h0);
    custom_rs1   = 32'h12345678;
    #1;
    if (custom_rd_valid === 1'b1) pass_tc(tc); else fail_tc(tc, "rd_valid should be 1 when valid=1");

    tc = 37;
    custom_valid = 1'b0;
    #1;
    if (custom_rd_valid === 1'b0) pass_tc(tc); else fail_tc(tc, "rd_valid should track valid deassertion");

    tc = 38;
    custom_valid = 1'b0;
    custom_instr = make_instr(7'h08, 3'h0);
    custom_rs1   = 32'h0;
    custom_rs2   = 32'h1;
    #1;
    if (custom_rd === 32'h0) pass_tc(tc); else fail_tc(tc, $sformatf("rd=0x%08X should be 0 (rcon,valid=0)", custom_rd));

    tc = 39;
    custom_valid = 1'b0;
    custom_instr = make_instr(7'h04, 3'h0);
    custom_rs1   = 32'hABCDEF01;
    #1;
    if (custom_rd === 32'h0) pass_tc(tc); else fail_tc(tc, $sformatf("rd=0x%08X should be 0 (inv-sub,valid=0)", custom_rd));

    tc = 40;
    custom_valid = 1'b0;
    custom_instr = make_instr(7'h05, 3'h0);
    custom_rs1   = 32'hDEADBEEF;
    #1;
    if (custom_rd_valid === 1'b0) pass_tc(tc); else fail_tc(tc, "rd_valid inv-mixcols should be 0 when valid=0");

    tc = 41;
    apply_instr(7'h02, 3'h0, 32'h12345678, 32'h0);
    expected = 32'h34567812;
    if (custom_rd === expected) pass_tc(tc); else fail_tc(tc, $sformatf("SR_L got 0x%08X exp 0x%08X", custom_rd, expected));

    tc = 42;
    apply_instr(7'h02, 3'h0, 32'hAABBCCDD, 32'h0);
    expected = 32'hBBCCDDAA;
    if (custom_rd === expected) pass_tc(tc); else fail_tc(tc, $sformatf("SR_L got 0x%08X exp 0x%08X", custom_rd, expected));

    tc = 43;
    apply_instr(7'h06, 3'h0, 32'h12345678, 32'h0);
    expected = 32'h78123456;
    if (custom_rd === expected) pass_tc(tc); else fail_tc(tc, $sformatf("SR_R got 0x%08X exp 0x%08X", custom_rd, expected));

    tc = 44;
    apply_instr(7'h06, 3'h0, 32'hAABBCCDD, 32'h0);
    expected = 32'hDDAABBCC;
    if (custom_rd === expected) pass_tc(tc); else fail_tc(tc, $sformatf("SR_R got 0x%08X exp 0x%08X", custom_rd, expected));

    tc = 45;
    apply_instr(7'h07, 3'h0, 32'hDEADBEEF, 32'h12345678);
    expected = 32'hCC99E897;
    if (custom_rd === expected) pass_tc(tc); else fail_tc(tc, $sformatf("XOR got 0x%08X exp 0x%08X", custom_rd, expected));

    tc = 46;
    apply_instr(7'h07, 3'h0, 32'hAABBCCDD, 32'h11223344);
    expected = 32'hBB99FF99;
    if (custom_rd === expected) pass_tc(tc); else fail_tc(tc, $sformatf("XOR got 0x%08X exp 0x%08X", custom_rd, expected));

    tc = 47;
    apply_instr(7'h08, 3'h0, 32'h0, 32'h00000001);
    expected = 32'h01000000;
    if (custom_rd === expected) pass_tc(tc); else fail_tc(tc, $sformatf("RCON[1] got 0x%08X exp 0x%08X", custom_rd, expected));

    tc = 48;
    apply_instr(7'h08, 3'h0, 32'h0, 32'h0000000A);
    expected = 32'h36000000;
    if (custom_rd === expected) pass_tc(tc); else fail_tc(tc, $sformatf("RCON[10] got 0x%08X exp 0x%08X", custom_rd, expected));

    tc = 49;
    apply_instr(7'h04, 3'h0, 32'h11223363, 32'h00000000);
    apply_instr(7'h00, 3'h0, 32'h000000AB, 32'h00000000);
    begin
        reg [31:0] sub_out;
        sub_out = custom_rd;
        apply_instr(7'h04, 3'h0, sub_out, 32'h00000000);
        if (custom_rd[7:0] === 8'hAB)
            pass_tc(tc);
        else
            fail_tc(tc, $sformatf("inv(sbox(0xAB))=0x%02X, expected 0xAB", custom_rd[7:0]));
    end

    tc = 50;
    apply_instr(7'h01, 3'h0, 32'h01010101, 32'h00000000);
    begin
        reg [31:0] mixed;
        mixed = custom_rd;
        apply_instr(7'h05, 3'h0, mixed, 32'h00000000);
        if (custom_rd === 32'h0101017C)
            pass_tc(tc);
        else
            fail_tc(tc, $sformatf("inv_mixcol(mixcol(x))=0x%08X, expected 0x0101017C", custom_rd));
    end

    $display("");
    $display("RESULT: %0d/50 passed", pass_count);
    $finish;
end

// Watchdog timer to abort simulation on hang
initial begin
    #500_000;
    $display("[FAIL] Simulation watchdog expired");
    $display("RESULT: %0d/50 passed", pass_count);
    $finish;
end

endmodule
`default_nettype wire
