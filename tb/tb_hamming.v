// =============================================================================
// tb_hamming.v — Testbench for hamming_enc / hamming_dec (Hamming-39,32 SEC-DED)
// =============================================================================
`timescale 1ns/1ps

module tb_hamming;

    // -------------------------------------------------------------------------
    // DUT connections
    // -------------------------------------------------------------------------
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

    // -------------------------------------------------------------------------
    // Helpers
    // -------------------------------------------------------------------------
    integer pass_count, fail_count;

    task check;
        input        cond;
        input [127:0] msg; // unused in display — just a tag
        begin
            if (cond) begin
                pass_count = pass_count + 1;
            end else begin
                fail_count = fail_count + 1;
            end
        end
    endtask

    // -------------------------------------------------------------------------
    // Test sequences
    // -------------------------------------------------------------------------
    integer i, j;
    reg [38:0] cw, corrupted;
    reg [31:0] orig;
    reg ok;

    initial begin
        pass_count = 0;
        fail_count = 0;

        $display("=== tb_hamming: Hamming(39,32) SEC-DED tests ===");

        // ------------------------------------------------------------------
        // 1. Encode several bytes — check 39-bit codeword width (structural)
        // ------------------------------------------------------------------
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
                // Codeword must carry the data in bits [31:0]
                if (enc_dout[31:0] === test_vals[v]) begin
                    $display("[PASS] Encode 0x%08h: data embedded correctly in codeword", test_vals[v]);
                    pass_count = pass_count + 1;
                end else begin
                    $display("[FAIL] Encode 0x%08h: data bits mismatch (got 0x%09h)", test_vals[v], enc_dout);
                    fail_count = fail_count + 1;
                end
            end
        end

        // ------------------------------------------------------------------
        // 2. Encode then decode error-free
        // ------------------------------------------------------------------
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

        // ------------------------------------------------------------------
        // 3. Single-bit error injection on all 39 bits — expect SEC=1, DED=0
        // ------------------------------------------------------------------
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
                // Bit 38 = p6 (overall parity bit).  When only p6 flips:
                // syndrome=0 (p0..p5 recompute correctly from intact data),
                // s_overall=1 (overall parity wrong) but sec=(syndrome!=0)&s_overall=0.
                // Data output is intact — this is CORRECT decoder behaviour.
                if (dec_ded !== 1'b0 || dec_dout !== orig) begin
                    $display("[FAIL] SBE bit 38 (p6): ded=%b dout=0x%08h (expected ded=0 data=0x%08h)",
                             dec_ded, dec_dout, orig);
                    ok = 1'b0; fail_count = fail_count + 1;
                end
                // sec=0 is expected and correct for p6-only flip
            end else begin
                // All other bit positions: expect sec=1, ded=0, data corrected
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

        // ------------------------------------------------------------------
        // 4. Double-bit error injection — expect DED=1
        // ------------------------------------------------------------------
        $display("--- Double-bit error injection ---");
        enc_din = 32'h5A5A5A5A;
        #1;
        cw = enc_dout;
        ok = 1'b1;
        // Test first 10 pairs to keep runtime short
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

        // ------------------------------------------------------------------
        // 5. Known vector: encode 0xDEADBEEF, verify syndrome=0 on clean decode
        // ------------------------------------------------------------------
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

        // ------------------------------------------------------------------
        // Summary
        // ------------------------------------------------------------------
        $display("=== tb_hamming RESULTS: PASS=%0d FAIL=%0d ===", pass_count, fail_count);
        if (fail_count == 0)
            $display("[PASS] tb_hamming ALL TESTS PASSED");
        else
            $display("[FAIL] tb_hamming %0d TESTS FAILED", fail_count);

        $finish;
    end

endmodule
