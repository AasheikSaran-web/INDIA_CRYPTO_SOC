#!/usr/bin/env python3
"""
collect_rtl_perf.py — CRIYA SoC RTL Performance Analyser
=========================================================
Parses all .v/.sv files in rtl/ to extract:
  • Pipeline topology (stages, interstage registers, stall/flush signals)
  • MDU operation latencies (from mdu_cnt threshold analysis)
  • ISA coverage  (instruction opcodes / M-extension ops)
  • Forwarding paths
  • CSR addresses  (MCYCLE / MINSTRET)
  • Module-level stats (LOC, FF count estimate, parameter count)

Then calculates IPC/CPI for two workload profiles and writes rtl_perf.json.

Usage:
    cd /path/to/INDIA_CRYPTO_SOC
    python3 dv/dashboard/collect_rtl_perf.py
"""

import os, re, json, datetime, sys

# ── Paths ─────────────────────────────────────────────────────────────────────
SCRIPT_DIR   = os.path.dirname(os.path.abspath(__file__))
PROJECT_ROOT = os.path.abspath(os.path.join(SCRIPT_DIR, '..', '..'))
RTL_DIR      = os.path.join(PROJECT_ROOT, 'rtl')
OUT_JSON     = os.path.join(SCRIPT_DIR, 'rtl_perf.json')

# ── Helpers ───────────────────────────────────────────────────────────────────
def read_file(path):
    try:
        with open(path, 'r', encoding='utf-8', errors='replace') as f:
            return f.read()
    except Exception:
        return ''

def strip_comments(verilog):
    """Remove // and /* */ comments, preserve line structure."""
    # Remove block comments
    verilog = re.sub(r'/\*.*?\*/', lambda m: '\n' * m.group().count('\n'), verilog, flags=re.DOTALL)
    # Remove line comments
    verilog = re.sub(r'//[^\n]*', '', verilog)
    return verilog

def find_files(ext=('.v', '.sv')):
    found = []
    if not os.path.isdir(RTL_DIR):
        return found
    for root, dirs, files in os.walk(RTL_DIR):
        dirs.sort()
        for fname in sorted(files):
            if fname.endswith(ext):
                abs_p = os.path.join(root, fname)
                rel_p = os.path.relpath(abs_p, PROJECT_ROOT).replace('\\', '/')
                found.append((abs_p, rel_p, fname))
    return found

# ── Per-file RTL stats ────────────────────────────────────────────────────────
def file_stats(content, rel_path):
    lines = content.splitlines()
    total      = len(lines)
    blank      = sum(1 for l in lines if l.strip() == '')
    comment    = 0
    in_block   = False
    for line in lines:
        s = line.strip()
        if in_block:
            comment += 1
            if '*/' in s:
                in_block = False
        elif '/*' in s and '*/' not in s:
            in_block = True
            comment += 1
        elif s.startswith('//') or s.startswith('/*'):
            comment += 1
    code = total - blank - comment

    clean = strip_comments(content)
    modules   = re.findall(r'\bmodule\s+(\w+)', clean)
    localparams = re.findall(r'\blocalparam\b', clean)
    params    = re.findall(r'\bparameter\b', clean)
    # Sequential registers: reg declarations
    regs      = re.findall(r'\breg\b', clean)
    # Always blocks
    always    = re.findall(r'\balways\b', clean)
    assigns   = re.findall(r'\bassign\b', clean)

    cat = categorize(rel_path)
    return {
        'file': rel_path,
        'module': modules[0] if modules else os.path.splitext(os.path.basename(rel_path))[0],
        'all_modules': modules,
        'category': cat,
        'loc': {'total': total, 'code': code, 'blank': blank, 'comment': comment},
        'counts': {
            'localparams': len(localparams),
            'parameters':  len(params),
            'reg_decls':   len(regs),
            'always_blocks': len(always),
            'assign_stmts': len(assigns),
        }
    }

def categorize(rel_path):
    p = rel_path.lower()
    if '/top/'    in p: return 'Top'
    if '/core/'   in p: return 'Core'
    if '/crypto/' in p: return 'Crypto'
    if '/fabric/' in p: return 'Fabric'
    if '/mem/'    in p: return 'Memory'
    if '/vendor/' in p: return 'Vendor IP'
    if '/periph/' in p: return 'Peripheral'
    return 'Other'

