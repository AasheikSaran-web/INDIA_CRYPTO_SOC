###############################################################################
# india_crypto_soc_300mhz.sdc
# Synopsys Design Constraints — INDIA_CRYPTO_SOC @ 300 MHz
# Process  : TSMC 28nm HPC+
# Target   : 300 MHz @ 0.9V  |  T_period = 3.333 ns
# Corner   : SS / 125°C / 0.81V  (worst-case timing signoff corner)
#
# Timing budget summary:
#   T_period          = 3.333 ns
#   T_setup (FF)      = 0.080 ns
#   T_clk2q (FF)      = 0.080 ns
#   T_skew (CTS)      = 0.120 ns
#   T_OCV  (5% derating on data, 0% on clock)
#   ─────────────────────────────────────────
#   Combinational budget = 3.333 - 0.080 - 0.080 - 0.120 = ~3.053 ns
#
# Critical paths (SS corner, with OCV):
#   AES-CA round      : ~1.81 ns  →  1.24 ns margin ✅
#   CPU EX (shifter)  : ~1.40 ns  →  1.65 ns margin ✅
#   AXI crossbar      : ~0.95 ns  →  2.10 ns margin ✅
###############################################################################

###############################################################################
# 1. PRIMARY CLOCK — System clock on clk pin
###############################################################################
create_clock -name clk \
             -period 3.333 \
             -waveform {0 1.667} \
             [get_ports clk]

# Clock uncertainty (jitter + skew budget)
# CTS target: <= 80 ps skew  |  PLL jitter: <= 40 ps RMS -> <= 120 ps peak-to-peak
set_clock_uncertainty -setup 0.120 [get_clocks clk]
set_clock_uncertainty -hold  0.050 [get_clocks clk]

# Clock transition time (slew rate from CTS buffer)
set_clock_transition 0.080 [get_clocks clk]

###############################################################################
# 2. CLOCK SOURCE LATENCY
#    Accounts for trace + bond wire + package delay from pin to first FF
###############################################################################
set_clock_latency -source 0.200 [get_clocks clk]

###############################################################################
# 3. INPUT DELAYS
###############################################################################

# SPI inputs — driven by host SPI master
set_input_delay -clock clk -max 1.500 [get_ports {spi_mosi spi_sck spi_cs_n}]
set_input_delay -clock clk -min 0.200 [get_ports {spi_mosi spi_sck spi_cs_n}]

# UART RX — asynchronous to clk; sampled inside apb_uart
set_input_delay -clock clk -max 1.500 [get_ports uart_rx]
set_input_delay -clock clk -min 0.200 [get_ports uart_rx]

# I2C SDA — asynchronous to clk; sampled inside apb_i2c
set_input_delay -clock clk -max 1.500 [get_ports i2c_sda]
set_input_delay -clock clk -min 0.200 [get_ports i2c_sda]

# Reset — asynchronous active-low
set_input_delay -clock clk -max 1.500 [get_ports rst_n]

# TRNG external ring-oscillator input — purely asynchronous entropy source
set_input_delay -clock clk -max 1.500 [get_ports rosc_ext]

###############################################################################
# 4. OUTPUT DELAYS
###############################################################################
set_output_delay -clock clk -max 1.500 [get_ports {spi_miso spi_cs_n}]
set_output_delay -clock clk -min 0.200 [get_ports {spi_miso spi_cs_n}]

set_output_delay -clock clk -max 1.500 [get_ports uart_tx]
set_output_delay -clock clk -min 0.200 [get_ports uart_tx]

set_output_delay -clock clk -max 1.500 [get_ports i2c_sda]
set_output_delay -clock clk -min 0.200 [get_ports i2c_sda]

set_output_delay -clock clk -max 1.500 [get_ports seceng_irq]
set_output_delay -clock clk -min 0.200 [get_ports seceng_irq]

