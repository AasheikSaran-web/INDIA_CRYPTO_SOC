`timescale 1ns/1ps

// tb_verhoeff_check: hardware module definition
module tb_verhoeff_check;
reg  [47:0] digits;
wire        verhoeff_ok;
wire        first_digit_ok;
wire        valid;

verhoeff_check dut (
    .digits        (digits),
    .verhoeff_ok   (verhoeff_ok),
    .first_digit_ok(first_digit_ok),
    .valid         (valid)
);
// automatic: combinational helper function
function automatic [3:0] d_lut;
    input [3:0] a, b;
    reg [3:0] D [0:9][0:9];
    begin
        D[0][0]=0; D[0][1]=1; D[0][2]=2; D[0][3]=3; D[0][4]=4;
        D[0][5]=5; D[0][6]=6; D[0][7]=7; D[0][8]=8; D[0][9]=9;
        D[1][0]=1; D[1][1]=2; D[1][2]=3; D[1][3]=4; D[1][4]=0;
        D[1][5]=6; D[1][6]=7; D[1][7]=8; D[1][8]=9; D[1][9]=5;
        D[2][0]=2; D[2][1]=3; D[2][2]=4; D[2][3]=0; D[2][4]=1;
        D[2][5]=7; D[2][6]=8; D[2][7]=9; D[2][8]=5; D[2][9]=6;
        D[3][0]=3; D[3][1]=4; D[3][2]=0; D[3][3]=1; D[3][4]=2;
        D[3][5]=8; D[3][6]=9; D[3][7]=5; D[3][8]=6; D[3][9]=7;
        D[4][0]=4; D[4][1]=0; D[4][2]=1; D[4][3]=2; D[4][4]=3;
        D[4][5]=9; D[4][6]=5; D[4][7]=6; D[4][8]=7; D[4][9]=8;
        D[5][0]=5; D[5][1]=9; D[5][2]=8; D[5][3]=7; D[5][4]=6;
        D[5][5]=0; D[5][6]=4; D[5][7]=3; D[5][8]=2; D[5][9]=1;
        D[6][0]=6; D[6][1]=5; D[6][2]=9; D[6][3]=8; D[6][4]=7;
        D[6][5]=1; D[6][6]=0; D[6][7]=4; D[6][8]=3; D[6][9]=2;
        D[7][0]=7; D[7][1]=6; D[7][2]=5; D[7][3]=9; D[7][4]=8;
        D[7][5]=2; D[7][6]=1; D[7][7]=0; D[7][8]=4; D[7][9]=3;
        D[8][0]=8; D[8][1]=7; D[8][2]=6; D[8][3]=5; D[8][4]=9;
        D[8][5]=3; D[8][6]=2; D[8][7]=1; D[8][8]=0; D[8][9]=4;
        D[9][0]=9; D[9][1]=8; D[9][2]=7; D[9][3]=6; D[9][4]=5;
        D[9][5]=4; D[9][6]=3; D[9][7]=2; D[9][8]=1; D[9][9]=0;
        d_lut = D[a][b];
    end
endfunction
// automatic: combinational helper function
function automatic [3:0] p_lut;
    input [2:0] pos;
    input [3:0] digit;
    reg [3:0] P [0:7][0:9];
    begin
        P[0][0]=0; P[0][1]=1; P[0][2]=2; P[0][3]=3; P[0][4]=4;
        P[0][5]=5; P[0][6]=6; P[0][7]=7; P[0][8]=8; P[0][9]=9;
        P[1][0]=1; P[1][1]=5; P[1][2]=7; P[1][3]=6; P[1][4]=2;
        P[1][5]=8; P[1][6]=3; P[1][7]=0; P[1][8]=9; P[1][9]=4;
        P[2][0]=5; P[2][1]=8; P[2][2]=0; P[2][3]=3; P[2][4]=7;
        P[2][5]=9; P[2][6]=6; P[2][7]=1; P[2][8]=4; P[2][9]=2;
        P[3][0]=8; P[3][1]=9; P[3][2]=1; P[3][3]=6; P[3][4]=0;
        P[3][5]=4; P[3][6]=3; P[3][7]=5; P[3][8]=2; P[3][9]=7;
        P[4][0]=9; P[4][1]=4; P[4][2]=5; P[4][3]=3; P[4][4]=1;
        P[4][5]=2; P[4][6]=6; P[4][7]=8; P[4][8]=7; P[4][9]=0;
        P[5][0]=4; P[5][1]=2; P[5][2]=8; P[5][3]=6; P[5][4]=5;
        P[5][5]=7; P[5][6]=3; P[5][7]=9; P[5][8]=0; P[5][9]=1;
        P[6][0]=2; P[6][1]=7; P[6][2]=9; P[6][3]=3; P[6][4]=8;
        P[6][5]=0; P[6][6]=6; P[6][7]=4; P[6][8]=1; P[6][9]=5;
        P[7][0]=7; P[7][1]=0; P[7][2]=4; P[7][3]=6; P[7][4]=9;
        P[7][5]=1; P[7][6]=3; P[7][7]=2; P[7][8]=5; P[7][9]=8;
        p_lut = P[pos][digit];
    end
endfunction
// automatic: combinational helper function
function automatic [3:0] verhoeff_sum;
    input [47:0] dgts;
    reg [3:0] rev [0:11];
    reg [3:0] c;
    integer i;
    begin
        rev[0]  = dgts[3:0];
        rev[1]  = dgts[7:4];
        rev[2]  = dgts[11:8];
        rev[3]  = dgts[15:12];
        rev[4]  = dgts[19:16];
        rev[5]  = dgts[23:20];
        rev[6]  = dgts[27:24];
        rev[7]  = dgts[31:28];
        rev[8]  = dgts[35:32];
        rev[9]  = dgts[39:36];
        rev[10] = dgts[43:40];
        rev[11] = dgts[47:44];
        c = 4'd0;
        for (i = 0; i < 12; i = i + 1)
            c = d_lut(c, p_lut(i[2:0], rev[i]));
        verhoeff_sum = c;
    end
endfunction
// automatic: combinational helper function
function automatic [3:0] find_check_digit;
    input [47:0] upper;
    reg [47:0] trial;
    reg [3:0]  cd;
    reg        found;
    integer    k;
    begin
        found = 0;
        cd    = 4'd0;
        for (k = 0; k <= 9 && !found; k = k + 1) begin
            trial = {upper[47:4], k[3:0]};
            if (verhoeff_sum(trial) == 4'd0) begin
                cd    = k[3:0];
                found = 1;
            end
        end
        find_check_digit = cd;
    end
endfunction
integer pass_count, fail_count;

// automatic: reusable simulation task
task automatic check_tc;
    input integer tcnum;
    input [47:0]  d;
    input         e_vok;
    input         e_fdok;
    input         e_valid;
    begin
        digits = d;
        #1;
        if (verhoeff_ok    === e_vok   &&
            first_digit_ok === e_fdok  &&
            valid           === e_valid) begin
            $display("[PASS] TC%02d  digits=%012h  vok=%b fdok=%b valid=%b",
                      tcnum, d, verhoeff_ok, first_digit_ok, valid);
            pass_count = pass_count + 1;
        end else begin
            $display("[FAIL] TC%02d  digits=%012h  vok=%b(exp %b) fdok=%b(exp %b) valid=%b(exp %b)",
                      tcnum, d,
                      verhoeff_ok,    e_vok,
                      first_digit_ok, e_fdok,
                      valid,          e_valid);
            fail_count = fail_count + 1;
        end
    end
endtask
// Simulation initialisation or stimulus block
initial begin
    pass_count = 0;
    fail_count = 0;
    digits     = 48'd0;
    check_tc(1, 48'h200055555554, 1'b1, 1'b1, 1'b1);
    begin : tc02_10
        reg [47:0] t;
        reg [3:0]  cd;
        t[47:44]=4'd2; t[43:40]=4'd3; t[39:36]=4'd4; t[35:32]=4'd5;
        t[31:28]=4'd6; t[27:24]=4'd7; t[23:20]=4'd8; t[19:16]=4'd9;
        t[15:12]=4'd0; t[11:8]=4'd1;  t[7:4]=4'd2;   t[3:0]=4'd0;
        cd = find_check_digit(t); t[3:0] = cd;
        check_tc(2, t, 1'b1, 1'b1, 1'b1);
        t[47:44]=4'd3; t[43:40]=4'd0; t[39:36]=4'd1; t[35:32]=4'd2;
        t[31:28]=4'd3; t[27:24]=4'd4; t[23:20]=4'd5; t[19:16]=4'd6;
        t[15:12]=4'd7; t[11:8]=4'd8;  t[7:4]=4'd9;   t[3:0]=4'd0;
        cd = find_check_digit(t); t[3:0] = cd;
        check_tc(3, t, 1'b1, 1'b1, 1'b1);
        t[47:44]=4'd4; t[43:40]=4'd1; t[39:36]=4'd1; t[35:32]=4'd1;
        t[31:28]=4'd1; t[27:24]=4'd1; t[23:20]=4'd1; t[19:16]=4'd1;
        t[15:12]=4'd1; t[11:8]=4'd1;  t[7:4]=4'd1;   t[3:0]=4'd0;
        cd = find_check_digit(t); t[3:0] = cd;
        check_tc(4, t, 1'b1, 1'b1, 1'b1);
        t[47:44]=4'd5; t[43:40]=4'd9; t[39:36]=4'd8; t[35:32]=4'd7;
        t[31:28]=4'd6; t[27:24]=4'd5; t[23:20]=4'd4; t[19:16]=4'd3;
        t[15:12]=4'd2; t[11:8]=4'd1;  t[7:4]=4'd0;   t[3:0]=4'd0;
        cd = find_check_digit(t); t[3:0] = cd;
        check_tc(5, t, 1'b1, 1'b1, 1'b1);
        t[47:44]=4'd6; t[43:40]=4'd2; t[39:36]=4'd2; t[35:32]=4'd2;
        t[31:28]=4'd2; t[27:24]=4'd2; t[23:20]=4'd2; t[19:16]=4'd2;
        t[15:12]=4'd2; t[11:8]=4'd2;  t[7:4]=4'd2;   t[3:0]=4'd0;
        cd = find_check_digit(t); t[3:0] = cd;
        check_tc(6, t, 1'b1, 1'b1, 1'b1);
        t[47:44]=4'd7; t[43:40]=4'd3; t[39:36]=4'd6; t[35:32]=4'd9;
        t[31:28]=4'd1; t[27:24]=4'd4; t[23:20]=4'd7; t[19:16]=4'd2;
        t[15:12]=4'd5; t[11:8]=4'd8;  t[7:4]=4'd0;   t[3:0]=4'd0;
        cd = find_check_digit(t); t[3:0] = cd;
        check_tc(7, t, 1'b1, 1'b1, 1'b1);
        t[47:44]=4'd8; t[43:40]=4'd4; t[39:36]=4'd4; t[35:32]=4'd4;
        t[31:28]=4'd4; t[27:24]=4'd4; t[23:20]=4'd4; t[19:16]=4'd4;
        t[15:12]=4'd4; t[11:8]=4'd4;  t[7:4]=4'd4;   t[3:0]=4'd0;
        cd = find_check_digit(t); t[3:0] = cd;
        check_tc(8, t, 1'b1, 1'b1, 1'b1);
        t[47:44]=4'd9; t[43:40]=4'd0; t[39:36]=4'd9; t[35:32]=4'd8;
        t[31:28]=4'd7; t[27:24]=4'd6; t[23:20]=4'd5; t[19:16]=4'd4;
        t[15:12]=4'd3; t[11:8]=4'd2;  t[7:4]=4'd1;   t[3:0]=4'd0;
        cd = find_check_digit(t); t[3:0] = cd;
        check_tc(9, t, 1'b1, 1'b1, 1'b1);
        t[47:44]=4'd2; t[43:40]=4'd9; t[39:36]=4'd7; t[35:32]=4'd5;
        t[31:28]=4'd3; t[27:24]=4'd1; t[23:20]=4'd8; t[19:16]=4'd6;
        t[15:12]=4'd4; t[11:8]=4'd2;  t[7:4]=4'd0;   t[3:0]=4'd0;
        cd = find_check_digit(t); t[3:0] = cd;
        check_tc(10, t, 1'b1, 1'b1, 1'b1);
    end
    begin : tc11_20
        reg [47:0] good, bad;
        reg [3:0]  orig, corrupted;
        reg        e_vok;
        integer    pos;
        good[47:44]=4'd3; good[43:40]=4'd0; good[39:36]=4'd1; good[35:32]=4'd2;
        good[31:28]=4'd3; good[27:24]=4'd4; good[23:20]=4'd5; good[19:16]=4'd6;
        good[15:12]=4'd7; good[11:8]=4'd8;  good[7:4]=4'd9;   good[3:0]=4'd0;
        good[3:0] = find_check_digit(good);

        for (pos = 0; pos <= 9; pos = pos + 1) begin
            bad          = good;
            orig         = good[4*pos +: 4];
            corrupted    = (orig == 4'd9) ? 4'd0 : (orig + 4'd1);
            bad[4*pos +: 4] = corrupted;
            e_vok = (verhoeff_sum(bad) == 4'd0) ? 1'b1 : 1'b0;
            check_tc(11 + pos, bad, e_vok, 1'b1, e_vok & 1'b1);
        end
    end
    begin : tc21_30
        reg [47:0] t;
        reg [3:0]  cd;
        reg        e_fdok;
        integer    d11v;

        for (d11v = 0; d11v <= 9; d11v = d11v + 1) begin
            t[47:44] = d11v[3:0];
            t[43:40]=4'd5; t[39:36]=4'd5; t[35:32]=4'd5;
            t[31:28]=4'd5; t[27:24]=4'd5; t[23:20]=4'd5; t[19:16]=4'd5;
            t[15:12]=4'd5; t[11:8]=4'd5;  t[7:4]=4'd5;   t[3:0]=4'd0;
            cd = find_check_digit(t);
            t[3:0] = cd;
            e_fdok = (d11v >= 2) ? 1'b1 : 1'b0;
            check_tc(21 + d11v, t, 1'b1, e_fdok, e_fdok);
        end
    end
    begin : tc31_40
        reg [47:0] t;
        reg        e_vok, e_fdok, e_valid;
        integer    d;

        for (d = 0; d <= 9; d = d + 1) begin
            t = { d[3:0], d[3:0], d[3:0], d[3:0],
                  d[3:0], d[3:0], d[3:0], d[3:0],
                  d[3:0], d[3:0], d[3:0], d[3:0] };
            e_vok   = (verhoeff_sum(t) == 4'd0) ? 1'b1 : 1'b0;
            e_fdok  = (d >= 2) ? 1'b1 : 1'b0;
            e_valid = e_vok & e_fdok;
            check_tc(31 + d, t, e_vok, e_fdok, e_valid);
        end
    end
    begin : tc41_45
        reg [47:0] t;
        reg [3:0]  cd;
        t[47:44]=4'd0; t[43:40]=4'd2; t[39:36]=4'd3; t[35:32]=4'd4;
        t[31:28]=4'd5; t[27:24]=4'd6; t[23:20]=4'd7; t[19:16]=4'd8;
        t[15:12]=4'd9; t[11:8]=4'd0;  t[7:4]=4'd1;   t[3:0]=4'd0;
        cd = find_check_digit(t); t[3:0] = cd;
        check_tc(41, t, 1'b1, 1'b0, 1'b0);
        t[47:44]=4'd1; t[43:40]=4'd3; t[39:36]=4'd3; t[35:32]=4'd3;
        t[31:28]=4'd3; t[27:24]=4'd3; t[23:20]=4'd3; t[19:16]=4'd3;
        t[15:12]=4'd3; t[11:8]=4'd3;  t[7:4]=4'd3;   t[3:0]=4'd0;
        cd = find_check_digit(t); t[3:0] = cd;
        check_tc(42, t, 1'b1, 1'b0, 1'b0);
        t[47:44]=4'd0; t[43:40]=4'd5; t[39:36]=4'd5; t[35:32]=4'd5;
        t[31:28]=4'd5; t[27:24]=4'd5; t[23:20]=4'd5; t[19:16]=4'd5;
        t[15:12]=4'd5; t[11:8]=4'd5;  t[7:4]=4'd5;   t[3:0]=4'd0;
        cd = find_check_digit(t); t[3:0] = cd;
        check_tc(43, t, 1'b1, 1'b0, 1'b0);
        t[47:44]=4'd1; t[43:40]=4'd9; t[39:36]=4'd8; t[35:32]=4'd7;
        t[31:28]=4'd6; t[27:24]=4'd5; t[23:20]=4'd4; t[19:16]=4'd3;
        t[15:12]=4'd2; t[11:8]=4'd1;  t[7:4]=4'd0;   t[3:0]=4'd0;
        cd = find_check_digit(t); t[3:0] = cd;
        check_tc(44, t, 1'b1, 1'b0, 1'b0);
        t[47:44]=4'd0; t[43:40]=4'd0; t[39:36]=4'd0; t[35:32]=4'd0;
        t[31:28]=4'd0; t[27:24]=4'd0; t[23:20]=4'd0; t[19:16]=4'd0;
        t[15:12]=4'd0; t[11:8]=4'd0;  t[7:4]=4'd0;   t[3:0]=4'd0;
        cd = find_check_digit(t); t[3:0] = cd;
        check_tc(45, t, 1'b1, 1'b0, 1'b0);
    end
    begin : tc46_50
        reg [47:0] t;
        reg [3:0]  cd;
        t[47:44]=4'd2; t[43:40]=4'd8; t[39:36]=4'd1; t[35:32]=4'd5;
        t[31:28]=4'd9; t[27:24]=4'd3; t[23:20]=4'd7; t[19:16]=4'd2;
        t[15:12]=4'd6; t[11:8]=4'd4;  t[7:4]=4'd0;   t[3:0]=4'd0;
        cd = find_check_digit(t); t[3:0] = cd;
        check_tc(46, t, 1'b1, 1'b1, 1'b1);
        t[47:44]=4'd3; t[43:40]=4'd7; t[39:36]=4'd4; t[35:32]=4'd1;
        t[31:28]=4'd8; t[27:24]=4'd5; t[23:20]=4'd2; t[19:16]=4'd9;
        t[15:12]=4'd6; t[11:8]=4'd3;  t[7:4]=4'd0;   t[3:0]=4'd0;
        cd = find_check_digit(t); t[3:0] = cd;
        check_tc(47, t, 1'b1, 1'b1, 1'b1);
        t[47:44]=4'd4; t[43:40]=4'd6; t[39:36]=4'd7; t[35:32]=4'd8;
        t[31:28]=4'd9; t[27:24]=4'd0; t[23:20]=4'd1; t[19:16]=4'd2;
        t[15:12]=4'd3; t[11:8]=4'd4;  t[7:4]=4'd5;   t[3:0]=4'd0;
        cd = find_check_digit(t); t[3:0] = cd;
        check_tc(48, t, 1'b1, 1'b1, 1'b1);
        t[47:44]=4'd7; t[43:40]=4'd3; t[39:36]=4'd1; t[35:32]=4'd4;
        t[31:28]=4'd1; t[27:24]=4'd5; t[23:20]=4'd9; t[19:16]=4'd2;
        t[15:12]=4'd6; t[11:8]=4'd5;  t[7:4]=4'd3;   t[3:0]=4'd0;
        cd = find_check_digit(t); t[3:0] = cd;
        check_tc(49, t, 1'b1, 1'b1, 1'b1);
        t[47:44]=4'd9; t[43:40]=4'd1; t[39:36]=4'd8; t[35:32]=4'd2;
        t[31:28]=4'd7; t[27:24]=4'd3; t[23:20]=4'd6; t[19:16]=4'd4;
        t[15:12]=4'd5; t[11:8]=4'd0;  t[7:4]=4'd9;   t[3:0]=4'd0;
        cd = find_check_digit(t); t[3:0] = cd;
        check_tc(50, t, 1'b1, 1'b1, 1'b1);
    end
    $display("RESULT: %0d/50 passed", pass_count);
    $finish;
end

endmodule
