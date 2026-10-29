`timescale 1ns/1ps
// =============================================================================
// uart_bfm.sv  —  UART Bus Functional Model
//
// Icarus-compatible: no string type, no mailbox, no UVM
// =============================================================================

module uart_bfm #(
    parameter integer CLK_PERIOD_NS = 10,
    parameter integer BAUD          = 115200
)(
    input  wire       clk,
    input  wire       rst_n,
    output reg        tx,   // BFM-driven TX line (optional, unused if loopback)
    input  wire       rx    // line to monitor
);

// ---------------------------------------------------------------------------
// Derived timing
// ---------------------------------------------------------------------------
// bit period in ns
localparam real   BIT_PERIOD_NS = 1.0e9 / BAUD;
// bit period in clock cycles (integer approximation)
localparam integer BIT_CYCLES   = BIT_PERIOD_NS / CLK_PERIOD_NS;

// ---------------------------------------------------------------------------
// TX default = idle high
// ---------------------------------------------------------------------------
initial tx = 1'b1;

// ---------------------------------------------------------------------------
// send_byte task: drives tx line with start + 8 data bits + stop
// ---------------------------------------------------------------------------
task send_byte;
    input [7:0] data;
    integer     b;
    begin
        // Start bit
        tx = 1'b0;
        #(BIT_PERIOD_NS);
        // Data bits LSB first
        for (b = 0; b < 8; b = b + 1) begin
            tx = data[b];
            #(BIT_PERIOD_NS);
        end
        // Stop bit
        tx = 1'b1;
        #(BIT_PERIOD_NS);
    end
endtask

// ---------------------------------------------------------------------------
// send_string_bytes: send a fixed array of bytes (Icarus avoids 'string' type)
// Caller fills a byte array and passes length
// ---------------------------------------------------------------------------
// (Callers can call send_byte in a loop directly; send_string is a wrapper
//  that works with a byte array + count.)
task send_bytes;
    input [7:0] data_arr [0:63];
    input integer len;
    integer idx;
    begin
        for (idx = 0; idx < len; idx = idx + 1)
            send_byte(data_arr[idx]);
    end
endtask

// ---------------------------------------------------------------------------
// RX monitor: captures bytes from the rx line into a FIFO (shift-reg based)
// Icarus-compatible: simple reg array, no mailbox
// ---------------------------------------------------------------------------
localparam RX_FIFO_DEPTH = 64;

reg [7:0] rx_fifo [0:RX_FIFO_DEPTH-1];
integer   rx_wr_ptr;
integer   rx_rd_ptr;
integer   rx_count;

initial begin
    rx_wr_ptr = 0;
    rx_rd_ptr = 0;
    rx_count  = 0;
end

// Function: is RX FIFO empty?
function rx_empty;
    input dummy;
    begin
        rx_empty = (rx_count == 0);
    end
endfunction

// Function: peek at oldest byte (does not remove)
function [7:0] rx_peek;
    input dummy;
    begin
        rx_peek = rx_fifo[rx_rd_ptr];
    end
endfunction

// Task: pop oldest byte from FIFO
task rx_pop;
    output [7:0] data;
    begin
        data      = rx_fifo[rx_rd_ptr];
        rx_rd_ptr = (rx_rd_ptr + 1) % RX_FIFO_DEPTH;
        rx_count  = rx_count - 1;
    end
endtask

// ---------------------------------------------------------------------------
// RX monitoring always block
// ---------------------------------------------------------------------------
reg [7:0] rx_byte;
integer   rx_bit;

always @(negedge rx) begin : rx_monitor
    if (rst_n === 1'b1) begin
        // Potential start bit
        // Sample at centre of start bit
        #(BIT_PERIOD_NS / 2.0);
        if (rx === 1'b0) begin
            rx_byte = 8'h00;
            for (rx_bit = 0; rx_bit < 8; rx_bit = rx_bit + 1) begin
                #(BIT_PERIOD_NS);
                rx_byte[rx_bit] = rx;
            end
            // Skip stop bit
            #(BIT_PERIOD_NS);

            // Push to FIFO
            if (rx_count < RX_FIFO_DEPTH) begin
                rx_fifo[rx_wr_ptr] = rx_byte;
                rx_wr_ptr = (rx_wr_ptr + 1) % RX_FIFO_DEPTH;
                rx_count  = rx_count + 1;
                $display("[%0t] [uart_bfm] RX byte: 0x%02X ('%c')", $time, rx_byte,
                         (rx_byte >= 8'h20 && rx_byte < 8'h7F) ? rx_byte : 8'h2E);
            end else begin
                $display("[%0t] [uart_bfm] WARNING: RX FIFO full, byte 0x%02X dropped",
                         $time, rx_byte);
            end
        end
    end
end

endmodule
