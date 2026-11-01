# mmmc.tcl -- Multi-Mode Multi-Corner setup for Innovus
# Replace the paths with files from your PDK / standard cell library.

# Timing libraries (.lib) for slow and fast corners
create_library_set -name libs_slow -timing [list /pdk/tsmc28nm/tcbn28hpcplusbwp30p140_190a/TSMCHOME/digital/Front_End/timing_power_noise/NLDM/tcbn28hpcplusbwp30p140_180a/tcbn28hpcplusbwp30p140ssg0p81v125c.lib]
create_library_set -name libs_fast -timing [list /pdk/tsmc28nm/tcbn28hpcplusbwp30p140_190a/TSMCHOME/digital/Front_End/timing_power_noise/NLDM/tcbn28hpcplusbwp30p140_180a/tcbn28hpcplusbwp30p140ffg0p99vm40c.lib]

# Parasitic extraction corners (captable or qrcTechFile from the PDK)
create_rc_corner -name rc_worst -T 125
create_rc_corner -name rc_best  -T -40

# Delay corners = library set + RC corner
create_delay_corner -name dc_slow -library_set libs_slow -rc_corner rc_worst
create_delay_corner -name dc_fast -library_set libs_fast -rc_corner rc_best

# Constraint mode = your SDC (clocks, IO delays, etc.)
create_constraint_mode -name func -sdc_files [list ../outputs/1ghz/india_crypto_soc_1ghz_final.sdc]

# Analysis views
create_analysis_view -name setup_view -constraint_mode func -delay_corner dc_slow
create_analysis_view -name hold_view  -constraint_mode func -delay_corner dc_fast

# Setup is checked at the slow corner, hold at the fast corner
set_analysis_view -setup [list setup_view] -hold [list hold_view]
