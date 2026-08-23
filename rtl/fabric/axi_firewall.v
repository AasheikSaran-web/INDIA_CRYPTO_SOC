// =============================================================================
// axi_firewall.v — AXI-Lite Security Firewall
// Project  : INDIA_CRYPTO_SOC
//
// Sits between the crossbar slave port and a protected peripheral.
// Carries a per-(master_id, slave_id) permission table stored in a 32-bit
// register so synthesis can infer simple flops.
//
// Permission table encoding:
//   perm_table[slave_id * N_MASTERS + master_id] = 1  ->  access allowed
//   N_MASTERS = 4, N_SLAVES = 8  =>  32-bit register
//
// Write-once protection:
//   After firmware writes lock_table == 32'hDEAD_BEEF the permission table
//   becomes read-only until reset.
//
// Forensic registers (read via firewall config port):
//   last_denied_addr   : address of the most recent denied transaction
//   last_denied_master : master_id of the most recent denied transaction
//   deny_count[15:0]   : accumulated denied access count (write-any to clear)
//
// Firewall config port (f_aw*/f_w*/f_b*/f_ar*/f_r*) register map:
//   0x00  perm_table      [31:0]  RW (locked after DEAD_BEEF)
//   0x04  lock_table      [31:0]  WO (write 0xDEADBEEF to lock)
//   0x08  last_denied_addr[31:0]  RO
//   0x0C  last_denied_master[1:0] RO
//   0x10  deny_count      [15:0]  RC (write-any to clear)
//
// On denied upstream transaction:
//   - AW/AR accepted (awready/arready asserted) to avoid bus hang
//   - W channel consumed (wready asserted)
//   - SLVERR returned immediately on B/R channel
//   - downstream slave sees nothing
//
// On allowed transaction:
//   - Channels passed through transparently
//
// Parameters:
//   N_SLAVES  = 8
//   N_MASTERS = 4
//   DEFAULT_PERM: reset value of perm_table (all CPU allowed, DMA to s1 only)
// =============================================================================
`default_nettype none
`timescale 1ns/1ps

module axi_firewall #(
    parameter N_SLAVES        = 8,
    parameter N_MASTERS       = 4,
    parameter LOG_DEPTH       = 4,            // deny-log FIFO depth (2^LOG_DEPTH entries)
    parameter [31:0] LOCK_KEY = 32'hDEADBEEF, // magic value to lock permission table
    // Default: CPU (id=0) allowed on every slave, DMA (id=1) allowed on s1
    // bit[slave*N_MASTERS + master]: slave 0..7, master 0..3
    // CPU (master 0) bits: bit 0, 4, 8, 12, 16, 20, 24, 28 => all set
    // DMA (master 1) on slave 1: bit[1*4+1] = bit 5
    parameter [31:0] DEFAULT_PERM = 32'b
        0001_0001_0001_0001_0001_0001_0001_0001  // CPU bit set on every slave
        | 32'h0000_0020                          // DMA bit set on slave 1
)(
    input  wire        clk,
    input  wire        rst_n,

    // Which master is driving the upstream port, and which slave this protects
    input  wire [1:0]  master_id,
    input  wire [2:0]  slave_id,

    // -------------------------------------------------------------------------
    // Upstream AXI-Lite slave port (from crossbar)
    // -------------------------------------------------------------------------
    input  wire [31:0] u_awaddr,
    input  wire        u_awvalid,
    output reg         u_awready,
    input  wire [31:0] u_wdata,
    input  wire [3:0]  u_wstrb,
    input  wire        u_wvalid,
    output reg         u_wready,
    output reg  [1:0]  u_bresp,
    output reg         u_bvalid,
    input  wire        u_bready,

    input  wire [31:0] u_araddr,
    input  wire        u_arvalid,
    output reg         u_arready,
    output reg  [31:0] u_rdata,
    output reg  [1:0]  u_rresp,
    output reg         u_rvalid,
    input  wire        u_rready,

    // -------------------------------------------------------------------------
    // Downstream AXI-Lite master port (to protected peripheral)
    // -------------------------------------------------------------------------
    output reg  [31:0] d_awaddr,
    output reg         d_awvalid,
    input  wire        d_awready,
    output reg  [31:0] d_wdata,
    output reg  [3:0]  d_wstrb,
    output reg         d_wvalid,
    input  wire        d_wready,
    input  wire [1:0]  d_bresp,
    input  wire        d_bvalid,
    output reg         d_bready,

    output reg  [31:0] d_araddr,
    output reg         d_arvalid,
    input  wire        d_arready,
    input  wire [31:0] d_rdata,
    input  wire [1:0]  d_rresp,
    input  wire        d_rvalid,
    output reg         d_rready,

    // -------------------------------------------------------------------------
    // Firewall configuration AXI-Lite slave port
    // -------------------------------------------------------------------------
    input  wire [31:0] f_awaddr,
    input  wire        f_awvalid,
    output reg         f_awready,
    input  wire [31:0] f_wdata,
    input  wire [3:0]  f_wstrb,
    input  wire        f_wvalid,
    output reg         f_wready,
    output reg  [1:0]  f_bresp,
    output reg         f_bvalid,
    input  wire        f_bready,

    input  wire [31:0] f_araddr,
    input  wire        f_arvalid,
    output reg         f_arready,
    output reg  [31:0] f_rdata,
    output reg  [1:0]  f_rresp,
    output reg         f_rvalid,
    input  wire        f_rready,

    // -------------------------------------------------------------------------
    // Deny IRQ — one-cycle pulse on any denied AW or AR transaction
    // Aggregated by top-level into seceng_irq
    // -------------------------------------------------------------------------
    output reg         deny_irq
);

