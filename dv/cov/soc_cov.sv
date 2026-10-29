`timescale 1ns/1ps
// =============================================================================
// soc_cov.sv  —  SoC-level functional coverage model
//
// Instantiate in soc_tb.sv and call sample() from test stimulus or monitors.
// =============================================================================

module soc_cov (
    input wire        clk,
    input wire        rst_n,

    // AES-CA register write signals (slave port s2)
    input wire        aes_awvalid,
    input wire [31:0] aes_awaddr,
    input wire [31:0] aes_wdata,

    // GPIO direction port
    input wire [31:0] gpio_dir,

    // IRQ sources
    input wire        seceng_irq,
    input wire        trng_rct,
    input wire        trng_apt,
    input wire        pdf_irq,
    input wire        uart_irq,

    // Reset (for cg_reset_cycles)
    input wire        rst_n_sync
);

// ---------------------------------------------------------------------------
// AES operation tracking
// ---------------------------------------------------------------------------
// AES-CA register offsets (relative to 0x10000000):
//   +0x00: control  bit[0]=start, bit[1]=key_sel(0=256,1=128)
// We latch wdata when awaddr[7:0] == 8'h00 and awvalid

reg [31:0] aes_ctrl_shadow;
reg        aes_ctrl_written;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        aes_ctrl_shadow  <= 32'h0;
        aes_ctrl_written <= 1'b0;
    end else begin
        aes_ctrl_written <= 1'b0;
        if (aes_awvalid && (aes_awaddr[7:0] == 8'h00)) begin
            aes_ctrl_shadow  <= aes_wdata;
            aes_ctrl_written <= 1'b1;
        end
    end
end

// ---------------------------------------------------------------------------
// Reset cycle counter
// ---------------------------------------------------------------------------
integer rst_cycle_cnt;
reg     rst_was_low;
reg     rst_sampled;

always @(posedge clk) begin
    if (!rst_n_sync) begin
        rst_cycle_cnt <= rst_cycle_cnt + 1;
        rst_was_low   <= 1'b1;
        rst_sampled   <= 1'b0;
    end else begin
        if (rst_was_low && !rst_sampled) begin
            rst_sampled <= 1'b1;
            // cg_reset_cycles is sampled by task below
        end
        if (!rst_was_low) begin
            rst_cycle_cnt <= 0;
        end
    end
end

initial begin
    rst_cycle_cnt = 0;
    rst_was_low   = 1'b0;
    rst_sampled   = 1'b0;
end

// ---------------------------------------------------------------------------
// Covergroup: AES operations
// ---------------------------------------------------------------------------
covergroup cg_aes_ops @(posedge clk);
    option.per_instance = 1;
    option.name         = "cg_aes_ops";

    // Key length: bit[1] of control = 0 means AES-256, 1 means AES-128
    cp_key_len: coverpoint aes_ctrl_shadow[1] iff (aes_ctrl_written) {
        bins key_256 = {1'b0};
        bins key_128 = {1'b1};
    }

    // Direction: bit[2] = decrypt flag (assumed)
    cp_direction: coverpoint aes_ctrl_shadow[2] iff (aes_ctrl_written) {
        bins encrypt = {1'b0};
        bins decrypt = {1'b1};
    }

    // Cross: key_len x direction
    cx_key_dir: cross cp_key_len, cp_direction;
endgroup

// ---------------------------------------------------------------------------
// Covergroup: GPIO direction transitions
// ---------------------------------------------------------------------------
covergroup cg_gpio_dir @(posedge clk);
    option.name = "cg_gpio_dir";

    cp_dir_mode: coverpoint gpio_dir {
        bins all_input  = {32'h0000_0000};
        bins all_output = {32'hFFFF_FFFF};
        bins mixed      = default;
    }
endgroup

// ---------------------------------------------------------------------------
// Covergroup: IRQ sources
// ---------------------------------------------------------------------------
covergroup cg_irq_sources @(posedge clk);
    option.name = "cg_irq_sources";

    cp_trng_rct:  coverpoint trng_rct  { bins fired = {1'b1}; }
    cp_trng_apt:  coverpoint trng_apt  { bins fired = {1'b1}; }
    cp_pdf_irq:   coverpoint pdf_irq   { bins fired = {1'b1}; }
    cp_uart_irq:  coverpoint uart_irq  { bins fired = {1'b1}; }

    cx_irq_cross: cross cp_trng_rct, cp_trng_apt, cp_pdf_irq, cp_uart_irq;
endgroup

// ---------------------------------------------------------------------------
// Covergroup: Reset cycle count
// ---------------------------------------------------------------------------
covergroup cg_reset_cycles;
    option.name = "cg_reset_cycles";

    cp_rst_len: coverpoint rst_cycle_cnt {
        bins short_reset   = {[0:9]};
        bins nominal_reset = {[10:50]};
        bins long_reset    = {[51:$]};
    }
endgroup

// ---------------------------------------------------------------------------
// Instantiate covergroups
// ---------------------------------------------------------------------------
cg_aes_ops      cg_aes_i   = new();
cg_gpio_dir     cg_gpio_i  = new();
cg_irq_sources  cg_irq_i   = new();
cg_reset_cycles cg_rst_i   = new();

// ---------------------------------------------------------------------------
// sample() task: call from testbench at key stimulus points
// ---------------------------------------------------------------------------
task sample;
    begin
        cg_aes_i.sample();
        cg_gpio_i.sample();
        cg_irq_i.sample();
    end
endtask

// Sample reset covergroup on reset release
always @(posedge rst_n_sync) begin
    if (rst_was_low)
        cg_rst_i.sample();
end

// ---------------------------------------------------------------------------
// Periodic coverage report
// ---------------------------------------------------------------------------
initial begin
    forever begin
        @(posedge clk);
        // Auto-sample IRQ covergroup each cycle
        cg_irq_i.sample();
    end
end

endmodule
