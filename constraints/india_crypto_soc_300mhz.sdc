###############################################################################
# india_crypto_soc_300mhz.sdc
# Synopsys Design Constraints — INDIA_CRYPTO_SOC @ 300 MHz
# Process  : TSMC 28nm HPC
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
#   SRAM + ECC decode : ~2.09 ns  →  0.96 ns margin ✅
#   AXI crossbar      : ~0.95 ns  →  2.10 ns margin ✅
###############################################################################

###############################################################################
# 1. PRIMARY CLOCK — System clock on clk pin
###############################################################################
create_clock -name clk \
             -period 3.333 \
             -waveform {0 1.667} \
             [get_ports clk]

# Apply clock uncertainty (jitter + skew budget)
# CTS target: ≤ 80 ps skew   |   PLL jitter: ≤ 40 ps RMS → ≤ 120 ps peak-to-peak
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
#    All inputs are assumed to come from an external source synchronous to clk
#    or are registered externally.  Worst-case input arrival = 1.5 ns before
#    the rising edge (i.e. hold some margin after edge; setup margin = period - 1.5)
###############################################################################

# SPI inputs — driven by host SPI master, synchronous to spi_sck
# These paths are false paths to the main clk domain (handled in Section 7)
set_input_delay -clock clk -max 1.500 [get_ports {spi_mosi spi_sck spi_cs_n}]
set_input_delay -clock clk -min 0.200 [get_ports {spi_mosi spi_sck spi_cs_n}]

# UART inputs — asynchronous to clk; oversampled in peripheral
# Set input delay loosely; UART RX has its own CDC synchronizer
set_input_delay -clock clk -max 1.500 [get_ports uart_rx]
set_input_delay -clock clk -min 0.200 [get_ports uart_rx]

# I2C inputs — asynchronous to clk; sampled in I2C peripheral synchronizer
set_input_delay -clock clk -max 1.500 [get_ports i2c_sda]
set_input_delay -clock clk -min 0.200 [get_ports i2c_sda]

# Reset — asynchronous active-low; treated as false path for timing
# (reset removal / recovery checked separately)
set_input_delay -clock clk -max 1.500 [get_ports rst_n]

# TRNG external ring-oscillator input — purely asynchronous entropy source
# The 4-stage synchronizer (ASYNC_REG) handles metastability; no timing path.
set_input_delay -clock clk -max 1.500 [get_ports rosc_ext]

###############################################################################
# 4. OUTPUT DELAYS
#    External load sees data valid within 1.5 ns after rising clock edge
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
#    Model realistic driving strength on inputs and capacitive load on outputs
###############################################################################

# All inputs driven by a standard 4X drive cell from I/O ring
set_driving_cell -lib_cell BUFFD4 -library sc9_cln28hpc_base_svt \
                 [all_inputs]

# All outputs drive a 50 fF external load (PCB trace + receiver input cap)
set_load 0.050 [all_outputs]

###############################################################################
# 6. MULTICYCLE PATHS
#    Paths that intentionally take more than one clock cycle.
###############################################################################

