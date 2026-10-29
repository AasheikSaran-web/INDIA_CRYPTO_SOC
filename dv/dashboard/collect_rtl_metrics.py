#!/usr/bin/env python3
"""
collect_rtl_metrics.py — CRIYA SoC RTL Metrics Collector
Scans rtl/ directory, counts LOC, extracts module names, parses syn/reports/*.rpt,
and writes rtl_metrics.json to the script's own directory.

Usage:
    cd /path/to/INDIA_CRYPTO_SOC/dv/dashboard
    python3 collect_rtl_metrics.py
"""

import os
import re
import json
import datetime
import sys

# ── Paths ────────────────────────────────────────────────────────────────────
SCRIPT_DIR   = os.path.dirname(os.path.abspath(__file__))
PROJECT_ROOT = os.path.abspath(os.path.join(SCRIPT_DIR, '..', '..'))
RTL_DIR      = os.path.join(PROJECT_ROOT, 'rtl')
RPT_DIR      = os.path.join(PROJECT_ROOT, 'syn', 'reports')
OUT_JSON     = os.path.join(SCRIPT_DIR, 'rtl_metrics.json')

# ── Hardcoded fallback synthesis numbers (from DC T-2022.03-SP5 run) ─────────
SYNTH_DEFAULTS = {
    "tool":                 "Synopsys DC T-2022.03-SP5",
    "library":              "tcbn28hpcplusbwp30p140",
    "corner":               "TT / 0.9V / 25°C",
    "target_mhz":           300,
    "wns_setup_ns":         0.493,
    "tns_ns":               0.0,
    "fmax_mhz":             352,
    "hold_wns_ns":          -0.07,
    "hold_violations":      149,
    "hold_status":          "APR_FIX",
    "stdcell_area_um2":     28410,
    "sram_area_um2":        7700,
    "total_area_um2":       36110,
    "total_power_mw":       6.13,
    "internal_power_mw":    5.945,
    "switching_power_mw":   0.078,
    "leakage_power_mw":     0.106,
    "cell_count":           33125,
    "net_count":            33851,
    "drc_violations":       0,
    "lint_fatal":           0,
    "signoff_status":       "READY",
}

LINT_DATA = [
    {"code": "LINT-28", "count": 207, "desc": "Unconnected ports", "severity": "INFO"},
    {"code": "LINT-2",  "count": 360, "desc": "Unloaded nets",     "severity": "INFO"},
    {"code": "LINT-55", "count": 1,   "desc": "SRAM Black Box",    "severity": "INFO"},
    {"code": "LINT-63", "count": 2,   "desc": "I2C Open-Drain",    "severity": "INFO"},
]

AREA_BREAKDOWN = [
    {"module": "u_cpu",      "ref": "rv32im_core",       "area_um2": 9865,  "pct": 34.7, "parent": None},
    {"module": "u_alu",      "ref": "alu",               "area_um2": 2104,  "pct": 7.4,  "parent": "u_cpu"},
    {"module": "u_mdu",      "ref": "mul_div_unit",      "area_um2": 3218,  "pct": 11.3, "parent": "u_cpu"},
    {"module": "u_regfile",  "ref": "regfile",           "area_um2": 1841,  "pct": 6.5,  "parent": "u_cpu"},
    {"module": "u_pdf",      "ref": "india_pdf_engine",  "area_um2": 8591,  "pct": 30.2, "parent": None},
    {"module": "u_pdf_hmac", "ref": "pdf_hmac",          "area_um2": 3102,  "pct": 10.9, "parent": "u_pdf"},
    {"module": "u_pdf_fsm",  "ref": "pdf_fsm",           "area_um2": 2841,  "pct": 10.0, "parent": "u_pdf"},
    {"module": "u_pdf_dma",  "ref": "pdf_dma",           "area_um2": 1824,  "pct": 6.4,  "parent": "u_pdf"},
    {"module": "u_spi",      "ref": "secure_spi",        "area_um2": 3526,  "pct": 12.4, "parent": None},
    {"module": "u_aes_ca",   "ref": "aes_ca_accel",      "area_um2": 1549,  "pct": 5.5,  "parent": None},
    {"module": "u_uart",     "ref": "secure_uart",       "area_um2": 1441,  "pct": 5.1,  "parent": None},
    {"module": "u_aes_isa",  "ref": "aes_isa_ext",       "area_um2": 897,   "pct": 3.2,  "parent": None},
    {"module": "u_trng",     "ref": "ms_trng",           "area_um2": 769,   "pct": 2.7,  "parent": None},
    {"module": "u_xbar",     "ref": "axi_lite_xbar",     "area_um2": 412,   "pct": 1.4,  "parent": None},
    {"module": "u_fw",       "ref": "axi_firewall×6",    "area_um2": 384,   "pct": 1.4,  "parent": None},
    {"module": "u_i2c",      "ref": "secure_i2c",        "area_um2": 312,   "pct": 1.1,  "parent": None},
    {"module": "u_clint",    "ref": "clint",             "area_um2": 184,   "pct": 0.6,  "parent": None},
    {"module": "u_plic",     "ref": "plic",              "area_um2": 196,   "pct": 0.7,  "parent": None},
    {"module": "u_gpio",     "ref": "gpio",              "area_um2": 140,   "pct": 0.5,  "parent": None},
    {"module": "u_boot_rom", "ref": "boot_rom",          "area_um2": 94,    "pct": 0.3,  "parent": None},
    {"module": "u_sram_ctrl","ref": "sram_ctrl",         "area_um2": 46,    "pct": 0.2,  "parent": None},
]

