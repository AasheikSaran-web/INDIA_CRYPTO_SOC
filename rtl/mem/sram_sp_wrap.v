// ============================================================================
// sram_sp_wrap.v  —  Single-Port SRAM Wrapper  (16384 × 32-bit, 512 KB)
// INDIA_CRYPTO_SOC  /  TSMC 28nm HPC+
//
// Compile with  +define+HARD_MACRO  to instantiate the real silicon macro.
// Without the define the module synthesises as a plain register file or is
// mapped by Yosys / DC to SRAM cells via the respective memory-compiler flow.
//
// Hard-macro target: ARM Artisan  TS1N28HPCPSVTB16384X32M8SW
//   16384-word × 32-bit  |  8-mux  |  SVT  |  TSMC 28nm HPC+
//   Datasheet polarity   : CEB active-LOW, WEB active-LOW, BWEB active-LOW
//   This wrapper uses    : active-HIGH enables  (cen / wen / bwen)
//   Inversion is done internally before the macro pins.
//
// Port description
//   clk   : rising-edge clock
//   cen   : chip enable, active-HIGH  (1 = selected, 0 = standby/no-op)
//   wen   : write enable, active-HIGH (1 = write,    0 = read)
//   bwen  : byte-lane write enable [3:0], valid only when wen = 1
//             bwen[0] -> D[ 7: 0]   bwen[1] -> D[15: 8]
//             bwen[2] -> D[23:16]   bwen[3] -> D[31:24]
//   addr  : word address [13:0]   (byte address >> 2)
//   wdata : write data  [31:0]
//   rdata : read  data  [31:0]  — registered output, valid one cycle after
//             a read access (cen=1, wen=0)
//
// Note: simultaneous read and write to the same address is undefined.
//       The controller (sram_ctrl.v) prevents this by arbitration.
// ============================================================================

`timescale 1ns / 1ps

module sram_sp_wrap #(
    parameter DEPTH = 16384,   // number of words
    parameter WIDTH = 32       // word width in bits
)(
    input  wire              clk,
    input  wire              cen,    // chip enable,        active-HIGH
    input  wire              wen,    // write enable,       active-HIGH
    input  wire [3:0]        bwen,   // byte write enable,  active-HIGH
    input  wire [13:0]       addr,
    input  wire [31:0]       wdata,
    output reg  [31:0]       rdata
);

`ifdef HARD_MACRO
    // =========================================================================
    // Hard Macro : ARM Artisan TS1N28HPCPSVTB16384X32M8SW
    // =========================================================================
    //
    // BWEB is 32-bit, one bit per data bit (active-LOW).
    // Expand 4-bit byte enable to 32-bit bit-write-enable here.
    //
    wire [31:0] bweb_n;
    assign bweb_n = { {8{~bwen[3]}}, {8{~bwen[2]}},
                      {8{~bwen[1]}}, {8{~bwen[0]}} };

    // rdata is driven directly by the macro Q port (already registered).
    // Redeclare as wire for the port connection; override 'reg' above.
    // synthesis translate_off
    // (The 'reg' declaration above is overridden by the macro port below.)
    // synthesis translate_on

    TS1N28HPCPSVTB16384X32M8SW u_sram_macro (
        .CLK   ( clk    ),
        .CEB   (~cen    ),   // active-LOW chip enable
        .WEB   (~wen    ),   // active-LOW write enable
        .BWEB  ( bweb_n ),   // active-LOW bit-write enable  [31:0]
        .A     ( addr   ),   // word address                 [13:0]
        .D     ( wdata  ),   // write data                   [31:0]
        .Q     ( rdata  ),   // read  data  (registered)     [31:0]
        // Timing-select pins — set for typical 28nm SS corner safe values
        .RTSEL ( 2'b01  ),   // read  timing select
        .WTSEL ( 2'b01  )    // write timing select
    );

`else
    // =========================================================================
    // Behavioral model — for simulation, Yosys, and soft-macro DC flow
    // =========================================================================
    reg [WIDTH-1:0] mem [0:DEPTH-1];

    always @(posedge clk) begin
        if (cen) begin
            if (wen) begin
                // Byte-lane write — no read-modify-write needed
                if (bwen[0]) mem[addr][ 7: 0] <= wdata[ 7: 0];
                if (bwen[1]) mem[addr][15: 8] <= wdata[15: 8];
                if (bwen[2]) mem[addr][23:16] <= wdata[23:16];
                if (bwen[3]) mem[addr][31:24] <= wdata[31:24];
            end else begin
                rdata <= mem[addr];
            end
        end
    end

`endif

endmodule
