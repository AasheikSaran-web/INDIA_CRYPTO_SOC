#!/usr/bin/env bash
# =============================================================================
# run_hamming.sh
# Compile and simulate the Hamming SEC-DED encoder+decoder testbench.
#
# Usage:
#   cd /Users/aasheiksaran/Desktop/Productivity/INDIA_CRYPTO_SOC/dv/tb/unit
#   bash run_hamming.sh
# =============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RTL="${SCRIPT_DIR}/../../../rtl/crypto/hamming_secded.v"
TB="${SCRIPT_DIR}/tb_hamming_secded.sv"
OUT="${SCRIPT_DIR}/tb_hamming_secded.vvp"

echo "=== Compiling hamming_secded ==="
iverilog -g2012 \
    -o "${OUT}" \
    "${RTL}" \
    "${TB}"

echo "=== Running simulation ==="
vvp "${OUT}"
