`timescale 1ns/1ps
// Formal wrapper: connects axil_checker to india_crypto_soc master port
module axil_wrap (
  input logic clk, rst_n
);
  // AXI-Lite signals (driven by formal tool as free variables)
  logic [31:0] awaddr, wdata, araddr;
  logic [3:0]  wstrb;
  logic [2:0]  awprot, arprot;
  logic        awvalid, wvalid, bready, arvalid, rready;

  // DUT output signals
  logic        awready, wready, bvalid, arready, rvalid;
  logic [31:0] rdata;
  logic [1:0]  bresp, rresp;

  // Checker instantiation (from dv/sva/axil_checker.sv)
  axil_checker #(.DATA_W(32), .ADDR_W(32)) u_chk (
    .clk     (clk),
    .rst_n   (rst_n),
    .awaddr  (awaddr),  .awvalid(awvalid), .awready(awready), .awprot(awprot),
    .wdata   (wdata),   .wstrb  (wstrb),   .wvalid (wvalid),  .wready (wready),
    .bresp   (bresp),   .bvalid (bvalid),  .bready (bready),
    .araddr  (araddr),  .arvalid(arvalid), .arready(arready), .arprot (arprot),
    .rdata   (rdata),   .rresp  (rresp),   .rvalid (rvalid),  .rready (rready)
  );

  // Assumptions: master behaves correctly
  // (these constrain the formal tool's free variables)
  always @(posedge clk) begin
    assume property (awaddr[1:0] == 2'b00);  // word-aligned
    assume property (araddr[1:0] == 2'b00);
    assume property (wstrb inside {4'hF, 4'h3, 4'h1, 4'hC});
  end

  // Default clocking
  default clocking @(posedge clk); endclocking
  default disable iff (!rst_n);
endmodule
