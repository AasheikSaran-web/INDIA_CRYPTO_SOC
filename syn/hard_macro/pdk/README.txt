================================================================================
syn/hard_macro/pdk/  —  Hard-Macro Timing Models
INDIA_CRYPTO_SOC / TSMC 28nm HPC+
================================================================================

Place the following .db (Synopsys Liberty binary) files in this directory
before running synth_hm_300mhz.tcl.  They are NOT checked into git because
they are under PDK/IP NDA.

--------------------------------------------------------------------------------
1. SRAM — ARM Artisan  TS1N28HPCPSVTB16384X32M8SW
--------------------------------------------------------------------------------
  Expected filename  : TS1N28HPCPSVTB16384X32M8SW_tt0p9v25c.db
  Source             : TSMC memory-compiler output for the typical corner.
                       Run the ARM Artisan memory compiler targeting
                       TSMC 28nm HPC+ SVT, 16384 words × 32 bits, 8-mux.
  Signoff corner .db : TS1N28HPCPSVTB16384X32M8SW_ss0p81v125c.db
  Also place LEF     : TS1N28HPCPSVTB16384X32M8SW.lef  (for P&R)

  Macro instantiation name in RTL:
    india_crypto_soc
      └─ u_sram_ctrl          (sram_ctrl.v)
           └─ u_sram          (sram_sp_wrap.v)
                └─ u_sram_macro  (TS1N28HPCPSVTB16384X32M8SW)

--------------------------------------------------------------------------------
2. PULP Peripheral IP (optional — blackbox timing for STA completeness)
--------------------------------------------------------------------------------
  apb_uart_tt0p9v25c.db          from PULP Platform or ETH Zürich release
  apb_spi_master_tt0p9v25c.db
  apb_i2c_tt0p9v25c.db

  Without these, DC will treat the PULP blocks as black-boxes with
  unconstrained I/O — synthesis will still complete, but timing through
  those blocks will not be signed off.

  To add them: uncomment the PULP_*_DB lines in synth_hm_300mhz.tcl and
  add them to link_library.

--------------------------------------------------------------------------------
3. TSMC 28nm HPC+ Standard-Cell Library (not stored here)
--------------------------------------------------------------------------------
  The standard-cell .db is referenced via PDK_LIB_DIR in synth_hm_300mhz.tcl.
  It is assumed to be installed at:
    /pdk/tsmc28nm/tcbn28hpcplusbwp30p140_190a/...

  Adjust the path in the TCL script if your server has a different mount point.

--------------------------------------------------------------------------------
Corner mapping summary
--------------------------------------------------------------------------------
  Synthesis compile  : TT / 0.9V / 25°C   (typical — fast compile)
  Timing signoff     : SS / 0.81V / 125°C  (worst-case — uncomment in SDC)
  Hold signoff       : FF / 0.99V / -40°C  (best-case — separate run needed)

================================================================================
