###############################################################################
# synth_300mhz.tcl
# Synopsys Design Compiler — INDIA_CRYPTO_SOC @ 300 MHz
# Run: dc_shell -f synth_300mhz.tcl | tee synth_300mhz.log
###############################################################################

# ── 0. Setup ─────────────────────────────────────────────────────────────────
set DESIGN      india_crypto_soc
set SDC         ../constraints/india_crypto_soc_300mhz.sdc
set RTL_DIR     ../rtl
set OUT_DIR     ../outputs/300mhz

file mkdir $OUT_DIR

# ── 1. Read all RTL files ─────────────────────────────────────────────────────
analyze -format sverilog [glob $RTL_DIR/periph/*.sv]
analyze -format verilog  [glob $RTL_DIR/core/*.v]
analyze -format verilog  [glob $RTL_DIR/crypto/*.v]
analyze -format verilog  [glob $RTL_DIR/fabric/*.v]
analyze -format verilog  $RTL_DIR/top/india_crypto_soc.v

elaborate $DESIGN

# ── 2. Link and check ─────────────────────────────────────────────────────────
current_design $DESIGN
check_design > $OUT_DIR/check_design.rpt

# ── 3. Apply constraints ──────────────────────────────────────────────────────
source $SDC

# ── 4. Compile — Phase 1 : Ungrouped, area-optimised baseline ────────────────
compile_ultra \
    -no_autoungroup \
    -retime                   ;# enable retiming across pipeline stage boundaries

# ── 5. Compile — Phase 2 : Incremental timing-driven ────────────────────────
# Runs a second pass focusing purely on critical paths identified in Phase 1.
# This is where the AES-CA round and SRAM+ECC paths get squeezed.
compile_ultra \
    -incremental \
    -retime \
    -timing_high_effort_script

# ── 6. Reports ───────────────────────────────────────────────────────────────
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

# ── 7. Verify WNS / TNS ──────────────────────────────────────────────────────
set wns [get_attribute [get_timing_paths -delay max] slack]
if {$wns < 0} {
    puts "ERROR: Timing FAILED. WNS = ${wns} ns. Check timing_setup.rpt."
} else {
    puts "INFO: Timing PASSED. WNS = ${wns} ns at 300 MHz."
}

# ── 8. Write outputs ─────────────────────────────────────────────────────────
write -format verilog  -hierarchy -output $OUT_DIR/${DESIGN}_300mhz_netlist.v
write -format ddc                 -output $OUT_DIR/${DESIGN}_300mhz.ddc
write_sdc                                 $OUT_DIR/${DESIGN}_300mhz_final.sdc
write_sdf -version 3.0                    $OUT_DIR/${DESIGN}_300mhz.sdf

puts "Synthesis complete. Outputs in $OUT_DIR/"
