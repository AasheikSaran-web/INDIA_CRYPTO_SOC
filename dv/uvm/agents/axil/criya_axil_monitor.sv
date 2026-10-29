`timescale 1ns/1ps
class criya_axil_monitor extends uvm_monitor;
  `uvm_component_utils(criya_axil_monitor)

  uvm_analysis_port #(criya_axil_seq_item) ap;
  virtual criya_axil_if vif;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    ap = new("ap", this);
    if (!uvm_config_db #(virtual criya_axil_if)::get(this, "", "axil_vif", vif))
      `uvm_fatal("NOVIF", "criya_axil_monitor: axil_vif not found")
  endfunction

  task run_phase(uvm_phase phase);
    criya_axil_seq_item txn;
    @(posedge vif.rst_n);
    forever begin
      txn = criya_axil_seq_item::type_id::create("mon_txn");
      // Detect write or read
      fork
        begin: write_detect
          @(posedge vif.clk iff (vif.awvalid && vif.awready));
          txn.dir  = criya_axil_seq_item::AXIL_WRITE;
          txn.addr = vif.awaddr;
          @(posedge vif.clk iff (vif.wvalid && vif.wready));
          txn.data = vif.wdata;
          @(posedge vif.clk iff vif.bvalid);
          txn.resp = vif.bresp;
          disable read_detect;
        end
        begin: read_detect
          @(posedge vif.clk iff (vif.arvalid && vif.arready));
          txn.dir  = criya_axil_seq_item::AXIL_READ;
          txn.addr = vif.araddr;
          @(posedge vif.clk iff vif.rvalid);
          txn.rdata = vif.rdata;
          txn.resp  = vif.rresp;
          disable write_detect;
        end
      join_any
      ap.write(txn);
    end
  endtask
endclass
