`timescale 1ns/1ps
// =============================================================================
// irq_checker.sv  —  Interrupt routing SVA checker
//
// Assertions:
//   1. seceng_irq must be stable for >= 2 cycles before deasserting (no glitches)
//
// Cover points:
//   1. seceng_irq goes high at least once during simulation
// =============================================================================

module irq_checker (
    input wire clk,
    input wire rst_n,
    input wire seceng_irq
);

`ifdef SYNTHESIS
`else

default clocking cb @(posedge clk);
endclocking

// ---------------------------------------------------------------------------
// Property: seceng_irq must be stable for at least 2 cycles before deasserting
// (no single-cycle glitches)
// ---------------------------------------------------------------------------
property p_seceng_irq_stable;
    @(posedge clk) disable iff (!rst_n)
    (seceng_irq && $fell(seceng_irq)) |->
        ($past(seceng_irq, 1) && $past(seceng_irq, 2));
endproperty

// Note: $fell triggers the cycle AFTER the fall. Rewrite to check that when
// seceng_irq was 1 and then falls, it had been 1 for at least 2 prior cycles.
property p_irq_no_glitch;
    @(posedge clk) disable iff (!rst_n)
    $fell(seceng_irq) |-> ($past(seceng_irq, 1) === 1'b1 && $past(seceng_irq, 2) === 1'b1);
endproperty

irq_no_glitch: assert property (p_irq_no_glitch)
    else $error("[irq_checker] seceng_irq glitch: de-asserted before 2-cycle stable at %0t", $time);

// ---------------------------------------------------------------------------
// Cover: seceng_irq goes high at least once
// ---------------------------------------------------------------------------
cov_seceng_irq_fires: cover property (
    @(posedge clk) disable iff (!rst_n)
    $rose(seceng_irq));

// ---------------------------------------------------------------------------
// Cover: seceng_irq asserted and deasserted (full pulse)
// ---------------------------------------------------------------------------
cov_seceng_irq_pulse: cover property (
    @(posedge clk) disable iff (!rst_n)
    $rose(seceng_irq) ##[2:$] $fell(seceng_irq));

`endif // SYNTHESIS

endmodule
