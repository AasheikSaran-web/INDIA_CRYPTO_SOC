`timescale 1ns/1ps
class criya_uart_monitor extends uvm_monitor;
  `uvm_component_utils(criya_uart_monitor)

  uvm_analysis_port #(uvm_reg_data_t) ap;
  virtual criya_uart_if vif;

  localparam BIT_TIME = 8680; // ns at 115200 baud

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    ap = new("ap", this);
    if (!uvm_config_db #(virtual criya_uart_if)::get(this, "", "uart_vif", vif))
      `uvm_fatal("NOVIF", "uart_vif not found")
  endfunction

  task run_phase(uvm_phase phase);
    byte unsigned rx_char;
    string rx_line = "";
    forever begin
      // Wait for start bit (falling edge on tx)
      @(negedge vif.tx);
      // Wait to center of first data bit
      #(BIT_TIME + BIT_TIME/2);
      rx_char = 0;
      for (int i = 0; i < 8; i++) begin
        rx_char[i] = vif.tx;
        #BIT_TIME;
      end
      ap.write(rx_char);
      // Accumulate line for display
      if (rx_char == "\n") begin
        `uvm_info("UART_MON", $sformatf("RX: %s", rx_line), UVM_MEDIUM)
        if (rx_line == "PASS")
          `uvm_info("UART_MON", "=== TEST PASSED ===", UVM_NONE)
        else if (rx_line == "FAIL")
          `uvm_error("UART_MON", "=== TEST FAILED ===")
        rx_line = "";
      end else begin
        rx_line = {rx_line, string'(rx_char)};
      end
    end
  endtask
endclass
