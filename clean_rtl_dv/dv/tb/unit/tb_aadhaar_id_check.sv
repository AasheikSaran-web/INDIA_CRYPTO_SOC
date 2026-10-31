`timescale 1ns/1ps

// tb_aadhaar_id_check: hardware module definition
module tb_aadhaar_id_check;
reg  [31:0] hdr_word;
wire        id_ok;

aadhaar_id_check dut (
    .hdr_word(hdr_word),
    .id_ok   (id_ok)
);
localparam [31:0] MAGIC = 32'h6D78_3F3C;
integer pass_count, fail_count;

// automatic: reusable simulation task
task automatic check_tc;
    input integer tcnum;
    input [31:0]  hw;
    input         exp_ok;
    begin
        hdr_word = hw;
        #1;
        if (id_ok === exp_ok) begin
            $display("[PASS] TC%02d  hdr_word=0x%08h  id_ok=%b", tcnum, hw, id_ok);
            pass_count = pass_count + 1;
        end else begin
            $display("[FAIL] TC%02d  hdr_word=0x%08h  id_ok=%b (exp %b)",
                      tcnum, hw, id_ok, exp_ok);
            fail_count = fail_count + 1;
        end
    end
endtask
// Simulation initialisation or stimulus block
initial begin
    pass_count = 0;
    fail_count = 0;
    hdr_word   = 32'd0;
    check_tc(1, MAGIC, 1'b1);
    begin : block_tc02_20
        integer bit_pos;
        for (bit_pos = 0; bit_pos <= 18; bit_pos = bit_pos + 1) begin
            check_tc(2 + bit_pos, MAGIC ^ (32'd1 << bit_pos), 1'b0);
        end
    end
    begin : block_tc21_30
        reg [7:0] b3, b2, b1, b0;
        reg [31:0] t;

        b3 = MAGIC[31:24];
        b2 = MAGIC[23:16];
        b1 = MAGIC[15:8];
        b0 = MAGIC[7:0];
        t = {b2, b1, b0, b3};
        check_tc(21, t, (t == MAGIC) ? 1'b1 : 1'b0);
        t = {b1, b0, b3, b2};
        check_tc(22, t, (t == MAGIC) ? 1'b1 : 1'b0);
        t = {b0, b3, b2, b1};
        check_tc(23, t, (t == MAGIC) ? 1'b1 : 1'b0);
        t = {b0, b2, b1, b3};
        check_tc(24, t, (t == MAGIC) ? 1'b1 : 1'b0);
        t = {b3, b1, b2, b0};
        check_tc(25, t, (t == MAGIC) ? 1'b1 : 1'b0);
        t = {b1, b2, b3, b0};
        check_tc(26, t, (t == MAGIC) ? 1'b1 : 1'b0);
        t = {b3, b0, b1, b2};
        check_tc(27, t, (t == MAGIC) ? 1'b1 : 1'b0);
        t = {b0, b1, b2, b3};
        check_tc(28, t, (t == MAGIC) ? 1'b1 : 1'b0);
        t = {b2, b3, b0, b1};
        check_tc(29, t, (t == MAGIC) ? 1'b1 : 1'b0);
        t = {8'h00, b2, b1, b0};
        check_tc(30, t, (t == MAGIC) ? 1'b1 : 1'b0);
    end
    begin : block_tc31_40
        check_tc(31, 32'hE0FF_D8FF, 1'b0);
        check_tc(32, 32'h474E_5089, 1'b0);
        check_tc(33, 32'h4644_5025, 1'b0);
        check_tc(34, 32'h0403_4B50, 1'b0);
        check_tc(35, 32'h464C_457F, 1'b0);
        check_tc(36, 32'h0090_5A4D, 1'b0);
        check_tc(37, 32'h3846_4947, 1'b0);
        check_tc(38, 32'h0008_8B1F, 1'b0);
        check_tc(39, 32'h002A_4949, 1'b0);
        check_tc(40, 32'h0036_4D42, 1'b0);
    end
    begin : block_tc41_50
        reg [31:0] t;
        t = 32'h0000_0000;
        check_tc(41, t, (t == MAGIC) ? 1'b1 : 1'b0);
        t = 32'hFFFF_FFFF;
        check_tc(42, t, (t == MAGIC) ? 1'b1 : 1'b0);
        t = ~MAGIC;
        check_tc(43, t, (t == MAGIC) ? 1'b1 : 1'b0);
        t = MAGIC + 32'd1;
        check_tc(44, t, (t == MAGIC) ? 1'b1 : 1'b0);
        t = MAGIC - 32'd1;
        check_tc(45, t, (t == MAGIC) ? 1'b1 : 1'b0);
        t = {MAGIC[31:16], MAGIC[31:16]};
        check_tc(46, t, (t == MAGIC) ? 1'b1 : 1'b0);
        t = {MAGIC[15:0], MAGIC[15:0]};
        check_tc(47, t, (t == MAGIC) ? 1'b1 : 1'b0);
        t = { {MAGIC[27:24], MAGIC[31:28]},
              {MAGIC[19:16], MAGIC[23:20]},
              {MAGIC[11:8],  MAGIC[15:12]},
              {MAGIC[3:0],   MAGIC[7:4]} };
        check_tc(48, t, (t == MAGIC) ? 1'b1 : 1'b0);
        begin : rev_block
            integer k;
            t = 32'd0;
            for (k = 0; k < 32; k = k + 1)
                t[k] = MAGIC[31 - k];
        end
        check_tc(49, t, (t == MAGIC) ? 1'b1 : 1'b0);
        t = MAGIC ^ 32'hAAAA_AAAA;
        check_tc(50, t, (t == MAGIC) ? 1'b1 : 1'b0);
    end
    $display("RESULT: %0d/50 passed", pass_count);
    $finish;
end

endmodule
