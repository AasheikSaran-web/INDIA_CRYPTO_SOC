`timescale 1ns/1ps
class criya_axil_seq_item extends uvm_sequence_item;
  `uvm_object_utils_begin(criya_axil_seq_item)
    `uvm_field_int(addr,    UVM_ALL_ON)
    `uvm_field_int(data,    UVM_ALL_ON)
    `uvm_field_int(wstrb,   UVM_ALL_ON)
    `uvm_field_enum(axil_dir_e, dir, UVM_ALL_ON)
    `uvm_field_int(rdata,   UVM_ALL_ON)
    `uvm_field_int(resp,    UVM_ALL_ON)
  `uvm_object_utils_end

  typedef enum {AXIL_WRITE, AXIL_READ} axil_dir_e;

  rand logic [31:0] addr;
  rand logic [31:0] data;
  rand logic [3:0]  wstrb = 4'hF;
  rand axil_dir_e   dir;
  logic [31:0]      rdata;
  logic [1:0]       resp;

  // Constrain to valid CRIYA address spaces
  constraint c_valid_addr {
    addr inside {
      [32'h0000_0000 : 32'h0000_7FFF],  // ROM
      [32'h0001_0000 : 32'h0001_FFFF],  // SRAM
      [32'h1000_0000 : 32'h1000_00FF],  // AES-CA
      [32'h1001_0000 : 32'h1001_00FF],  // TRNG
      [32'h2000_0000 : 32'h2000_00FF],  // UART
      [32'h4000_0000 : 32'h4000_000F]   // GPIO
    };
    addr[1:0] == 2'b00;  // word-aligned
  }

  function new(string name="criya_axil_seq_item");
    super.new(name);
  endfunction
endclass
