`default_nettype none
`timescale 1ns/1ps

module rv32im_core #(
    parameter RESET_ADDR  = 32'h0000_0000,
    parameter WDT_DEFAULT = 24'hFFFFFF,
    parameter WDT_BITS    = 24,
    parameter PC_GUARD_EN = 1,
    parameter ECC_EN      = 1,
    parameter PARITY_EN   = 1
)(
    input  wire        clk,
    input  wire        rst_n,

    input  wire        timer_irq,
    input  wire        soft_irq,
    input  wire        ext_irq,

    output reg         ecc_error,
    output reg         ecc_fatal,
    output reg         wdt_reset,

    output reg  [31:0] imem_araddr,
    output reg         imem_arvalid,
    input  wire        imem_arready,
    input  wire [31:0] imem_rdata,
    input  wire [1:0]  imem_rresp,
    input  wire        imem_rvalid,
    output reg         imem_rready,

    output reg  [31:0] dmem_awaddr,
    output reg         dmem_awvalid,
    input  wire        dmem_awready,
    output reg  [31:0] dmem_wdata,
    output reg  [3:0]  dmem_wstrb,
    output reg         dmem_wvalid,
    input  wire        dmem_wready,
    input  wire [1:0]  dmem_bresp,
    input  wire        dmem_bvalid,
    output reg         dmem_bready,
    output reg  [31:0] dmem_araddr,
    output reg         dmem_arvalid,
    input  wire        dmem_arready,
    input  wire [31:0] dmem_rdata,
    input  wire [1:0]  dmem_rresp,
    input  wire        dmem_rvalid,
    output reg         dmem_rready,

    output reg         custom_valid,
    output reg  [31:0] custom_instr,
    output reg  [31:0] custom_rs1,
    output reg  [31:0] custom_rs2,
    input  wire [31:0] custom_rd,
    input  wire        custom_rd_valid
);

localparam TRAP_ADDR  = 32'h0000_0100;
localparam PC_RESET   = RESET_ADDR;

localparam OP_LUI    = 7'b0110111;
localparam OP_AUIPC  = 7'b0010111;
localparam OP_JAL    = 7'b1101111;
localparam OP_JALR   = 7'b1100111;
localparam OP_BRANCH = 7'b1100011;
localparam OP_LOAD   = 7'b0000011;
localparam OP_STORE  = 7'b0100011;
localparam OP_ALUI   = 7'b0010011;
localparam OP_ALUR   = 7'b0110011;
localparam OP_SYSTEM = 7'b1110011;
localparam OP_CUSTOM0= 7'b0001011;
localparam OP_FENCE  = 7'b0001111;

localparam ALU_ADD  = 4'd0;
localparam ALU_SUB  = 4'd1;
localparam ALU_SLL  = 4'd2;
localparam ALU_SLT  = 4'd3;
localparam ALU_SLTU = 4'd4;
localparam ALU_XOR  = 4'd5;
localparam ALU_SRL  = 4'd6;
localparam ALU_SRA  = 4'd7;
localparam ALU_OR   = 4'd8;
localparam ALU_AND  = 4'd9;
localparam ALU_COPY_B = 4'd10;

localparam MDU_MUL    = 3'd0;
localparam MDU_MULH   = 3'd1;
localparam MDU_MULHSU = 3'd2;
localparam MDU_MULHU  = 3'd3;
localparam MDU_DIV    = 3'd4;
localparam MDU_DIVU   = 3'd5;
localparam MDU_REM    = 3'd6;
localparam MDU_REMU   = 3'd7;

localparam CSR_MSTATUS  = 12'h300;
localparam CSR_MIE      = 12'h304;
localparam CSR_MTVEC    = 12'h305;
localparam CSR_MSCRATCH = 12'h340;
localparam CSR_MEPC     = 12'h341;
localparam CSR_MCAUSE   = 12'h342;
localparam CSR_MIP      = 12'h344;
localparam CSR_MCYCLE   = 12'hC00;
localparam CSR_MINSTRET = 12'hC02;
localparam CSR_PCMIN    = 12'hBC0;
localparam CSR_PCMAX    = 12'hBC1;
localparam CSR_WDTREL   = 12'hBC2;

reg [31:0] regfile [0:31];

function [6:0] ham_encode;
    input [3:0] d;
    reg p1, p2, p3;
    begin
        p1 = d[0] ^ d[1] ^ d[3];
        p2 = d[0] ^ d[2] ^ d[3];
        p3 = d[1] ^ d[2] ^ d[3];
        ham_encode = {d[3], d[2], d[1], p3, d[0], p2, p1};
    end
endfunction