# ── Pipeline topology extractor ───────────────────────────────────────────────
def extract_pipeline(content):
    """Detect interstage regs, stall/flush signals, forwarding."""
    clean = strip_comments(content)

    # Interstage register prefixes (ifid_, idex_, exmem_, memwb_)
    interstage_prefixes = sorted(set(re.findall(
        r'\breg\s+(?:\[[\d:]+\]\s+)?(\w+)_(?:pc|instr|valid|rd|alu)\b', clean
    )))
    # More reliable: look for named pipeline register groups
    stage_regs = re.findall(r'\breg\b[^;]+?(ifid|idex|exmem|memwb)_\w+', clean)
    stage_prefixes = sorted(set(stage_regs))

    stall_sigs = re.findall(r'\breg\s+(\w*stall\w*)\s*;', clean)
    flush_sigs = re.findall(r'\breg\s+(\w*flush\w*)\s*;', clean)

    # Stage names from stall signal names (stall_if → IF stage)
    def prefix_to_stage(sig):
        sig = sig.lower()
        for abbr, full in [('_if','IF'),('_id','ID'),('_ex','EX'),('_mem','MEM'),('_wb','WB')]:
            if sig.endswith(abbr): return full
        return sig.upper()

    stall_stages = [prefix_to_stage(s) for s in stall_sigs]
    flush_stages = [prefix_to_stage(s) for s in flush_sigs]

    # Number of pipeline stages = number of interstage reg groups + 1
    known_stages = ['IF','ID','EX','MEM','WB']
    n_stages = 5 if any(p in stage_prefixes for p in ['ifid','idex','exmem','memwb']) else None
    if n_stages is None:
        n_stages = len(set(stage_prefixes)) + 1

    # Forwarding: look for fwd_rs1/fwd_rs2 assignments or "forwarding" keyword
    has_forwarding = bool(re.search(r'\bfwd_rs[12]\b', clean))

    # Branch flush: flush_ex = ... branch_taken
    branch_flush_cycles = 0
    flush_src = re.findall(r'(flush_\w+)\s*=\s*[^;]+branch_taken', clean)
    if flush_src:
        branch_flush_cycles = len(set(flush_src))  # each flush signal = 1 bubble
    # Default: if we see flush_ex and flush_id both driven by branch_taken
    if 'flush_ex' in clean and 'flush_id' in clean and 'branch_taken' in clean:
        branch_flush_cycles = 2

    # Load-use hazard
    luh_signal = None
    luh_match = re.search(r'(load_use_hazard)\s*=', clean)
    if luh_match:
        luh_signal = luh_match.group(1)
    luh_cycles = 1 if luh_signal else 0

    # Memory wait stall
    mem_wait_signal = None
    if re.search(r'dmem_op_pending', clean):
        mem_wait_signal = 'dmem_op_pending'

    return {
        'stages': n_stages,
        'stage_names': known_stages[:n_stages],
        'interstage_reg_prefixes': stage_prefixes,
        'stall_signals': stall_sigs,
        'flush_signals': flush_sigs,
        'stall_stages': stall_stages,
        'flush_stages': flush_stages,
        'forwarding': has_forwarding,
        'forwarding_signals': ['fwd_rs1', 'fwd_rs2'] if has_forwarding else [],
        'branch_flush_cycles': branch_flush_cycles,
        'load_use_hazard': {
            'signal': luh_signal or 'N/A',
            'stall_cycles': luh_cycles,
        },
        'mem_wait': {
            'signal': mem_wait_signal or 'N/A',
            'stall_cycles': 1 if mem_wait_signal else 0,
            'note': '1-cycle SRAM access, 0 extra stalls when pipelined'
        }
    }

