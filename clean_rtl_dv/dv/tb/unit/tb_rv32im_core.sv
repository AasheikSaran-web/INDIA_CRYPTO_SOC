
`timescale 1ns/1ps

// tb_rv32im_core: hardware module definition
module tb_rv32im_core;
reg clk;
reg rst_n;

// Simulation initialisation or stimulus block
initial clk = 0;
// Combinational logic output computation
always #5 clk = ~clk;
wire [31:0] imem_araddr;
wire        imem_arvalid;
reg         imem_arready;
reg  [31:0] imem_rdata;
reg  [1:0]  imem_rresp;
reg         imem_rvalid;
wire        imem_rready;
wire [31:0] dmem_awaddr;
wire        dmem_awvalid;
reg         dmem_awready;
wire [31:0] dmem_wdata;
wire [3:0]  dmem_wstrb;
wire        dmem_wvalid;
reg         dmem_wready;
reg  [1:0]  dmem_bresp;
reg         dmem_bvalid;
wire        dmem_bready;
wire [31:0] dmem_araddr;
wire        dmem_arvalid;
reg         dmem_arready;
reg  [31:0] dmem_rdata;
reg  [1:0]  dmem_rresp;
reg         dmem_rvalid;
wire        dmem_rready;
wire        custom_valid;
wire [31:0] custom_instr;
wire [31:0] custom_rs1;
wire [31:0] custom_rs2;
reg  [31:0] custom_rd;
reg         custom_rd_valid;
reg timer_irq, soft_irq, ext_irq;
rv32im_core #(.RESET_ADDR(32'h2000_0000)) dut (
    .clk           (clk),
    .rst_n         (rst_n),
    .timer_irq     (timer_irq),
    .soft_irq      (soft_irq),
    .ext_irq       (ext_irq),
    .imem_araddr   (imem_araddr),
    .imem_arvalid  (imem_arvalid),
    .imem_arready  (imem_arready),
    .imem_rdata    (imem_rdata),
    .imem_rresp    (imem_rresp),
    .imem_rvalid   (imem_rvalid),
    .imem_rready   (imem_rready),
    .dmem_awaddr   (dmem_awaddr),
    .dmem_awvalid  (dmem_awvalid),
    .dmem_awready  (dmem_awready),
    .dmem_wdata    (dmem_wdata),
    .dmem_wstrb    (dmem_wstrb),
    .dmem_wvalid   (dmem_wvalid),
    .dmem_wready   (dmem_wready),
    .dmem_bresp    (dmem_bresp),
    .dmem_bvalid   (dmem_bvalid),
    .dmem_bready   (dmem_bready),
    .dmem_araddr   (dmem_araddr),
    .dmem_arvalid  (dmem_arvalid),
    .dmem_arready  (dmem_arready),
    .dmem_rdata    (dmem_rdata),
    .dmem_rresp    (dmem_rresp),
    .dmem_rvalid   (dmem_rvalid),
    .dmem_rready   (dmem_rready),
    .custom_valid  (custom_valid),
    .custom_instr  (custom_instr),
    .custom_rs1    (custom_rs1),
    .custom_rs2    (custom_rs2),
    .custom_rd     (custom_rd),
    .custom_rd_valid(custom_rd_valid)
);
localparam IMEM_BASE = 32'h2000_0000;
localparam DMEM_BASE = 32'h2001_0000;
localparam MEM_WORDS = 4096;

reg [31:0] imem [0:MEM_WORDS-1];
reg [31:0] dmem [0:MEM_WORDS-1];
reg [31:0] wr_addr_lat;
reg        wr_addr_valid;
reg [31:0] wr_data_lat;
reg [3:0]  wr_strb_lat;
reg        wr_data_valid;
reg        ar_pending;
reg [31:0] ar_addr_r;

integer i;
// init_mem: reusable simulation task
task init_mem;
    integer j;
    begin
        for (j = 0; j < MEM_WORDS; j = j + 1) begin
            imem[j] = 32'h0000_0013;
            dmem[j] = 32'h0000_0000;
        end
        wr_addr_valid = 0;
        wr_data_valid = 0;
        ar_pending    = 0;
    end
endtask
// store_instr: reusable simulation task
task store_instr;
    input [31:0] ba;
    input [31:0] word;
    begin
        imem[(ba - IMEM_BASE) >> 2] = word;
    end
endtask
// store_data: reusable simulation task
task store_data;
    input [31:0] ba;
    input [31:0] word;
    begin
        dmem[(ba - DMEM_BASE) >> 2] = word;
    end
endtask
// Clocked sequential logic register update
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        dmem_arready <= 0;
        dmem_rdata   <= 0;
        dmem_rresp   <= 0;
        dmem_rvalid  <= 0;
        dmem_awready <= 0;
        dmem_wready  <= 0;
        dmem_bvalid  <= 0;
        dmem_bresp   <= 0;
        ar_pending   <= 0;
        ar_addr_r    <= 0;
        wr_addr_valid<= 0;
        wr_data_valid<= 0;
        wr_addr_lat  <= 0;
        wr_data_lat  <= 0;
        wr_strb_lat  <= 0;
    end else begin
        dmem_arready <= 0;
        if (dmem_rvalid && dmem_rready) begin
            dmem_rvalid <= 0;
            ar_pending  <= 0;
        end
        if (dmem_arvalid && !ar_pending) begin
            dmem_arready <= 1;
            ar_pending   <= 1;
            ar_addr_r    <= dmem_araddr;
        end
        if (ar_pending && !dmem_rvalid) begin
            if (ar_addr_r >= IMEM_BASE && ar_addr_r < (IMEM_BASE + MEM_WORDS*4))
                dmem_rdata <= imem[(ar_addr_r - IMEM_BASE) >> 2];
            else if (ar_addr_r >= DMEM_BASE && ar_addr_r < (DMEM_BASE + MEM_WORDS*4))
                dmem_rdata <= dmem[(ar_addr_r - DMEM_BASE) >> 2];
            else
                dmem_rdata <= 32'hDEAD_BEEF;
            dmem_rresp  <= 2'b00;
            dmem_rvalid <= 1;
        end
        dmem_awready <= 0;
        dmem_wready  <= 0;
        if (dmem_bvalid && dmem_bready) begin
            dmem_bvalid   <= 0;
            wr_addr_valid <= 0;
            wr_data_valid <= 0;
        end
        if (dmem_awvalid && !dmem_bvalid) begin
            dmem_awready  <= 1;
            wr_addr_lat   <= dmem_awaddr;
            wr_addr_valid <= 1;
        end
        if (dmem_wvalid && !dmem_bvalid) begin
            dmem_wready   <= 1;
            wr_data_lat   <= dmem_wdata;
            wr_strb_lat   <= dmem_wstrb;
            wr_data_valid <= 1;
        end
        if ((wr_addr_valid || (dmem_awvalid && !dmem_bvalid)) &&
            (wr_data_valid || (dmem_wvalid  && !dmem_bvalid)) && !dmem_bvalid) begin
            begin : do_write
                reg [31:0] waddr;
                reg [31:0] wdata;
                reg [3:0]  wstrb;
                waddr = wr_addr_valid ? wr_addr_lat : dmem_awaddr;
                wdata = wr_data_valid ? wr_data_lat : dmem_wdata;
                wstrb = wr_data_valid ? wr_strb_lat : dmem_wstrb;
                if (waddr >= DMEM_BASE && waddr < (DMEM_BASE + MEM_WORDS*4)) begin : dm_wr
                    reg [31:0] idx;
                    reg [31:0] old;
                    idx = (waddr - DMEM_BASE) >> 2;
                    old = dmem[idx];
                    if (wstrb[0]) dmem[idx][ 7: 0] <= wdata[ 7: 0];
                    if (wstrb[1]) dmem[idx][15: 8] <= wdata[15: 8];
                    if (wstrb[2]) dmem[idx][23:16] <= wdata[23:16];
                    if (wstrb[3]) dmem[idx][31:24] <= wdata[31:24];
                end
            end
            dmem_bresp  <= 2'b00;
            dmem_bvalid <= 1;
        end
    end
end
// Simulation initialisation or stimulus block
initial begin
    imem_arready = 0;
    imem_rdata   = 0;
    imem_rresp   = 0;
    imem_rvalid  = 0;
end
// Simulation initialisation or stimulus block
initial begin
    custom_rd       = 0;
    custom_rd_valid = 0;
end
// Simulation initialisation or stimulus block
initial begin
    timer_irq = 0;
    soft_irq  = 0;
    ext_irq   = 0;
end
integer pass_count;
integer fail_count;
integer tc_num;

// pass: reusable simulation task
task pass;
    input [7:0] n;
    begin
        $display("[PASS] TC%0d", n);
        pass_count = pass_count + 1;
    end
endtask

// fail: reusable simulation task
task fail;
    input [7:0] n;
    input [127:0] reason;
    begin
        $display("[FAIL] TC%0d : %s", n, reason);
        fail_count = fail_count + 1;
    end
endtask
// do_reset: reusable simulation task
task do_reset;
    begin
        rst_n = 0;
        repeat(4) @(posedge clk);
        @(negedge clk);
        rst_n = 1;
    end
endtask
// wait_store: reusable simulation task
task wait_store;
    input  [31:0] exp_addr;
    input  integer timeout_cycles;
    output [31:0] out_data;
    output        ok;
    integer cnt;
    reg [31:0] waddr;
    begin
        ok  = 0;
        cnt = 0;
        out_data = 32'hX;
        while (cnt < timeout_cycles) begin
            @(posedge clk);
            #1;
            if (dmem_bvalid && dmem_bready) begin
                waddr = wr_addr_lat;
                @(posedge clk); #1;
                if (waddr >= DMEM_BASE && waddr < (DMEM_BASE + MEM_WORDS*4)) begin
                    out_data = dmem[(waddr - DMEM_BASE) >> 2];
                    if (waddr == exp_addr) begin
                        ok = 1;
                        cnt = timeout_cycles;
                    end
                end
            end
            cnt = cnt + 1;
        end
    end
endtask
// wait_load_ar: reusable simulation task
task wait_load_ar;
    input  [31:0] exp_addr;
    input  integer timeout_cycles;
    output        ok;
    integer cnt;
    begin
        ok  = 0;
        cnt = 0;
        while (cnt < timeout_cycles) begin
            @(posedge clk); #1;
            if (dmem_arvalid && dmem_arready && dmem_araddr == exp_addr) begin
                ok = 1;
                cnt = timeout_cycles;
            end
            cnt = cnt + 1;
        end
    end
endtask
// run_cycles: reusable simulation task
task run_cycles;
    input integer n;
    integer k;
    begin
        for (k = 0; k < n; k = k + 1)
            @(posedge clk);
    end
endtask
`define NOP  32'h0000_0013
// enc_addi: combinational helper function
function [31:0] enc_addi;
    input [4:0] rd, rs1;
    input [11:0] imm;
    begin enc_addi = {imm, rs1, 3'b000, rd, 7'h13}; end
