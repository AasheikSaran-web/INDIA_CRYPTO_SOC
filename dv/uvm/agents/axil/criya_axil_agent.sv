`timescale 1ns/1ps
class criya_axil_agent extends uvm_agent;
  `uvm_component_utils(criya_axil_agent)

  criya_axil_driver    driver;
  criya_axil_monitor   monitor;
  uvm_sequencer #(criya_axil_seq_item) sequencer;

  uvm_analysis_port #(criya_axil_seq_item) ap;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    ap       = new("ap", this);
    monitor  = criya_axil_monitor::type_id::create("monitor", this);
    if (get_is_active() == UVM_ACTIVE) begin
      driver    = criya_axil_driver::type_id::create("driver", this);
      sequencer = uvm_sequencer #(criya_axil_seq_item)::type_id::create("sequencer", this);
    end
  endfunction

  function void connect_phase(uvm_phase phase);
    monitor.ap.connect(ap);
    if (get_is_active() == UVM_ACTIVE)
      driver.seq_item_port.connect(sequencer.seq_item_export);
  endfunction
endclass