# ── ISA coverage extractor ────────────────────────────────────────────────────
def extract_isa(content):
    """Parse instruction opcodes, M-extension ops, CSR addresses."""
    clean = strip_comments(content)

    # Instruction opcodes (OP_ localparams)
    opcodes = {}
    for m in re.finditer(r'localparam\s+(OP_\w+)\s*=\s*(7\'b[\d_]+|7\'h[\da-fA-F]+)', clean):
        opcodes[m.group(1)] = m.group(2)

    # ALU ops
    alu_ops = {}
    for m in re.finditer(r'localparam\s+(ALU_\w+)\s*=\s*([\d\'hdboB_]+)', clean):
        alu_ops[m.group(1)] = m.group(2)

    # MDU ops (M-extension)
    mdu_ops = {}
    for m in re.finditer(r'localparam\s+(MDU_\w+)\s*=\s*([\d\'hdboB_]+)', clean):
        mdu_ops[m.group(1)] = m.group(2)

    # CSR addresses
    csr_addrs = {}
    for m in re.finditer(r'localparam\s+(CSR_\w+)\s*=\s*(12\'h[\da-fA-F]+)', clean):
        csr_addrs[m.group(1)] = m.group(2)

    # ISA string from module port or comment
    isa_str = 'RV32I'
    if mdu_ops:
        isa_str = 'RV32IM'
    if re.search(r'[AF]_EXT|RV32[AF]', clean, re.I):
        isa_str += 'F'

    # M-extension opcode detection
    has_m_ext = bool(mdu_ops) or bool(re.search(r'7\'b0000001', clean))  # FUNCT7=0x01 = M-ext

    return {
        'isa': isa_str,
        'has_m_extension': has_m_ext,
        'opcodes': opcodes,
        'alu_ops': alu_ops,
        'mdu_ops': mdu_ops,
        'csr_addresses': csr_addrs,
        'perf_csrs': {
            k: v for k, v in csr_addrs.items()
            if k in ('CSR_MCYCLE', 'CSR_MINSTRET', 'CSR_MCYCLEH', 'CSR_MINSTRETH')
        }
    }

# ── MDU latency analyser ──────────────────────────────────────────────────────
def extract_mdu_latency(content):
    """
    Parse the MDU state machine to derive exact stall cycle counts.

    MUL/MULH/MULHU/MULHSU:  mdu_cnt < 6'd32  (counts 0→31, fires else at 32)
      → stall_cycles = threshold + 1  = 33

    DIV/REM (signed):  cnt==0 setup  then cnt<=32 compute  (else at cnt=33)
      → stall_cycles = threshold(32) + 2  = 34

    DIVU/REMU (unsigned):  mdu_cnt < 6'd32 (same as MUL)
      → stall_cycles = threshold + 1  = 33
    """
    clean = strip_comments(content)
    result = {
        'mdu_signal': 'mdu_busy',
        'mdu_cnt_signal': 'mdu_cnt',
        'mul': {'ops': [], 'stall_cycles': 32, 'threshold_expr': 'N/A', 'mechanism': 'shift-add'},
        'div_signed': {'ops': [], 'stall_cycles': 34, 'threshold_expr': 'N/A', 'mechanism': 'restoring-division'},
        'div_unsigned': {'ops': [], 'stall_cycles': 32, 'threshold_expr': 'N/A', 'mechanism': 'restoring-division'},
    }

    # Find "mdu_cnt < N'd<val>" ONLY in conditional contexts (not assignments)
    # Match patterns like: if (mdu_cnt < 6'd32)  or  end if mdu_cnt < 6'd32
    lt_matches = re.findall(r"if\s*\(\s*mdu_cnt\s*<\s*\d+'d(\d+)\s*\)", clean)
    # Find "mdu_cnt <= N'd<val>" in conditional contexts only
    # Excludes non-blocking assignments like "mdu_cnt <= 6'd1;"
    le_matches = re.findall(r"if\s*\(\s*mdu_cnt\s*<=\s*\d+'d(\d+)\s*\)", clean)
    # Find "mdu_cnt == N'd0" (div setup cycle)
    has_div_setup = bool(re.search(r"mdu_cnt\s*==\s*\d+'d0", clean))

    if lt_matches:
        threshold = int(lt_matches[0])  # e.g. 32
        # stall = threshold + 1 cycles (cnt 0..threshold-1 all fire the < branch,
        #   then cnt==threshold fires the else which clears busy in THAT same cycle,
        #   so busy is 1 for threshold+1 cycles: cnt 0 through threshold)
        mul_stall = threshold + 1
        result['mul']['threshold_expr'] = f"mdu_cnt < {threshold}"
        result['mul']['stall_cycles']   = mul_stall
        result['mul']['ops']            = ['MUL', 'MULH', 'MULHU', 'MULHSU']

        # DIVU/REMU use the same < threshold pattern
        result['div_unsigned']['threshold_expr'] = f"mdu_cnt < {threshold}"
        result['div_unsigned']['stall_cycles']   = mul_stall
        result['div_unsigned']['ops']            = ['DIVU', 'REMU']

    if le_matches and has_div_setup:
        threshold = int(le_matches[0])  # e.g. 32
        # DIV/REM signed: cnt=0 is setup (1 cycle), cnt=1..threshold are compute
        # (threshold cycles), cnt=threshold+1 fires else → stall = threshold + 2
        div_stall = threshold + 2
        result['div_signed']['threshold_expr'] = f"mdu_cnt <= {threshold} (+ setup at cnt==0)"
        result['div_signed']['stall_cycles']   = div_stall
        result['div_signed']['ops']            = ['DIV', 'REM']

    return result

