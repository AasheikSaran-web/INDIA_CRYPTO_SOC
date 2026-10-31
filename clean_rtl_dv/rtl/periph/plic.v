`timescale 1ns/1ps
`default_nettype none

// plic: hardware module definition
module plic #(
    parameter N_SRC = 8
) (
    input  wire              clk,
    input  wire              rst_n,

    input  wire [N_SRC-1:0]  irq_src,
    output reg               irq_out,

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

    reg [2:0]  priority_r [0:N_SRC-1];
    reg [N_SRC-1:0] enable_r;
    reg [2:0]  threshold_r;

    wire [N_SRC-1:0] pending;
    assign pending = irq_src & enable_r;

    reg [3:0]  claim_id;
    reg [2:0]  max_pri;

    integer i;
    // PLIC interrupt priority register array write on AXI access
    always @(*) begin
        claim_id = 4'd0;
        max_pri  = 3'd0;
        for (i = 0; i < N_SRC; i = i + 1) begin
            if (pending[i] && (priority_r[i] > max_pri)) begin
                max_pri  = priority_r[i];
                claim_id = i[3:0];
            end
        end
    end

    // PLIC interrupt enable register write for each context
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            irq_out <= 1'b0;
        else
            irq_out <= (|pending) && (max_pri > threshold_r);
    end

    integer j;
    // PLIC priority threshold register write per context
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            s_axil_awready <= 1'b0;
            s_axil_wready  <= 1'b0;
            s_axil_bvalid  <= 1'b0;
            s_axil_bresp   <= 2'b00;
            enable_r       <= {N_SRC{1'b0}};
            threshold_r    <= 3'd0;
            for (j = 0; j < N_SRC; j = j + 1)
                priority_r[j] <= 3'd0;
        end else begin
            s_axil_awready <= 1'b0;
            s_axil_wready  <= 1'b0;
            if (s_axil_awvalid && s_axil_wvalid && !s_axil_bvalid) begin
                s_axil_awready <= 1'b1;
                s_axil_wready  <= 1'b1;
                s_axil_bvalid  <= 1'b1;
                s_axil_bresp   <= 2'b00;
                casez (s_axil_awaddr)
                    12'h0??: begin
                        if (s_axil_awaddr[7:2] < N_SRC[5:0])
                            priority_r[s_axil_awaddr[7:2]] <= s_axil_wdata[2:0];
                    end
                    12'h200: enable_r    <= s_axil_wdata[N_SRC-1:0];
                    12'h300: threshold_r <= s_axil_wdata[2:0];
                    12'h304: ;
                    default: ;
                endcase
            end
            if (s_axil_bvalid && s_axil_bready)
                s_axil_bvalid <= 1'b0;
        end
    end

    // PLIC claim/complete register write — claim clears pending, complete clears IP
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
                s_axil_rresp   <= 2'b00;
                casez (s_axil_araddr)
                    12'h0??: begin
                        if (s_axil_araddr[7:2] < N_SRC[5:0])
                            s_axil_rdata <= {29'd0, priority_r[s_axil_araddr[7:2]]};
                        else begin
                            s_axil_rdata <= 32'd0;
                            s_axil_rresp <= 2'b10;
                        end
                    end
                    12'h100: s_axil_rdata <= {{(32-N_SRC){1'b0}}, pending};
                    12'h200: s_axil_rdata <= {{(32-N_SRC){1'b0}}, enable_r};
                    12'h300: s_axil_rdata <= {29'd0, threshold_r};
                    12'h304: s_axil_rdata <= {28'd0, claim_id};
                    default: begin
                        s_axil_rdata <= 32'd0;
                        s_axil_rresp <= 2'b10;
                    end
                endcase
            end
            if (s_axil_rvalid && s_axil_rready)
                s_axil_rvalid <= 1'b0;
        end
    end

endmodule
