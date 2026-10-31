

`timescale 1ns/1ps
`default_nettype none

// aadhaar_id_check: hardware module definition
module aadhaar_id_check (
    input  wire [31:0] hdr_word,
    output wire        id_ok
);
localparam [31:0] AADHAAR_XML_MAGIC = 32'h6D78_3F3C;

assign id_ok = (hdr_word == AADHAAR_XML_MAGIC);

endmodule
