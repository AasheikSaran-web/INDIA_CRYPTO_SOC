// aadhaar_id_check.v — Aadhaar document header identifier
// Purely combinational.
//
// The UIDAI Offline Aadhaar XML document starts with the ASCII sequence
//   <?xml  →  bytes 0x3C 0x3F 0x78 0x6D
// When loaded by the RV32 (little-endian) CPU as a 32-bit word from
// address 0 of the document buffer:
//   LW t0, 0(src)  →  t0 = 0x6D78_3F3C
//
// Firmware reads that word, writes it to REG_ADH_HDR (offset 0x8C of the
// PDF engine), and this module asserts id_ok if the magic matches.
//
// The expected magic is also exposed as REG_ADH_HDR_EXP (offset 0x94) so
// firmware can read it back and verify the expected value is what was used.

`timescale 1ns/1ps
`default_nettype none

module aadhaar_id_check (
    input  wire [31:0] hdr_word,   // first 4 bytes of document (as LE word)
    output wire        id_ok       // 1 when hdr_word matches Aadhaar XML magic
);

// <?xml  in little-endian 32-bit word:
//   byte[0]='<'=0x3C  byte[1]='?'=0x3F  byte[2]='x'=0x78  byte[3]='m'=0x6D
localparam [31:0] AADHAAR_XML_MAGIC = 32'h6D78_3F3C;

assign id_ok = (hdr_word == AADHAAR_XML_MAGIC);

endmodule
