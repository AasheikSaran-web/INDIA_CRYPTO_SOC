// =============================================================================
// axi_lite_xbar.v — Parameterised AXI-Lite Crossbar
// Project  : INDIA_CRYPTO_SOC
//
// N_MASTERS = 2 : m0 = CPU dmem (higher priority), m1 = PDF-engine DMA
// N_SLAVES  = 8 : s0..s7, address-decoded by BASE/MASK pairs
//
// Address decode: combinational, (addr & MASK) == BASE
// Arbitration:    when both masters target the same slave, m0 wins;
//                 m1 stalls (m1_awready / m1_arready de-asserted).
// Error response: if no slave matches, SLVERR (bresp/rresp = 2'b10),
//                 rdata = 32'hDEAD_BEEF.
//
// Flat port style (no unpacked arrays) for synthesis compatibility.
// =============================================================================
`default_nettype none
`timescale 1ns/1ps

module axi_lite_xbar #(
    parameter N_MASTERS = 2,
    parameter N_SLAVES  = 8,
    // Slave base addresses
    parameter [31:0] BASE0 = 32'h0000_0000,  // Boot ROM
    parameter [31:0] BASE1 = 32'h2000_0000,  // SRAM
    parameter [31:0] BASE2 = 32'h3000_0000,  // AES-CA
    parameter [31:0] BASE3 = 32'h3000_1000,  // MS-TRNG
    parameter [31:0] BASE4 = 32'h3000_2000,  // India PDF Engine
    parameter [31:0] BASE5 = 32'h4000_0000,  // Secure UART
    parameter [31:0] BASE6 = 32'h4000_1000,  // Secure I2C
    parameter [31:0] BASE7 = 32'h4000_2000,  // Secure SPI
    // Address masks (1s = must match)
    parameter [31:0] MASK0 = 32'hFFFF_8000,  // 32 KB
    parameter [31:0] MASK1 = 32'hFFFE_0000,  // 128 KB
    parameter [31:0] MASK2 = 32'hFFFF_F000,  // 4 KB
    parameter [31:0] MASK3 = 32'hFFFF_F000,
    parameter [31:0] MASK4 = 32'hFFFF_F000,
    parameter [31:0] MASK5 = 32'hFFFF_F000,
    parameter [31:0] MASK6 = 32'hFFFF_F000,
    parameter [31:0] MASK7 = 32'hFFFF_F000
)(
    input  wire        clk,
    input  wire        rst_n,

    // -------------------------------------------------------------------------
    // Master 0 — CPU dmem (higher priority)
    // -------------------------------------------------------------------------
    // Write address
    input  wire [31:0] m0_awaddr,
    input  wire        m0_awvalid,
    output wire        m0_awready,
    // Write data
    input  wire [31:0] m0_wdata,
    input  wire [3:0]  m0_wstrb,
    input  wire        m0_wvalid,
    output wire        m0_wready,
    // Write response
    output wire [1:0]  m0_bresp,
    output wire        m0_bvalid,
    input  wire        m0_bready,
    // Read address
    input  wire [31:0] m0_araddr,
    input  wire        m0_arvalid,
    output wire        m0_arready,
    // Read data
    output wire [31:0] m0_rdata,
    output wire [1:0]  m0_rresp,
    output wire        m0_rvalid,
    input  wire        m0_rready,

    // -------------------------------------------------------------------------
    // Master 1 — PDF-engine DMA (lower priority)
    // -------------------------------------------------------------------------
    input  wire [31:0] m1_awaddr,
    input  wire        m1_awvalid,
    output wire        m1_awready,
    input  wire [31:0] m1_wdata,
    input  wire [3:0]  m1_wstrb,
    input  wire        m1_wvalid,
    output wire        m1_wready,
    output wire [1:0]  m1_bresp,
    output wire        m1_bvalid,
    input  wire        m1_bready,
    input  wire [31:0] m1_araddr,
    input  wire        m1_arvalid,
    output wire        m1_arready,
    output wire [31:0] m1_rdata,
    output wire [1:0]  m1_rresp,
    output wire        m1_rvalid,
    input  wire        m1_rready,

    // -------------------------------------------------------------------------
    // Slave 0 — Boot ROM
    // -------------------------------------------------------------------------
    output wire [31:0] s0_awaddr,  output wire s0_awvalid,  input  wire s0_awready,
    output wire [31:0] s0_wdata,   output wire [3:0] s0_wstrb,
    output wire        s0_wvalid,  input  wire s0_wready,
    input  wire [1:0]  s0_bresp,   input  wire s0_bvalid,   output wire s0_bready,
    output wire [31:0] s0_araddr,  output wire s0_arvalid,  input  wire s0_arready,
    input  wire [31:0] s0_rdata,   input  wire [1:0] s0_rresp,
    input  wire        s0_rvalid,  output wire s0_rready,

    // Slave 1 — SRAM
    output wire [31:0] s1_awaddr,  output wire s1_awvalid,  input  wire s1_awready,
    output wire [31:0] s1_wdata,   output wire [3:0] s1_wstrb,
    output wire        s1_wvalid,  input  wire s1_wready,
    input  wire [1:0]  s1_bresp,   input  wire s1_bvalid,   output wire s1_bready,
    output wire [31:0] s1_araddr,  output wire s1_arvalid,  input  wire s1_arready,
    input  wire [31:0] s1_rdata,   input  wire [1:0] s1_rresp,
    input  wire        s1_rvalid,  output wire s1_rready,

    // Slave 2 — AES-CA Accelerator
    output wire [31:0] s2_awaddr,  output wire s2_awvalid,  input  wire s2_awready,
    output wire [31:0] s2_wdata,   output wire [3:0] s2_wstrb,
    output wire        s2_wvalid,  input  wire s2_wready,
    input  wire [1:0]  s2_bresp,   input  wire s2_bvalid,   output wire s2_bready,
    output wire [31:0] s2_araddr,  output wire s2_arvalid,  input  wire s2_arready,
    input  wire [31:0] s2_rdata,   input  wire [1:0] s2_rresp,
    input  wire        s2_rvalid,  output wire s2_rready,

    // Slave 3 — MS-TRNG
    output wire [31:0] s3_awaddr,  output wire s3_awvalid,  input  wire s3_awready,
    output wire [31:0] s3_wdata,   output wire [3:0] s3_wstrb,
    output wire        s3_wvalid,  input  wire s3_wready,
    input  wire [1:0]  s3_bresp,   input  wire s3_bvalid,   output wire s3_bready,
    output wire [31:0] s3_araddr,  output wire s3_arvalid,  input  wire s3_arready,
    input  wire [31:0] s3_rdata,   input  wire [1:0] s3_rresp,
    input  wire        s3_rvalid,  output wire s3_rready,

    // Slave 4 — India PDF Engine config
    output wire [31:0] s4_awaddr,  output wire s4_awvalid,  input  wire s4_awready,
    output wire [31:0] s4_wdata,   output wire [3:0] s4_wstrb,
    output wire        s4_wvalid,  input  wire s4_wready,
    input  wire [1:0]  s4_bresp,   input  wire s4_bvalid,   output wire s4_bready,
    output wire [31:0] s4_araddr,  output wire s4_arvalid,  input  wire s4_arready,
    input  wire [31:0] s4_rdata,   input  wire [1:0] s4_rresp,
    input  wire        s4_rvalid,  output wire s4_rready,

    // Slave 5 — Secure UART
    output wire [31:0] s5_awaddr,  output wire s5_awvalid,  input  wire s5_awready,
    output wire [31:0] s5_wdata,   output wire [3:0] s5_wstrb,
    output wire        s5_wvalid,  input  wire s5_wready,
    input  wire [1:0]  s5_bresp,   input  wire s5_bvalid,   output wire s5_bready,
    output wire [31:0] s5_araddr,  output wire s5_arvalid,  input  wire s5_arready,
    input  wire [31:0] s5_rdata,   input  wire [1:0] s5_rresp,
    input  wire        s5_rvalid,  output wire s5_rready,

    // Slave 6 — Secure I2C
    output wire [31:0] s6_awaddr,  output wire s6_awvalid,  input  wire s6_awready,
    output wire [31:0] s6_wdata,   output wire [3:0] s6_wstrb,
    output wire        s6_wvalid,  input  wire s6_wready,
    input  wire [1:0]  s6_bresp,   input  wire s6_bvalid,   output wire s6_bready,
    output wire [31:0] s6_araddr,  output wire s6_arvalid,  input  wire s6_arready,
    input  wire [31:0] s6_rdata,   input  wire [1:0] s6_rresp,
    input  wire        s6_rvalid,  output wire s6_rready,

    // Slave 7 — Secure SPI
    output wire [31:0] s7_awaddr,  output wire s7_awvalid,  input  wire s7_awready,
    output wire [31:0] s7_wdata,   output wire [3:0] s7_wstrb,
    output wire        s7_wvalid,  input  wire s7_wready,
    input  wire [1:0]  s7_bresp,   input  wire s7_bvalid,   output wire s7_bready,
    output wire [31:0] s7_araddr,  output wire s7_arvalid,  input  wire s7_arready,
    input  wire [31:0] s7_rdata,   input  wire [1:0] s7_rresp,
    input  wire        s7_rvalid,  output wire s7_rready
);

