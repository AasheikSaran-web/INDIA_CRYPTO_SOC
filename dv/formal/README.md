# CRIYA SoC — Formal Verification

This directory contains SymbiYosys (sby) formal verification jobs for the CRIYA SoC.

## Tool Requirements

| Tool        | Version | Purpose                         |
|-------------|---------|---------------------------------|
| SymbiYosys  | >=0.9   | Formal verification frontend    |
| Boolector   | >=3.2   | SMT solver (BMC jobs)           |
| Z3          | >=4.8   | SMT solver (unbounded prove)    |
| Yosys       | >=0.15  | RTL synthesis/elaboration       |

## Installation

### Ubuntu / Debian
```bash
# Yosys + SymbiYosys via OSS CAD Suite (recommended)
wget https://github.com/YosysHQ/oss-cad-suite-build/releases/latest/download/oss-cad-suite-linux-x64-*.tgz
tar xzf oss-cad-suite-linux-x64-*.tgz
source oss-cad-suite/environment

# Or install individually:
sudo apt-get install -y yosys
pip install symbiyosys
sudo apt-get install -y boolector z3
```

### macOS (Homebrew)
```bash
brew install yosys z3
pip install symbiyosys
brew install boolector
```

## Running Proofs

Run all formal jobs:
```bash
make -C dv/formal all
```

Run a specific proof:
```bash
cd dv/formal/axil_protocol && sby -f axil.sby
cd dv/formal/reset_domain  && sby -f reset.sby
cd dv/formal/crypto        && sby -f aes.sby
cd dv/formal/trng          && sby -f trng.sby
```

## Proof Coverage

| Directory       | Top Module        | Mode  | Depth | Solver    | What it proves                                  |
|-----------------|-------------------|-------|-------|-----------|-------------------------------------------------|
| axil_protocol/  | axil_wrap         | bmc   | 40    | boolector | AXI-Lite protocol compliance (valid/ready rules)|
| reset_domain/   | reset_wrap        | prove | 20    | z3        | Outputs stable/low during and after reset       |
| crypto/         | aes_props_wrap    | bmc   | 100   | boolector | AES done semantics, no spurious done, CT nonzero|
| trng/           | trng_props_wrap   | bmc   | 500   | boolector | TRNG health test ordering, data_valid gating    |

## Results in Dashboard

After running `make -C dv/formal all`, results are collected by:
```bash
python3 dv/dashboard/collect_results.py
```

Each `result.log` under `sim_out/formal/<job>/` is parsed for PASS/FAIL status and
displayed in the regression dashboard at `dv/dashboard/index.html`.

## Adding New Proofs

1. Create a new subdirectory under `dv/formal/`
2. Write a `*_props.sv` wrapper that instantiates the DUT and SVA properties
3. Write a `*.sby` config pointing to the RTL and wrapper
4. Add the directory name to `FORMAL_DIRS` in `dv/formal/Makefile`
