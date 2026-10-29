#!/usr/bin/env bash
# =============================================================================
# run_compare.sh — Compare RTL simulation commit log against Spike ISS
#
# Usage:
#   ./run_compare.sh <elf_binary>
#
# The script:
#   1. Runs the ELF through Spike (rv32im) and captures the commit log.
#   2. Compiles and runs the same ELF through the RTL simulation (VCS or
#      Icarus), capturing a commit log from core_tb.v's +commit_log output.
#   3. Normalises both logs to a common format (one "pc=0x... rd=x... val=..."
#      line per committed instruction).
#   4. Diffs them line by line and reports PASS or the first divergence point.
#
# Requirements:
#   spike        — riscv-isa-sim with --isa=rv32im
#   vcs or iverilog
#   riscv32-unknown-elf-gcc / objcopy (for hex conversion)
# =============================================================================

set -euo pipefail

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RESET='\033[0m'

info()  { printf "${YELLOW}[INFO]${RESET}  %s\n" "$*"; }
pass()  { printf "${GREEN}[PASS]${RESET}  %s\n" "$*"; }
fail()  { printf "${RED}[FAIL]${RESET}  %s\n" "$*"; }
fatal() { printf "${RED}[ERROR]${RESET} %s\n" "$*" >&2; exit 1; }