// =============================================================================
// Internal — pack bases/masks for indexed decode
// =============================================================================
wire [31:0] BASE [0:7];
wire [31:0] MASK [0:7];
assign BASE[0] = BASE0; assign MASK[0] = MASK0;
assign BASE[1] = BASE1; assign MASK[1] = MASK1;
assign BASE[2] = BASE2; assign MASK[2] = MASK2;
assign BASE[3] = BASE3; assign MASK[3] = MASK3;
assign BASE[4] = BASE4; assign MASK[4] = MASK4;
assign BASE[5] = BASE5; assign MASK[5] = MASK5;
assign BASE[6] = BASE6; assign MASK[6] = MASK6;
assign BASE[7] = BASE7; assign MASK[7] = MASK7;

// =============================================================================
// Address decode — purely combinational
// =============================================================================

// m0 write/read slave selects (one-hot, 8 bits + 1 error bit)
wire [7:0] m0_aw_sel, m0_ar_sel;
wire [7:0] m1_aw_sel, m1_ar_sel;
wire       m0_aw_err, m0_ar_err, m1_aw_err, m1_ar_err;

genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : DECODE
        assign m0_aw_sel[i] = ((m0_awaddr & MASK[i]) == BASE[i]);
        assign m0_ar_sel[i] = ((m0_araddr & MASK[i]) == BASE[i]);
        assign m1_aw_sel[i] = ((m1_awaddr & MASK[i]) == BASE[i]);
        assign m1_ar_sel[i] = ((m1_araddr & MASK[i]) == BASE[i]);
    end
