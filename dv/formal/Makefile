FORMAL_DIRS := axil_protocol reset_domain crypto trng
FORMAL_RESULTS_DIR := ../../sim_out/formal

.PHONY: all clean $(FORMAL_DIRS)

all: $(FORMAL_DIRS)

axil_protocol:
	@mkdir -p $(FORMAL_RESULTS_DIR)/axil_protocol
	@cd axil_protocol && sby -f axil.sby 2>&1 | tee $(FORMAL_RESULTS_DIR)/axil_protocol/result.log
	@echo "axil_protocol: $$(grep -c PASSED $(FORMAL_RESULTS_DIR)/axil_protocol/result.log || echo 0) proofs passed"

reset_domain:
	@mkdir -p $(FORMAL_RESULTS_DIR)/reset_domain
	@cd reset_domain && sby -f reset.sby 2>&1 | tee $(FORMAL_RESULTS_DIR)/reset_domain/result.log

crypto:
	@mkdir -p $(FORMAL_RESULTS_DIR)/crypto
	@cd crypto && sby -f aes.sby 2>&1 | tee $(FORMAL_RESULTS_DIR)/crypto/result.log

trng:
	@mkdir -p $(FORMAL_RESULTS_DIR)/trng
	@cd trng && sby -f trng.sby 2>&1 | tee $(FORMAL_RESULTS_DIR)/trng/result.log

clean:
	rm -rf axil_protocol/axil/ reset_domain/reset/ crypto/aes/ trng/trng/
