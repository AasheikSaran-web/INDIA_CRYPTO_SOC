// =============================================================================
// core_tb.v — Minimal self-checking testbench stub for RISC-V arch tests
//
// Instantiates rv32im_core with a hex-loaded IMEM/DMEM model.
// The test binary writes a result word to the tohost address (0x8000_0000).
// Simulation ends and passes when tohost == 1, fails otherwise.
//
// Plusargs:
//   +commit_log=<file>   — path to write register-commit trace
//   +timeout=<cycles>    — max cycles before declaring timeout (default 200000)
//
// Compile-time define:
//   HEX_FILE="path/to/test.hex"  — Verilog $readmemh hex image
// =============================================================================

`timescale 1ns/1ps

`ifndef HEX_FILE
  `define HEX_FILE "test.hex"
`endif

`define TOHOST_ADDR  32'h8000_0000
`define MEM_DEPTH    65536          // 256 KB word-addressed

module core_tb;

// ---------------------------------------------------------------------------
// Clock and reset
// ---------------------------------------------------------------------------
reg clk;
reg rst_n;

initial clk = 0;
always #1.667 clk = ~clk;  // ~300 MHz

initial begin
    rst_n = 0;
    repeat(10) @(posedge clk);
    rst_n = 1;
end

// ---------------------------------------------------------------------------
// Flat memory model
// ---------------------------------------------------------------------------
reg [31:0] mem [0:`MEM_DEPTH-1];

initial begin
    integer i;
    for (i = 0; i < `MEM_DEPTH; i = i+1) mem[i] = 32'h0000_0013; // NOP
    $readmemh(`HEX_FILE, mem);
end

// ---------------------------------------------------------------------------
// Simple bus interface signals (matches rv32im_core ports)
// ---------------------------------------------------------------------------
wire [31:0] imem_addr;
reg  [31:0] imem_rdata;
wire        imem_req;

wire [31:0] dmem_addr;
wire [31:0] dmem_wdata;
wire [ 3:0] dmem_be;
wire        dmem_we;
wire        dmem_req;
reg  [31:0] dmem_rdata;
reg         dmem_gnt;
reg         dmem_rvalid;

// Instruction memory — 1-cycle latency
always @(posedge clk)
    imem_rdata <= mem[imem_addr[17:2]];

// Data memory — 1-cycle latency read, immediate write
always @(posedge clk) begin
    dmem_gnt    <= dmem_req;
    dmem_rvalid <= dmem_gnt;
    if (dmem_req && dmem_we) begin
        if (dmem_be[3]) mem[dmem_addr[17:2]][31:24] <= dmem_wdata[31:24];
        if (dmem_be[2]) mem[dmem_addr[17:2]][23:16] <= dmem_wdata[23:16];
        if (dmem_be[1]) mem[dmem_addr[17:2]][15: 8] <= dmem_wdata[15: 8];
        if (dmem_be[0]) mem[dmem_addr[17:2]][ 7: 0] <= dmem_wdata[ 7: 0];
    end
    dmem_rdata <= mem[dmem_addr[17:2]];
end

// ---------------------------------------------------------------------------
// DUT
// ---------------------------------------------------------------------------
rv32im_core u_core (
    .clk          (clk),
    .rst_n        (rst_n),
    // Instruction port
    .imem_addr_o  (imem_addr),
    .imem_req_o   (imem_req),
    .imem_rdata_i (imem_rdata),
    .imem_err_i   (1'b0),
    // Data port
    .dmem_addr_o  (dmem_addr),
    .dmem_wdata_o (dmem_wdata),
    .dmem_be_o    (dmem_be),
    .dmem_we_o    (dmem_we),
    .dmem_req_o   (dmem_req),
    .dmem_rdata_i (dmem_rdata),
    .dmem_gnt_i   (dmem_gnt),
    .dmem_rvalid_i(dmem_rvalid),
    .dmem_err_i   (1'b0),
    // IRQs (unused in arch tests)
    .irq_i        (32'h0),
    .irq_ack_o    (),
    .irq_id_o     ()
);

// ---------------------------------------------------------------------------
// Commit log
// NOTE: For full commit tracing, replace with a UVM/bind-based monitor.
//       This stub logs PC transitions as a lightweight proxy.
// ---------------------------------------------------------------------------
integer commit_fd;
integer cycle_cnt;
integer timeout;

initial begin
    string commit_log_path;
    if (!$value$plusargs("commit_log=%s", commit_log_path))
        commit_log_path = "commit.log";
    commit_fd = $fopen(commit_log_path, "w");

    if (!$value$plusargs("timeout=%d", timeout))
        timeout = 200000;
end

reg [31:0] prev_pc;
always @(posedge clk) begin
    if (rst_n && imem_req && (imem_addr !== prev_pc)) begin
        $fdisplay(commit_fd, "pc=0x%08x", imem_addr);
        prev_pc <= imem_addr;
    end
end

// ---------------------------------------------------------------------------
// tohost / timeout monitor
// ---------------------------------------------------------------------------
always @(posedge clk) begin
    if (rst_n) begin
        cycle_cnt = cycle_cnt + 1;

        // Check tohost write
        if (dmem_req && dmem_we && (dmem_addr == `TOHOST_ADDR)) begin
            $fclose(commit_fd);
            if (dmem_wdata == 32'h1) begin
                $display("TEST PASSED: %s", `HEX_FILE);
                $finish;
            end else begin
                $display("TEST FAILED: %s (tohost=0x%08x)", `HEX_FILE, dmem_wdata);
                $finish;
            end
        end

        // Timeout
        if (cycle_cnt >= timeout) begin
            $fclose(commit_fd);
            $display("TEST FAILED: %s (timeout after %0d cycles)", `HEX_FILE, timeout);
            $finish;
        end
    end else begin
        cycle_cnt = 0;
        prev_pc   = 32'hFFFF_FFFF;
    end
end

// ---------------------------------------------------------------------------
// Optional VCD dump
// ---------------------------------------------------------------------------
`ifdef VCD
initial begin
    $dumpfile("core_tb.vcd");
    $dumpvars(0, core_tb);
end
`endif

endmodule
