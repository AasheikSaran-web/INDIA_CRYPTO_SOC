

`timescale 1ns/1ps
`default_nettype none

// rv32im_core: hardware module definition
module rv32im_core #(
    parameter [31:0] RESET_ADDR = 32'h2000_0000
) (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        timer_irq,
    input  wire        soft_irq,
    input  wire        ext_irq,
    output wire [31:0] imem_araddr,
    output wire        imem_arvalid,
    input  wire        imem_arready,
    input  wire [31:0] imem_rdata,
    input  wire [1:0]  imem_rresp,
    input  wire        imem_rvalid,
    output wire        imem_rready,
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
    output wire        custom_valid,
    output wire [31:0] custom_instr,
    output wire [31:0] custom_rs1,
    output wire [31:0] custom_rs2,
    input  wire [31:0] custom_rd,
    input  wire        custom_rd_valid
);
assign imem_araddr  = 32'd0;
assign imem_arvalid = 1'b0;
assign imem_rready  = 1'b0;
localparam [6:0] OPC_LUI    = 7'h37;
localparam [6:0] OPC_AUIPC  = 7'h17;
localparam [6:0] OPC_JAL    = 7'h6F;
localparam [6:0] OPC_JALR   = 7'h67;
localparam [6:0] OPC_BRANCH = 7'h63;
localparam [6:0] OPC_LOAD   = 7'h03;
localparam [6:0] OPC_STORE  = 7'h23;
localparam [6:0] OPC_ALUI   = 7'h13;
localparam [6:0] OPC_ALU    = 7'h33;
localparam [6:0] OPC_FENCE  = 7'h0F;
localparam [6:0] OPC_SYSTEM = 7'h73;
localparam [6:0] OPC_CUSTOM = 7'h0B;
localparam [2:0] AXI_IDLE     = 3'd0;
localparam [2:0] AXI_FETCH_AR = 3'd1;
localparam [2:0] AXI_FETCH_R  = 3'd2;
localparam [2:0] AXI_DATA_AR  = 3'd3;
localparam [2:0] AXI_DATA_R   = 3'd4;
localparam [2:0] AXI_DATA_AW  = 3'd5;
localparam [2:0] AXI_DATA_B   = 3'd6;
localparam [2:0] F3_MUL    = 3'd0;
localparam [2:0] F3_MULH   = 3'd1;
localparam [2:0] F3_MULHSU = 3'd2;
localparam [2:0] F3_MULHU  = 3'd3;
localparam [2:0] F3_DIV    = 3'd4;
localparam [2:0] F3_DIVU   = 3'd5;
localparam [2:0] F3_REM    = 3'd6;
localparam [2:0] F3_REMU   = 3'd7;
reg [2:0]  axi_state;
reg [31:0] pc;
reg [31:0] regfile [1:31];
reg        if_de_valid;
reg [31:0] if_de_instr;
reg [31:0] if_de_pc;
reg        de_ex_valid;
reg [31:0] de_ex_instr;
reg [31:0] de_ex_pc;
reg [31:0] de_ex_rs1_val;
reg [31:0] de_ex_rs2_val;
reg [4:0]  de_ex_rd;
reg        de_ex_wb_en;
reg        de_ex_is_mem;
reg        de_ex_is_store;
reg        de_ex_is_branch;
reg        de_ex_is_jal;
reg        de_ex_is_jalr;
reg        de_ex_is_lui;
reg        de_ex_is_auipc;
reg        de_ex_is_custom;
reg        de_ex_is_muldiv;
reg [31:0] de_ex_imm;
reg [2:0]  de_ex_funct3;
reg [6:0]  de_ex_funct7;
reg [6:0]  de_ex_opcode;
reg        wb_en;
reg [4:0]  wb_rd;
reg [31:0] wb_val;
reg        aw_done;
reg        w_done;
reg [31:0] fetch_addr_r;
reg [31:0] load_addr_r;
reg [2:0]  load_funct3_r;
reg        muldiv_busy;
reg        muldiv_start;
reg [2:0]  muldiv_op;
reg [31:0] muldiv_a;
reg [31:0] muldiv_b;
reg [31:0] muldiv_result;
reg [5:0]  muldiv_cnt;
reg [63:0] muldiv_acc;
reg [31:0] muldiv_quotient;
reg [31:0] muldiv_divisor;
reg        muldiv_neg_result;
reg        muldiv_is_div;
reg        muldiv_done;
reg [31:0] alu_out;
reg        branch_taken;
reg [31:0] branch_target;
reg [31:0] mem_addr;
reg [1:0]  mem_addr_lo;
reg        mem_addr_bit1;
reg [63:0] muldiv_rem_tmp;
wire custom_wait = de_ex_valid && de_ex_is_custom && !custom_rd_valid;