// =============================================================================
// Permission & forensic registers
// =============================================================================
reg [31:0] perm_table;
reg        table_locked;
reg [31:0] last_denied_addr;
reg [1:0]  last_denied_master;
reg [15:0] deny_count;

// Permission check: bit index = slave_id * N_MASTERS + master_id
wire [4:0] perm_idx = ({2'b00, slave_id} * N_MASTERS[4:0]) + {3'b000, master_id};
wire       wr_allowed = perm_table[perm_idx];
wire       rd_allowed = perm_table[perm_idx];   // same permission for R and W

// =============================================================================
// Write FSM — 2 states: IDLE, RESP
// =============================================================================
localparam WS_IDLE = 2'd0;
localparam WS_PASS = 2'd1;   // forwarding to downstream
localparam WS_DENY = 2'd2;   // generating error response locally
localparam WS_RESP = 2'd3;   // waiting for u_bready after DENY

reg [1:0] wstate;
reg       aw_captured;       // AW handshake done
reg       w_captured;        // W handshake done
reg [31:0] aw_addr_lat;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        wstate          <= WS_IDLE;
        u_awready       <= 1'b0;
        u_wready        <= 1'b0;
        u_bvalid        <= 1'b0;
        u_bresp         <= 2'b00;
        d_awvalid       <= 1'b0;
        d_wvalid        <= 1'b0;
        d_awaddr        <= 32'h0;
        d_wdata         <= 32'h0;
        d_wstrb         <= 4'h0;
        d_bready        <= 1'b0;
        aw_captured     <= 1'b0;
        w_captured      <= 1'b0;
        aw_addr_lat     <= 32'h0;
        last_denied_addr   <= 32'h0;
        last_denied_master <= 2'h0;
        deny_count      <= 16'h0;
        deny_irq        <= 1'b0;
    end else begin
        // Default de-assert one-shot signals
        u_awready <= 1'b0;
        u_wready  <= 1'b0;
        deny_irq  <= 1'b0;

        case (wstate)
        WS_IDLE: begin
            d_awvalid <= 1'b0;
            d_wvalid  <= 1'b0;
            d_bready  <= 1'b0;
            if (u_awvalid && !aw_captured) begin
                // Latch address and accept it
                aw_addr_lat <= u_awaddr;
                u_awready   <= 1'b1;
                aw_captured <= 1'b1;
            end
            if (u_wvalid && !w_captured) begin
                u_wready  <= 1'b1;
                w_captured <= 1'b1;
            end
            if (aw_captured || (u_awvalid)) begin
                if (w_captured || u_wvalid) begin
                    // Both channels ready to decide
                    if (wr_allowed) begin
                        wstate <= WS_PASS;
                    end else begin
                        // Log denial and pulse IRQ
                        last_denied_addr   <= aw_addr_lat;
                        last_denied_master <= master_id;
                        deny_count         <= deny_count + 16'h1;
                        deny_irq           <= 1'b1;   // one-cycle pulse to seceng_irq
                        wstate             <= WS_DENY;
                    end
                end
            end
        end

        WS_PASS: begin
            // Forward AW and W to downstream
            d_awvalid <= 1'b1;
            d_awaddr  <= aw_addr_lat;
            d_wdata   <= u_wdata;
            d_wstrb   <= u_wstrb;
            d_wvalid  <= 1'b1;
            d_bready  <= u_bready;
            if (d_awready) d_awvalid <= 1'b0;
            if (d_wready)  d_wvalid  <= 1'b0;
            // Forward B channel back
            u_bvalid <= d_bvalid;
            u_bresp  <= d_bresp;
            if (d_bvalid && u_bready) begin
                aw_captured <= 1'b0;
                w_captured  <= 1'b0;
                wstate      <= WS_IDLE;
            end
        end

        WS_DENY: begin
            // Return SLVERR without touching downstream
            u_bvalid <= 1'b1;
            u_bresp  <= 2'b10;   // SLVERR
            if (u_bready) begin
                u_bvalid    <= 1'b0;
                aw_captured <= 1'b0;
                w_captured  <= 1'b0;
                wstate      <= WS_IDLE;
            end
        end

        default: wstate <= WS_IDLE;
        endcase
    end
end

// =============================================================================
// Read FSM
// =============================================================================
localparam RS_IDLE = 2'd0;
localparam RS_PASS = 2'd1;
localparam RS_DENY = 2'd2;

reg [1:0] rstate;
reg [31:0] ar_addr_lat;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        rstate      <= RS_IDLE;
        u_arready   <= 1'b0;
        u_rvalid    <= 1'b0;
        u_rdata     <= 32'h0;
        u_rresp     <= 2'b00;
        d_arvalid   <= 1'b0;
        d_araddr    <= 32'h0;
        d_rready    <= 1'b0;
        ar_addr_lat <= 32'h0;
    end else begin
        u_arready <= 1'b0;

        case (rstate)
        RS_IDLE: begin
            d_arvalid <= 1'b0;
            d_rready  <= 1'b0;
            if (u_arvalid) begin
                ar_addr_lat <= u_araddr;
                u_arready   <= 1'b1;
                if (rd_allowed) begin
                    rstate <= RS_PASS;
                end else begin
                    last_denied_addr   <= u_araddr;
                    last_denied_master <= master_id;
                    deny_count         <= deny_count + 16'h1;
                    deny_irq           <= 1'b1;   // one-cycle pulse to seceng_irq
                    rstate             <= RS_DENY;
                end
            end
        end

        RS_PASS: begin
            d_arvalid <= 1'b1;
            d_araddr  <= ar_addr_lat;
            if (d_arready) d_arvalid <= 1'b0;
            d_rready  <= u_rready;
            u_rvalid  <= d_rvalid;
            u_rdata   <= d_rdata;
            u_rresp   <= d_rresp;
            if (d_rvalid && u_rready) begin
                rstate <= RS_IDLE;
            end
        end

        RS_DENY: begin
            u_rvalid <= 1'b1;
            u_rdata  <= 32'hDEAD_BEEF;
            u_rresp  <= 2'b10;
            if (u_rready) begin
                u_rvalid <= 1'b0;
                rstate   <= RS_IDLE;
            end
        end

        default: rstate <= RS_IDLE;
        endcase
    end
end

// =============================================================================
// Firewall configuration port — simple register bank
// =============================================================================
// Register addresses (word aligned, use bits [4:2])
localparam CFG_PERM    = 3'h0;  // 0x00
localparam CFG_LOCK    = 3'h1;  // 0x04
localparam CFG_DA_ADDR = 3'h2;  // 0x08
localparam CFG_DA_MSTR = 3'h3;  // 0x0C
localparam CFG_DENY_CT = 3'h4;  // 0x10

reg f_aw_done, f_w_done;
reg [31:0] f_awaddr_lat;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        perm_table   <= DEFAULT_PERM;
        table_locked <= 1'b0;
        f_awready    <= 1'b0;
        f_wready     <= 1'b0;
        f_bvalid     <= 1'b0;
        f_bresp      <= 2'b00;
        f_arready    <= 1'b0;
        f_rvalid     <= 1'b0;
        f_rdata      <= 32'h0;
        f_rresp      <= 2'b00;
        f_aw_done    <= 1'b0;
        f_w_done     <= 1'b0;
        f_awaddr_lat <= 32'h0;
    end else begin
        // Defaults
        f_awready <= 1'b0;
        f_wready  <= 1'b0;
        f_arready <= 1'b0;

        // --- Write path ---
        if (f_awvalid && !f_aw_done) begin
            f_awready    <= 1'b1;
            f_awaddr_lat <= f_awaddr;
            f_aw_done    <= 1'b1;
        end
        if (f_wvalid && !f_w_done) begin
            f_wready  <= 1'b1;
            f_w_done  <= 1'b1;
        end
        if (f_aw_done && f_w_done) begin
            f_aw_done <= 1'b0;
            f_w_done  <= 1'b0;
            f_bvalid  <= 1'b1;
            f_bresp   <= 2'b00;
            case (f_awaddr_lat[4:2])
                CFG_PERM: begin
                    if (!table_locked)
                        perm_table <= f_wdata;
                    else
                        f_bresp <= 2'b10;   // SLVERR: locked
                end
                CFG_LOCK: begin
                    if (f_wdata == 32'hDEADBEEF)
                        table_locked <= 1'b1;
                end
                CFG_DENY_CT: begin
                    deny_count <= 16'h0;   // write-any clears
                end
                default: f_bresp <= 2'b10;
            endcase
        end
        if (f_bvalid && f_bready) f_bvalid <= 1'b0;

        // --- Read path ---
        if (f_arvalid && !f_rvalid) begin
            f_arready <= 1'b1;
            f_rvalid  <= 1'b1;
            f_rresp   <= 2'b00;
            case (f_araddr[4:2])
                CFG_PERM:    f_rdata <= perm_table;
                CFG_LOCK:    f_rdata <= {31'h0, table_locked};
                CFG_DA_ADDR: f_rdata <= last_denied_addr;
                CFG_DA_MSTR: f_rdata <= {30'h0, last_denied_master};
                CFG_DENY_CT: f_rdata <= {16'h0, deny_count};
                default:     begin f_rdata <= 32'h0; f_rresp <= 2'b10; end
            endcase
        end
        if (f_rvalid && f_rready) f_rvalid <= 1'b0;
    end
end

endmodule
`default_nettype wire
