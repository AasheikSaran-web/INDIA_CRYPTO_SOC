`timescale 1ns/1ps
`default_nettype none

// boot_rom: hardware module definition
module boot_rom (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [31:0] s_axil_araddr,
    input  wire        s_axil_arvalid,
    output reg         s_axil_arready,
    output reg  [31:0] s_axil_rdata,
    output reg  [1:0]  s_axil_rresp,
    output reg         s_axil_rvalid,
    input  wire        s_axil_rready,
    input  wire [31:0] s_axil_awaddr,
    input  wire        s_axil_awvalid,
    output reg         s_axil_awready,
    input  wire [31:0] s_axil_wdata,
    input  wire [3:0]  s_axil_wstrb,
    input  wire        s_axil_wvalid,
    output reg         s_axil_wready,
    output reg  [1:0]  s_axil_bresp,
    output reg         s_axil_bvalid,
    input  wire        s_axil_bready
);
    localparam ROM_DEPTH = 8192;
    reg [31:0] mem [0:ROM_DEPTH-1];

    integer i;
    // Simulation initialisation or stimulus block
    initial begin
        for (i = 0; i < ROM_DEPTH; i = i + 1)
            mem[i] = 32'h0000_0013;
        mem[0]  = 32'h4000_21B7;
        mem[1]  = 32'h2000_0237;
        mem[2]  = 32'h2001_0137;
        mem[3]  = 32'hFFC1_0113;
        mem[4]  = 32'h0001_AA23;
        mem[5]  = 32'h0010_0313;
        mem[6]  = 32'h0061_A223;
        mem[7]  = 32'h0300_0337;
        mem[8]  = 32'h0061_A423;
        mem[9]  = 32'h0001_A623;
        mem[10] = 32'h0020_2337;
        mem[11] = 32'h8083_0313;
        mem[12] = 32'h0061_A823;
        mem[13] = 32'h0202_0293;
        mem[14] = 32'h1010_0313;
        mem[15] = 32'h0061_A023;
        mem[16] = 32'h0001_A383;
        mem[17] = 32'h0013_F393;
        mem[18] = 32'hFE03_8CE3;
        mem[19] = 32'h0201_A383;
        mem[20] = 32'h0072_2023;
        mem[21] = 32'h0042_0213;
        mem[22] = 32'hFE52_1AE3;
        mem[23] = 32'h2000_00B7;
        mem[24] = 32'h0000_8067;
    end
    localparam RD_IDLE = 1'b0, RD_DATA = 1'b1;
    reg rd_state;
    reg [12:0] rd_word_addr;

    // Boot ROM AXI-Lite read address latch and response generation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rd_state       <= RD_IDLE;
            s_axil_arready <= 1'b0;
            s_axil_rvalid  <= 1'b0;
            s_axil_rdata   <= 32'd0;
            s_axil_rresp   <= 2'b00;
            rd_word_addr   <= 13'd0;
        end else begin
            s_axil_arready <= 1'b0;

            case (rd_state)
                RD_IDLE: begin
                    if (s_axil_arvalid) begin
                        rd_word_addr   <= s_axil_araddr[14:2];
                        s_axil_arready <= 1'b1;
                        s_axil_rdata   <= mem[s_axil_araddr[14:2]];
                        s_axil_rresp   <= 2'b00;
                        s_axil_rvalid  <= 1'b1;
                        rd_state       <= RD_DATA;
                    end
                end
                RD_DATA: begin
                    if (s_axil_rready) begin
                        s_axil_rvalid <= 1'b0;
                        rd_state      <= RD_IDLE;
                    end
                end
            endcase
        end
    end
    // Boot ROM read-data mux indexed by word address
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            s_axil_awready <= 1'b0;
            s_axil_wready  <= 1'b0;
            s_axil_bvalid  <= 1'b0;
            s_axil_bresp   <= 2'b10;
        end else begin
            s_axil_awready <= 1'b0;
            s_axil_wready  <= 1'b0;
            if (s_axil_awvalid && s_axil_wvalid && !s_axil_bvalid) begin
                s_axil_awready <= 1'b1;
                s_axil_wready  <= 1'b1;
                s_axil_bvalid  <= 1'b1;
                s_axil_bresp   <= 2'b10;
            end
            if (s_axil_bvalid && s_axil_bready)
                s_axil_bvalid <= 1'b0;
        end
    end

endmodule
