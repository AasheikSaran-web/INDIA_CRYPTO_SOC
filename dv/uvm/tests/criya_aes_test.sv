`timescale 1ns/1ps
class criya_aes_test extends criya_base_test;
  `uvm_component_utils(criya_aes_test)

  function new(string name, uvm_component parent); super.new(name, parent); endfunction

  task run_phase(uvm_phase phase);
    aes_mmio_seq seq;
    phase.raise_objection(this);
    #2000;  // wait for reset + CPU boot
    seq = aes_mmio_seq::type_id::create("seq");
    seq.start(env.axil_agent.sequencer);
    phase.drop_objection(this);
  endtask
endclass
