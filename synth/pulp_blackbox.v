// =============================================================
// pulp_blackbox.v  — Black-box stubs for PULP IP sub-modules
// Used during Yosys synthesis so the tool can see port lists
// without needing to elaborate the full PULP source (which
// uses APB/OBI struct macros and is validated separately).
// =============================================================

(* blackbox *)
module apb_spi_master #(
    parameter BUFFER_DEPTH   = 8,
    parameter APB_ADDR_WIDTH = 12
)(
    input  wire                      HCLK,
    input  wire                      HRESETn,
    input  wire [APB_ADDR_WIDTH-1:0] PADDR,
    input  wire [31:0]               PWDATA,
    input  wire                      PWRITE,
    input  wire                      PSEL,
    input  wire                      PENABLE,
    output wire [31:0]               PRDATA,
    output wire                      PREADY,
    output wire                      PSLVERR,
    output wire [7:0]                events_o,
    output wire                      spi_clk,
    output wire                      spi_csn0,
    output wire                      spi_csn1,
    output wire                      spi_csn2,
    output wire                      spi_csn3,
    output wire [1:0]                spi_mode,
    output wire                      spi_sdo0,
    output wire                      spi_sdo1,
    output wire                      spi_sdo2,
    output wire                      spi_sdo3,
    input  wire                      spi_sdi0,
    input  wire                      spi_sdi1,
    input  wire                      spi_sdi2,
    input  wire                      spi_sdi3
);
endmodule

(* blackbox *)
module apb_uart (
    input  wire        CLK,
    input  wire        RSTN,
    // APB
    input  wire        PSEL,
    input  wire        PENABLE,
    input  wire        PWRITE,
    input  wire [4:0]  PADDR,
    input  wire [31:0] PWDATA,
    output wire [31:0] PRDATA,
    output wire        PREADY,
    output wire        PSLVERR,
    // Interrupt
    output wire        INT,
    // Physical UART
    input  wire        SIN,
    output wire        SOUT,
    // Modem control outputs
    output wire        OUT1N,
    output wire        OUT2N,
    output wire        RTSN,
    output wire        DTRN,
    // Modem control inputs
    input  wire        CTSN,
    input  wire        DSRN,
    input  wire        DCDN,
    input  wire        RIN
);
endmodule

(* blackbox *)
module apb_i2c #(
    parameter APB_ADDR_WIDTH = 12
)(
    input  wire [APB_ADDR_WIDTH-1:0] PADDR,
    input  wire [31:0]               PWDATA,
    input  wire                      PWRITE,
    input  wire                      PSEL,
    input  wire                      PENABLE,
    output wire [31:0]               PRDATA,
    output wire                      PREADY,
    output wire                      PSLVERR,
    input  wire                      HCLK,
    input  wire                      HRESETn,
    output wire                      interrupt_o,
    input  wire                      scl_pad_i,
    output wire                      scl_pad_o,
    output wire                      scl_padoen_o,
    input  wire                      sda_pad_i,
    output wire                      sda_pad_o,
    output wire                      sda_padoen_o
);
endmodule