endfunction
// enc_lui: combinational helper function
function [31:0] enc_lui;
    input [4:0] rd;
    input [19:0] imm20;
    begin enc_lui = {imm20, rd, 7'h37}; end
endfunction
// enc_auipc: combinational helper function
function [31:0] enc_auipc;
    input [4:0] rd;
    input [19:0] imm20;
    begin enc_auipc = {imm20, rd, 7'h17}; end
endfunction
// enc_add: combinational helper function
function [31:0] enc_add;
    input [4:0] rd, rs1, rs2;
    begin enc_add = {7'b0000000, rs2, rs1, 3'b000, rd, 7'h33}; end
endfunction
// enc_sub: combinational helper function
function [31:0] enc_sub;
    input [4:0] rd, rs1, rs2;
    begin enc_sub = {7'b0100000, rs2, rs1, 3'b000, rd, 7'h33}; end
endfunction
// enc_and: combinational helper function
function [31:0] enc_and;
    input [4:0] rd, rs1, rs2;
    begin enc_and = {7'b0000000, rs2, rs1, 3'b111, rd, 7'h33}; end
endfunction
// enc_or: combinational helper function
function [31:0] enc_or;
    input [4:0] rd, rs1, rs2;
    begin enc_or = {7'b0000000, rs2, rs1, 3'b110, rd, 7'h33}; end
endfunction
// enc_xor: combinational helper function
function [31:0] enc_xor;
    input [4:0] rd, rs1, rs2;
    begin enc_xor = {7'b0000000, rs2, rs1, 3'b100, rd, 7'h33}; end
endfunction
// enc_sll: combinational helper function
function [31:0] enc_sll;
    input [4:0] rd, rs1, rs2;
    begin enc_sll = {7'b0000000, rs2, rs1, 3'b001, rd, 7'h33}; end
endfunction
// enc_srl: combinational helper function
function [31:0] enc_srl;
    input [4:0] rd, rs1, rs2;
    begin enc_srl = {7'b0000000, rs2, rs1, 3'b101, rd, 7'h33}; end
endfunction
// enc_sra: combinational helper function
function [31:0] enc_sra;
    input [4:0] rd, rs1, rs2;
    begin enc_sra = {7'b0100000, rs2, rs1, 3'b101, rd, 7'h33}; end
endfunction
// enc_slt: combinational helper function
function [31:0] enc_slt;
    input [4:0] rd, rs1, rs2;
    begin enc_slt = {7'b0000000, rs2, rs1, 3'b010, rd, 7'h33}; end
endfunction
// enc_sltu: combinational helper function
function [31:0] enc_sltu;
    input [4:0] rd, rs1, rs2;
    begin enc_sltu = {7'b0000000, rs2, rs1, 3'b011, rd, 7'h33}; end
endfunction
// enc_sw: combinational helper function
function [31:0] enc_sw;
    input [4:0] rs1, rs2;
    input [11:0] offset;
    begin enc_sw = {offset[11:5], rs2, rs1, 3'b010, offset[4:0], 7'h23}; end
endfunction
// enc_sh: combinational helper function
function [31:0] enc_sh;
    input [4:0] rs1, rs2;
    input [11:0] offset;
    begin enc_sh = {offset[11:5], rs2, rs1, 3'b001, offset[4:0], 7'h23}; end
endfunction
// enc_sb: combinational helper function
function [31:0] enc_sb;
    input [4:0] rs1, rs2;
    input [11:0] offset;
    begin enc_sb = {offset[11:5], rs2, rs1, 3'b000, offset[4:0], 7'h23}; end
endfunction
// enc_lw: combinational helper function
function [31:0] enc_lw;
    input [4:0] rd, rs1;
    input [11:0] offset;
    begin enc_lw = {offset, rs1, 3'b010, rd, 7'h03}; end
endfunction
// enc_lh: combinational helper function
function [31:0] enc_lh;
    input [4:0] rd, rs1;
    input [11:0] offset;
    begin enc_lh = {offset, rs1, 3'b001, rd, 7'h03}; end
endfunction
// enc_lb: combinational helper function
function [31:0] enc_lb;
    input [4:0] rd, rs1;
    input [11:0] offset;
    begin enc_lb = {offset, rs1, 3'b000, rd, 7'h03}; end
endfunction
// enc_lhu: combinational helper function
function [31:0] enc_lhu;
    input [4:0] rd, rs1;
    input [11:0] offset;
    begin enc_lhu = {offset, rs1, 3'b101, rd, 7'h03}; end
endfunction
// enc_lbu: combinational helper function
function [31:0] enc_lbu;
    input [4:0] rd, rs1;
    input [11:0] offset;
    begin enc_lbu = {offset, rs1, 3'b100, rd, 7'h03}; end
endfunction
// enc_beq: combinational helper function
function [31:0] enc_beq;
    input [4:0] rs1, rs2;
    input [12:0] offset;
    begin
        enc_beq = {offset[12], offset[10:5], rs2, rs1,
                   3'b000, offset[4:1], offset[11], 7'h63};
    end
endfunction
// enc_bne: combinational helper function
function [31:0] enc_bne;
    input [4:0] rs1, rs2;
    input [12:0] offset;
    begin
        enc_bne = {offset[12], offset[10:5], rs2, rs1,
                   3'b001, offset[4:1], offset[11], 7'h63};
    end
endfunction
// enc_blt: combinational helper function
function [31:0] enc_blt;
    input [4:0] rs1, rs2;
    input [12:0] offset;
    begin
        enc_blt = {offset[12], offset[10:5], rs2, rs1,
                   3'b100, offset[4:1], offset[11], 7'h63};
    end
endfunction
// enc_bge: combinational helper function
function [31:0] enc_bge;
    input [4:0] rs1, rs2;
    input [12:0] offset;
    begin
        enc_bge = {offset[12], offset[10:5], rs2, rs1,
                   3'b101, offset[4:1], offset[11], 7'h63};
    end
endfunction
// enc_jal: combinational helper function
function [31:0] enc_jal;
    input [4:0] rd;
    input [20:0] offset;
    begin
        enc_jal = {offset[20], offset[10:1], offset[11], offset[19:12], rd, 7'h6F};
    end
endfunction
// enc_jalr: combinational helper function
function [31:0] enc_jalr;
    input [4:0] rd, rs1;
    input [11:0] offset;
    begin enc_jalr = {offset, rs1, 3'b000, rd, 7'h67}; end
endfunction
// enc_mul: combinational helper function
function [31:0] enc_mul;
    input [4:0] rd, rs1, rs2;
    begin enc_mul = {7'b0000001, rs2, rs1, 3'b000, rd, 7'h33}; end
endfunction
// enc_mulh: combinational helper function
function [31:0] enc_mulh;
    input [4:0] rd, rs1, rs2;
    begin enc_mulh = {7'b0000001, rs2, rs1, 3'b001, rd, 7'h33}; end
endfunction
// enc_mulhu: combinational helper function
function [31:0] enc_mulhu;
    input [4:0] rd, rs1, rs2;
    begin enc_mulhu = {7'b0000001, rs2, rs1, 3'b011, rd, 7'h33}; end
endfunction
// enc_mulhsu: combinational helper function
function [31:0] enc_mulhsu;
    input [4:0] rd, rs1, rs2;
    begin enc_mulhsu = {7'b0000001, rs2, rs1, 3'b010, rd, 7'h33}; end
endfunction
// enc_div: combinational helper function
function [31:0] enc_div;
    input [4:0] rd, rs1, rs2;
    begin enc_div = {7'b0000001, rs2, rs1, 3'b100, rd, 7'h33}; end
endfunction
// enc_divu: combinational helper function
function [31:0] enc_divu;
    input [4:0] rd, rs1, rs2;
    begin enc_divu = {7'b0000001, rs2, rs1, 3'b101, rd, 7'h33}; end
endfunction
// enc_rem: combinational helper function
function [31:0] enc_rem;
    input [4:0] rd, rs1, rs2;
    begin enc_rem = {7'b0000001, rs2, rs1, 3'b110, rd, 7'h33}; end
endfunction
// enc_remu: combinational helper function
function [31:0] enc_remu;
    input [4:0] rd, rs1, rs2;
    begin enc_remu = {7'b0000001, rs2, rs1, 3'b111, rd, 7'h33}; end
endfunction
// enc_slli: combinational helper function
function [31:0] enc_slli;
    input [4:0] rd, rs1, shamt;
    begin enc_slli = {7'b0000000, shamt, rs1, 3'b001, rd, 7'h13}; end
endfunction
// enc_srli: combinational helper function
function [31:0] enc_srli;
    input [4:0] rd, rs1, shamt;
    begin enc_srli = {7'b0000000, shamt, rs1, 3'b101, rd, 7'h13}; end
endfunction
// enc_srai: combinational helper function
function [31:0] enc_srai;
    input [4:0] rd, rs1, shamt;
    begin enc_srai = {7'b0100000, shamt, rs1, 3'b101, rd, 7'h13}; end
endfunction
// enc_andi: combinational helper function
function [31:0] enc_andi;
    input [4:0] rd, rs1;
    input [11:0] imm;
    begin enc_andi = {imm, rs1, 3'b111, rd, 7'h13}; end
endfunction

// enc_ori: combinational helper function
function [31:0] enc_ori;
    input [4:0] rd, rs1;
    input [11:0] imm;
    begin enc_ori = {imm, rs1, 3'b110, rd, 7'h13}; end
endfunction

// enc_xori: combinational helper function
function [31:0] enc_xori;
    input [4:0] rd, rs1;
    input [11:0] imm;
    begin enc_xori = {imm, rs1, 3'b100, rd, 7'h13}; end
endfunction
// enc_slti: combinational helper function
function [31:0] enc_slti;
    input [4:0] rd, rs1;
    input [11:0] imm;
    begin enc_slti = {imm, rs1, 3'b010, rd, 7'h13}; end
endfunction
// Simulation initialisation or stimulus block
initial begin
    #10_000_000;
    $display("WATCHDOG TIMEOUT");
    $display("RESULT: %0d/50 passed", pass_count);
    $finish;
end

localparam [19:0] DMEM_HI = 20'h20010;
`define SET_X2_DMEM(base) \
    store_instr(base, enc_lui(5'd2, DMEM_HI))
reg [31:0] got_data;
reg        got_ok;
reg [31:0] ar_addr_obs;
reg        ar_ok;
reg ar_seen;
integer ar_wait;

// Simulation initialisation or stimulus block
initial begin
    pass_count = 0;
    fail_count = 0;
    $dumpfile("tb_rv32im_core.vcd");
    $dumpvars(0, tb_rv32im_core);
    init_mem();
    do_reset();
    ar_seen = 0;
    for (ar_wait = 0; ar_wait < 30; ar_wait = ar_wait + 1) begin
        @(posedge clk); #1;
        if (dmem_arvalid && dmem_araddr == 32'h2000_0000)
            ar_seen = 1;
    end
    if (ar_seen) pass(1); else fail(1, "no fetch to RESET_ADDR");
    init_mem();
    do_reset();
    begin : tc02
        integer w;
        reg saw_hs;
        reg saw_deassert;
        saw_hs       = 0;
        saw_deassert = 0;
        for (w = 0; w < 40 && !saw_deassert; w = w + 1) begin
            @(posedge clk); #1;
            if (dmem_arvalid && dmem_arready)
                saw_hs = 1;
            if (saw_hs && !dmem_arvalid)
                saw_deassert = 1;
        end
        if (saw_deassert) pass(2); else fail(2, "arvalid did not deassert");
    end
    init_mem();
    do_reset();
    begin : tc03
        integer w;
        reg saw_rready;
        saw_rready = 0;
        for (w = 0; w < 40; w = w + 1) begin
            @(posedge clk); #1;
            if (dmem_rready) saw_rready = 1;
        end
        if (saw_rready) pass(3); else fail(3, "rready never asserted");
    end
    init_mem();
    do_reset();
    begin : tc04
        integer w;
        reg saw_4;
        saw_4 = 0;
        for (w = 0; w < 60; w = w + 1) begin
            @(posedge clk); #1;
            if (dmem_arvalid && dmem_araddr == 32'h2000_0004)
                saw_4 = 1;
        end
        if (saw_4) pass(4); else fail(4, "no fetch to 0x20000004");
    end
    init_mem();
    do_reset();
    run_cycles(20);
    rst_n = 0;
    repeat(4) @(posedge clk);
    @(negedge clk); rst_n = 1;
    begin : tc05
        integer w;
        reg saw_reset_fetch;
        saw_reset_fetch = 0;
        for (w = 0; w < 30; w = w + 1) begin
            @(posedge clk); #1;
            if (dmem_arvalid && dmem_araddr == 32'h2000_0000)
                saw_reset_fetch = 1;
        end
        if (saw_reset_fetch) pass(5); else fail(5, "no re-fetch after second reset");
    end
    init_mem();
    store_instr(32'h2000_0000, enc_lui(5'd2, DMEM_HI));
    store_instr(32'h2000_0004, enc_lui(5'd1, 20'hABCDE));
    store_instr(32'h2000_0008, enc_sw(5'd2, 5'd1, 12'd0));
    do_reset();
    wait_store(DMEM_BASE, 200, got_data, got_ok);
    if (got_ok && got_data == 32'hABCDE000) pass(6);
    else begin $display("  TC06 got_data=%08h ok=%0d", got_data, got_ok); fail(6, "LUI wrong value"); end
    init_mem();
    store_instr(32'h2000_0000, enc_lui(5'd2, DMEM_HI));
    store_instr(32'h2000_0004, enc_addi(5'd1, 5'd0, 12'd42));
    store_instr(32'h2000_0008, enc_sw(5'd2, 5'd1, 12'd0));
    do_reset();
    wait_store(DMEM_BASE, 200, got_data, got_ok);
    if (got_ok && got_data == 32'd42) pass(7);
    else begin $display("  TC07 got=%08h", got_data); fail(7, "ADDI wrong"); end
    init_mem();
    store_instr(32'h2000_0000, enc_lui(5'd2, DMEM_HI));
    store_instr(32'h2000_0004, enc_addi(5'd1, 5'd0, 12'd10));
    store_instr(32'h2000_0008, enc_addi(5'd3, 5'd0, 12'd20));
    store_instr(32'h2000_000C, enc_add(5'd5, 5'd1, 5'd3));
    store_instr(32'h2000_0010, enc_sw(5'd2, 5'd5, 12'd0));
    do_reset();
    wait_store(DMEM_BASE, 300, got_data, got_ok);
    if (got_ok && got_data == 32'd30) pass(8);
    else begin $display("  TC08 got=%08h", got_data); fail(8, "ADD wrong"); end
    init_mem();
    store_instr(32'h2000_0000, enc_lui(5'd2, DMEM_HI));
    store_instr(32'h2000_0004, enc_lui(5'd1, 20'h000FF));
    store_instr(32'h2000_0008, enc_addi(5'd1, 5'd1, 12'hFF));
    store_instr(32'h2000_0000, enc_lui(5'd2, DMEM_HI));
    store_instr(32'h2000_0004, enc_addi(5'd1, 5'd0, 12'hF0));
    store_instr(32'h2000_0008, enc_addi(5'd3, 5'd0, 12'hFF));
    store_instr(32'h2000_000C, enc_and(5'd5, 5'd1, 5'd3));
    store_instr(32'h2000_0010, enc_sw(5'd2, 5'd5, 12'd0));
    do_reset();
    wait_store(DMEM_BASE, 300, got_data, got_ok);
    if (got_ok && got_data == 32'hF0) pass(9);
    else begin $display("  TC09 got=%08h", got_data); fail(9, "AND wrong"); end
    init_mem();
    store_instr(32'h2000_0000, enc_lui(5'd2, DMEM_HI));
    store_instr(32'h2000_0004, enc_addi(5'd1, 5'd0, 12'h0F));
    store_instr(32'h2000_0008, enc_addi(5'd3, 5'd0, 12'hF0));
    store_instr(32'h2000_000C, enc_or(5'd5, 5'd1, 5'd3));
    store_instr(32'h2000_0010, enc_sw(5'd2, 5'd5, 12'd0));
    do_reset();
    wait_store(DMEM_BASE, 300, got_data, got_ok);
    if (got_ok && got_data == 32'hFF) pass(10);
    else begin $display("  TC10 got=%08h", got_data); fail(10, "OR wrong"); end
    init_mem();
    store_instr(32'h2000_0000, enc_lui(5'd2, DMEM_HI));
    store_instr(32'h2000_0004, enc_addi(5'd1, 5'd0, 12'hFF));
    store_instr(32'h2000_0008, enc_addi(5'd3, 5'd0, 12'h0F));
    store_instr(32'h2000_000C, enc_xor(5'd5, 5'd1, 5'd3));
    store_instr(32'h2000_0010, enc_sw(5'd2, 5'd5, 12'd0));
    do_reset();
    wait_store(DMEM_BASE, 300, got_data, got_ok);
    if (got_ok && got_data == 32'hF0) pass(11);
    else begin $display("  TC11 got=%08h", got_data); fail(11, "XOR wrong"); end
    init_mem();
    store_instr(32'h2000_0000, enc_lui(5'd2, DMEM_HI));
    store_instr(32'h2000_0004, enc_addi(5'd1, 5'd0, 12'd1));
    store_instr(32'h2000_0008, enc_addi(5'd3, 5'd0, 12'd4));
    store_instr(32'h2000_000C, enc_sll(5'd5, 5'd1, 5'd3));
    store_instr(32'h2000_0010, enc_sw(5'd2, 5'd5, 12'd0));
    do_reset();
    wait_store(DMEM_BASE, 300, got_data, got_ok);
    if (got_ok && got_data == 32'd16) pass(12);
    else begin $display("  TC12 got=%08h", got_data); fail(12, "SLL wrong"); end
    init_mem();
    store_instr(32'h2000_0000, enc_lui(5'd2, DMEM_HI));
    store_instr(32'h2000_0004, enc_lui(5'd1, 20'h80000));
    store_instr(32'h2000_0008, enc_addi(5'd3, 5'd0, 12'd1));
    store_instr(32'h2000_000C, enc_srl(5'd5, 5'd1, 5'd3));
    store_instr(32'h2000_0010, enc_sw(5'd2, 5'd5, 12'd0));
    do_reset();
    wait_store(DMEM_BASE, 300, got_data, got_ok);
    if (got_ok && got_data == 32'h4000_0000) pass(13);
    else begin $display("  TC13 got=%08h", got_data); fail(13, "SRL wrong"); end
    init_mem();
    store_instr(32'h2000_0000, enc_lui(5'd2, DMEM_HI));
    store_instr(32'h2000_0004, enc_addi(5'd1, 5'd0, 12'd100));
    store_instr(32'h2000_0008, enc_addi(5'd3, 5'd0, 12'd37));
    store_instr(32'h2000_000C, enc_sub(5'd5, 5'd1, 5'd3));
    store_instr(32'h2000_0010, enc_sw(5'd2, 5'd5, 12'd0));
    do_reset();
    wait_store(DMEM_BASE, 300, got_data, got_ok);
    if (got_ok && got_data == 32'd63) pass(14);
    else begin $display("  TC14 got=%08h", got_data); fail(14, "SUB wrong"); end
    init_mem();
    store_instr(32'h2000_0000, enc_lui(5'd2, DMEM_HI));
    store_instr(32'h2000_0004, enc_auipc(5'd1, 20'd0));
    store_instr(32'h2000_0008, enc_sw(5'd2, 5'd1, 12'd0));
    do_reset();
    wait_store(DMEM_BASE, 300, got_data, got_ok);
    if (got_ok && got_data == 32'h2000_0004) pass(15);
    else begin $display("  TC15 got=%08h", got_data); fail(15, "AUIPC wrong"); end
    init_mem();
    store_instr(32'h2000_0000, enc_lui(5'd2, DMEM_HI));
    store_instr(32'h2000_0004, enc_addi(5'd1, 5'd0, 12'd5));
    store_instr(32'h2000_0008, enc_addi(5'd3, 5'd0, 12'd5));
    store_instr(32'h2000_000C, enc_beq(5'd1, 5'd3, 13'd8));
    store_instr(32'h2000_0010, enc_sw(5'd2, 5'd0, 12'd0));
    store_instr(32'h2000_0014, enc_addi(5'd5, 5'd0, 12'hAA));
    store_instr(32'h2000_0018, enc_sw(5'd2, 5'd5, 12'd0));
    do_reset();
    wait_store(DMEM_BASE, 400, got_data, got_ok);
    if (got_ok && got_data == 32'hAA) pass(16);
    else begin $display("  TC16 got=%08h ok=%0d", got_data, got_ok); fail(16, "BEQ taken wrong"); end
    init_mem();
    store_instr(32'h2000_0000, enc_lui(5'd2, DMEM_HI));
    store_instr(32'h2000_0004, enc_addi(5'd1, 5'd0, 12'd5));
    store_instr(32'h2000_0008, enc_addi(5'd3, 5'd0, 12'd6));
    store_instr(32'h2000_000C, enc_beq(5'd1, 5'd3, 13'd8));
    store_instr(32'h2000_0010, enc_addi(5'd5, 5'd0, 12'hBB));
    store_instr(32'h2000_0014, enc_sw(5'd2, 5'd5, 12'd0));
    do_reset();
    wait_store(DMEM_BASE, 400, got_data, got_ok);
    if (got_ok && got_data == 32'hBB) pass(17);
    else begin $display("  TC17 got=%08h ok=%0d", got_data, got_ok); fail(17, "BEQ not-taken wrong"); end
    init_mem();
    store_instr(32'h2000_0000, enc_lui(5'd2, DMEM_HI));
    store_instr(32'h2000_0004, enc_addi(5'd1, 5'd0, 12'd1));
    store_instr(32'h2000_0008, enc_addi(5'd3, 5'd0, 12'd2));
    store_instr(32'h2000_000C, enc_bne(5'd1, 5'd3, 13'd8));
    store_instr(32'h2000_0010, enc_sw(5'd2, 5'd0, 12'd0));
    store_instr(32'h2000_0014, enc_addi(5'd5, 5'd0, 12'hCC));
    store_instr(32'h2000_0018, enc_sw(5'd2, 5'd5, 12'd0));
    do_reset();
    wait_store(DMEM_BASE, 400, got_data, got_ok);
    if (got_ok && got_data == 32'hCC) pass(18);
    else begin $display("  TC18 got=%08h", got_data); fail(18, "BNE taken wrong"); end
    init_mem();
    store_instr(32'h2000_0000, enc_lui(5'd2, DMEM_HI));
    store_instr(32'h2000_0004, enc_addi(5'd1, 5'd0, 12'd1));
    store_instr(32'h2000_0008, enc_addi(5'd3, 5'd0, 12'd10));
    store_instr(32'h2000_000C, enc_blt(5'd1, 5'd3, 13'd8));
    store_instr(32'h2000_0010, enc_sw(5'd2, 5'd0, 12'd0));
    store_instr(32'h2000_0014, enc_addi(5'd5, 5'd0, 12'hDD));
    store_instr(32'h2000_0018, enc_sw(5'd2, 5'd5, 12'd0));
    do_reset();
    wait_store(DMEM_BASE, 400, got_data, got_ok);
    if (got_ok && got_data == 32'hDD) pass(19);
    else begin $display("  TC19 got=%08h", got_data); fail(19, "BLT taken wrong"); end
    init_mem();
    store_instr(32'h2000_0000, enc_lui(5'd2, DMEM_HI));
    store_instr(32'h2000_0004, enc_addi(5'd1, 5'd0, 12'd1));
    store_instr(32'h2000_0008, enc_addi(5'd3, 5'd0, 12'd10));
    store_instr(32'h2000_000C, enc_bge(5'd1, 5'd3, 13'd8));
    store_instr(32'h2000_0010, enc_addi(5'd5, 5'd0, 12'hEE));
    store_instr(32'h2000_0014, enc_sw(5'd2, 5'd5, 12'd0));
    do_reset();
    wait_store(DMEM_BASE, 400, got_data, got_ok);
    if (got_ok && got_data == 32'hEE) pass(20);
    else begin $display("  TC20 got=%08h", got_data); fail(20, "BGE not-taken wrong"); end
    init_mem();
    dmem[0] = 32'hDEAD_BEEF;
    store_instr(32'h2000_0000, enc_lui(5'd2, DMEM_HI));
    store_instr(32'h2000_0004, enc_lw(5'd1, 5'd2, 12'd0));
    store_instr(32'h2000_0008, enc_sw(5'd2, 5'd1, 12'd4));
    do_reset();
    wait_store(DMEM_BASE + 4, 400, got_data, got_ok);
    if (got_ok && got_data == 32'hDEAD_BEEF) pass(21);
    else begin $display("  TC21 got=%08h ok=%0d", got_data, got_ok); fail(21, "LW wrong"); end
    init_mem();
    dmem[0] = 32'h0000_8001;
    store_instr(32'h2000_0000, enc_lui(5'd2, DMEM_HI));
    store_instr(32'h2000_0004, enc_lh(5'd1, 5'd2, 12'd0));
    store_instr(32'h2000_0008, enc_sw(5'd2, 5'd1, 12'd4));
    do_reset();
    wait_store(DMEM_BASE + 4, 400, got_data, got_ok);
    if (got_ok && got_data == 32'hFFFF_8001) pass(22);
    else begin $display("  TC22 got=%08h ok=%0d", got_data, got_ok); fail(22, "LH sign-ext wrong"); end
    init_mem();
    dmem[0] = 32'h0000_00FF;
    store_instr(32'h2000_0000, enc_lui(5'd2, DMEM_HI));
    store_instr(32'h2000_0004, enc_lb(5'd1, 5'd2, 12'd0));
    store_instr(32'h2000_0008, enc_sw(5'd2, 5'd1, 12'd4));
    do_reset();
    wait_store(DMEM_BASE + 4, 400, got_data, got_ok);
    if (got_ok && got_data == 32'hFFFF_FFFF) pass(23);
    else begin $display("  TC23 got=%08h ok=%0d", got_data, got_ok); fail(23, "LB sign-ext wrong"); end
    init_mem();
    dmem[0] = 32'h0000_00FF;
    store_instr(32'h2000_0000, enc_lui(5'd2, DMEM_HI));
    store_instr(32'h2000_0004, enc_lbu(5'd1, 5'd2, 12'd0));
    store_instr(32'h2000_0008, enc_sw(5'd2, 5'd1, 12'd4));
    do_reset();
    wait_store(DMEM_BASE + 4, 400, got_data, got_ok);
    if (got_ok && got_data == 32'h0000_00FF) pass(24);
    else begin $display("  TC24 got=%08h ok=%0d", got_data, got_ok); fail(24, "LBU wrong"); end
    init_mem();
    dmem[0] = 32'h0000_CAFE;
    store_instr(32'h2000_0000, enc_lui(5'd2, DMEM_HI));
    store_instr(32'h2000_0004, enc_lhu(5'd1, 5'd2, 12'd0));
    store_instr(32'h2000_0008, enc_sw(5'd2, 5'd1, 12'd4));
    do_reset();
    wait_store(DMEM_BASE + 4, 400, got_data, got_ok);
    if (got_ok && got_data == 32'h0000_CAFE) pass(25);
    else begin $display("  TC25 got=%08h ok=%0d", got_data, got_ok); fail(25, "LHU wrong"); end
    init_mem();
    store_instr(32'h2000_0000, enc_lui(5'd2, DMEM_HI));
    store_instr(32'h2000_0004, enc_addi(5'd1, 5'd0, 12'h5A));
    store_instr(32'h2000_0008, enc_sw(5'd2, 5'd1, 12'd0));
    do_reset();
    begin : tc26
        integer w;
        reg saw_sw;
        saw_sw = 0;
        for (w = 0; w < 400; w = w + 1) begin
            @(posedge clk); #1;
            if (dmem_awvalid && dmem_wvalid &&
                dmem_awaddr == DMEM_BASE &&
                dmem_wstrb == 4'b1111 &&
                dmem_wdata == 32'h5A) begin
                saw_sw = 1;
            end
        end
        if (saw_sw) pass(26); else fail(26, "SW wstrb/data wrong");
    end
    init_mem();
    store_instr(32'h2000_0000, enc_lui(5'd2, DMEM_HI));
    store_instr(32'h2000_0004, enc_addi(5'd1, 5'd0, 12'h1234));
    store_instr(32'h2000_0008, enc_sh(5'd2, 5'd1, 12'd0));
    do_reset();
    begin : tc27
        integer w;
        reg saw_sh;
        saw_sh = 0;
        for (w = 0; w < 300; w = w + 1) begin
            @(posedge clk); #1;
            if (dmem_awvalid && dmem_wvalid &&
                dmem_awaddr == DMEM_BASE &&
                dmem_wstrb == 4'b0011) begin
                saw_sh = 1;
            end
        end
        if (saw_sh) pass(27); else fail(27, "SH wstrb wrong");
    end
    init_mem();
    store_instr(32'h2000_0000, enc_lui(5'd2, DMEM_HI));
    store_instr(32'h2000_0004, enc_addi(5'd1, 5'd0, 12'hAB));
    store_instr(32'h2000_0008, enc_sb(5'd2, 5'd1, 12'd0));
    do_reset();
    begin : tc28
        integer w;
        reg saw_sb;
        saw_sb = 0;
        for (w = 0; w < 300; w = w + 1) begin
            @(posedge clk); #1;
            if (dmem_awvalid && dmem_wvalid &&
                dmem_awaddr == DMEM_BASE &&
                dmem_wstrb == 4'b0001) begin
                saw_sb = 1;
            end
        end
        if (saw_sb) pass(28); else fail(28, "SB wstrb offset-0 wrong");
    end
    init_mem();
    store_instr(32'h2000_0000, enc_lui(5'd2, DMEM_HI));
    store_instr(32'h2000_0004, enc_addi(5'd1, 5'd0, 12'hAB));
    store_instr(32'h2000_0008, enc_sb(5'd2, 5'd1, 12'd1));
    do_reset();
    begin : tc29
        integer w;
        reg saw_sb1;
        saw_sb1 = 0;
        for (w = 0; w < 300; w = w + 1) begin
            @(posedge clk); #1;
            if (dmem_awvalid && dmem_wvalid &&
                dmem_awaddr == (DMEM_BASE + 1) &&
                dmem_wstrb == 4'b0010) begin
                saw_sb1 = 1;
            end
        end
        if (saw_sb1) pass(29); else fail(29, "SB wstrb offset-1 wrong");
    end
    init_mem();
    store_instr(32'h2000_0000, enc_lui(5'd2, DMEM_HI));
    store_instr(32'h2000_0004, enc_addi(5'd1, 5'd0, 12'h7F));
    store_instr(32'h2000_0008, enc_sw(5'd2, 5'd1, 12'd8));
    do_reset();
    wait_store(DMEM_BASE + 8, 300, got_data, got_ok);
    if (got_ok && got_data == 32'h7F) pass(30);
    else begin $display("  TC30 got=%08h ok=%0d", got_data, got_ok); fail(30, "SW offset wrong"); end
    init_mem();
    store_instr(32'h2000_0000, enc_lui(5'd2, DMEM_HI));
    store_instr(32'h2000_0004, enc_jal(5'd1, 21'd8));
    store_instr(32'h2000_0008, enc_sw(5'd2, 5'd0, 12'd0));
    store_instr(32'h2000_000C, enc_addi(5'd5, 5'd0, 12'h31));
    store_instr(32'h2000_0010, enc_sw(5'd2, 5'd5, 12'd0));
    store_instr(32'h2000_0014, enc_sw(5'd2, 5'd1, 12'd4));
    do_reset();
    wait_store(DMEM_BASE, 400, got_data, got_ok);
    if (got_ok && got_data == 32'h31) pass(31);
    else begin $display("  TC31 got=%08h ok=%0d", got_data, got_ok); fail(31, "JAL target wrong"); end
    init_mem();
    store_instr(32'h2000_0000, enc_lui(5'd2, DMEM_HI));
    store_instr(32'h2000_0004, enc_jal(5'd1, 21'd8));
    store_instr(32'h2000_0008, enc_sw(5'd2, 5'd0, 12'd0));
    store_instr(32'h2000_000C, enc_sw(5'd2, 5'd1, 12'd0));
    do_reset();
    wait_store(DMEM_BASE, 400, got_data, got_ok);
    if (got_ok && got_data == 32'h2000_0008) pass(32);
    else begin $display("  TC32 got=%08h ok=%0d", got_data, got_ok); fail(32, "JAL rd wrong"); end
    init_mem();
    store_instr(32'h2000_0000, enc_lui(5'd2, DMEM_HI));
    store_instr(32'h2000_0004, enc_lui(5'd3, 20'h20000));
    store_instr(32'h2000_0008, enc_jalr(5'd1, 5'd3, 12'h014));
    store_instr(32'h2000_000C, enc_sw(5'd2, 5'd0, 12'd0));
    store_instr(32'h2000_0010, enc_sw(5'd2, 5'd0, 12'd0));
    store_instr(32'h2000_0014, enc_addi(5'd5, 5'd0, 12'h33));
    store_instr(32'h2000_0018, enc_sw(5'd2, 5'd5, 12'd0));
    do_reset();
    wait_store(DMEM_BASE, 500, got_data, got_ok);
    if (got_ok && got_data == 32'h33) pass(33);
    else begin $display("  TC33 got=%08h ok=%0d", got_data, got_ok); fail(33, "JALR target wrong"); end
    init_mem();
    store_instr(32'h2000_0000, enc_lui(5'd2, DMEM_HI));
    store_instr(32'h2000_0004, enc_lui(5'd3, 20'h20000));
    store_instr(32'h2000_0008, enc_jalr(5'd1, 5'd3, 12'h014));
    store_instr(32'h2000_000C, enc_sw(5'd2, 5'd0, 12'd0));
    store_instr(32'h2000_0010, enc_sw(5'd2, 5'd0, 12'd0));
    store_instr(32'h2000_0014, enc_sw(5'd2, 5'd1, 12'd0));
    do_reset();
    wait_store(DMEM_BASE, 500, got_data, got_ok);
    if (got_ok && got_data == 32'h2000_000C) pass(34);
    else begin $display("  TC34 got=%08h ok=%0d", got_data, got_ok); fail(34, "JALR rd wrong"); end
    init_mem();
    store_instr(32'h2000_0000, enc_lui(5'd2, DMEM_HI));
    store_instr(32'h2000_0004, enc_jal(5'd0, 21'd8));
    store_instr(32'h2000_0008, enc_sw(5'd2, 5'd0, 12'd0));
    store_instr(32'h2000_000C, enc_addi(5'd5, 5'd0, 12'h35));
    store_instr(32'h2000_0010, enc_sw(5'd2, 5'd5, 12'd0));
    do_reset();
    wait_store(DMEM_BASE, 400, got_data, got_ok);
    if (got_ok && got_data == 32'h35) pass(35);
    else begin $display("  TC35 got=%08h ok=%0d", got_data, got_ok); fail(35, "JAL x0 wrong"); end
    init_mem();
    store_instr(32'h2000_0000, enc_lui(5'd2, DMEM_HI));
    store_instr(32'h2000_0004, enc_addi(5'd1, 5'd0, 12'd6));
    store_instr(32'h2000_0008, enc_addi(5'd3, 5'd0, 12'd7));
    store_instr(32'h2000_000C, enc_mul(5'd5, 5'd1, 5'd3));
    store_instr(32'h2000_0010, enc_sw(5'd2, 5'd5, 12'd0));
    do_reset();
    wait_store(DMEM_BASE, 600, got_data, got_ok);
    if (got_ok && got_data == 32'd42) pass(36);
    else begin $display("  TC36 got=%08h ok=%0d", got_data, got_ok); fail(36, "MUL wrong"); end
    init_mem();
    store_instr(32'h2000_0000, enc_lui(5'd2, DMEM_HI));
    store_instr(32'h2000_0004, enc_addi(5'd1, 5'd0, 12'h100));
    store_instr(32'h2000_0008, enc_addi(5'd3, 5'd0, 12'h100));
    store_instr(32'h2000_000C, enc_mul(5'd5, 5'd1, 5'd3));
    store_instr(32'h2000_0010, enc_sw(5'd2, 5'd5, 12'd0));
    do_reset();
    wait_store(DMEM_BASE, 600, got_data, got_ok);
    if (got_ok && got_data == 32'h10000) pass(37);
    else begin $display("  TC37 got=%08h ok=%0d", got_data, got_ok); fail(37, "MUL large wrong"); end
    init_mem();
    store_instr(32'h2000_0000, enc_lui(5'd2, DMEM_HI));
    store_instr(32'h2000_0004, enc_addi(5'd1, 5'd0, 12'hFFF));
    store_instr(32'h2000_0008, enc_addi(5'd3, 5'd0, 12'hFFF));
    store_instr(32'h2000_000C, enc_mulh(5'd5, 5'd1, 5'd3));
    store_instr(32'h2000_0010, enc_sw(5'd2, 5'd5, 12'd0));
    do_reset();
    wait_store(DMEM_BASE, 600, got_data, got_ok);
    if (got_ok && got_data == 32'd0) pass(38);
    else begin $display("  TC38 got=%08h ok=%0d", got_data, got_ok); fail(38, "MULH wrong"); end
    init_mem();
    store_instr(32'h2000_0000, enc_lui(5'd2, DMEM_HI));
    store_instr(32'h2000_0004, enc_addi(5'd1, 5'd0, 12'hFFF));
    store_instr(32'h2000_0008, enc_addi(5'd3, 5'd0, 12'hFFF));
    store_instr(32'h2000_000C, enc_mulhu(5'd5, 5'd1, 5'd3));
    store_instr(32'h2000_0010, enc_sw(5'd2, 5'd5, 12'd0));
    do_reset();
    wait_store(DMEM_BASE, 600, got_data, got_ok);
    if (got_ok && got_data == 32'hFFFF_FFFE) pass(39);
    else begin $display("  TC39 got=%08h ok=%0d", got_data, got_ok); fail(39, "MULHU wrong"); end
    init_mem();
    store_instr(32'h2000_0000, enc_lui(5'd2, DMEM_HI));
    store_instr(32'h2000_0004, enc_addi(5'd1, 5'd0, 12'd99));
    store_instr(32'h2000_0008, enc_addi(5'd3, 5'd0, 12'd0));
    store_instr(32'h2000_000C, enc_mul(5'd5, 5'd1, 5'd3));
    store_instr(32'h2000_0010, enc_sw(5'd2, 5'd5, 12'd0));
    do_reset();
    wait_store(DMEM_BASE, 600, got_data, got_ok);
    if (got_ok && got_data == 32'd0) pass(40);
    else begin $display("  TC40 got=%08h ok=%0d", got_data, got_ok); fail(40, "MUL by zero wrong"); end
    init_mem();
    store_instr(32'h2000_0000, enc_lui(5'd2, DMEM_HI));
    store_instr(32'h2000_0004, enc_addi(5'd1, 5'd0, 12'd100));
    store_instr(32'h2000_0008, enc_addi(5'd3, 5'd0, 12'd5));
    store_instr(32'h2000_000C, enc_div(5'd5, 5'd1, 5'd3));
    store_instr(32'h2000_0010, enc_sw(5'd2, 5'd5, 12'd0));
    do_reset();
    wait_store(DMEM_BASE, 2000, got_data, got_ok);
    if (got_ok && got_data == 32'd20) pass(41);
    else begin $display("  TC41 got=%08h ok=%0d", got_data, got_ok); fail(41, "DIV wrong"); end
    init_mem();
    store_instr(32'h2000_0000, enc_lui(5'd2, DMEM_HI));
    store_instr(32'h2000_0004, enc_addi(5'd1, 5'd0, 12'd100));
    store_instr(32'h2000_0008, enc_addi(5'd3, 5'd0, 12'd3));
    store_instr(32'h2000_000C, enc_divu(5'd5, 5'd1, 5'd3));
    store_instr(32'h2000_0010, enc_sw(5'd2, 5'd5, 12'd0));
    do_reset();
    wait_store(DMEM_BASE, 2000, got_data, got_ok);
    if (got_ok && got_data == 32'd33) pass(42);
    else begin $display("  TC42 got=%08h ok=%0d", got_data, got_ok); fail(42, "DIVU wrong"); end
    init_mem();
    store_instr(32'h2000_0000, enc_lui(5'd2, DMEM_HI));
    store_instr(32'h2000_0004, enc_addi(5'd1, 5'd0, 12'd100));
    store_instr(32'h2000_0008, enc_addi(5'd3, 5'd0, 12'd7));
    store_instr(32'h2000_000C, enc_rem(5'd5, 5'd1, 5'd3));
    store_instr(32'h2000_0010, enc_sw(5'd2, 5'd5, 12'd0));
    do_reset();
    wait_store(DMEM_BASE, 2000, got_data, got_ok);
    if (got_ok && got_data == 32'd2) pass(43);
    else begin $display("  TC43 got=%08h ok=%0d", got_data, got_ok); fail(43, "REM wrong"); end
    init_mem();
    store_instr(32'h2000_0000, enc_lui(5'd2, DMEM_HI));
    store_instr(32'h2000_0004, enc_addi(5'd1, 5'd0, 12'd100));
    store_instr(32'h2000_0008, enc_addi(5'd3, 5'd0, 12'd7));
    store_instr(32'h2000_000C, enc_remu(5'd5, 5'd1, 5'd3));
    store_instr(32'h2000_0010, enc_sw(5'd2, 5'd5, 12'd0));
    do_reset();
    wait_store(DMEM_BASE, 2000, got_data, got_ok);
    if (got_ok && got_data == 32'd2) pass(44);
    else begin $display("  TC44 got=%08h ok=%0d", got_data, got_ok); fail(44, "REMU wrong"); end
    init_mem();
    store_instr(32'h2000_0000, enc_lui(5'd2, DMEM_HI));
    store_instr(32'h2000_0004, enc_addi(5'd1, 5'd0, 12'hFF4));
    store_instr(32'h2000_0008, enc_addi(5'd3, 5'd0, 12'd3));
    store_instr(32'h2000_000C, enc_div(5'd5, 5'd1, 5'd3));
    store_instr(32'h2000_0010, enc_sw(5'd2, 5'd5, 12'd0));
    do_reset();
    wait_store(DMEM_BASE, 2000, got_data, got_ok);
    if (got_ok && got_data == 32'hFFFF_FFFC) pass(45);
    else begin $display("  TC45 got=%08h ok=%0d", got_data, got_ok); fail(45, "DIV signed wrong"); end
    init_mem();
    store_instr(32'h2000_0000, enc_lui(5'd2, DMEM_HI));
    store_instr(32'h2000_0004, `NOP);
    store_instr(32'h2000_0008, `NOP);
    store_instr(32'h2000_000C, `NOP);
    store_instr(32'h2000_0010, `NOP);
    store_instr(32'h2000_0014, `NOP);
    store_instr(32'h2000_0018, `NOP);
    store_instr(32'h2000_001C, `NOP);
    store_instr(32'h2000_0020, enc_addi(5'd5, 5'd0, 12'h46));
    store_instr(32'h2000_0024, enc_sw(5'd2, 5'd5, 12'd0));
    do_reset();
    wait_store(DMEM_BASE, 600, got_data, got_ok);
    if (got_ok && got_data == 32'h46) pass(46);
    else begin $display("  TC46 got=%08h ok=%0d", got_data, got_ok); fail(46, "NOP sequence wrong"); end
    init_mem();
    store_instr(32'h2000_0000, enc_lui(5'd2, DMEM_HI));
    store_instr(32'h2000_0004, enc_addi(5'd5, 5'd0, 12'h47));
    store_instr(32'h2000_0008, enc_sw(5'd2, 5'd5, 12'd0));
    store_instr(32'h2000_000C, enc_addi(5'd6, 5'd0, 12'hA7));
    store_instr(32'h2000_0010, enc_sw(5'd2, 5'd6, 12'd4));
    do_reset();
    wait_store(DMEM_BASE + 4, 600, got_data, got_ok);
    if (got_ok && got_data == 32'hA7 && dmem[0] == 32'h47) pass(47);
    else begin
        $display("  TC47 dmem[0]=%08h dmem[1]=%08h ok=%0d", dmem[0], dmem[1], got_ok);
        fail(47, "Back-to-back store wrong");
    end
    init_mem();
    dmem[0] = 32'hCAFE_BABE;
    store_instr(32'h2000_0000, enc_lui(5'd2, DMEM_HI));
    store_instr(32'h2000_0004, enc_lw(5'd1, 5'd2, 12'd0));
    store_instr(32'h2000_0008, enc_sw(5'd2, 5'd1, 12'd4));
    do_reset();
    wait_store(DMEM_BASE + 4, 600, got_data, got_ok);
    if (got_ok && got_data == 32'hCAFE_BABE) pass(48);
    else begin $display("  TC48 got=%08h ok=%0d", got_data, got_ok); fail(48, "LW->SW stall wrong"); end
    init_mem();
    store_instr(32'h2000_0000, enc_lui(5'd2, DMEM_HI));
    store_instr(32'h2000_0004, enc_addi(5'd1, 5'd0, 12'hFE0));
    store_instr(32'h2000_0008, enc_addi(5'd3, 5'd0, 12'd2));
    store_instr(32'h2000_000C, enc_sra(5'd5, 5'd1, 5'd3));
    store_instr(32'h2000_0010, enc_sw(5'd2, 5'd5, 12'd0));
    do_reset();
    wait_store(DMEM_BASE, 300, got_data, got_ok);
    if (got_ok && got_data == 32'hFFFF_FFF8) pass(49);
    else begin $display("  TC49 got=%08h ok=%0d", got_data, got_ok); fail(49, "SRA sign wrong"); end
    init_mem();
    store_instr(32'h2000_0000, enc_lui(5'd2, DMEM_HI));
    store_instr(32'h2000_0004, enc_addi(5'd1, 5'd0, 12'd1));
    store_instr(32'h2000_0008, enc_addi(5'd3, 5'd0, 12'd10));
    store_instr(32'h2000_000C, enc_slt(5'd5, 5'd1, 5'd3));
    store_instr(32'h2000_0010, enc_slt(5'd6, 5'd3, 5'd1));
    store_instr(32'h2000_0014, enc_add(5'd7, 5'd5, 5'd6));
    store_instr(32'h2000_0018, enc_sw(5'd2, 5'd7, 12'd0));
    do_reset();
    wait_store(DMEM_BASE, 500, got_data, got_ok);
    if (got_ok && got_data == 32'd1) pass(50);
    else begin $display("  TC50 got=%08h ok=%0d", got_data, got_ok); fail(50, "SLT wrong"); end
    $display("");
    $display("============================================================");
    $display("RESULT: %0d/50 passed  (%0d failed)", pass_count, fail_count);
    $display("============================================================");
    $finish;
end

endmodule
