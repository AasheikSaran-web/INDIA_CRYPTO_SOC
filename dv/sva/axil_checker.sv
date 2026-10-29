`timescale 1ns/1ps
// =============================================================================
// axil_checker.sv  —  AXI-Lite protocol checker (SVA)
//
// Instantiate this module in your testbench and connect to an AXI-Lite
// master/slave port pair to verify protocol compliance.
// =============================================================================

module axil_checker #(
    parameter integer DATA_W = 32,
    parameter integer ADDR_W = 32
)(
    input  wire              clk,
    input  wire              rst_n,

    // Write address channel
    input  wire              awvalid,
    input  wire              awready,
    input  wire [ADDR_W-1:0] awaddr,

    // Write data channel
    input  wire              wvalid,
    input  wire              wready,
    input  wire [DATA_W-1:0] wdata,
    input  wire [DATA_W/8-1:0] wstrb,

    // Write response channel
    input  wire              bvalid,
    input  wire              bready,
    input  wire [1:0]        bresp,

    // Read address channel
    input  wire              arvalid,
    input  wire              arready,
    input  wire [ADDR_W-1:0] araddr,

    // Read data channel
    input  wire              rvalid,
    input  wire              rready,
    input  wire [DATA_W-1:0] rdata,
    input  wire [1:0]        rresp
);

`ifdef SYNTHESIS
`else

// ---------------------------------------------------------------------------
// Default clocking / disable iff reset
// ---------------------------------------------------------------------------
default clocking cb @(posedge clk);
endclocking

// ---------------------------------------------------------------------------
// Property: valid signals must not be X or Z after reset deasserts
// ---------------------------------------------------------------------------
property p_no_x_awvalid;
    @(posedge clk) disable iff (!rst_n)
    !$isunknown(awvalid);
endproperty

property p_no_x_wvalid;
    @(posedge clk) disable iff (!rst_n)
    !$isunknown(wvalid);
endproperty

property p_no_x_arvalid;
    @(posedge clk) disable iff (!rst_n)
    !$isunknown(arvalid);
endproperty

property p_no_x_bvalid;
    @(posedge clk) disable iff (!rst_n)
    !$isunknown(bvalid);
endproperty

property p_no_x_rvalid;
    @(posedge clk) disable iff (!rst_n)
    !$isunknown(rvalid);
endproperty

axil_no_x_awvalid: assert property (p_no_x_awvalid)
    else $error("[axil_checker] AWVALID is X/Z at %0t", $time);

axil_no_x_wvalid: assert property (p_no_x_wvalid)
    else $error("[axil_checker] WVALID is X/Z at %0t", $time);

axil_no_x_arvalid: assert property (p_no_x_arvalid)
    else $error("[axil_checker] ARVALID is X/Z at %0t", $time);

axil_no_x_bvalid: assert property (p_no_x_bvalid)
    else $error("[axil_checker] BVALID is X/Z at %0t", $time);

axil_no_x_rvalid: assert property (p_no_x_rvalid)
    else $error("[axil_checker] RVALID is X/Z at %0t", $time);

// ---------------------------------------------------------------------------
// Property: once AWVALID asserted, must hold until AWREADY
// ---------------------------------------------------------------------------
property p_awvalid_stable;
    @(posedge clk) disable iff (!rst_n)
    (awvalid && !awready) |=> awvalid;
endproperty

axil_awvalid_stable: assert property (p_awvalid_stable)
    else $error("[axil_checker] AWVALID de-asserted before AWREADY at %0t", $time);

// ---------------------------------------------------------------------------
// Property: once WVALID asserted, must hold until WREADY
// ---------------------------------------------------------------------------
property p_wvalid_stable;
    @(posedge clk) disable iff (!rst_n)
    (wvalid && !wready) |=> wvalid;
endproperty

axil_wvalid_stable: assert property (p_wvalid_stable)
    else $error("[axil_checker] WVALID de-asserted before WREADY at %0t", $time);

// ---------------------------------------------------------------------------
// Property: once ARVALID asserted, must hold until ARREADY
// ---------------------------------------------------------------------------
property p_arvalid_stable;
    @(posedge clk) disable iff (!rst_n)
    (arvalid && !arready) |=> arvalid;
endproperty

axil_arvalid_stable: assert property (p_arvalid_stable)
    else $error("[axil_checker] ARVALID de-asserted before ARREADY at %0t", $time);

// ---------------------------------------------------------------------------
// Property: after write addr + data accepted, BVALID must come within 32 cycles
// ---------------------------------------------------------------------------
property p_bvalid_after_write;
    @(posedge clk) disable iff (!rst_n)
    (awvalid && awready && wvalid && wready) |-> ##[1:32] bvalid;
endproperty

axil_bvalid_after_write: assert property (p_bvalid_after_write)
    else $error("[axil_checker] BVALID not seen within 32 cycles after write at %0t", $time);

// ---------------------------------------------------------------------------
// Property: after read address accepted, RVALID must come within 32 cycles
// ---------------------------------------------------------------------------
property p_rvalid_after_read;
    @(posedge clk) disable iff (!rst_n)
    (arvalid && arready) |-> ##[1:32] rvalid;
endproperty

axil_rvalid_after_read: assert property (p_rvalid_after_read)
    else $error("[axil_checker] RVALID not seen within 32 cycles after read at %0t", $time);

// ---------------------------------------------------------------------------
// Property: BRESP and RRESP must be OKAY (2'b00)
// ---------------------------------------------------------------------------
property p_bresp_ok;
    @(posedge clk) disable iff (!rst_n)
    bvalid |-> (bresp == 2'b00);
endproperty

property p_rresp_ok;
    @(posedge clk) disable iff (!rst_n)
    rvalid |-> (rresp == 2'b00);
endproperty

axil_bresp_ok: assert property (p_bresp_ok)
    else $error("[axil_checker] Non-OKAY BRESP=0x%0x at %0t", bresp, $time);

axil_rresp_ok: assert property (p_rresp_ok)
    else $error("[axil_checker] Non-OKAY RRESP=0x%0x at %0t", rresp, $time);

// ---------------------------------------------------------------------------
// Cover points
// ---------------------------------------------------------------------------
cov_write_xact: cover property (
    @(posedge clk) disable iff (!rst_n)
    (awvalid && awready) ##[0:4] (wvalid && wready) ##[1:32] (bvalid && bready));

cov_read_xact: cover property (
    @(posedge clk) disable iff (!rst_n)
    (arvalid && arready) ##[1:32] (rvalid && rready));

`endif // SYNTHESIS

endmodule
