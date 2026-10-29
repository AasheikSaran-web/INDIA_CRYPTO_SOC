`timescale 1ns/1ps
module criya_tb_top;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import criya_test_pkg::*;

  // Clock & reset
  logic clk, rst_n;
  initial clk = 0;
  always #5 clk = ~clk;  // 100 MHz sim clock

  // TRNG async source
  logic rosc_ext;
  initial rosc_ext = 0;
  always #7 rosc_ext = ~rosc_ext;

  // DUT interface signals
  logic uart_rx, uart_tx;
  wire  i2c_sda, i2c_scl;
  logic spi_mosi, spi_miso, spi_sck, spi_cs_n;
  logic [31:0] gpio_in, gpio_out, gpio_dir;
  logic seceng_irq;

  // Pull-ups for I2C open-drain
  pullup(i2c_sda);
  pullup(i2c_scl);

  // Default stimulus
  assign gpio_in  = 32'hDEAD_BEEF;
  assign spi_miso = 1'b0;

  // DUT instantiation
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

  // Virtual interfaces (passed to UVM via config_db)
  criya_axil_if  axil_if(.clk(clk), .rst_n(rst_n));
  criya_uart_if  uart_if(.clk(clk), .rst_n(rst_n));
  criya_spi_if   spi_if (.clk(clk), .rst_n(rst_n));

  // Connect UART interface to DUT
  assign uart_if.tx     = uart_tx;
  assign uart_rx        = uart_if.rx;
  assign spi_if.mosi    = spi_mosi;
  assign spi_if.sck     = spi_sck;
  assign spi_if.cs_n    = spi_cs_n;
  assign spi_miso       = spi_if.miso;

  initial begin
    // Register virtual interfaces
    uvm_config_db #(virtual criya_axil_if)::set(null, "uvm_test_top.*", "axil_vif", axil_if);
    uvm_config_db #(virtual criya_uart_if)::set(null, "uvm_test_top.*", "uart_vif", uart_if);
    uvm_config_db #(virtual criya_spi_if )::set(null, "uvm_test_top.*", "spi_vif",  spi_if);

    // Reset sequence
    rst_n = 0;
    repeat(20) @(posedge clk);
    rst_n = 1;

    // Run UVM test
    run_test();
  end

  // Timeout watchdog
  initial begin
    #50_000_000;
    `uvm_fatal("TIMEOUT", "Simulation exceeded 50ms — watchdog fired")
  end
endmodule
