

set DESIGN      india_crypto_soc
set SDC         ../constraints/india_crypto_soc_hm.sdc
set RTL_DIR     ../../../rtl
set OUT_DIR     ../outputs

file mkdir $OUT_DIR

set PDK_LIB_DIR /pdk/tsmc28nm/tcbn28hpcplusbwp30p140_190a/TSMCHOME/digital/Front_End/timing_power_noise/NLDM/tcbn28hpcplusbwp30p140_180a
set SC_DB       ${PDK_LIB_DIR}/tcbn28hpcplusbwp30p140tt0p9v25c.db

set SRAM_DB     ../pdk/TS1N28HPCPSVTB16384X32M8SW_tt0p9v25c.db

set target_library [list $SC_DB]
set link_library   [concat * $SC_DB $SRAM_DB]

analyze -format sverilog +define+HARD_MACRO \
    $RTL_DIR/periph/vendor/pulp_blackbox.v

analyze -format sverilog +define+HARD_MACRO \
    [glob $RTL_DIR/periph/*.sv]

analyze -format sverilog +define+HARD_MACRO \
    [glob $RTL_DIR/core/*.v]

analyze -format sverilog +define+HARD_MACRO \
    $RTL_DIR/mem/sram_sp_wrap.v
analyze -format sverilog +define+HARD_MACRO \
    $RTL_DIR/mem/sram_ctrl.v

analyze -format sverilog +define+HARD_MACRO \
    $RTL_DIR/crypto/aes_ca_accel.v
analyze -format sverilog +define+HARD_MACRO \
    $RTL_DIR/crypto/india_pdf_engine.v
analyze -format sverilog +define+HARD_MACRO \
    $RTL_DIR/crypto/rosc_trng.v

analyze -format sverilog +define+HARD_MACRO \
    $RTL_DIR/fabric/axi_lite_xbar.v

analyze -format sverilog +define+HARD_MACRO \
    $RTL_DIR/top/india_crypto_soc.v

elaborate $DESIGN

current_design $DESIGN
link
check_design > $OUT_DIR/check_design.rpt

set_dont_touch [get_cells -hierarchical u_sram_macro]

set_dont_touch [get_cells u_sram_ctrl/u_sram]

source $SDC

compile_ultra \
    -no_autoungroup \
    -retime

compile_ultra \
    -incremental \
    -retime \
    -timing_high_effort_script

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

set wns [get_attribute [get_timing_paths -delay max] slack]
if {$wns < 0} {
    puts "ERROR: Timing FAILED. WNS = ${wns} ns. Check timing_setup.rpt."
} else {
    puts "INFO: Timing PASSED. WNS = ${wns} ns at 300 MHz (hard-macro flow)."
}

write -format verilog  -hierarchy -output $OUT_DIR/${DESIGN}_hm_netlist.v
write -format ddc                 -output $OUT_DIR/${DESIGN}_hm.ddc
write_sdc                                 $OUT_DIR/${DESIGN}_hm_final.sdc
write_sdf -version 3.0                    $OUT_DIR/${DESIGN}_hm.sdf

puts "Hard-macro synthesis complete. Outputs in $OUT_DIR/"
