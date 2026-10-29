`timescale 1ns/1ps
module reset_wrap (
  input logic clk, rst_n,
  input logic uart_tx,
  input logic seceng_irq
);
  reset_checker u_chk (
    .clk        (clk),
    .rst_n      (rst_n),
    .uart_tx    (uart_tx),
    .seceng_irq (seceng_irq)
  );

  default clocking @(posedge clk); endclocking
endmodule
