`timescale 1ns/1ps
// =============================================================================
// soc_tb.sv  —  Top-level SoC testbench for india_crypto_soc
//
// Usage:
//   +test=<name>   load tests/sw/<name>.hex into SRAM
//   +dump          enable VCD dump
// =============================================================================

module soc_tb;

// ---------------------------------------------------------------------------
// Parameters
// ---------------------------------------------------------------------------
localparam CLK_PERIOD_NS    = 10;
localparam ROSC_PERIOD_NS   = 7;
localparam RESET_CYCLES     = 20;
localparam WATCHDOG_CYCLES  = 5_000_000;
// 115200 baud at 10 ns/cycle => 1e9/115200 ~= 8680 ns => 868 cycles
localparam BAUD_CYCLES      = 868;
localparam SRAM_DEPTH       = 16384;

// ---------------------------------------------------------------------------
// DUT signals
// ---------------------------------------------------------------------------
logic        clk;
logic        rst_n;
logic        rosc_ext;
logic        uart_rx;
wire         uart_tx;
wire         i2c_sda;
wire         i2c_scl;
wire         spi_mosi;
logic        spi_miso;
wire         spi_sck;
wire         spi_cs_n;
logic [31:0] gpio_in;
wire  [31:0] gpio_out;
wire  [31:0] gpio_dir;
wire         seceng_irq;

// ---------------------------------------------------------------------------
// SRAM preload memory — matches sram_sp_wrap depth
// ---------------------------------------------------------------------------
reg [31:0] sram_mem [0:SRAM_DEPTH-1];

// ---------------------------------------------------------------------------
// Plusarg: test name
// ---------------------------------------------------------------------------
reg [255:0] test_name;
initial begin
    if (!$value$plusargs("test=%s", test_name))
        test_name = "default";
end

// ---------------------------------------------------------------------------
// Clock generation
// ---------------------------------------------------------------------------
initial clk = 0;
always #(CLK_PERIOD_NS/2) clk = ~clk;

// ---------------------------------------------------------------------------
// ROSC external clock (async, 7 ns period)
// ---------------------------------------------------------------------------
initial rosc_ext = 0;
always #(ROSC_PERIOD_NS/2) rosc_ext = ~rosc_ext;

// ---------------------------------------------------------------------------
// Reset
// ---------------------------------------------------------------------------
initial begin
    rst_n = 1'b0;
    repeat (RESET_CYCLES) @(posedge clk);
    @(negedge clk);
    rst_n = 1'b1;
    $display("[%0t] [soc_tb] Reset released after %0d cycles", $time, RESET_CYCLES);
end

// ---------------------------------------------------------------------------
// GPIO stimulus
// ---------------------------------------------------------------------------
initial gpio_in = 32'hDEAD_BEEF;

// ---------------------------------------------------------------------------
// SPI: tie miso=0
// ---------------------------------------------------------------------------
initial spi_miso = 1'b0;

// ---------------------------------------------------------------------------
// I2C: pull-up via pullup primitives
// ---------------------------------------------------------------------------
pullup(i2c_sda);
pullup(i2c_scl);

// ---------------------------------------------------------------------------
// UART loopback: uart_tx -> uart_rx
// ---------------------------------------------------------------------------
assign uart_rx = uart_tx;

// ---------------------------------------------------------------------------
// DUT instantiation
// ---------------------------------------------------------------------------
india_crypto_soc dut (
    .clk        (clk),
    .rst_n      (rst_n),
    .rosc_ext   (rosc_ext),
    .uart_rx    (uart_rx),
    .uart_tx    (uart_tx),
    .i2c_sda    (i2c_sda),
    .i2c_scl    (i2c_scl),
    .spi_mosi   (spi_mosi),
    .spi_miso   (spi_miso),
    .spi_sck    (spi_sck),
    .spi_cs_n   (spi_cs_n),
    .gpio_in    (gpio_in),
    .gpio_out   (gpio_out),
    .gpio_dir   (gpio_dir),
    .seceng_irq (seceng_irq)
);

// ---------------------------------------------------------------------------
// SRAM preload  — force internal mem array after reset
// ---------------------------------------------------------------------------
reg [511:0] hex_path;
integer     i_init;

initial begin : sram_preload
    // zero-init first
    for (i_init = 0; i_init < SRAM_DEPTH; i_init = i_init + 1)
        sram_mem[i_init] = 32'h0;

    // read hex
    $sformat(hex_path, "tests/sw/%0s.hex", test_name);
    $display("[%0t] [soc_tb] Loading %0s", $time, hex_path);
    $readmemh(hex_path, sram_mem);

    // Wait until reset is done then force SRAM contents
    @(posedge rst_n);
    @(posedge clk);
    force dut.u_sram_ctrl.u_sram.mem = sram_mem;
    $display("[%0t] [soc_tb] SRAM preload complete", $time);
end

// ---------------------------------------------------------------------------
// VCD dump
// ---------------------------------------------------------------------------
initial begin
    if ($test$plusargs("dump")) begin
        $system("mkdir -p sim_out/soc_tb");
        $dumpfile("sim_out/soc_tb/tb.vcd");
        $dumpvars(0, soc_tb);
        $display("[%0t] [soc_tb] VCD dump enabled -> sim_out/soc_tb/tb.vcd", $time);
    end
end

// ---------------------------------------------------------------------------
// Watchdog
// ---------------------------------------------------------------------------
integer wd_cnt;
initial begin : watchdog
    wd_cnt = 0;
    @(posedge rst_n);
    forever begin
        @(posedge clk);
        wd_cnt = wd_cnt + 1;
        if (wd_cnt >= WATCHDOG_CYCLES) begin
            $display("[%0t] [soc_tb] WATCHDOG TIMEOUT after %0d cycles — TEST FAILED",
                     $time, WATCHDOG_CYCLES);
            $finish(1);
        end
    end
end

// ---------------------------------------------------------------------------
// UART TX monitor: sample at 115200 baud, detect "PASS\n" / "FAIL\n"
// Icarus-compatible: no string type, plain byte comparison
// ---------------------------------------------------------------------------
// Circular buffer: last 5 characters
reg [7:0] uart_buf [0:4];
integer   uart_buf_idx;

// Baud sampling
real      uart_bit_period_ns;
integer   uart_bit_cycles;

initial begin
    uart_bit_period_ns = 1.0e9 / 115200.0;   // ~8680 ns
    uart_bit_cycles    = 868;
    uart_buf_idx       = 0;
    uart_buf[0] = 8'h00; uart_buf[1] = 8'h00; uart_buf[2] = 8'h00;
    uart_buf[3] = 8'h00; uart_buf[4] = 8'h00;
end

// Monitor uart_tx
reg [7:0] rx_byte;
integer   bit_idx;

always @(negedge uart_tx) begin : uart_monitor
    // Possible start bit — verify we are actually after reset
    if (rst_n === 1'b1) begin
        // Wait half bit period to centre sample on start bit
        #(CLK_PERIOD_NS * uart_bit_cycles / 2);

        // Verify this is still a start bit (low)
        if (uart_tx === 1'b0) begin
            rx_byte = 8'h00;
            // Sample 8 data bits, each one full bit-period after start-bit centre
            for (bit_idx = 0; bit_idx < 8; bit_idx = bit_idx + 1) begin
                #(CLK_PERIOD_NS * uart_bit_cycles);
                rx_byte[bit_idx] = uart_tx;
            end
            // Move past stop bit
            #(CLK_PERIOD_NS * uart_bit_cycles);

            $write("%c", rx_byte);

            // Shift buffer
            uart_buf[4] = uart_buf[3];
            uart_buf[3] = uart_buf[2];
            uart_buf[2] = uart_buf[1];
            uart_buf[1] = uart_buf[0];
            uart_buf[0] = rx_byte;

            // Check for "PASS\n" (buf[4..0] = 'P','A','S','S','\n')
            if (uart_buf[0] == 8'h0A &&   // '\n'
                uart_buf[1] == 8'h53 &&   // 'S'
                uart_buf[2] == 8'h53 &&   // 'S'
                uart_buf[3] == 8'h41 &&   // 'A'
                uart_buf[4] == 8'h50) begin  // 'P'
                $display("\n[%0t] [soc_tb] TEST PASSED", $time);
                $finish(0);
            end

            // Check for "FAIL\n"
            if (uart_buf[0] == 8'h0A &&   // '\n'
                uart_buf[1] == 8'h4C &&   // 'L'
                uart_buf[2] == 8'h49 &&   // 'I'
                uart_buf[3] == 8'h41 &&   // 'A'
                uart_buf[4] == 8'h46) begin  // 'F'
                $display("\n[%0t] [soc_tb] TEST FAILED", $time);
                $finish(1);
            end
        end
    end
end

// ---------------------------------------------------------------------------
// Checker instantiations (SV assertions — VCS only; no-ops under Icarus)
// ---------------------------------------------------------------------------
`ifndef IVERILOG

