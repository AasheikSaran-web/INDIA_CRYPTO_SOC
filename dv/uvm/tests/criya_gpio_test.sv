`timescale 1ns/1ps
class criya_gpio_test extends criya_base_test;
  `uvm_component_utils(criya_gpio_test)

  function new(string name, uvm_component parent); super.new(name, parent); endfunction

  task run_phase(uvm_phase phase);
    gpio_rand_seq seq;
    phase.raise_objection(this);
    #2000;
    seq = gpio_rand_seq::type_id::create("seq");
    seq.num_iters = 20;
    seq.start(env.axil_agent.sequencer);
    phase.drop_objection(this);
  endtask
endclass
