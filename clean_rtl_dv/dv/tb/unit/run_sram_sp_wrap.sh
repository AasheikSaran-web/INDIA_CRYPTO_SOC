#!/usr/bin/env bash
# =============================================================================
# run_sram_sp_wrap.sh
# Compile and simulate tb_sram_sp_wrap.sv against sram_sp_wrap.v
# Run from:  dv/tb/unit/
# =============================================================================
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RTL="$SCRIPT_DIR/../../rtl/mem/sram_sp_wrap.v"
TB="$SCRIPT_DIR/tb_sram_sp_wrap.sv"
OUT="$SCRIPT_DIR/tb_sram_sp_wrap.vvp"

echo "=== Compiling sram_sp_wrap testbench ==="
iverilog -g2012 \
    "$RTL" \
    "$TB" \
    -o "$OUT"

echo "=== Running simulation ==="
vvp "$OUT"

echo "=== Done ==="
