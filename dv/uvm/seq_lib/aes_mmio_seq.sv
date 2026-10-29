`timescale 1ns/1ps
class aes_mmio_seq extends criya_base_seq;
  `uvm_object_utils(aes_mmio_seq)

  localparam AES_BASE  = 32'h1000_0000;
  localparam AES_CTRL  = AES_BASE + 32'h00;  // [0]=start [1]=key256 [2]=enc/dec
  localparam AES_STAT  = AES_BASE + 32'h04;  // [0]=done
  localparam AES_PT0   = AES_BASE + 32'h08;  // plaintext word 0
  localparam AES_PT1   = AES_BASE + 32'h0C;
  localparam AES_PT2   = AES_BASE + 32'h10;
  localparam AES_PT3   = AES_BASE + 32'h14;
  localparam AES_KEY0  = AES_BASE + 32'h20;  // key word 0..7
  localparam AES_CT0   = AES_BASE + 32'h40;  // ciphertext word 0

  // AES-256 known-answer: all-zero key, all-zero plaintext
  // Expected CT: DC95C078 A2408989 AD48A214 92842087
  logic [31:0] expected_ct[4] = '{32'hDC95C078, 32'hA2408989, 32'hAD48A214, 32'h92842087};

  function new(string name = "aes_mmio_seq");
    super.new(name);
  endfunction

  task body();
    logic [31:0] rdata, ct[4];
    int timeout;

    `uvm_info("AES_SEQ", "Starting AES-256 KAT sequence", UVM_MEDIUM)

    // Write all-zero 256-bit key (8 words)
    for (int i = 0; i < 8; i++)
      axil_write(AES_KEY0 + i*4, 32'h0000_0000);

    // Write all-zero plaintext (4 words)
    for (int i = 0; i < 4; i++)
      axil_write(AES_PT0 + i*4, 32'h0000_0000);

    // Start: key256=1, enc=1, start=1
    axil_write(AES_CTRL, 32'h0000_0007);

    // Poll done (max 256 cycles at 100MHz = 2560 ns)
    timeout = 0;
    do begin
      axil_read(AES_STAT, rdata);
      timeout++;
      if (timeout > 500) begin
        `uvm_error("AES_SEQ", "AES done timeout!")
        return;
      end
    end while (rdata[0] == 0);

    // Read ciphertext
    for (int i = 0; i < 4; i++) begin
      axil_read(AES_CT0 + i*4, ct[i]);
      if (ct[i] !== expected_ct[i])
        `uvm_error("AES_SEQ", $sformatf(
          "CT[%0d] mismatch: got 0x%08h expected 0x%08h", i, ct[i], expected_ct[i]))
    end

    `uvm_info("AES_SEQ", "AES-256 KAT PASSED", UVM_NONE)
  endtask
endclass