# ── IPC / CPI calculator ──────────────────────────────────────────────────────
def calc_ipc_cpi(pipeline, mdu, workload_profile):
    """
    Calculate IPC / CPI from RTL-derived stall latencies and workload mix.

    Returns dict with per-source stall contributions and final IPC/CPI.
    """
    br_penalty = pipeline['branch_flush_cycles']
    luh_penalty = pipeline['load_use_hazard']['stall_cycles']
    mem_penalty = pipeline['mem_wait']['stall_cycles']
    mul_stall   = mdu['mul']['stall_cycles']
    div_stall   = mdu['div_signed']['stall_cycles']   # worst case (signed)

    p = workload_profile  # shorthand

    # Stall contributions per instruction (fractional)
    # = fraction_of_instructions × penalty_cycles
    luh_contrib   = p['load_pct']/100 * p['load_use_hazard_rate'] * luh_penalty
    branch_contrib= p['branch_pct']/100 * p['branch_taken_rate']  * br_penalty
    mul_contrib   = p['mul_pct']/100   * mul_stall
    div_contrib   = p['div_pct']/100   * div_stall
    mem_contrib   = p['mem_wait_pct']/100 * mem_penalty

    total_stall_per_instr = luh_contrib + branch_contrib + mul_contrib + div_contrib + mem_contrib
    cpi = round(1.0 + total_stall_per_instr, 3)
    ipc = round(1.0 / cpi, 3)

    # Per 1000 instructions
    stalls_1k = {
        'load_use':  round(luh_contrib    * 1000),
        'branch':    round(branch_contrib * 1000),
        'mdu_mul':   round(mul_contrib    * 1000),
        'mdu_div':   round(div_contrib    * 1000),
        'mem_wait':  round(mem_contrib    * 1000),
    }
    total_stall_1k = sum(stalls_1k.values())

    return {
        'cpi': cpi,
        'ipc': ipc,
        'stall_cycles_per_1k': stalls_1k,
        'total_stall_per_1k':  total_stall_1k,
        'ideal_cpi': 1.0,
        'stall_overhead_pct': round(total_stall_per_instr / cpi * 100, 1),
    }

# ── Workload profiles ─────────────────────────────────────────────────────────
WORKLOAD_PROFILES = {
    'crypto': {
        'label': 'Crypto Workload (AES-256 / HMAC-SHA)',
        'description': (
            'AES-256-CTR cipher + PDF document HMAC. Dominated by XOR, shift, '
            'add, load/store. Very few MUL instructions, no DIV.'
        ),
        'load_pct':             20.0,   # % of instructions that are loads
        'load_use_hazard_rate':  0.35,  # fraction of loads followed by dependent use
        'branch_pct':           15.0,   # % of instructions that are branches
        'branch_taken_rate':     0.45,  # fraction of branches that are taken
        'mul_pct':               0.5,   # % MUL/MULH/MULHU/MULHSU
        'div_pct':               0.0,   # % DIV/DIVU/REM/REMU
        'mem_wait_pct':          0.5,   # % of instructions causing SRAM wait
    },
    'coremark': {
        'label': 'CoreMark / General Integer',
        'description': (
            'General integer benchmark with matrix multiply, linked-list, '
            'state machine. Higher MUL/DIV fraction, more branches.'
        ),
        'load_pct':             20.0,
        'load_use_hazard_rate':  0.40,
        'branch_pct':           18.0,
        'branch_taken_rate':     0.55,
        'mul_pct':               2.0,
        'div_pct':               0.5,
        'mem_wait_pct':          0.0,
    },
}

