`timescale 1ns/1ps
// =============================================================================
// i2c_bfm.sv  —  I2C Slave Bus Functional Model
//
// Detects START/STOP conditions and issues ACK when addressed.
// SLAVE_ADDR = 7'h50
// Icarus-compatible: inout handled via tri-state reg
// =============================================================================

module i2c_bfm #(
    parameter [6:0] SLAVE_ADDR = 7'h50
)(
    inout wire sda,
    input wire scl
);

// ---------------------------------------------------------------------------
// Tri-state drive
// ---------------------------------------------------------------------------
reg sda_oe;   // output enable (active-high)
reg sda_out;  // value to drive when OE

assign sda = (sda_oe) ? sda_out : 1'bz;

initial begin
    sda_oe  = 1'b0;
    sda_out = 1'b1;
end

// ---------------------------------------------------------------------------
// Internal state
// ---------------------------------------------------------------------------
reg        start_detected;
reg        stop_detected;
reg [7:0]  rx_byte;
integer    bit_count;
reg        is_read;
reg        addr_match;

// Transaction log
reg [7:0]  tx_log [0:255];
integer    tx_log_ptr;

initial begin
    start_detected = 1'b0;
    stop_detected  = 1'b0;
    rx_byte        = 8'h00;
    bit_count      = 0;
    is_read        = 1'b0;
    addr_match     = 1'b0;
    tx_log_ptr     = 0;
end

// ---------------------------------------------------------------------------
// START: SDA falls while SCL is high
// ---------------------------------------------------------------------------
always @(negedge sda) begin
    if (scl === 1'b1) begin
        start_detected = 1'b1;
        stop_detected  = 1'b0;
        bit_count      = 0;
        rx_byte        = 8'h00;
        addr_match     = 1'b0;
        sda_oe         = 1'b0;
        $display("[%0t] [i2c_bfm] START detected", $time);
    end
end

// ---------------------------------------------------------------------------
// STOP: SDA rises while SCL is high
// ---------------------------------------------------------------------------
always @(posedge sda) begin
    if (scl === 1'b1 && start_detected) begin
        stop_detected  = 1'b1;
        start_detected = 1'b0;
        sda_oe         = 1'b0;
        $display("[%0t] [i2c_bfm] STOP detected", $time);
    end
end

// ---------------------------------------------------------------------------
// Data sampling on SCL rising edge
// ---------------------------------------------------------------------------
always @(posedge scl) begin
    if (start_detected && !stop_detected) begin
        if (bit_count < 8) begin
            // Shift in bit (MSB first)
            rx_byte   = {rx_byte[6:0], sda};
            bit_count = bit_count + 1;

            if (bit_count == 8) begin
                // Byte complete
                is_read = rx_byte[0];
                if (rx_byte[7:1] == SLAVE_ADDR) begin
                    addr_match = 1'b1;
                    $display("[%0t] [i2c_bfm] Address match: 0x%02X %s",
                             $time, SLAVE_ADDR,
                             is_read ? "(read)" : "(write)");
                end else begin
                    $display("[%0t] [i2c_bfm] Address 0x%02X no match (ours=0x%02X)",
                             $time, rx_byte[7:1], SLAVE_ADDR);
                end
            end
        end else begin
            // 9th clock: ACK/NACK
            bit_count = 0;
            rx_byte   = 8'h00;
        end
    end
end

// ---------------------------------------------------------------------------
// ACK: pull SDA low on 9th clock falling edge when address matched
// ---------------------------------------------------------------------------
always @(negedge scl) begin
    if (start_detected && !stop_detected) begin
        if (bit_count == 8 && addr_match) begin
            // Assert ACK
            sda_oe  = 1'b1;
            sda_out = 1'b0;
            $display("[%0t] [i2c_bfm] ACK asserted", $time);
        end else begin
            // Release SDA
            sda_oe  = 1'b0;
        end
    end
end

// ---------------------------------------------------------------------------
// Log received data bytes
// ---------------------------------------------------------------------------
always @(posedge scl) begin
    if (start_detected && !stop_detected && addr_match) begin
        if (bit_count == 8 && !is_read) begin
            if (tx_log_ptr < 256) begin
                tx_log[tx_log_ptr] = rx_byte;
                tx_log_ptr         = tx_log_ptr + 1;
                $display("[%0t] [i2c_bfm] Data byte: 0x%02X", $time, rx_byte);
            end
        end
    end
end

endmodule
