`timescale 1ns/1ps
`default_nettype none

// tb_hamming_secded: hardware module definition
module tb_hamming_secded;
reg  [31:0] test_in;
wire [38:0] enc_out;

reg  [38:0] dec_in;
wire [31:0] dec_out;
wire        dec_sec;
wire        dec_ded;
hamming_enc u_enc (
    .din  (test_in),
    .dout (enc_out)
);

hamming_dec u_dec (
    .din  (dec_in),
    .dout (dec_out),
    .sec  (dec_sec),
    .ded  (dec_ded)
);
integer pass_count;
integer fail_count;
integer tc;
// automatic: reusable simulation task
task automatic run_noerr_test;
    input [5:0]  tc_num;
    input [31:0] data;
    begin
        test_in = data;
        #1;
        dec_in = enc_out;
        #1;
        if (dec_out === data && dec_sec === 1'b0 && dec_ded === 1'b0) begin
            $display("[PASS] TC%02d  no-error roundtrip data=0x%08h  sec=%b ded=%b",
                     tc_num, data, dec_sec, dec_ded);
            pass_count = pass_count + 1;
        end else begin
            $display("[FAIL] TC%02d  no-error roundtrip data=0x%08h  got dout=0x%08h sec=%b ded=%b  exp sec=0 ded=0",
                     tc_num, data, dec_out, dec_sec, dec_ded);
            fail_count = fail_count + 1;
        end
    end
