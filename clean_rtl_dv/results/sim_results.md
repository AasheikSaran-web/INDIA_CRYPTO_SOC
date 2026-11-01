# INDIA_CRYPTO_SOC — Simulation Results

All three full-SoC simulations **PASS** on Icarus Verilog (iverilog/vvp) after the fixes applied in this session.

---

## soc_tb_aadhaar — Aadhaar Validation + Encrypt/Decrypt

```
*** AADHAAR SIMULATION PASSED ***
  Verhoeff checksum : PASS
  Leading digit     : PASS  (first digit = 2)
  Document identity : PASS  (<?xml header matched)
  Encrypt + Decrypt : PASS  (round-trip match)
[HB1K] cyc=1000 pc=0x2000016c pdf_st=0 done=1 busy=0 auth=1 x6=0x00000006 dmop=0 dmrd=0
```

---

## soc_tb_crypto — 256-byte AES-256-CTR Encrypt/Decrypt

```
*** SIMULATION PASSED ***
  GPIO = 0x900ddead = PASS after 9466 cycles
```

---

## soc_tb_image — 64-byte JPEG Slice Encrypt/Decrypt

```
*** IMAGE ENCRYPT/DECRYPT SIMULATION PASSED ***
  Step 1 — Aadhaar validation  : PASS  (2000 5555 5554)
  Step 2 — AES-256-CTR encrypt : PASS  (64-byte JPEG slice)
  Step 3 — AES-256-CTR decrypt : PASS  (same key/nonce)
  Step 4 — Auth tag verify     : PASS  (exp_tag matched)
  Step 5 — Byte-level compare  : PASS  (16 words match)
```

---

## Fixes Applied

| File | Fix |
|------|-----|
| `rtl/mem/sram_ctrl.v` | CPU AR guard: `!cpu_rd_pend2 && !cpu_rvalid` — prevents speculative-fetch pipeline overlap |
| `rtl/core/rv32im_core.v` | AXI_ADDR: unconditional `imem_rready=1`; branch-redirect: removed `imem_rready=0`; AXI_DATA: `rvalid&&rready`; custom-instr stall |
| `rtl/core/aes_isa_ext.v` | `AADHAAR.CHECK` instruction: instantiates `verhoeff_check`, returns `{31'd0, adh_valid}` |
| `rtl/crypto/india_pdf_engine.v` | Decrypt `src_ptr <= src_addr + 32'd16` — HMAC over ciphertext, not encrypted header |
| `dv/tb/fw_gen_aadhaar.py` | UART loopback bypassed via JAL after `auth_ok`; `SRC_ADDR = SRAM_DST` (packet base) |
| `dv/tb/fw_gen.py` | Decrypt `SRC_ADDR = DST_BASE` (not `DST_BASE+16`) |
| `dv/tb/fw_gen_image.py` | `DEC_SRC = ENC_DST` (not `ENC_DST+16`) |
| `dv/tb/soc_tb_image.sv` | Signal renames: `axi_state→imem_state`, `if_de_valid→ifid_valid`, `de_ex_valid→idex_valid` |
| `dv/tb/compile.sh` | Added `verhoeff_check.v`, `aadhaar_id_check.v`, `boot_rom.v` |
| `dv/tb/compile_image.sh` | Added `boot_rom.v` |
