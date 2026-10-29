`timescale 1ns/1ps
class criya_axil_driver extends uvm_driver #(criya_axil_seq_item);
  `uvm_component_utils(criya_axil_driver)

  virtual criya_axil_if vif;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db #(virtual criya_axil_if)::get(this, "", "axil_vif", vif))
      `uvm_fatal("NOVIF", "criya_axil_driver: axil_vif not found in config_db")
  endfunction

  task run_phase(uvm_phase phase);
    criya_axil_seq_item req;
    // Initialize to idle
    vif.master_cb.awvalid <= 0; vif.master_cb.wvalid <= 0;
    vif.master_cb.bready  <= 1;
    vif.master_cb.arvalid <= 0; vif.master_cb.rready <= 1;
    @(posedge vif.rst_n);
    forever begin
      seq_item_port.get_next_item(req);
      if (req.dir == criya_axil_seq_item::AXIL_WRITE)
        do_write(req);
      else
        do_read(req);
      seq_item_port.item_done();
    end
  endtask

  task do_write(criya_axil_seq_item req);
    // Drive AW and W channels simultaneously
    vif.master_cb.awaddr  <= req.addr;
    vif.master_cb.awprot  <= 3'b000;
    vif.master_cb.awvalid <= 1;
    vif.master_cb.wdata   <= req.data;
    vif.master_cb.wstrb   <= req.wstrb;
    vif.master_cb.wvalid  <= 1;
    // Wait for both handshakes
    fork
      begin @(posedge vif.clk iff vif.awready); vif.master_cb.awvalid <= 0; end
      begin @(posedge vif.clk iff vif.wready);  vif.master_cb.wvalid  <= 0; end
    join
    // Wait for B channel
    @(posedge vif.clk iff vif.bvalid);
    req.resp = vif.bresp;
    @(posedge vif.clk);
  endtask

  task do_read(criya_axil_seq_item req);
    vif.master_cb.araddr  <= req.addr;
    vif.master_cb.arprot  <= 3'b000;
    vif.master_cb.arvalid <= 1;
    @(posedge vif.clk iff vif.arready);
    vif.master_cb.arvalid <= 0;
    @(posedge vif.clk iff vif.rvalid);
    req.rdata = vif.rdata;
    req.resp  = vif.rresp;
    @(posedge vif.clk);
  endtask
endclass
