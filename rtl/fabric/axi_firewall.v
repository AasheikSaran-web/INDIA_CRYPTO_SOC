`default_nettype none
`timescale 1ns/1ps

module axi_firewall #(
    parameter N_SLAVES        = 8,
    parameter N_MASTERS       = 4,
    parameter LOG_DEPTH       = 4,
    parameter [31:0] LOCK_KEY = 32'hDEADBEEF,

    parameter [31:0] DEFAULT_PERM = 32'h1111_1131
)(
    input  wire        clk,
    input  wire        rst_n,

    input  wire [1:0]  master_id,
    input  wire [2:0]  slave_id,

    input  wire [31:0] u_awaddr,
    input  wire        u_awvalid,
    output reg         u_awready,
    input  wire [31:0] u_wdata,
    input  wire [3:0]  u_wstrb,
    input  wire        u_wvalid,
    output reg         u_wready,
    output reg  [1:0]  u_bresp,
    output reg         u_bvalid,
    input  wire        u_bready,

    input  wire [31:0] u_araddr,
    input  wire        u_arvalid,
    output reg         u_arready,
    output reg  [31:0] u_rdata,
    output reg  [1:0]  u_rresp,
    output reg         u_rvalid,
    input  wire        u_rready,

    output reg  [31:0] d_awaddr,
    output reg         d_awvalid,
    input  wire        d_awready,
    output reg  [31:0] d_wdata,
    output reg  [3:0]  d_wstrb,
    output reg         d_wvalid,
    input  wire        d_wready,
    input  wire [1:0]  d_bresp,
    input  wire        d_bvalid,
    output reg         d_bready,

    output reg  [31:0] d_araddr,
    output reg         d_arvalid,
    input  wire        d_arready,
    input  wire [31:0] d_rdata,
    input  wire [1:0]  d_rresp,
    input  wire        d_rvalid,
    output reg         d_rready,

    input  wire [31:0] f_awaddr,
    input  wire        f_awvalid,
    output reg         f_awready,
    input  wire [31:0] f_wdata,
    input  wire [3:0]  f_wstrb,
    input  wire        f_wvalid,
    output reg         f_wready,
    output reg  [1:0]  f_bresp,
    output reg         f_bvalid,
    input  wire        f_bready,

    input  wire [31:0] f_araddr,
    input  wire        f_arvalid,
    output reg         f_arready,
    output reg  [31:0] f_rdata,
    output reg  [1:0]  f_rresp,
    output reg         f_rvalid,
    input  wire        f_rready,

    output reg         deny_irq
);

reg [31:0] perm_table;
reg        table_locked;
reg [31:0] last_denied_addr;
reg [1:0]  last_denied_master;
reg [15:0] deny_count;

