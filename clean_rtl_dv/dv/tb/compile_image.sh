#!/bin/bash
# compile_image.sh — Build the image encrypt/decrypt SoC testbench
#
# Usage:
#   cd dv/tb
#   python3 image_to_hex.py        # → test_vectors/aadhar/aadhar_slice.hex
#   python3 fw_gen_image.py        # → image_firmware.hex
#   bash compile_image.sh          # → soc_tb_image.vvp
#   vvp soc_tb_image.vvp
#
export PATH="/opt/homebrew/bin:$PATH"
set -e
cd /Users/aasheiksaran/Desktop/Productivity/INDIA_CRYPTO_SOC/dv/tb

echo "[compile_image] Regenerating hex files..."
python3 image_to_hex.py
python3 fw_gen_image.py

echo "[compile_image] Compiling SoC..."
iverilog -g2012 \
    -I../../rtl/periph/vendor/include \
    -o soc_tb_image.vvp \
    ../../rtl/top/india_crypto_soc.v \
    ../../rtl/core/rv32im_core.v \
    ../../rtl/core/aes_isa_ext.v \
    ../../rtl/crypto/verhoeff_check.v \
    ../../rtl/crypto/aadhaar_id_check.v \
    ../../rtl/crypto/aes_ca_accel.v \
    ../../rtl/crypto/india_pdf_engine.v \
    ../../rtl/crypto/rosc_trng.v \
    ../../rtl/crypto/hamming_secded.v \
    ../../rtl/fabric/axi_lite_xbar.v \
    ../../rtl/mem/sram_ctrl.v \
    ../../rtl/mem/boot_rom.v \
    ../../rtl/mem/sram_sp_wrap.v \
    ../../rtl/periph/vendor/pulp_blackbox.v \
    ../../rtl/periph/pulp_uart_wrap.sv \
    ../../rtl/periph/pulp_i2c_wrap.sv \
    ../../rtl/periph/pulp_spi_wrap.sv \
    ../../rtl/periph/axil_to_apb.sv \
    ../../rtl/periph/clint.v \
    ../../rtl/periph/plic.v \
    ../../rtl/periph/gpio.v \
    soc_tb_image.sv

echo "[compile_image] COMPILE_OK → soc_tb_image.vvp"
echo "[compile_image] Run with: vvp soc_tb_image.vvp"