axil_checker #(
    .DATA_W (32),
    .ADDR_W (32)
) u_axil_chk (
    .clk       (clk),
    .rst_n     (rst_n),
    // CPU data-master -> crossbar port m0
    .awvalid   (dut.cpu_dmem_awvalid),
    .awready   (dut.cpu_dmem_awready),
    .awaddr    (dut.cpu_dmem_awaddr),
    .wvalid    (dut.cpu_dmem_wvalid),
    .wready    (dut.cpu_dmem_wready),
    .wdata     (dut.cpu_dmem_wdata),
    .wstrb     (dut.cpu_dmem_wstrb),
    .bvalid    (dut.cpu_dmem_bvalid),
    .bready    (dut.cpu_dmem_bready),
    .bresp     (dut.cpu_dmem_bresp),
    .arvalid   (dut.cpu_dmem_arvalid),
    .arready   (dut.cpu_dmem_arready),
    .araddr    (dut.cpu_dmem_araddr),
    .rvalid    (dut.cpu_dmem_rvalid),
    .rready    (dut.cpu_dmem_rready),
    .rdata     (dut.cpu_dmem_rdata),
    .rresp     (dut.cpu_dmem_rresp)
);

reset_checker u_rst_chk (
    .clk          (clk),
    .rst_n        (rst_n),
    .awvalid      (dut.cpu_dmem_awvalid),
    .arvalid      (dut.cpu_dmem_arvalid),
    .seceng_irq   (seceng_irq),
    .uart_tx      (uart_tx)
);