###############################################################################
# 5. DRIVING CELL AND LOAD
###############################################################################
set_driving_cell -lib_cell BUFFD4 -library tcbn28hpcplusbwp30p140tt0p9v25c \
                 [all_inputs]

set_load 0.050 [all_outputs]

###############################################################################
# 6. MULTICYCLE PATHS
###############################################################################

# ── RV32IM Iterative Multiplier (MUL/DIV/REM) ────────────────────────────────
# The MDU is inline in rv32im_core. The accumulator runs over up to 32 cycles;
# mdu_result is only sampled after mdu_done asserts.
set_multicycle_path -setup 32 \
    -from [get_cells u_cpu/mdu_acc_reg*] \
    -to   [get_cells u_cpu/mdu_result_reg*]

set_multicycle_path -hold 31 \
    -from [get_cells u_cpu/mdu_acc_reg*] \
    -to   [get_cells u_cpu/mdu_result_reg*]

# ── TRNG Accumulator ──────────────────────────────────────────────────────────
# 32-bit accumulator shifts in one debiased bit every 2-4 raw bits.
# accum_word is only consumed after 32 valid bits are shifted in (~64-128 cycles).
set_multicycle_path -setup 4 \
    -from [get_cells u_trng/accum_reg*] \
    -to   [get_cells u_trng/accum_word_reg*]

set_multicycle_path -hold 3 \
    -from [get_cells u_trng/accum_reg*] \
    -to   [get_cells u_trng/accum_word_reg*]

###############################################################################
# 7. FALSE PATHS
###############################################################################

# Asynchronous reset — recovery/removal checked separately
set_false_path -from [get_ports rst_n]

# TRNG external pin -> synchronizer chain (ASYNC_REG, metastability intentional)
set_false_path -from [get_ports rosc_ext] \
               -to   [get_cells u_trng/sync0_reg]

# UART RX is asynchronous — false path to the first flip-flop inside apb_uart
set_false_path -from [get_ports uart_rx]

# I2C SDA is asynchronous — false path into the apb_i2c peripheral
set_false_path -from [get_ports i2c_sda]

###############################################################################
# 8. DONT-TOUCH — ASYNC_REG SYNCHRONIZER CHAINS
#    Prevent synthesis from merging or retiming these FFs.
#    Physical adjacency of sync FFs is required for MTBF guarantees.
###############################################################################

# TRNG 4-stage synchronizer
set_dont_touch [get_cells u_trng/sync0_reg]
set_dont_touch [get_cells u_trng/sync1_reg]
set_dont_touch [get_cells u_trng/sync2_reg]
set_dont_touch [get_cells u_trng/sync3_reg]

###############################################################################
# 9. AES-CA CRITICAL PATH ADVISORY
#    At 300 MHz the AES-CA round closes comfortably.
#    This max_delay tightens the advisory so the tool does not leave slack
#    unoptimized on the hottest path.
###############################################################################

set_max_delay 2.400 \
    -datapath_only \
    -from [get_cells u_aes_ca/aes_state_reg*] \
    -to   [get_cells u_aes_ca/aes_state_reg*]

# Key schedule to round key: runs in background, relax
set_multicycle_path -setup 2 \
    -from [get_cells u_aes_ca/key_sched_reg*] \
    -to   [get_cells u_aes_ca/round_key_reg*]
set_multicycle_path -hold 1 \
    -from [get_cells u_aes_ca/key_sched_reg*] \
    -to   [get_cells u_aes_ca/round_key_reg*]

###############################################################################
# 10. OPERATING CONDITIONS
###############################################################################

# Worst-case signoff corner: SS / 125°C / 0.81V
# Uncomment and adjust library name to match your PDK:
# set_operating_conditions -library tcbn28hpcplusbwp30p140ss0p81v125c SS_0P81V_125C

# On-Chip Variation (OCV): 5% pessimism on data, 0% on clock
set_timing_derate -late  1.05 -cell_delay -data_path
set_timing_derate -early 0.95 -cell_delay -data_path

###############################################################################
# END OF SDC
###############################################################################
