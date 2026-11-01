#!/usr/bin/env bash
# run_aadhaar_id.sh — compile and run tb_aadhaar_id_check
set -e
cd "$(dirname "$0")"

RTL=../../../rtl/crypto/aadhaar_id_check.v
TB=tb_aadhaar_id_check.sv
OUT=sim_aadhaar_id

echo "=== Compiling aadhaar_id_check ==="
iverilog -g2012 -o "$OUT" "$RTL" "$TB"

echo "=== Running simulation ==="
vvp "$OUT" | tee run_aadhaar_id.log

echo ""
if grep -q "RESULT: 50/50 passed" run_aadhaar_id.log; then
    echo "PASS — all 50/50 test cases passed"
    exit 0
else
    RESULT=$(grep "^RESULT:" run_aadhaar_id.log || echo "RESULT: 0/50 passed")
    echo "FAIL — $RESULT"
    exit 1
fi
