`timescale 1ns/1ps
`default_nettype none

module clint (
    input  wire        clk,
    input  wire        rst_n,

    output reg         timer_irq,
    output reg         soft_irq,

    input  wire [11:0] s_axil_awaddr,
    input  wire        s_axil_awvalid,
    output reg         s_axil_awready,
    input  wire [31:0] s_axil_wdata,
    input  wire [3:0]  s_axil_wstrb,
    input  wire        s_axil_wvalid,
    output reg         s_axil_wready,
    output reg  [1:0]  s_axil_bresp,
    output reg         s_axil_bvalid,
    input  wire        s_axil_bready,
    input  wire [11:0] s_axil_araddr,
    input  wire        s_axil_arvalid,
    output reg         s_axil_arready,
    output reg  [31:0] s_axil_rdata,
    output reg  [1:0]  s_axil_rresp,
    output reg         s_axil_rvalid,
    input  wire        s_axil_rready
);

    reg [63:0] mtime;
    reg [63:0] mtimecmp;
    reg [31:0] msip;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mtime <= 64'd0;
        else
            mtime <= mtime + 64'd1;
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            timer_irq <= 1'b0;
            soft_irq  <= 1'b0;
        end else begin
            timer_irq <= (mtimecmp != 64'd0) && (mtime >= mtimecmp);
            soft_irq  <= msip[0];
        end
    end

    reg [31:0] wr_data_lat;
    reg [3:0]  wr_strb_lat;
    reg [11:0] wr_addr_lat;

    function [31:0] apply_strb;
        input [31:0] orig;
        input [31:0] wdata;
        input [3:0]  strb;
        begin
            apply_strb[7:0]   = strb[0] ? wdata[7:0]   : orig[7:0];
            apply_strb[15:8]  = strb[1] ? wdata[15:8]  : orig[15:8];
            apply_strb[23:16] = strb[2] ? wdata[23:16] : orig[23:16];
            apply_strb[31:24] = strb[3] ? wdata[31:24] : orig[31:24];
        end
    endfunction

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            s_axil_awready <= 1'b0;
            s_axil_wready  <= 1'b0;
            s_axil_bvalid  <= 1'b0;
            s_axil_bresp   <= 2'b00;
            msip           <= 32'd0;
            mtimecmp       <= 64'd0;
            wr_addr_lat    <= 12'd0;
            wr_data_lat    <= 32'd0;
            wr_strb_lat    <= 4'd0;
        end else begin
            s_axil_awready <= 1'b0;
            s_axil_wready  <= 1'b0;
            if (s_axil_awvalid && s_axil_wvalid && !s_axil_bvalid) begin
                s_axil_awready <= 1'b1;
                s_axil_wready  <= 1'b1;
                wr_addr_lat    <= s_axil_awaddr;
                wr_data_lat    <= s_axil_wdata;
                wr_strb_lat    <= s_axil_wstrb;
                s_axil_bvalid  <= 1'b1;
                case (s_axil_awaddr)
                    12'h000: msip            <= apply_strb(msip, s_axil_wdata, s_axil_wstrb) & 32'h1;
                    12'h008: mtimecmp[31:0]  <= apply_strb(mtimecmp[31:0],  s_axil_wdata, s_axil_wstrb);
                    12'h00C: mtimecmp[63:32] <= apply_strb(mtimecmp[63:32], s_axil_wdata, s_axil_wstrb);
                    12'h010: mtime[31:0]     <= apply_strb(mtime[31:0],     s_axil_wdata, s_axil_wstrb);
                    12'h014: mtime[63:32]    <= apply_strb(mtime[63:32],    s_axil_wdata, s_axil_wstrb);
                    default: ;
                endcase
                s_axil_bresp <= 2'b00;
            end
            if (s_axil_bvalid && s_axil_bready)
                s_axil_bvalid <= 1'b0;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            s_axil_arready <= 1'b0;
            s_axil_rvalid  <= 1'b0;
            s_axil_rdata   <= 32'd0;
            s_axil_rresp   <= 2'b00;
        end else begin
            s_axil_arready <= 1'b0;
            if (s_axil_arvalid && !s_axil_rvalid) begin
                s_axil_arready <= 1'b1;
                s_axil_rvalid  <= 1'b1;
                case (s_axil_araddr)
                    12'h000: begin s_axil_rdata <= msip;             s_axil_rresp <= 2'b00; end
                    12'h008: begin s_axil_rdata <= mtimecmp[31:0];   s_axil_rresp <= 2'b00; end
                    12'h00C: begin s_axil_rdata <= mtimecmp[63:32];  s_axil_rresp <= 2'b00; end
                    12'h010: begin s_axil_rdata <= mtime[31:0];      s_axil_rresp <= 2'b00; end
                    12'h014: begin s_axil_rdata <= mtime[63:32];     s_axil_rresp <= 2'b00; end
                    default: begin s_axil_rdata <= 32'd0;            s_axil_rresp <= 2'b10; end
                endcase
            end
            if (s_axil_rvalid && s_axil_rready)
                s_axil_rvalid <= 1'b0;
        end
    end

endmodule