endtask
// automatic: reusable simulation task
task automatic run_sec_test;
    input [5:0]  tc_num;
    input [31:0] data;
    input [5:0]  flip_bit;
    begin
        test_in = data;
        #1;
        dec_in = enc_out ^ (39'b1 << flip_bit);
        #1;
        if (dec_sec === 1'b1 && dec_ded === 1'b0 && dec_out === data) begin
            $display("[PASS] TC%02d  single-bit err data=0x%08h flip_bit=%0d  sec=%b ded=%b dout=0x%08h",
                     tc_num, data, flip_bit, dec_sec, dec_ded, dec_out);
            pass_count = pass_count + 1;
        end else begin
            $display("[FAIL] TC%02d  single-bit err data=0x%08h flip_bit=%0d  got sec=%b ded=%b dout=0x%08h  exp sec=1 ded=0 dout=0x%08h",
                     tc_num, data, flip_bit, dec_sec, dec_ded, dec_out, data);
            fail_count = fail_count + 1;
        end
    end
endtask
// automatic: reusable simulation task
task automatic run_ded_test;
    input [5:0]  tc_num;
    input [31:0] data;
    input [5:0]  flip_a;
    input [5:0]  flip_b;
    begin
        test_in = data;
        #1;
        dec_in = enc_out ^ (39'b1 << flip_a) ^ (39'b1 << flip_b);
        #1;
        if (dec_ded === 1'b1 && dec_sec === 1'b0) begin
            $display("[PASS] TC%02d  double-bit err data=0x%08h flip_a=%0d flip_b=%0d  sec=%b ded=%b",
                     tc_num, data, flip_a, flip_b, dec_sec, dec_ded);
            pass_count = pass_count + 1;
        end else begin
            $display("[FAIL] TC%02d  double-bit err data=0x%08h flip_a=%0d flip_b=%0d  got sec=%b ded=%b  exp sec=0 ded=1",
                     tc_num, data, flip_a, flip_b, dec_sec, dec_ded);
            fail_count = fail_count + 1;
        end
    end
endtask
// automatic: reusable simulation task
task automatic run_parity_err_test;
    input [5:0]  tc_num;
    input [31:0] data;
    input [5:0]  parity_bit;
    begin
        test_in = data;
        #1;
        dec_in = enc_out ^ (39'b1 << parity_bit);
        #1;
        if (dec_sec === 1'b1 && dec_ded === 1'b0 && dec_out === data) begin
            $display("[PASS] TC%02d  parity-only err data=0x%08h parity_bit=%0d  sec=%b ded=%b dout=0x%08h",
                     tc_num, data, parity_bit, dec_sec, dec_ded, dec_out);
            pass_count = pass_count + 1;
        end else begin
            $display("[FAIL] TC%02d  parity-only err data=0x%08h parity_bit=%0d  got sec=%b ded=%b dout=0x%08h  exp sec=1 ded=0 dout=0x%08h",
                     tc_num, data, parity_bit, dec_sec, dec_ded, dec_out, data);
            fail_count = fail_count + 1;
        end
    end
endtask
// Simulation initialisation or stimulus block
initial begin
    pass_count = 0;
    fail_count = 0;
    test_in    = 32'h0;
    dec_in     = 39'h0;
    #5;
    $display("--- TC01-TC10: No-error roundtrips ---");
    run_noerr_test(6'd1,  32'h0000_0000);
    run_noerr_test(6'd2,  32'hFFFF_FFFF);
    run_noerr_test(6'd3,  32'hAAAA_AAAA);
    run_noerr_test(6'd4,  32'h5555_5555);
    run_noerr_test(6'd5,  32'hDEAD_BEEF);
    run_noerr_test(6'd6,  32'h1234_5678);
    run_noerr_test(6'd7,  32'hFEDC_BA98);
    run_noerr_test(6'd8,  32'h8000_0000);
    run_noerr_test(6'd9,  32'h0000_0001);
    run_noerr_test(6'd10, 32'h6D78_3F3C);
    $display("--- TC11-TC30: Single-bit error injection ---");
    run_sec_test(6'd11, 32'hDEAD_BEEF, 6'd0 );
    run_sec_test(6'd12, 32'h1234_5678, 6'd1 );
    run_sec_test(6'd13, 32'hAAAA_AAAA, 6'd2 );
    run_sec_test(6'd14, 32'h5555_5555, 6'd3 );
    run_sec_test(6'd15, 32'hFFFF_FFFF, 6'd4 );
    run_sec_test(6'd16, 32'h8000_0000, 6'd5 );
    run_sec_test(6'd17, 32'h0000_0001, 6'd6 );
    run_sec_test(6'd18, 32'hFEDC_BA98, 6'd7 );
    run_sec_test(6'd19, 32'h6D78_3F3C, 6'd8 );
    run_sec_test(6'd20, 32'hCAFE_BABE, 6'd9 );
    run_sec_test(6'd21, 32'h900D_DEAD, 6'd10);
    run_sec_test(6'd22, 32'hA5A5_A5A5, 6'd11);
    run_sec_test(6'd23, 32'h0F0F_0F0F, 6'd15);
    run_sec_test(6'd24, 32'hF0F0_F0F0, 6'd17);
    run_sec_test(6'd25, 32'hC0DE_C0DE, 6'd20);
    run_sec_test(6'd26, 32'hBEEF_CAFE, 6'd24);
    run_sec_test(6'd27, 32'h1357_2468, 6'd25);
    run_sec_test(6'd28, 32'h2468_1357, 6'd28);
    run_sec_test(6'd29, 32'h1111_1111, 6'd30);
    run_sec_test(6'd30, 32'h9999_9999, 6'd31);
    $display("--- TC31-TC40: Double-bit error injection ---");
    run_ded_test(6'd31, 32'hDEAD_BEEF, 6'd0,  6'd1 );
    run_ded_test(6'd32, 32'h1234_5678, 6'd2,  6'd4 );
    run_ded_test(6'd33, 32'hAAAA_AAAA, 6'd3,  6'd7 );
    run_ded_test(6'd34, 32'h5555_5555, 6'd5,  6'd10);
    run_ded_test(6'd35, 32'hFFFF_FFFF, 6'd6,  6'd11);
    run_ded_test(6'd36, 32'h8000_0000, 6'd8,  6'd13);
    run_ded_test(6'd37, 32'h0000_0001, 6'd9,  6'd15);
    run_ded_test(6'd38, 32'hFEDC_BA98, 6'd12, 6'd17);
    run_ded_test(6'd39, 32'h6D78_3F3C, 6'd18, 6'd25);
    run_ded_test(6'd40, 32'hCAFE_BABE, 6'd26, 6'd31);
    $display("--- TC41-TC45: Parity-only single-bit errors ---");
    run_parity_err_test(6'd41, 32'hDEAD_BEEF, 6'd32);
    run_parity_err_test(6'd42, 32'h1234_5678, 6'd33);
    run_parity_err_test(6'd43, 32'hAAAA_AAAA, 6'd34);
    run_parity_err_test(6'd44, 32'h5555_5555, 6'd35);
    run_parity_err_test(6'd45, 32'hFFFF_FFFF, 6'd36);
    $display("--- TC46-TC50: Miscellaneous roundtrip and single-bit tests ---");
    run_noerr_test(6'd46, 32'h0000_0000);
    run_noerr_test(6'd47, 32'hFFFF_FFFF);
    run_sec_test(6'd48, 32'hCAFE_BABE, 6'd14);
    run_sec_test(6'd49, 32'h900D_DEAD, 6'd19);
    run_sec_test(6'd50, 32'h1234_5678, 6'd29);
    #5;
    $display("--------------------------------------------------");
    $display("Results: %0d / 50 passed,  %0d / 50 failed",
             pass_count, fail_count);
    if (fail_count == 0 && pass_count == 50)
        $display("ALL 50 PASSED");
    else
        $display("SOME TESTS FAILED");
    $display("--------------------------------------------------");
    $finish;
end

endmodule

`default_nettype wire
