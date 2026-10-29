`timescale 1ns/1ps
// =============================================================================
// tb_pdf_engine.v
//
// RTL verification testbench for india_pdf_engine + aes_ca_accel.
//
// Flow:
//   1. Load PDF bytes into a behavioral SRAM at SRC_BASE.
//   2. Drive india_pdf_engine to ENCRYPT: SRC_BASE → DST_BASE.
//   3. Drive india_pdf_engine to DECRYPT: DST_BASE → OUT_BASE.
//   4. Compare OUT_BASE[0..PDF_LEN-1] word-by-word with original.
//   5. Print TEST PASSED / TEST FAILED.
// =============================================================================

module tb_pdf_engine;

// ---------------------------------------------------------------------------
// Parameters
// ---------------------------------------------------------------------------
localparam CLK_PERIOD   = 10;          // 10 ns → 100 MHz sim clock
localparam RESET_CYCLES = 20;

// ---------------------------------------------------------------------------
// Test-vector selection
// All source files live under test_vectors/  (never mix with TB source).
//   Default : quick 256-byte smoke test from the PDF
//   -DFULL_PDF          : full 89,755-byte PDF
//   -DTEST_AADHAR       : 505,086-byte Aadhaar JPEG
//   -DTEST_GRADIENT     : 196,608-byte synthetic gradient image
//   -DPDF_BYTES_OVERRIDE=N -DTEST_HEX=\"path\" : arbitrary file
// ---------------------------------------------------------------------------
`ifdef TEST_AADHAR
  `define TEST_HEX "test_vectors/aadhar/aadhar.hex"
  `define _BYTE_COUNT 505086
`elsif TEST_GRADIENT
  `define TEST_HEX "test_vectors/gradient/gradient.hex"
  `define _BYTE_COUNT 196608
`elsif FULL_PDF
  `define TEST_HEX "test_vectors/pdf/original.hex"
  `define _BYTE_COUNT 89755
`elsif PDF_BYTES_OVERRIDE
  // TEST_HEX must be supplied by the caller via -DTEST_HEX=\"path\"
  `ifndef TEST_HEX
    `define TEST_HEX "test_vectors/pdf/original.hex"
  `endif
  `define _BYTE_COUNT `PDF_BYTES_OVERRIDE
`else
  `define TEST_HEX "test_vectors/pdf/original.hex"
  `define _BYTE_COUNT 256
`endif

