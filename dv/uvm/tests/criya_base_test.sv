`timescale 1ns/1ps
class criya_base_test extends uvm_test;
  `uvm_component_utils(criya_base_test)

  criya_env env;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = criya_env::type_id::create("env", this);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    #1000;  // wait for reset
    phase.drop_objection(this);
  endtask
endclass