endgenerate

assign m0_aw_err = (m0_aw_sel == 8'h00);
assign m0_ar_err = (m0_ar_sel == 8'h00);
assign m1_aw_err = (m1_aw_sel == 8'h00);
assign m1_ar_err = (m1_ar_sel == 8'h00);

// =============================================================================
// Arbitration — m0 wins; m1 stalls when same slave targeted simultaneously
// =============================================================================

// Conflict: both masters address the same slave
wire [7:0] aw_conflict = m0_aw_sel & m1_aw_sel;
wire [7:0] ar_conflict = m0_ar_sel & m1_ar_sel;
wire       m1_aw_stall = (|aw_conflict) & m1_awvalid & m0_awvalid;
wire       m1_ar_stall = (|ar_conflict) & m1_arvalid & m0_arvalid;

// =============================================================================
// Per-slave AW mux — m0 has priority; m1 only drives when m0 not selecting
// =============================================================================

// Slave write address / data bus: driven by winning master
// We use wires indexed by slave; build 8 sets of mux outputs

// Pack slave outputs for iteration
wire [31:0] sx_awaddr [0:7];
wire        sx_awvalid[0:7];
wire [31:0] sx_wdata  [0:7];
wire [3:0]  sx_wstrb  [0:7];
wire        sx_wvalid [0:7];
wire        sx_bready [0:7];
wire [31:0] sx_araddr [0:7];
wire        sx_arvalid[0:7];
wire        sx_rready [0:7];

// Pack slave inputs for return
wire        sx_awready[0:7];
wire        sx_wready [0:7];
wire [1:0]  sx_bresp  [0:7];
wire        sx_bvalid [0:7];
wire        sx_arready[0:7];
wire [31:0] sx_rdata  [0:7];
wire [1:0]  sx_rresp  [0:7];
wire        sx_rvalid [0:7];

// Connect flat slave ports to arrays
assign sx_awready[0]=s0_awready; assign sx_wready[0]=s0_wready;
assign sx_bresp[0]=s0_bresp;     assign sx_bvalid[0]=s0_bvalid;
assign sx_arready[0]=s0_arready; assign sx_rdata[0]=s0_rdata;
assign sx_rresp[0]=s0_rresp;     assign sx_rvalid[0]=s0_rvalid;

assign sx_awready[1]=s1_awready; assign sx_wready[1]=s1_wready;
assign sx_bresp[1]=s1_bresp;     assign sx_bvalid[1]=s1_bvalid;
assign sx_arready[1]=s1_arready; assign sx_rdata[1]=s1_rdata;
assign sx_rresp[1]=s1_rresp;     assign sx_rvalid[1]=s1_rvalid;

assign sx_awready[2]=s2_awready; assign sx_wready[2]=s2_wready;
assign sx_bresp[2]=s2_bresp;     assign sx_bvalid[2]=s2_bvalid;
assign sx_arready[2]=s2_arready; assign sx_rdata[2]=s2_rdata;
assign sx_rresp[2]=s2_rresp;     assign sx_rvalid[2]=s2_rvalid;

assign sx_awready[3]=s3_awready; assign sx_wready[3]=s3_wready;
assign sx_bresp[3]=s3_bresp;     assign sx_bvalid[3]=s3_bvalid;
assign sx_arready[3]=s3_arready; assign sx_rdata[3]=s3_rdata;
assign sx_rresp[3]=s3_rresp;     assign sx_rvalid[3]=s3_rvalid;

assign sx_awready[4]=s4_awready; assign sx_wready[4]=s4_wready;
assign sx_bresp[4]=s4_bresp;     assign sx_bvalid[4]=s4_bvalid;
assign sx_arready[4]=s4_arready; assign sx_rdata[4]=s4_rdata;
assign sx_rresp[4]=s4_rresp;     assign sx_rvalid[4]=s4_rvalid;

assign sx_awready[5]=s5_awready; assign sx_wready[5]=s5_wready;
assign sx_bresp[5]=s5_bresp;     assign sx_bvalid[5]=s5_bvalid;
assign sx_arready[5]=s5_arready; assign sx_rdata[5]=s5_rdata;
assign sx_rresp[5]=s5_rresp;     assign sx_rvalid[5]=s5_rvalid;

assign sx_awready[6]=s6_awready; assign sx_wready[6]=s6_wready;
assign sx_bresp[6]=s6_bresp;     assign sx_bvalid[6]=s6_bvalid;
assign sx_arready[6]=s6_arready; assign sx_rdata[6]=s6_rdata;
assign sx_rresp[6]=s6_rresp;     assign sx_rvalid[6]=s6_rvalid;

assign sx_awready[7]=s7_awready; assign sx_wready[7]=s7_wready;
assign sx_bresp[7]=s7_bresp;     assign sx_bvalid[7]=s7_bvalid;
assign sx_arready[7]=s7_arready; assign sx_rdata[7]=s7_rdata;
assign sx_rresp[7]=s7_rresp;     assign sx_rvalid[7]=s7_rvalid;

// =============================================================================
// Slave-side mux: arbitrate which master drives each slave channel
// m0 wins write/read when it selects that slave; m1 drives otherwise
// =============================================================================
generate
    for (i = 0; i < 8; i = i + 1) begin : SMUX
        // Write address channel
        assign sx_awaddr[i]  = m0_aw_sel[i] ? m0_awaddr  : m1_awaddr;
        assign sx_awvalid[i] = m0_aw_sel[i] ? (m0_awvalid & !m0_aw_err) :
                                              (m1_awvalid & m1_aw_sel[i] & !m1_aw_err & !m1_aw_stall);
        // Write data channel — follow the AW winner
        assign sx_wdata[i]   = m0_aw_sel[i] ? m0_wdata   : m1_wdata;
        assign sx_wstrb[i]   = m0_aw_sel[i] ? m0_wstrb   : m1_wstrb;
        assign sx_wvalid[i]  = m0_aw_sel[i] ? m0_wvalid  : (m1_wvalid & m1_aw_sel[i] & !m1_aw_stall);
        // Write response ready
        assign sx_bready[i]  = m0_aw_sel[i] ? m0_bready  : m1_bready;
        // Read address channel
        assign sx_araddr[i]  = m0_ar_sel[i] ? m0_araddr  : m1_araddr;
        assign sx_arvalid[i] = m0_ar_sel[i] ? (m0_arvalid & !m0_ar_err) :
                                              (m1_arvalid & m1_ar_sel[i] & !m1_ar_err & !m1_ar_stall);
        // Read ready
        assign sx_rready[i]  = m0_ar_sel[i] ? m0_rready  : m1_rready;
    end
endgenerate

// =============================================================================
// Connect mux outputs to flat slave ports
// =============================================================================
assign s0_awaddr=sx_awaddr[0]; assign s0_awvalid=sx_awvalid[0];
assign s0_wdata=sx_wdata[0];   assign s0_wstrb=sx_wstrb[0]; assign s0_wvalid=sx_wvalid[0];
assign s0_bready=sx_bready[0]; assign s0_araddr=sx_araddr[0]; assign s0_arvalid=sx_arvalid[0];
assign s0_rready=sx_rready[0];

assign s1_awaddr=sx_awaddr[1]; assign s1_awvalid=sx_awvalid[1];
assign s1_wdata=sx_wdata[1];   assign s1_wstrb=sx_wstrb[1]; assign s1_wvalid=sx_wvalid[1];
assign s1_bready=sx_bready[1]; assign s1_araddr=sx_araddr[1]; assign s1_arvalid=sx_arvalid[1];
assign s1_rready=sx_rready[1];

assign s2_awaddr=sx_awaddr[2]; assign s2_awvalid=sx_awvalid[2];
assign s2_wdata=sx_wdata[2];   assign s2_wstrb=sx_wstrb[2]; assign s2_wvalid=sx_wvalid[2];
assign s2_bready=sx_bready[2]; assign s2_araddr=sx_araddr[2]; assign s2_arvalid=sx_arvalid[2];
assign s2_rready=sx_rready[2];

assign s3_awaddr=sx_awaddr[3]; assign s3_awvalid=sx_awvalid[3];
assign s3_wdata=sx_wdata[3];   assign s3_wstrb=sx_wstrb[3]; assign s3_wvalid=sx_wvalid[3];
assign s3_bready=sx_bready[3]; assign s3_araddr=sx_araddr[3]; assign s3_arvalid=sx_arvalid[3];
assign s3_rready=sx_rready[3];

assign s4_awaddr=sx_awaddr[4]; assign s4_awvalid=sx_awvalid[4];
assign s4_wdata=sx_wdata[4];   assign s4_wstrb=sx_wstrb[4]; assign s4_wvalid=sx_wvalid[4];
assign s4_bready=sx_bready[4]; assign s4_araddr=sx_araddr[4]; assign s4_arvalid=sx_arvalid[4];
assign s4_rready=sx_rready[4];

assign s5_awaddr=sx_awaddr[5]; assign s5_awvalid=sx_awvalid[5];
assign s5_wdata=sx_wdata[5];   assign s5_wstrb=sx_wstrb[5]; assign s5_wvalid=sx_wvalid[5];
assign s5_bready=sx_bready[5]; assign s5_araddr=sx_araddr[5]; assign s5_arvalid=sx_arvalid[5];
assign s5_rready=sx_rready[5];

assign s6_awaddr=sx_awaddr[6]; assign s6_awvalid=sx_awvalid[6];
assign s6_wdata=sx_wdata[6];   assign s6_wstrb=sx_wstrb[6]; assign s6_wvalid=sx_wvalid[6];
assign s6_bready=sx_bready[6]; assign s6_araddr=sx_araddr[6]; assign s6_arvalid=sx_arvalid[6];
assign s6_rready=sx_rready[6];

assign s7_awaddr=sx_awaddr[7]; assign s7_awvalid=sx_awvalid[7];
assign s7_wdata=sx_wdata[7];   assign s7_wstrb=sx_wstrb[7]; assign s7_wvalid=sx_wvalid[7];
assign s7_bready=sx_bready[7]; assign s7_araddr=sx_araddr[7]; assign s7_arvalid=sx_arvalid[7];
assign s7_rready=sx_rready[7];

// =============================================================================
// Master-side return: steer slave responses back to the correct master
// For each master, fold across all 8 slaves; error response if no match.
// =============================================================================

// --- m0 write response ---
reg [1:0]  m0_bresp_r;
reg        m0_bvalid_r;
reg        m0_awready_r;
reg        m0_wready_r;

always @(*) begin : M0_WR_RESP
    integer j;
    m0_bresp_r   = 2'b10;   // default: SLVERR
    m0_bvalid_r  = 1'b0;
    m0_awready_r = 1'b0;
    m0_wready_r  = 1'b0;
    if (m0_aw_err && m0_awvalid) begin
        // No slave matched — generate immediate SLVERR
        m0_awready_r = 1'b1;
        m0_wready_r  = 1'b1;
        m0_bvalid_r  = 1'b1;
        m0_bresp_r   = 2'b10;
    end else begin
        for (j = 0; j < 8; j = j + 1) begin
            if (m0_aw_sel[j]) begin
                m0_awready_r = sx_awready[j];
                m0_wready_r  = sx_wready[j];
                m0_bvalid_r  = sx_bvalid[j];
                m0_bresp_r   = sx_bresp[j];
            end
        end
    end
end

assign m0_awready = m0_awready_r;
assign m0_wready  = m0_wready_r;
assign m0_bvalid  = m0_bvalid_r;
assign m0_bresp   = m0_bresp_r;

// --- m0 read response ---
reg [31:0] m0_rdata_r;
reg [1:0]  m0_rresp_r;
reg        m0_rvalid_r;
reg        m0_arready_r;

always @(*) begin : M0_RD_RESP
    integer j;
    m0_rdata_r   = 32'hDEAD_BEEF;
    m0_rresp_r   = 2'b10;
    m0_rvalid_r  = 1'b0;
    m0_arready_r = 1'b0;
    if (m0_ar_err && m0_arvalid) begin
        m0_arready_r = 1'b1;
        m0_rvalid_r  = 1'b1;
        m0_rresp_r   = 2'b10;
        m0_rdata_r   = 32'hDEAD_BEEF;
    end else begin
        for (j = 0; j < 8; j = j + 1) begin
            if (m0_ar_sel[j]) begin
                m0_arready_r = sx_arready[j];
                m0_rvalid_r  = sx_rvalid[j];
                m0_rresp_r   = sx_rresp[j];
                m0_rdata_r   = sx_rdata[j];
            end
        end
    end
end

assign m0_arready = m0_arready_r;
assign m0_rvalid  = m0_rvalid_r;
assign m0_rresp   = m0_rresp_r;
assign m0_rdata   = m0_rdata_r;

// --- m1 write response ---
reg [1:0]  m1_bresp_r;
reg        m1_bvalid_r;
reg        m1_awready_r;
reg        m1_wready_r;

always @(*) begin : M1_WR_RESP
    integer j;
    m1_bresp_r   = 2'b10;
    m1_bvalid_r  = 1'b0;
    m1_awready_r = 1'b0;
    m1_wready_r  = 1'b0;
    if (m1_aw_stall) begin
        // Stall: do not assert ready
        m1_awready_r = 1'b0;
        m1_wready_r  = 1'b0;
    end else if (m1_aw_err && m1_awvalid) begin
        m1_awready_r = 1'b1;
        m1_wready_r  = 1'b1;
        m1_bvalid_r  = 1'b1;
        m1_bresp_r   = 2'b10;
    end else begin
        for (j = 0; j < 8; j = j + 1) begin
            if (m1_aw_sel[j] && !m0_aw_sel[j]) begin
                m1_awready_r = sx_awready[j];
                m1_wready_r  = sx_wready[j];
                m1_bvalid_r  = sx_bvalid[j];
                m1_bresp_r   = sx_bresp[j];
            end
        end
    end
end

assign m1_awready = m1_awready_r;
assign m1_wready  = m1_wready_r;
assign m1_bvalid  = m1_bvalid_r;
assign m1_bresp   = m1_bresp_r;

// --- m1 read response ---
reg [31:0] m1_rdata_r;
reg [1:0]  m1_rresp_r;
reg        m1_rvalid_r;
reg        m1_arready_r;

always @(*) begin : M1_RD_RESP
    integer j;
    m1_rdata_r   = 32'hDEAD_BEEF;
    m1_rresp_r   = 2'b10;
    m1_rvalid_r  = 1'b0;
    m1_arready_r = 1'b0;
    if (m1_ar_stall) begin
        m1_arready_r = 1'b0;
    end else if (m1_ar_err && m1_arvalid) begin
        m1_arready_r = 1'b1;
        m1_rvalid_r  = 1'b1;
        m1_rresp_r   = 2'b10;
        m1_rdata_r   = 32'hDEAD_BEEF;
    end else begin
        for (j = 0; j < 8; j = j + 1) begin
            if (m1_ar_sel[j] && !m0_ar_sel[j]) begin
                m1_arready_r = sx_arready[j];
                m1_rvalid_r  = sx_rvalid[j];
                m1_rresp_r   = sx_rresp[j];
                m1_rdata_r   = sx_rdata[j];
            end
        end
    end
end

assign m1_arready = m1_arready_r;
assign m1_rvalid  = m1_rvalid_r;
assign m1_rresp   = m1_rresp_r;
assign m1_rdata   = m1_rdata_r;

endmodule
`default_nettype wire
