# =============================================================================
# INDIA_CRYPTO_SOC — DV Regression Makefile
# Target tool : VCS (primary, per 1-TOPS signoff checklist)
#               Icarus Verilog (fallback when vcs not in PATH)
# Usage:
#   make            # run all testbenches (alias: make regress)
#   make <tb_name>  # run a single testbench
#   make clean      # remove sim_out/
# =============================================================================

# ---------------------------------------------------------------------------
# Tool detection
# ---------------------------------------------------------------------------
VCS_BIN  := $(shell command -v vcs 2>/dev/null)
IVER_BIN := $(shell command -v iverilog 2>/dev/null)

ifdef VCS_BIN
  SIM       := vcs
  SIMFLAGS  := -full64 -sverilog -timescale=1ns/1ps +define+VCS
  SIMRUN    =  $(SIMOUT)/$(1)/simv -l $(SIMOUT)/$(1)/sim.log
  COMPILE   =  vcs $(SIMFLAGS) $(SV_INCDIRS) $(2) $(3) -o $(SIMOUT)/$(1)/simv \
                   -l $(SIMOUT)/$(1)/compile.log
else ifdef IVER_BIN
  SIM       := icarus
  SIMFLAGS  := -g2012 -Wall -Wno-timescale
  SIMRUN    =  vvp $(SIMOUT)/$(1)/sim.vvp -lxt2 | tee $(SIMOUT)/$(1)/sim.log
  COMPILE   =  iverilog $(SIMFLAGS) $(IVER_INCDIRS) $(2) $(3) \
                   -o $(SIMOUT)/$(1)/sim.vvp
else
  $(error "Neither vcs nor iverilog found in PATH. Install one to proceed.")
endif

# ---------------------------------------------------------------------------
# Paths
# ---------------------------------------------------------------------------
SIMOUT   := sim_out
RTL_ROOT := ../rtl

# Include dirs fed to VCS (+incdir+) and Icarus (-I)
RTL_INCDIRS := \
  $(RTL_ROOT)/top \
  $(RTL_ROOT)/core \
  $(RTL_ROOT)/crypto \
  $(RTL_ROOT)/fabric \
  $(RTL_ROOT)/mem \
  $(RTL_ROOT)/periph \
  $(RTL_ROOT)/periph/vendor \
  $(RTL_ROOT)/periph/vendor/include \
  $(RTL_ROOT)/periph/vendor/include/apb \
  $(RTL_ROOT)/periph/vendor/uart \
  $(RTL_ROOT)/periph/vendor/spi \
  $(RTL_ROOT)/periph/vendor/i2c

SV_INCDIRS   := $(addprefix +incdir+,$(RTL_INCDIRS))
IVER_INCDIRS := $(addprefix -I ,$(RTL_INCDIRS))

# ---------------------------------------------------------------------------
# VCD output directory (VCS: +vcd+<path>; Icarus: $dumpfile in TB)
# We pass +define+VCD_DIR so testbenches can pick it up if they check.
# ---------------------------------------------------------------------------
ifdef VCS_BIN
  VCD_FLAGS := +define+VCD_DIR=\"$(CURDIR)/$(SIMOUT)\"
else
  VCD_FLAGS :=
endif

# ---------------------------------------------------------------------------
# RTL source lists per testbench
# ---------------------------------------------------------------------------
RTL_hamming       := $(RTL_ROOT)/crypto/hamming_secded.v

RTL_axil_to_apb   := $(RTL_ROOT)/periph/axil_to_apb.sv

# axi_firewall RTL source does not exist in rtl/ (only synthesised netlist).
# tb_axi_firewall is listed as a target but will report NOT_FOUND gracefully.
RTL_axi_firewall  :=

RTL_apb_uart      := \
  $(RTL_ROOT)/periph/pulp_uart_wrap.sv \
  $(RTL_ROOT)/periph/vendor/uart/apb_uart.sv \
  $(RTL_ROOT)/periph/vendor/uart/apb_uart_wrap.sv \
  $(RTL_ROOT)/periph/axil_to_apb.sv

RTL_rosc_trng     := \
  $(RTL_ROOT)/crypto/rosc_trng.v \
  $(RTL_ROOT)/periph/axil_to_apb.sv

# ---------------------------------------------------------------------------
# Master testbench list  (tb_axi_firewall intentionally skipped — no RTL src)
# ---------------------------------------------------------------------------
ALL_TBS := tb_hamming tb_axil_to_apb tb_apb_uart tb_rosc_trng

