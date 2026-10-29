`timescale 1ns/1ps
// =============================================================================
// spi_bfm.sv  —  SPI Slave Bus Functional Model
//
// Mode 0 (CPOL=0, CPHA=0): sample on rising SCK, shift on falling SCK
// Icarus-compatible: no string, no mailbox
// =============================================================================

module spi_bfm #(
    parameter CPOL = 0,
    parameter CPHA = 0
)(
    input  wire sck,
    input  wire cs_n,
    input  wire mosi,
    output reg  miso
);

// ---------------------------------------------------------------------------
// Receive shift register
// ---------------------------------------------------------------------------
reg [7:0]  shift_reg;
integer    bit_cnt;
reg [7:0]  rx_log [0:255];
integer    rx_log_ptr;

initial begin
    miso       = 1'b0;
    shift_reg  = 8'h00;
    bit_cnt    = 0;
    rx_log_ptr = 0;
end

// ---------------------------------------------------------------------------
// Capture MOSI on rising SCK while CS is asserted (mode 0)
// ---------------------------------------------------------------------------
always @(posedge sck) begin
    if (!cs_n) begin
        shift_reg = {shift_reg[6:0], mosi};
        bit_cnt   = bit_cnt + 1;

        if (bit_cnt == 8) begin
            $display("[%0t] [spi_bfm] RX byte: 0x%02X", $time, shift_reg);
            if (rx_log_ptr < 256) begin
                rx_log[rx_log_ptr] = shift_reg;
                rx_log_ptr = rx_log_ptr + 1;
            end
            shift_reg = 8'h00;
            bit_cnt   = 0;
        end
    end
end

// ---------------------------------------------------------------------------
// Reset on CS deassert
// ---------------------------------------------------------------------------
always @(posedge cs_n) begin
    shift_reg = 8'h00;
    bit_cnt   = 0;
end

// ---------------------------------------------------------------------------
// MISO: drive 0 (loopback can be wired by setting miso = rx_log[n])
// ---------------------------------------------------------------------------
always @(negedge sck) begin
    miso = 1'b0;
end

endmodule
