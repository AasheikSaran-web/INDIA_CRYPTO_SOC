#!/usr/bin/env bash
# =============================================================
# synth_blocks.sh  — Block-level Yosys synthesis
# Synthesizes each custom RTL block against Nangate45
# Usage: cd synth && bash synth_blocks.sh
# =============================================================

LIB="../pdk/nangate45/NangateOpenCellLibrary_typical.lib"
OUT="../synthesis/yosys"
mkdir -p "$OUT"

synth_block() {
    local TOP="$1"; shift
    local FILES=("$@")
    echo ""
    echo "======================================================"
    echo "  Synthesising: $TOP"
    echo "======================================================"

    local SCRIPT=$(mktemp /tmp/yosys_XXXXXX.ys)
    for f in "${FILES[@]}"; do
        echo "read_verilog -sv $f" >> "$SCRIPT"
    done
    cat >> "$SCRIPT" <<YS
hierarchy -check -top $TOP
synth -top $TOP
dfflibmap -liberty $LIB
abc -liberty $LIB
clean
tee -o $OUT/${TOP}_stat.txt stat -liberty $LIB
write_verilog -noattr -noexpr $OUT/${TOP}_netlist.v
YS

    # Run without -q so stat tee output works; send stderr to log
    yosys "$SCRIPT" > "$OUT/${TOP}.log" 2>&1
    local RC=$?
    rm -f "$SCRIPT"

    if [ $RC -eq 0 ] && [ -s "$OUT/${TOP}_stat.txt" ]; then
        echo "  PASS"
        grep -E "Number of cells|Number of DFF|Chip area" "$OUT/${TOP}_stat.txt" | sed 's/^/    /'
    else
        echo "  FAIL"
        grep "ERROR" "$OUT/${TOP}.log" 2>/dev/null | head -3 | sed 's/^/    /'
    fi
}

synth_block hamming_enc    "../rtl/crypto/hamming_secded.v"
synth_block hamming_dec    "../rtl/crypto/hamming_secded.v"
synth_block rosc_trng      "../rtl/crypto/rosc_trng.v"
synth_block aes_ca_accel   "../rtl/crypto/aes_ca_accel.v"
synth_block india_pdf_engine "../rtl/crypto/india_pdf_engine.v"
synth_block axi_firewall   "../rtl/fabric/axi_firewall.v"
synth_block axi_lite_xbar  "../rtl/fabric/axi_lite_xbar.v"
synth_block axil_to_apb    "../rtl/periph/axil_to_apb.sv"
synth_block pulp_spi_wrap  "pulp_blackbox.v" "../rtl/periph/axil_to_apb.sv" "../rtl/periph/pulp_spi_wrap.sv"
synth_block rv32im_core    "../rtl/core/rv32im_core.v"
synth_block aes_isa_ext    "../rtl/core/aes_isa_ext.v"

echo ""
echo "======================================================"
echo "  Combined Area Summary"
echo "======================================================"
{
printf "\n%-24s %8s %14s %8s\n" "Module" "Cells" "Area (um2)" "DFFs"
printf "%-24s %8s %14s %8s\n"  "------" "-----" "----------" "----"
for f in "$OUT"/*_stat.txt; do
    MOD=$(basename "$f" _stat.txt)
    CELLS=$(grep "Number of cells:" "$f" | awk '{print $NF}' | tail -1)
    AREA=$(grep "Chip area" "$f" | awk '{print $NF}' | tail -1)
    FFS=$(grep "Number of DFF" "$f" | awk '{print $NF}' | paste -sd+ | bc 2>/dev/null)
    [ -z "$CELLS" ] && CELLS="-"
    [ -z "$AREA"  ] && AREA="-"
    [ -z "$FFS"   ] && FFS="0"
    printf "%-24s %8s %14s %8s\n" "$MOD" "$CELLS" "$AREA" "$FFS"
done
} | tee "$OUT/area_summary.txt"
echo ""
echo "Results written to $OUT/"
