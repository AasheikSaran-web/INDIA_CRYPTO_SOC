`timescale 1ns/1ps

// tb_sram_sp_wrap: hardware module definition
module tb_sram_sp_wrap;
    reg        clk;
    reg        cen;
    reg        wen;
    reg [3:0]  bwen;
    reg [13:0] addr;
    reg [31:0] wdata;
    wire [31:0] rdata;
    sram_sp_wrap #(.DEPTH(16384), .WIDTH(32)) dut (
        .clk   (clk),
        .cen   (cen),
        .wen   (wen),
        .bwen  (bwen),
        .addr  (addr),
        .wdata (wdata),
        .rdata (rdata)
    );
    // Simulation initialisation or stimulus block
    initial clk = 0;
    // Combinational logic output computation
    always #5 clk = ~clk;
    // idle: reusable simulation task
    task idle;
        cen   = 1'b0;
        wen   = 1'b0;
        bwen  = 4'h0;
        addr  = 14'h0;
        wdata = 32'h0;
    endtask
    // do_write: reusable simulation task
    task do_write;
        input [13:0] a;
        input [31:0] d;
        input [3:0]  be;
        begin
            @(negedge clk);
            cen   = 1'b1;
            wen   = 1'b1;
            bwen  = be;
            addr  = a;
            wdata = d;
            @(posedge clk);
            #1;
            idle;
        end
    endtask
    // do_read: reusable simulation task
    task do_read;
        input  [13:0] a;
        output [31:0] d;
        begin
            @(negedge clk);
            cen   = 1'b1;
            wen   = 1'b0;
            bwen  = 4'hF;
            addr  = a;
            wdata = 32'h0;
            @(posedge clk);
            #1;
            idle;
            @(posedge clk);
            #1;
            d = rdata;
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
    reg [31:0] pat;
    reg [13:0] tc46_addrs [0:4];
    reg [31:0] tc46_exp   [0:4];
    integer    i;
    // Simulation initialisation or stimulus block
    initial begin
        pass_cnt = 0;
        fail_cnt = 0;
        idle;
        do_write(14'd0, 32'hDEAD_BEEF, 4'hF);
        do_read (14'd0, rd_data);
        check("TC01", rd_data, 32'hDEAD_BEEF);

        do_write(14'd1, 32'hCAFE_BABE, 4'hF);
        do_read (14'd1, rd_data);
        check("TC02", rd_data, 32'hCAFE_BABE);

        do_write(14'd2, 32'h1234_5678, 4'hF);
        do_read (14'd2, rd_data);
        check("TC03", rd_data, 32'h1234_5678);

        do_write(14'd3, 32'hABCD_EF01, 4'hF);
        do_read (14'd3, rd_data);
        check("TC04", rd_data, 32'hABCD_EF01);

        do_write(14'd4, 32'h5A5A_5A5A, 4'hF);
        do_read (14'd4, rd_data);
        check("TC05", rd_data, 32'h5A5A_5A5A);
        do_write(14'd100, 32'hFFFF_FFFF, 4'hF);
        do_read (14'd100, rd_data);
        check("TC06", rd_data, 32'hFFFF_FFFF);

        do_write(14'd101, 32'hFFFF_FFFF, 4'hF);
        do_read (14'd101, rd_data);
        check("TC07", rd_data, 32'hFFFF_FFFF);

        do_write(14'd102, 32'hFFFF_FFFF, 4'hF);
        do_read (14'd102, rd_data);
        check("TC08", rd_data, 32'hFFFF_FFFF);

        do_write(14'd103, 32'hFFFF_FFFF, 4'hF);
        do_read (14'd103, rd_data);
        check("TC09", rd_data, 32'hFFFF_FFFF);

        do_write(14'd104, 32'hFFFF_FFFF, 4'hF);
        do_read (14'd104, rd_data);
        check("TC10", rd_data, 32'hFFFF_FFFF);
        do_write(14'd200, 32'h0000_0000, 4'hF);
        do_write(14'd200, 32'h0000_00AB, 4'b0001);
        do_read (14'd200, rd_data);
        check("TC11", rd_data & 32'h0000_00FF, 32'h0000_00AB);
        check("TC12", rd_data & 32'hFFFF_FF00, 32'h0000_0000);
        do_write(14'd200, 32'h0000_00CD, 4'b0001);
        do_read (14'd200, rd_data);
        check("TC13", rd_data & 32'h0000_00FF, 32'h0000_00CD);
        check("TC14", rd_data & 32'hFFFF_0000, 32'h0000_0000);
        do_write(14'd200, 32'h0000_1100, 4'b0010);
        do_write(14'd200, 32'h0000_00EE, 4'b0001);
        do_read (14'd200, rd_data);
        check("TC15", rd_data & 32'h0000_FFFF, 32'h0000_11EE);
        do_write(14'd300, 32'h0000_0000, 4'hF);
        do_write(14'd300, 32'h0000_2200, 4'b0010);
        do_read (14'd300, rd_data);
        check("TC16", rd_data & 32'h0000_FF00, 32'h0000_2200);
        do_write(14'd300, 32'h0033_0000, 4'b0100);
        do_read (14'd300, rd_data);
        check("TC17", rd_data & 32'h00FF_0000, 32'h0033_0000);
        do_write(14'd300, 32'h4400_0000, 4'b1000);
        do_read (14'd300, rd_data);
        check("TC18", rd_data & 32'hFF00_0000, 32'h4400_0000);
        do_write(14'd400, 32'h0000_0000, 4'hF);
        do_write(14'd400, 32'h0000_00AA, 4'b0001);
        do_write(14'd400, 32'h0000_BB00, 4'b0010);
        do_write(14'd400, 32'h00CC_0000, 4'b0100);
        do_write(14'd400, 32'hDD00_0000, 4'b1000);
        do_read (14'd400, rd_data);
        check("TC19", rd_data, 32'hDDCC_BBAA);
        do_write(14'd300, 32'hFFFF_FFFF, 4'b0000);
        do_read (14'd300, rd_data);
        check("TC20", rd_data & 32'hFF00_0000, 32'h4400_0000);
        do_write(14'd500, 32'h0000_0001, 4'hF);
        do_write(14'd500, 32'h0000_0002, 4'hF);
        do_read (14'd500, rd_data);
        check("TC21", rd_data, 32'h0000_0002);

        do_write(14'd501, 32'hAAAA_AAAA, 4'hF);
        do_write(14'd501, 32'h5555_5555, 4'hF);
        do_read (14'd501, rd_data);
        check("TC22", rd_data, 32'h5555_5555);

        do_write(14'd502, 32'hFFFF_0000, 4'hF);
        do_write(14'd502, 32'h0000_FFFF, 4'hF);
        do_read (14'd502, rd_data);
        check("TC23", rd_data, 32'h0000_FFFF);

        do_write(14'd503, 32'h1111_1111, 4'hF);
        do_write(14'd503, 32'h2222_2222, 4'hF);
        do_write(14'd503, 32'h3333_3333, 4'hF);
        do_read (14'd503, rd_data);
        check("TC24", rd_data, 32'h3333_3333);

        do_write(14'd504, 32'hC0DE_C0DE, 4'hF);
        do_write(14'd504, 32'hFEED_F00D, 4'hF);
        do_read (14'd504, rd_data);
        check("TC25", rd_data, 32'hFEED_F00D);
        do_write(14'd600, 32'hAABB_CCDD, 4'hF);
        do_write(14'd601, 32'h1122_3344, 4'hF);
        do_write(14'd602, 32'h5566_7788, 4'hF);
        do_write(14'd603, 32'h99AA_BBCC, 4'hF);
        do_write(14'd604, 32'hDDEE_FF00, 4'hF);
        @(negedge clk); cen=1'b0; wen=1'b1; bwen=4'hF; addr=14'd600; wdata=32'hDEAD_DEAD; @(posedge clk); #1; idle;
        @(negedge clk); cen=1'b0; wen=1'b1; bwen=4'hF; addr=14'd601; wdata=32'hDEAD_DEAD; @(posedge clk); #1; idle;
        @(negedge clk); cen=1'b0; wen=1'b1; bwen=4'hF; addr=14'd602; wdata=32'hDEAD_DEAD; @(posedge clk); #1; idle;
        @(negedge clk); cen=1'b0; wen=1'b1; bwen=4'hF; addr=14'd603; wdata=32'hDEAD_DEAD; @(posedge clk); #1; idle;
        @(negedge clk); cen=1'b0; wen=1'b1; bwen=4'hF; addr=14'd604; wdata=32'hDEAD_DEAD; @(posedge clk); #1; idle;

        do_read(14'd600, rd_data); check("TC26", rd_data, 32'hAABB_CCDD);
        do_read(14'd601, rd_data); check("TC27", rd_data, 32'h1122_3344);
        do_read(14'd602, rd_data); check("TC28", rd_data, 32'h5566_7788);
        do_read(14'd603, rd_data); check("TC29", rd_data, 32'h99AA_BBCC);
        do_read(14'd604, rd_data); check("TC30", rd_data, 32'hDDEE_FF00);
        for (i = 0; i < 16; i = i + 1)
            do_write(1000 + i, 32'hBEEF_0000 | i, 4'hF);

        do_read(14'd1000, rd_data); check("TC31", rd_data, 32'hBEEF_0000);
        do_read(14'd1001, rd_data); check("TC32", rd_data, 32'hBEEF_0001);
        do_read(14'd1002, rd_data); check("TC33", rd_data, 32'hBEEF_0002);
        do_read(14'd1003, rd_data); check("TC34", rd_data, 32'hBEEF_0003);
        for (i = 4; i < 15; i = i + 1)
            do_read(1000 + i, rd_data);
        do_read(14'd1015, rd_data);
        check("TC35", rd_data, 32'hBEEF_000F);
        do_write(14'd16383, 32'hC001_D00D, 4'hF);
        do_read (14'd16383, rd_data);
        check("TC36", rd_data, 32'hC001_D00D);

        do_write(14'd16383, 32'hFFFF_FFFE, 4'hF);
        do_read (14'd16383, rd_data);
        check("TC37", rd_data, 32'hFFFF_FFFE);

        do_write(14'd16383, 32'h0000_0001, 4'hF);
        do_read (14'd16383, rd_data);
        check("TC38", rd_data, 32'h0000_0001);
        do_write(14'd16383, 32'h0000_0000, 4'hF);
        do_write(14'd16383, 32'h0000_00AB, 4'b0001);
        do_read (14'd16383, rd_data);
        check("TC39", rd_data & 32'h0000_00FF, 32'h0000_00AB);

        do_write(14'd16383, 32'hF0F0_F0F0, 4'hF);
        do_read (14'd16383, rd_data);
        check("TC40", rd_data, 32'hF0F0_F0F0);
        do_write(14'd0, 32'h1111_1111, 4'hF);
        do_write(14'd0, 32'h2222_2222, 4'hF);
        do_read (14'd0, rd_data);
        check("TC41", rd_data, 32'h2222_2222);

        do_write(14'd0, 32'hAAAA_AAAA, 4'hF);
        do_write(14'd0, 32'h5555_5555, 4'hF);
        do_read (14'd0, rd_data);
        check("TC42", rd_data, 32'h5555_5555);

        do_write(14'd0, 32'hFFFF_FFFF, 4'hF);
        do_write(14'd0, 32'h0000_0000, 4'hF);
        do_read (14'd0, rd_data);
        check("TC43", rd_data, 32'h0000_0000);

        do_write(14'd1, 32'hDEAD_DEAD, 4'hF);
        do_write(14'd1, 32'hBEEF_BEEF, 4'hF);
        do_read (14'd1, rd_data);
        check("TC44", rd_data, 32'hBEEF_BEEF);

        do_write(14'd2, 32'h0000_0001, 4'hF);
        do_write(14'd2, 32'h0000_0002, 4'hF);
        do_write(14'd2, 32'h0000_0003, 4'hF);
        do_read (14'd2, rd_data);
        check("TC45", rd_data, 32'h0000_0003);
        tc46_addrs[0] = 14'd2000;
        tc46_addrs[1] = 14'd2001;
        tc46_addrs[2] = 14'd2002;
        tc46_addrs[3] = 14'd2003;
        tc46_addrs[4] = 14'd2004;

        for (i = 0; i < 5; i = i + 1) begin
            pat = 32'hA5A5_A5A5 ^ ({18'h0, tc46_addrs[i]} << 1);
            tc46_exp[i] = pat;
            do_write(tc46_addrs[i], pat, 4'hF);
        end

        do_read(tc46_addrs[0], rd_data); check("TC46", rd_data, tc46_exp[0]);
        do_read(tc46_addrs[1], rd_data); check("TC47", rd_data, tc46_exp[1]);
        do_read(tc46_addrs[2], rd_data); check("TC48", rd_data, tc46_exp[2]);
        do_read(tc46_addrs[3], rd_data); check("TC49", rd_data, tc46_exp[3]);
        do_read(tc46_addrs[4], rd_data); check("TC50", rd_data, tc46_exp[4]);
        $display("");
        $display("RESULT: %0d/50 passed", pass_cnt);
        $finish;
    end
    // Simulation initialisation or stimulus block
    initial begin
        #200000;
        $display("[TIMEOUT] Simulation exceeded limit");
        $finish;
    end

endmodule