# ── Auto-find CPU core file ───────────────────────────────────────────────────
def find_core_file(all_files):
    """Return (abs_path, rel_path) for the main RV32IM pipeline core."""
    # Priority 1: file name matches rv32im_core
    for abs_p, rel_p, fname in all_files:
        if 'rv32im_core' in fname.lower():
            return abs_p, rel_p
    # Priority 2: file in core/ dir that mentions mdu_busy
    for abs_p, rel_p, fname in all_files:
        if '/core/' in rel_p:
            txt = read_file(abs_p)
            if 'mdu_busy' in txt and 'stall_if' in txt:
                return abs_p, rel_p
    # Priority 3: any file with pipeline stall signals
    for abs_p, rel_p, fname in all_files:
        txt = read_file(abs_p)
        if 'stall_if' in txt and 'stall_id' in txt and 'mdu_busy' in txt:
            return abs_p, rel_p
    return None, None

# ── Register / port counters ──────────────────────────────────────────────────
def count_ports(content):
    """Count input/output/inout ports in a module."""
    clean = strip_comments(content)
    inputs  = len(re.findall(r'\binput\b',  clean))
    outputs = len(re.findall(r'\boutput\b', clean))
    inouts  = len(re.findall(r'\binout\b',  clean))
    return {'input': inputs, 'output': outputs, 'inout': inouts, 'total': inputs+outputs+inouts}

def count_registers(content):
    """Estimate FF count from reg declarations."""
    clean = strip_comments(content)
    total_bits = 0
    for m in re.finditer(r'\breg\s*(?:\[(\d+):(\d+)\])?\s*(\w+)', clean):
        hi = int(m.group(1)) if m.group(1) else 0
        lo = int(m.group(2)) if m.group(2) else 0
        total_bits += (hi - lo + 1)
    return total_bits

