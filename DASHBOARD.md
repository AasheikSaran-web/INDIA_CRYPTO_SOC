# INDIA_CRYPTO_SOC — Interactive Dashboards

Three browser-based dashboards covering DV results, RTL metrics, and synthesis PPA for the CRIYA AES-CA RISC-V SoC.

---

## Live Public Dashboards (GitHub Pages)

Once GitHub Pages is enabled (one-time setup below), the dashboards are always accessible at:

| Dashboard | URL |
|---|---|
| **DV Results** | `https://AasheikSaran-web.github.io/INDIA_CRYPTO_SOC/` |
| **RTL Metrics** | `https://AasheikSaran-web.github.io/INDIA_CRYPTO_SOC/rtl_dashboard.html` |
| **Synthesis PPA** | `https://AasheikSaran-web.github.io/INDIA_CRYPTO_SOC/syn_dashboard.html` |

> No server required — these are static HTML files served over HTTPS from GitHub's CDN.

---

## Enable GitHub Pages (one-time, 2 minutes)

1. Go to **[https://github.com/AasheikSaran-web/INDIA_CRYPTO_SOC/settings/pages](https://github.com/AasheikSaran-web/INDIA_CRYPTO_SOC/settings/pages)**
2. Under **Source**, select:
   - Branch: `main`
   - Folder: `/docs`
3. Click **Save**
4. Wait ~60 seconds — a green banner confirms the site is live at the URL above

Every time you push a new commit that updates files in `docs/`, the live site refreshes automatically within ~30 seconds.

---

## What Each Dashboard Shows

### DV Results (`index.html`)
- Pass/fail summary across all test categories (directed SW tests, UVM, riscv-dv random, formal)
- Per-test status table with duration and UVM error/warning counts
- Pass-rate trend chart over recent runs
- Coverage hole callouts

### RTL Metrics (`rtl_dashboard.html`)
- Lines of code per module and per subsystem
- Module count, parameter count, estimated flip-flop count
- Lint summary (Verilator / Spyglass lint codes)
- Area breakdown donut chart (from synthesis reports)
- Per-module area table with hierarchy

### Synthesis PPA (`syn_dashboard.html`)
- Timing: WNS/TNS setup, hold violations, Fmax estimate (352 MHz)
- Power: total / internal / switching / leakage breakdown
- Area: stdcell vs SRAM, total 36,110 µm² on TSMC 28nm HPC+
- DRC and signoff status

---

## Generate Fresh Dashboards Locally

When you run your own simulations or resynthesise, regenerate the JSON data files and copy them to `docs/` to update both local and public views.

### Prerequisites

```bash
# Python 3.8+ (no extra packages needed — all stdlib)
python3 --version

# Clone the repo
git clone https://github.com/AasheikSaran-web/INDIA_CRYPTO_SOC.git
cd INDIA_CRYPTO_SOC
```

### Step 1 — Regenerate DV results JSON

Reads simulation logs from `sim_out/` and writes `dv/dashboard/results.json`.

```bash
cd dv
python3 dashboard/collect_results.py
```

Expected output:
```
[collect_results] Written .../dv/dashboard/results.json
  Total: 42  PASS: 40  FAIL: 2
```

### Step 2 — Regenerate RTL metrics JSON

Scans every `.v`/`.sv` file in `rtl/` and synthesis reports in `syn/reports/`, writes `dv/dashboard/rtl_metrics.json`.

```bash
cd dv/dashboard
python3 collect_rtl_metrics.py
```

### Step 3 — Regenerate RTL performance JSON

Parses pipeline registers, MDU latencies, ISA coverage, and forwarding paths from RTL source, writes `dv/dashboard/rtl_perf.json`.

```bash
cd INDIA_CRYPTO_SOC          # project root
python3 dv/dashboard/collect_rtl_perf.py
```

### Step 4 — Copy updated JSON into docs/ (updates public site)

```bash
cd INDIA_CRYPTO_SOC
cp dv/dashboard/results.json     docs/results.json
cp dv/dashboard/rtl_metrics.json docs/rtl_metrics.json
cp dv/dashboard/rtl_perf.json    docs/rtl_perf.json
```

### Step 5 — Commit and push to publish

```bash
git add docs/
git commit -m "dashboard: refresh DV/RTL/synth data $(date +%Y-%m-%d)"
git push origin main
# GitHub Pages updates within ~30 seconds
```

---

## View Dashboards Locally (no internet needed)

The HTML files embed all their CSS and JavaScript inline — no build step, no npm, no Node required.

```bash
# Option A: Python built-in server (recommended)
cd dv/dashboard
python3 serve.py
# Open http://localhost:8080

# Option B: Direct file open (works for RTL and Synthesis dashboards)
open dv/dashboard/rtl_dashboard.html      # macOS
xdg-open dv/dashboard/rtl_dashboard.html  # Linux
start dv/dashboard/rtl_dashboard.html     # Windows

# Option C: Python one-liner
cd dv/dashboard && python3 -m http.server 8080
# Open http://localhost:8080
```

> **Note:** `index.html` (DV dashboard) fetches `results.json` via XHR — it requires the Python server (Options A or C). The RTL and Synthesis dashboards embed their data and open directly from the filesystem.

---

## Self-Host on Any HTTPS Server

The `docs/` folder is a self-contained static site. Copy it to any web host:

### Netlify (drag-and-drop, free tier)
1. Go to [app.netlify.com/drop](https://app.netlify.com/drop)
2. Drag the `docs/` folder into the browser
3. Get an `https://random-name.netlify.app` URL immediately

### Netlify connected to this repo (auto-deploy)
```toml
# netlify.toml at project root
[build]
  publish = "docs"
```
Connect the repo at [app.netlify.com](https://app.netlify.com) → every push auto-deploys.

### Vercel
```bash
npm i -g vercel
cd docs && vercel --prod
```

### GitHub Codespaces / local ngrok tunnel
```bash
cd dv/dashboard && python3 -m http.server 8080
# In another terminal:
ngrok http 8080
# Gives you a public https://xxxx.ngrok.io URL
```

---

## Dashboard File Map

```
INDIA_CRYPTO_SOC/
│
├── docs/                          ← GitHub Pages root (public HTTPS)
│   ├── index.html                 DV Results dashboard
│   ├── rtl_dashboard.html         RTL Metrics dashboard
│   ├── syn_dashboard.html         Synthesis PPA dashboard
│   ├── results.json               DV test results (generated by collect_results.py)
│   ├── rtl_metrics.json           RTL metrics data (generated by collect_rtl_metrics.py)
│   └── rtl_perf.json              RTL performance data (generated by collect_rtl_perf.py)
│
└── dv/dashboard/                  ← Source files (generators + live HTML)
    ├── index.html                 DV Results dashboard (source)
    ├── rtl_dashboard.html         RTL Metrics dashboard (source)
    ├── syn_dashboard.html         Synthesis PPA dashboard (source)
    ├── results.json               DV test results (source)
    ├── rtl_metrics.json           RTL metrics data (source)
    ├── rtl_perf.json              RTL performance data (source)
    ├── collect_results.py         Parses sim_out/ → results.json
    ├── collect_rtl_metrics.py     Parses rtl/ + syn/reports/ → rtl_metrics.json
    ├── collect_rtl_perf.py        Analyses RTL pipeline → rtl_perf.json
    └── serve.py                   Local dev server at http://localhost:8080
```

> **Workflow:** Generate JSON in `dv/dashboard/` → copy to `docs/` → push → public site updates.

---

## Technology Stack

| Component | Technology |
|---|---|
| Charts | [Chart.js 4.4](https://www.chartjs.org/) via CDN |
| Styling | Pure CSS (no framework) — inline in HTML |
| Data | JSON files loaded via `fetch()` |
| Server | Python `http.server` (stdlib, zero dependencies) |
| Hosting | GitHub Pages (static, HTTPS, free) |
| Generators | Python 3 stdlib only (`os`, `re`, `json`, `glob`) |
