`timescale 1ns/1ps
// =============================================================================
// reset_checker.sv  —  Reset behavior SVA checker
//
// Verifies that:
//   1. After rst_n deasserts, AXI master AWVALID/ARVALID hold 0 for >= 4 cycles
//   2. seceng_irq is 0 while rst_n is asserted
//   3. uart_tx is 1 (idle) while rst_n is asserted
// =============================================================================

module reset_checker (
    input wire clk,
    input wire rst_n,
    input wire awvalid,
    input wire arvalid,
    input wire seceng_irq,
    input wire uart_tx
);

`ifdef SYNTHESIS
`else

default clocking cb @(posedge clk);
endclocking

// ---------------------------------------------------------------------------
// Property 1: AWVALID stays 0 for first 4 cycles after reset release
// ---------------------------------------------------------------------------
property p_awvalid_quiet_after_reset;
    @(posedge clk)
    $rose(rst_n) |-> !awvalid [*4];
endproperty

rst_awvalid_quiet: assert property (p_awvalid_quiet_after_reset)
    else $error("[reset_checker] AWVALID asserted within 4 cycles of reset release at %0t", $time);

// ---------------------------------------------------------------------------
// Property 2: ARVALID stays 0 for first 4 cycles after reset release
// ---------------------------------------------------------------------------
property p_arvalid_quiet_after_reset;
    @(posedge clk)
    $rose(rst_n) |-> !arvalid [*4];
endproperty

rst_arvalid_quiet: assert property (p_arvalid_quiet_after_reset)
    else $error("[reset_checker] ARVALID asserted within 4 cycles of reset release at %0t", $time);

// ---------------------------------------------------------------------------
// Property 3: seceng_irq must be 0 during reset
// ---------------------------------------------------------------------------
property p_seceng_irq_in_reset;
    @(posedge clk) disable iff (rst_n)
    !seceng_irq;
endproperty

rst_seceng_irq_low: assert property (p_seceng_irq_in_reset)
    else $error("[reset_checker] seceng_irq asserted during reset at %0t", $time);

// ---------------------------------------------------------------------------
// Property 4: uart_tx must be 1 (idle) during reset
// ---------------------------------------------------------------------------
property p_uart_tx_idle_in_reset;
    @(posedge clk) disable iff (rst_n)
    uart_tx === 1'b1;
endproperty

rst_uart_tx_idle: assert property (p_uart_tx_idle_in_reset)
    else $error("[reset_checker] uart_tx not idle during reset at %0t", $time);

// ---------------------------------------------------------------------------
// Cover: reset was actually asserted then released
// ---------------------------------------------------------------------------
cov_reset_cycle: cover property (
    @(posedge clk)
    (!rst_n) ##[1:$] rst_n);

`endif // SYNTHESIS

endmodule
