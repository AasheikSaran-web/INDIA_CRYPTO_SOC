# INDIA_CRYPTO_SOC Verification Results

**Date:** 2026-08-26  
**Simulator:** Icarus Verilog 12.0 (`iverilog -g2012`)  
**Status: ✅ ALL TESTS PASSING (39/39)**

---

## Summary Table

| Testbench | Module Under Test | Tests | Pass | Fail |
|-----------|------------------|-------|------|------|
| `tb_hamming` | `hamming_enc` / `hamming_dec` (Hamming-39,32 SEC-DED) | 13 | 13 | 0 |
| `tb_axil_to_apb` | `axil_to_apb` (AXI-Lite → APB bridge) | 6 | 6 | 0 |
| `tb_axi_firewall` | `axi_firewall` (per-master permission table) | 5 | 5 | 0 |
| `tb_apb_uart` | `apb_uart` (16550-compatible UART) | 8 | 8 | 0 |
| `tb_rosc_trng` | `rosc_trng` (Ring-Osc TRNG, SP 800-90B) | 7 | 7 | 0 |
| **TOTAL** | | **39** | **39** | **0** |

---

## Detailed Results

### tb_hamming — Hamming(39,32) SEC-DED ECC

Tests: Encoder correctness, error-free decode, single-bit error correction (SEC), double-bit error detection (DED).

```
[PASS] Encode 0x00000000: data embedded correctly in codeword
[PASS] Encode 0xFFFFFFFF: data embedded correctly in codeword
[PASS] Encode 0xA5A5A5A5: data embedded correctly in codeword
[PASS] Encode 0x5A5A5A5A: data embedded correctly in codeword
[PASS] Encode 0xDEADBEEF: data embedded correctly in codeword
[PASS] Error-free decode 0x00000000: data correct, sec=0, ded=0
[PASS] Error-free decode 0xFFFFFFFF: data correct, sec=0, ded=0
[PASS] Error-free decode 0xA5A5A5A5: data correct, sec=0, ded=0
[PASS] Error-free decode 0x5A5A5A5A: data correct, sec=0, ded=0
[PASS] Error-free decode 0xDEADBEEF: data correct, sec=0, ded=0
[PASS] All 39 single-bit positions handled correctly (bit38=p6 special case)
[PASS] Double-bit errors detected (DED=1) for 10 pairs
[PASS] Known vector 0xDEADBEEF: encode/decode round-trip correct, syndrome=0
```

**RTL Bug Fixed:** `s_overall = ^din` (XOR of all 39 received bits). Original
implementation recomputed overall parity from syndrome bits, which cancelled
the error contribution and misclassified every single-bit data error as DED=1.

---

### tb_axil_to_apb — AXI-Lite to APB Bridge

Tests: Write address/data capture, read data, slave wait-states, back-to-back writes, BRESP=OKAY, pwrite polarity.

```
[PASS] TC1 Write: paddr=0xABC pwdata=0xDEAD1234
[PASS] TC2 Read: 0xCAFEBABE received
[PASS] TC3 SlaveWait: 0x12345678 after 3-cycle wait
[PASS] TC4 Back-to-back: 4 writes completed
[PASS] TC5 BRESP=OKAY
[PASS] TC6 pwrite=1 on write
```

**Testbench Fix:** Bridge requires AW and W valid simultaneously in IDLE state.
The `axil_wr` task now waits for `awready && wready` in the same clock cycle.

---

### tb_axi_firewall — AXI Firewall (Per-Master Access Control)

Tests: Allowed/denied writes, BRESP responses, read access enforcement, post-denied-write behavior.

```
[PASS] TC1 Allowed master write: BRESP=OKAY
[PASS] TC2 Denied master write: BRESP=SLVERR
[PASS] TC3 Master-0 second write still passes: BRESP=OKAY
[PASS] TC4 Denied master read: RRESP=SLVERR (perm_table enforced for reads)
[PASS] TC5 Master-0 read: RRESP=OKAY, data=0xABCDEF00
```

**RTL Bugs Fixed (2):**
1. **Syntax error (line 55):** Multi-line binary literal with embedded comments and `|`
   operator on separate line. Fixed: `parameter [31:0] DEFAULT_PERM = 32'h1111_1131`.
2. **WS_PASS and RS_PASS re-assertion loop:** Both states unconditionally drove
   `d_awvalid/d_arvalid <= 1'b1` every cycle, causing the downstream slave model
   to re-process the same AW/AR handshake after `d_awready/d_arready` fired,
   creating an infinite loop. Fixed: `d_awvalid`/`d_arvalid` are pre-asserted once
   on state entry and cleared only when the downstream acknowledges.

**Testbench Fixes (2):**
1. `do_write`: waits for `awready && wready` simultaneously (firewall asserts
   both as one-shot pulses in the same cycle).
2. `do_write`/`do_read`: `bready`/`rready` only set *after* `bvalid`/`rvalid`
   appears — prevents the "last-NBA-wins" clear in `WS_DENY`/`RS_DENY` states.

---

### tb_apb_uart — APB UART (16550-compatible)

Tests: Baud rate divisor, LCR configuration, scratch register, IER masking, FIFO status, TX and RX loopback, IIR idle state.

```
[PASS] TC1 DLL=1 readback correct
[PASS] TC2 LCR readback 0x1B
[PASS] TC3 SCR=0xA5 readback
[PASS] TC4 IER masked to 0x0F
[PASS] TC5 LSR THRE=1 TEMT=1 (TX FIFO empty at reset)
[PASS] TC6 TX loopback: sent 0x55, received 0x55
[PASS] TC7 RX loopback: received 0xA5
[PASS] TC8 IIR=0xC1 (no interrupt)
```

---

### tb_rosc_trng — Ring-Oscillator TRNG (NIST SP 800-90B)

Tests: Health flags after reset, first valid entropy word, non-zero output, consecutive words differ, AXI-Lite STAT register read, RCT health under normal toggling, CTRL register readback.

```
[PASS] TC1 Post-reset: rct_fail=0 apt_fail=0
[PASS] TC2 trng_valid after 33 cycles data=0x6DE196E9
[PASS] TC3 trng_data non-zero
[PASS] TC4 Consecutive values differ: 0x6DE196E9 vs 0xB6F2A6CC
[PASS] TC5 AXI-Lite STAT read=0x00000001 (valid=1 rct=0 apt=0)
[PASS] TC6 RCT_FAIL=0 under bypass_vn toggling
[PASS] TC7 CTRL readback: enable=1 bypass_vn=1 test_mode=0
```

**Testbench Fix:** `axil_rd` task deadlock — TRNG asserts `arready` and `rvalid`
in the same clock cycle; pre-setting `rready=1` caused `rvalid` to be cleared
immediately via the `rvalid && rready` handshake before the task could observe it.
Fix: wait for `rvalid` directly (not `arready`), capture `s_rdata` in the same
posedge where `rvalid` first appears. Additionally, TRNG must be enabled
(`ctrl_enable=1, ctrl_bypass_vn=1`) via an AXI write before entropy is produced.

---

## How to Run

```bash
cd /Users/aasheiksaran/Desktop/Productivity/INDIA_CRYPTO_SOC/tb
bash run_tb.sh
```

All testbenches compile and simulate with Icarus Verilog 12.0. Total wall-clock
time: ~10 seconds.
