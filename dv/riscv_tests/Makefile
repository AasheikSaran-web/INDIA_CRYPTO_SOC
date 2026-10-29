# =============================================================================
# INDIA_CRYPTO_SOC — RISC-V Architecture Tests
# Runs official riscv-arch-test suite against the rv32im_core via simulation.
#
# Prerequisites:
#   make setup          # prints install instructions
#   make all            # compile + run rv32ui + rv32um tests
#   make rv32ui         # integer instruction tests only
#   make rv32um         # M-extension tests only
#   make check          # diff RTL commits against Spike golden log
# =============================================================================

# ---------------------------------------------------------------------------
# Configurable variables (override on command line as needed)
# ---------------------------------------------------------------------------
RISCV_GNU   ?= riscv32-unknown-elf
RISCV_TESTS ?= $(HOME)/riscv-arch-test
SIM         ?= $(shell command -v vcs 2>/dev/null && echo vcs || echo icarus)

# ---------------------------------------------------------------------------
# Toolchain aliases
# ---------------------------------------------------------------------------
CC      := $(RISCV_GNU)-gcc
OBJCOPY := $(RISCV_GNU)-objcopy
OBJDUMP := $(RISCV_GNU)-objdump

# ---------------------------------------------------------------------------
# Compile flags
# ---------------------------------------------------------------------------
ARCH    := rv32im
ABI     := ilp32
CFLAGS  := -march=$(ARCH) -mabi=$(ABI) -static -mcmodel=medany \
           -fvisibility=hidden -nostdlib -nostartfiles -T link.ld

# ---------------------------------------------------------------------------
# Simulation setup
# ---------------------------------------------------------------------------
RTL_ROOT  := ../../rtl
SIM_OUT   := sim_out
CORE_TB   := core_tb.v

ifeq ($(SIM),vcs)
  SIMFLAGS   := -full64 -sverilog -timescale=1ns/1ps +define+VCS
  INCDIRS    := $(addprefix +incdir+, \
                  $(RTL_ROOT)/core \
                  $(RTL_ROOT)/top \
                  $(RTL_ROOT)/mem \
                  $(RTL_ROOT)/periph)
  RTL_SRCS   := $(RTL_ROOT)/core/rv32im_core.v \
                $(RTL_ROOT)/mem/sram_ctrl.v \
                $(RTL_ROOT)/mem/sram_sp_wrap.v
  COMPILE_CMD = vcs $(SIMFLAGS) $(INCDIRS) +define+HEX_FILE=\"$(HEX)\" \
                    $(RTL_SRCS) $(CORE_TB) -o $(BIN_DIR)/simv \
                    -l $(BIN_DIR)/compile.log
  RUN_CMD     = $(BIN_DIR)/simv +commit_log=$(BIN_DIR)/commit.log \
                    -l $(BIN_DIR)/sim.log
else
  SIMFLAGS   := -g2012 -Wall -Wno-timescale
  INCDIRS    := $(addprefix -I , \
                  $(RTL_ROOT)/core \
                  $(RTL_ROOT)/top \
                  $(RTL_ROOT)/mem \
                  $(RTL_ROOT)/periph)
  RTL_SRCS   := $(RTL_ROOT)/core/rv32im_core.v \
                $(RTL_ROOT)/mem/sram_ctrl.v \
                $(RTL_ROOT)/mem/sram_sp_wrap.v
  COMPILE_CMD = iverilog $(SIMFLAGS) $(INCDIRS) -DHEX_FILE=\"$(HEX)\" \
                    $(RTL_SRCS) $(CORE_TB) -o $(BIN_DIR)/sim.vvp
  RUN_CMD     = vvp $(BIN_DIR)/sim.vvp +commit_log=$(BIN_DIR)/commit.log \
                    | tee $(BIN_DIR)/sim.log
endif

