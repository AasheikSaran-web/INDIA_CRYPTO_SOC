#!/usr/bin/env python3
"""
soc_regress.py — SoC-level regression results parser

Reads all sim_out/soc_*/sim.log files, counts TEST PASSED / TEST FAILED,
prints a formatted summary table and exits with code 0 (all pass) or 1 (any fail).

Usage:
    python3 scripts/soc_regress.py
    python3 scripts/soc_regress.py --sim-dir /path/to/sim_out
"""

import argparse
import glob
import os
import sys


# ANSI colour codes
GREEN  = "\033[0;32m"
RED    = "\033[0;31m"
YELLOW = "\033[0;33m"
RESET  = "\033[0m"
BOLD   = "\033[1m"


def parse_log(log_path: str) -> str:
    """Return 'PASS', 'FAIL', or 'UNKNOWN' for a sim log."""
    try:
        with open(log_path, "r", errors="replace") as f:
            content = f.read()
    except OSError as exc:
        print(f"  WARNING: cannot read {log_path}: {exc}", file=sys.stderr)
        return "UNKNOWN"

    if "TEST PASSED" in content:
        return "PASS"
    if "TEST FAILED" in content or "WATCHDOG TIMEOUT" in content:
        return "FAIL"
    return "UNKNOWN"


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Parse SoC regression sim logs and report results."
    )
    parser.add_argument(
        "--sim-dir",
        default="sim_out",
        help="Directory containing soc_* sim output subdirectories (default: sim_out)",
    )
    args = parser.parse_args()

    pattern = os.path.join(args.sim_dir, "soc_*", "sim.log")
    log_files = sorted(glob.glob(pattern))

    if not log_files:
        print(f"{YELLOW}WARNING: No sim logs found matching '{pattern}'{RESET}")
        print("  Run 'make soc_regress' first to generate simulation outputs.")
        return 1

    # Collect results
    results = []
    for log_path in log_files:
        test_dir  = os.path.basename(os.path.dirname(log_path))
        test_name = test_dir.replace("soc_", "", 1)
        status    = parse_log(log_path)
        results.append((test_name, status, log_path))

    # Print summary table
    col_name   = max(len(r[0]) for r in results)
    col_name   = max(col_name, 20)
    sep        = "-" * (col_name + 30)

    print()
    print(f"{BOLD}{'=' * (col_name + 30)}{RESET}")
    print(f"{BOLD}  CRIYA SoC Regression Results{RESET}")
    print(f"{BOLD}{'=' * (col_name + 30)}{RESET}")
    print(f"  {'Test':<{col_name}}  {'Result':<8}  Log")
    print(f"  {sep}")

    passed  = 0
    failed  = 0
    unknown = 0

    for test_name, status, log_path in results:
        if status == "PASS":
            colour = GREEN
            passed += 1
        elif status == "FAIL":
            colour = RED
            failed += 1
        else:
            colour = YELLOW
            unknown += 1

        print(f"  {test_name:<{col_name}}  {colour}{status:<8}{RESET}  {log_path}")

    total = len(results)
    print(f"  {sep}")

    summary_colour = GREEN if failed == 0 and unknown == 0 else RED
    print(
        f"\n  {summary_colour}{BOLD}Summary: "
        f"{passed}/{total} PASSED, {failed} FAILED, {unknown} UNKNOWN{RESET}"
    )
    print(f"{'=' * (col_name + 30)}\n")

    if failed > 0:
        print(f"{RED}REGRESSION FAILED — {failed} test(s) did not pass{RESET}")
        return 1
    if unknown > 0:
        print(f"{YELLOW}REGRESSION INCOMPLETE — {unknown} test(s) had no result{RESET}")
        return 1

    print(f"{GREEN}REGRESSION PASSED — all {passed} tests passed{RESET}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
