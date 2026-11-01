#!/usr/bin/env bash
# run_verhoeff.sh — compile and run tb_verhoeff_check
set -e
cd "$(dirname "$0")"

RTL=../../../rtl/crypto/verhoeff_check.v
TB=tb_verhoeff_check.sv
OUT=sim_verhoeff

echo "=== Compiling verhoeff_check ==="
iverilog -g2012 -o "$OUT" "$RTL" "$TB"

echo "=== Running simulation ==="
vvp "$OUT" | tee run_verhoeff.log

echo ""
if grep -q "RESULT: 50/50 passed" run_verhoeff.log; then
    echo "PASS — all 50/50 test cases passed"
    exit 0
else
    RESULT=$(grep "^RESULT:" run_verhoeff.log || echo "RESULT: 0/50 passed")
    echo "FAIL — $RESULT"
    exit 1
fi