assign custom_valid = de_ex_valid && de_ex_is_custom;
assign custom_instr = de_ex_instr;
assign custom_rs1   = de_ex_rs1_val;
assign custom_rs2   = de_ex_rs2_val;
wire axi_idle = (axi_state == AXI_IDLE);
wire axi_busy = !axi_idle;
wire pipe_stall = axi_busy | muldiv_busy | custom_wait;
wire if_de_is_mem = (if_de_instr[6:0] == OPC_LOAD || if_de_instr[6:0] == OPC_STORE);
wire fetch_ok = axi_idle &&
                !if_de_valid &&
                !(de_ex_valid && de_ex_is_mem) &&
                !(if_de_valid && if_de_is_mem) &&
                !(de_ex_valid && (de_ex_is_branch || de_ex_is_jal || de_ex_is_jalr));
wire [6:0] d_opcode = if_de_instr[6:0];
wire [4:0] d_rd     = if_de_instr[11:7];
wire [2:0] d_funct3 = if_de_instr[14:12];
wire [4:0] d_rs1    = if_de_instr[19:15];
wire [4:0] d_rs2    = if_de_instr[24:20];
wire [6:0] d_funct7 = if_de_instr[31:25];

wire [31:0] d_imm_i = {{20{if_de_instr[31]}}, if_de_instr[31:20]};
wire [31:0] d_imm_s = {{20{if_de_instr[31]}}, if_de_instr[31:25], if_de_instr[11:7]};
wire [31:0] d_imm_b = {{19{if_de_instr[31]}}, if_de_instr[31], if_de_instr[7],
                        if_de_instr[30:25], if_de_instr[11:8], 1'b0};
wire [31:0] d_imm_u = {if_de_instr[31:12], 12'b0};
wire [31:0] d_imm_j = {{11{if_de_instr[31]}}, if_de_instr[31], if_de_instr[19:12],
                        if_de_instr[20], if_de_instr[30:21], 1'b0};
wire [31:0] rs1_fwd = (d_rs1 == 5'd0) ? 32'd0 :
                      (wb_en && wb_rd == d_rs1) ? wb_val :
                      regfile[d_rs1];
wire [31:0] rs2_fwd = (d_rs2 == 5'd0) ? 32'd0 :
                      (wb_en && wb_rd == d_rs2) ? wb_val :
                      regfile[d_rs2];
integer rf_idx;

// RV32IM pipeline fetch stage — PC register and instruction memory request
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        muldiv_busy       <= 1'b0;
        muldiv_done       <= 1'b0;
        muldiv_result     <= 32'd0;
        muldiv_cnt        <= 6'd0;
        muldiv_acc        <= 64'd0;
        muldiv_quotient   <= 32'd0;
        muldiv_divisor    <= 32'd0;
        muldiv_neg_result <= 1'b0;
        muldiv_is_div     <= 1'b0;
    end else begin
        muldiv_done <= 1'b0;

        if (muldiv_start && !muldiv_busy) begin
            muldiv_busy <= 1'b1;
            muldiv_cnt  <= 6'd0;

            if (muldiv_op == F3_MUL || muldiv_op == F3_MULH ||
                muldiv_op == F3_MULHSU || muldiv_op == F3_MULHU) begin
                muldiv_is_div <= 1'b0;
                if (muldiv_op == F3_MULHU)
                    muldiv_acc <= {32'd0, muldiv_a} * {32'd0, muldiv_b};
                else if (muldiv_op == F3_MULHSU)
                    muldiv_acc <= $signed({{32{1'b0}}, muldiv_a}) * $signed({{32{1'b0}}, muldiv_b});
                else
                    muldiv_acc <= $signed({{32{muldiv_a[31]}}, muldiv_a}) *
                                  $signed({{32{muldiv_b[31]}}, muldiv_b});
                muldiv_cnt <= 6'd1;
            end else begin
                muldiv_is_div <= 1'b1;
                muldiv_quotient   <= 32'd0;
                case (muldiv_op)
                    F3_DIV: begin
                        muldiv_neg_result <= muldiv_a[31] ^ muldiv_b[31];
                        muldiv_acc     <= {32'd0, muldiv_a[31] ? (32'(-muldiv_a)) : muldiv_a};
                        muldiv_divisor <= muldiv_b[31] ? (32'(-muldiv_b)) : muldiv_b;
                    end
                    F3_DIVU: begin
                        muldiv_neg_result <= 1'b0;
                        muldiv_acc     <= {32'd0, muldiv_a};
                        muldiv_divisor <= muldiv_b;
                    end
                    F3_REM: begin
                        muldiv_neg_result <= muldiv_a[31];
                        muldiv_acc     <= {32'd0, muldiv_a[31] ? (32'(-muldiv_a)) : muldiv_a};
                        muldiv_divisor <= muldiv_b[31] ? (32'(-muldiv_b)) : muldiv_b;
                    end
                    default: begin
                        muldiv_neg_result <= 1'b0;
                        muldiv_acc     <= {32'd0, muldiv_a};
                        muldiv_divisor <= muldiv_b;
                    end
                endcase
            end

        end else if (muldiv_busy) begin
            if (!muldiv_is_div) begin
                if (muldiv_cnt == 6'd1) begin
                    case (muldiv_op)
                        F3_MUL:  muldiv_result <= muldiv_acc[31:0];
                        default: muldiv_result <= muldiv_acc[63:32];
                    endcase
                    muldiv_busy <= 1'b0;
                    muldiv_done <= 1'b1;
                end
            end else begin
                if (muldiv_cnt < 6'd32) begin
                    muldiv_rem_tmp = {muldiv_acc[62:0], 1'b0};
                    if (muldiv_rem_tmp[63:32] >= muldiv_divisor) begin
                        muldiv_acc      <= {muldiv_rem_tmp[63:32] - muldiv_divisor,
                                            muldiv_rem_tmp[31:0]};
                        muldiv_quotient <= {muldiv_quotient[30:0], 1'b1};
                    end else begin
                        muldiv_acc      <= muldiv_rem_tmp;
                        muldiv_quotient <= {muldiv_quotient[30:0], 1'b0};
                    end
                    muldiv_cnt <= muldiv_cnt + 6'd1;
                end else begin
                    case (muldiv_op)
                        F3_DIV:  muldiv_result <= muldiv_neg_result ?
                                     (~muldiv_quotient + 1) : muldiv_quotient;
                        F3_DIVU: muldiv_result <= muldiv_quotient;
                        F3_REM:  muldiv_result <= muldiv_neg_result ?
                                     (~muldiv_acc[63:32] + 1) : muldiv_acc[63:32];
                        default: muldiv_result <= muldiv_acc[63:32];
                    endcase
                    muldiv_busy <= 1'b0;
                    muldiv_done <= 1'b1;
                end
            end
        end
    end
end
// RV32IM pipeline decode stage — instruction decode and register file read
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        pc            <= RESET_ADDR;
        if_de_valid   <= 1'b0;
        if_de_instr   <= 32'h0000_0013;
        if_de_pc      <= 32'd0;
        de_ex_valid   <= 1'b0;
        de_ex_instr   <= 32'd0;
        de_ex_pc      <= 32'd0;
        de_ex_rs1_val <= 32'd0;
        de_ex_rs2_val <= 32'd0;
        de_ex_rd      <= 5'd0;
        de_ex_wb_en   <= 1'b0;
        de_ex_is_mem  <= 1'b0;
        de_ex_is_store<= 1'b0;
        de_ex_is_branch<= 1'b0;
        de_ex_is_jal  <= 1'b0;
        de_ex_is_jalr <= 1'b0;
        de_ex_is_lui  <= 1'b0;
        de_ex_is_auipc<= 1'b0;
        de_ex_is_custom<= 1'b0;
        de_ex_is_muldiv<= 1'b0;
        de_ex_imm     <= 32'd0;
        de_ex_funct3  <= 3'd0;
        de_ex_funct7  <= 7'd0;
        de_ex_opcode  <= 7'd0;
        wb_en         <= 1'b0;
        wb_rd         <= 5'd0;
        wb_val        <= 32'd0;
        muldiv_start  <= 1'b0;
        muldiv_op     <= 3'd0;
        muldiv_a      <= 32'd0;
        muldiv_b      <= 32'd0;
        aw_done       <= 1'b0;
        w_done        <= 1'b0;
        fetch_addr_r  <= 32'd0;
        load_addr_r   <= 32'd0;
        load_funct3_r <= 3'd0;
        dmem_awaddr   <= 32'd0;
        dmem_awvalid  <= 1'b0;
        dmem_wdata    <= 32'd0;
        dmem_wstrb    <= 4'd0;
        dmem_wvalid   <= 1'b0;
        dmem_bready   <= 1'b0;
        dmem_araddr   <= 32'd0;
        dmem_arvalid  <= 1'b0;
        dmem_rready   <= 1'b0;
        axi_state     <= AXI_IDLE;
        for (rf_idx = 1; rf_idx < 32; rf_idx = rf_idx + 1)
            regfile[rf_idx] <= 32'd0;
    end else begin
        wb_en        <= 1'b0;
        muldiv_start <= 1'b0;
        case (axi_state)

            AXI_IDLE: begin
                if (de_ex_valid && de_ex_is_mem) begin
                    mem_addr     = de_ex_rs1_val + de_ex_imm;
                    mem_addr_lo  = mem_addr[1:0];
                    mem_addr_bit1 = mem_addr[1];
                    load_addr_r   <= mem_addr;
                    load_funct3_r <= de_ex_funct3;
                    if (de_ex_is_store) begin
                        dmem_awaddr  <= mem_addr;
                        dmem_awvalid <= 1'b1;
                        case (de_ex_funct3)
                            3'b000: begin
                                dmem_wdata <= {4{de_ex_rs2_val[7:0]}};
                                case (mem_addr_lo)
                                    2'b00: dmem_wstrb <= 4'b0001;
                                    2'b01: dmem_wstrb <= 4'b0010;
                                    2'b10: dmem_wstrb <= 4'b0100;
                                    default: dmem_wstrb <= 4'b1000;
                                endcase
                            end
                            3'b001: begin
                                dmem_wdata <= {2{de_ex_rs2_val[15:0]}};
                                dmem_wstrb <= mem_addr_bit1 ? 4'b1100 : 4'b0011;
                            end
                            default: begin
                                dmem_wdata <= de_ex_rs2_val;
                                dmem_wstrb <= 4'b1111;
                            end
                        endcase
                        dmem_wvalid <= 1'b1;
                        aw_done     <= 1'b0;
                        w_done      <= 1'b0;
                        axi_state   <= AXI_DATA_AW;
                    end else begin
                        dmem_araddr  <= mem_addr;
                        dmem_arvalid <= 1'b1;
                        axi_state    <= AXI_DATA_AR;
                    end
                end else if (fetch_ok) begin
                    fetch_addr_r <= pc;
                    dmem_araddr  <= pc;
                    dmem_arvalid <= 1'b1;
                    axi_state    <= AXI_FETCH_AR;
                end
            end

            AXI_FETCH_AR: begin
                if (dmem_arready) begin
                    dmem_arvalid <= 1'b0;
                    dmem_rready  <= 1'b1;
                    axi_state    <= AXI_FETCH_R;
                end
            end

            AXI_FETCH_R: begin
                if (dmem_rvalid && dmem_rready) begin
                    dmem_rready <= 1'b0;
                    axi_state   <= AXI_IDLE;
                    if (de_ex_valid && (de_ex_is_branch || de_ex_is_jal || de_ex_is_jalr)) begin
                        if_de_valid <= 1'b0;
                    end else begin
                        if_de_valid <= 1'b1;
                        if_de_instr <= dmem_rdata;
                        if_de_pc    <= fetch_addr_r;
                        pc          <= fetch_addr_r + 32'd4;
                    end
                end
            end

            AXI_DATA_AR: begin
                if (dmem_arready) begin
                    dmem_arvalid <= 1'b0;
                    dmem_rready  <= 1'b1;
                    axi_state    <= AXI_DATA_R;
                end
            end

            AXI_DATA_R: begin
                if (dmem_rvalid && dmem_rready) begin
                    dmem_rready <= 1'b0;
                    axi_state   <= AXI_IDLE;
                    case (load_funct3_r)
                        3'b000: begin
                            case (load_addr_r[1:0])
                                2'b00: wb_val <= {{24{dmem_rdata[7]}},  dmem_rdata[7:0]};
                                2'b01: wb_val <= {{24{dmem_rdata[15]}}, dmem_rdata[15:8]};
                                2'b10: wb_val <= {{24{dmem_rdata[23]}}, dmem_rdata[23:16]};
                                default: wb_val <= {{24{dmem_rdata[31]}}, dmem_rdata[31:24]};
                            endcase
                        end
                        3'b001: begin
                            if (load_addr_r[1])
                                wb_val <= {{16{dmem_rdata[31]}}, dmem_rdata[31:16]};
                            else
                                wb_val <= {{16{dmem_rdata[15]}}, dmem_rdata[15:0]};
                        end
                        3'b010: wb_val <= dmem_rdata;
                        3'b100: begin
                            case (load_addr_r[1:0])
                                2'b00: wb_val <= {24'd0, dmem_rdata[7:0]};
                                2'b01: wb_val <= {24'd0, dmem_rdata[15:8]};
                                2'b10: wb_val <= {24'd0, dmem_rdata[23:16]};
                                default: wb_val <= {24'd0, dmem_rdata[31:24]};
                            endcase
                        end
                        3'b101: begin
                            if (load_addr_r[1])
                                wb_val <= {16'd0, dmem_rdata[31:16]};
                            else
                                wb_val <= {16'd0, dmem_rdata[15:0]};
                        end
                        default: wb_val <= dmem_rdata;
                    endcase
                    if (de_ex_rd != 5'd0) begin
                        wb_en <= 1'b1;
                        wb_rd <= de_ex_rd;
                    end
                    de_ex_valid <= 1'b0;
                end
            end

            AXI_DATA_AW: begin
                if (dmem_awvalid && dmem_awready) begin
                    dmem_awvalid <= 1'b0;
                    aw_done      <= 1'b1;
                end
                if (dmem_wvalid && dmem_wready) begin
                    dmem_wvalid <= 1'b0;
                    w_done      <= 1'b1;
                end
                if ((aw_done || (dmem_awvalid && dmem_awready)) &&
                    (w_done  || (dmem_wvalid  && dmem_wready))) begin
                    dmem_awvalid <= 1'b0;
                    dmem_wvalid  <= 1'b0;
                    dmem_bready  <= 1'b1;
                    aw_done      <= 1'b0;
                    w_done       <= 1'b0;
                    axi_state    <= AXI_DATA_B;
                end
            end

            AXI_DATA_B: begin
                if (dmem_bvalid && dmem_bready) begin
                    dmem_bready <= 1'b0;
                    de_ex_valid <= 1'b0;
                    axi_state   <= AXI_IDLE;
                end
            end

            default: axi_state <= AXI_IDLE;
        endcase
        if (de_ex_valid && !axi_busy) begin

            if (de_ex_is_custom) begin
                if (custom_rd_valid) begin
                    if (de_ex_rd != 5'd0) begin
                        regfile[de_ex_rd] <= custom_rd;
                        wb_en  <= 1'b1;
                        wb_rd  <= de_ex_rd;
                        wb_val <= custom_rd;
                    end
                    de_ex_valid <= 1'b0;
                end

            end else if (de_ex_is_muldiv) begin
                if (!muldiv_busy) begin
                    if (muldiv_done) begin
                        if (de_ex_rd != 5'd0) begin
                            regfile[de_ex_rd] <= muldiv_result;
                            wb_en  <= 1'b1;
                            wb_rd  <= de_ex_rd;
                            wb_val <= muldiv_result;
                        end
                        de_ex_valid <= 1'b0;
                    end else begin
                        muldiv_start <= 1'b1;
                        muldiv_op    <= de_ex_funct3;
                        muldiv_a     <= de_ex_rs1_val;
                        muldiv_b     <= de_ex_rs2_val;
                    end
                end

            end else if (de_ex_is_mem) begin

            end else begin
                alu_out      = 32'd0;
                branch_taken = 1'b0;
                branch_target = de_ex_pc + de_ex_imm;

                if (de_ex_is_lui) begin
                    alu_out = de_ex_imm;

                end else if (de_ex_is_auipc) begin
                    alu_out = de_ex_pc + de_ex_imm;

                end else if (de_ex_is_jal) begin
                    alu_out      = de_ex_pc + 32'd4;
                    branch_target = de_ex_pc + de_ex_imm;
                    branch_taken = 1'b1;

                end else if (de_ex_is_jalr) begin
                    alu_out      = de_ex_pc + 32'd4;
                    branch_target = (de_ex_rs1_val + de_ex_imm) & ~32'd1;
                    branch_taken = 1'b1;

                end else if (de_ex_is_branch) begin
                    alu_out = 32'd0;
                    case (de_ex_funct3)
                        3'b000: branch_taken = (de_ex_rs1_val == de_ex_rs2_val);
                        3'b001: branch_taken = (de_ex_rs1_val != de_ex_rs2_val);
                        3'b100: branch_taken = ($signed(de_ex_rs1_val) < $signed(de_ex_rs2_val));
                        3'b101: branch_taken = ($signed(de_ex_rs1_val) >= $signed(de_ex_rs2_val));
                        3'b110: branch_taken = (de_ex_rs1_val < de_ex_rs2_val);
                        3'b111: branch_taken = (de_ex_rs1_val >= de_ex_rs2_val);
                        default: branch_taken = 1'b0;
                    endcase

                end else begin
                    case (de_ex_funct3)
                        3'b000: begin
                            if (de_ex_opcode == OPC_ALU && de_ex_funct7[5])
                                alu_out = de_ex_rs1_val - de_ex_rs2_val;
                            else if (de_ex_opcode == OPC_ALU)
                                alu_out = de_ex_rs1_val + de_ex_rs2_val;
                            else
                                alu_out = de_ex_rs1_val + de_ex_imm;
                        end
                        3'b001: begin
                            if (de_ex_opcode == OPC_ALU)
                                alu_out = de_ex_rs1_val << de_ex_rs2_val[4:0];
                            else
                                alu_out = de_ex_rs1_val << de_ex_instr[24:20];
                        end
                        3'b010: begin
                            if (de_ex_opcode == OPC_ALU)
                                alu_out = ($signed(de_ex_rs1_val) < $signed(de_ex_rs2_val)) ? 32'd1 : 32'd0;
                            else
                                alu_out = ($signed(de_ex_rs1_val) < $signed(de_ex_imm)) ? 32'd1 : 32'd0;
                        end
                        3'b011: begin
                            if (de_ex_opcode == OPC_ALU)
                                alu_out = (de_ex_rs1_val < de_ex_rs2_val) ? 32'd1 : 32'd0;
                            else
                                alu_out = (de_ex_rs1_val < de_ex_imm) ? 32'd1 : 32'd0;
                        end
                        3'b100: begin
                            if (de_ex_opcode == OPC_ALU)
                                alu_out = de_ex_rs1_val ^ de_ex_rs2_val;
                            else
                                alu_out = de_ex_rs1_val ^ de_ex_imm;
                        end
                        3'b101: begin
                            if (de_ex_opcode == OPC_ALU) begin
                                if (de_ex_funct7[5])
                                    alu_out = $signed(de_ex_rs1_val) >>> de_ex_rs2_val[4:0];
                                else
                                    alu_out = de_ex_rs1_val >> de_ex_rs2_val[4:0];
                            end else begin
                                if (de_ex_funct7[5])
                                    alu_out = $signed(de_ex_rs1_val) >>> de_ex_instr[24:20];
                                else
                                    alu_out = de_ex_rs1_val >> de_ex_instr[24:20];
                            end
                        end
                        3'b110: begin
                            if (de_ex_opcode == OPC_ALU)
                                alu_out = de_ex_rs1_val | de_ex_rs2_val;
                            else
                                alu_out = de_ex_rs1_val | de_ex_imm;
                        end
                        3'b111: begin
                            if (de_ex_opcode == OPC_ALU)
                                alu_out = de_ex_rs1_val & de_ex_rs2_val;
                            else
                                alu_out = de_ex_rs1_val & de_ex_imm;
                        end
                        default: alu_out = 32'd0;
                    endcase
                end
                if (de_ex_wb_en && de_ex_rd != 5'd0) begin
                    regfile[de_ex_rd] <= alu_out;
                    wb_en  <= 1'b1;
                    wb_rd  <= de_ex_rd;
                    wb_val <= alu_out;
                end
                if (branch_taken) begin
                    if_de_valid <= 1'b0;
                    pc          <= branch_target;
                end

                de_ex_valid <= 1'b0;
            end
        end
        if (wb_en && wb_rd != 5'd0) begin
            regfile[wb_rd] <= wb_val;
        end
        if (!pipe_stall && !de_ex_valid && if_de_valid) begin
            de_ex_valid    <= 1'b1;
            de_ex_instr    <= if_de_instr;
            de_ex_pc       <= if_de_pc;
            de_ex_funct3   <= d_funct3;
            de_ex_funct7   <= d_funct7;
            de_ex_opcode   <= d_opcode;
            de_ex_rs1_val  <= rs1_fwd;
            de_ex_rs2_val  <= rs2_fwd;
            de_ex_rd       <= d_rd;
            de_ex_is_mem   <= (d_opcode == OPC_LOAD || d_opcode == OPC_STORE);
            de_ex_is_store <= (d_opcode == OPC_STORE);
            de_ex_is_branch<= (d_opcode == OPC_BRANCH);
            de_ex_is_jal   <= (d_opcode == OPC_JAL);
            de_ex_is_jalr  <= (d_opcode == OPC_JALR);
            de_ex_is_lui   <= (d_opcode == OPC_LUI);
            de_ex_is_auipc <= (d_opcode == OPC_AUIPC);
            de_ex_is_custom<= (d_opcode == OPC_CUSTOM);
            de_ex_is_muldiv<= (d_opcode == OPC_ALU && d_funct7 == 7'h01);
            de_ex_wb_en    <= (d_opcode != OPC_BRANCH &&
                               d_opcode != OPC_STORE  &&
                               d_opcode != OPC_FENCE  &&
                               d_opcode != OPC_CUSTOM &&
                               d_rd    != 5'd0);
            case (d_opcode)
                OPC_LUI:    de_ex_imm <= d_imm_u;
                OPC_AUIPC:  de_ex_imm <= d_imm_u;
                OPC_JAL:    de_ex_imm <= d_imm_j;
                OPC_JALR:   de_ex_imm <= d_imm_i;
                OPC_BRANCH: de_ex_imm <= d_imm_b;
                OPC_LOAD:   de_ex_imm <= d_imm_i;
                OPC_STORE:  de_ex_imm <= d_imm_s;
                OPC_ALUI:   de_ex_imm <= d_imm_i;
                default:    de_ex_imm <= 32'd0;
            endcase
            if_de_valid <= 1'b0;
        end

    end
end

endmodule

`default_nettype wire
