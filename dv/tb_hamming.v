`timescale 1ns/1ps

module tb_hamming;

    reg  [31:0] enc_din;
    wire [38:0] enc_dout;

    reg  [38:0] dec_din;
    wire [31:0] dec_dout;
    wire        dec_sec;
    wire        dec_ded;

    hamming_enc dut_enc (
        .din  (enc_din),
        .dout (enc_dout)
    );

    hamming_dec dut_dec (
        .din  (dec_din),
        .dout (dec_dout),
        .sec  (dec_sec),
        .ded  (dec_ded)
    );

    integer pass_count, fail_count;

    task check;
        input        cond;
        input [127:0] msg;
        begin
            if (cond) begin
                pass_count = pass_count + 1;
            end else begin
                fail_count = fail_count + 1;
            end
        end
    endtask

    integer i, j;
    reg [38:0] cw, corrupted;
    reg [31:0] orig;
    reg ok;

    initial begin
        pass_count = 0;
        fail_count = 0;

        $display("=== tb_hamming: Hamming(39,32) SEC-DED tests ===");

        begin : enc_width
            reg [31:0] test_vals [0:4];
            integer v;
            test_vals[0] = 32'h00000000;
            test_vals[1] = 32'hFFFFFFFF;
            test_vals[2] = 32'hA5A5A5A5;
            test_vals[3] = 32'h5A5A5A5A;
            test_vals[4] = 32'hDEADBEEF;

            for (v = 0; v < 5; v = v + 1) begin
                enc_din = test_vals[v];
                #1;

                if (enc_dout[31:0] === test_vals[v]) begin
                    $display("[PASS] Encode 0x%08h: data embedded correctly in codeword", test_vals[v]);
                    pass_count = pass_count + 1;
                end else begin
                    $display("[FAIL] Encode 0x%08h: data bits mismatch (got 0x%09h)", test_vals[v], enc_dout);
                    fail_count = fail_count + 1;
                end
            end
        end

        begin : no_error
            reg [31:0] test_vals [0:4];
            integer v;
            test_vals[0] = 32'h00000000;
            test_vals[1] = 32'hFFFFFFFF;
            test_vals[2] = 32'hA5A5A5A5;
            test_vals[3] = 32'h5A5A5A5A;
            test_vals[4] = 32'hDEADBEEF;

            for (v = 0; v < 5; v = v + 1) begin
                enc_din = test_vals[v];
                #1;
                dec_din = enc_dout;
                #1;
                if (dec_dout === test_vals[v] && dec_sec === 1'b0 && dec_ded === 1'b0) begin
                    $display("[PASS] Error-free decode 0x%08h: data correct, sec=0, ded=0", test_vals[v]);
                    pass_count = pass_count + 1;
                end else begin
                    $display("[FAIL] Error-free decode 0x%08h: dout=0x%08h sec=%b ded=%b",
                             test_vals[v], dec_dout, dec_sec, dec_ded);
                    fail_count = fail_count + 1;
                end
            end
        end

        $display("--- Single-bit error injection (39 bits) ---");
        enc_din = 32'hA5A5A5A5;
        #1;
        cw = enc_dout;
        orig = 32'hA5A5A5A5;
        ok = 1'b1;
        for (i = 0; i < 39; i = i + 1) begin
            corrupted = cw ^ (39'h1 << i);
            dec_din = corrupted;
            #1;
            if (i == 38) begin

                if (dec_ded !== 1'b0 || dec_dout !== orig) begin
                    $display("[FAIL] SBE bit 38 (p6): ded=%b dout=0x%08h (expected ded=0 data=0x%08h)",
                             dec_ded, dec_dout, orig);
                    ok = 1'b0; fail_count = fail_count + 1;
                end

            end else begin

                if (dec_sec !== 1'b1 || dec_ded !== 1'b0 || dec_dout !== orig) begin
                    $display("[FAIL] SBE bit %0d: sec=%b ded=%b dout=0x%08h (expected sec=1 ded=0 dout=0x%08h)",
                             i, dec_sec, dec_ded, dec_dout, orig);
                    ok = 1'b0; fail_count = fail_count + 1;
                end
            end
        end
        if (ok) begin
            $display("[PASS] All 39 single-bit positions handled correctly (bit38=p6 special case)");
            pass_count = pass_count + 1;
        end

        $display("--- Double-bit error injection ---");
        enc_din = 32'h5A5A5A5A;
        #1;
        cw = enc_dout;
        ok = 1'b1;

        for (i = 0; i < 10; i = i + 1) begin
            j = (i + 5) % 39;
            if (j == i) j = (j + 1) % 39;
            corrupted = cw ^ (39'h1 << i) ^ (39'h1 << j);
            dec_din = corrupted;
            #1;
            if (dec_ded !== 1'b1) begin
                $display("[FAIL] DBE bits %0d,%0d: ded=%b (expected ded=1)", i, j, dec_ded);
                ok = 1'b0;
                fail_count = fail_count + 1;
            end
        end
        if (ok) begin
            $display("[PASS] Double-bit errors detected (DED=1) for 10 pairs");
            pass_count = pass_count + 1;
        end

        enc_din = 32'hDEADBEEF;
        #1;
        dec_din = enc_dout;
        #1;
        if (dec_dout === 32'hDEADBEEF && dec_sec === 1'b0 && dec_ded === 1'b0) begin
            $display("[PASS] Known vector 0xDEADBEEF: encode/decode round-trip correct, syndrome=0");
            pass_count = pass_count + 1;
        end else begin
            $display("[FAIL] Known vector 0xDEADBEEF: dout=0x%08h sec=%b ded=%b", dec_dout, dec_sec, dec_ded);
            fail_count = fail_count + 1;
        end

        $display("=== tb_hamming RESULTS: PASS=%0d FAIL=%0d ===", pass_count, fail_count);
        if (fail_count == 0)
            $display("[PASS] tb_hamming ALL TESTS PASSED");
        else
            $display("[FAIL] tb_hamming %0d TESTS FAILED", fail_count);

        $finish;
    end

endmodule
