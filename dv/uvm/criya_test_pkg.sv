`timescale 1ns/1ps
package criya_test_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  `include "agents/axil/criya_axil_seq_item.sv"
  `include "agents/axil/criya_axil_driver.sv"
  `include "agents/axil/criya_axil_monitor.sv"
  `include "agents/axil/criya_axil_agent.sv"
  `include "agents/uart/criya_uart_monitor.sv"
  `include "env/criya_scoreboard.sv"
  `include "env/criya_env.sv"
  `include "seq_lib/criya_base_seq.sv"
  `include "seq_lib/aes_mmio_seq.sv"
  `include "seq_lib/gpio_rand_seq.sv"
  `include "tests/criya_base_test.sv"
  `include "tests/criya_aes_test.sv"
  `include "tests/criya_gpio_test.sv"
endpackage
