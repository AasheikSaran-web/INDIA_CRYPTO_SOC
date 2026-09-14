###############################################################################
# india_crypto_soc_hm.sdc
# Synopsys Design Constraints — INDIA_CRYPTO_SOC @ 300 MHz  (Hard-Macro Flow)
# Process  : TSMC 28nm HPC+
# Target   : 300 MHz @ 0.9V  |  T_period = 3.333 ns
# Corner   : SS / 125°C / 0.81V  (worst-case timing signoff corner)
#
# Hard macros covered:
#   u_sram_ctrl/u_sram/u_sram_macro  — ARM Artisan TS1N28HPCPSVTB16384X32M8SW
#
# Differences from the soft-macro SDC (syn/constraints/india_crypto_soc_300mhz.sdc)
#   • SRAM macro timing is handled via its own .lib / .db — no set_max_delay
#     advisory needed for the array itself
#   • set_multicycle_path on SRAM read path (2 cycles: addr presented cycle N,
#     data valid cycle N+1) — this relaxes setup on the sram_ctrl capture FFs
#   • set_dont_touch on the macro boundary means these paths are transparent
#     to DC optimisation; the STA tool reads macro timing from its .lib
###############################################################################

###############################################################################
# 1. PRIMARY CLOCK
###############################################################################
create_clock -name clk \
             -period 3.333 \
             -waveform {0 1.667} \
             [get_ports clk]

# Clock uncertainty (jitter + skew)
set_clock_uncertainty -setup 0.120 [get_clocks clk]
set_clock_uncertainty -hold  0.050 [get_clocks clk]

# Clock transition (CTS buffer output slew)
set_clock_transition 0.080 [get_clocks clk]

###############################################################################
# 2. CLOCK SOURCE LATENCY
###############################################################################
set_clock_latency -source 0.200 [get_clocks clk]

###############################################################################
# 3. INPUT DELAYS
###############################################################################
set_input_delay -clock clk -max 1.500 [get_ports {spi_mosi spi_sck spi_cs_n}]
set_input_delay -clock clk -min 0.200 [get_ports {spi_mosi spi_sck spi_cs_n}]

set_input_delay -clock clk -max 1.500 [get_ports uart_rx]
set_input_delay -clock clk -min 0.200 [get_ports uart_rx]

set_input_delay -clock clk -max 1.500 [get_ports i2c_sda]
set_input_delay -clock clk -min 0.200 [get_ports i2c_sda]

set_input_delay -clock clk -max 1.500 [get_ports rst_n]

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
set_driving_cell -lib_cell BUFFD4 \
                 -library tcbn28hpcplusbwp30p140tt0p9v25c \
                 [all_inputs]

set_load 0.050 [all_outputs]

###############################################################################
# 6. SRAM HARD-MACRO PATH CONSTRAINTS
#
# The ARM Artisan SRAM has a registered output (synchronous read):
#   Cycle 0 : sram_ctrl presents address + CEB to macro
#   Cycle 1 : macro Q valid — captured by sram_ctrl cpu_rdata / axi_rdata regs
#
# The 2-cycle read latency is intentional and matches sram_ctrl behaviour.
# We apply a multicycle setup = 2 on the path from the SRAM Q port to the
# capture registers inside sram_ctrl so the tool understands the Q data
# is not expected to meet a single-cycle setup.
#
# Note: DC will derive SRAM internal timing from its .lib; these constraints
# cover the RTL wrapper logic around the macro, not the macro itself.
###############################################################################

# SRAM read: address driven at cycle N, data captured at cycle N+1
# (matches the 2-cycle handshake in sram_ctrl)
set_multicycle_path -setup 2 \
    -from [get_cells u_sram_ctrl/u_sram/u_sram_macro] \
    -to   [get_cells u_sram_ctrl/cpu_rdata_reg*]

set_multicycle_path -hold 1 \
    -from [get_cells u_sram_ctrl/u_sram/u_sram_macro] \
    -to   [get_cells u_sram_ctrl/cpu_rdata_reg*]

set_multicycle_path -setup 2 \
    -from [get_cells u_sram_ctrl/u_sram/u_sram_macro] \
    -to   [get_cells u_sram_ctrl/axi_rdata_reg*]

set_multicycle_path -hold 1 \
    -from [get_cells u_sram_ctrl/u_sram/u_sram_macro] \
    -to   [get_cells u_sram_ctrl/axi_rdata_reg*]

###############################################################################
# 7. MULTICYCLE PATHS — Compute Blocks
###############################################################################

# ── RV32IM Iterative Multiplier (MUL/DIV/REM) ────────────────────────────────
set_multicycle_path -setup 32 \
    -from [get_cells u_cpu/mdu_acc_reg*] \
    -to   [get_cells u_cpu/mdu_result_reg*]

set_multicycle_path -hold 31 \
    -from [get_cells u_cpu/mdu_acc_reg*] \
    -to   [get_cells u_cpu/mdu_result_reg*]

# ── TRNG Accumulator ──────────────────────────────────────────────────────────
set_multicycle_path -setup 4 \
    -from [get_cells u_trng/accum_reg*] \
    -to   [get_cells u_trng/accum_word_reg*]

set_multicycle_path -hold 3 \
    -from [get_cells u_trng/accum_reg*] \
    -to   [get_cells u_trng/accum_word_reg*]

# ── AES-CA Key Schedule ───────────────────────────────────────────────────────
set_multicycle_path -setup 2 \
    -from [get_cells u_aes_ca/key_sched_reg*] \
    -to   [get_cells u_aes_ca/round_key_reg*]

set_multicycle_path -hold 1 \
    -from [get_cells u_aes_ca/key_sched_reg*] \
    -to   [get_cells u_aes_ca/round_key_reg*]

###############################################################################
# 8. FALSE PATHS
###############################################################################

# Asynchronous reset — recovery/removal checked separately
set_false_path -from [get_ports rst_n]

# TRNG external ring oscillator entropy source — async by design
set_false_path -from [get_ports rosc_ext] \
               -to   [get_cells u_trng/sync0_reg]

# UART RX is asynchronous — false path to first FF inside apb_uart
set_false_path -from [get_ports uart_rx]

# I2C SDA is asynchronous — false path into apb_i2c
set_false_path -from [get_ports i2c_sda]

###############################################################################
# 9. DONT-TOUCH — ASYNC_REG SYNCHRONIZER CHAINS
###############################################################################

# TRNG 4-stage synchronizer
set_dont_touch [get_cells u_trng/sync0_reg]
set_dont_touch [get_cells u_trng/sync1_reg]
set_dont_touch [get_cells u_trng/sync2_reg]
set_dont_touch [get_cells u_trng/sync3_reg]

###############################################################################
# 10. AES-CA CRITICAL PATH ADVISORY
###############################################################################

set_max_delay 2.400 \
    -datapath_only \
    -from [get_cells u_aes_ca/aes_state_reg*] \
    -to   [get_cells u_aes_ca/aes_state_reg*]

###############################################################################
# 11. OPERATING CONDITIONS + OCV
###############################################################################

# Worst-case signoff corner: SS / 125°C / 0.81V
# Uncomment and adjust library name to match your PDK:
# set_operating_conditions -library tcbn28hpcplusbwp30p140ss0p81v125c SS_0P81V_125C

# On-Chip Variation: 5% pessimism on data paths, 0% on clock
set_timing_derate -late  1.05 -cell_delay -data_path
set_timing_derate -early 0.95 -cell_delay -data_path

###############################################################################
# END OF SDC
###############################################################################
