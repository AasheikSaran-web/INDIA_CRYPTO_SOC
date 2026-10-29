`timescale 1ns/1ps
// Formal properties for AES-CA accelerator block
// Run against aes_ca_accel module directly
module aes_props_wrap (
  input  logic        clk,
  input  logic        rst_n,
  input  logic [31:0] ctrl_reg,
  input  logic [127:0] plaintext,
  input  logic [255:0] key,
  output logic        done,
  output logic [127:0] ciphertext
);
  // Instantiate AES-CA (adjust port names to match actual RTL)
  aes_ca_accel u_aes (
    .clk        (clk),
    .rst_n      (rst_n),
    .ctrl       (ctrl_reg),
    .plaintext  (plaintext),
    .key        (key),
    .done       (done),
    .ciphertext (ciphertext)
  );

  default clocking @(posedge clk); endclocking
  default disable iff (!rst_n);

  // Property 1: Done must deassert after reset
  p_done_clears_on_rst: assert property (
    !rst_n |=> !done
  );

  // Property 2: Done cannot assert while start is not set
  p_no_spurious_done: assert property (
    !ctrl_reg[0] |-> !done
  );

  // Property 3: Ciphertext must never be all-zeros for non-zero input
  // (basic sanity — not cryptographically strong but catches stuck-at faults)
  p_ct_not_all_zero: assert property (
    done && (|plaintext) && (|key) |-> (|ciphertext)
  );

  // Property 4: Done must be stable until ctrl clears start bit
  p_done_stable: assert property (
    done && ctrl_reg[0] |=> done
  );

  // Cover: at least one completed AES operation
  c_aes_completes: cover property (
    $rose(done)
  );
endmodule