`ifdef PDF_BYTES_OVERRIDE
localparam PDF_BYTES    = `PDF_BYTES_OVERRIDE;
`else
localparam PDF_BYTES    = `_BYTE_COUNT;
`endif
localparam PDF_WORDS    = (PDF_BYTES + 3) / 4;
localparam PAD_BLOCKS   = (PDF_BYTES + 15) / 16;        // # of 16-byte AES blocks
localparam PAD_BYTES    = PAD_BLOCKS * 16;              // padded byte count (multiple of 16)
localparam PAD_WORDS    = PAD_BLOCKS * 4;               // padded size in 32-bit words
localparam BLOB_WORDS   = 4 + PAD_WORDS + 4;            // header + body + tag (in 32-bit words)

// Address map — computed dynamically so any file size works.
// Each region starts at the next 64 KB boundary after the previous region ends.
//   SRC  : [SRC_BASE .. SRC_BASE + PAD_BYTES)
//   DST  : [DST_BASE .. DST_BASE + 16 + PAD_BYTES + 16)   (header + body + tag)
//   OUT  : [OUT_BASE .. OUT_BASE + 16 + PAD_BYTES)         (header + decrypted body)
localparam SRC_BASE  = 32'h0000_0000;
localparam DST_BASE  = ((SRC_BASE + PAD_BYTES + 32'hFFFF) & ~32'hFFFF);  // 64KB-aligned after SRC
localparam OUT_BASE  = ((DST_BASE + 32 + PAD_BYTES + 32'hFFFF) & ~32'hFFFF); // 64KB-aligned after DST blob
localparam MEM_WORDS = ((OUT_BASE + 32 + PAD_BYTES + 32'hFFFF) & ~32'hFFFF) / 4; // covers full OUT region

// AES-256 test key and nonce
localparam [255:0] TEST_KEY   = 256'hdeadbeefcafebabe123456789abcdef00fedcba987654321aabbccddeeff0011;
localparam [127:0] TEST_NONCE = 128'h0123456789abcdeffedcba9876543210;

// ---------------------------------------------------------------------------
// Clock / reset
// ---------------------------------------------------------------------------
reg clk  = 0;
reg rst_n = 0;
always #(CLK_PERIOD/2) clk = ~clk;

initial begin
    repeat (RESET_CYCLES) @(posedge clk);
    @(negedge clk); rst_n = 1;
end

// ---------------------------------------------------------------------------
// Behavioural SRAM (byte-enable write, word read)
// ---------------------------------------------------------------------------
reg [31:0] mem [0:MEM_WORDS-1];

// Block-level diagnostic probe: fires on first body block of each pass
reg [31:0] probe_pass_cnt = 0;
always @(posedge clk) begin
    // Detect S_CTR_REQ (state==7) when block_index is exactly 1 (first body block)
    if (u_pdf.state == 5'd7 && u_pdf.block_index == 32'd1) begin
        probe_pass_cnt <= probe_pass_cnt + 1;
        $display("[PROBE] Pass %0d block1: hmac=%08x%08x%08x%08x data_buf=%08x%08x%08x%08x",
            probe_pass_cnt + 1,
            u_pdf.hmac_accum[127:96], u_pdf.hmac_accum[95:64],
            u_pdf.hmac_accum[63:32],  u_pdf.hmac_accum[31:0],
            u_pdf.data_buf[127:96],   u_pdf.data_buf[95:64],
            u_pdf.data_buf[63:32],    u_pdf.data_buf[31:0]);
    end
    // Also probe after AES done for block 1 (state == S_WAIT_CTR==8, cipher_done, block_index==1)
    if (u_pdf.state == 5'd8 && u_pdf.cipher_done && u_pdf.block_index == 32'd1) begin
        $display("[PROBE] Pass %0d block1 cipher_dout=%08x%08x%08x%08x result_buf=%08x%08x%08x%08x",
            probe_pass_cnt,
            u_pdf.cipher_dout[127:96], u_pdf.cipher_dout[95:64],
            u_pdf.cipher_dout[63:32],  u_pdf.cipher_dout[31:0],
            u_pdf.result_buf[127:96],  u_pdf.result_buf[95:64],
            u_pdf.result_buf[63:32],   u_pdf.result_buf[31:0]);
    end
    // Probe hmac right after block 1 finishes (block_index transitions to 2)
    if (u_pdf.state == 5'd8 && u_pdf.cipher_done && u_pdf.block_index == 32'd1) begin
        // hmac updated in this cycle; print the NEW value next cycle
    end
end

// Print hmac after first block processed — catch when block_index==2 enters S_STORE_WORD
reg probe_block2_seen = 0;
always @(posedge clk) begin
    if (u_pdf.state == 5'd9 && u_pdf.block_index == 32'd2 && !probe_block2_seen) begin
        probe_block2_seen <= 1'b1;
        $display("[PROBE] After block1: hmac=%08x%08x%08x%08x",
            u_pdf.hmac_accum[127:96], u_pdf.hmac_accum[95:64],
            u_pdf.hmac_accum[63:32],  u_pdf.hmac_accum[31:0]);
    end
    // Reset for decrypt pass
    if (u_pdf.start_pulse) probe_block2_seen <= 1'b0;
end

integer mi;
initial begin
    for (mi = 0; mi < MEM_WORDS; mi = mi + 1)
        mem[mi] = 32'h0;
    $readmemh(`TEST_HEX, mem, SRC_BASE/4, SRC_BASE/4 + PDF_WORDS - 1);
    $display("[TB] Loaded %0d words from %s at addr 0x%08x",
             PDF_WORDS, `TEST_HEX, SRC_BASE);
end

// ---------------------------------------------------------------------------
// AES-CA accelerator <-> PDF engine wires
// ---------------------------------------------------------------------------
wire [255:0] cipher_key;
wire [127:0] cipher_din;
wire         cipher_start;
wire         cipher_decrypt;
wire [127:0] cipher_dout;
wire         cipher_done;

// ---------------------------------------------------------------------------
// TRNG: simple counter-based stub (always valid)
// ---------------------------------------------------------------------------
reg [31:0] trng_cnt = 32'h1234_5678;
reg        trng_vld = 0;
always @(posedge clk) begin
    trng_cnt <= trng_cnt + 32'h9e37_79b9;
    trng_vld <= ~trng_vld;
end

// ---------------------------------------------------------------------------
// AXI-Lite slave → PDF engine register interface
// ---------------------------------------------------------------------------
reg  [11:0] s_awaddr  = 0; reg s_awvalid = 0;
reg  [31:0] s_wdata   = 0; reg [3:0] s_wstrb = 4'hF; reg s_wvalid = 0;
wire        s_awready, s_wready, s_bvalid; wire [1:0] s_bresp;
reg         s_bready  = 1;
reg  [11:0] s_araddr  = 0; reg s_arvalid = 0;
wire        s_arready; wire s_rvalid; wire [31:0] s_rdata; wire [1:0] s_rresp;
reg         s_rready  = 1;

// ---------------------------------------------------------------------------
// AXI master from PDF engine → behavioural SRAM
// ---------------------------------------------------------------------------
wire [31:0] m_araddr; wire m_arvalid; reg  m_arready = 0;
reg  [31:0] m_rdata  = 0; wire [1:0] m_rresp_w; reg [1:0] m_rresp = 0;
reg         m_rvalid = 0; wire m_rready;

wire [31:0] m_awaddr; wire m_awvalid; reg  m_awready = 0;
wire [31:0] m_wdata;  wire [3:0] m_wstrb_w; wire m_wvalid;
reg         m_wready = 0;
wire [1:0]  m_bresp_w; reg [1:0] m_bbresp = 0; reg m_bvalid = 0; wire m_bready;

assign m_rresp_w  = 2'b00;
assign m_bresp_w  = 2'b00;

// ---------------------------------------------------------------------------
// DUT instances
// ---------------------------------------------------------------------------
aes_ca_accel u_aes (
    .clk            (clk),
    .rst_n          (rst_n),
    .direct_key     (cipher_key),
    .direct_din     (cipher_din),
    .direct_start   (cipher_start),
    .direct_decrypt (cipher_decrypt),
    .direct_dout    (cipher_dout),
    .direct_done    (cipher_done),
    // AXI-Lite slave (unused in direct mode)
    .s_axil_awaddr  (12'h0), .s_axil_awvalid(1'b0),
    .s_axil_wdata   (32'h0), .s_axil_wstrb  (4'h0), .s_axil_wvalid(1'b0),
    .s_axil_bready  (1'b1),
    .s_axil_araddr  (12'h0), .s_axil_arvalid(1'b0),
    .s_axil_rready  (1'b1)
);

india_pdf_engine u_pdf (
    .clk            (clk),
    .rst_n          (rst_n),
    // CSR slave
    .s_awaddr       (s_awaddr),  .s_awvalid(s_awvalid), .s_awready(s_awready),
    .s_wdata        (s_wdata),   .s_wstrb  (s_wstrb),   .s_wvalid (s_wvalid),
    .s_wready       (s_wready),  .s_bresp  (s_bresp),   .s_bvalid (s_bvalid),
    .s_bready       (s_bready),
    .s_araddr       (s_araddr),  .s_arvalid(s_arvalid), .s_arready(s_arready),
    .s_rdata        (s_rdata),   .s_rresp  (s_rresp),   .s_rvalid (s_rvalid),
    .s_rready       (s_rready),
    // AXI master → SRAM
    .m_araddr       (m_araddr),  .m_arvalid(m_arvalid), .m_arready(m_arready),
    .m_rdata        (m_rdata),   .m_rresp  (m_rresp),   .m_rvalid (m_rvalid),
    .m_rready       (m_rready),
    .m_awaddr       (m_awaddr),  .m_awvalid(m_awvalid), .m_awready(m_awready),
    .m_wdata        (m_wdata),   .m_wstrb  (m_wstrb_w), .m_wvalid (m_wvalid),
    .m_wready       (m_wready),
    .m_bresp        (m_bbresp),  .m_bvalid (m_bvalid),  .m_bready (m_bready),
    // AES accelerator (direct mode)
    .cipher_key     (cipher_key),
    .cipher_din     (cipher_din),
    .cipher_start   (cipher_start),
    .cipher_decrypt (cipher_decrypt),
    .cipher_dout    (cipher_dout),
    .cipher_done    (cipher_done),
    // TRNG
    .trng_data      (trng_cnt),
    .trng_valid     (trng_vld),
    .irq            ()
);

// ---------------------------------------------------------------------------
// Behavioural SRAM responder — AXI4-Lite, 1-cycle read latency
// Write: latch address separately so it stays valid when wready fires.
// ---------------------------------------------------------------------------
reg [31:0] rd_addr_lat;
reg        rd_pending  = 0;
reg [31:0] wr_addr_lat = 0;
reg        wr_addr_vld = 0;

always @(posedge clk) begin : sram_model
    // ── READ ──────────────────────────────────────────────────────────────
    // Default: lower ready/valid each cycle; re-assert below if needed
    m_arready <= 1'b0;
    if (!rd_pending) m_rvalid <= 1'b0;

    if (m_arvalid && !m_arready) begin
        m_arready   <= 1'b1;
        rd_addr_lat <= m_araddr;
        rd_pending  <= 1'b1;
    end
    if (rd_pending && !m_rvalid) begin          // return data one cycle after addr
        m_rdata    <= mem[rd_addr_lat >> 2];
        m_rvalid   <= 1'b1;
        m_rresp    <= 2'b00;
        rd_pending <= 1'b0;
    end
    if (m_rvalid && m_rready)
        m_rvalid <= 1'b0;

    // ── WRITE ─────────────────────────────────────────────────────────────
    m_awready <= 1'b0;
    m_wready  <= 1'b0;
    m_bvalid  <= 1'b0;

    // Latch write address
    if (m_awvalid && !m_awready && !wr_addr_vld) begin
        m_awready   <= 1'b1;
        wr_addr_lat <= m_awaddr;
        wr_addr_vld <= 1'b1;
    end
    // Accept write data once we have an address
    if (m_wvalid && !m_wready && wr_addr_vld) begin
        m_wready <= 1'b1;
        if (m_wstrb_w[3]) mem[wr_addr_lat >> 2][31:24] <= m_wdata[31:24];
        if (m_wstrb_w[2]) mem[wr_addr_lat >> 2][23:16] <= m_wdata[23:16];
        if (m_wstrb_w[1]) mem[wr_addr_lat >> 2][15: 8] <= m_wdata[15: 8];
        if (m_wstrb_w[0]) mem[wr_addr_lat >> 2][ 7: 0] <= m_wdata[ 7: 0];
        wr_addr_vld <= 1'b0;
        m_bvalid    <= 1'b1;
        m_bbresp    <= 2'b00;
    end
    if (m_bvalid && m_bready) m_bvalid <= 1'b0;
end

// ---------------------------------------------------------------------------
// CSR write helper task
// ---------------------------------------------------------------------------
task csr_write;
    input [11:0] addr;
    input [31:0] data;
    begin
        @(posedge clk); #1;
        s_awaddr  = addr; s_awvalid = 1;
        s_wdata   = data; s_wvalid  = 1; s_wstrb = 4'hF;
        @(posedge clk); #1;
        while (!s_awready) @(posedge clk);
        s_awvalid = 0;
        while (!s_wready)  @(posedge clk);
        s_wvalid  = 0;
        while (!s_bvalid)  @(posedge clk);
    end
endtask

// ---------------------------------------------------------------------------
// CSR read helper task
// ---------------------------------------------------------------------------
reg [31:0] csr_rd_data;
task csr_read;
    input [11:0] addr;
    begin
        @(posedge clk); #1;
        s_araddr  = addr; s_arvalid = 1;
        @(posedge clk); #1;
        while (!s_arready) @(posedge clk);
        s_arvalid = 0;
        while (!s_rvalid)  @(posedge clk);
        csr_rd_data = s_rdata;
    end
endtask

// ---------------------------------------------------------------------------
// Poll until reg_busy=0  (offset 0x08 bit[0]=busy)
// ---------------------------------------------------------------------------
task wait_done;
    integer timeout;
    begin
        timeout = 0;
        csr_rd_data = 32'h1;
        while (csr_rd_data[0]) begin
            repeat (20) @(posedge clk);
            csr_read(12'h08);
            timeout = timeout + 1;
            if (timeout > 50000) begin
                $display("[TB] TIMEOUT waiting for engine to finish");
                $finish;
            end
        end
    end
endtask

// ---------------------------------------------------------------------------
// Main test sequence
// ---------------------------------------------------------------------------
integer i, errors;
reg [31:0] orig_word, out_word;

initial begin
    // VCD disabled — enable with -DVCD for waveform debug
`ifdef VCD
    $dumpfile("tb_pdf_engine.vcd");
    $dumpvars(0, tb_pdf_engine);
`endif

    // Wait for reset
    @(posedge rst_n); repeat (5) @(posedge clk);

    $display("[TB] ========================================================");
    $display("[TB]  INDIA_CRYPTO_SOC — PDF Engine RTL Verification");
    $display("[TB]  PDF size: %0d bytes (%0d words)", PDF_BYTES, PDF_WORDS);
    $display("[TB] ========================================================");

    // ── ENCRYPT ────────────────────────────────────────────────────────────
    $display("[TB] STEP 1: Encrypt  SRC=0x%08x → DST=0x%08x", SRC_BASE, DST_BASE);

    // Program key (offsets 0x28-0x44)
    csr_write(12'h28, TEST_KEY[255:224]);
    csr_write(12'h2C, TEST_KEY[223:192]);
    csr_write(12'h30, TEST_KEY[191:160]);
    csr_write(12'h34, TEST_KEY[159:128]);
    csr_write(12'h38, TEST_KEY[127: 96]);
    csr_write(12'h3C, TEST_KEY[ 95: 64]);
    csr_write(12'h40, TEST_KEY[ 63: 32]);
    csr_write(12'h44, TEST_KEY[ 31:  0]);

    // Program nonce (offsets 0x18-0x24)
    csr_write(12'h18, TEST_NONCE[127:96]);
    csr_write(12'h1C, TEST_NONCE[ 95:64]);
    csr_write(12'h20, TEST_NONCE[ 63:32]);
    csr_write(12'h24, TEST_NONCE[ 31: 0]);

    // Addresses and length
    csr_write(12'h0C, SRC_BASE);
    csr_write(12'h10, DST_BASE);
    csr_write(12'h14, PAD_BYTES);  // must be multiple-of-16: pad to AES block boundary

    // doc_id_lo, doc_id_hi, timestamp, auth_level
    csr_write(12'h58, 32'h20260001);
    csr_write(12'h5C, 32'hC91A500C);
    csr_write(12'h60, 32'h67200000);
    csr_write(12'h64, 32'h2);

    // app_mode = 1
    csr_write(12'h04, 32'h1);

    // Start encrypt (bit1=decrypt_mode=0, bit0=start)
    csr_write(12'h00, 32'h1);

    // Wait for S_DONE (state==16) using direct signal monitoring
    begin : poll_encrypt
        integer enc_cycles;
        enc_cycles = 0;
        @(posedge clk);
        while (u_pdf.state !== 5'd16) begin
            @(posedge clk);
            enc_cycles = enc_cycles + 1;
            if ((enc_cycles % 1000000) == 0)
                $display("[TB] Encrypt progress: %0d Mcycles, state=%0d", enc_cycles/1000000, u_pdf.state);
            if (enc_cycles > 200000000) begin
                $display("[TB] TIMEOUT in encrypt after %0d cycles", enc_cycles);
                $finish;
            end
        end
        @(posedge clk);  // let S_DONE register its outputs
    end
    $display("[TB] Encrypt done. block_index=%0d hmac=%08x%08x%08x%08x",
             u_pdf.block_index,
             u_pdf.hmac_accum[127:96], u_pdf.hmac_accum[95:64],
             u_pdf.hmac_accum[63:32],  u_pdf.hmac_accum[31:0]);

    // Dump first 4 words of ciphertext blob (at DST_BASE+16)
    $display("[TB] Blob check: mem[DST_BASE+16..+28] = %08x %08x %08x %08x",
             mem[(DST_BASE+16)/4], mem[(DST_BASE+20)/4],
             mem[(DST_BASE+24)/4], mem[(DST_BASE+28)/4]);
    $display("[TB] Blob check: SRC plaintext[0..3]   = %08x %08x %08x %08x",
             mem[SRC_BASE/4], mem[SRC_BASE/4+1],
             mem[SRC_BASE/4+2], mem[SRC_BASE/4+3]);

    // ── DECRYPT ────────────────────────────────────────────────────────────
    // Blob layout at DST_BASE:
    //   [DST_BASE .. DST_BASE+15]           16B encrypted header
    //   [DST_BASE+16 .. DST_BASE+16+PAD-1]  padded ciphertext  (PAD_WORDS*4 bytes)
    //   [DST_BASE+16+PAD .. +15]             16B auth tag
    //
    // For decrypt the pdf_engine reads the BODY starting at src_addr.
    // We must point src_addr past the 16B header → DST_BASE + 16.
    // The auth tag in the blob must be loaded into exp_tag CSR for S_VERIFY.

    // Tag offset = DST_BASE + 16 + PAD_BYTES (= PAD_WORDS*4)
    $display("[TB] STEP 2a: Load auth tag from blob → exp_tag CSR");
    begin
        reg [31:0] tag_base;
        tag_base = DST_BASE + 16 + PAD_WORDS*4;
        csr_write(12'h48, mem[tag_base/4]);
        csr_write(12'h4C, mem[tag_base/4 + 1]);
        csr_write(12'h50, mem[tag_base/4 + 2]);
        csr_write(12'h54, mem[tag_base/4 + 3]);
        $display("[TB]   tag @ 0x%08x: %08x %08x %08x %08x",
            tag_base,
            mem[tag_base/4], mem[tag_base/4+1],
            mem[tag_base/4+2], mem[tag_base/4+3]);
    end

    $display("[TB] STEP 2b: Decrypt  SRC=0x%08x → DST=0x%08x",
             DST_BASE + 16, OUT_BASE);

    csr_write(12'h28, TEST_KEY[255:224]);
    csr_write(12'h2C, TEST_KEY[223:192]);
    csr_write(12'h30, TEST_KEY[191:160]);
    csr_write(12'h34, TEST_KEY[159:128]);
    csr_write(12'h38, TEST_KEY[127: 96]);
    csr_write(12'h3C, TEST_KEY[ 95: 64]);
    csr_write(12'h40, TEST_KEY[ 63: 32]);
    csr_write(12'h44, TEST_KEY[ 31:  0]);

    csr_write(12'h18, TEST_NONCE[127:96]);
    csr_write(12'h1C, TEST_NONCE[ 95:64]);
    csr_write(12'h20, TEST_NONCE[ 63:32]);
    csr_write(12'h24, TEST_NONCE[ 31: 0]);

    // src = body of encrypted blob (skip 16B header), dst = output area
    csr_write(12'h0C, DST_BASE + 16);   // skip encrypted header
    csr_write(12'h10, OUT_BASE);
    csr_write(12'h14, PAD_BYTES);  // must be multiple-of-16: pad to AES block boundary

    csr_write(12'h58, 32'h20260001);
    csr_write(12'h5C, 32'hC91A500C);
    csr_write(12'h60, 32'h67200000);
    csr_write(12'h64, 32'h2);
    csr_write(12'h04, 32'h1);

    // Start decrypt (bit1=decrypt_mode=1, bit0=start)
    csr_write(12'h00, 32'h3);

    // Wait for S_DONE (state==16) using direct signal monitoring
    begin : poll_decrypt
        integer dec_cycles;
        dec_cycles = 0;
        @(posedge clk);
        while (u_pdf.state !== 5'd16) begin
            @(posedge clk);
            dec_cycles = dec_cycles + 1;
            if ((dec_cycles % 1000000) == 0)
                $display("[TB] Decrypt progress: %0d Mcycles, state=%0d", dec_cycles/1000000, u_pdf.state);
            if (dec_cycles > 200000000) begin
                $display("[TB] TIMEOUT in decrypt after %0d cycles", dec_cycles);
                $finish;
            end
        end
        @(posedge clk);  // let S_DONE register auth outputs
    end
    $display("[TB] Decrypt done. block_index=%0d hmac=%08x%08x%08x%08x",
             u_pdf.block_index,
             u_pdf.hmac_accum[127:96], u_pdf.hmac_accum[95:64],
             u_pdf.hmac_accum[63:32],  u_pdf.hmac_accum[31:0]);

    // Use the persistent latches — immune to S_IDLE clearing the flags
    $display("[TB] Auth tag result: auth_ok=%0d  auth_fail=%0d",
             auth_ok_lat, auth_fail_lat);
    $display("[TB]   result_tag = %08x %08x %08x %08x",
             u_pdf.result_tag[127:96], u_pdf.result_tag[95:64],
             u_pdf.result_tag[63:32],  u_pdf.result_tag[31:0]);
    $display("[TB]   exp_tag    = %08x %08x %08x %08x",
             u_pdf.exp_tag[127:96], u_pdf.exp_tag[95:64],
             u_pdf.exp_tag[63:32],  u_pdf.exp_tag[31:0]);
    if (auth_ok_lat)
        $display("[TB] Auth tag: PASS");
    else if (auth_fail_lat)
        $display("[TB] Auth tag: FAIL (tag mismatch)");

    // Decrypted body lands at OUT_BASE + 16 (engine offsets dst by 16 for header slot)
    $display("[TB] STEP 3: Compare  OUT_BASE+16 vs SRC_BASE word-by-word ...");

    // ── COMPARE ────────────────────────────────────────────────────────────
    errors = 0;
    for (i = 0; i < PDF_WORDS; i = i + 1) begin
        orig_word = mem[SRC_BASE/4 + i];
        out_word  = mem[(OUT_BASE + 16)/4 + i];
        if (orig_word !== out_word) begin
            if (errors < 10)
                $display("[TB]   MISMATCH word[%0d] (byte %0d): orig=0x%08x  out=0x%08x",
                         i, i*4, orig_word, out_word);
            errors = errors + 1;
        end
    end

    $display("[TB] ========================================================");
    if (errors == 0 && auth_ok_lat) begin
        $display("[TB] TEST PASSED — RTL decrypt matches original PDF exactly");
        $display("[TB]   All %0d words (%0d bytes) byte-for-byte identical", PDF_WORDS, PDF_BYTES);
        $display("[TB]   Auth tag: verified");
        $display("[TB]   First word: 0x%08x  (%s)",
                 mem[SRC_BASE/4],
                 (mem[SRC_BASE/4] == 32'h25504446) ? "%%PDF header valid" : "unexpected");
    end else begin
        $display("[TB] TEST FAILED");
        if (errors > 0)
            $display("[TB]   %0d/%0d words corrupted", errors, PDF_WORDS);
        if (!auth_ok_lat)
            $display("[TB]   Auth tag: %s", auth_fail_lat ? "FAIL" : "not captured");
    end
    $display("[TB] ========================================================");

    #100;
    $finish;
end

// ---------------------------------------------------------------------------
// Auth-status latch — captures auth_ok/auth_fail the cycle they fire
// (they are one-cycle pulses cleared by S_IDLE before TB can poll CSR)
// ---------------------------------------------------------------------------
reg auth_ok_lat   = 0;
reg auth_fail_lat = 0;
always @(posedge clk) begin
    if (u_pdf.reg_auth_ok)   auth_ok_lat   <= 1'b1;
    if (u_pdf.reg_auth_fail) auth_fail_lat <= 1'b1;
    // Reset latches when a new operation starts
    if (u_pdf.start_pulse) begin
        auth_ok_lat   <= 1'b0;
        auth_fail_lat <= 1'b0;
    end
end

// ---------------------------------------------------------------------------
// State monitor — print PDF-engine and AES-accel state every 50k cycles
// ---------------------------------------------------------------------------
initial begin : monitor
    integer cyc;
    cyc = 0;
    @(posedge rst_n);
    forever begin
        repeat (50000) @(posedge clk);
        cyc = cyc + 50000;
        $display("[MON @%0dk] pdf_state=%0d aes_state=%0d busy=%0d ks_idx=%0d round=%0d",
            cyc/1000,
            u_pdf.state,
            u_aes.state_r,
            u_pdf.reg_busy,
            u_aes.ks_idx,
            u_aes.round_r);
    end
end

// ---------------------------------------------------------------------------
// Watchdog
// ---------------------------------------------------------------------------
initial begin
    #8_000_000_000; // 8 s sim time (supports up to ~500KB files)
    $display("[TB] WATCHDOG TIMEOUT");
    $finish;
end

endmodule
