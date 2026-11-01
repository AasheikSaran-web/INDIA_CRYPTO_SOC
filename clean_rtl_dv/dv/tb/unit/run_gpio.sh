#!/usr/bin/env bash
# =============================================================================
# run_gpio.sh  –  Compile and simulate tb_gpio.sv against gpio.v (Icarus / VCS)
# =============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RTL_DIR="${SCRIPT_DIR}/../../rtl/periph"
TB="${SCRIPT_DIR}/tb_gpio.sv"
DUT="${RTL_DIR}/gpio.v"

echo "========================================"
echo " GPIO Unit Testbench"
echo "========================================"

# --------------------------------------------------------------------------
# Auto-detect simulator: prefer Icarus Verilog (iverilog), fall back to VCS
# --------------------------------------------------------------------------
if command -v iverilog &>/dev/null; then
    SIM="iverilog"
elif command -v vcs &>/dev/null; then
    SIM="vcs"
else
    echo "[ERROR] No supported simulator found (iverilog or vcs)."
    echo "        Install Icarus Verilog:  brew install icarus-verilog"
    exit 1
fi

echo "Using simulator: ${SIM}"
echo ""

# --------------------------------------------------------------------------
# Icarus Verilog flow
# --------------------------------------------------------------------------
if [ "${SIM}" = "iverilog" ]; then
    OUT="${SCRIPT_DIR}/tb_gpio.vvp"
    iverilog \
        -g2012 \
        -Wall \
        -o "${OUT}" \
        "${DUT}" \
        "${TB}"

    echo "Compilation OK – running simulation..."
    echo ""
    vvp "${OUT}"

# --------------------------------------------------------------------------
# VCS flow
# --------------------------------------------------------------------------
else
    VCS_OUT="${SCRIPT_DIR}/simv_gpio"
    vcs \
        -full64 \
        -sverilog \
        -timescale=1ns/1ps \
        +v2k \
        -o "${VCS_OUT}" \
        "${DUT}" \
        "${TB}"

    echo "Compilation OK – running simulation..."
    echo ""
    "${VCS_OUT}"
fi

echo ""
echo "Done."
