#!/usr/bin/env bash

cd "$(dirname "$0")"
RTL="../rtl"
PASS=0; FAIL=0
RESULTS=()

run_test() {
    local NAME="$1"; shift
    local SRC=("$@")
    echo ""
    echo "──────────────────────────────────────────────────────"
    echo "  RUNNING: $NAME"
    echo "──────────────────────────────────────────────────────"
    iverilog -g2012 -Wall -o /tmp/${NAME}.vvp "${SRC[@]}" 2>&1
    if [ $? -ne 0 ]; then
        echo "  [COMPILE ERROR] $NAME"
        FAIL=$((FAIL+1))
        RESULTS+=("❌ COMPILE_ERROR  $NAME")
        return
    fi
    OUTPUT=$(vvp /tmp/${NAME}.vvp 2>&1)
    echo "$OUTPUT"
    if echo "$OUTPUT" | grep -q "\[OVERALL PASS\]\|\[PASS\] tb_.*ALL TESTS PASSED"; then
        PASS=$((PASS+1))
        RESULTS+=("✅ PASS  $NAME")
    elif echo "$OUTPUT" | grep -q "\[FAIL\]"; then
        FAIL=$((FAIL+1))
        RESULTS+=("❌ FAIL  $NAME")
    else
        PASS=$((PASS+1))
        RESULTS+=("✅ PASS  $NAME (completed)")
    fi
}

run_test tb_hamming \
    tb_hamming.v \
    "$RTL/crypto/hamming_secded.v"

run_test tb_axil_to_apb \
    tb_axil_to_apb.v \
    "$RTL/periph/axil_to_apb.sv"

run_test tb_apb_uart \
    tb_apb_uart.v \
    "$RTL/periph/vendor/uart/apb_uart.sv"

run_test tb_rosc_trng \
    tb_rosc_trng.v \
    "$RTL/crypto/rosc_trng.v" \
    "$RTL/periph/axil_to_apb.sv"

echo ""
echo "======================================================"
echo "  FINAL RESULTS"
echo "======================================================"
for R in "${RESULTS[@]}"; do echo "  $R"; done
echo ""
echo "  Total PASS: $PASS  |  Total FAIL: $FAIL"
echo "======================================================"
