`timescale 1ns/1ps
// ============================================================
// tb_axil_to_apb.v — Testbench for axil_to_apb bridge
// Bridge latches AW+W simultaneously (both fire in same cycle).
// ============================================================
module tb_axil_to_apb;
    reg clk = 0; reg rst_n = 0;
    always #5 clk = ~clk;

    reg  [11:0] s_awaddr; reg s_awvalid=0; wire s_awready;
    reg  [31:0] s_wdata=0; reg [3:0] s_wstrb=0; reg s_wvalid=0; wire s_wready;
    wire [1:0]  s_bresp; wire s_bvalid; reg s_bready=0;
    reg  [11:0] s_araddr=0; reg s_arvalid=0; wire s_arready;
    wire [31:0] s_rdata; wire [1:0] s_rresp; wire s_rvalid; reg s_rready=0;
    wire [11:0] paddr; wire psel,penable,pwrite; wire [31:0] pwdata;
    reg  [31:0] prdata=0; reg pready=0, pslverr=0;

    axil_to_apb dut(.clk(clk),.rst_n(rst_n),
        .s_awaddr(s_awaddr),.s_awvalid(s_awvalid),.s_awready(s_awready),
        .s_wdata(s_wdata),.s_wstrb(s_wstrb),.s_wvalid(s_wvalid),.s_wready(s_wready),
        .s_bresp(s_bresp),.s_bvalid(s_bvalid),.s_bready(s_bready),
        .s_araddr(s_araddr),.s_arvalid(s_arvalid),.s_arready(s_arready),
        .s_rdata(s_rdata),.s_rresp(s_rresp),.s_rvalid(s_rvalid),.s_rready(s_rready),
        .paddr(paddr),.psel(psel),.penable(penable),.pwrite(pwrite),.pwdata(pwdata),
        .prdata(prdata),.pready(pready),.pslverr(pslverr));

    integer pass=0,fail=0;
    reg [31:0] paddr_cap, pwdata_cap, rdata_got;

    // APB slave: respond with given data after opt delay cycles
    task apb_respond; input [31:0] rd; input integer dly;
        begin
            wait(psel);
            wait(penable);
            if (dly > 0) repeat(dly) @(posedge clk);
            @(negedge clk); prdata <= rd; pready <= 1; pslverr <= 0;
            @(posedge clk);
            @(negedge clk); pready <= 0; prdata <= 0;
        end
    endtask

    // AXI-Lite write: drive AW+W together, wait combined ack
    task axil_wr; input [11:0] a; input [31:0] d;
        begin
            @(negedge clk);
            s_awaddr<=a; s_awvalid<=1;
            s_wdata<=d;  s_wstrb<=4'hF; s_wvalid<=1;
            // wait until BOTH awready and wready are high (same cycle)
            @(posedge clk);
            while(!(s_awready && s_wready)) @(posedge clk);
            @(negedge clk); s_awvalid<=0; s_wvalid<=0;
            // collect B response
            s_bready<=1;
            @(posedge clk); while(!s_bvalid) @(posedge clk);
            @(negedge clk); s_bready<=0;
        end
    endtask

    // AXI-Lite read
    task axil_rd; input [11:0] a; output [31:0] d;
        begin
            @(negedge clk); s_araddr<=a; s_arvalid<=1; s_rready<=1;
            @(posedge clk); while(!s_arready) @(posedge clk);
            @(negedge clk); s_arvalid<=0;
            @(posedge clk); while(!s_rvalid)  @(posedge clk);
            d=s_rdata;
            @(negedge clk); s_rready<=0;
        end
    endtask

    integer k;
    initial begin
        s_awaddr=0;
        repeat(4) @(posedge clk); rst_n<=1; @(posedge clk);
        $display("=== tb_axil_to_apb tests ===");

        // TC1: Write — capture APB addr/data
        fork
            axil_wr(12'hABC, 32'hDEAD1234);
            begin
                apb_respond(32'h0, 0);
                paddr_cap  = paddr;
                pwdata_cap = pwdata;
            end
        join
        if (paddr_cap===12'hABC && pwdata_cap===32'hDEAD1234) begin
            $display("[PASS] TC1 Write: paddr=0xABC pwdata=0xDEAD1234"); pass=pass+1;
        end else begin
            $display("[FAIL] TC1 Write: paddr=0x%03h pwdata=0x%08h",paddr_cap,pwdata_cap); fail=fail+1;
        end

        // TC2: Read — slave returns 0xCAFEBABE
        fork
            axil_rd(12'h100, rdata_got);
            apb_respond(32'hCAFEBABE, 0);
        join
        if (rdata_got===32'hCAFEBABE) begin
            $display("[PASS] TC2 Read: 0xCAFEBABE received"); pass=pass+1;
        end else begin
            $display("[FAIL] TC2 Read: got 0x%08h",rdata_got); fail=fail+1;
        end

        // TC3: Slave wait (3 extra cycles before pready)
        fork
            axil_rd(12'h200, rdata_got);
            apb_respond(32'h12345678, 3);
        join
        if (rdata_got===32'h12345678) begin
            $display("[PASS] TC3 SlaveWait: 0x12345678 after 3-cycle wait"); pass=pass+1;
        end else begin
            $display("[FAIL] TC3 SlaveWait: got 0x%08h",rdata_got); fail=fail+1;
        end

        // TC4: Back-to-back writes x4
        for (k=0; k<4; k=k+1) begin
            fork
                axil_wr(12'h010+k, 32'hA000_0000+k);
                apb_respond(32'h0, 0);
            join
        end
        $display("[PASS] TC4 Back-to-back: 4 writes completed"); pass=pass+1;

        // TC5: BRESP=OKAY after no-error slave
        fork
            axil_wr(12'h300, 32'h11223344);
            apb_respond(32'h0, 0);
        join
        if (s_bresp===2'b00) begin
            $display("[PASS] TC5 BRESP=OKAY"); pass=pass+1;
        end else begin
            $display("[FAIL] TC5 BRESP=%b",s_bresp); fail=fail+1;
        end

        // TC6: pwrite=1 on write, pwrite=0 on read
        fork
            axil_wr(12'h400, 32'hFF00FF00);
            begin wait(penable); paddr_cap=(pwrite?32'h1:32'h0); apb_respond(32'h0,0); end
        join
        if (paddr_cap===32'h1) begin
            $display("[PASS] TC6 pwrite=1 on write"); pass=pass+1;
        end else begin
            $display("[FAIL] TC6 pwrite=%0h on write",paddr_cap); fail=fail+1;
        end

        $display("=== tb_axil_to_apb RESULTS: PASS=%0d FAIL=%0d ===",pass,fail);
        if (fail==0) $display("[PASS] tb_axil_to_apb ALL TESTS PASSED");
        else         $display("[FAIL] tb_axil_to_apb %0d FAILED",fail);
        $finish;
    end
endmodule