# ---------------------------------------------------------------------------
# Usage check
# ---------------------------------------------------------------------------
if [[ $# -lt 1 ]]; then
    echo ""
    echo "  Usage: $0 <compiled-riscv-elf>"
    echo ""
    echo "  Description:"
    echo "    Runs the given RISC-V ELF binary through Spike (rv32im ISS) and"
    echo "    through the RTL simulation, then compares their register-commit"
    echo "    logs line by line."
    echo ""
    echo "  Examples:"
    echo "    $0 sim_out/I/add/add.elf"
    echo "    $0 /path/to/dhrystone.elf"
    echo ""
    echo "  Environment overrides:"
    echo "    RISCV_GNU=riscv32-unknown-elf   (toolchain prefix)"
    echo "    RTL_ROOT=../../rtl              (path to RTL sources)"
    echo "    SIM=vcs|icarus                  (force simulator choice)"
    echo ""
    exit 1
fi

ELF="$1"
[[ -f "$ELF" ]] || fatal "ELF not found: $ELF"

# ---------------------------------------------------------------------------
# Configuration
# ---------------------------------------------------------------------------
RISCV_GNU="${RISCV_GNU:-riscv32-unknown-elf}"
OBJCOPY="${RISCV_GNU}-objcopy"
RTL_ROOT="${RTL_ROOT:-../../rtl}"
WORK_DIR="$(dirname "$ELF")/spike_cmp"
mkdir -p "$WORK_DIR"

TESTNAME="$(basename "$ELF" .elf)"
HEX="$WORK_DIR/$TESTNAME.hex"
SPIKE_RAW="$WORK_DIR/spike_raw.log"
SPIKE_NORM="$WORK_DIR/spike_norm.log"
RTL_COMMIT="$WORK_DIR/rtl_commit.log"
RTL_NORM="$WORK_DIR/rtl_norm.log"
DIFF_OUT="$WORK_DIR/divergence.diff"

# ---------------------------------------------------------------------------
# Tool detection
# ---------------------------------------------------------------------------
if [[ "${SIM:-}" == "vcs" ]] || command -v vcs &>/dev/null; then
    SIM=vcs
elif command -v iverilog &>/dev/null; then
    SIM=icarus
else
    fatal "Neither 'vcs' nor 'iverilog' found in PATH."
fi

command -v spike &>/dev/null || fatal "'spike' not found in PATH. See dv/riscv_tests/Makefile 'make setup' for install instructions."

info "ELF      : $ELF"
info "Simulator: $SIM"
info "Work dir : $WORK_DIR"

# ---------------------------------------------------------------------------
# Step 1: Convert ELF to hex
# ---------------------------------------------------------------------------
info "Converting ELF to Verilog hex ..."
"$OBJCOPY" -O verilog "$ELF" "$HEX"

# ---------------------------------------------------------------------------
# Step 2: Run Spike — capture commit log
# ---------------------------------------------------------------------------
info "Running Spike (rv32im) ..."
spike --isa=rv32im -l --log-commits "$ELF" 2>"$SPIKE_RAW" || true

if [[ ! -s "$SPIKE_RAW" ]]; then
    fatal "Spike produced no output. Confirm spike supports --log-commits and --isa=rv32im."
fi

# Normalise Spike log:
# Spike --log-commits format (approx):
#   core   0: 0x00000000 (0x00000297) auipc   t0, 0x0
#   core   0: 3 0x00000000 (0x00000297) x5  0x00000000
# We emit: pc=0x<ADDR> rd=x<N> val=0x<VAL>
# Lines without a register writeback get only pc=...
python3 - "$SPIKE_RAW" "$SPIKE_NORM" <<'PYEOF'
import re, sys

in_path  = sys.argv[1]
out_path = sys.argv[2]

# Pattern for commit line with register write:
#   core   0: 3 0x00000000 (0x...) x5  0x00000000
commit_re  = re.compile(
    r'core\s+\d+:\s+\d+\s+(0x[0-9a-fA-F]+)\s+\(0x[0-9a-fA-F]+\)\s+(x\d+)\s+(0x[0-9a-fA-F]+)')
# Pattern for PC-only line (no register write):
pc_only_re = re.compile(
    r'core\s+\d+:\s+\d+\s+(0x[0-9a-fA-F]+)\s+\(0x[0-9a-fA-F]+\)')

with open(in_path) as fin, open(out_path, 'w') as fout:
    for line in fin:
        m = commit_re.search(line)
        if m:
            fout.write(f"pc={m.group(1)} rd={m.group(2)} val={m.group(3)}\n")
        else:
            m2 = pc_only_re.search(line)
            if m2:
                fout.write(f"pc={m2.group(1)}\n")
PYEOF

info "Spike commit log: $(wc -l < "$SPIKE_NORM") entries"

# ---------------------------------------------------------------------------
# Step 3: Run RTL simulation — capture commit log
# ---------------------------------------------------------------------------
info "Running RTL simulation ($SIM) ..."

TB_DIR="$(cd "$(dirname "$0")/../riscv_tests" && pwd)"
CORE_TB="$TB_DIR/core_tb.v"
[[ -f "$CORE_TB" ]] || fatal "core_tb.v not found at $TB_DIR/core_tb.v"

RTL_SRCS="$RTL_ROOT/core/rv32im_core.v $RTL_ROOT/mem/sram_ctrl.v $RTL_ROOT/mem/sram_sp_wrap.v"

if [[ "$SIM" == "vcs" ]]; then
    SIMV="$WORK_DIR/simv"
    vcs -full64 -sverilog -timescale=1ns/1ps +define+VCS \
        "+define+HEX_FILE=\"$HEX\"" \
        +incdir+"$RTL_ROOT/core" \
        +incdir+"$RTL_ROOT/mem" \
        +incdir+"$RTL_ROOT/top" \
        $RTL_SRCS "$CORE_TB" \
        -o "$SIMV" \
        -l "$WORK_DIR/compile.log" \
        2>&1 || fatal "VCS compile failed — see $WORK_DIR/compile.log"
    "$SIMV" "+commit_log=$RTL_COMMIT" -l "$WORK_DIR/rtl_sim.log" 2>&1 || true
else
    VVP="$WORK_DIR/sim.vvp"
    iverilog -g2012 -Wall -Wno-timescale \
        "-DHEX_FILE=\"$HEX\"" \
        -I "$RTL_ROOT/core" \
        -I "$RTL_ROOT/mem" \
        -I "$RTL_ROOT/top" \
        $RTL_SRCS "$CORE_TB" \
        -o "$VVP" \
        2>"$WORK_DIR/compile.log" || fatal "Icarus compile failed — see $WORK_DIR/compile.log"
    vvp "$VVP" "+commit_log=$RTL_COMMIT" | tee "$WORK_DIR/rtl_sim.log" >/dev/null || true
fi

if [[ ! -s "$RTL_COMMIT" ]]; then
    fatal "RTL simulation produced no commit log at $RTL_COMMIT"
fi

# ---------------------------------------------------------------------------
# Step 4: Normalise RTL commit log
# ---------------------------------------------------------------------------
# core_tb.v writes:  pc=0x<ADDR>  (pc-only for now)
# For exact rd/val comparison, extend core_tb with a proper commit monitor.
# For this script we compare pc sequences only when RTL log has no rd entries,
# and full pc+rd+val lines when they are present.

python3 - "$RTL_COMMIT" "$RTL_NORM" <<'PYEOF'
import re, sys

in_path  = sys.argv[1]
out_path = sys.argv[2]

full_re = re.compile(r'pc=(0x[0-9a-fA-F]+)\s+rd=(x\d+)\s+val=(0x[0-9a-fA-F]+)')
pc_re   = re.compile(r'pc=(0x[0-9a-fA-F]+)')

with open(in_path) as fin, open(out_path, 'w') as fout:
    for line in fin:
        m = full_re.search(line)
        if m:
            fout.write(f"pc={m.group(1)} rd={m.group(2)} val={m.group(3)}\n")
        else:
            m2 = pc_re.search(line)
            if m2:
                fout.write(f"pc={m2.group(1)}\n")
PYEOF

# If RTL log is pc-only, strip rd/val from Spike log too for a fair comparison
rtl_has_rd=$(grep -c "rd=" "$RTL_NORM" 2>/dev/null || echo 0)
if [[ "$rtl_has_rd" -eq 0 ]]; then
    info "RTL log is PC-only — stripping rd/val from Spike log for comparison"
    python3 -c "
import sys
for line in open('$SPIKE_NORM'):
    parts = line.split()
    if parts:
        print(parts[0])   # just pc=...
" > "${SPIKE_NORM}.pc_only"
    mv "${SPIKE_NORM}.pc_only" "$SPIKE_NORM"
    python3 -c "
for line in open('$RTL_NORM'):
    parts = line.split()
    if parts:
        print(parts[0])
" > "${RTL_NORM}.pc_only"
    mv "${RTL_NORM}.pc_only" "$RTL_NORM"
fi

info "RTL commit log:   $(wc -l < "$RTL_NORM") entries"

# ---------------------------------------------------------------------------
# Step 5: Diff and report
# ---------------------------------------------------------------------------
info "Comparing commit logs ..."

if diff "$SPIKE_NORM" "$RTL_NORM" > "$DIFF_OUT" 2>&1; then
    pass "All $(wc -l < "$SPIKE_NORM" | tr -d ' ') commits match — $TESTNAME"
    echo ""
    exit 0
else
    total_spike=$(wc -l < "$SPIKE_NORM" | tr -d ' ')
    total_rtl=$(wc -l < "$RTL_NORM"   | tr -d ' ')

    # Find first diverging line
    first_div=$(python3 - "$SPIKE_NORM" "$RTL_NORM" <<'PYEOF'
import sys
with open(sys.argv[1]) as fa, open(sys.argv[2]) as fb:
    for i, (a, b) in enumerate(zip(fa, fb), 1):
        if a.rstrip() != b.rstrip():
            print(f"Line {i}:")
            print(f"  Spike : {a.rstrip()}")
            print(f"  RTL   : {b.rstrip()}")
            break
    else:
        print(f"Logs diverge in length (Spike={i}, check RTL log)")
PYEOF
    )

    fail "$TESTNAME — commit log divergence"
    echo ""
    echo "  Spike entries : $total_spike"
    echo "  RTL   entries : $total_rtl"
    echo ""
    echo "  First divergence:"
    echo "$first_div" | sed 's/^/    /'
    echo ""
    echo "  Full diff: $DIFF_OUT"
    echo "  Spike log: $SPIKE_NORM"
    echo "  RTL log  : $RTL_NORM"
    echo ""
    exit 1
fi
