// =============================================================================
// india_pdf_engine.v — Streaming AES-CTR PDF Encryption/Decryption Engine
// Project  : INDIA_CRYPTO_SOC — AES-accelerated PDF encryption
//
// PURPOSE  : Full-file AES-256-CTR encryption/decryption of government PDFs.
//            Reads input from SRAM via AXI-Lite master DMA, drives the
//            aes_ca_accel via its direct wire interface (one 128-bit block
//            per invocation), writes encrypted output back to SRAM, prepends
//            an application-specific metadata header, and appends a 128-bit
//            CA-HMAC integrity tag computed with Rule-30 cellular automaton.
//
// APPLICATIONS (app_mode):
//   2'd0  AADHAAR   : UID authority biometric ID documents
//   2'd1  GOVT_DOC  : NIC / DigiLocker central & state government documents
//   2'd2  MEDICAL   : ABDM / DICOM / FHIR health record PDFs
//
// AXI-LITE SLAVE REGISTER MAP (12-bit addr, 32-bit data):
//   0x000  CTRL        [0]=START [1]=DECRYPT [2]=IRQ_EN
//   0x004  APP_MODE    [1:0]
//   0x008  STATUS      [0]=busy [1]=done [2]=auth_ok [3]=auth_fail [4]=error
//   0x00C  SRC_ADDR    input PDF SRAM base address
//   0x010  DST_ADDR    output SRAM base address
//   0x014  PDF_LEN     byte count (must be multiple of 16)
//   0x018  NONCE[0]    nonce bits [127:96]
//   0x01C  NONCE[1]    nonce bits [95:64]
//   0x020  NONCE[2]    nonce bits [63:32]
//   0x024  NONCE[3]    nonce bits [31:0]
//   0x028  KEY[0]      key bits [255:224]
//   0x02C  KEY[1]      key bits [223:192]
//   0x030  KEY[2]      key bits [191:160]
//   0x034  KEY[3]      key bits [159:128]
//   0x038  KEY[4]      key bits [127:96]
//   0x03C  KEY[5]      key bits [95:64]
//   0x040  KEY[6]      key bits [63:32]
//   0x044  KEY[7]      key bits [31:0]
//   0x048  EXP_TAG[0]  expected HMAC tag [127:96]
//   0x04C  EXP_TAG[1]  expected HMAC tag [95:64]
//   0x050  EXP_TAG[2]  expected HMAC tag [63:32]
//   0x054  EXP_TAG[3]  expected HMAC tag [31:0]
//   0x058  DOC_ID_LO   document ID [31:0]
//   0x05C  DOC_ID_HI   document ID [63:32]
//   0x060  TIMESTAMP   Unix timestamp [31:0]
//   0x064  AUTH_LEVEL  [1:0] (0=public,1=restricted,2=secret,3=top-secret)
//   0x068  RESULT_TAG[0] computed HMAC [127:96]  (read-only)
//   0x06C  RESULT_TAG[1] computed HMAC [95:64]   (read-only)
//   0x070  RESULT_TAG[2] computed HMAC [63:32]   (read-only)
//   0x074  RESULT_TAG[3] computed HMAC [31:0]    (read-only)
//
// OUTPUT PACKET FORMAT at dst_addr:
//   [0..15]       encrypted metadata header (one 128-bit AES-CTR block)
//   [16..N+15]    encrypted PDF (N = pdf_len bytes)
//   [N+16..N+31]  CA-HMAC integrity tag (128-bit, plaintext)
//
// CTR COUNTER BLOCK: {nonce[127:32], block_index[31:0]}
//   block 0 = header, blocks 1..M = PDF data
//
// CA-HMAC (Rule-30, 8 iterations):
//   header_seed = {doc_id[63:0], timestamp[31:0], auth_level[1:0],
//                  app_mode[1:0], pdf_len[31:0]}  (padded to 128 bits)
//   initial hmac_accum = ca30_8rounds(header_seed XOR nonce)
//   per data block: hmac_accum = ca30_8rounds(hmac_accum XOR ciphertext_block)
//   final tag = ca30_8rounds(hmac_accum XOR header_seed)
//
// DIRECT AES-CA INTERFACE (matches aes_ca_accel.v):
//   cipher_key[255:0], cipher_din[127:0], cipher_start, cipher_decrypt
//   cipher_dout[127:0], cipher_done
// =============================================================================

