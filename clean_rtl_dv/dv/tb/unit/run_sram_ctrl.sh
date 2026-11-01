#!/usr/bin/env bash
# =============================================================================
# run_sram_ctrl.sh
# Compile and simulate tb_sram_ctrl.sv against sram_ctrl.v + sram_sp_wrap.v
# Run from:  dv/tb/unit/
# =============================================================================
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RTL_WRAP="$SCRIPT_DIR/../../rtl/mem/sram_sp_wrap.v"
RTL_CTRL="$SCRIPT_DIR/../../rtl/mem/sram_ctrl.v"
TB="$SCRIPT_DIR/tb_sram_ctrl.sv"
OUT="$SCRIPT_DIR/tb_sram_ctrl.vvp"

echo "=== Compiling sram_ctrl testbench ==="
iverilog -g2012 \
    "$RTL_WRAP" \
    "$RTL_CTRL" \
    "$TB" \
    -o "$OUT"

echo "=== Running simulation ==="
vvp "$OUT"

echo "=== Done ==="
