`timescale 1ns/1ps

module india_pdf_engine #(
    parameter AW = 32,
    parameter DW = 32
)(
    input  wire         clk,
    input  wire         rst_n,

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

    output reg  [255:0] cipher_key,
    output reg  [127:0] cipher_din,
    output reg          cipher_start,
    output wire         cipher_decrypt,

    input  wire [127:0] cipher_dout,
    input  wire         cipher_done,

    input  wire [31:0]  trng_data,
    input  wire         trng_valid,

    output reg          irq
);

assign cipher_decrypt = decrypt_mode;

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

reg         reg_busy;
reg         reg_done;
reg         reg_auth_ok;
reg         reg_auth_fail;
reg         reg_error;

reg [127:0] result_tag;

reg [4:0]   state;

reg [2:0]   trng_key_cnt;
reg [1:0]   trng_nonce_cnt;
reg         key_preloaded;
reg         nonce_preloaded;

reg [31:0]  src_ptr;
reg [31:0]  dst_ptr;
reg [31:0]  bytes_remaining;
reg [31:0]  block_index;

reg [127:0] data_buf;
reg [1:0]   word_idx;

reg [127:0] result_buf;

reg [127:0] hmac_accum;
reg [127:0] header_seed;

reg [31:0]  zero_ptr;
reg [31:0]  zero_end;

reg [11:0]  aw_addr_lat;
reg         aw_addr_valid_r;

reg         start_pulse;

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

function [127:0] build_ctr_block;
    input [127:0] n;
    input [31:0]  bidx;
    begin
        build_ctr_block = {n[127:32], bidx};
    end
endfunction

function tag_equal;
    input [127:0] a;
    input [127:0] b;
    reg [127:0] diff;
    begin
        diff      = a ^ b;
        tag_equal = (diff == 128'h0);
    end
endfunction

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        s_awready      <= 1'b0;
        s_wready       <= 1'b0;
        s_bvalid       <= 1'b0;
        s_bresp        <= 2'b00;
        aw_addr_lat    <= 12'h0;
        aw_addr_valid_r<= 1'b0;
        start_pulse    <= 1'b0;

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

        if (s_awvalid && !s_awready) begin
            s_awready       <= 1'b1;
            aw_addr_lat     <= s_awaddr;
            aw_addr_valid_r <= 1'b1;
        end else begin
            s_awready <= 1'b0;
        end

        if (s_wvalid && aw_addr_valid_r && !s_wready) begin
            s_wready        <= 1'b1;
            aw_addr_valid_r <= 1'b0;
            s_bvalid        <= 1'b1;
            s_bresp         <= 2'b00;

            case (aw_addr_lat[7:0])
                8'h00: begin
                    irq_en       <= s_wdata[2];
                    decrypt_mode <= s_wdata[1];
                    if (s_wdata[0] && (state == S_IDLE))
                        start_pulse <= 1'b1;
                end
                8'h04: app_mode   <= s_wdata[1:0];

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

                default: ;
            endcase
        end else begin
            s_wready <= 1'b0;
        end

        if (s_bvalid && s_bready)
            s_bvalid <= 1'b0;
    end
end

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

        cipher_start <= 1'b0;
        irq          <= 1'b0;

        case (state)

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

                    key_preloaded   <= (key != 256'h0);

                    nonce_preloaded <= (nonce != 128'h0);

                    if (key != 256'h0) begin

                        if (nonce != 128'h0) begin

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

            S_BUILD_HDR: begin

                header_seed <= build_header_seed(doc_id_hi, doc_id_lo,
                                                  timestamp, auth_level,
                                                  app_mode, pdf_len);

                hmac_accum <= ca30_8rounds(
                    build_header_seed(doc_id_hi, doc_id_lo,
                                      timestamp, auth_level,
                                      app_mode, pdf_len) ^ nonce
                );

                cipher_key  <= key;

                cipher_din   <= build_ctr_block(nonce, 32'h0);
                block_index  <= 32'h0;

                src_ptr         <= src_addr;
                dst_ptr         <= dst_addr + 32'd16;
                bytes_remaining <= pdf_len;

                state <= S_ENC_HDR;
            end

            S_ENC_HDR: begin

                if (!cipher_start && !cipher_done) begin
                    cipher_start <= 1'b1;
                end

                if (cipher_done) begin

                    result_buf  <= build_header_block(app_mode, auth_level,
                                                      pdf_len, doc_id_hi, doc_id_lo)
                                   ^ cipher_dout;

                    block_index <= 32'd1;
                    word_idx    <= 2'd0;

                    if (!decrypt_mode) begin

                        m_awaddr  <= dst_addr;
                        m_awvalid <= 1'b1;
                        m_wdata   <= result_buf[127:96];
                        m_wstrb   <= 4'hF;
                        m_wvalid  <= 1'b0;

                        word_idx  <= 2'd0;
                        dst_ptr   <= dst_addr;
                        state     <= S_STORE_WORD;
                    end else begin

                        dst_ptr   <= dst_addr + 32'd16;
                        src_ptr   <= src_addr;
                        state     <= S_LOAD_WORD;
                    end
                end
            end

            S_LOAD_WORD: begin
                if (bytes_remaining == 32'h0) begin

                    state <= S_WRITE_TAG;
                end else begin
                    m_araddr  <= src_ptr;
                    m_arvalid <= 1'b1;
                    m_rready  <= 1'b1;
                    state     <= S_WAIT_LOAD;
                end
            end

            S_WAIT_LOAD: begin
                if (m_arvalid && m_arready) begin
                    m_arvalid <= 1'b0;
                end

                if (m_rvalid && m_rready) begin
                    m_rready <= 1'b0;
                    src_ptr  <= src_ptr + 32'd4;

                    case (word_idx)
                        2'd0: data_buf[127:96] <= m_rdata;
                        2'd1: data_buf[95:64]  <= m_rdata;
                        2'd2: data_buf[63:32]  <= m_rdata;
                        2'd3: data_buf[31:0]   <= m_rdata;
                        default: ;
                    endcase

                    if (word_idx == 2'd3) begin

                        word_idx  <= 2'd0;
                        state     <= S_CTR_REQ;
                    end else begin
                        word_idx <= word_idx + 2'd1;
                        state    <= S_LOAD_WORD;
                    end
                end
            end

            S_CTR_REQ: begin
                cipher_din   <= build_ctr_block(nonce, block_index);
                cipher_start <= 1'b1;
                state        <= S_WAIT_CTR;
            end

            S_WAIT_CTR: begin
                if (cipher_done) begin

                    result_buf  <= data_buf ^ cipher_dout;

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

            S_STORE_WORD: begin

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

                        word_idx <= 2'd0;

                        if (!decrypt_mode && (dst_ptr == dst_addr + 32'd12)) begin

                            dst_ptr   <= dst_addr + 32'd16;
                            src_ptr   <= src_addr;
                            state     <= S_LOAD_WORD;
                        end else begin

                            state <= S_LOAD_WORD;
                        end
                    end else begin
                        word_idx <= word_idx + 2'd1;
                        state    <= S_STORE_WORD;
                    end
                end
            end

            S_WRITE_TAG: begin

                result_tag <= ca30_8rounds(hmac_accum ^ header_seed);

                dst_ptr    <= dst_addr + 32'd16 + pdf_len;
                word_idx   <= 2'd0;
                state      <= S_WAIT_TAG;
            end

            S_WAIT_TAG: begin

                case (word_idx)
                    2'd0: m_wdata <= result_tag[127:96];
                    2'd1: m_wdata <= result_tag[95:64];
                    2'd2: m_wdata <= result_tag[63:32];
                    2'd3: m_wdata <= result_tag[31:0];
                    default: m_wdata <= 32'h0;
                endcase

                if (!m_awvalid && !m_wvalid && !m_bvalid) begin

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

                        word_idx <= 2'd0;
                        if (decrypt_mode) begin
                            state <= S_VERIFY;
                        end else begin
                            reg_auth_ok <= 1'b1;
                            state       <= S_DONE;
                        end
                    end else begin
                        word_idx <= word_idx + 2'd1;

                    end
                end
            end

            S_VERIFY: begin
                if (tag_equal(result_tag, exp_tag)) begin
                    reg_auth_ok   <= 1'b1;
                    reg_auth_fail <= 1'b0;
                    state         <= S_DONE;
                end else begin
                    reg_auth_fail <= 1'b1;
                    reg_auth_ok   <= 1'b0;

                    zero_ptr <= dst_addr;
                    zero_end <= dst_addr + 32'd16 + pdf_len + 32'd16;
                    state    <= S_ZEROIZE;
                end
            end

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

            S_WAIT_ZERO: begin
                if (m_awvalid && m_awready) m_awvalid <= 1'b0;
                if (m_wvalid  && m_wready)  m_wvalid  <= 1'b0;

                if (m_bvalid && m_bready) begin
                    m_bready <= 1'b0;
                    zero_ptr <= zero_ptr + 32'd4;
                    state    <= S_ZEROIZE;
                end
            end

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
