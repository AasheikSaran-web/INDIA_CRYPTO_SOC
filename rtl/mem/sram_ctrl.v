// ============================================================================
// sram_ctrl.v  —  SRAM Arbiter + AXI-Lite / CPU-Imem Controller
// INDIA_CRYPTO_SOC  /  TSMC 28nm HPC+
//
// This module replaces the two inline always_ff SRAM access blocks in
// india_crypto_soc.v and instantiates sram_sp_wrap, providing a clean
// boundary for the hard-macro substitution flow.
//
// Clients
//   Port A  — CPU instruction fetch (read-only, AXI-AR/R handshake)
//   Port B  — AXI-Lite data port    (full AXI-Lite slave, read + write)
//
// Arbitration priority (evaluated each cycle, highest wins):
//   1. AXI write  — staged (both AW + W channels latched before issuing)
//   2. AXI read
//   3. CPU read
//
// Read latency: 2 cycles
//   Cycle 0 : request accepted (arready pulsed), address presented to SRAM
//   Cycle 1 : SRAM Q valid, rdata driven, rvalid asserted
//
// Write latency: 1 cycle after both AW and W channels are latched.
//   Byte-lane granularity via BWEB — NO read-modify-write required.
//
// Notes:
//   - CPU read address is latched at accept time (cpu_arready pulse) so
//     the CPU can drop arvalid immediately, per AXI spec.
//   - AXI-B read address is similarly latched.
//   - A CPU read queued while AXI read or write is in progress will be
//     held and granted the next idle cycle (one wait-state at most for the
//     common case where accesses are independent).
// ============================================================================

