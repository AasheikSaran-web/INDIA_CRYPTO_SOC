`timescale 1ns/1ps

// AXI-Lite to APB bridge testbench with 50 self-checking test cases
module tb_axil_to_apb;

    logic clk = 0;
    // 100 MHz clock toggle
    always #5 clk = ~clk;

    logic        rst_n;

    logic [11:0] s_awaddr;
    logic        s_awvalid;
    logic        s_awready;
    logic [31:0] s_wdata;
    logic [3:0]  s_wstrb;
    logic        s_wvalid;
    logic        s_wready;
    logic [1:0]  s_bresp;
    logic        s_bvalid;
    logic        s_bready;
    logic [11:0] s_araddr;
    logic        s_arvalid;
    logic        s_arready;
    logic [31:0] s_rdata;
    logic [1:0]  s_rresp;
    logic        s_rvalid;
    logic        s_rready;

    logic [11:0] paddr;
    logic        psel;
    logic        penable;
    logic        pwrite;
    logic [31:0] pwdata;
    logic [31:0] prdata;
    logic        pready;
    logic        pslverr;

    axil_to_apb dut (
        .clk      (clk),
        .rst_n    (rst_n),
        .s_awaddr (s_awaddr),
        .s_awvalid(s_awvalid),
        .s_awready(s_awready),
        .s_wdata  (s_wdata),
        .s_wstrb  (s_wstrb),
        .s_wvalid (s_wvalid),
        .s_wready (s_wready),
        .s_bresp  (s_bresp),
        .s_bvalid (s_bvalid),
        .s_bready (s_bready),
        .s_araddr (s_araddr),
        .s_arvalid(s_arvalid),
        .s_arready(s_arready),
        .s_rdata  (s_rdata),
        .s_rresp  (s_rresp),
        .s_rvalid (s_rvalid),
        .s_rready (s_rready),
        .paddr    (paddr),
        .psel     (psel),
        .penable  (penable),
        .pwrite   (pwrite),
        .pwdata   (pwdata),
        .prdata   (prdata),
        .pready   (pready),
        .pslverr  (pslverr)
    );

    int   apb_pready_delay  = 1;
    logic apb_inject_slverr = 1'b0;

    logic [31:0] apb_mem [0:4095];

    logic penable_prev;
    int   penable_counter;

    // APB slave model initialization
    initial begin
        prdata          = 32'h0;
        pready          = 1'b0;
        pslverr         = 1'b0;
        penable_prev    = 1'b0;
        penable_counter = 0;
        begin : mem_init
            integer k;
            for (k = 0; k < 4096; k = k + 1)
                apb_mem[k] = 32'h0;
        end
    end

    // Clocked APB slave model with configurable pready delay and slverr injection
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            prdata          <= 32'h0;
            pready          <= 1'b0;
            pslverr         <= 1'b0;
            penable_prev    <= 1'b0;
            penable_counter <= 0;
        end else begin
            penable_prev <= penable;

            if (penable && !penable_prev) begin
                penable_counter <= 1;
                pready          <= 1'b0;
                pslverr         <= 1'b0;
            end else if (penable && penable_prev) begin
                if (penable_counter < apb_pready_delay) begin
                    penable_counter <= penable_counter + 1;
                    pready          <= 1'b0;
                end else begin
                    pready  <= 1'b1;
                    pslverr <= apb_inject_slverr;
                    if (pwrite) begin
                        apb_mem[paddr[11:0]] <= pwdata;
                        prdata               <= 32'h0;
                    end else begin
                        prdata <= 32'hA5A5A5A5 + {20'h0, paddr};
                    end
                end
            end else begin
                pready          <= 1'b0;
                pslverr         <= 1'b0;
                penable_counter <= 0;
            end
        end
    end

    int pass_count = 0;
    int fail_count = 0;

    // Single-bit check scoreboard task
    task automatic check(input string name, input logic got, input logic exp);
        if (got === exp) begin
            $display("[PASS] %s  (got=%0b exp=%0b)", name, got, exp);
            pass_count++;
        end else begin
            $display("[FAIL] %s  (got=%0b exp=%0b)", name, got, exp);
            fail_count++;
        end
    endtask

    // 32-bit check scoreboard task
    task automatic check32(input string name, input logic [31:0] got, input logic [31:0] exp);
        if (got === exp) begin
            $display("[PASS] %s  (got=0x%08h exp=0x%08h)", name, got, exp);
            pass_count++;
        end else begin
            $display("[FAIL] %s  (got=0x%08h exp=0x%08h)", name, got, exp);
            fail_count++;
        end
    endtask

    // 2-bit check scoreboard task
    task automatic check2(input string name, input logic [1:0] got, input logic [1:0] exp);
        if (got === exp) begin
            $display("[PASS] %s  (got=%02b exp=%02b)", name, got, exp);
            pass_count++;
        end else begin
            $display("[FAIL] %s  (got=%02b exp=%02b)", name, got, exp);
            fail_count++;
        end
    endtask

    // Drive all AXI-Lite inputs to idle state
    task automatic axil_idle();
        s_awaddr  = '0;
        s_awvalid = 1'b0;
        s_wdata   = '0;
        s_wstrb   = 4'hF;
        s_wvalid  = 1'b0;
        s_bready  = 1'b0;
        s_araddr  = '0;
        s_arvalid = 1'b0;
        s_rready  = 1'b0;
    endtask

    // AXI-Lite write with configurable bready delay
    task automatic axil_write(
        input  logic [11:0] addr,
        input  logic [31:0] data,
        output logic [1:0]  resp,
        input  int          delayed_bready
    );
        @(negedge clk);
        s_awaddr  = addr;
        s_awvalid = 1'b1;
        s_wdata   = data;
        s_wstrb   = 4'hF;
        s_wvalid  = 1'b1;

        fork
            begin : aw_h
                @(posedge clk);
                while (!s_awready) @(posedge clk);
                @(negedge clk);
                s_awvalid = 1'b0;
            end
            begin : w_h
                @(posedge clk);
                while (!s_wready) @(posedge clk);
                @(negedge clk);
                s_wvalid = 1'b0;
            end
        join

        @(posedge clk);
        while (!s_bvalid) @(posedge clk);

        if (delayed_bready > 0)
            repeat(delayed_bready) @(posedge clk);

        @(negedge clk);
        s_bready = 1'b1;
        @(posedge clk);
        resp     = s_bresp;
        @(negedge clk);
        s_bready = 1'b0;
    endtask

    // Convenience AXI-Lite write with no bready delay
    task automatic axil_write_nd(
        input  logic [11:0] addr,
        input  logic [31:0] data,
        output logic [1:0]  resp
    );
        axil_write(addr, data, resp, 0);
    endtask

    // AXI-Lite read with configurable rready delay
    task automatic axil_read(
        input  logic [11:0] addr,
        output logic [31:0] data,
        output logic [1:0]  resp,
        input  int          delayed_rready
    );
        @(negedge clk);
        s_araddr  = addr;
        s_arvalid = 1'b1;

        @(posedge clk);
        while (!s_arready) @(posedge clk);
        @(negedge clk);
        s_arvalid = 1'b0;

        @(posedge clk);
        while (!s_rvalid) @(posedge clk);

        if (delayed_rready > 0)
            repeat(delayed_rready) @(posedge clk);

        @(negedge clk);
        s_rready = 1'b1;
        @(posedge clk);
        data     = s_rdata;
        resp     = s_rresp;
        @(negedge clk);
        s_rready = 1'b0;
    endtask

    // Convenience AXI-Lite read with no rready delay
    task automatic axil_read_nd(
        input  logic [11:0] addr,
        output logic [31:0] data,
        output logic [1:0]  resp
    );
        axil_read(addr, data, resp, 0);
    endtask

    // Assert active-low reset and initialize all bus signals
    task automatic do_reset();
        rst_n = 1'b0;
        axil_idle();
        prdata  = 32'h0;
        pready  = 1'b0;
        pslverr = 1'b0;
        repeat(5) @(posedge clk);
        @(negedge clk);
        rst_n = 1'b1;
        @(posedge clk);
    endtask

    logic obs_psel_in_setup;
    logic obs_penable_in_enable;
    logic obs_pwrite_correct;
    logic obs_paddr_correct;
    logic obs_pwdata_correct;
    logic obs_bvalid_held;
    logic obs_rvalid_held;

    logic [31:0] rdata;
    logic [1:0]  resp;
    logic [31:0] exp_rdata;

    // Main test sequence driving 50 test cases
    initial begin
        $dumpfile("tb_axil_to_apb.vcd");
        $dumpvars(0, tb_axil_to_apb);

        do_reset();

        apb_pready_delay  = 1;
        apb_inject_slverr = 1'b0;

        obs_psel_in_setup     = 1'b0;
        obs_penable_in_enable = 1'b0;
        obs_pwrite_correct    = 1'b0;
        obs_paddr_correct     = 1'b0;
        obs_pwdata_correct    = 1'b0;

        fork
            begin : tc01_drv
                axil_write_nd(12'h010, 32'hDEADBEEF, resp);
            end
            begin : tc01_obs
                @(posedge clk);
                while (!psel) @(posedge clk);
                obs_psel_in_setup = psel & ~penable;
                @(posedge clk);
                obs_penable_in_enable = psel & penable;
                obs_pwrite_correct    = (pwrite === 1'b1);
                obs_paddr_correct     = (paddr  === 12'h010);
                obs_pwdata_correct    = (pwdata  === 32'hDEADBEEF);
            end
        join

        check("TC01 psel=1 penable=0 during SETUP state", obs_psel_in_setup, 1'b1);
        check("TC02 psel=1 penable=1 during ENABLE state", obs_penable_in_enable, 1'b1);
        check("TC03 pwrite=1 for AXI write", obs_pwrite_correct, 1'b1);
        check("TC04 paddr=0x010 correct", obs_paddr_correct, 1'b1);
        check("TC05 pwdata=0xDEADBEEF correct", obs_pwdata_correct, 1'b1);

        obs_psel_in_setup     = 1'b0;
        obs_penable_in_enable = 1'b0;
        obs_pwrite_correct    = 1'b0;
        obs_paddr_correct     = 1'b0;

        fork
            begin : tc06_drv
                axil_read_nd(12'h020, rdata, resp);
            end
            begin : tc06_obs
                @(posedge clk);
                while (!psel) @(posedge clk);
                obs_psel_in_setup     = psel & ~penable;
                @(posedge clk);
                obs_penable_in_enable = psel & penable;
                obs_pwrite_correct    = (pwrite === 1'b0);
                obs_paddr_correct     = (paddr  === 12'h020);
            end
        join

        check("TC06 psel=1 penable=0 during SETUP (read)", obs_psel_in_setup, 1'b1);
        check("TC07 psel=1 penable=1 during ENABLE (read)", obs_penable_in_enable, 1'b1);
        check("TC08 pwrite=0 for AXI read", obs_pwrite_correct, 1'b1);
        check("TC09 paddr=0x020 correct for read", obs_paddr_correct, 1'b1);

        exp_rdata = 32'hA5A5A5A5 + 32'h020;
        check32("TC10 s_rdata = APB prdata formula", rdata, exp_rdata);

        axil_write_nd(12'h030, 32'hAAAA0001, resp);
        check2("TC11 consecutive write 1 bresp=OKAY", resp, 2'b00);

        axil_write_nd(12'h034, 32'hAAAA0002, resp);
        check2("TC12 consecutive write 2 bresp=OKAY", resp, 2'b00);

        axil_write_nd(12'h038, 32'hAAAA0003, resp);
        check2("TC13 consecutive write 3 bresp=OKAY", resp, 2'b00);

        check32("TC14 APB slave mem[0x034]=0xAAAA0002",
                apb_mem[12'h034], 32'hAAAA0002);
        check32("TC15 APB slave mem[0x038]=0xAAAA0003",
                apb_mem[12'h038], 32'hAAAA0003);

        axil_read_nd(12'h040, rdata, resp);
        check32("TC16 consecutive read 1 data", rdata, 32'hA5A5A5A5 + 32'h040);

        axil_read_nd(12'h044, rdata, resp);
        check32("TC17 consecutive read 2 data", rdata, 32'hA5A5A5A5 + 32'h044);

        axil_read_nd(12'h048, rdata, resp);
        check32("TC18 consecutive read 3 data", rdata, 32'hA5A5A5A5 + 32'h048);

        axil_read_nd(12'h04C, rdata, resp);
        check2("TC19 consecutive read 4 rresp=OKAY", resp, 2'b00);

        axil_read_nd(12'h050, rdata, resp);
        check2("TC20 consecutive read 5 rresp=OKAY", resp, 2'b00);

        axil_write_nd(12'h060, 32'hBEEFCAFE, resp);
        check2("TC21 mixed: write bresp=OKAY", resp, 2'b00);

        axil_read_nd(12'h060, rdata, resp);
        check32("TC22 mixed: read rdata=formula (APB slave uses formula not mem)",
                rdata, 32'hA5A5A5A5 + 32'h060);

        axil_write_nd(12'h064, 32'h12345678, resp);
        check2("TC23 mixed: second write bresp=OKAY", resp, 2'b00);

        axil_read_nd(12'h068, rdata, resp);
        check2("TC24 mixed: second read rresp=OKAY", resp, 2'b00);

        check32("TC25 APB slave mem[0x064]=0x12345678",
                apb_mem[12'h064], 32'h12345678);

        apb_inject_slverr = 1'b1;

        axil_write_nd(12'h070, 32'hDEAD0001, resp);
        check2("TC26 write pslverr: bresp=SLVERR(2'b10)", resp, 2'b10);

        axil_write_nd(12'h074, 32'hDEAD0002, resp);
        check2("TC27 write pslverr 2: bresp=SLVERR", resp, 2'b10);

        axil_write_nd(12'h078, 32'hDEAD0003, resp);
        check2("TC28 write pslverr 3: bresp=SLVERR", resp, 2'b10);

        apb_inject_slverr = 1'b0;

        axil_write_nd(12'h07C, 32'hC001C0DE, resp);
        check2("TC29 write after slverr cleared: bresp=OKAY", resp, 2'b00);

        check32("TC30 APB slave recorded data during pslverr write",
                apb_mem[12'h074], 32'hDEAD0002);

        apb_inject_slverr = 1'b1;

        axil_read_nd(12'h080, rdata, resp);
        check2("TC31 read pslverr: rresp=SLVERR(2'b10)", resp, 2'b10);

        axil_read_nd(12'h084, rdata, resp);
        check2("TC32 read pslverr 2: rresp=SLVERR", resp, 2'b10);

        axil_read_nd(12'h088, rdata, resp);
        check2("TC33 read pslverr 3: rresp=SLVERR", resp, 2'b10);

        apb_inject_slverr = 1'b0;

        axil_read_nd(12'h08C, rdata, resp);
        check2("TC34 read after slverr cleared: rresp=OKAY", resp, 2'b00);

        axil_read_nd(12'h090, rdata, resp);
        check32("TC35 rdata=formula after slverr sequence",
                rdata, 32'hA5A5A5A5 + 32'h090);

        obs_bvalid_held = 1'b0;
        fork
            begin : tc36_drv
                axil_write(12'h0A0, 32'hABC00001, resp, 3);
            end
            begin : tc36_obs
                @(posedge clk);
                while (!s_bvalid) @(posedge clk);
                @(posedge clk);
                obs_bvalid_held = s_bvalid;
            end
        join
        check("TC36 bvalid held while bready delayed", obs_bvalid_held, 1'b1);
        check2("TC37 delayed-bready write bresp=OKAY", resp, 2'b00);

        axil_write(12'h0A4, 32'hABC00002, resp, 2);
        check2("TC38 delayed-bready write 2 bresp=OKAY", resp, 2'b00);

        axil_write(12'h0A8, 32'hABC00003, resp, 1);
        check2("TC39 delayed-bready write 3 bresp=OKAY", resp, 2'b00);

        check32("TC40 APB slave mem[0x0A4]=0xABC00002",
                apb_mem[12'h0A4], 32'hABC00002);

        obs_rvalid_held = 1'b0;
        fork
            begin : tc41_drv
                axil_read(12'h0B0, rdata, resp, 3);
            end
            begin : tc41_obs
                @(posedge clk);
                while (!s_rvalid) @(posedge clk);
                @(posedge clk);
                obs_rvalid_held = s_rvalid;
            end
        join
        check("TC41 rvalid held while rready delayed", obs_rvalid_held, 1'b1);
        check2("TC42 delayed-rready read rresp=OKAY", resp, 2'b00);

        axil_read(12'h0B4, rdata, resp, 2);
        check2("TC43 delayed-rready read 2 rresp=OKAY", resp, 2'b00);

        axil_read(12'h0B8, rdata, resp, 1);
        check32("TC44 delayed-rready read 3 rdata correct",
                rdata, 32'hA5A5A5A5 + 32'h0B8);

        axil_read(12'h0BC, rdata, resp, 4);
        check2("TC45 delayed-rready read 4 rresp=OKAY", resp, 2'b00);

        apb_pready_delay = 2;

        axil_write_nd(12'h0C0, 32'hDE1A0001, resp);
        check2("TC46 pready-delayed write bresp=OKAY", resp, 2'b00);

        check32("TC47 APB slave mem[0x0C0] with pready delay",
                apb_mem[12'h0C0], 32'hDE1A0001);

        axil_read_nd(12'h0C4, rdata, resp);
        check2("TC48 pready-delayed read rresp=OKAY", resp, 2'b00);

        check32("TC49 rdata correct with pready-delayed read",
                rdata, 32'hA5A5A5A5 + 32'h0C4);

        axil_write_nd(12'h0C8, 32'hDE1A0002, resp);
        check32("TC50 APB slave mem[0x0C8] second pready-delayed write",
                apb_mem[12'h0C8], 32'hDE1A0002);

        apb_pready_delay = 1;

        $display("----------------------------------------");
        $display("RESULT: %0d/50 passed", pass_count);
        $display("----------------------------------------");

        $finish;
    end

    // Simulation timeout watchdog
    initial begin
        #500000;
        $display("[TIMEOUT] Simulation exceeded 500us — aborting.");
        $finish;
    end

endmodule
