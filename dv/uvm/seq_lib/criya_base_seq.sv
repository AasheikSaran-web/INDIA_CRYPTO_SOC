`timescale 1ns/1ps
class criya_base_seq extends uvm_sequence #(criya_axil_seq_item);
  `uvm_object_utils(criya_base_seq)

  function new(string name = "criya_base_seq");
    super.new(name);
  endfunction

  task axil_write(input logic [31:0] addr, data, input logic [3:0] wstrb = 4'hF);
    criya_axil_seq_item req = criya_axil_seq_item::type_id::create("req");
    start_item(req);
    if (!req.randomize() with {
      dir       == criya_axil_seq_item::AXIL_WRITE;
      req.addr  == addr;
      req.data  == data;
      req.wstrb == wstrb; })
      `uvm_fatal("RAND", "axil_write randomize failed")
    finish_item(req);
  endtask

  task axil_read(input logic [31:0] addr, output logic [31:0] rdata);
    criya_axil_seq_item req = criya_axil_seq_item::type_id::create("req");
    start_item(req);
    if (!req.randomize() with {
      dir      == criya_axil_seq_item::AXIL_READ;
      req.addr == addr; })
      `uvm_fatal("RAND", "axil_read randomize failed")
    finish_item(req);
    rdata = req.rdata;
  endtask
endclass
