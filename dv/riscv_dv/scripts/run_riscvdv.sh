#!/usr/bin/env bash
# Run chipsalliance/riscv-dv random instruction generator for CRIYA
set -euo pipefail

RISCV_DV=${RISCV_DV_PATH:-$(which run.py 2>/dev/null || echo "")}
CFG=cfg/criya_rv32im.yaml
OUT=riscv_dv_out
TESTS=${1:-10}  # number of tests, override with first arg

if [[ -z "$RISCV_DV" ]]; then
  echo "[ERROR] riscv-dv not found. Install: git clone https://github.com/chipsalliance/riscv-dv && pip install -r requirements.txt"
  exit 1
fi

mkdir -p $OUT/sim $OUT/asm_test

echo "[RISCV-DV] Generating $TESTS random RV32IM tests..."
python3 $RISCV_DV \
  --test riscv_arithmetic_basic_test,riscv_rand_instr_test,riscv_load_store_rand_test \
  --simulator vcs \
  --isa rv32im \
  --mabi ilp32 \
  --num_tests $TESTS \
  --steps gen,gcc_compile,iss_sim \
  --output $OUT \
  --custom_target $(pwd)/.. \
  --so_args "+incdir+../tb ../tb/soc_tb.sv" \
  2>&1 | tee $OUT/riscvdv_run.log

# Run RTL sim for each generated hex
PASS=0; FAIL=0
for hexfile in $OUT/asm_test/*.hex; do
  testname=$(basename $hexfile .hex)
  mkdir -p ../../sim_out/riscvdv_$testname
  echo "[RUN] $testname"
  # VCS sim
  vcs -full64 -sverilog -timescale=1ns/1ps \
      +incdir+../../rtl \
      ../../rtl/top/india_crypto_soc.v \
      ../tb/soc_tb.sv \
      -o ../../sim_out/riscvdv_$testname/simv 2>/dev/null
  ../../sim_out/riscvdv_$testname/simv \
      +test=$testname +hexdir=$OUT/asm_test \
      2>&1 | tee ../../sim_out/riscvdv_$testname/sim.log
  if grep -q "TEST PASSED" ../../sim_out/riscvdv_$testname/sim.log; then
    PASS=$((PASS+1))
  else
    FAIL=$((FAIL+1))
  fi
done

echo ""
echo "===== RISCV-DV RESULTS ====="
echo "  PASS: $PASS"
echo "  FAIL: $FAIL"
echo "  TOTAL: $((PASS+FAIL))"
[[ $FAIL -eq 0 ]] && exit 0 || exit 1
