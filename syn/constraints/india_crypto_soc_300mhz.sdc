

create_clock -name clk \
             -period 3.333 \
             -waveform {0 1.667} \
             [get_ports clk]

set_clock_uncertainty -setup 0.120 [get_clocks clk]
set_clock_uncertainty -hold  0.050 [get_clocks clk]

set_clock_transition 0.080 [get_clocks clk]

set_clock_latency -source 0.200 [get_clocks clk]

set_input_delay -clock clk -max 1.500 [get_ports {spi_mosi spi_sck spi_cs_n}]
set_input_delay -clock clk -min 0.200 [get_ports {spi_mosi spi_sck spi_cs_n}]

set_input_delay -clock clk -max 1.500 [get_ports uart_rx]
set_input_delay -clock clk -min 0.200 [get_ports uart_rx]

set_input_delay -clock clk -max 1.500 [get_ports i2c_sda]
set_input_delay -clock clk -min 0.200 [get_ports i2c_sda]

set_input_delay -clock clk -max 1.500 [get_ports rst_n]

set_input_delay -clock clk -max 1.500 [get_ports rosc_ext]

set_output_delay -clock clk -max 1.500 [get_ports {spi_miso spi_cs_n}]
set_output_delay -clock clk -min 0.200 [get_ports {spi_miso spi_cs_n}]

set_output_delay -clock clk -max 1.500 [get_ports uart_tx]
set_output_delay -clock clk -min 0.200 [get_ports uart_tx]

set_output_delay -clock clk -max 1.500 [get_ports i2c_sda]
set_output_delay -clock clk -min 0.200 [get_ports i2c_sda]

set_output_delay -clock clk -max 1.500 [get_ports seceng_irq]
set_output_delay -clock clk -min 0.200 [get_ports seceng_irq]

set_driving_cell -lib_cell BUFFD4 -library tcbn28hpcplusbwp30p140tt0p9v25c \
                 [all_inputs]

set_load 0.050 [all_outputs]

set_multicycle_path -setup 32 \
    -from [get_cells u_cpu/mdu_acc_reg*] \
    -to   [get_cells u_cpu/mdu_result_reg*]

set_multicycle_path -hold 31 \
    -from [get_cells u_cpu/mdu_acc_reg*] \
    -to   [get_cells u_cpu/mdu_result_reg*]

set_multicycle_path -setup 4 \
    -from [get_cells u_trng/accum_reg*] \
    -to   [get_cells u_trng/accum_word_reg*]

set_multicycle_path -hold 3 \
    -from [get_cells u_trng/accum_reg*] \
    -to   [get_cells u_trng/accum_word_reg*]

set_false_path -from [get_ports rst_n]

set_false_path -from [get_ports rosc_ext] \
               -to   [get_cells u_trng/sync0_reg]

set_false_path -from [get_ports uart_rx]

set_false_path -from [get_ports i2c_sda]

set_dont_touch [get_cells u_trng/sync0_reg]
set_dont_touch [get_cells u_trng/sync1_reg]
set_dont_touch [get_cells u_trng/sync2_reg]
set_dont_touch [get_cells u_trng/sync3_reg]

set_max_delay 2.400 \
    -datapath_only \
    -from [get_cells u_aes_ca/aes_state_reg*] \
    -to   [get_cells u_aes_ca/aes_state_reg*]

set_multicycle_path -setup 2 \
    -from [get_cells u_aes_ca/key_sched_reg*] \
    -to   [get_cells u_aes_ca/round_key_reg*]
set_multicycle_path -hold 1 \
    -from [get_cells u_aes_ca/key_sched_reg*] \
    -to   [get_cells u_aes_ca/round_key_reg*]

set_timing_derate -late  1.05 -cell_delay -data_path
set_timing_derate -early 0.95 -cell_delay -data_path