irq_checker u_irq_chk (
    .clk        (clk),
    .rst_n      (rst_n),
    .seceng_irq (seceng_irq)
);

`endif // IVERILOG

// ---------------------------------------------------------------------------
// Coverage model instantiation
// ---------------------------------------------------------------------------
`ifndef IVERILOG
soc_cov u_soc_cov (
    .clk          (clk),
    .rst_n        (rst_n),
    .aes_awvalid  (dut.xb_s2_awvalid),
    .aes_awaddr   (dut.xb_s2_awaddr),
    .aes_wdata    (dut.xb_s2_wdata),
    .gpio_dir     (gpio_dir),
    .seceng_irq   (seceng_irq),
    .trng_rct     (dut.trng_rct_fail),
    .trng_apt     (dut.trng_apt_fail),
    .pdf_irq      (dut.pdf_irq),
    .uart_irq     (dut.uart_irq),
    .rst_n_sync   (rst_n)
);
`endif

// ---------------------------------------------------------------------------
// BFM instantiations (informational monitors only — loopback path above)
// ---------------------------------------------------------------------------
uart_bfm #(
    .CLK_PERIOD_NS (CLK_PERIOD_NS),
    .BAUD          (115200)
) u_uart_bfm (
    .clk   (clk),
    .rst_n (rst_n),
    .tx    (),       // not driven; loopback uses uart_tx directly
    .rx    (uart_tx) // monitor DUT's TX output
);

spi_bfm u_spi_bfm (
    .sck   (spi_sck),
    .cs_n  (spi_cs_n),
    .mosi  (spi_mosi),
    .miso  (spi_miso)
);

i2c_bfm u_i2c_bfm (
    .sda (i2c_sda),
    .scl (i2c_scl)
);

// ---------------------------------------------------------------------------
// Initial banner
// ---------------------------------------------------------------------------
initial begin
    $display("========================================================");
    $display("[soc_tb] CRIYA / india_crypto_soc SoC testbench");
    $display("[soc_tb] Test    : %0s", test_name);
    $display("[soc_tb] Clk     : %0d ns period (100 MHz sim)", CLK_PERIOD_NS);
    $display("[soc_tb] Baud    : 115200  (%0d cycles/bit)", BAUD_CYCLES);
    $display("[soc_tb] Watchdog: %0d cycles", WATCHDOG_CYCLES);
    $display("========================================================");
end

endmodule
