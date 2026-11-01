#!/usr/bin/env bash
# =============================================================================
# run_plic.sh  —  Compile and simulate tb_plic.sv against plic.v
# Requires: iverilog + vvp  (Icarus Verilog)
# Usage:    bash run_plic.sh [--waves]
# =============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
UNIT_DIR="${SCRIPT_DIR}"
RTL_DIR="${SCRIPT_DIR}/../../rtl/periph"

TB_TOP="tb_plic"
TB_SRC="${UNIT_DIR}/tb_plic.sv"
RTL_SRC="${RTL_DIR}/plic.v"
OUT="${UNIT_DIR}/${TB_TOP}.vvp"
VCD="${UNIT_DIR}/${TB_TOP}.vcd"

WAVES=0
for arg in "$@"; do
    [[ "$arg" == "--waves" ]] && WAVES=1
done

echo "============================================================"
echo "  Compiling ${TB_TOP}"
echo "  TB  : ${TB_SRC}"
echo "  RTL : ${RTL_SRC}"
echo "============================================================"

iverilog \
    -g2012 \
    -Wall \
    -o "${OUT}" \
    "${RTL_SRC}" \
    "${TB_SRC}"

echo "  Compilation OK -> ${OUT}"
echo ""
echo "  Simulating..."
echo "------------------------------------------------------------"

vvp "${OUT}"

echo "------------------------------------------------------------"
echo "  Simulation complete."

if [[ ${WAVES} -eq 1 ]]; then
    if command -v gtkwave &>/dev/null; then
        echo "  Opening waveform in GTKWave: ${VCD}"
        gtkwave "${VCD}" &
    else
        echo "  GTKWave not found.  Waveform saved to: ${VCD}"
    fi
fi