# ── Main ──────────────────────────────────────────────────────────────────────
def main():
    print("=" * 64)
    print("CRIYA RTL Performance Analyser")
    print(f"  Project root : {PROJECT_ROOT}")
    print(f"  RTL dir      : {RTL_DIR}")
    print(f"  Output JSON  : {OUT_JSON}")
    print("=" * 64)

    # ── 1. Scan all RTL files ────────────────────────────────────────
    print("\n[1] Scanning RTL files ...")
    all_files = find_files()
    rtl_data = []
    total_loc = 0
    for abs_p, rel_p, fname in all_files:
        content = read_file(abs_p)
        stats = file_stats(content, rel_p)
        ports = count_ports(content)
        stats['ports'] = ports
        rtl_data.append(stats)
        total_loc += stats['loc']['total']
        print(f"    {rel_p:<60}  {stats['loc']['total']:>5} LOC")

    v_count  = sum(1 for _, r, _ in all_files if r.endswith('.v'))
    sv_count = sum(1 for _, r, _ in all_files if r.endswith('.sv'))
    total_code = sum(f['loc']['code'] for f in rtl_data)
    print(f"\n  Total: {len(all_files)} files  |  {total_loc:,} LOC  |"
          f"  {v_count} .v  {sv_count} .sv  |  {total_code:,} code lines")

    # ── 2. Find and parse the CPU core ──────────────────────────────
    print("\n[2] Finding CPU core file ...")
    core_abs, core_rel = find_core_file(all_files)
    if not core_abs:
        print("  [WARN] Could not auto-detect CPU core file — using defaults")
        core_content = ''
    else:
        core_content = read_file(core_abs)
        print(f"  Found: {core_rel}  ({len(core_content.splitlines())} lines)")

    # ── 3. Extract pipeline topology ────────────────────────────────
    print("\n[3] Extracting pipeline topology ...")
    pipeline = extract_pipeline(core_content)
    print(f"  Stages      : {pipeline['stages']} ({' → '.join(pipeline['stage_names'])})")
    print(f"  Stall sigs  : {pipeline['stall_signals']}")
    print(f"  Flush sigs  : {pipeline['flush_signals']}")
    print(f"  Forwarding  : {pipeline['forwarding']}")
    print(f"  Branch pen. : {pipeline['branch_flush_cycles']} cycles")
    print(f"  Load-use    : {pipeline['load_use_hazard']['stall_cycles']} cycle "
          f"({pipeline['load_use_hazard']['signal']})")

    # ── 4. Extract ISA coverage ──────────────────────────────────────
    print("\n[4] Extracting ISA coverage ...")
    isa = extract_isa(core_content)
    print(f"  ISA         : {isa['isa']}")
    print(f"  M-extension : {isa['has_m_extension']}")
    print(f"  Opcodes     : {len(isa['opcodes'])} OP_* constants")
    print(f"  MDU ops     : {list(isa['mdu_ops'].keys())}")
    print(f"  Perf CSRs   : {isa['perf_csrs']}")

    # ── 5. Analyse MDU latency ───────────────────────────────────────
    print("\n[5] Analysing MDU latency ...")
    mdu = extract_mdu_latency(core_content)
    print(f"  MUL stall   : {mdu['mul']['stall_cycles']} cycles  [{mdu['mul']['threshold_expr']}]")
    print(f"  DIV (signed): {mdu['div_signed']['stall_cycles']} cycles  [{mdu['div_signed']['threshold_expr']}]")
    print(f"  DIV (unsig) : {mdu['div_unsigned']['stall_cycles']} cycles  [{mdu['div_unsigned']['threshold_expr']}]")

    # ── 6. Calculate IPC / CPI for each workload ─────────────────────
    print("\n[6] Computing IPC / CPI ...")
    workloads = {}
    for key, profile in WORKLOAD_PROFILES.items():
        perf = calc_ipc_cpi(pipeline, mdu, profile)
        workloads[key] = {
            'label':       profile['label'],
            'description': profile['description'],
            'assumptions': {k: v for k, v in profile.items()
                            if k not in ('label', 'description')},
            **perf,
        }
        print(f"  {key:<12}: CPI={perf['cpi']:.3f}  IPC={perf['ipc']:.3f}  "
              f"stall={perf['total_stall_per_1k']} cyc/1k")

    # ── 7. Module-level register estimates for core ──────────────────
    print("\n[7] Register estimation for core ...")
    core_ff_bits = count_registers(core_content)
    print(f"  ~{core_ff_bits} register-bits in {core_rel or 'N/A'}")

    # ── 8. Assemble output JSON ──────────────────────────────────────
    output = {
        'generated_at': datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S'),
        'tool': 'collect_rtl_perf.py v1.0 — CRIYA SoC RTL Analyser',
        'source': {
            'rtl_dir':          RTL_DIR,
            'core_file':        core_rel,
            'parsed_from_rtl':  bool(core_content),
        },
        'rtl_summary': {
            'total_files':   len(all_files),
            'total_loc':     total_loc,
            'total_code_loc': total_code,
            'v_files':       v_count,
            'sv_files':      sv_count,
            'total_modules': sum(len(f['all_modules']) for f in rtl_data),
        },
        'pipeline':  pipeline,
        'isa':       isa,
        'mdu':       mdu,
        'workloads': workloads,
        'rtl_files': rtl_data,
    }

    os.makedirs(os.path.dirname(OUT_JSON), exist_ok=True)
    with open(OUT_JSON, 'w', encoding='utf-8') as fh:
        json.dump(output, fh, indent=2)

    # Verify
    with open(OUT_JSON, 'r', encoding='utf-8') as fh:
        json.load(fh)

    print(f"\n{'='*64}")
    print(f"Written: {OUT_JSON}")
    print(f"  Pipeline : {pipeline['stages']}-stage"
          f" ({' → '.join(pipeline['stage_names'])})"
          f" | forwarding={pipeline['forwarding']}")
    for key, wl in workloads.items():
        print(f"  {key:<12}: IPC={wl['ipc']:.3f}  CPI={wl['cpi']:.3f}")
    print(f"{'='*64}")

if __name__ == '__main__':
    main()
