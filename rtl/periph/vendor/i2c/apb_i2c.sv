`include "i2c_master_defines.sv"

`define REG_CLK_PRESCALER 3'b000
`define REG_CTRL          3'b001
`define REG_RX            3'b010
`define REG_STATUS        3'b011
`define REG_TX            3'b100
`define REG_CMD           3'b101

module apb_i2c
#(
    parameter APB_ADDR_WIDTH = 12
)
(
    input  logic                      HCLK,
    input  logic                      HRESETn,
    input  logic [APB_ADDR_WIDTH-1:0] PADDR,
    input  logic               [31:0] PWDATA,
    input  logic                      PWRITE,
    input  logic                      PSEL,
    input  logic                      PENABLE,
    output logic               [31:0] PRDATA,
    output logic                      PREADY,
    output logic                      PSLVERR,
    output logic                      interrupt_o,
    input  logic                      scl_pad_i,
    output logic                      scl_pad_o,
    output logic                      scl_padoen_o,
    input  logic                      sda_pad_i,
    output logic                      sda_pad_o,
    output logic                      sda_padoen_o
);

    logic  [3:0] s_apb_addr;

    reg  [15:0] r_pre;
    reg  [ 7:0] r_ctrl;
    reg  [ 7:0] r_tx;
    wire [ 7:0] s_rx;
    reg  [ 7:0] r_cmd;
    wire [ 7:0] s_status;

    wire s_done;

    wire s_core_en;
    wire s_ien;

    wire s_irxack;
    reg  rxack;
    reg  tip;
    reg  irq_flag;
    wire i2c_busy;
    wire i2c_al;
    reg  al;

    assign s_apb_addr = PADDR[5:2];

    always_ff @ (posedge HCLK, negedge HRESETn)
    begin
        if(~HRESETn)
        begin
            r_pre  <= 'h0;
            r_ctrl <= 'h0;
            r_tx   <= 'h0;
            r_cmd  <= 'h0;
        end
        else if (PSEL && PENABLE && PWRITE)
             begin
                if (s_done | i2c_al)
                      r_cmd[7:4] <= 4'h0;

                r_cmd[2:1] <= 2'b0;
                r_cmd[0]   <= 1'b0;
                case (s_apb_addr)
                    `REG_CLK_PRESCALER:
                        r_pre <= PWDATA[15:0];
                    `REG_CTRL:
                        r_ctrl <= PWDATA[7:0];
                    `REG_TX:
                        r_tx <= PWDATA[7:0];
                    `REG_CMD:
                    begin
                        if(s_core_en)
                            r_cmd <= PWDATA[7:0];
                    end
                endcase
            end
            else
            begin
                if (s_done | i2c_al)
                    r_cmd[7:4] <= 4'h0;

                r_cmd[2:1] <= 2'b0;
                r_cmd[0]   <= 1'b0;
            end
    end

    always_comb
    begin
        case (s_apb_addr)
            `REG_CLK_PRESCALER:
                PRDATA = {16'h0,r_pre};
            `REG_CTRL:
                PRDATA = {24'h0,r_ctrl};
            `REG_RX:
                PRDATA = {24'h0,s_rx};
            `REG_STATUS:
                PRDATA = {24'h0,s_status};
            `REG_TX:
                PRDATA = {24'h0,r_tx};
            `REG_CMD:
                PRDATA = {24'h0,r_cmd};
            default:
                PRDATA = 'h0;
        endcase
    end

    wire sta  = r_cmd[7];
    wire sto  = r_cmd[6];
    wire rd   = r_cmd[5];
    wire wr   = r_cmd[4];
    wire ack  = r_cmd[3];
    wire iack = r_cmd[0];

    assign s_core_en = r_ctrl[7];
    assign s_ien     = r_ctrl[6];

    i2c_master_byte_ctrl byte_controller
    (
            .clk      ( HCLK         ),
            .nReset   ( HRESETn      ),
            .ena      ( s_core_en    ),
            .clk_cnt  ( r_pre        ),
            .start    ( sta          ),
            .stop     ( sto          ),
            .read     ( rd           ),
            .write    ( wr           ),
            .ack_in   ( ack          ),
            .din      ( r_tx         ),
            .cmd_ack  ( s_done       ),
            .ack_out  ( s_irxack     ),
            .dout     ( s_rx         ),
            .i2c_busy ( i2c_busy     ),
            .i2c_al   ( i2c_al       ),
            .scl_i    ( scl_pad_i    ),
            .scl_o    ( scl_pad_o    ),
            .scl_oen  ( scl_padoen_o ),
            .sda_i    ( sda_pad_i    ),
            .sda_o    ( sda_pad_o    ),
            .sda_oen  ( sda_padoen_o )
    );

    always_ff @(posedge HCLK, negedge HRESETn)
    begin
        if (!HRESETn)
        begin
            al       <= 1'b0;
            rxack    <= 1'b0;
            tip      <= 1'b0;
            irq_flag <= 1'b0;
        end
        else
        begin
            al       <= i2c_al | (al & ~sta);
            rxack    <= s_irxack;
            tip      <= (rd | wr);
            irq_flag <= (s_done | i2c_al | irq_flag) & ~iack;
        end
    end

    always_ff @(posedge HCLK, negedge HRESETn)
    begin
        if (!HRESETn)
            interrupt_o <= 1'b0;
        else
            interrupt_o <= irq_flag && s_ien;
    end

    assign s_status[7]   = rxack;
    assign s_status[6]   = i2c_busy;
    assign s_status[5]   = al;
    assign s_status[4:2] = 3'h0;
    assign s_status[1]   = tip;
    assign s_status[0]   = irq_flag;

    assign PREADY  = 1'b1;
    assign PSLVERR = 1'b0;

endmodule
