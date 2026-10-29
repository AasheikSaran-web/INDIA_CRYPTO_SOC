`timescale 1ns/1ps
interface criya_uart_if(input logic clk, rst_n);
  logic tx;   // DUT output (we monitor)
  logic rx;   // DUT input  (we drive)
  initial rx = 1'b1;  // idle
endinterface
