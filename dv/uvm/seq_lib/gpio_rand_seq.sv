`timescale 1ns/1ps
class gpio_rand_seq extends criya_base_seq;
  `uvm_object_utils(gpio_rand_seq)

  localparam GPIO_BASE = 32'h4000_0000;
  localparam GPIO_DATA = GPIO_BASE + 32'h00;
  localparam GPIO_DIR  = GPIO_BASE + 32'h04;
  localparam GPIO_OUT  = GPIO_BASE + 32'h08;

  int unsigned num_iters = 10;

  function new(string name = "gpio_rand_seq"); super.new(name); endfunction

  task body();
    logic [31:0] rdata;
    rand logic [31:0] rand_data;

    // Verify gpio_in = 0xDEADBEEF
    axil_read(GPIO_DATA, rdata);
    if (rdata !== 32'hDEAD_BEEF)
      `uvm_error("GPIO_SEQ", $sformatf("gpio_in mismatch: got 0x%08h", rdata))

    // Random write/readback on gpio_out
    repeat(num_iters) begin
      void'(std::randomize(rand_data));
      axil_write(GPIO_DIR, 32'hFFFF_FFFF);   // all output
      axil_write(GPIO_OUT, rand_data);
      axil_read(GPIO_OUT, rdata);
      if (rdata !== rand_data)
        `uvm_error("GPIO_SEQ", $sformatf("GPIO_OUT readback fail: wrote 0x%08h got 0x%08h", rand_data, rdata))
    end
    `uvm_info("GPIO_SEQ", $sformatf("GPIO random test PASSED (%0d iters)", num_iters), UVM_NONE)
  endtask
endclass
