###############################################################################
# synth_300mhz.tcl
# Synopsys Design Compiler — INDIA_CRYPTO_SOC @ 300 MHz
# Run from syn/scripts/: dc_shell -f synth_300mhz.tcl | tee synth_300mhz.log
###############################################################################

# ── 0. Setup ─────────────────────────────────────────────────────────────────
set DESIGN      india_crypto_soc
set SDC         ../constraints/india_crypto_soc_300mhz.sdc
set RTL_DIR     ../../rtl
set OUT_DIR     ../outputs/300mhz

file mkdir $OUT_DIR

# ── PDK Library Setup ─────────────────────────────────────────────────────────
# Adjust paths to match your server's PDK installation.
# TSMC 28nm HPC+ — typical corner (TT / 0.9V / 25°C) for compile;
# use SS / 0.81V / 125°C .db for final signoff timing checks.
set PDK_LIB_DIR /pdk/tsmc28nm/tcbn28hpcplusbwp30p140_190a/TSMCHOME/digital/Front_End/timing_power_noise/NLDM/tcbn28hpcplusbwp30p140_180a
set target_library [list ${PDK_LIB_DIR}/tcbn28hpcplusbwp30p140tt0p9v25c.db]
set link_library   [concat * $target_library]

# ── 1. Read all RTL files ─────────────────────────────────────────────────────
# All files use -format sverilog because the RTL uses SystemVerilog constructs
# (logic type, always_ff, always_comb, inline variable declarations).

# PULP vendor IP blackbox stubs — read first so wrappers can reference them
analyze -format sverilog $RTL_DIR/periph/vendor/pulp_blackbox.v

# Peripheral wrappers (AXI-Lite to APB bridges around PULP IP)
analyze -format sverilog [glob $RTL_DIR/periph/*.sv]

# CPU core and AES ISA extension
analyze -format sverilog [glob $RTL_DIR/core/*.v]

# Crypto blocks
analyze -format sverilog $RTL_DIR/crypto/aes_ca_accel.v
analyze -format sverilog $RTL_DIR/crypto/india_pdf_engine.v
analyze -format sverilog $RTL_DIR/crypto/rosc_trng.v

# Fabric (crossbar only — firewall removed)
analyze -format sverilog $RTL_DIR/fabric/axi_lite_xbar.v

# Top-level SoC
analyze -format sverilog $RTL_DIR/top/india_crypto_soc.v

elaborate $DESIGN

# ── 2. Link and check ─────────────────────────────────────────────────────────
current_design $DESIGN
link
check_design > $OUT_DIR/check_design.rpt

# ── 3. Apply constraints ──────────────────────────────────────────────────────
source $SDC

# ── 4. Compile — Phase 1 : Ungrouped, area-optimised baseline ────────────────
compile_ultra \
    -no_autoungroup \
    -retime

# ── 5. Compile — Phase 2 : Incremental timing-driven ─────────────────────────
# Second pass focuses on critical paths identified in Phase 1.
compile_ultra \
    -incremental \
    -retime \
    -timing_high_effort_script

# ── 6. Reports ────────────────────────────────────────────────────────────────
report_timing -delay max \
              -path_type full_clock_expanded \
              -nworst 10 \
              -significant_digits 3 \
              > $OUT_DIR/timing_setup.rpt

report_timing -delay min \
              -nworst 5 \
              > $OUT_DIR/timing_hold.rpt

report_area   -hierarchy > $OUT_DIR/area.rpt
report_power  -hierarchy > $OUT_DIR/power.rpt
report_qor                > $OUT_DIR/qor.rpt

# ── 7. Verify WNS / TNS ───────────────────────────────────────────────────────
set wns [get_attribute [get_timing_paths -delay max] slack]
if {$wns < 0} {
    puts "ERROR: Timing FAILED. WNS = ${wns} ns. Check timing_setup.rpt."
} else {
    puts "INFO: Timing PASSED. WNS = ${wns} ns at 300 MHz."
}

# ── 8. Write outputs ──────────────────────────────────────────────────────────
write -format verilog  -hierarchy -output $OUT_DIR/${DESIGN}_300mhz_netlist.v
write -format ddc                 -output $OUT_DIR/${DESIGN}_300mhz.ddc
write_sdc                                 $OUT_DIR/${DESIGN}_300mhz_final.sdc
write_sdf -version 3.0                    $OUT_DIR/${DESIGN}_300mhz.sdf

puts "Synthesis complete. Outputs in $OUT_DIR/"
