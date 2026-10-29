`timescale 1ns/1ps
module trng_props_wrap (
  input logic clk, rst_n,
  input logic rosc_ext
);
  logic       data_valid;
  logic       rct_pass, apt_pass;
  logic [31:0] entropy_out;

  rosc_trng u_trng (
    .clk        (clk),
    .rst_n      (rst_n),
    .rosc_ext   (rosc_ext),
    .data_valid (data_valid),
    .rct_pass   (rct_pass),
    .apt_pass   (apt_pass),
    .entropy    (entropy_out)
  );

  default clocking @(posedge clk); endclocking
  default disable iff (!rst_n);

  // Health test flags must be 0 during reset
  p_rct_rst: assert property (!rst_n |=> !rct_pass);
  p_apt_rst: assert property (!rst_n |=> !apt_pass);

  // Data valid cannot assert until health tests pass
  p_valid_after_health: assert property (
    data_valid |-> (rct_pass && apt_pass)
  );

  // Cover: health tests eventually pass
  c_rct_passes: cover property ($rose(rct_pass));
  c_apt_passes: cover property ($rose(apt_pass));
endmodule
