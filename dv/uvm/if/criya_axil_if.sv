`timescale 1ns/1ps
interface criya_axil_if(input logic clk, rst_n);
  // Write address channel
  logic [31:0] awaddr;
  logic        awvalid, awready;
  logic [2:0]  awprot;
  // Write data channel
  logic [31:0] wdata;
  logic [3:0]  wstrb;
  logic        wvalid, wready;
  // Write response channel
  logic [1:0]  bresp;
  logic        bvalid, bready;
  // Read address channel
  logic [31:0] araddr;
  logic        arvalid, arready;
  logic [2:0]  arprot;
  // Read data channel
  logic [31:0] rdata;
  logic [1:0]  rresp;
  logic        rvalid, rready;

  // Master clocking block (driven by agent)
  clocking master_cb @(posedge clk);
    default input #1 output #1;
    output awaddr, awvalid, awprot;
    output wdata, wstrb, wvalid;
    input  awready, wready;
    input  bresp, bvalid;
    output bready;
    output araddr, arvalid, arprot;
    input  arready;
    input  rdata, rresp, rvalid;
    output rready;
  endclocking

  modport master_mp(clocking master_cb, input clk, rst_n);
endinterface
