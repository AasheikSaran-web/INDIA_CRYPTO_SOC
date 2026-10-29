`timescale 1ns/1ps
interface criya_spi_if(input logic clk, rst_n);
  logic mosi, miso, sck, cs_n;
  initial miso = 1'b0;
endinterface
