`timescale 1ns/1ps
`default_nettype none

module gpio (
    input  wire        clk,
    input  wire        rst_n,

    input  wire [31:0] gpio_in,
    output reg  [31:0] gpio_out,
    output reg  [31:0] gpio_dir,
    output reg         irq,

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

    reg [31:0] sync0;
    reg [31:0] sync1;
    reg [31:0] sync_prev;
    reg [31:0] ie_r;
    reg [31:0] is_r;
    reg [31:0] iev_r;

    wire [31:0] edge_det;
    assign edge_det = sync1 ^ sync_prev;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sync0     <= 32'd0;
            sync1     <= 32'd0;
            sync_prev <= 32'd0;
            is_r      <= 32'd0;
            irq       <= 1'b0;
        end else begin
            sync0     <= gpio_in;
            sync1     <= sync0;
            sync_prev <= sync1;
            is_r      <= is_r | (edge_det & ie_r & ~gpio_dir);
            irq       <= |(is_r | (edge_det & ie_r & ~gpio_dir));
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            s_axil_awready <= 1'b0;
            s_axil_wready  <= 1'b0;
            s_axil_bvalid  <= 1'b0;
            s_axil_bresp   <= 2'b00;
            gpio_out       <= 32'd0;
            gpio_dir       <= 32'd0;
            ie_r           <= 32'd0;
            iev_r          <= 32'd0;
        end else begin
            s_axil_awready <= 1'b0;
            s_axil_wready  <= 1'b0;
            if (s_axil_awvalid && s_axil_wvalid && !s_axil_bvalid) begin
                s_axil_awready <= 1'b1;
                s_axil_wready  <= 1'b1;
                s_axil_bvalid  <= 1'b1;
                s_axil_bresp   <= 2'b00;
                case (s_axil_awaddr)
                    12'h000: begin
                        if (s_axil_wstrb[0]) gpio_out[7:0]   <= s_axil_wdata[7:0];
                        if (s_axil_wstrb[1]) gpio_out[15:8]  <= s_axil_wdata[15:8];
                        if (s_axil_wstrb[2]) gpio_out[23:16] <= s_axil_wdata[23:16];
                        if (s_axil_wstrb[3]) gpio_out[31:24] <= s_axil_wdata[31:24];
                    end
                    12'h004: begin
                        if (s_axil_wstrb[0]) gpio_dir[7:0]   <= s_axil_wdata[7:0];
                        if (s_axil_wstrb[1]) gpio_dir[15:8]  <= s_axil_wdata[15:8];
                        if (s_axil_wstrb[2]) gpio_dir[23:16] <= s_axil_wdata[23:16];
                        if (s_axil_wstrb[3]) gpio_dir[31:24] <= s_axil_wdata[31:24];
                    end
                    12'h008: begin
                        if (s_axil_wstrb[0]) ie_r[7:0]   <= s_axil_wdata[7:0];
                        if (s_axil_wstrb[1]) ie_r[15:8]  <= s_axil_wdata[15:8];
                        if (s_axil_wstrb[2]) ie_r[23:16] <= s_axil_wdata[23:16];
                        if (s_axil_wstrb[3]) ie_r[31:24] <= s_axil_wdata[31:24];
                    end
                    12'h00C: begin
                        if (s_axil_wstrb[0]) is_r[7:0]   <= is_r[7:0]   & ~s_axil_wdata[7:0];
                        if (s_axil_wstrb[1]) is_r[15:8]  <= is_r[15:8]  & ~s_axil_wdata[15:8];
                        if (s_axil_wstrb[2]) is_r[23:16] <= is_r[23:16] & ~s_axil_wdata[23:16];
                        if (s_axil_wstrb[3]) is_r[31:24] <= is_r[31:24] & ~s_axil_wdata[31:24];
                    end
                    12'h010: begin
                        if (s_axil_wstrb[0]) iev_r[7:0]   <= s_axil_wdata[7:0];
                        if (s_axil_wstrb[1]) iev_r[15:8]  <= s_axil_wdata[15:8];
                        if (s_axil_wstrb[2]) iev_r[23:16] <= s_axil_wdata[23:16];
                        if (s_axil_wstrb[3]) iev_r[31:24] <= s_axil_wdata[31:24];
                    end
                    default: ;
                endcase
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
                    12'h000: begin s_axil_rdata <= sync1;    s_axil_rresp <= 2'b00; end
                    12'h004: begin s_axil_rdata <= gpio_dir; s_axil_rresp <= 2'b00; end
                    12'h008: begin s_axil_rdata <= ie_r;     s_axil_rresp <= 2'b00; end
                    12'h00C: begin s_axil_rdata <= is_r;     s_axil_rresp <= 2'b00; end
                    12'h010: begin s_axil_rdata <= iev_r;    s_axil_rresp <= 2'b00; end
                    default: begin s_axil_rdata <= 32'd0;    s_axil_rresp <= 2'b10; end
                endcase
            end
            if (s_axil_rvalid && s_axil_rready)
                s_axil_rvalid <= 1'b0;
        end
    end

endmodule