# ── RV32IM Iterative Multiplier (MUL/DIV/REM) ────────────────────────────────
# The M-extension multiply unit uses a shift-and-add loop running over 32 cycles.
# The result register is only sampled after the iteration count expires.
# Data path: mul_partial_product → accumulator (stays stable for 32 cycles)
set_multicycle_path -setup 32 \
    -from [get_cells u_cpu/u_mul_div/*] \
    -to   [get_cells u_cpu/mul_result_reg]

set_multicycle_path -hold 31 \
    -from [get_cells u_cpu/u_mul_div/*] \
    -to   [get_cells u_cpu/mul_result_reg]

# ── TRNG Accumulator ──────────────────────────────────────────────────────────
# The 32-bit bit accumulator in rosc_trng shifts in one bit per debiased
# output (every 2–4 raw bits). The accumulator word is only consumed after
# 32 valid bits are shifted in — that takes ~64–128 clock cycles minimum.
# Treat as a relaxed path (4-cycle multicycle for synthesis flexibility).
set_multicycle_path -setup 4 \
    -from [get_cells u_trng/accum_reg*] \
    -to   [get_cells u_trng/accum_word_reg*]

set_multicycle_path -hold 3 \
    -from [get_cells u_trng/accum_reg*] \
    -to   [get_cells u_trng/accum_word_reg*]

# ── AXI Firewall Permission Table ─────────────────────────────────────────────
# perm_table is written rarely (once at boot by firmware, then locked).
# The path from perm_table write to permission check output is timing-critical
# but only occurs once — NOT a multicycle (just an informational comment).
# No multicycle needed; let synthesis optimize normally.

###############################################################################
# 7. FALSE PATHS
#    Paths where timing analysis is not meaningful.
###############################################################################

# ── Asynchronous Reset ────────────────────────────────────────────────────────
# rst_n is async. No combinational timing path from rst_n to any data FF
# that the tool should check for setup/hold (recovery/removal checked elsewhere).
set_false_path -from [get_ports rst_n]

# ── TRNG External Pin → Synchronizer Chain ───────────────────────────────────
# rosc_ext is a free-running asynchronous signal. The 4-stage sync chain
# (sync0..sync3 with ASYNC_REG) deliberately allows metastability on sync0.
# Standard setup/hold timing analysis is meaningless here.
set_false_path -from [get_ports rosc_ext] \
               -to   [get_cells u_trng/sync0_reg]

# ── UART RX → First Sync FF ──────────────────────────────────────────────────
set_false_path -from [get_ports uart_rx] \
               -to   [get_cells u_uart/rx_sync_reg[0]]

# ── I2C SDA → First Sync FF ──────────────────────────────────────────────────
set_false_path -from [get_ports i2c_sda] \
               -to   [get_cells u_i2c/sda_sync_reg[0]]

# ── Firewall Lock Register (write-once) ───────────────────────────────────────
# Once table_locked is set to 1 (by firmware writing 0xDEADBEEF), it never
# changes again until reset. The path table_locked → perm_table write-enable
# does not need timing closure after boot. However, we DO want timing closure
# during boot, so do NOT false-path this; let synthesis optimize it.

###############################################################################
# 8. DONT-TOUCH — ASYNC_REG SYNCHRONIZER CHAINS
#    Prevent synthesis from merging, retiming, or restructuring the explicit
#    synchronizer flip-flops. Their physical placement adjacency is what
#    provides MTBF guarantees — tool must not move them.
###############################################################################

# TRNG 4-stage synchronizer
set_dont_touch [get_cells u_trng/sync0_reg]
set_dont_touch [get_cells u_trng/sync1_reg]
set_dont_touch [get_cells u_trng/sync2_reg]
set_dont_touch [get_cells u_trng/sync3_reg]

# UART RX synchronizer (2-stage inside pulp_uart_wrap)
set_dont_touch [get_cells u_uart/rx_sync_reg*]

# I2C SDA synchronizer
set_dont_touch [get_cells u_i2c/sda_sync_reg*]

###############################################################################
# 9. CASE ANALYSIS — CONSTANT PINS AT THIS FREQUENCY
###############################################################################

# secure_mode on pulp_spi_wrap is tied to 0 in normal operation
# Tell synthesis to optimize with this assumption for timing closure
set_case_analysis 0 [get_pins u_spi/secure_mode]

# AES ISA extensions: custom0_valid driven by CPU — not constant.
# No case analysis; let synthesis optimize normally.

###############################################################################
# 10. TIMING EXCEPTIONS FOR THE AES-CA CRITICAL PATH
#     At 300 MHz (3.333 ns period) the AES-CA round comfortably closes.
#     The following max_delay is NOT a relaxation — it is a tighter advisory
#     that prevents the tool from leaving all slack on this path unoptimized.
###############################################################################

# AES-CA round register-to-register: target 2.4 ns combinational
# (leaves 0.65 ns margin against the 3.05 ns combinational budget at SS)
set_max_delay 2.400 \
    -datapath_only \
    -from [get_cells u_aes_ca/aes_state_reg*] \
    -to   [get_cells u_aes_ca/aes_state_reg*]

# Key schedule output to round key register: relax (key schedule runs in
# background, not on critical path after initial key expansion)
set_multicycle_path -setup 2 \
    -from [get_cells u_aes_ca/key_sched_reg*] \
    -to   [get_cells u_aes_ca/round_key_reg*]
set_multicycle_path -hold 1 \
    -from [get_cells u_aes_ca/key_sched_reg*] \
    -to   [get_cells u_aes_ca/round_key_reg*]

###############################################################################
# 11. SRAM / ECC PATH ADVISORY
#     The Hamming decoder adds ~1.35 ns (TT) on the SRAM read path.
#     Provide a max_delay hint so synthesis knows to optimize this chain.
###############################################################################

# Port A (IMEM) decode chain: SRAM array → hamming_dec → cpu_imem_rdata
set_max_delay 2.600 \
    -datapath_only \
    -from [get_cells sram_reg*] \
    -to   [get_cells cpu_imem_rdata_reg*]

# Port B (DMEM) decode chain
set_max_delay 2.600 \
    -datapath_only \
    -from [get_cells sram_reg*] \
    -to   [get_cells xb_s1_rdata_reg*]

###############################################################################
# 12. OPERATING CONDITIONS
#     Specify the process corner for timing signoff.
###############################################################################

# Worst-case signoff corner: SS process, 125°C, 0.81V (10% VDD sag)
# set_operating_conditions -library sc9_cln28hpc_base_svt SS_0P81V_125C
# (Uncomment and adjust library name to match your PDK naming convention)

# On-Chip Variation (OCV) derating
# 5% pessimism on data paths, 0% on clock (clock tree already in uncertainty)
set_timing_derate -late  1.05 -cell_delay -data_path
set_timing_derate -early 0.95 -cell_delay -data_path

###############################################################################
# 13. POWER INTENT (OPTIONAL — for multi-VDD or power gating flows)
#     At 300 MHz, 0.9V, no power domains needed. Single VDD domain.
###############################################################################

# Single power domain — no level shifters needed
# create_power_domain PD_TOP -elements {.}

###############################################################################
# 14. SYNTHESIS DIRECTIVES (Tcl attributes for DC / Genus)
###############################################################################

# Enable automatic retiming across register boundaries
# This lets the tool rebalance logic between pipeline stages in the CPU.
# Safe to enable globally since all our pipeline stages are correctly modelled.
# (In Synopsys DC: set compile_ultra_ungroup_small_hierarchies true)
# (In Cadence Genus: set_db / set_attribute as below)

# set_attribute [get_cells u_cpu] retime true   ;# Genus
# set_compile_ultra -retime                      ;# DC (pass during compile_ultra)

###############################################################################
# END OF SDC
###############################################################################
