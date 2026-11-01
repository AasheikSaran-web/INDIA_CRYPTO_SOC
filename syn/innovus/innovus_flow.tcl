# innovus_flow.tcl -- basic netlist-to-GDS flow (legacy Innovus command set)
# Run with:  innovus -files innovus_flow.tcl      (GUI)
#       or:  innovus -nowin -files innovus_flow.tcl  (batch)
# Edit every /path/to/..., cell name, layer name and net name for your PDK.

#--------------------------------------------------------------
# 1. Design import
#--------------------------------------------------------------
set init_verilog    ../outputs/1ghz/india_crypto_soc_1ghz_netlist.v
set init_top_cell   india_crypto_soc            ;# top module name in the netlist
set init_lef_file   [list /pdk/tsmc28nm/28HPC_plus_RF/APR_Tech/Cadence/tn28clpr002e1_1_9_1a/PRTF_EDI_28nm_Cad_V19_1a/PR_tech/Cadence/LefHeader/HVH/tsmcn28_10lm6X2Y1ZRDL.tlef /pdk/tsmc28nm/tcbn28hpcplusbwp30p140_190a/TSMCHOME/digital/Back_End/lef/tcbn28hpcplusbwp30p140_110a/lef/tcbn28hpcplusbwp30p140.lef]
set init_mmmc_file  mmmc.tcl
set init_pwr_net    VDD
set init_gnd_net    VSS

init_design
setExtractRCMode -engine postRoute -effortLevel low
setDesignMode -process 28             ;# your technology node in nm
setDesignMode -topRoutingLayer M10

#--------------------------------------------------------------
# 2. Floorplan
#--------------------------------------------------------------
# -r <aspect ratio> <core utilization> <left> <bottom> <right> <top margins>
floorPlan -site core -r 1.0 0.7 1000 1000 1000 1000

#--------------------------------------------------------------
# 3. Power planning
#--------------------------------------------------------------
globalNetConnect VDD -type pgpin -pin VDD -inst * -override
globalNetConnect VSS -type pgpin -pin VSS -inst * -override
globalNetConnect VDD -type tiehi
globalNetConnect VSS -type tielo

addRing -nets {VDD VSS} -type core_rings \
        -layer {top M9 bottom M9 left M10 right M10} \
        -width 2 -spacing 1 -offset 1

addStripe -nets {VDD VSS} -layer M10 -direction vertical \
          -width 2 -spacing 1 -set_to_set_distance 30 -start_from left

addStripe -nets {VDD VSS} -layer M9 -direction horizontal \
          -width 2 -spacing 1 -set_to_set_distance 30 -start_from bottom

#sroute -connect {corePin} -nets {VDD VSS}
sroute -connect {corePin} -nets {VDD VSS} \
       -layerChangeRange {M1(1) M10(10)} \
       -targetViaLayerRange {M1(1) M10(10)} \
       -allowLayerChange 1


#--------------------------------------------------------------
# 4. Placement (IO pins placed automatically)
#--------------------------------------------------------------
setPlaceMode -place_global_place_io_pins true
placeDesign
optDesign -preCTS
timeDesign -preCTS -outDir reports/preCTS

#--------------------------------------------------------------
# 5. Clock tree synthesis
#--------------------------------------------------------------
ccopt_design
optDesign -postCTS
optDesign -postCTS -hold
timeDesign -postCTS -outDir reports/postCTS

#--------------------------------------------------------------
# 6. Routing
#--------------------------------------------------------------
routeDesign
setAnalysisMode -analysisType onChipVariation
optDesign -postRoute
optDesign -postRoute -hold
timeDesign -postRoute -outDir reports/postRoute
timeDesign -postRoute -hold -outDir reports/postRoute

#--------------------------------------------------------------
# 7. Fillers and verification
#--------------------------------------------------------------
addFiller -cell {FILL1 FILL2 FILL4 FILL8} -prefix FILLER   ;# use your lib's filler names

verifyConnectivity -report reports/connectivity.rpt
verify_drc -report reports/drc.rpt
verifyProcessAntenna -report reports/antenna.rpt

#--------------------------------------------------------------
# 8. Reports and outputs
#--------------------------------------------------------------
report_timing > reports/timing.rpt
report_power  > reports/power.rpt
report_area   > reports/area.rpt

saveDesign  my_top_final.enc
saveNetlist outputs/my_top_pnr.v
write_sdf   outputs/my_top.sdf
rcOut -spef outputs/my_top.spef
streamOut outputs/my_top.gds -mapFile /path/to/streamOut.map \
          -libName DesignLib -units 2000 -mode ALL
