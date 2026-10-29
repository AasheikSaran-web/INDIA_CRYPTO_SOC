# CRIYA SoC — riscv-dv Integration

[riscv-dv](https://github.com/chipsalliance/riscv-dv) is an open-source random RISC-V
instruction sequence generator from Google / chipsalliance. It generates assembly test
programs, compiles them with `riscv32-unknown-elf-gcc`, runs them on an ISS (Spike),
and then re-runs the same programs on the RTL simulation to compare execution traces.

## Installation

```bash
# 1. Clone riscv-dv
git clone https://github.com/chipsalliance/riscv-dv
cd riscv-dv
pip install -r requirements.txt

# 2. Install Spike ISS
sudo apt-get install -y device-tree-compiler
git clone https://github.com/riscv-software-src/riscv-isa-sim
cd riscv-isa-sim && mkdir build && cd build
../configure --prefix=/opt/spike
make -j$(nproc) && sudo make install
export PATH=/opt/spike/bin:$PATH

# 3. Install RISC-V toolchain
sudo apt-get install -y gcc-riscv64-unknown-elf
# OR build from source for rv32im support:
# https://github.com/riscv-collab/riscv-gnu-toolchain

# 4. Set RISCV_DV_PATH
export RISCV_DV_PATH=/path/to/riscv-dv/run.py
```

## Running

Generate and run 10 random tests (default):
```bash
cd dv/riscv_dv
./scripts/run_riscvdv.sh
```

Generate and run 50 tests:
```bash
./scripts/run_riscvdv.sh 50
```

## What Tests Are Generated

The script generates three test types defined in `cfg/criya_rv32im.yaml`:

| Test                        | Description                                    |
|-----------------------------|------------------------------------------------|
| `riscv_arithmetic_basic_test` | Basic ALU ops: ADD, SUB, AND, OR, XOR, SLT  |
| `riscv_rand_instr_test`       | Fully random RV32IM with hazard injection   |
| `riscv_load_store_rand_test`  | Random LW/SW/LH/SH/LB/SB with random addrs |

The config (`cfg/criya_rv32im.yaml`) sets:
- `march: rv32im` — base integer + multiply/divide only (no F/D/A/C)
- `privileged_mode: machine` — M-mode only (CRIYA has no S/U modes)
- `illegal_instr_ratio: 2` — 2% illegal instructions to stress the trap handler
- `no_load_use_hazard: 0` — load-use hazards are intentionally generated to stress the pipeline's stall logic
- `num_of_sub_program: 5` — generates subroutine calls to exercise the call stack

## How Results Feed the Dashboard

After the run, `run_riscvdv.sh` writes per-test simulation logs under:
```
dv/sim_out/riscvdv_<testname>/sim.log
```

The dashboard collector (`dv/dashboard/collect_results.py`) scans for `TEST PASSED` /
`TEST FAILED` tokens in all `sim_out/*/sim.log` files and renders the summary in
`dv/dashboard/index.html`.

To view:
```bash
make -C dv dashboard_serve
# then open http://localhost:8080
```

## Configuration

Edit `cfg/criya_rv32im.yaml` to tune:
- `num_of_tests` / `num_of_instructions` — scale up for pre-tapeout regression
- `enable_interrupt: 1` — once interrupt handler is verified, turn on IRQ injection
- `illegal_instr_ratio` — increase to stress illegal-instruction trap path