function [5:0] ham_decode;
    input [6:0] c;
    reg [2:0] synd;
    reg [6:0] cc;
    begin
        synd[0] = c[6] ^ c[4] ^ c[2] ^ c[0];
        synd[1] = c[6] ^ c[5] ^ c[2] ^ c[1];
        synd[2] = c[6] ^ c[5] ^ c[4] ^ c[3];
        cc = c;
        if (synd != 3'd0 && synd <= 7) cc[synd-1] = ~c[synd-1];
        ham_decode = {(synd != 0 && synd > 7) ? 1'b1 : 1'b0,
                      (synd != 0) ? 1'b1 : 1'b0,
                      cc[6], cc[5], cc[4], cc[2]};
    end
endfunction

reg [55:0] regfile_ecc [0:31];

task regfile_write;
    input [4:0]  addr;
    input [31:0] data;
    integer i;
    begin
        if (addr != 5'd0) begin
            regfile[addr] <= data;
            regfile_ecc[addr][6:0]   <= ham_encode(data[3:0]);
            regfile_ecc[addr][13:7]  <= ham_encode(data[7:4]);
            regfile_ecc[addr][20:14] <= ham_encode(data[11:8]);
            regfile_ecc[addr][27:21] <= ham_encode(data[15:12]);
            regfile_ecc[addr][34:28] <= ham_encode(data[19:16]);
            regfile_ecc[addr][41:35] <= ham_encode(data[23:20]);
            regfile_ecc[addr][48:42] <= ham_encode(data[27:24]);
            regfile_ecc[addr][55:49] <= ham_encode(data[31:28]);
        end
    end
endtask

function [33:0] regfile_read_ecc;
    input [4:0] addr;
    reg [5:0] d0,d1,d2,d3,d4,d5,d6,d7;
    reg any_fatal, any_corr;
    begin
        if (addr == 5'd0) begin
            regfile_read_ecc = 34'd0;
        end else begin
            d0 = ham_decode(regfile_ecc[addr][6:0]);
            d1 = ham_decode(regfile_ecc[addr][13:7]);
            d2 = ham_decode(regfile_ecc[addr][20:14]);
            d3 = ham_decode(regfile_ecc[addr][27:21]);
            d4 = ham_decode(regfile_ecc[addr][34:28]);
            d5 = ham_decode(regfile_ecc[addr][41:35]);
            d6 = ham_decode(regfile_ecc[addr][48:42]);
            d7 = ham_decode(regfile_ecc[addr][55:49]);
            any_fatal = d0[5]|d1[5]|d2[5]|d3[5]|d4[5]|d5[5]|d6[5]|d7[5];
            any_corr  = d0[4]|d1[4]|d2[4]|d3[4]|d4[4]|d5[4]|d6[4]|d7[4];
            regfile_read_ecc = {any_fatal, any_corr,
                d7[3:0], d6[3:0], d5[3:0], d4[3:0],
                d3[3:0], d2[3:0], d1[3:0], d0[3:0]};
        end
    end
endfunction

reg [31:0] csr_mstatus;
reg [31:0] csr_mie;
reg [31:0] csr_mtvec;
reg [31:0] csr_mscratch;
reg [31:0] csr_mepc;
reg [31:0] csr_mcause;
reg [31:0] csr_mip;
reg [63:0] csr_mcycle;
reg [63:0] csr_minstret;
reg [31:0] csr_pc_min;
reg [31:0] csr_pc_max;
reg [23:0] csr_wdt_reload;

reg [31:0] ifid_pc;
reg [31:0] ifid_instr;
reg        ifid_valid;

reg [31:0] idex_pc;
reg [31:0] idex_instr;
reg [31:0] idex_rs1_val;
reg [31:0] idex_rs2_val;
reg [31:0] idex_imm;
reg [4:0]  idex_rd;
reg [4:0]  idex_rs1;
reg [4:0]  idex_rs2;
reg [3:0]  idex_alu_op;
reg        idex_alu_src;
reg        idex_mem_read;
reg        idex_mem_write;
reg [2:0]  idex_mem_width;
reg        idex_reg_write;
reg        idex_mem_to_reg;
reg        idex_branch;
reg        idex_jal;
reg        idex_jalr;
reg        idex_mdu_en;
reg [2:0]  idex_mdu_op;
reg        idex_csr_en;
reg [11:0] idex_csr_addr;
reg [1:0]  idex_csr_op;
reg        idex_custom;
reg        idex_is_lui;
reg        idex_is_auipc;
reg        idex_valid;

reg [31:0] exmem_pc;
reg [31:0] exmem_alu_result;
reg [31:0] exmem_rs2_val;
reg [4:0]  exmem_rd;
reg        exmem_mem_read;
reg        exmem_mem_write;
reg [2:0]  exmem_mem_width;
reg        exmem_reg_write;
reg        exmem_mem_to_reg;
reg        exmem_branch_taken;
reg [31:0] exmem_branch_target;
reg        exmem_valid;
reg        exmem_csr_en;
reg [31:0] exmem_csr_result;
reg [4:0]  exmem_rs2;

reg [31:0] memwb_alu_result;
reg [31:0] memwb_mem_data;
reg [4:0]  memwb_rd;
reg        memwb_reg_write;
reg        memwb_mem_to_reg;
reg        memwb_valid;

reg        mdu_busy;
reg [2:0]  mdu_op_r;
reg [63:0] mdu_acc;
reg [31:0] mdu_a, mdu_b;
reg [5:0]  mdu_cnt;
reg        mdu_neg_result;
reg [31:0] mdu_result;
reg        mdu_done;

wire signed [31:0] mdu_a_s = $signed(mdu_a);
wire signed [31:0] mdu_b_s = $signed(mdu_b);

reg stall_if;
reg stall_id;
reg flush_ex;
reg flush_id;
reg trap_req;
reg [31:0] trap_cause;
reg [31:0] trap_pc;

reg [23:0] wdt_counter;
reg        wdt_en;

reg [31:0] pc;
reg [31:0] next_pc;
reg        fetch_pending;

wire [6:0]  id_opcode  = ifid_instr[6:0];
wire [4:0]  id_rd      = ifid_instr[11:7];
wire [2:0]  id_funct3  = ifid_instr[14:12];
wire [4:0]  id_rs1     = ifid_instr[19:15];
wire [4:0]  id_rs2     = ifid_instr[24:20];
wire [6:0]  id_funct7  = ifid_instr[31:25];

wire [31:0] id_imm_i = {{20{ifid_instr[31]}}, ifid_instr[31:20]};
wire [31:0] id_imm_s = {{20{ifid_instr[31]}}, ifid_instr[31:25], ifid_instr[11:7]};
wire [31:0] id_imm_b = {{19{ifid_instr[31]}}, ifid_instr[31], ifid_instr[7],
                         ifid_instr[30:25], ifid_instr[11:8], 1'b0};
wire [31:0] id_imm_u = {ifid_instr[31:12], 12'd0};
wire [31:0] id_imm_j = {{11{ifid_instr[31]}}, ifid_instr[31], ifid_instr[19:12],
                         ifid_instr[20], ifid_instr[30:21], 1'b0};

wire id_parity_ok = ~(^ifid_instr);

reg [31:0] fwd_rs1, fwd_rs2;

wire [33:0] rf_rs1_ecc = regfile_read_ecc(id_rs1);
wire [33:0] rf_rs2_ecc = regfile_read_ecc(id_rs2);
wire [31:0] rf_rs1_data = rf_rs1_ecc[31:0];
wire [31:0] rf_rs2_data = rf_rs2_ecc[31:0];

reg [31:0] alu_a, alu_b, alu_result;

always @(*) begin
    case (idex_alu_op)
        ALU_ADD:    alu_result = alu_a + alu_b;
        ALU_SUB:    alu_result = alu_a - alu_b;
        ALU_SLL:    alu_result = alu_a << alu_b[4:0];
        ALU_SLT:    alu_result = ($signed(alu_a) < $signed(alu_b)) ? 32'd1 : 32'd0;
        ALU_SLTU:   alu_result = (alu_a < alu_b) ? 32'd1 : 32'd0;
        ALU_XOR:    alu_result = alu_a ^ alu_b;
        ALU_SRL:    alu_result = alu_a >> alu_b[4:0];
        ALU_SRA:    alu_result = $signed(alu_a) >>> alu_b[4:0];
        ALU_OR:     alu_result = alu_a | alu_b;
        ALU_AND:    alu_result = alu_a & alu_b;
        ALU_COPY_B: alu_result = alu_b;
        default:    alu_result = 32'd0;
    endcase
end

reg branch_taken;
always @(*) begin
    branch_taken = 1'b0;
    if (idex_branch) begin
        case (idex_instr[14:12])
            3'b000: branch_taken = (fwd_rs1 == fwd_rs2);
            3'b001: branch_taken = (fwd_rs1 != fwd_rs2);
            3'b100: branch_taken = ($signed(fwd_rs1) < $signed(fwd_rs2));
            3'b101: branch_taken = ($signed(fwd_rs1) >= $signed(fwd_rs2));
            3'b110: branch_taken = (fwd_rs1 < fwd_rs2);
            3'b111: branch_taken = (fwd_rs1 >= fwd_rs2);
            default: branch_taken = 1'b0;
        endcase
    end
end

wire [31:0] branch_target = idex_pc + idex_imm;
wire [31:0] jalr_target   = (fwd_rs1 + idex_imm) & 32'hFFFFFFFE;

reg [31:0] csr_rdata;
always @(*) begin
    case (idex_csr_addr)
        CSR_MSTATUS:  csr_rdata = csr_mstatus;
        CSR_MIE:      csr_rdata = csr_mie;
        CSR_MTVEC:    csr_rdata = TRAP_ADDR;
        CSR_MSCRATCH: csr_rdata = csr_mscratch;
        CSR_MEPC:     csr_rdata = csr_mepc;
        CSR_MCAUSE:   csr_rdata = csr_mcause;
        CSR_MIP:      csr_rdata = csr_mip;
        CSR_MCYCLE:   csr_rdata = csr_mcycle[31:0];
        CSR_MINSTRET: csr_rdata = csr_minstret[31:0];
        CSR_PCMIN:    csr_rdata = csr_pc_min;
        CSR_PCMAX:    csr_rdata = csr_pc_max;
        CSR_WDTREL:   csr_rdata = {8'd0, csr_wdt_reload};
        default:      csr_rdata = 32'd0;
    endcase
end

wire load_use_hazard = idex_mem_read & ifid_valid &
                       ((idex_rd == id_rs1) | (idex_rd == id_rs2)) &
                       (idex_rd != 5'd0);

always @(*) begin

    if (exmem_reg_write && (exmem_rd != 5'd0) && (exmem_rd == idex_rs1))
        fwd_rs1 = exmem_alu_result;
    else if (memwb_reg_write && (memwb_rd != 5'd0) && (memwb_rd == idex_rs1))
        fwd_rs1 = memwb_mem_to_reg ? memwb_mem_data : memwb_alu_result;
    else
        fwd_rs1 = idex_rs1_val;

    if (exmem_reg_write && (exmem_rd != 5'd0) && (exmem_rd == idex_rs2))
        fwd_rs2 = exmem_alu_result;
    else if (memwb_reg_write && (memwb_rd != 5'd0) && (memwb_rd == idex_rs2))
        fwd_rs2 = memwb_mem_to_reg ? memwb_mem_data : memwb_alu_result;
    else
        fwd_rs2 = idex_rs2_val;
end

localparam AXI_IDLE = 2'd0, AXI_ADDR = 2'd1, AXI_DATA = 2'd2;
reg [1:0] imem_state;
reg [1:0] dmem_rd_state;
reg [1:0] dmem_wr_state;
reg       dmem_op_pending;
reg       dmem_is_write;
reg [31:0] dmem_pending_addr;
reg [31:0] dmem_pending_wdata;
reg [3:0]  dmem_pending_strb;
reg [31:0] dmem_rdata_r;
reg        dmem_done;

integer i;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin

        pc              <= PC_RESET;
        fetch_pending   <= 1'b0;
        ifid_valid      <= 1'b0;
        ifid_pc         <= 32'd0;
        ifid_instr      <= 32'd0;
        idex_valid      <= 1'b0;
        exmem_valid     <= 1'b0;
        memwb_valid     <= 1'b0;

        csr_mstatus     <= 32'd0;
        csr_mie         <= 32'd0;
        csr_mtvec       <= TRAP_ADDR;
        csr_mscratch    <= 32'd0;
        csr_mepc        <= 32'd0;
        csr_mcause      <= 32'd0;
        csr_mip         <= 32'd0;
        csr_mcycle      <= 64'd0;
        csr_minstret    <= 64'd0;
        csr_pc_min      <= 32'h0000_0000;
        csr_pc_max      <= 32'h2001_FFFF;
        csr_wdt_reload  <= WDT_DEFAULT;

        wdt_counter     <= WDT_DEFAULT;
        wdt_reset       <= 1'b0;
        ecc_error       <= 1'b0;
        ecc_fatal       <= 1'b0;

        imem_arvalid    <= 1'b0;
        imem_rready     <= 1'b0;
        imem_araddr     <= 32'd0;
        imem_state      <= AXI_IDLE;

        dmem_awvalid    <= 1'b0;
        dmem_wvalid     <= 1'b0;
        dmem_bready     <= 1'b1;
        dmem_arvalid    <= 1'b0;
        dmem_rready     <= 1'b0;
        dmem_rd_state   <= AXI_IDLE;
        dmem_wr_state   <= AXI_IDLE;
        dmem_done       <= 1'b0;
        dmem_op_pending <= 1'b0;

        mdu_busy        <= 1'b0;
        mdu_done        <= 1'b0;

        custom_valid    <= 1'b0;
        custom_instr    <= 32'd0;
        custom_rs1      <= 32'd0;
        custom_rs2      <= 32'd0;

        trap_req        <= 1'b0;
        trap_cause      <= 32'd0;
        trap_pc         <= 32'd0;

        for (i = 0; i < 32; i = i + 1) begin
            regfile[i]     <= 32'd0;
            regfile_ecc[i] <= 56'd0;
        end

    end else begin

        wdt_reset  <= 1'b0;
        ecc_error  <= 1'b0;
        ecc_fatal  <= 1'b0;
        dmem_done  <= 1'b0;
        mdu_done   <= 1'b0;
        custom_valid <= 1'b0;

        csr_mcycle <= csr_mcycle + 64'd1;

        csr_mip[7] <= timer_irq;
        csr_mip[3] <= soft_irq;
        csr_mip[11]<= ext_irq;

        if (wdt_counter == 24'd0) begin
            wdt_reset   <= 1'b1;
            wdt_counter <= csr_wdt_reload;
        end else begin
            wdt_counter <= wdt_counter - 24'd1;
        end

        if (!trap_req) begin
            if (csr_mstatus[3] && (csr_mie & csr_mip) != 32'd0) begin
                trap_req   <= 1'b1;
                trap_pc    <= pc;
                if (csr_mip[11] & csr_mie[11]) trap_cause <= 32'h8000000B;
                else if (csr_mip[7] & csr_mie[7]) trap_cause <= 32'h80000007;
                else trap_cause <= 32'h80000003;
            end
        end

        case (imem_state)
            AXI_IDLE: begin
                if (!stall_if && !trap_req) begin
                    imem_araddr  <= pc;
                    imem_arvalid <= 1'b1;
                    imem_state   <= AXI_ADDR;
                end
            end
            AXI_ADDR: begin
                if (imem_arready) begin
                    imem_arvalid <= 1'b0;
                    imem_rready  <= 1'b1;
                    imem_state   <= AXI_DATA;
                end
            end
            AXI_DATA: begin
                if (imem_rvalid) begin
                    imem_rready <= 1'b0;
                    if (!stall_id) begin
                        ifid_instr  <= imem_rdata;
                        ifid_pc     <= pc;
                        ifid_valid  <= 1'b1;
                        pc          <= pc + 32'd4;
                    end
                    imem_state  <= AXI_IDLE;
                end
            end
            default: imem_state <= AXI_IDLE;
        endcase

        if (trap_req) begin
            csr_mepc    <= trap_pc;
            csr_mcause  <= trap_cause;
            csr_mstatus[7] <= csr_mstatus[3];
            csr_mstatus[3] <= 1'b0;
            pc          <= TRAP_ADDR;
            ifid_valid  <= 1'b0;
            idex_valid  <= 1'b0;
            exmem_valid <= 1'b0;
            trap_req    <= 1'b0;
            imem_state  <= AXI_IDLE;
            imem_arvalid<= 1'b0;
            imem_rready <= 1'b0;
        end

        if (!stall_id && ifid_valid && !flush_id) begin

            if (rf_rs1_ecc[33]) ecc_fatal <= 1'b1;
            else if (rf_rs1_ecc[32]) ecc_error <= 1'b1;
            if (rf_rs2_ecc[33]) ecc_fatal <= 1'b1;
            else if (rf_rs2_ecc[32]) ecc_error <= 1'b1;

            if ((ifid_pc < csr_pc_min) || (ifid_pc > csr_pc_max)) begin
                trap_req   <= 1'b1;
                trap_pc    <= ifid_pc;
                trap_cause <= 32'd1;
                ifid_valid <= 1'b0;
            end else begin
                idex_pc       <= ifid_pc;
                idex_instr    <= ifid_instr;
                idex_rs1      <= id_rs1;
                idex_rs2      <= id_rs2;
                idex_rd       <= id_rd;
                idex_rs1_val  <= rf_rs1_data;
                idex_rs2_val  <= rf_rs2_data;
                idex_mem_read <= 1'b0;
                idex_mem_write<= 1'b0;
                idex_reg_write<= 1'b0;
                idex_mem_to_reg<=1'b0;
                idex_branch   <= 1'b0;
                idex_jal      <= 1'b0;
                idex_jalr     <= 1'b0;
                idex_mdu_en   <= 1'b0;
                idex_csr_en   <= 1'b0;
                idex_custom   <= 1'b0;
                idex_alu_src  <= 1'b0;
                idex_is_lui   <= 1'b0;
                idex_is_auipc <= 1'b0;
                idex_valid    <= 1'b1;

                if (!id_parity_ok) begin
                    trap_req   <= 1'b1;
                    trap_pc    <= ifid_pc;
                    trap_cause <= 32'd2;
                    idex_valid <= 1'b0;
                end else begin
                    case (id_opcode)
                        OP_LUI: begin
                            idex_imm      <= id_imm_u;
                            idex_alu_op   <= ALU_COPY_B;
                            idex_alu_src  <= 1'b1;
                            idex_reg_write<= 1'b1;
                            idex_is_lui   <= 1'b1;
                        end
                        OP_AUIPC: begin
                            idex_imm      <= id_imm_u;
                            idex_alu_op   <= ALU_ADD;
                            idex_alu_src  <= 1'b1;
                            idex_reg_write<= 1'b1;
                            idex_is_auipc <= 1'b1;
                        end
                        OP_JAL: begin
                            idex_imm      <= id_imm_j;
                            idex_jal      <= 1'b1;
                            idex_reg_write<= 1'b1;
                        end
                        OP_JALR: begin
                            idex_imm      <= id_imm_i;
                            idex_jalr     <= 1'b1;
                            idex_reg_write<= 1'b1;
                            idex_alu_src  <= 1'b1;
                        end
                        OP_BRANCH: begin
                            idex_imm      <= id_imm_b;
                            idex_branch   <= 1'b1;
                            idex_alu_op   <= ALU_SUB;
                        end
                        OP_LOAD: begin
                            idex_imm        <= id_imm_i;
                            idex_alu_op     <= ALU_ADD;
                            idex_alu_src    <= 1'b1;
                            idex_mem_read   <= 1'b1;
                            idex_mem_width  <= id_funct3;
                            idex_reg_write  <= 1'b1;
                            idex_mem_to_reg <= 1'b1;
                        end
                        OP_STORE: begin
                            idex_imm       <= id_imm_s;
                            idex_alu_op    <= ALU_ADD;
                            idex_alu_src   <= 1'b1;
                            idex_mem_write <= 1'b1;
                            idex_mem_width <= id_funct3;
                        end
                        OP_ALUI: begin
                            idex_imm     <= id_imm_i;
                            idex_alu_src <= 1'b1;
                            idex_reg_write <= 1'b1;
                            case (id_funct3)
                                3'b000: idex_alu_op <= ALU_ADD;
                                3'b010: idex_alu_op <= ALU_SLT;
                                3'b011: idex_alu_op <= ALU_SLTU;
                                3'b100: idex_alu_op <= ALU_XOR;
                                3'b110: idex_alu_op <= ALU_OR;
                                3'b111: idex_alu_op <= ALU_AND;
                                3'b001: idex_alu_op <= ALU_SLL;
                                3'b101: idex_alu_op <= (id_funct7[5]) ? ALU_SRA : ALU_SRL;
                                default: idex_alu_op <= ALU_ADD;
                            endcase
                        end
                        OP_ALUR: begin
                            idex_reg_write <= 1'b1;
                            if (id_funct7 == 7'b0000001) begin

                                idex_mdu_en  <= 1'b1;
                                idex_mdu_op  <= id_funct3;
                            end else begin
                                case (id_funct3)
                                    3'b000: idex_alu_op <= (id_funct7[5]) ? ALU_SUB : ALU_ADD;
                                    3'b001: idex_alu_op <= ALU_SLL;
                                    3'b010: idex_alu_op <= ALU_SLT;
                                    3'b011: idex_alu_op <= ALU_SLTU;
                                    3'b100: idex_alu_op <= ALU_XOR;
                                    3'b101: idex_alu_op <= (id_funct7[5]) ? ALU_SRA : ALU_SRL;
                                    3'b110: idex_alu_op <= ALU_OR;
                                    3'b111: idex_alu_op <= ALU_AND;
                                    default: idex_alu_op <= ALU_ADD;
                                endcase
                            end
                        end
                        OP_SYSTEM: begin
                            idex_csr_en   <= 1'b1;
                            idex_csr_addr <= ifid_instr[31:20];
                            idex_csr_op   <= id_funct3[1:0];
                            idex_reg_write<= (id_rd != 5'd0);

                            if (id_funct3 == 3'b000 && ifid_instr[31:20] == 12'h302) begin
                                idex_csr_en  <= 1'b0;
                                trap_req     <= 1'b0;
                                pc           <= csr_mepc;
                                csr_mstatus[3] <= csr_mstatus[7];
                                idex_valid   <= 1'b0;
                                ifid_valid   <= 1'b0;
                            end
                        end
                        OP_CUSTOM0: begin
                            idex_custom   <= 1'b1;
                            idex_reg_write<= 1'b1;
                        end
                        OP_FENCE: begin

                            idex_alu_op <= ALU_ADD;
                        end
                        default: begin
                            trap_req   <= 1'b1;
                            trap_pc    <= ifid_pc;
                            trap_cause <= 32'd2;
                            idex_valid <= 1'b0;
                        end
                    endcase
                end
            end
        end else if (load_use_hazard) begin
            idex_valid <= 1'b0;
        end else if (flush_ex) begin
            idex_valid <= 1'b0;
        end

        alu_a = idex_is_auipc ? idex_pc : fwd_rs1;
        alu_b = (idex_alu_src || idex_is_lui) ? idex_imm : fwd_rs2;

        if (idex_valid && idex_custom) begin
            custom_valid <= 1'b1;
            custom_instr <= idex_instr;
            custom_rs1   <= fwd_rs1;
            custom_rs2   <= fwd_rs2;
        end

        if (idex_valid && idex_mdu_en && !mdu_busy) begin
            mdu_op_r  <= idex_mdu_op;
            mdu_a     <= fwd_rs1;
            mdu_b     <= fwd_rs2;
            mdu_cnt   <= 6'd0;
            mdu_acc   <= 64'd0;
            mdu_busy  <= 1'b1;
            mdu_neg_result <= 1'b0;
        end

        if (mdu_busy) begin
            case (mdu_op_r)
                MDU_MUL, MDU_MULHU: begin
                    if (mdu_cnt < 6'd32) begin
                        if (mdu_b[mdu_cnt])
                            mdu_acc <= mdu_acc + ({32'd0, mdu_a} << mdu_cnt);
                        mdu_cnt <= mdu_cnt + 6'd1;
                    end else begin
                        mdu_result <= (mdu_op_r == MDU_MUL) ? mdu_acc[31:0] : mdu_acc[63:32];
                        mdu_busy   <= 1'b0;
                        mdu_done   <= 1'b1;
                    end
                end
                MDU_MULH: begin
                    if (mdu_cnt < 6'd32) begin
                        if (mdu_b[mdu_cnt]) begin
                            if (mdu_a[31])
                                mdu_acc <= mdu_acc + (~({32'd0, mdu_a} << mdu_cnt) + 64'd1);
                            else
                                mdu_acc <= mdu_acc + ({32'd0, mdu_a} << mdu_cnt);
                        end
                        mdu_cnt <= mdu_cnt + 6'd1;
                    end else begin
                        mdu_result <= mdu_acc[63:32];
                        mdu_busy   <= 1'b0;
                        mdu_done   <= 1'b1;
                    end
                end
                MDU_MULHSU: begin
                    if (mdu_cnt < 6'd32) begin
                        if (mdu_b[mdu_cnt])
                            mdu_acc <= mdu_acc + ($signed({mdu_a[31], mdu_a}) <<< mdu_cnt);
                        mdu_cnt <= mdu_cnt + 6'd1;
                    end else begin
                        mdu_result <= mdu_acc[63:32];
                        mdu_busy   <= 1'b0;
                        mdu_done   <= 1'b1;
                    end
                end
                MDU_DIV, MDU_REM: begin
                    if (mdu_cnt == 6'd0) begin

                        mdu_neg_result <= (mdu_op_r == MDU_DIV) ?
                            (mdu_a[31] ^ mdu_b[31]) : mdu_a[31];
                        mdu_acc  <= {32'd0, mdu_a[31] ? (~mdu_a + 32'd1) : mdu_a};
                        mdu_b    <= mdu_b[31] ? (~mdu_b + 32'd1) : mdu_b;
                        mdu_cnt  <= 6'd1;
                    end else if (mdu_cnt <= 6'd32) begin

                        mdu_acc <= {mdu_acc[62:0], 1'b0};
                        if (mdu_acc[63:32] >= {1'b0, mdu_b}) begin
                            mdu_acc[63:32] <= mdu_acc[63:32] - {1'b0, mdu_b};
                            mdu_acc[0]     <= 1'b1;
                        end
                        mdu_cnt <= mdu_cnt + 6'd1;
                    end else begin
                        if (mdu_op_r == MDU_DIV)
                            mdu_result <= mdu_neg_result ? (~mdu_acc[31:0] + 1) : mdu_acc[31:0];
                        else
                            mdu_result <= mdu_neg_result ? (~mdu_acc[63:32] + 1) : mdu_acc[63:32];
                        mdu_busy <= 1'b0;
                        mdu_done <= 1'b1;
                    end
                end
                MDU_DIVU, MDU_REMU: begin
                    if (mdu_cnt < 6'd32) begin
                        mdu_acc <= {mdu_acc[62:0], 1'b0};
                        if (mdu_acc[63:32] >= {1'b0, mdu_b}) begin
                            mdu_acc[63:32] <= mdu_acc[63:32] - {1'b0, mdu_b};
                            mdu_acc[0]     <= 1'b1;
                        end
                        mdu_cnt <= mdu_cnt + 6'd1;
                    end else begin
                        mdu_result <= (mdu_op_r == MDU_DIVU) ? mdu_acc[31:0] : mdu_acc[63:32];
                        mdu_busy   <= 1'b0;
                        mdu_done   <= 1'b1;
                    end
                end
                default: begin
                    mdu_busy <= 1'b0;
                    mdu_done <= 1'b1;
                    mdu_result <= 32'd0;
                end
            endcase
        end

        if (idex_valid && !mdu_busy) begin
            exmem_pc           <= idex_pc;
            exmem_rd           <= idex_rd;
            exmem_rs2          <= idex_rs2;
            exmem_mem_read     <= idex_mem_read;
            exmem_mem_write    <= idex_mem_write;
            exmem_mem_width    <= idex_mem_width;
            exmem_reg_write    <= idex_reg_write && !idex_custom && !idex_mdu_en;
            exmem_mem_to_reg   <= idex_mem_to_reg;
            exmem_valid        <= 1'b1;
            exmem_csr_en       <= idex_csr_en;

            if (idex_custom && custom_rd_valid) begin
                exmem_alu_result <= custom_rd;
                exmem_reg_write  <= 1'b1;
            end else if (idex_mdu_en && mdu_done) begin
                exmem_alu_result <= mdu_result;
                exmem_reg_write  <= 1'b1;
            end else if (idex_jal) begin
                exmem_alu_result  <= idex_pc + 32'd4;
                exmem_branch_taken<= 1'b1;
                exmem_branch_target <= idex_pc + idex_imm;
            end else if (idex_jalr) begin
                exmem_alu_result  <= idex_pc + 32'd4;
                exmem_branch_taken<= 1'b1;
                exmem_branch_target <= jalr_target;
            end else if (idex_branch) begin
                exmem_branch_taken  <= branch_taken;
                exmem_branch_target <= branch_target;
                exmem_alu_result    <= 32'd0;
                exmem_reg_write     <= 1'b0;
            end else begin
                exmem_alu_result    <= alu_result;
                exmem_branch_taken  <= 1'b0;
            end

            if (idex_csr_en) begin
                reg [31:0] csr_wdata;
                csr_wdata = 32'd0;
                case (idex_csr_op)
                    2'b01: csr_wdata = fwd_rs1;
                    2'b10: csr_wdata = csr_rdata | fwd_rs1;
                    2'b11: csr_wdata = csr_rdata & ~fwd_rs1;
                    default: csr_wdata = fwd_rs1;
                endcase
                exmem_csr_result <= csr_rdata;

                case (idex_csr_addr)
                    CSR_MSTATUS:  csr_mstatus  <= csr_wdata;
                    CSR_MIE:      csr_mie      <= csr_wdata;
                    CSR_MSCRATCH: csr_mscratch <= csr_wdata;
                    CSR_MEPC:     csr_mepc     <= csr_wdata;
                    CSR_MCAUSE:   csr_mcause   <= csr_wdata;
                    CSR_PCMIN:    csr_pc_min   <= csr_wdata;
                    CSR_PCMAX:    csr_pc_max   <= csr_wdata;
                    CSR_WDTREL:   csr_wdt_reload <= csr_wdata[23:0];
                    default: ;
                endcase
            end

            exmem_rs2_val <= fwd_rs2;
        end else if (!idex_valid || flush_ex) begin
            exmem_valid <= 1'b0;
        end

        if (exmem_valid && exmem_branch_taken) begin
            pc          <= exmem_branch_target;
            ifid_valid  <= 1'b0;
            idex_valid  <= 1'b0;
            imem_state  <= AXI_IDLE;
            imem_arvalid<= 1'b0;
            imem_rready <= 1'b0;
        end

        if (exmem_valid && (exmem_mem_read || exmem_mem_write) && !dmem_op_pending) begin
            dmem_op_pending    <= 1'b1;
            dmem_is_write      <= exmem_mem_write;
            dmem_pending_addr  <= exmem_alu_result;
            dmem_pending_strb  <= (exmem_mem_width[1:0] == 2'b00) ?
                                    (4'b0001 << exmem_alu_result[1:0]) :
                                  (exmem_mem_width[1:0] == 2'b01) ?
                                    (4'b0011 << {exmem_alu_result[1], 1'b0}) :
                                    4'b1111;

            case (exmem_mem_width[1:0])
                2'b00: dmem_pending_wdata <= {4{exmem_rs2_val[7:0]}};
                2'b01: dmem_pending_wdata <= {2{exmem_rs2_val[15:0]}};
                default: dmem_pending_wdata <= exmem_rs2_val;
            endcase
        end

        if (dmem_op_pending && dmem_is_write) begin
            case (dmem_wr_state)
                AXI_IDLE: begin
                    dmem_awaddr  <= dmem_pending_addr;
                    dmem_awvalid <= 1'b1;
                    dmem_wdata   <= dmem_pending_wdata;
                    dmem_wstrb   <= dmem_pending_strb;
                    dmem_wvalid  <= 1'b1;
                    dmem_wr_state<= AXI_ADDR;
                end
                AXI_ADDR: begin
                    if (dmem_awready) dmem_awvalid <= 1'b0;
                    if (dmem_wready)  dmem_wvalid  <= 1'b0;
                    if ((!dmem_awvalid || dmem_awready) && (!dmem_wvalid || dmem_wready))
                        dmem_wr_state <= AXI_DATA;
                end
                AXI_DATA: begin
                    if (dmem_bvalid) begin
                        dmem_op_pending <= 1'b0;
                        dmem_done       <= 1'b1;
                        dmem_wr_state   <= AXI_IDLE;
                    end
                end
                default: dmem_wr_state <= AXI_IDLE;
            endcase
        end

        if (dmem_op_pending && !dmem_is_write) begin
            case (dmem_rd_state)
                AXI_IDLE: begin
                    dmem_araddr  <= dmem_pending_addr;
                    dmem_arvalid <= 1'b1;
                    dmem_rd_state<= AXI_ADDR;
                end
                AXI_ADDR: begin
                    if (dmem_arready) begin
                        dmem_arvalid <= 1'b0;
                        dmem_rready  <= 1'b1;
                        dmem_rd_state<= AXI_DATA;
                    end
                end
                AXI_DATA: begin
                    if (dmem_rvalid) begin
                        dmem_rready     <= 1'b0;
                        dmem_rdata_r    <= dmem_rdata;
                        dmem_op_pending <= 1'b0;
                        dmem_done       <= 1'b1;
                        dmem_rd_state   <= AXI_IDLE;
                    end
                end
                default: dmem_rd_state <= AXI_IDLE;
            endcase
        end

        if (exmem_valid) begin
            memwb_rd         <= exmem_rd;
            memwb_reg_write  <= exmem_reg_write;
            memwb_mem_to_reg <= exmem_mem_to_reg;
            memwb_valid      <= 1'b1;

            if (exmem_csr_en) begin
                memwb_alu_result <= exmem_csr_result;
                memwb_mem_to_reg <= 1'b0;
            end else begin
                memwb_alu_result <= exmem_alu_result;
            end

            if (exmem_mem_read && dmem_done) begin
                case (exmem_mem_width)
                    3'b000: memwb_mem_data <= {{24{dmem_rdata_r[7]}},  dmem_rdata_r[7:0]};
                    3'b001: memwb_mem_data <= {{16{dmem_rdata_r[15]}}, dmem_rdata_r[15:0]};
                    3'b010: memwb_mem_data <= dmem_rdata_r;
                    3'b100: memwb_mem_data <= {24'd0, dmem_rdata_r[7:0]};
                    3'b101: memwb_mem_data <= {16'd0, dmem_rdata_r[15:0]};
                    default: memwb_mem_data <= dmem_rdata_r;
                endcase
            end
        end else begin
            memwb_valid <= 1'b0;
        end

        if (memwb_valid && memwb_reg_write && (memwb_rd != 5'd0)) begin
            reg [31:0] wb_data;
            wb_data = memwb_mem_to_reg ? memwb_mem_data : memwb_alu_result;
            regfile_write(memwb_rd, wb_data);

            csr_minstret <= csr_minstret + 64'd1;
            wdt_counter  <= csr_wdt_reload;
        end

    end
end

always @(*) begin
    stall_if = load_use_hazard | mdu_busy |
               (dmem_op_pending & exmem_valid & (exmem_mem_read | exmem_mem_write));
    stall_id = load_use_hazard | mdu_busy |
               (dmem_op_pending & exmem_valid & (exmem_mem_read | exmem_mem_write));
    flush_ex = exmem_valid & exmem_branch_taken;
    flush_id = exmem_valid & exmem_branch_taken;
end

endmodule
`default_nettype wire
