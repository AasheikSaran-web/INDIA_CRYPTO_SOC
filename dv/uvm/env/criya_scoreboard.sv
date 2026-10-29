`timescale 1ns/1ps
class criya_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(criya_scoreboard)

  uvm_analysis_imp #(criya_axil_seq_item, criya_scoreboard) axil_imp;

  int unsigned writes_ok, reads_ok, errors;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    axil_imp = new("axil_imp", this);
  endfunction

  function void write(criya_axil_seq_item txn);
    if (txn.resp != 2'b00) begin
      `uvm_error("SCOREBOARD", $sformatf(
        "AXI-Lite ERROR response 2'b%02b on %s addr=0x%08h",
        txn.resp,
        txn.dir == criya_axil_seq_item::AXIL_WRITE ? "WRITE" : "READ",
        txn.addr))
      errors++;
    end else begin
      if (txn.dir == criya_axil_seq_item::AXIL_WRITE) writes_ok++;
      else reads_ok++;
    end
  endfunction

  function void report_phase(uvm_phase phase);
    `uvm_info("SCOREBOARD", $sformatf(
      "Results: WRITES_OK=%0d  READS_OK=%0d  ERRORS=%0d",
      writes_ok, reads_ok, errors), UVM_NONE)
    if (errors > 0)
      `uvm_error("SCOREBOARD", "SCOREBOARD: ERRORS DETECTED — TEST FAILED")
    else
      `uvm_info("SCOREBOARD", "SCOREBOARD: All transactions OK — TEST PASSED", UVM_NONE)
  endfunction
endclass
