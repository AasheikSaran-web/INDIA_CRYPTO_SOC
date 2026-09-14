

set DESIGN      india_crypto_soc
set SDC         ../constraints/india_crypto_soc_300mhz.sdc
set RTL_DIR     ../../rtl
set OUT_DIR     ../outputs/300mhz

file mkdir $OUT_DIR

set PDK_LIB_DIR /pdk/tsmc28nm/tcbn28hpcplusbwp30p140_190a/TSMCHOME/digital/Front_End/timing_power_noise/NLDM/tcbn28hpcplusbwp30p140_180a
set target_library [list ${PDK_LIB_DIR}/tcbn28hpcplusbwp30p140tt0p9v25c.db]
set link_library   [concat * $target_library]

analyze -format sverilog $RTL_DIR/periph/vendor/pulp_blackbox.v

analyze -format sverilog [glob $RTL_DIR/periph/*.sv]

analyze -format sverilog [glob $RTL_DIR/core/*.v]

analyze -format sverilog $RTL_DIR/mem/sram_sp_wrap.v
analyze -format sverilog $RTL_DIR/mem/sram_ctrl.v

analyze -format sverilog $RTL_DIR/crypto/aes_ca_accel.v
analyze -format sverilog $RTL_DIR/crypto/india_pdf_engine.v
analyze -format sverilog $RTL_DIR/crypto/rosc_trng.v

analyze -format sverilog $RTL_DIR/fabric/axi_lite_xbar.v

analyze -format sverilog $RTL_DIR/top/india_crypto_soc.v

elaborate $DESIGN

current_design $DESIGN
link
check_design > $OUT_DIR/check_design.rpt

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
    puts "INFO: Timing PASSED. WNS = ${wns} ns at 300 MHz."
}

write -format verilog  -hierarchy -output $OUT_DIR/${DESIGN}_300mhz_netlist.v
write -format ddc                 -output $OUT_DIR/${DESIGN}_300mhz.ddc
write_sdc                                 $OUT_DIR/${DESIGN}_300mhz_final.sdc
write_sdf -version 3.0                    $OUT_DIR/${DESIGN}_300mhz.sdf

puts "Synthesis complete. Outputs in $OUT_DIR/"
