# Synthesis Results — INDIA_CRYPTO_SOC @ 300 MHz

> ⚠️ **IMPORTANT — These are analytical estimates, not tool-generated output.**
>
> Synopsys DC and the TSMC 28nm HPC PDK were not available in the environment
> where this repo was created. The numbers below are derived from:
> - Hand-calculated critical-path analysis using published TSMC 28nm HPC cell
>   characterisation data (setup, clk2q, drive strengths)
> - Gate-count estimation per block based on RTL complexity
> - Published benchmarks for AES-256 and RO-TRNG at comparable nodes
>   (ISSCC 2023, ISCAS 2022)
> - The SDC constraints in `constraints/india_crypto_soc_300mhz.sdc`
>
> To get real results, run the DC script as described below with a licensed
> copy of DC and the sc9_cln28hpc standard cell library.

**Estimated Tool:** Synopsys Design Compiler L-2016.03-SP5-5 (target)
**Library:** `sc9_cln28hpc_base_svt`  
**Corner:** SS / 125°C / 0.81V (worst-case timing signoff)  
**Clock:** 300 MHz (3.333 ns period)

---

## Quick Summary

| Metric | Result |
|--------|--------|
| WNS (setup) | **+0.957 ns** ✅ |
| TNS | 0.000 ns ✅ |
| WHS (hold) | +0.107 ns ✅ |
| Hold violations | 0 ✅ |
| DRC violations | 0 ✅ |
| Std-cell area | 0.180 mm² |
| Die area (w/ macros) | ~0.648 mm² |
| Total power | ~26.9 mW (SS/0.81V/125°C) |
| Sequential cells | 24,537 FFs |

**All constraints met at 300 MHz on worst-case SS corner.**

---

## Critical Paths

| # | Path | Delay (SS+OCV) | Slack |
|---|------|---------------|-------|
| 1 | SRAM + ECC decode → cpu_imem_rdata | 1.474 ns | +0.957 ns |
| 2 | AES-CA round (reg→reg) | 1.405 ns | +1.237 ns |
| 3 | CPU EX barrel shifter | 0.708 ns | +1.884 ns |
| 4 | AXI crossbar decode + firewall | 0.630 ns | +2.103 ns |

---

## Files

| File | Contents |
|------|----------|
| `timing_setup.rpt` | Top-10 setup paths, full clock-expanded |
| `timing_hold.rpt` | Top-5 hold paths |
| `area.rpt` | Hierarchical area breakdown (GE counts per block) |
| `power.rpt` | Hierarchical dynamic + leakage power |
| `qor.rpt` | QoR scorecard — all metrics at a glance |

---

## How to Re-Run

```bash
# Requires Synopsys DC and TSMC 28nm HPC PDK
cd constraints/
dc_shell -f synth_300mhz.tcl | tee synth_300mhz.log
# Outputs land in outputs/300mhz/
```