# ---------------------------------------------------------------------------
# Test discovery
# ---------------------------------------------------------------------------
RV32UI_TESTS := $(wildcard $(RISCV_TESTS)/riscv-test-suite/rv32i_m/I/src/*.S)
RV32UM_TESTS := $(wildcard $(RISCV_TESTS)/riscv-test-suite/rv32i_m/M/src/*.S)

RV32UI_NAMES := $(notdir $(basename $(RV32UI_TESTS)))
RV32UM_NAMES := $(notdir $(basename $(RV32UM_TESTS)))

# Reference signature directory (arch-test model output)
REF_DIR := $(RISCV_TESTS)/riscv-test-suite/rv32i_m

# ---------------------------------------------------------------------------
# Phony targets
# ---------------------------------------------------------------------------
.PHONY: all rv32ui rv32um check setup clean

all: rv32ui rv32um
	@echo ""
	@echo "All RISC-V arch tests complete. Run 'make check' to compare against Spike."

# ---------------------------------------------------------------------------
# rv32ui — RV32 integer instruction tests
# ---------------------------------------------------------------------------
rv32ui:
	@echo "=== Running rv32ui tests ($(words $(RV32UI_NAMES)) tests found) ==="
	@[ -n "$(RV32UI_TESTS)" ] || { echo "ERROR: no rv32ui tests found under $(RISCV_TESTS)"; exit 1; }
	@pass=0; fail=0; \
	for test in $(RV32UI_NAMES); do \
	    $(MAKE) --no-print-directory _run_test \
	        TESTNAME=$$test \
	        TESTSRC=$(RISCV_TESTS)/riscv-test-suite/rv32i_m/I/src/$$test.S \
	        SUITE=I && pass=$$((pass+1)) || fail=$$((fail+1)); \
	done; \
	echo "rv32ui: $$pass passed, $$fail failed"

# ---------------------------------------------------------------------------
# rv32um — RV32 M-extension (multiply/divide) tests
# ---------------------------------------------------------------------------
rv32um:
	@echo "=== Running rv32um tests ($(words $(RV32UM_NAMES)) tests found) ==="
	@[ -n "$(RV32UM_TESTS)" ] || { echo "ERROR: no rv32um tests found under $(RISCV_TESTS)"; exit 1; }
	@pass=0; fail=0; \
	for test in $(RV32UM_NAMES); do \
	    $(MAKE) --no-print-directory _run_test \
	        TESTNAME=$$test \
	        TESTSRC=$(RISCV_TESTS)/riscv-test-suite/rv32i_m/M/src/$$test.S \
	        SUITE=M && pass=$$((pass+1)) || fail=$$((fail+1)); \
	done; \
	echo "rv32um: $$pass passed, $$fail failed"

# ---------------------------------------------------------------------------
# Internal rule: compile one test and run it
# TESTNAME, TESTSRC, SUITE must be set by the caller.
# ---------------------------------------------------------------------------
BIN_DIR = $(SIM_OUT)/$(SUITE)/$(TESTNAME)
ELF     = $(BIN_DIR)/$(TESTNAME).elf
HEX     = $(BIN_DIR)/$(TESTNAME).hex

.PHONY: _run_test
_run_test: | $(BIN_DIR)
	@printf "  [BUILD] %-30s" "$(TESTNAME)"
	@$(CC) $(CFLAGS) \
	    -I$(RISCV_TESTS)/riscv-test-suite/env \
	    -I$(RISCV_TESTS)/riscv-test-suite/rv32i_m/$(SUITE) \
	    $(TESTSRC) -o $(ELF) 2>$(BIN_DIR)/build.log || \
	    { echo " FAIL (build)"; cat $(BIN_DIR)/build.log; exit 1; }
	@$(OBJCOPY) -O verilog $(ELF) $(HEX)
	@$(OBJDUMP) -d $(ELF) > $(BIN_DIR)/$(TESTNAME).dis
	@printf " built\n"
	@printf "  [SIM]   %-30s" "$(TESTNAME)"
	@$(COMPILE_CMD) 2>>$(BIN_DIR)/compile.log || \
	    { echo " FAIL (compile sim)"; exit 1; }
	@$(RUN_CMD) 2>&1 | tee -a $(BIN_DIR)/sim.log >/dev/null
	@if grep -q "TEST_PASS\|PASS\b" $(BIN_DIR)/sim.log 2>/dev/null; then \
	    printf " \033[0;32mPASS\033[0m\n"; \
	else \
	    printf " \033[0;31mFAIL\033[0m (see $(BIN_DIR)/sim.log)\n"; exit 1; \
	fi

# ---------------------------------------------------------------------------
# check — compare RTL commit log against Spike golden output
# Runs spike on every ELF found in sim_out/, diffs commit logs.
# ---------------------------------------------------------------------------
check:
	@echo "=== Checking RTL output against Spike ISS ==="
	@command -v spike >/dev/null 2>&1 || \
	    { echo "ERROR: spike not found in PATH. Run 'make setup' for install instructions."; exit 1; }
	@total=0; match=0; \
	for elf in $$(find $(SIM_OUT) -name "*.elf"); do \
	    total=$$((total+1)); \
	    dir=$$(dirname $$elf); \
	    name=$$(basename $$elf .elf); \
	    spike --isa=rv32im -l --log-commits $$elf 2>$$dir/spike_commits.log; \
	    if [ -f $$dir/commit.log ]; then \
	        if diff -q $$dir/spike_commits.log $$dir/commit.log >/dev/null 2>&1; then \
	            match=$$((match+1)); \
	        else \
	            echo "\033[0;31mDIVERGE\033[0m $$name"; \
	            diff $$dir/spike_commits.log $$dir/commit.log | head -20; \
	        fi; \
	    else \
	        echo "  SKIP $$name — no commit.log from RTL sim"; \
	    fi; \
	done; \
	echo "Spike check: $$match/$$total matched"

# ---------------------------------------------------------------------------
# Linker script (generated once if missing)
# Places code at 0x0000_0000, data follows, tohost/fromhost for htif.
# ---------------------------------------------------------------------------
link.ld:
	@echo "Generating default link.ld ..."
	@printf 'OUTPUT_ARCH(riscv)\nENTRY(_start)\nSECTIONS {\n' > link.ld
	@printf '  . = 0x00000000;\n  .text : { *(.text*) }\n' >> link.ld
	@printf '  .data : { *(.data*) }\n  .bss  : { *(.bss*)  }\n' >> link.ld
	@printf '  .tohost : { *(.tohost) }\n}\n' >> link.ld

# ---------------------------------------------------------------------------
# Output directory
# ---------------------------------------------------------------------------
$(SIM_OUT)/%:
	@mkdir -p $@

# ---------------------------------------------------------------------------
# setup — print toolchain install instructions
# ---------------------------------------------------------------------------
setup:
	@echo ""
	@echo "================================================================"
	@echo " RISC-V Arch Test Prerequisites"
	@echo "================================================================"
	@echo ""
	@echo " 1. riscv-gnu-toolchain (rv32im)"
	@echo "    git clone https://github.com/riscv-collab/riscv-gnu-toolchain"
	@echo "    cd riscv-gnu-toolchain"
	@echo "    ./configure --prefix=/opt/riscv32 --with-arch=rv32im --with-abi=ilp32"
	@echo "    make -j$(nproc)"
	@echo "    export PATH=\$$PATH:/opt/riscv32/bin"
	@echo ""
	@echo " 2. riscv-arch-test repo"
	@echo "    git clone https://github.com/riscv-non-isa/riscv-arch-test \$$HOME/riscv-arch-test"
	@echo "    # Or override: make RISCV_TESTS=/your/path all"
	@echo ""
	@echo " 3. Spike ISS (for 'make check')"
	@echo "    git clone https://github.com/riscv-software-src/riscv-isa-sim"
	@echo "    cd riscv-isa-sim && mkdir build && cd build"
	@echo "    ../configure --prefix=/opt/riscv32 --with-isa=rv32im"
	@echo "    make -j$(nproc) && make install"
	@echo ""
	@echo " Current config:"
	@echo "   RISCV_GNU   = $(RISCV_GNU)"
	@echo "   RISCV_TESTS = $(RISCV_TESTS)"
	@echo "   SIM         = $(SIM)"
	@echo "================================================================"
	@echo ""

# ---------------------------------------------------------------------------
# Clean
# ---------------------------------------------------------------------------
clean:
	rm -rf $(SIM_OUT) csrc simv* *.log link.ld