wire [4:0] perm_idx = ({2'b00, slave_id} * N_MASTERS[4:0]) + {3'b000, master_id};
wire       wr_allowed = perm_table[perm_idx];
wire       rd_allowed = perm_table[perm_idx];

localparam WS_IDLE = 2'd0;
localparam WS_PASS = 2'd1;
localparam WS_DENY = 2'd2;
localparam WS_RESP = 2'd3;

reg [1:0] wstate;
reg       aw_captured;
reg       w_captured;
reg [31:0] aw_addr_lat;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        wstate          <= WS_IDLE;
        u_awready       <= 1'b0;
        u_wready        <= 1'b0;
        u_bvalid        <= 1'b0;
        u_bresp         <= 2'b00;
        d_awvalid       <= 1'b0;
        d_wvalid        <= 1'b0;
        d_awaddr        <= 32'h0;
        d_wdata         <= 32'h0;
        d_wstrb         <= 4'h0;
        d_bready        <= 1'b0;
        aw_captured     <= 1'b0;
        w_captured      <= 1'b0;
        aw_addr_lat     <= 32'h0;
        last_denied_addr   <= 32'h0;
        last_denied_master <= 2'h0;
        deny_count      <= 16'h0;
        deny_irq        <= 1'b0;
    end else begin

        u_awready <= 1'b0;
        u_wready  <= 1'b0;
        deny_irq  <= 1'b0;

        case (wstate)
        WS_IDLE: begin
            d_awvalid <= 1'b0;
            d_wvalid  <= 1'b0;
            d_bready  <= 1'b0;
            if (u_awvalid && !aw_captured) begin

                aw_addr_lat <= u_awaddr;
                u_awready   <= 1'b1;
                aw_captured <= 1'b1;
            end
            if (u_wvalid && !w_captured) begin
                u_wready  <= 1'b1;
                w_captured <= 1'b1;
            end
            if (aw_captured || (u_awvalid)) begin
                if (w_captured || u_wvalid) begin

                    if (wr_allowed) begin
                        wstate    <= WS_PASS;

                        d_awvalid <= 1'b1;
                        d_wvalid  <= 1'b1;
                    end else begin

                        last_denied_addr   <= aw_addr_lat;
                        last_denied_master <= master_id;
                        deny_count         <= deny_count + 16'h1;
                        deny_irq           <= 1'b1;
                        wstate             <= WS_DENY;
                    end
                end
            end
        end

        WS_PASS: begin

            d_awaddr <= aw_addr_lat;
            d_wdata  <= u_wdata;
            d_wstrb  <= u_wstrb;
            d_bready <= u_bready;

            if (d_awready) d_awvalid <= 1'b0;
            if (d_wready)  d_wvalid  <= 1'b0;

            u_bvalid <= d_bvalid;
            u_bresp  <= d_bresp;
            if (d_bvalid && u_bready) begin
                aw_captured <= 1'b0;
                w_captured  <= 1'b0;
                d_awvalid   <= 1'b0;
                d_wvalid    <= 1'b0;
                wstate      <= WS_IDLE;
            end
        end

        WS_DENY: begin

            u_bvalid <= 1'b1;
            u_bresp  <= 2'b10;
            if (u_bready) begin
                u_bvalid    <= 1'b0;
                aw_captured <= 1'b0;
                w_captured  <= 1'b0;
                wstate      <= WS_IDLE;
            end
        end

        default: wstate <= WS_IDLE;
        endcase
    end
end

localparam RS_IDLE = 2'd0;
localparam RS_PASS = 2'd1;
localparam RS_DENY = 2'd2;

reg [1:0] rstate;
reg [31:0] ar_addr_lat;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        rstate      <= RS_IDLE;
        u_arready   <= 1'b0;
        u_rvalid    <= 1'b0;
        u_rdata     <= 32'h0;
        u_rresp     <= 2'b00;
        d_arvalid   <= 1'b0;
        d_araddr    <= 32'h0;
        d_rready    <= 1'b0;
        ar_addr_lat <= 32'h0;
    end else begin
        u_arready <= 1'b0;

        case (rstate)
        RS_IDLE: begin
            d_arvalid <= 1'b0;
            d_rready  <= 1'b0;
            if (u_arvalid) begin
                ar_addr_lat <= u_araddr;
                u_arready   <= 1'b1;
                if (rd_allowed) begin
                    rstate    <= RS_PASS;

                    d_arvalid <= 1'b1;
                end else begin
                    last_denied_addr   <= u_araddr;
                    last_denied_master <= master_id;
                    deny_count         <= deny_count + 16'h1;
                    deny_irq           <= 1'b1;
                    rstate             <= RS_DENY;
                end
            end
        end

        RS_PASS: begin

            d_araddr <= ar_addr_lat;

            if (d_arready) d_arvalid <= 1'b0;
            d_rready  <= u_rready;
            u_rvalid  <= d_rvalid;
            u_rdata   <= d_rdata;
            u_rresp   <= d_rresp;
            if (d_rvalid && u_rready) begin
                d_arvalid <= 1'b0;
                rstate    <= RS_IDLE;
            end
        end

        RS_DENY: begin
            u_rvalid <= 1'b1;
            u_rdata  <= 32'hDEAD_BEEF;
            u_rresp  <= 2'b10;
            if (u_rready) begin
                u_rvalid <= 1'b0;
                rstate   <= RS_IDLE;
            end
        end

        default: rstate <= RS_IDLE;
        endcase
    end
end

localparam CFG_PERM    = 3'h0;
localparam CFG_LOCK    = 3'h1;
localparam CFG_DA_ADDR = 3'h2;
localparam CFG_DA_MSTR = 3'h3;
localparam CFG_DENY_CT = 3'h4;

reg f_aw_done, f_w_done;
reg [31:0] f_awaddr_lat;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        perm_table   <= DEFAULT_PERM;
        table_locked <= 1'b0;
        f_awready    <= 1'b0;
        f_wready     <= 1'b0;
        f_bvalid     <= 1'b0;
        f_bresp      <= 2'b00;
        f_arready    <= 1'b0;
        f_rvalid     <= 1'b0;
        f_rdata      <= 32'h0;
        f_rresp      <= 2'b00;
        f_aw_done    <= 1'b0;
        f_w_done     <= 1'b0;
        f_awaddr_lat <= 32'h0;
    end else begin

        f_awready <= 1'b0;
        f_wready  <= 1'b0;
        f_arready <= 1'b0;

        if (f_awvalid && !f_aw_done) begin
            f_awready    <= 1'b1;
            f_awaddr_lat <= f_awaddr;
            f_aw_done    <= 1'b1;
        end
        if (f_wvalid && !f_w_done) begin
            f_wready  <= 1'b1;
            f_w_done  <= 1'b1;
        end
        if (f_aw_done && f_w_done) begin
            f_aw_done <= 1'b0;
            f_w_done  <= 1'b0;
            f_bvalid  <= 1'b1;
            f_bresp   <= 2'b00;
            case (f_awaddr_lat[4:2])
                CFG_PERM: begin
                    if (!table_locked)
                        perm_table <= f_wdata;
                    else
                        f_bresp <= 2'b10;
                end
                CFG_LOCK: begin
                    if (f_wdata == 32'hDEADBEEF)
                        table_locked <= 1'b1;
                end
                CFG_DENY_CT: begin
                    deny_count <= 16'h0;
                end
                default: f_bresp <= 2'b10;
            endcase
        end
        if (f_bvalid && f_bready) f_bvalid <= 1'b0;

        if (f_arvalid && !f_rvalid) begin
            f_arready <= 1'b1;
            f_rvalid  <= 1'b1;
            f_rresp   <= 2'b00;
            case (f_araddr[4:2])
                CFG_PERM:    f_rdata <= perm_table;
                CFG_LOCK:    f_rdata <= {31'h0, table_locked};
                CFG_DA_ADDR: f_rdata <= last_denied_addr;
                CFG_DA_MSTR: f_rdata <= {30'h0, last_denied_master};
                CFG_DENY_CT: f_rdata <= {16'h0, deny_count};
                default:     begin f_rdata <= 32'h0; f_rresp <= 2'b10; end
            endcase
        end
        if (f_rvalid && f_rready) f_rvalid <= 1'b0;
    end
end

endmodule
`default_nettype wire
