`timescale 1ns/1ps

// tb_sram_ctrl: hardware module definition
module tb_sram_ctrl;
    reg clk;
    reg rst_n;

    // Simulation initialisation or stimulus block
    initial clk = 0;
    // Combinational logic output computation
    always #5 clk = ~clk;
    reg         cpu_arvalid;
    reg  [31:0] cpu_araddr;
    wire        cpu_arready;
    wire        cpu_rvalid;
    wire [31:0] cpu_rdata;
    wire [1:0]  cpu_rresp;
    reg         cpu_rready;
    reg         axi_awvalid;
    reg  [31:0] axi_awaddr;
    wire        axi_awready;
    reg         axi_wvalid;
    reg  [31:0] axi_wdata;
    reg  [3:0]  axi_wstrb;
    wire        axi_wready;
    wire        axi_bvalid;
    wire [1:0]  axi_bresp;
    reg         axi_bready;
    reg         axi_arvalid;
    reg  [31:0] axi_araddr;
    wire        axi_arready;
    wire        axi_rvalid;
    wire [31:0] axi_rdata;
    wire [1:0]  axi_rresp;
    reg         axi_rready;
    sram_ctrl dut (
        .clk          (clk),
        .rst_n        (rst_n),
        .cpu_arvalid  (cpu_arvalid),
        .cpu_araddr   (cpu_araddr),
        .cpu_arready  (cpu_arready),
        .cpu_rvalid   (cpu_rvalid),
        .cpu_rdata    (cpu_rdata),
        .cpu_rresp    (cpu_rresp),
        .cpu_rready   (cpu_rready),
        .axi_awvalid  (axi_awvalid),
        .axi_awaddr   (axi_awaddr),
        .axi_awready  (axi_awready),
        .axi_wvalid   (axi_wvalid),
        .axi_wdata    (axi_wdata),
        .axi_wstrb    (axi_wstrb),
        .axi_wready   (axi_wready),
        .axi_bvalid   (axi_bvalid),
        .axi_bresp    (axi_bresp),
        .axi_bready   (axi_bready),
        .axi_arvalid  (axi_arvalid),
        .axi_araddr   (axi_araddr),
        .axi_arready  (axi_arready),
        .axi_rvalid   (axi_rvalid),
        .axi_rdata    (axi_rdata),
        .axi_rresp    (axi_rresp),
        .axi_rready   (axi_rready)
    );
    // idle_all: reusable simulation task
    task idle_all;
        begin
            cpu_arvalid  = 1'b0;
            cpu_araddr   = 32'h0;
            cpu_rready   = 1'b1;
            axi_awvalid  = 1'b0;
            axi_awaddr   = 32'h0;
            axi_wvalid   = 1'b0;
            axi_wdata    = 32'h0;
            axi_wstrb    = 4'hF;
            axi_bready   = 1'b1;
            axi_arvalid  = 1'b0;
            axi_araddr   = 32'h0;
            axi_rready   = 1'b1;
        end
    endtask
    // axi_write: reusable simulation task
    task axi_write;
        input [31:0] a;
        input [31:0] d;
        input [3:0]  s;
        reg aw_done;
        reg w_done;
        begin
            aw_done = 1'b0;
            w_done  = 1'b0;

            @(negedge clk);
            axi_awvalid = 1'b1;
            axi_awaddr  = a;
            axi_wvalid  = 1'b1;
            axi_wdata   = d;
            axi_wstrb   = s;
            while (!(aw_done && w_done)) begin
                @(posedge clk); #1;
                if (axi_awready) begin
                    axi_awvalid = 1'b0;
                    aw_done = 1'b1;
                end
                if (axi_wready) begin
                    axi_wvalid  = 1'b0;
                    w_done = 1'b1;
                end
            end
            @(posedge clk);
            while (!axi_bvalid) @(posedge clk);
            @(negedge clk);
            idle_all;
        end
    endtask
    // axi_read: reusable simulation task
    task axi_read;
        input  [31:0] a;
        output [31:0] d;
        begin
            @(negedge clk);
            axi_arvalid = 1'b1;
            axi_araddr  = a;

            @(posedge clk);
            while (!axi_arready) @(posedge clk);
            #1;
            axi_arvalid = 1'b0;
            axi_araddr  = 32'h0;

            @(posedge clk);
            while (!axi_rvalid) @(posedge clk);
            d = axi_rdata;
            @(negedge clk);
        end
    endtask
    // cpu_read: reusable simulation task
    task cpu_read;
        input  [31:0] a;
        output [31:0] d;
        begin
            @(negedge clk);
            cpu_arvalid = 1'b1;
            cpu_araddr  = a;

            @(posedge clk);
            while (!cpu_arready) @(posedge clk);
            #1;
            cpu_arvalid = 1'b0;
            cpu_araddr  = 32'h0;

            @(posedge clk);
            while (!cpu_rvalid) @(posedge clk);
            d = cpu_rdata;
            @(negedge clk);
        end
    endtask
    integer pass_cnt;
    integer fail_cnt;

    // check: reusable simulation task
    task check;
        input [127:0] tc_name;
        input [31:0]  got;
        input [31:0]  exp;
        begin
            if (got === exp) begin
                $display("[PASS] %0s  got=0x%08X exp=0x%08X", tc_name, got, exp);
                pass_cnt = pass_cnt + 1;
            end else begin
                $display("[FAIL] %0s  got=0x%08X exp=0x%08X", tc_name, got, exp);
                fail_cnt = fail_cnt + 1;
            end
        end
    endtask
    reg [31:0] rd_data;
    integer    i;
    integer    delay_cyc;
    reg        bvalid_held;
    // Simulation initialisation or stimulus block
    initial begin
        pass_cnt = 0;
        fail_cnt = 0;
        idle_all;
        rst_n = 1'b0;
        repeat(5) @(posedge clk);
        #1;
        rst_n = 1'b1;
        @(posedge clk); #1;
        axi_write(32'h0000_0000, 32'hDEAD_BEEF, 4'hF);
        axi_read (32'h0000_0000, rd_data);
        check("TC01", rd_data, 32'hDEAD_BEEF);

        axi_write(32'h0000_0004, 32'hCAFE_BABE, 4'hF);
        axi_read (32'h0000_0004, rd_data);
        check("TC02", rd_data, 32'hCAFE_BABE);

        axi_write(32'h0000_0008, 32'h1234_5678, 4'hF);
        axi_read (32'h0000_0008, rd_data);
        check("TC03", rd_data, 32'h1234_5678);

        axi_write(32'h0000_000C, 32'hABCD_EF01, 4'hF);
        axi_read (32'h0000_000C, rd_data);
        check("TC04", rd_data, 32'hABCD_EF01);

        axi_write(32'h0000_0010, 32'h5A5A_5A5A, 4'hF);
        axi_read (32'h0000_0010, rd_data);
        check("TC05", rd_data, 32'h5A5A_5A5A);
        cpu_read(32'h0000_0000, rd_data);
        check("TC06", rd_data, 32'hDEAD_BEEF);

        cpu_read(32'h0000_0004, rd_data);
        check("TC07", rd_data, 32'hCAFE_BABE);

        cpu_read(32'h0000_0008, rd_data);
        check("TC08", rd_data, 32'h1234_5678);

        cpu_read(32'h0000_000C, rd_data);
        check("TC09", rd_data, 32'hABCD_EF01);

        cpu_read(32'h0000_0010, rd_data);
        check("TC10", rd_data, 32'h5A5A_5A5A);
        axi_write(32'h0000_0100, 32'hBB00_0001, 4'hF);
        axi_write(32'h0000_0104, 32'hBB00_0002, 4'hF);
        axi_write(32'h0000_0108, 32'hBB00_0003, 4'hF);
        axi_write(32'h0000_010C, 32'hBB00_0004, 4'hF);
        axi_write(32'h0000_0110, 32'hBB00_0005, 4'hF);

        axi_read(32'h0000_0100, rd_data); check("TC11", rd_data, 32'hBB00_0001);
        axi_read(32'h0000_0104, rd_data); check("TC12", rd_data, 32'hBB00_0002);
        axi_read(32'h0000_0108, rd_data); check("TC13", rd_data, 32'hBB00_0003);
        axi_read(32'h0000_010C, rd_data); check("TC14", rd_data, 32'hBB00_0004);
        axi_read(32'h0000_0110, rd_data); check("TC15", rd_data, 32'hBB00_0005);
        axi_write(32'h0000_0200, 32'hCC00_0001, 4'hF);
        axi_write(32'h0000_0204, 32'hCC00_0002, 4'hF);
        axi_write(32'h0000_0208, 32'hCC00_0003, 4'hF);
        axi_write(32'h0000_020C, 32'hCC00_0004, 4'hF);
        axi_write(32'h0000_0210, 32'hCC00_0005, 4'hF);

        axi_read(32'h0000_0200, rd_data); check("TC16", rd_data, 32'hCC00_0001);
        axi_read(32'h0000_0204, rd_data); check("TC17", rd_data, 32'hCC00_0002);
        axi_read(32'h0000_0208, rd_data); check("TC18", rd_data, 32'hCC00_0003);
        axi_read(32'h0000_020C, rd_data); check("TC19", rd_data, 32'hCC00_0004);
        axi_read(32'h0000_0210, rd_data); check("TC20", rd_data, 32'hCC00_0005);
        axi_write(32'h0000_0300, 32'hDD00_0001, 4'hF);
        axi_read (32'h0000_0300, rd_data); check("TC21", rd_data, 32'hDD00_0001);

        axi_write(32'h0000_0400, 32'hDD00_0002, 4'hF);
        axi_read (32'h0000_0300, rd_data); check("TC22", rd_data, 32'hDD00_0001);

        axi_write(32'h0000_0500, 32'hDD00_0003, 4'hF);
        axi_read (32'h0000_0400, rd_data); check("TC23", rd_data, 32'hDD00_0002);

        axi_write(32'h0000_0600, 32'hDD00_0004, 4'hF);
        axi_read (32'h0000_0500, rd_data); check("TC24", rd_data, 32'hDD00_0003);

        axi_write(32'h0000_0700, 32'hDD00_0005, 4'hF);
        axi_read (32'h0000_0600, rd_data); check("TC25", rd_data, 32'hDD00_0004);
        axi_write(32'h0000_0800, 32'hEE00_0001, 4'hF);
        axi_read (32'h0000_0800, rd_data); check("TC26", rd_data, 32'hEE00_0001);

        axi_write(32'h0000_0804, 32'hEE00_0002, 4'hF);
        axi_read (32'h0000_0804, rd_data); check("TC27", rd_data, 32'hEE00_0002);

        axi_write(32'h0000_0808, 32'hEE00_0003, 4'hF);
        axi_read (32'h0000_0808, rd_data); check("TC28", rd_data, 32'hEE00_0003);

        axi_write(32'h0000_080C, 32'hEE00_0004, 4'hF);
        axi_read (32'h0000_080C, rd_data); check("TC29", rd_data, 32'hEE00_0004);

        axi_write(32'h0000_0810, 32'hEE00_0005, 4'hF);
        axi_read (32'h0000_0810, rd_data); check("TC30", rd_data, 32'hEE00_0005);
        axi_write(32'h0000_0900, 32'h0000_0000, 4'hF);
        axi_write(32'h0000_0900, 32'h0000_00AB, 4'b0001);
        axi_read (32'h0000_0900, rd_data);
        check("TC31", rd_data & 32'h0000_00FF, 32'h0000_00AB);
        axi_write(32'h0000_0900, 32'h0000_CD00, 4'b0010);
        axi_read (32'h0000_0900, rd_data);
        check("TC32", rd_data & 32'h0000_FF00, 32'h0000_CD00);
        axi_write(32'h0000_0900, 32'h00EF_0000, 4'b0100);
        axi_read (32'h0000_0900, rd_data);
        check("TC33", rd_data & 32'h00FF_0000, 32'h00EF_0000);
        axi_write(32'h0000_0900, 32'h7600_0000, 4'b1000);
        axi_read (32'h0000_0900, rd_data);
        check("TC34", rd_data & 32'hFF00_0000, 32'h7600_0000);
        axi_read (32'h0000_0900, rd_data);
        check("TC35", rd_data, 32'h76EF_CDAB);
        axi_write(32'h0000_0A00, 32'hFF00_0001, 4'hF);
        cpu_read (32'h0000_0A00, rd_data); check("TC36", rd_data, 32'hFF00_0001);

        axi_write(32'h0000_0A04, 32'hFF00_0002, 4'hF);
        cpu_read (32'h0000_0A04, rd_data); check("TC37", rd_data, 32'hFF00_0002);

        axi_write(32'h0000_0A08, 32'hFF00_0003, 4'hF);
        cpu_read (32'h0000_0A08, rd_data); check("TC38", rd_data, 32'hFF00_0003);

        axi_write(32'h0000_0A0C, 32'hFF00_0004, 4'hF);
        cpu_read (32'h0000_0A0C, rd_data); check("TC39", rd_data, 32'hFF00_0004);

        axi_write(32'h0000_0A10, 32'hFF00_0005, 4'hF);
        cpu_read (32'h0000_0A10, rd_data); check("TC40", rd_data, 32'hFF00_0005);
        axi_write(32'h0000_0B00, 32'hAA11_0001, 4'hF);
        axi_write(32'h0000_0B04, 32'hAA11_0002, 4'hF);
        axi_write(32'h0000_0B08, 32'hAA11_0003, 4'hF);
        axi_write(32'h0000_0B0C, 32'hAA11_0004, 4'hF);
        axi_write(32'h0000_0B10, 32'hAA11_0005, 4'hF);

        cpu_read(32'h0000_0B00, rd_data); check("TC41", rd_data, 32'hAA11_0001);
        cpu_read(32'h0000_0B04, rd_data); check("TC42", rd_data, 32'hAA11_0002);
        cpu_read(32'h0000_0B08, rd_data); check("TC43", rd_data, 32'hAA11_0003);
        cpu_read(32'h0000_0B0C, rd_data); check("TC44", rd_data, 32'hAA11_0004);
        cpu_read(32'h0000_0B10, rd_data); check("TC45", rd_data, 32'hAA11_0005);
        for (i = 0; i < 5; i = i + 1) begin
            delay_cyc = i + 2;
            @(negedge clk);
            axi_bready  = 1'b0;
            axi_awvalid = 1'b1;
            axi_awaddr  = 32'h0000_0C00 + (i << 2);
            axi_wvalid  = 1'b1;
            axi_wdata   = 32'hBC00_0000 | i;
            axi_wstrb   = 4'hF;
            @(posedge clk);
            while (!axi_awready) @(posedge clk);
            #1; axi_awvalid = 1'b0;
            while (!axi_wready) @(posedge clk); #1;
            axi_wvalid = 1'b0;
            @(posedge clk);
            while (!axi_bvalid) @(posedge clk);
            bvalid_held = 1'b1;
            repeat (delay_cyc) begin
                @(posedge clk);
                if (!axi_bvalid) bvalid_held = 1'b0;
            end
            @(negedge clk);
            axi_bready = 1'b1;
            @(posedge clk); #1;

            if (bvalid_held) begin
                $display("[PASS] TC%0d  bvalid held for %0d-cycle delay",
                         46 + i, delay_cyc);
                pass_cnt = pass_cnt + 1;
            end else begin
                $display("[FAIL] TC%0d  bvalid deasserted prematurely (delay=%0d)",
                         46 + i, delay_cyc);
                fail_cnt = fail_cnt + 1;
            end

            @(negedge clk);
            axi_bready = 1'b1;
            idle_all;
            @(posedge clk); #1;
        end
        $display("");
        $display("RESULT: %0d/50 passed", pass_cnt);
        $finish;
    end
    // Simulation initialisation or stimulus block
    initial begin
        #2000000;
        $display("[TIMEOUT] Simulation exceeded limit");
        $finish;
    end

endmodule