# Colour codes
GREEN := \033[0;32m
RED   := \033[0;31m
RESET := \033[0m

# ---------------------------------------------------------------------------
# Default target
# ---------------------------------------------------------------------------
.PHONY: regress
regress: $(ALL_TBS)
	@echo ""
	@echo "============================================================"
	@python3 -c " \
import os, glob, sys; \
logs = glob.glob('$(SIMOUT)/*/sim.log'); \
total = len(logs); \
passed = sum(1 for l in logs if any('TEST PASSED' in line for line in open(l))); \
failed = total - passed; \
print(f'\033[0;32m{passed}/{total} tests passed\033[0m' if failed == 0 \
      else f'\033[0;31m{passed}/{total} tests passed ({failed} FAILED)\033[0m'); \
sys.exit(1 if failed else 0) \
"

# ---------------------------------------------------------------------------
# Per-testbench rules
# ---------------------------------------------------------------------------

# Helper: create output dir, compile, run, report
# $(1) = short name (e.g. tb_hamming)
# $(2) = TB source
# $(3) = RTL sources
define RUN_TB
.PHONY: $(1)
$(1): | $(SIMOUT)/$(1)
	@printf "  [SIM] %-22s  ($(SIM))\n" "$(1)"
ifdef VCS_BIN
	@vcs $(SIMFLAGS) $(SV_INCDIRS) $(VCD_FLAGS) $(3) $(2) \
	    -o $(SIMOUT)/$(1)/simv \
	    -l $(SIMOUT)/$(1)/compile.log 2>&1 || \
	    { echo "$(RED)FAIL$(RESET) $(1) — compile error"; exit 1; }
	@$(SIMOUT)/$(1)/simv +vcdfile=$(SIMOUT)/$(1)/$(1).vcd \
	    -l $(SIMOUT)/$(1)/sim.log 2>&1 || true
else
	@iverilog $(SIMFLAGS) $(IVER_INCDIRS) $(VCD_FLAGS) $(3) $(2) \
	    -o $(SIMOUT)/$(1)/sim.vvp 2>&1 || \
	    { echo "$(RED)FAIL$(RESET) $(1) — compile error"; exit 1; }
	@vvp $(SIMOUT)/$(1)/sim.vvp -lxt2 | tee $(SIMOUT)/$(1)/sim.log || true
endif
	@if grep -q "TEST PASSED" $(SIMOUT)/$(1)/sim.log 2>/dev/null; then \
	    printf "  $(GREEN)PASS$(RESET) %s\n" "$(1)"; \
	else \
	    printf "  $(RED)FAIL$(RESET) %s  (see $(SIMOUT)/$(1)/sim.log)\n" "$(1)"; \
	fi
endef

$(eval $(call RUN_TB,tb_hamming,tb_hamming.v,$(RTL_hamming)))
$(eval $(call RUN_TB,tb_axil_to_apb,tb_axil_to_apb.v,$(RTL_axil_to_apb)))
$(eval $(call RUN_TB,tb_apb_uart,tb_apb_uart.v,$(RTL_apb_uart)))
$(eval $(call RUN_TB,tb_rosc_trng,tb_rosc_trng.v,$(RTL_rosc_trng)))

# tb_axi_firewall — RTL source not present; emit a clear diagnostic
.PHONY: tb_axi_firewall
tb_axi_firewall:
	@printf "  $(RED)SKIP$(RESET) tb_axi_firewall — axi_firewall.v not found in rtl/\n"
	@printf "        (only synthesised netlist exists at syn/netlist/axi_firewall_netlist.v)\n"

# ---------------------------------------------------------------------------
# Output directory rules
# ---------------------------------------------------------------------------
$(SIMOUT)/%:
	@mkdir -p $@

# ---------------------------------------------------------------------------
# Clean
# ---------------------------------------------------------------------------
.PHONY: clean
clean:
	rm -rf $(SIMOUT) csrc simv* ucli.key vc_hdrs.h .vcs_* DVEfiles *.log

# =============================================================================
# SOC-level testbench (soc_tb.sv)
# =============================================================================

# ---------------------------------------------------------------------------
# All RTL sources needed for full-chip sim
# ---------------------------------------------------------------------------
RTL_SOC_SRCS := \
  $(RTL_ROOT)/top/india_crypto_soc.v \
  $(RTL_ROOT)/core/rv32im_core.v \
  $(RTL_ROOT)/core/aes_isa_ext.v \
  $(RTL_ROOT)/crypto/rosc_trng.v \
  $(RTL_ROOT)/crypto/aes_ca_accel.v \
  $(RTL_ROOT)/crypto/india_pdf_engine.v \
  $(RTL_ROOT)/crypto/hamming_secded.v \
  $(RTL_ROOT)/fabric/axi_lite_xbar.v \
  $(RTL_ROOT)/mem/sram_ctrl.v \
  $(RTL_ROOT)/mem/sram_sp_wrap.v \
  $(RTL_ROOT)/periph/axil_to_apb.sv \
  $(RTL_ROOT)/periph/clint.v \
  $(RTL_ROOT)/periph/gpio.v \
  $(RTL_ROOT)/periph/plic.v \
  $(RTL_ROOT)/periph/pulp_uart_wrap.sv \
  $(RTL_ROOT)/periph/pulp_i2c_wrap.sv \
  $(RTL_ROOT)/periph/pulp_spi_wrap.sv \
  $(RTL_ROOT)/periph/vendor/pulp_blackbox.v \
  $(RTL_ROOT)/periph/vendor/uart/apb_uart.sv \
  $(RTL_ROOT)/periph/vendor/uart/apb_uart_wrap.sv \
  $(RTL_ROOT)/periph/vendor/spi/apb_spi_master.sv \
  $(RTL_ROOT)/periph/vendor/spi/spi_master_apb_if.sv \
  $(RTL_ROOT)/periph/vendor/spi/spi_master_clkgen.sv \
  $(RTL_ROOT)/periph/vendor/spi/spi_master_controller.sv \
  $(RTL_ROOT)/periph/vendor/spi/spi_master_fifo.sv \
  $(RTL_ROOT)/periph/vendor/spi/spi_master_rx.sv \
  $(RTL_ROOT)/periph/vendor/spi/spi_master_tx.sv \
  $(RTL_ROOT)/periph/vendor/i2c/apb_i2c.sv \
  $(RTL_ROOT)/periph/vendor/i2c/i2c_master_bit_ctrl.sv \
  $(RTL_ROOT)/periph/vendor/i2c/i2c_master_byte_ctrl.sv

TB_SOC_SRCS := \
  tb/soc_tb.sv \
  tb/bfm/uart_bfm.sv \
  tb/bfm/spi_bfm.sv \
  tb/bfm/i2c_bfm.sv \
  sva/axil_checker.sv \
  sva/reset_checker.sv \
  sva/irq_checker.sv \
  cov/soc_cov.sv

# ---------------------------------------------------------------------------
# Compile the SoC testbench (produces a simulator binary / vvp)
# ---------------------------------------------------------------------------
.PHONY: soc_tb
soc_tb:
	@mkdir -p $(SIMOUT)/soc_tb
	@printf "  [COMPILE] soc_tb  ($(SIM))\n"
ifdef VCS_BIN
	vcs $(SIMFLAGS) $(SV_INCDIRS) $(VCD_FLAGS) \
	    +define+VCS \
	    $(RTL_SOC_SRCS) $(TB_SOC_SRCS) \
	    -top soc_tb \
	    -o $(SIMOUT)/soc_tb/simv \
	    -l $(SIMOUT)/soc_tb/compile.log
else
	iverilog $(SIMFLAGS) $(IVER_INCDIRS) $(VCD_FLAGS) \
	    +define+IVERILOG \
	    $(RTL_SOC_SRCS) $(TB_SOC_SRCS) \
	    -o $(SIMOUT)/soc_tb/sim.vvp \
	    2>&1 | tee $(SIMOUT)/soc_tb/compile.log
endif
	@printf "  [COMPILE] soc_tb done\n"

# ---------------------------------------------------------------------------
# Run a single SoC test: make soc_<testname>
# Requires soc_tb built and tests/sw/<testname>.hex to exist.
# ---------------------------------------------------------------------------
soc_%: soc_tb
	@mkdir -p $(SIMOUT)/soc_$*
	@printf "  [SIM] soc_$*  (test=$*)\n"
ifdef VCS_BIN
	$(SIMOUT)/soc_tb/simv \
	    +test=$* \
	    +dump \
	    +vcdfile=$(SIMOUT)/soc_$*/tb.vcd \
	    -l $(SIMOUT)/soc_$*/sim.log 2>&1 || true
else
	vvp $(SIMOUT)/soc_tb/sim.vvp \
	    +test=$* \
	    +dump \
	    2>&1 | tee $(SIMOUT)/soc_$*/sim.log || true
endif
	@if grep -q "TEST PASSED" $(SIMOUT)/soc_$*/sim.log 2>/dev/null; then \
	    printf "  $(GREEN)PASS$(RESET) soc_$*\n"; \
	else \
	    printf "  $(RED)FAIL$(RESET) soc_$*  (see $(SIMOUT)/soc_$*/sim.log)\n"; \
	fi

# ---------------------------------------------------------------------------
# Run all SoC tests and print a summary
# ---------------------------------------------------------------------------
.PHONY: soc_regress
soc_regress: soc_aes_selftest soc_trng_health soc_uart_loopback soc_gpio_test
	@python3 scripts/soc_regress.py

# ---------------------------------------------------------------------------
# SW compilation targets: compile a .c test to .elf + .hex
# Requires riscv32-unknown-elf-gcc (or riscv64-unknown-elf-gcc -m32) in PATH
# ---------------------------------------------------------------------------
RV_GCC    := $(shell command -v riscv32-unknown-elf-gcc 2>/dev/null || \
                     command -v riscv64-unknown-elf-gcc 2>/dev/null)
RV_OBJCOPY := $(shell command -v riscv32-unknown-elf-objcopy 2>/dev/null || \
                      command -v riscv64-unknown-elf-objcopy 2>/dev/null)

RV_FLAGS  := -march=rv32im -mabi=ilp32 -O1 -ffreestanding -nostdlib \
             -I tests/sw
RV_LINK   := -T tests/sw/common/link.ld
RV_CRT    := tests/sw/common/crt0.S tests/sw/common/uart_print.c

sw_compile_%: tests/sw/%.c
	@if [ -z "$(RV_GCC)" ]; then \
	    echo "ERROR: riscv32-unknown-elf-gcc not found in PATH"; exit 1; fi
	$(RV_GCC) $(RV_FLAGS) $(RV_LINK) $(RV_CRT) $< -o tests/sw/$*.elf
	$(RV_OBJCOPY) -O verilog tests/sw/$*.elf tests/sw/$*.hex
	@printf "  [SW] %s compiled -> tests/sw/%s.hex\n" "$*" "$*"

# Convenience: compile all known tests
.PHONY: sw_all
sw_all: sw_compile_aes_selftest sw_compile_trng_health \
        sw_compile_uart_loopback sw_compile_gpio_test

# =============================================================================
# UVM Targets
# =============================================================================
RTLDIR := $(RTL_ROOT)

UVM_SRCS_COMMON := $(wildcard $(RTLDIR)/top/*.v) $(wildcard $(RTLDIR)/core/*.v) \
                   $(wildcard $(RTLDIR)/crypto/*.v) $(wildcard $(RTLDIR)/fabric/*.v) \
                   $(wildcard $(RTLDIR)/mem/*.v) $(wildcard $(RTLDIR)/periph/*.v) \
                   $(wildcard $(RTLDIR)/periph/**/*.sv)

uvm_%:
	mkdir -p $(SIMOUT)/uvm_$*
	vcs -full64 -sverilog -ntb_opts uvm-1.2 \
	    -timescale=1ns/1ps \
	    +incdir+$(RTLDIR) \
	    +incdir+uvm \
	    $(UVM_SRCS_COMMON) \
	    uvm/if/criya_axil_if.sv uvm/if/criya_uart_if.sv uvm/if/criya_spi_if.sv \
	    uvm/criya_test_pkg.sv \
	    uvm/tb/criya_tb_top.sv \
	    -o $(SIMOUT)/uvm_$*/simv \
	    2>&1 | tee $(SIMOUT)/uvm_$*/compile.log
	$(SIMOUT)/uvm_$*/simv +UVM_TESTNAME=criya_$*_test \
	    2>&1 | tee $(SIMOUT)/uvm_$*/sim.log

.PHONY: uvm_regress
uvm_regress: uvm_aes uvm_gpio
	@python3 scripts/soc_regress.py --prefix uvm_

# =============================================================================
# Formal Targets
# =============================================================================
formal_%:
	$(MAKE) -C formal $*

.PHONY: formal_all
formal_all:
	$(MAKE) -C formal all
	@python3 scripts/soc_regress.py --prefix formal_

# =============================================================================
# Dashboard
# =============================================================================
.PHONY: dashboard_collect dashboard_serve
dashboard_collect:
	python3 dashboard/collect_results.py

dashboard_serve: dashboard_collect
	python3 dashboard/serve.py &
	@echo "Dashboard at http://localhost:8080"

# =============================================================================
# Full regression
# =============================================================================
.PHONY: full_regress
full_regress: regress soc_regress uvm_regress formal_all dashboard_collect
	@echo "Full regression complete. Open dashboard/index.html"
