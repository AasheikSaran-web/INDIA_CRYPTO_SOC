#!/usr/bin/env python3
"""
collect_results.py — Scan sim_out/ and produce dashboard/results.json
Run from dv/ directory: python3 dashboard/collect_results.py
"""
import os, re, json, glob, time
from datetime import datetime

BASE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SIM_OUT = os.path.join(BASE, "sim_out")
OUT_JSON = os.path.join(BASE, "dashboard", "results.json")

def parse_sim_log(log_path):
    """Return 'PASS', 'FAIL', or 'UNKNOWN' from a sim log."""
    try:
        text = open(log_path).read()
        if "TEST PASSED" in text or "UVM_ERROR : 0" in text and "TEST PASSED" in text:
            return "PASS"
        if "TEST FAILED" in text or re.search(r"UVM_ERROR\s*:\s*[1-9]", text):
            return "FAIL"
        if "WATCHDOG TIMEOUT" in text or "Fatal" in text:
            return "TIMEOUT"
        return "UNKNOWN"
    except FileNotFoundError:
        return "MISSING"

def parse_formal_log(log_path):
    try:
        text = open(log_path).read()
        if "PASSED" in text: return "PASS"
        if "FAILED" in text or "ERROR" in text: return "FAIL"
        if "TIMEOUT" in text: return "TIMEOUT"
        return "UNKNOWN"
    except FileNotFoundError:
        return "MISSING"

def get_sim_duration(log_path):
    """Extract simulation time from log if available."""
    try:
        for line in open(log_path):
            m = re.search(r'(\d+(?:\.\d+)?)\s*(ns|us|ms|s)\b', line)
            if m: return f"{m.group(1)} {m.group(2)}"
    except: pass
    return "—"

def get_uvm_counts(log_path):
    """Extract UVM_ERROR and UVM_WARNING counts."""
    try:
        text = open(log_path).read()
        err = re.search(r'UVM_ERROR\s*:\s*(\d+)', text)
        warn = re.search(r'UVM_WARNING\s*:\s*(\d+)', text)
        return int(err.group(1)) if err else 0, int(warn.group(1)) if warn else 0
    except: return 0, 0

results = {
    "generated_at": datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
    "project": "CRIYA — Cryptographic RISC-V Indian Yield-optimized Architecture",
    "target": "TSMC 28nm HPC+ | 300 MHz | 36,110 µm² | 6.13 mW | Dec 2026",
    "summary": {"total": 0, "pass": 0, "fail": 0, "unknown": 0},
    "directed": [],
    "uvm": [],
    "riscv_dv": [],
    "formal": []
}

# ── Directed SW tests ────────────────────────────────────────────────
for log in sorted(glob.glob(os.path.join(SIM_OUT, "soc_*", "sim.log"))):
    name = os.path.basename(os.path.dirname(log)).replace("soc_", "")
    status = parse_sim_log(log)
    results["directed"].append({
        "name": name, "status": status, "log": log,
        "category": "SW Test", "duration": get_sim_duration(log)
    })

# ── UVM tests ────────────────────────────────────────────────────────
for log in sorted(glob.glob(os.path.join(SIM_OUT, "uvm_*", "sim.log"))):
    name = os.path.basename(os.path.dirname(log)).replace("uvm_", "")
    errors, warns = get_uvm_counts(log)
    status = "PASS" if errors == 0 and parse_sim_log(log) != "FAIL" else "FAIL"
    results["uvm"].append({
        "name": name, "status": status, "log": log,
        "uvm_errors": errors, "uvm_warnings": warns,
        "category": "UVM", "duration": get_sim_duration(log)
    })

# ── riscv-dv random tests ────────────────────────────────────────────
for log in sorted(glob.glob(os.path.join(SIM_OUT, "riscvdv_*", "sim.log"))):
    name = os.path.basename(os.path.dirname(log)).replace("riscvdv_", "")
    status = parse_sim_log(log)
    results["riscv_dv"].append({
        "name": name, "status": status, "log": log,
        "category": "riscv-dv", "duration": get_sim_duration(log)
    })

# ── Formal proofs ────────────────────────────────────────────────────
for log in sorted(glob.glob(os.path.join(SIM_OUT, "formal", "*", "result.log"))):
    name = os.path.basename(os.path.dirname(log))
    status = parse_formal_log(log)
    results["formal"].append({
        "name": name, "status": status, "log": log,
        "category": "Formal", "duration": "—"
    })

# ── Summary ──────────────────────────────────────────────────────────
all_tests = results["directed"] + results["uvm"] + results["riscv_dv"] + results["formal"]
results["summary"]["total"]   = len(all_tests)
results["summary"]["pass"]    = sum(1 for t in all_tests if t["status"] == "PASS")
results["summary"]["fail"]    = sum(1 for t in all_tests if t["status"] == "FAIL")
results["summary"]["unknown"] = sum(1 for t in all_tests if t["status"] not in ("PASS","FAIL"))
results["summary"]["pass_rate"] = (
    round(results["summary"]["pass"] / results["summary"]["total"] * 100, 1)
    if results["summary"]["total"] > 0 else 0
)

os.makedirs(os.path.dirname(OUT_JSON), exist_ok=True)
with open(OUT_JSON, "w") as f:
    json.dump(results, f, indent=2)
print(f"[collect_results] Written {OUT_JSON}")
print(f"  Total: {results['summary']['total']}  PASS: {results['summary']['pass']}  FAIL: {results['summary']['fail']}")