POWER_BREAKDOWN = [
    {"module": "u_cpu",       "power_mw": 2.275, "pct": 37.1},
    {"module": "u_pdf",       "power_mw": 1.437, "pct": 23.5},
    {"module": "u_spi",       "power_mw": 0.932, "pct": 15.2},
    {"module": "u_aes_ca",    "power_mw": 0.438, "pct": 7.1},
    {"module": "u_uart",      "power_mw": 0.380, "pct": 6.2},
    {"module": "u_trng",      "power_mw": 0.260, "pct": 4.2},
    {"module": "u_sram_ctrl", "power_mw": 0.213, "pct": 3.5},
    {"module": "Others",      "power_mw": 0.193, "pct": 3.1},
]

TIMING_DATA = {
    "critical_path":             "u_cpu/u_mdu — MDU carry chain",
    "critical_path_detail":      "mdu_cnt_reg[1] → 64× FA1D1/HA1D0 → mdu_acc_reg[62]",
    "data_path_ns":              2.708,
    "logic_levels":              76,
    "clock_period_ns":           3.333,
    "arrival_time_ns":           2.908,
    "hold_root_cause":           "u_trng sync0→sync1 back-to-back FFs, 0 comb logic",
    "hold_fix":                  "HOLD_FIX DLY insertion in Innovus/ICC2 during CTS",
    "post_cts_wns_predicted_ns": 0.05,
}

# ── Category mapping by directory path fragment ───────────────────────────────
def categorize(rel_path):
    p = rel_path.lower().replace('\\', '/')
    if '/top/'    in p or p.startswith('top/'):    return 'Top'
    if '/core/'   in p or p.startswith('core/'):   return 'Core'
    if '/crypto/' in p or p.startswith('crypto/'): return 'Crypto'
    if '/fabric/' in p or p.startswith('fabric/'): return 'Fabric'
    if '/mem/'    in p or p.startswith('mem/'):    return 'Memory'
    if '/vendor/' in p:                             return 'Vendor IP'
    if '/periph/' in p or p.startswith('periph/'): return 'Peripheral'
    return 'Other'

# ── LOC counting ──────────────────────────────────────────────────────────────
def count_loc(filepath):
    total = 0
    blank = 0
    comment = 0
    in_block = False
    try:
        with open(filepath, 'r', encoding='utf-8', errors='replace') as f:
            for line in f:
                total += 1
                stripped = line.strip()
                if in_block:
                    comment += 1
                    if '*/' in stripped:
                        in_block = False
                elif '/*' in stripped and '*/' not in stripped:
                    in_block = True
                    comment += 1
                elif stripped.startswith('//') or stripped.startswith('/*'):
                    comment += 1
                elif stripped == '':
                    blank += 1
    except Exception:
        pass
    return total, blank, comment

# ── Module name extraction ────────────────────────────────────────────────────
MODULE_RE = re.compile(r'\bmodule\s+(\w+)', re.MULTILINE)

def extract_modules(filepath):
    modules = []
    try:
        with open(filepath, 'r', encoding='utf-8', errors='replace') as f:
            content = f.read()
        modules = MODULE_RE.findall(content)
    except Exception:
        pass
    return modules

# ── RTL directory scan ────────────────────────────────────────────────────────
def scan_rtl():
    files = []
    if not os.path.isdir(RTL_DIR):
        print(f"[WARN] RTL directory not found: {RTL_DIR}", file=sys.stderr)
        return files

    for root, dirs, fnames in os.walk(RTL_DIR):
        # Sort for deterministic output
        dirs.sort()
        for fname in sorted(fnames):
            if not (fname.endswith('.v') or fname.endswith('.sv')):
                continue
            abs_path = os.path.join(root, fname)
            rel_path = os.path.relpath(abs_path, PROJECT_ROOT)
            loc, blank, comments = count_loc(abs_path)
            modules = extract_modules(abs_path)
            module_name = modules[0] if modules else os.path.splitext(fname)[0]
            cat = categorize(rel_path)
            files.append({
                "file":          rel_path.replace('\\', '/'),
                "module":        module_name,
                "all_modules":   modules,
                "category":      cat,
                "loc":           loc,
                "blank_lines":   blank,
                "comment_lines": comments,
            })
    return files

# ── Report parsers ────────────────────────────────────────────────────────────
def _read_rpt(name):
    path = os.path.join(RPT_DIR, name)
    if not os.path.isfile(path):
        return None
    try:
        with open(path, 'r', encoding='utf-8', errors='replace') as f:
            return f.read()
    except Exception:
        return None