`timescale 1ns/1ps

module india_pdf_engine #(
    parameter AW = 32,
    parameter DW = 32
)(
    input  wire         clk,
    input  wire         rst_n,

    // -------------------------------------------------------------------------
    // AXI-Lite SLAVE — CPU configuration port
    // -------------------------------------------------------------------------
    input  wire [11:0]  s_awaddr,
    input  wire         s_awvalid,
    output reg          s_awready,
    input  wire [31:0]  s_wdata,
    input  wire [3:0]   s_wstrb,
    input  wire         s_wvalid,
    output reg          s_wready,
    output reg  [1:0]   s_bresp,
    output reg          s_bvalid,
    input  wire         s_bready,
    input  wire [11:0]  s_araddr,
    input  wire         s_arvalid,
    output reg          s_arready,
    output reg  [31:0]  s_rdata,
    output reg  [1:0]   s_rresp,
    output reg          s_rvalid,
    input  wire         s_rready,

    // -------------------------------------------------------------------------
    // AXI-Lite MASTER — SRAM DMA port
    // -------------------------------------------------------------------------
    output reg  [31:0]  m_araddr,
    output reg          m_arvalid,
    input  wire         m_arready,
    input  wire [31:0]  m_rdata,
    input  wire [1:0]   m_rresp,
    input  wire         m_rvalid,
    output reg          m_rready,

    output reg  [31:0]  m_awaddr,
    output reg          m_awvalid,
    input  wire         m_awready,
    output reg  [31:0]  m_wdata,
    output reg  [3:0]   m_wstrb,
    output reg          m_wvalid,
    input  wire         m_wready,
    input  wire [1:0]   m_bresp,
    input  wire         m_bvalid,
    output reg          m_bready,

    // -------------------------------------------------------------------------
    // AES-CA accelerator direct interface (to aes_ca_accel.v)
    // -------------------------------------------------------------------------
    output reg  [255:0] cipher_key,
    output reg  [127:0] cipher_din,
    output reg          cipher_start,
    output wire         cipher_decrypt,    // 1 when CTRL[1]=DECRYPT → inverse CA rounds

    input  wire [127:0] cipher_dout,
    input  wire         cipher_done,

    // -------------------------------------------------------------------------
    // TRNG interface (from rosc_trng.v — ring-oscillator TRNG, 28nm)
    // -------------------------------------------------------------------------
    input  wire [31:0]  trng_data,
    input  wire         trng_valid,

    // -------------------------------------------------------------------------
    // Interrupt output
    // -------------------------------------------------------------------------
    output reg          irq
);

// In CA-augmented AES, DECRYPT uses inverse CA rounds (InvSubBytes/Rows/MixCols).
// cipher_decrypt mirrors the CTRL[1] DECRYPT bit set by firmware.
assign cipher_decrypt = decrypt_mode;

// =============================================================================
// FSM STATE ENCODING  (5-bit to accommodate 17 states without aliasing)
// =============================================================================
localparam [4:0]
    S_IDLE       = 5'd0,
    S_TRNG_KEY   = 5'd1,
    S_TRNG_NONCE = 5'd2,
    S_BUILD_HDR  = 5'd3,
    S_ENC_HDR    = 5'd4,
    S_LOAD_WORD  = 5'd5,
    S_WAIT_LOAD  = 5'd6,
    S_CTR_REQ    = 5'd7,
    S_WAIT_CTR   = 5'd8,
    S_STORE_WORD = 5'd9,
    S_WAIT_STORE = 5'd10,
    S_WRITE_TAG  = 5'd11,
    S_WAIT_TAG   = 5'd12,
    S_VERIFY     = 5'd13,
    S_ZEROIZE    = 5'd14,
    S_WAIT_ZERO  = 5'd15,
    S_DONE       = 5'd16;

// =============================================================================
// CONFIGURATION REGISTERS (written by CPU via AXI-Lite slave)
// =============================================================================
reg [1:0]   app_mode;
reg [31:0]  src_addr;
reg [31:0]  dst_addr;
reg [31:0]  pdf_len;
reg [127:0] nonce;
reg [255:0] key;
reg [127:0] exp_tag;
reg [31:0]  doc_id_lo;
reg [31:0]  doc_id_hi;
reg [31:0]  timestamp;
reg [1:0]   auth_level;
reg         irq_en;
reg         decrypt_mode;

// STATUS bits
reg         reg_busy;
reg         reg_done;
reg         reg_auth_ok;
reg         reg_auth_fail;
reg         reg_error;

// Computed HMAC result (readable after done)
reg [127:0] result_tag;

// =============================================================================
// INTERNAL OPERATIONAL REGISTERS
// =============================================================================
reg [4:0]   state;

// TRNG collection counters
reg [2:0]   trng_key_cnt;    // 0..7 (8 words for 256-bit key)
reg [1:0]   trng_nonce_cnt;  // 0..3 (4 words for 128-bit nonce)
reg         key_preloaded;
reg         nonce_preloaded;

// DMA tracking
reg [31:0]  src_ptr;         // current read pointer
reg [31:0]  dst_ptr;         // current write pointer
reg [31:0]  bytes_remaining; // bytes left to process
reg [31:0]  block_index;     // current CTR block index (0=header, 1..N=data)

// 128-bit data buffer (assembled from 4 x 32-bit DMA reads)
reg [127:0] data_buf;
reg [1:0]   word_idx;        // 0..3 within a 128-bit block

// 128-bit result buffer (4 x 32-bit writes)
reg [127:0] result_buf;

// CA-HMAC accumulator
reg [127:0] hmac_accum;
reg [127:0] header_seed;

// Zeroize counter
reg [31:0]  zero_ptr;
reg [31:0]  zero_end;

// AXI slave write address latch
reg [11:0]  aw_addr_lat;
reg         aw_addr_valid_r;

// Start pulse (one-cycle)
reg         start_pulse;

// =============================================================================
// RULE-30 CELLULAR AUTOMATON FUNCTIONS
// =============================================================================

// One Rule-30 step on a 128-bit state (wrap-around at edges)
// Rule 30: new[i] = state[i-1] XOR (state[i] OR state[i+1])
function [127:0] ca30_step;
    input [127:0] s;
    reg [127:0] ns;
    integer i;
    begin
        for (i = 0; i < 128; i = i + 1) begin
            ns[i] = s[(i + 127) % 128] ^ (s[i] | s[(i + 1) % 128]);
        end
        ca30_step = ns;
    end
endfunction

// 8 rounds of Rule-30 CA on a 128-bit state
function [127:0] ca30_8rounds;
    input [127:0] s;
    reg [127:0] t;
    begin
        t = ca30_step(s);
        t = ca30_step(t);
        t = ca30_step(t);
        t = ca30_step(t);
        t = ca30_step(t);
        t = ca30_step(t);
        t = ca30_step(t);
        t = ca30_step(t);
        ca30_8rounds = t;
    end
endfunction

// =============================================================================
// HEADER SEED COMPUTATION
// Build 128-bit header_seed from document metadata fields
// Layout: {doc_id_hi[31:0], doc_id_lo[31:0], timestamp[31:0],
//          auth_level[7:0], app_mode[7:0], pdf_len[31:0], 8'd0}
// = 32+32+32+8+8+32 = 144 bits → truncate to 128 by dropping lowest 16 bits
// Practical packing: [127:96]=doc_id_hi, [95:64]=doc_id_lo,
//                    [63:32]=timestamp, [31:16]={auth_level[1:0],6'b0,app_mode[1:0],6'b0},
//                    [15:0]=pdf_len[31:16]  (upper half, gives unique per-length)
// =============================================================================
function [127:0] build_header_seed;
    input [31:0] dhi;
    input [31:0] dlo;
    input [31:0] ts;
    input [1:0]  al;
    input [1:0]  am;
    input [31:0] plen;
    begin
        build_header_seed = { dhi,
                               dlo,
                               ts,
                               al[1:0], 6'h00, am[1:0], 6'h00,
                               plen[31:16] };
    end
endfunction

// =============================================================================
// BUILD 128-BIT METADATA HEADER BLOCK (plaintext, encrypted in S_ENC_HDR)
// {app_mode[7:0], auth_level[7:0], pdf_len[31:0], doc_id[63:0], 8'd0}
// =============================================================================
function [127:0] build_header_block;
    input [1:0]  am;
    input [1:0]  al;
    input [31:0] plen;
    input [31:0] dhi;
    input [31:0] dlo;
    begin
        build_header_block = { {6'h00, am[1:0]},
                                {6'h00, al[1:0]},
                                plen,
                                dhi,
                                dlo,
                                8'h00 };
    end
endfunction

// =============================================================================
// COUNTER BLOCK CONSTRUCTION
// {nonce[127:32], block_index[31:0]}
// =============================================================================
function [127:0] build_ctr_block;
    input [127:0] n;
    input [31:0]  bidx;
    begin
        build_ctr_block = {n[127:32], bidx};
    end
endfunction

// =============================================================================
// CONSTANT-TIME 128-BIT COMPARE (returns 1 if equal, 0 if not)
// Accumulates XOR across all bits; done in one combinational step.
// =============================================================================
function tag_equal;
    input [127:0] a;
    input [127:0] b;
    reg [127:0] diff;
    begin
        diff      = a ^ b;
        tag_equal = (diff == 128'h0);
    end
endfunction

// =============================================================================
// AXI-LITE SLAVE — CPU CONFIGURATION PORT
// =============================================================================
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        s_awready      <= 1'b0;
        s_wready       <= 1'b0;
        s_bvalid       <= 1'b0;
        s_bresp        <= 2'b00;
        aw_addr_lat    <= 12'h0;
        aw_addr_valid_r<= 1'b0;
        start_pulse    <= 1'b0;
        // Config register reset values
        app_mode       <= 2'd0;
        src_addr       <= 32'h0;
        dst_addr       <= 32'h0;
        pdf_len        <= 32'h0;
        nonce          <= 128'h0;
        key            <= 256'h0;
        exp_tag        <= 128'h0;
        doc_id_lo      <= 32'h0;
        doc_id_hi      <= 32'h0;
        timestamp      <= 32'h0;
        auth_level     <= 2'd0;
        irq_en         <= 1'b0;
        decrypt_mode   <= 1'b0;
    end else begin
        start_pulse <= 1'b0;

        // Address phase
        if (s_awvalid && !s_awready) begin
            s_awready       <= 1'b1;
            aw_addr_lat     <= s_awaddr;
            aw_addr_valid_r <= 1'b1;
        end else begin
            s_awready <= 1'b0;
        end

        // Data phase
        if (s_wvalid && aw_addr_valid_r && !s_wready) begin
            s_wready        <= 1'b1;
            aw_addr_valid_r <= 1'b0;
            s_bvalid        <= 1'b1;
            s_bresp         <= 2'b00;

            case (aw_addr_lat[7:0])
                8'h00: begin // CTRL
                    irq_en       <= s_wdata[2];
                    decrypt_mode <= s_wdata[1];
                    if (s_wdata[0] && (state == S_IDLE))
                        start_pulse <= 1'b1;
                end
                8'h04: app_mode   <= s_wdata[1:0];
                // STATUS 0x08 is read-only
                8'h0C: src_addr   <= s_wdata;
                8'h10: dst_addr   <= s_wdata;
                8'h14: pdf_len    <= s_wdata;
                8'h18: nonce[127:96]  <= s_wdata;
                8'h1C: nonce[95:64]   <= s_wdata;
                8'h20: nonce[63:32]   <= s_wdata;
                8'h24: nonce[31:0]    <= s_wdata;
                8'h28: key[255:224]   <= s_wdata;
                8'h2C: key[223:192]   <= s_wdata;
                8'h30: key[191:160]   <= s_wdata;
                8'h34: key[159:128]   <= s_wdata;
                8'h38: key[127:96]    <= s_wdata;
                8'h3C: key[95:64]     <= s_wdata;
                8'h40: key[63:32]     <= s_wdata;
                8'h44: key[31:0]      <= s_wdata;
                8'h48: exp_tag[127:96] <= s_wdata;
                8'h4C: exp_tag[95:64]  <= s_wdata;
                8'h50: exp_tag[63:32]  <= s_wdata;
                8'h54: exp_tag[31:0]   <= s_wdata;
                8'h58: doc_id_lo      <= s_wdata;
                8'h5C: doc_id_hi      <= s_wdata;
                8'h60: timestamp      <= s_wdata;
                8'h64: auth_level     <= s_wdata[1:0];
                // RESULT_TAG 0x68..0x74 is read-only
                default: ;
            endcase
        end else begin
            s_wready <= 1'b0;
        end

        if (s_bvalid && s_bready)
            s_bvalid <= 1'b0;
    end
end

// Read channel
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        s_arready <= 1'b0;
        s_rvalid  <= 1'b0;
        s_rdata   <= 32'h0;
        s_rresp   <= 2'b00;
    end else begin
        if (s_arvalid && !s_arready) begin
            s_arready <= 1'b1;
            s_rvalid  <= 1'b1;
            s_rresp   <= 2'b00;
            case (s_araddr[7:0])
                8'h00: s_rdata <= {29'h0, irq_en, decrypt_mode, 1'b0};
                8'h04: s_rdata <= {30'h0, app_mode};
                8'h08: s_rdata <= {27'h0, reg_error, reg_auth_fail, reg_auth_ok,
                                          reg_done, reg_busy};
                8'h0C: s_rdata <= src_addr;
                8'h10: s_rdata <= dst_addr;
                8'h14: s_rdata <= pdf_len;
                8'h18: s_rdata <= nonce[127:96];
                8'h1C: s_rdata <= nonce[95:64];
                8'h20: s_rdata <= nonce[63:32];
                8'h24: s_rdata <= nonce[31:0];
                8'h28: s_rdata <= key[255:224];
                8'h2C: s_rdata <= key[223:192];
                8'h30: s_rdata <= key[191:160];
                8'h34: s_rdata <= key[159:128];
                8'h38: s_rdata <= key[127:96];
                8'h3C: s_rdata <= key[95:64];
                8'h40: s_rdata <= key[63:32];
                8'h44: s_rdata <= key[31:0];
                8'h48: s_rdata <= exp_tag[127:96];
                8'h4C: s_rdata <= exp_tag[95:64];
                8'h50: s_rdata <= exp_tag[63:32];
                8'h54: s_rdata <= exp_tag[31:0];
                8'h58: s_rdata <= doc_id_lo;
                8'h5C: s_rdata <= doc_id_hi;
                8'h60: s_rdata <= timestamp;
                8'h64: s_rdata <= {30'h0, auth_level};
                8'h68: s_rdata <= result_tag[127:96];
                8'h6C: s_rdata <= result_tag[95:64];
                8'h70: s_rdata <= result_tag[63:32];
                8'h74: s_rdata <= result_tag[31:0];
                default: s_rdata <= 32'hDEAD_BEEF;
            endcase
        end else begin
            s_arready <= 1'b0;
        end

        if (s_rvalid && s_rready)
            s_rvalid <= 1'b0;
    end
end

// =============================================================================
// MAIN OPERATIONAL FSM
// =============================================================================
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state           <= S_IDLE;
        reg_busy        <= 1'b0;
        reg_done        <= 1'b0;
        reg_auth_ok     <= 1'b0;
        reg_auth_fail   <= 1'b0;
        reg_error       <= 1'b0;
        irq             <= 1'b0;
        result_tag      <= 128'h0;
        hmac_accum      <= 128'h0;
        header_seed     <= 128'h0;
        data_buf        <= 128'h0;
        result_buf      <= 128'h0;
        block_index     <= 32'h0;
        word_idx        <= 2'd0;
        src_ptr         <= 32'h0;
        dst_ptr         <= 32'h0;
        bytes_remaining <= 32'h0;
        zero_ptr        <= 32'h0;
        zero_end        <= 32'h0;
        trng_key_cnt    <= 3'd0;
        trng_nonce_cnt  <= 2'd0;
        key_preloaded   <= 1'b0;
        nonce_preloaded <= 1'b0;
        cipher_key      <= 256'h0;
        cipher_din      <= 128'h0;
        cipher_start    <= 1'b0;
        // Master AXI defaults
        m_araddr        <= 32'h0;
        m_arvalid       <= 1'b0;
        m_rready        <= 1'b0;
        m_awaddr        <= 32'h0;
        m_awvalid       <= 1'b0;
        m_wdata         <= 32'h0;
        m_wstrb         <= 4'hF;
        m_wvalid        <= 1'b0;
        m_bready        <= 1'b0;
    end else begin
        // Default pulse signals
        cipher_start <= 1'b0;
        irq          <= 1'b0;

        case (state)

            // -----------------------------------------------------------------
            // S_IDLE: Wait for START from CPU
            // -----------------------------------------------------------------
            S_IDLE: begin
                reg_busy      <= 1'b0;
                reg_done      <= 1'b0;
                reg_auth_ok   <= 1'b0;
                reg_auth_fail <= 1'b0;
                reg_error     <= 1'b0;

                if (start_pulse) begin
                    reg_busy        <= 1'b1;
                    reg_done        <= 1'b0;
                    block_index     <= 32'h0;
                    word_idx        <= 2'd0;
                    hmac_accum      <= 128'h0;
                    result_tag      <= 128'h0;

                    // Detect pre-loaded key: non-zero key register means firmware supplied it
                    key_preloaded   <= (key != 256'h0);
                    // Detect pre-loaded nonce
                    nonce_preloaded <= (nonce != 128'h0);

                    if (key != 256'h0) begin
                        // Key pre-loaded — check nonce next
                        if (nonce != 128'h0) begin
                            // Both pre-loaded, go straight to header build
                            state <= S_BUILD_HDR;
                        end else begin
                            trng_nonce_cnt <= 2'd0;
                            state          <= S_TRNG_NONCE;
                        end
                    end else begin
                        trng_key_cnt <= 3'd0;
                        state        <= S_TRNG_KEY;
                    end
                end
            end

            // -----------------------------------------------------------------
            // S_TRNG_KEY: Collect 8 x 32-bit TRNG words to form 256-bit key
            // -----------------------------------------------------------------
            S_TRNG_KEY: begin
                if (trng_valid) begin
                    case (trng_key_cnt)
                        3'd0: key[255:224] <= trng_data;
                        3'd1: key[223:192] <= trng_data;
                        3'd2: key[191:160] <= trng_data;
                        3'd3: key[159:128] <= trng_data;
                        3'd4: key[127:96]  <= trng_data;
                        3'd5: key[95:64]   <= trng_data;
                        3'd6: key[63:32]   <= trng_data;
                        3'd7: key[31:0]    <= trng_data;
                        default: ;
                    endcase
                    if (trng_key_cnt == 3'd7) begin
                        if (nonce != 128'h0) begin
                            state <= S_BUILD_HDR;
                        end else begin
                            trng_nonce_cnt <= 2'd0;
                            state          <= S_TRNG_NONCE;
                        end
                    end else begin
                        trng_key_cnt <= trng_key_cnt + 3'd1;
                    end
                end
            end

            // -----------------------------------------------------------------
            // S_TRNG_NONCE: Collect 4 x 32-bit TRNG words for 128-bit nonce
            // -----------------------------------------------------------------
            S_TRNG_NONCE: begin
                if (trng_valid) begin
                    case (trng_nonce_cnt)
                        2'd0: nonce[127:96] <= trng_data;
                        2'd1: nonce[95:64]  <= trng_data;
                        2'd2: nonce[63:32]  <= trng_data;
                        2'd3: nonce[31:0]   <= trng_data;
                        default: ;
                    endcase
                    if (trng_nonce_cnt == 2'd3) begin
                        state <= S_BUILD_HDR;
                    end else begin
                        trng_nonce_cnt <= trng_nonce_cnt + 2'd1;
                    end
                end
            end

            // -----------------------------------------------------------------
            // S_BUILD_HDR: Compute header_seed and initial hmac_accum,
            //              assemble counter block 0, arm AES-CA for header
            // -----------------------------------------------------------------
            S_BUILD_HDR: begin
                // Compute header seed
                header_seed <= build_header_seed(doc_id_hi, doc_id_lo,
                                                  timestamp, auth_level,
                                                  app_mode, pdf_len);

                // Initial HMAC accumulator: CA30_8rounds(header_seed XOR nonce)
                // Note: header_seed is computed this cycle; use combinational
                // value directly for the CA function input
                hmac_accum <= ca30_8rounds(
                    build_header_seed(doc_id_hi, doc_id_lo,
                                      timestamp, auth_level,
                                      app_mode, pdf_len) ^ nonce
                );

                // Latch cipher key
                cipher_key  <= key;

                // Encrypt counter block 0 (header block)
                cipher_din   <= build_ctr_block(nonce, 32'h0);
                block_index  <= 32'h0;

                // DMA pointers
                src_ptr         <= src_addr;
                dst_ptr         <= dst_addr + 32'd16; // first 16 bytes = header
                bytes_remaining <= pdf_len;

                state <= S_ENC_HDR;
            end

            // -----------------------------------------------------------------
            // S_ENC_HDR: Send counter block 0 to AES-CA, write encrypted header
            //            On decrypt path, skip writing — header already in place.
            // -----------------------------------------------------------------
            S_ENC_HDR: begin
                // Issue one-cycle start pulse to AES-CA (CTR block 0)
                if (!cipher_start && !cipher_done) begin
                    cipher_start <= 1'b1;
                end

                if (cipher_done) begin
                    // keystream[0] = cipher_dout
                    // plaintext header block
                    result_buf  <= build_header_block(app_mode, auth_level,
                                                      pdf_len, doc_id_hi, doc_id_lo)
                                   ^ cipher_dout;

                    // For decrypt path: output = plaintext XOR keystream = ciphertext XOR keystream = plaintext
                    // Same formula, CTR is symmetric.

                    block_index <= 32'd1;
                    word_idx    <= 2'd0;

                    if (!decrypt_mode) begin
                        // Write encrypted header to dst_addr + 0
                        m_awaddr  <= dst_addr;
                        m_awvalid <= 1'b1;
                        m_wdata   <= result_buf[127:96]; // will be updated word-by-word
                        m_wstrb   <= 4'hF;
                        m_wvalid  <= 1'b0;
                        // Use S_STORE_WORD to drain the header too
                        // Pack into result_buf for the store loop
                        // result_buf already set above; reset word_idx
                        word_idx  <= 2'd0;
                        dst_ptr   <= dst_addr;           // header goes at base
                        state     <= S_STORE_WORD;
                    end else begin
                        // Decrypt: skip header write, begin data loop
                        dst_ptr   <= dst_addr + 32'd16;
                        src_ptr   <= src_addr;           // encrypted data follows header in src
                        state     <= S_LOAD_WORD;
                    end
                end
            end

            // -----------------------------------------------------------------
            // S_LOAD_WORD: Issue AXI-Lite read for next 32-bit word from src
            //              Collect 4 words to fill data_buf (128-bit block)
            // -----------------------------------------------------------------
            S_LOAD_WORD: begin
                if (bytes_remaining == 32'h0) begin
                    // All PDF blocks processed — write HMAC tag
                    state <= S_WRITE_TAG;
                end else begin
                    m_araddr  <= src_ptr;
                    m_arvalid <= 1'b1;
                    m_rready  <= 1'b1;
                    state     <= S_WAIT_LOAD;
                end
            end

            // -----------------------------------------------------------------
            // S_WAIT_LOAD: Wait for AXI read handshake, accumulate into data_buf
            // -----------------------------------------------------------------
            S_WAIT_LOAD: begin
                if (m_arvalid && m_arready) begin
                    m_arvalid <= 1'b0;
                end

                if (m_rvalid && m_rready) begin
                    m_rready <= 1'b0;
                    src_ptr  <= src_ptr + 32'd4;

                    // Pack word into data_buf (big-endian: word 0 = bits [127:96])
                    case (word_idx)
                        2'd0: data_buf[127:96] <= m_rdata;
                        2'd1: data_buf[95:64]  <= m_rdata;
                        2'd2: data_buf[63:32]  <= m_rdata;
                        2'd3: data_buf[31:0]   <= m_rdata;
                        default: ;
                    endcase

                    if (word_idx == 2'd3) begin
                        // Full 128-bit block assembled — request keystream
                        word_idx  <= 2'd0;
                        state     <= S_CTR_REQ;
                    end else begin
                        word_idx <= word_idx + 2'd1;
                        state    <= S_LOAD_WORD;
                    end
                end
            end

            // -----------------------------------------------------------------
            // S_CTR_REQ: Drive counter block into AES-CA and assert start
            // -----------------------------------------------------------------
            S_CTR_REQ: begin
                cipher_din   <= build_ctr_block(nonce, block_index);
                cipher_start <= 1'b1;
                state        <= S_WAIT_CTR;
            end

            // -----------------------------------------------------------------
            // S_WAIT_CTR: Wait for AES-CA to finish; XOR to get result;
            //             update HMAC accumulator
            // -----------------------------------------------------------------
            S_WAIT_CTR: begin
                if (cipher_done) begin
                    // CTR: output = input XOR keystream
                    result_buf  <= data_buf ^ cipher_dout;

                    // HMAC update: use ciphertext block (encrypt-then-MAC)
                    // On encrypt path: ciphertext = data_buf XOR cipher_dout = result_buf
                    // On decrypt path: ciphertext = data_buf (the input was ciphertext)
                    if (!decrypt_mode) begin
                        hmac_accum <= ca30_8rounds(hmac_accum ^ (data_buf ^ cipher_dout));
                    end else begin
                        hmac_accum <= ca30_8rounds(hmac_accum ^ data_buf);
                    end

                    block_index     <= block_index + 32'd1;
                    bytes_remaining <= bytes_remaining - 32'd16;
                    word_idx        <= 2'd0;
                    state           <= S_STORE_WORD;
                end
            end

            // -----------------------------------------------------------------
            // S_STORE_WORD: Write one 32-bit word of result_buf to dst_ptr
            // -----------------------------------------------------------------
            S_STORE_WORD: begin
                // Select word from result_buf
                case (word_idx)
                    2'd0: m_wdata <= result_buf[127:96];
                    2'd1: m_wdata <= result_buf[95:64];
                    2'd2: m_wdata <= result_buf[63:32];
                    2'd3: m_wdata <= result_buf[31:0];
                    default: m_wdata <= 32'h0;
                endcase

                m_awaddr  <= dst_ptr;
                m_awvalid <= 1'b1;
                m_wstrb   <= 4'hF;
                m_wvalid  <= 1'b1;
                m_bready  <= 1'b1;
                state     <= S_WAIT_STORE;
            end

            // -----------------------------------------------------------------
            // S_WAIT_STORE: Wait for AXI write handshake to complete
            // -----------------------------------------------------------------
            S_WAIT_STORE: begin
                if (m_awvalid && m_awready) begin
                    m_awvalid <= 1'b0;
                end
                if (m_wvalid && m_wready) begin
                    m_wvalid <= 1'b0;
                end

                if (m_bvalid && m_bready) begin
                    m_bready <= 1'b0;
                    dst_ptr  <= dst_ptr + 32'd4;

                    if (word_idx == 2'd3) begin
                        // Finished writing 4 words of this block
                        word_idx <= 2'd0;

                        // Check context: were we writing the header?
                        // We distinguish by comparing dst_ptr range:
                        // Header store: dst_ptr was dst_addr..dst_addr+12
                        // After header, advance to data region
                        if (!decrypt_mode && (dst_ptr == dst_addr + 32'd12)) begin
                            // Header done; start data DMA
                            dst_ptr   <= dst_addr + 32'd16;
                            src_ptr   <= src_addr;
                            state     <= S_LOAD_WORD;
                        end else begin
                            // Data block done; load next data block
                            state <= S_LOAD_WORD;
                        end
                    end else begin
                        word_idx <= word_idx + 2'd1;
                        state    <= S_STORE_WORD;
                    end
                end
            end

            // -----------------------------------------------------------------
            // S_WRITE_TAG: Compute final HMAC tag, write 128 bits (4 words)
            //              to dst_addr + 16 + pdf_len
            // -----------------------------------------------------------------
            S_WRITE_TAG: begin
                // Final HMAC: ca30_8rounds(hmac_accum XOR header_seed)
                result_tag <= ca30_8rounds(hmac_accum ^ header_seed);
                // Set up write pointer for tag region
                dst_ptr    <= dst_addr + 32'd16 + pdf_len;
                word_idx   <= 2'd0;
                state      <= S_WAIT_TAG;
            end

            // -----------------------------------------------------------------
            // S_WAIT_TAG: Write 4 x 32-bit tag words sequentially.
            //             Each iteration issues one word write and waits for
            //             the write response before advancing.
            // -----------------------------------------------------------------
            S_WAIT_TAG: begin
                // Drive write address and data for the current tag word
                case (word_idx)
                    2'd0: m_wdata <= result_tag[127:96];
                    2'd1: m_wdata <= result_tag[95:64];
                    2'd2: m_wdata <= result_tag[63:32];
                    2'd3: m_wdata <= result_tag[31:0];
                    default: m_wdata <= 32'h0;
                endcase

                if (!m_awvalid && !m_wvalid && !m_bvalid) begin
                    // Issue next write only when the channel is idle
                    m_awaddr  <= dst_ptr;
                    m_awvalid <= 1'b1;
                    m_wstrb   <= 4'hF;
                    m_wvalid  <= 1'b1;
                    m_bready  <= 1'b1;
                end

                if (m_awvalid && m_awready) m_awvalid <= 1'b0;
                if (m_wvalid  && m_wready)  m_wvalid  <= 1'b0;

                if (m_bvalid && m_bready) begin
                    m_bready <= 1'b0;
                    dst_ptr  <= dst_ptr + 32'd4;

                    if (word_idx == 2'd3) begin
                        // All 4 tag words written
                        word_idx <= 2'd0;
                        if (decrypt_mode) begin
                            state <= S_VERIFY;
                        end else begin
                            reg_auth_ok <= 1'b1;
                            state       <= S_DONE;
                        end
                    end else begin
                        word_idx <= word_idx + 2'd1;
                        // Stay in S_WAIT_TAG; next word issues on the following cycle
                    end
                end
            end

            // -----------------------------------------------------------------
            // S_VERIFY: Constant-time compare result_tag vs exp_tag
            // -----------------------------------------------------------------
            S_VERIFY: begin
                if (tag_equal(result_tag, exp_tag)) begin
                    reg_auth_ok   <= 1'b1;
                    reg_auth_fail <= 1'b0;
                    state         <= S_DONE;
                end else begin
                    reg_auth_fail <= 1'b1;
                    reg_auth_ok   <= 1'b0;
                    // Zero out the destination to prevent leaking plaintext
                    zero_ptr <= dst_addr;
                    zero_end <= dst_addr + 32'd16 + pdf_len + 32'd16; // header+data+tag
                    state    <= S_ZEROIZE;
                end
            end

            // -----------------------------------------------------------------
            // S_ZEROIZE: Write 32'h0 to every word from dst_addr to
            //            dst_addr + pdf_len + 31 (header 16B + data NB + tag 16B)
            // -----------------------------------------------------------------
            S_ZEROIZE: begin
                if (zero_ptr >= zero_end) begin
                    state <= S_DONE;
                end else begin
                    m_awaddr  <= zero_ptr;
                    m_awvalid <= 1'b1;
                    m_wdata   <= 32'h0;
                    m_wstrb   <= 4'hF;
                    m_wvalid  <= 1'b1;
                    m_bready  <= 1'b1;
                    state     <= S_WAIT_ZERO;
                end
            end

            // -----------------------------------------------------------------
            // S_WAIT_ZERO: Wait for zeroize write, advance pointer
            // -----------------------------------------------------------------
            S_WAIT_ZERO: begin
                if (m_awvalid && m_awready) m_awvalid <= 1'b0;
                if (m_wvalid  && m_wready)  m_wvalid  <= 1'b0;

                if (m_bvalid && m_bready) begin
                    m_bready <= 1'b0;
                    zero_ptr <= zero_ptr + 32'd4;
                    state    <= S_ZEROIZE;
                end
            end

            // -----------------------------------------------------------------
            // S_DONE (5'd16): Set done flag, fire IRQ if enabled, return IDLE
            // -----------------------------------------------------------------
            S_DONE: begin
                reg_busy <= 1'b0;
                reg_done <= 1'b1;
                if (irq_en)
                    irq <= 1'b1;
                state <= S_IDLE;
            end

            default: state <= S_IDLE;

        endcase
    end
end

endmodule
