`timescale 1ns/1ps
class criya_env extends uvm_env;
  `uvm_component_utils(criya_env)

  criya_axil_agent   axil_agent;
  criya_uart_monitor uart_monitor;
  criya_scoreboard   scoreboard;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    axil_agent   = criya_axil_agent::type_id::create("axil_agent", this);
    uart_monitor = criya_uart_monitor::type_id::create("uart_monitor", this);
    scoreboard   = criya_scoreboard::type_id::create("scoreboard", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    axil_agent.ap.connect(scoreboard.axil_imp);
  endfunction
endclass