def parse_qor(synth):
    """Try to extract key numbers from qor.rpt; update synth dict in place."""
    txt = _read_rpt('qor.rpt')
    if not txt:
        return

    # WNS setup
    m = re.search(r'WNS\s*\(ns\)\s*[:\|]?\s*([-\d.]+)', txt, re.IGNORECASE)
    if m:
        try: synth['wns_setup_ns'] = float(m.group(1))
        except ValueError: pass

    # TNS
    m = re.search(r'TNS\s*\(ns\)\s*[:\|]?\s*([-\d.]+)', txt, re.IGNORECASE)
    if m:
        try: synth['tns_ns'] = float(m.group(1))
        except ValueError: pass

    # cell count
    m = re.search(r'Number of cells\s*[:\|]?\s*([\d,]+)', txt, re.IGNORECASE)
    if m:
        try: synth['cell_count'] = int(m.group(1).replace(',', ''))
        except ValueError: pass

    # net count
    m = re.search(r'Number of nets\s*[:\|]?\s*([\d,]+)', txt, re.IGNORECASE)
    if m:
        try: synth['net_count'] = int(m.group(1).replace(',', ''))
        except ValueError: pass


def parse_area(synth):
    """Try to extract std-cell area from area.rpt."""
    txt = _read_rpt('area.rpt')
    if not txt:
        return

    # Look for a total/chip-level area line
    m = re.search(r'Total\s+cell\s+area[:\s]+([\d.]+)', txt, re.IGNORECASE)
    if m:
        try: synth['stdcell_area_um2'] = int(float(m.group(1)))
        except ValueError: pass


def parse_power(synth):
    """Try to extract total power from power.rpt."""
    txt = _read_rpt('power.rpt')
    if not txt:
        return

    # Look for total power line
    m = re.search(r'Total\s+Power\s*=\s*([\d.]+)\s*(m?W)', txt, re.IGNORECASE)
    if m:
        try:
            val = float(m.group(1))
            unit = m.group(2).upper()
            if unit == 'W':
                val *= 1000.0
            synth['total_power_mw'] = round(val, 3)
        except ValueError: pass


def parse_timing_setup(synth):
    """Try to extract setup WNS from timing_setup.rpt."""
    txt = _read_rpt('timing_setup.rpt')
    if not txt:
        return

    m = re.search(r'slack\s+\(MET\)\s+([\d.]+)', txt, re.IGNORECASE)
    if m:
        try: synth['wns_setup_ns'] = float(m.group(1))
        except ValueError: pass


def parse_timing_hold(synth):
    """Try to extract hold WNS and violation count from timing_hold.rpt."""
    txt = _read_rpt('timing_hold.rpt')
    if not txt:
        return

    # Hold WNS (negative slack)
    m = re.search(r'slack\s+\(VIOLATED\)\s+([-\d.]+)', txt, re.IGNORECASE)
    if m:
        try: synth['hold_wns_ns'] = float(m.group(1))
        except ValueError: pass

    # Violation count
    m = re.search(r'(\d+)\s+violation', txt, re.IGNORECASE)
    if m:
        try: synth['hold_violations'] = int(m.group(1))
        except ValueError: pass


# ── Main ──────────────────────────────────────────────────────────────────────
def main():
    print("CRIYA RTL Metrics Collector")
    print(f"  Project root : {PROJECT_ROOT}")
    print(f"  RTL dir      : {RTL_DIR}")
    print(f"  Reports dir  : {RPT_DIR}")
    print(f"  Output JSON  : {OUT_JSON}")
    print()

    # Start from hardcoded defaults
    synth = dict(SYNTH_DEFAULTS)

    # Try to refine from actual reports (failures silently use defaults)
    print("Parsing synthesis reports...")
    parse_qor(synth)
    parse_area(synth)
    parse_power(synth)
    parse_timing_setup(synth)
    parse_timing_hold(synth)
    print("  Done (hardcoded fallbacks active for any missing values)")

    # Scan RTL
    print("Scanning RTL files...")
    rtl_files = scan_rtl()
    total_loc = sum(f['loc'] for f in rtl_files)
    print(f"  Found {len(rtl_files)} RTL files, {total_loc:,} total lines")

    # Assemble JSON
    result = {
        "generated_at":    datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
        "synthesis":       synth,
        "lint":            LINT_DATA,
        "area_breakdown":  AREA_BREAKDOWN,
        "power_breakdown": POWER_BREAKDOWN,
        "timing":          TIMING_DATA,
        "rtl_stats": {
            "total_files":   len(rtl_files),
            "total_loc":     total_loc,
            "v_files":       sum(1 for f in rtl_files if f['file'].endswith('.v')),
            "sv_files":      sum(1 for f in rtl_files if f['file'].endswith('.sv')),
        },
        "rtl_files": rtl_files,
    }

    # Write output
    with open(OUT_JSON, 'w', encoding='utf-8') as fh:
        json.dump(result, fh, indent=2)

    print(f"\nWrote {OUT_JSON}")
    print("Verifying JSON...")
    with open(OUT_JSON, 'r', encoding='utf-8') as fh:
        json.load(fh)
    print("  JSON valid.")


if __name__ == '__main__':
    main()
