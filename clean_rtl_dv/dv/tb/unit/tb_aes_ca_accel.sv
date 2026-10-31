`timescale 1ns/1ps
// tb_aes_ca_accel: hardware module definition
module tb_aes_ca_accel;
reg clk;
reg rst_n;

// Simulation initialisation or stimulus block
initial clk = 0;
// Combinational logic output computation
always #5 clk = ~clk;
reg  [255:0] direct_key;
reg  [127:0] direct_din;
reg          direct_start;
reg          direct_decrypt;
wire [127:0] direct_dout;
wire         direct_done;

reg  [11:0]  s_axil_awaddr;
reg          s_axil_awvalid;
wire         s_axil_awready;
reg  [31:0]  s_axil_wdata;
reg  [3:0]   s_axil_wstrb;
reg          s_axil_wvalid;
wire         s_axil_wready;
wire [1:0]   s_axil_bresp;
wire         s_axil_bvalid;
reg          s_axil_bready;
reg  [11:0]  s_axil_araddr;
reg          s_axil_arvalid;
wire         s_axil_arready;
wire [31:0]  s_axil_rdata;
wire [1:0]   s_axil_rresp;
wire         s_axil_rvalid;
reg          s_axil_rready;
aes_ca_accel dut (
    .clk            (clk),
    .rst_n          (rst_n),
    .direct_key     (direct_key),
    .direct_din     (direct_din),
    .direct_start   (direct_start),
    .direct_decrypt (direct_decrypt),
    .direct_dout    (direct_dout),
    .direct_done    (direct_done),
    .s_axil_awaddr  (s_axil_awaddr),
    .s_axil_awvalid (s_axil_awvalid),
    .s_axil_awready (s_axil_awready),
    .s_axil_wdata   (s_axil_wdata),
    .s_axil_wstrb   (s_axil_wstrb),
    .s_axil_wvalid  (s_axil_wvalid),
    .s_axil_wready  (s_axil_wready),
    .s_axil_bresp   (s_axil_bresp),
    .s_axil_bvalid  (s_axil_bvalid),
    .s_axil_bready  (s_axil_bready),
    .s_axil_araddr  (s_axil_araddr),
    .s_axil_arvalid (s_axil_arvalid),
    .s_axil_arready (s_axil_arready),
    .s_axil_rdata   (s_axil_rdata),
    .s_axil_rresp   (s_axil_rresp),
    .s_axil_rvalid  (s_axil_rvalid),
    .s_axil_rready  (s_axil_rready)
);
integer pass_count;
integer fail_count;

// report: reusable simulation task
task report;
    input [7:0]  tc_num;
    input        pass;
    input [127:0] msg_unused;
    begin
        if (pass) begin
            $display("[PASS] TC%0d", tc_num);
            pass_count = pass_count + 1;
        end else begin
            $display("[FAIL] TC%0d", tc_num);
            fail_count = fail_count + 1;
        end
    end
endtask
// axi_write: reusable simulation task
task axi_write;
    input [11:0] addr;
    input [31:0] data;
    integer timeout;
    begin
        @(posedge clk);
        #1;
        s_axil_awaddr  = addr;
        s_axil_awvalid = 1'b1;
        s_axil_wstrb   = 4'hF;

        timeout = 0;
        while (!s_axil_awready) begin
            @(posedge clk); #1;
            timeout = timeout + 1;
            if (timeout > 100) begin
                $display("[FAIL] axi_write: awready timeout at addr=%0h", addr);
                $finish;
            end
        end
        @(posedge clk); #1;
        s_axil_awvalid = 1'b0;
        s_axil_wdata  = data;
        s_axil_wvalid = 1'b1;

        timeout = 0;
        while (!s_axil_wready) begin
            @(posedge clk); #1;
            timeout = timeout + 1;
            if (timeout > 100) begin
                $display("[FAIL] axi_write: wready timeout at addr=%0h", addr);
                $finish;
            end
        end
        @(posedge clk); #1;
        s_axil_wvalid = 1'b0;
        s_axil_bready = 1'b1;
        timeout = 0;
        while (!s_axil_bvalid) begin
            @(posedge clk); #1;
            timeout = timeout + 1;
            if (timeout > 100) begin
                $display("[FAIL] axi_write: bvalid timeout at addr=%0h", addr);
                $finish;
            end
        end
        @(posedge clk); #1;
        s_axil_bready = 1'b0;
    end
endtask
reg [31:0] axi_rd_data;

// axi_read: reusable simulation task
task axi_read;
    input  [11:0] addr;
    integer timeout;
    begin
        @(posedge clk); #1;
        s_axil_araddr  = addr;
        s_axil_arvalid = 1'b1;
        s_axil_rready  = 1'b0;

        timeout = 0;
        while (!s_axil_arready) begin
            @(posedge clk); #1;
            timeout = timeout + 1;
            if (timeout > 100) begin
                $display("[FAIL] axi_read: arready timeout at addr=%0h", addr);
                $finish;
            end
        end
        @(posedge clk); #1;
        s_axil_arvalid = 1'b0;
        s_axil_rready  = 1'b1;

        timeout = 0;
        while (!s_axil_rvalid) begin
            @(posedge clk); #1;
            timeout = timeout + 1;
            if (timeout > 100) begin
                $display("[FAIL] axi_read: rvalid timeout at addr=%0h", addr);
                $finish;
            end
        end
        axi_rd_data = s_axil_rdata;
        @(posedge clk); #1;
        s_axil_rready = 1'b0;
    end
endtask
reg [127:0] captured_dout;
reg         got_done;

// wait_direct_done: reusable simulation task
task wait_direct_done;
    integer cyc;
    begin
        got_done      = 1'b0;
        captured_dout = 128'h0;
        cyc = 0;
        while (cyc < 200) begin
            @(posedge clk); #1;
            if (direct_done) begin
                got_done      = 1'b1;
                captured_dout = direct_dout;
                @(posedge clk);
                cyc = 300;
            end else begin
                cyc = cyc + 1;
            end
        end
    end
endtask
// wait_axi_busy_clear: reusable simulation task
task wait_axi_busy_clear;
    integer attempts;
    begin
        attempts = 0;
        begin : poll_loop
            forever begin
                axi_read(12'h44);
                if (axi_rd_data[1] == 1'b0) begin
                    disable poll_loop;
                end
                attempts = attempts + 1;
                if (attempts > 500) begin
                    $display("[FAIL] wait_axi_busy_clear: timeout");
                    disable poll_loop;
                end
            end
        end
    end
endtask
reg [127:0] axi_dout_captured;

// read_axi_dout: reusable simulation task
task read_axi_dout;
    reg [31:0] d0, d1, d2, d3;
    begin
        axi_read(12'h34); d0 = axi_rd_data;
        axi_read(12'h38); d1 = axi_rd_data;
        axi_read(12'h3C); d2 = axi_rd_data;
        axi_read(12'h40); d3 = axi_rd_data;
        axi_dout_captured = {d0, d1, d2, d3};
    end
endtask
// direct_encrypt: reusable simulation task
task direct_encrypt;
    input  [255:0] key;
    input  [127:0] din;
    output [127:0] dout;
    begin
        @(posedge clk); #1;
        direct_key     = key;
        direct_din     = din;
        direct_decrypt = 1'b0;
        direct_start   = 1'b1;
        @(posedge clk); #1;
        direct_start   = 1'b0;
        wait_direct_done;
        dout = captured_dout;
    end
endtask
// direct_decrypt_op: reusable simulation task
task direct_decrypt_op;
    input  [255:0] key;
    input  [127:0] din;
    output [127:0] dout;
    begin
        @(posedge clk); #1;
        direct_key     = key;
        direct_din     = din;
        direct_decrypt = 1'b1;
        direct_start   = 1'b1;
        @(posedge clk); #1;
        direct_start   = 1'b0;
        wait_direct_done;
        dout = captured_dout;
    end
endtask
// axi_write_key: reusable simulation task
task axi_write_key;
    input [255:0] key;
    begin
        axi_write(12'h04, key[255:224]);
        axi_write(12'h08, key[223:192]);
        axi_write(12'h0C, key[191:160]);
        axi_write(12'h10, key[159:128]);
        axi_write(12'h14, key[127:96]);
        axi_write(12'h18, key[95:64]);
        axi_write(12'h1C, key[63:32]);
        axi_write(12'h20, key[31:0]);
    end
endtask
// axi_write_din: reusable simulation task
task axi_write_din;
    input [127:0] din;
    begin
        axi_write(12'h24, din[127:96]);
        axi_write(12'h28, din[95:64]);
        axi_write(12'h2C, din[63:32]);
        axi_write(12'h30, din[31:0]);
    end
endtask
reg [255:0] axi_key_rd;

// read_axi_key: reusable simulation task
task read_axi_key;
    reg [31:0] k0,k1,k2,k3,k4,k5,k6,k7;
    begin
        axi_read(12'h04); k0 = axi_rd_data;
        axi_read(12'h08); k1 = axi_rd_data;
        axi_read(12'h0C); k2 = axi_rd_data;
        axi_read(12'h10); k3 = axi_rd_data;
        axi_read(12'h14); k4 = axi_rd_data;
        axi_read(12'h18); k5 = axi_rd_data;
        axi_read(12'h1C); k6 = axi_rd_data;
        axi_read(12'h20); k7 = axi_rd_data;
        axi_key_rd = {k0,k1,k2,k3,k4,k5,k6,k7};
    end
endtask
reg [127:0] axi_din_rd;

// read_axi_din: reusable simulation task
task read_axi_din;
    reg [31:0] d0,d1,d2,d3;
    begin
        axi_read(12'h24); d0 = axi_rd_data;
        axi_read(12'h28); d1 = axi_rd_data;
        axi_read(12'h2C); d2 = axi_rd_data;
        axi_read(12'h30); d3 = axi_rd_data;
        axi_din_rd = {d0,d1,d2,d3};
    end
endtask
// axi_encrypt: reusable simulation task
task axi_encrypt;
    input  [255:0] key;
    input  [127:0] din;
    input          do_decrypt;
    output [127:0] dout;
    reg [31:0] ctrl_word;
    begin
        axi_write_key(key);
        axi_write_din(din);
        ctrl_word = {30'h0, do_decrypt, 1'b1};
        axi_write(12'h00, ctrl_word);
        wait_axi_busy_clear;
        repeat(5) @(posedge clk);
        read_axi_dout;
        dout = axi_dout_captured;
    end
endtask
localparam KEY_A = 256'h000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f;
localparam DIN_A = 128'h00112233445566778899aabbccddeeff;
localparam KEY_ZERO = 256'h0;
localparam DIN_ZERO = 128'h0;
localparam KEY_ONES = 256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
localparam DIN_ONES = 128'hffffffffffffffffffffffffffffffff;
localparam KEY_D = 256'hdeadbeef_cafebabe_12345678_9abcdef0_0fedcba9_87654321_efbeadde_bebafeca;
localparam DIN_D = 128'h01234567_89abcdef_fedcba98_76543210;
localparam KEY_E = 256'haabbccdd_eeff0011_22334455_66778899_aabbccdd_eeff0011_22334455_66778899;
localparam DIN_E = 128'hdeadbeef_cafebabe_12345678_9abcdef0;
reg [127:0] enc_out_a, dec_out_a;
reg [127:0] enc_out_d, enc_out_d2;
reg [127:0] enc_zero,  dec_zero;
reg [127:0] enc_ones,  dec_ones;
reg [127:0] enc_axi_e;
reg [127:0] axi_enc_zero, axi_dec_zero;
reg [127:0] axi_enc_ones, axi_dec_ones;
// Simulation initialisation or stimulus block
initial begin
    #5_000_000;
    $display("[FAIL] Watchdog timeout");
    $finish;
end
// Simulation initialisation or stimulus block
initial begin
    pass_count     = 0;
    fail_count     = 0;
    s_axil_awaddr  = 12'h0;
    s_axil_awvalid = 1'b0;
    s_axil_wdata   = 32'h0;
    s_axil_wstrb   = 4'hF;
    s_axil_wvalid  = 1'b0;
    s_axil_bready  = 1'b0;
    s_axil_araddr  = 12'h0;
    s_axil_arvalid = 1'b0;
    s_axil_rready  = 1'b0;
    direct_key     = 256'h0;
    direct_din     = 128'h0;
    direct_start   = 1'b0;
    direct_decrypt = 1'b0;
    rst_n = 1'b0;
    repeat(5) @(posedge clk);
    rst_n = 1'b1;
    repeat(3) @(posedge clk);
    report(1, (direct_done === 1'b0), 128'h0);
    report(2, (direct_dout === 128'h0), 128'h0);
    axi_read(12'h44);
    report(3, (axi_rd_data === 32'h0), 128'h0);
    axi_read(12'h00);
    report(4, (axi_rd_data === 32'h0), 128'h0);
    axi_read(12'hFF);
    report(5, (axi_rd_data === 32'hDEAD_BEEF), 128'h0);
    direct_encrypt(KEY_A, DIN_A, enc_out_a);
    report(6, (got_done === 1'b1), 128'h0);
    report(7, (enc_out_a !== 128'h0), 128'h0);
    report(8, (enc_out_a !== DIN_A), 128'h0);
    begin
        reg [127:0] enc_out_a2;
        direct_encrypt(KEY_A, DIN_A, enc_out_a2);
        report(9, (enc_out_a2 === enc_out_a), 128'h0);
    end
    direct_encrypt(KEY_D, DIN_D, enc_out_d);
    report(10, (got_done === 1'b1) && (enc_out_d !== 128'h0), 128'h0);
    direct_decrypt_op(KEY_A, enc_out_a, dec_out_a);
    report(11, (got_done === 1'b1), 128'h0);
    report(12, (dec_out_a !== 128'h0) && (dec_out_a !== enc_out_a), 128'h0);
    begin
        reg [127:0] dec2;
        direct_decrypt_op(KEY_A, enc_out_a, dec2);
        report(13, (got_done === 1'b1) && (dec2 !== 128'h0), 128'h0);
    end
    report(14, (dec_out_a !== 128'h0), 128'h0);
    begin
        reg [127:0] dec_d;
        direct_decrypt_op(KEY_D, enc_out_d, dec_d);
        report(15, (got_done === 1'b1) && (dec_d !== 128'h0) && (dec_d !== enc_out_d), 128'h0);
    end
    axi_write_key(KEY_A);
    read_axi_key;
    report(16, (axi_key_rd === KEY_A), 128'h0);
    axi_write_key(KEY_D);
    read_axi_key;
    report(17, (axi_key_rd === KEY_D), 128'h0);
    axi_write_key(KEY_ZERO);
    read_axi_key;
    report(18, (axi_key_rd === KEY_ZERO), 128'h0);
    axi_write_key(KEY_ONES);
    read_axi_key;
    report(19, (axi_key_rd === KEY_ONES), 128'h0);
    axi_write_key(KEY_E);
    begin
        reg [31:0] k0, k1, k2, k3;
        axi_read(12'h04); k0 = axi_rd_data;
        axi_read(12'h08); k1 = axi_rd_data;
        axi_read(12'h0C); k2 = axi_rd_data;
        axi_read(12'h10); k3 = axi_rd_data;
        report(20, ({k0,k1,k2,k3} === KEY_E[255:128]), 128'h0);
    end
    axi_write_din(DIN_A);
    read_axi_din;
    report(21, (axi_din_rd === DIN_A), 128'h0);
    axi_write_din(DIN_D);
    read_axi_din;
    report(22, (axi_din_rd === DIN_D), 128'h0);
    axi_write_din(DIN_ZERO);
    read_axi_din;
    report(23, (axi_din_rd === DIN_ZERO), 128'h0);
    axi_write_din(128'hffffffffffffffffffffffffffffffff);
    read_axi_din;
    report(24, (axi_din_rd === 128'hffffffffffffffffffffffffffffffff), 128'h0);
    axi_write_din(DIN_E);
    begin
        reg [31:0] d2, d3;
        axi_read(12'h2C); d2 = axi_rd_data;
        axi_read(12'h30); d3 = axi_rd_data;
        report(25, ({d2,d3} === DIN_E[63:0]), 128'h0);
    end
    axi_write(12'h00, 32'h00);
    axi_read(12'h00);
    report(26, (axi_rd_data[1:0] === 2'b00), 128'h0);
    axi_write(12'h00, 32'h02);
    axi_read(12'h00);
    report(27, (axi_rd_data[1] === 1'b1), 128'h0);
    axi_read(12'h44);
    report(28, (axi_rd_data[1:0] === 2'b00), 128'h0);
    axi_read(12'h00);
    report(29, (axi_rd_data[0] === 1'b0), 128'h0);
    axi_read(12'hFC);
    report(30, (axi_rd_data === 32'hDEAD_BEEF), 128'h0);
    axi_write(12'h00, 32'h00);
    direct_encrypt(KEY_D, DIN_A, enc_out_d2);
    report(31, (got_done === 1'b1), 128'h0);
    report(32, (enc_out_d2 !== enc_out_a), 128'h0);
    report(33, (enc_out_d2 !== 128'h0), 128'h0);
    begin
        reg [127:0] enc_d_keya;
        direct_encrypt(KEY_A, DIN_D, enc_d_keya);
        report(34, (enc_d_keya !== enc_out_a), 128'h0);
    end
    begin
        reg [127:0] dec_d2;
        direct_decrypt_op(KEY_D, enc_out_d2, dec_d2);
        report(35, (got_done === 1'b1) && (dec_d2 !== 128'h0) && (dec_d2 !== enc_out_d2), 128'h0);
    end
    axi_encrypt(KEY_E, DIN_E, 1'b0, enc_axi_e);
    report(36, (enc_axi_e !== 128'h0), 128'h0);
    report(37, (enc_axi_e !== DIN_E), 128'h0);
    begin
        reg [127:0] axi_dec_e;
        axi_encrypt(KEY_E, enc_axi_e, 1'b1, axi_dec_e);
        report(38, (axi_dec_e !== 128'h0) && (axi_dec_e !== enc_axi_e), 128'h0);
    end
    axi_read(12'h44);
    report(39, (axi_rd_data[1] === 1'b0), 128'h0);
    begin
        reg [127:0] axi_enc_a;
        axi_encrypt(KEY_A, DIN_A, 1'b0, axi_enc_a);
        report(40, (axi_enc_a === enc_out_a), 128'h0);
    end
    direct_encrypt(KEY_ZERO, DIN_ZERO, enc_zero);
    report(41, (got_done === 1'b1), 128'h0);
    report(42, (enc_zero !== 128'h0), 128'h0);
    direct_decrypt_op(KEY_ZERO, enc_zero, dec_zero);
    report(43, (got_done === 1'b1) && (dec_zero !== 128'h0), 128'h0);
    begin
        reg [127:0] enc_dinA_kzero;
        direct_encrypt(KEY_ZERO, DIN_A, enc_dinA_kzero);
        report(44, (enc_dinA_kzero !== 128'h0) && (enc_dinA_kzero !== DIN_A), 128'h0);
    end
    begin
        reg [127:0] axi_dec_z;
        axi_encrypt(KEY_ZERO, enc_zero, 1'b1, axi_dec_z);
        report(45, (axi_dec_z !== 128'h0) && (axi_dec_z !== enc_zero), 128'h0);
    end
    direct_encrypt(KEY_ONES, DIN_ZERO, enc_ones);
    report(46, (got_done === 1'b1), 128'h0);
    report(47, (enc_ones !== 128'h0), 128'h0);
    report(48, (enc_ones !== enc_zero), 128'h0);
    direct_decrypt_op(KEY_ONES, enc_ones, dec_ones);
    report(49, (got_done === 1'b1) && (dec_ones !== 128'h0) && (dec_ones !== enc_ones), 128'h0);
    begin
        reg [127:0] axi_enc_o, axi_dec_o;
        axi_encrypt(KEY_ONES, DIN_A, 1'b0, axi_enc_o);
        axi_encrypt(KEY_ONES, axi_enc_o, 1'b1, axi_dec_o);
        report(50, (axi_enc_o !== 128'h0) && (axi_dec_o !== 128'h0) && (axi_dec_o !== axi_enc_o), 128'h0);
    end
    $display("RESULT: %0d/50 passed", pass_count);
    $finish;
end

endmodule