`timescale 1ns / 1ps

module sram_ctrl (
    input  wire         clk,
    input  wire         rst_n,

    // ── Port A: CPU Instruction Fetch (read-only) ────────────────────────────
    input  wire         cpu_arvalid,
    input  wire [31:0]  cpu_araddr,   // full 32-bit; [15:2] used as word address
    output reg          cpu_arready,
    output reg          cpu_rvalid,
    output reg  [31:0]  cpu_rdata,
    output wire [1:0]   cpu_rresp,
    input  wire         cpu_rready,

    // ── Port B: AXI-Lite Data Port ───────────────────────────────────────────
    // Write address channel
    input  wire         axi_awvalid,
    input  wire [31:0]  axi_awaddr,   // full 32-bit; [15:2] used as word address
    output reg          axi_awready,
    // Write data channel
    input  wire         axi_wvalid,
    input  wire [31:0]  axi_wdata,
    input  wire [3:0]   axi_wstrb,
    output reg          axi_wready,
    // Write response channel
    output reg          axi_bvalid,
    output wire [1:0]   axi_bresp,
    input  wire         axi_bready,
    // Read address channel
    input  wire         axi_arvalid,
    input  wire [31:0]  axi_araddr,   // full 32-bit; [15:2] used as word address
    output reg          axi_arready,
    // Read data channel
    output reg          axi_rvalid,
    output reg  [31:0]  axi_rdata,
    output wire [1:0]   axi_rresp,
    input  wire         axi_rready
);

    // Fixed OKAY responses — SRAM never errors
    assign cpu_rresp = 2'b00;
    assign axi_rresp = 2'b00;
    assign axi_bresp = 2'b00;

    // ── SRAM Interface Signals ────────────────────────────────────────────────
    reg          sram_cen;
    reg          sram_wen;
    reg  [3:0]   sram_bwen;
    reg  [13:0]  sram_addr;
    reg  [31:0]  sram_wdata;
    wire [31:0]  sram_rdata;

    sram_sp_wrap #(
        .DEPTH (16384),
        .WIDTH (32)
    ) u_sram (
        .clk   (clk),
        .cen   (sram_cen),
        .wen   (sram_wen),
        .bwen  (sram_bwen),
        .addr  (sram_addr),
        .wdata (sram_wdata),
        .rdata (sram_rdata)
    );

    // ── AXI Write Staging Registers ───────────────────────────────────────────
    reg          wr_aw_done;   // AW channel handshake complete
    reg          wr_w_done;    // W  channel handshake complete
    reg  [13:0]  wr_addr;      // latched word address
    reg  [31:0]  wr_wdata;     // latched write data
    reg  [3:0]   wr_wstrb;     // latched byte strobes

    // ── Read Request Queues ───────────────────────────────────────────────────
    // _wait  : request accepted from master, waiting for SRAM grant
    // _pend  : SRAM access issued, waiting for Q (next cycle)
    reg          cpu_rd_wait,  cpu_rd_pend;
    reg          axi_rd_wait,  axi_rd_pend;
    reg  [13:0]  cpu_rd_addr;  // latched at accept
    reg  [13:0]  axi_rd_addr;  // latched at accept

    // ── Arbitration (combinational) ───────────────────────────────────────────
    wire do_wr      = wr_aw_done && wr_w_done;
    wire do_axi_rd  = axi_rd_wait && !do_wr;
    wire do_cpu_rd  = cpu_rd_wait && !do_wr && !axi_rd_wait;

    // ── Sequential Logic ──────────────────────────────────────────────────────
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // SRAM control
            sram_cen       <= 1'b0;
            sram_wen       <= 1'b0;
            sram_bwen      <= 4'h0;
            sram_addr      <= 14'h0;
            sram_wdata     <= 32'h0;
            // Port A — CPU
            cpu_arready    <= 1'b0;
            cpu_rvalid     <= 1'b0;
            cpu_rdata      <= 32'h0;
            cpu_rd_wait    <= 1'b0;
            cpu_rd_pend    <= 1'b0;
            cpu_rd_addr    <= 14'h0;
            // Port B — AXI write
            axi_awready    <= 1'b0;
            axi_wready     <= 1'b0;
            axi_bvalid     <= 1'b0;
            wr_aw_done     <= 1'b0;
            wr_w_done      <= 1'b0;
            wr_addr        <= 14'h0;
            wr_wdata       <= 32'h0;
            wr_wstrb       <= 4'h0;
            // Port B — AXI read
            axi_arready    <= 1'b0;
            axi_rvalid     <= 1'b0;
            axi_rdata      <= 32'h0;
            axi_rd_wait    <= 1'b0;
            axi_rd_pend    <= 1'b0;
            axi_rd_addr    <= 14'h0;
        end else begin
            // ── Pulse signals default LOW each cycle ──────────────────────────
            cpu_arready <= 1'b0;
            axi_awready <= 1'b0;
            axi_wready  <= 1'b0;
            axi_arready <= 1'b0;
            sram_cen    <= 1'b0;     // disable SRAM by default (power saving)

            // ── Port B: Accept AXI Write Address ─────────────────────────────
            if (axi_awvalid && !wr_aw_done) begin
                axi_awready <= 1'b1;
                wr_aw_done  <= 1'b1;
                wr_addr     <= axi_awaddr[15:2];
            end

            // ── Port B: Accept AXI Write Data ────────────────────────────────
            if (axi_wvalid && !wr_w_done) begin
                axi_wready <= 1'b1;
                wr_w_done  <= 1'b1;
                wr_wdata   <= axi_wdata;
                wr_wstrb   <= axi_wstrb;
            end

            // ── Port A: Accept CPU Read (latch address immediately) ───────────
            if (cpu_arvalid && !cpu_rd_wait && !cpu_rd_pend) begin
                cpu_arready <= 1'b1;
                cpu_rd_wait <= 1'b1;
                cpu_rd_addr <= cpu_araddr[15:2];   // latch — master may drop arvalid
            end

            // ── Port B: Accept AXI Read (latch address immediately) ───────────
            if (axi_arvalid && !axi_rd_wait && !axi_rd_pend) begin
                axi_arready <= 1'b1;
                axi_rd_wait <= 1'b1;
                axi_rd_addr <= axi_araddr[15:2];   // latch — master may drop arvalid
            end

            // ── Arbitrated SRAM Access ────────────────────────────────────────
            if (do_wr) begin
                // ── Priority 1: AXI Write ─────────────────────────────────────
                // BWEB inside sram_sp_wrap handles byte granularity;
                // no read-modify-write needed.
                sram_cen   <= 1'b1;
                sram_wen   <= 1'b1;
                sram_bwen  <= wr_wstrb;
                sram_addr  <= wr_addr;
                sram_wdata <= wr_wdata;
                wr_aw_done <= 1'b0;
                wr_w_done  <= 1'b0;
                axi_bvalid <= 1'b1;   // response available next cycle

            end else if (do_axi_rd) begin
                // ── Priority 2: AXI Read ──────────────────────────────────────
                sram_cen      <= 1'b1;
                sram_wen      <= 1'b0;
                sram_bwen     <= 4'hF;
                sram_addr     <= axi_rd_addr;
                axi_rd_wait   <= 1'b0;
                axi_rd_pend   <= 1'b1;   // data arrives next cycle

            end else if (do_cpu_rd) begin
                // ── Priority 3: CPU Instruction Read ─────────────────────────
                sram_cen      <= 1'b1;
                sram_wen      <= 1'b0;
                sram_bwen     <= 4'hF;
                sram_addr     <= cpu_rd_addr;
                cpu_rd_wait   <= 1'b0;
                cpu_rd_pend   <= 1'b1;   // data arrives next cycle
            end

            // ── SRAM Read Return: AXI ─────────────────────────────────────────
            if (axi_rd_pend) begin
                axi_rvalid  <= 1'b1;
                axi_rdata   <= sram_rdata;   // capture registered SRAM output
                axi_rd_pend <= 1'b0;
            end
            if (axi_rvalid && axi_rready)
                axi_rvalid <= 1'b0;

            // ── SRAM Read Return: CPU ─────────────────────────────────────────
            if (cpu_rd_pend) begin
                cpu_rvalid  <= 1'b1;
                cpu_rdata   <= sram_rdata;   // capture registered SRAM output
                cpu_rd_pend <= 1'b0;
            end
            if (cpu_rvalid && cpu_rready)
                cpu_rvalid <= 1'b0;

            // ── AXI Write Response ────────────────────────────────────────────
            if (axi_bvalid && axi_bready)
                axi_bvalid <= 1'b0;
        end
    end

endmodule
