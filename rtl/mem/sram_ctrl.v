

`timescale 1ns / 1ps

module sram_ctrl (
    input  wire         clk,
    input  wire         rst_n,

    
    input  wire         cpu_arvalid,
    input  wire [31:0]  cpu_araddr,   
    output reg          cpu_arready,
    output reg          cpu_rvalid,
    output reg  [31:0]  cpu_rdata,
    output wire [1:0]   cpu_rresp,
    input  wire         cpu_rready,

    
    
    input  wire         axi_awvalid,
    input  wire [31:0]  axi_awaddr,   
    output reg          axi_awready,
    
    input  wire         axi_wvalid,
    input  wire [31:0]  axi_wdata,
    input  wire [3:0]   axi_wstrb,
    output reg          axi_wready,
    
    output reg          axi_bvalid,
    output wire [1:0]   axi_bresp,
    input  wire         axi_bready,
    
    input  wire         axi_arvalid,
    input  wire [31:0]  axi_araddr,   
    output reg          axi_arready,
    
    output reg          axi_rvalid,
    output reg  [31:0]  axi_rdata,
    output wire [1:0]   axi_rresp,
    input  wire         axi_rready
);

    
    assign cpu_rresp = 2'b00;
    assign axi_rresp = 2'b00;
    assign axi_bresp = 2'b00;

    
    reg          sram_cen;
    reg          sram_wen;
    reg  [3:0]   sram_bwen;
    reg  [13:0]  sram_addr;
    reg  [31:0]  sram_wdata;
    wire [31:0]  sram_rdata;

    sram_sp_wrap #(
        .DEPTH (16384),
        .WIDTH (32)
    ) u_sram (
        .clk   (clk),
        .cen   (sram_cen),
        .wen   (sram_wen),
        .bwen  (sram_bwen),
        .addr  (sram_addr),
        .wdata (sram_wdata),
        .rdata (sram_rdata)
    );

    
    reg          wr_aw_done;   
    reg          wr_w_done;    
    reg  [13:0]  wr_addr;      
    reg  [31:0]  wr_wdata;     
    reg  [3:0]   wr_wstrb;     

    
    
    
    reg          cpu_rd_wait,  cpu_rd_pend;
    reg          axi_rd_wait,  axi_rd_pend;
    reg  [13:0]  cpu_rd_addr;  
    reg  [13:0]  axi_rd_addr;  

    
    wire do_wr      = wr_aw_done && wr_w_done;
    wire do_axi_rd  = axi_rd_wait && !do_wr;
    wire do_cpu_rd  = cpu_rd_wait && !do_wr && !axi_rd_wait;

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            
            sram_cen       <= 1'b0;
            sram_wen       <= 1'b0;
            sram_bwen      <= 4'h0;
            sram_addr      <= 14'h0;
            sram_wdata     <= 32'h0;
            
            cpu_arready    <= 1'b0;
            cpu_rvalid     <= 1'b0;
            cpu_rdata      <= 32'h0;
            cpu_rd_wait    <= 1'b0;
            cpu_rd_pend    <= 1'b0;
            cpu_rd_addr    <= 14'h0;
            
            axi_awready    <= 1'b0;
            axi_wready     <= 1'b0;
            axi_bvalid     <= 1'b0;
            wr_aw_done     <= 1'b0;
            wr_w_done      <= 1'b0;
            wr_addr        <= 14'h0;
            wr_wdata       <= 32'h0;
            wr_wstrb       <= 4'h0;
            
            axi_arready    <= 1'b0;
            axi_rvalid     <= 1'b0;
            axi_rdata      <= 32'h0;
            axi_rd_wait    <= 1'b0;
            axi_rd_pend    <= 1'b0;
            axi_rd_addr    <= 14'h0;
        end else begin
            
            cpu_arready <= 1'b0;
            axi_awready <= 1'b0;
            axi_wready  <= 1'b0;
            axi_arready <= 1'b0;
            sram_cen    <= 1'b0;     

            
            if (axi_awvalid && !wr_aw_done) begin
                axi_awready <= 1'b1;
                wr_aw_done  <= 1'b1;
                wr_addr     <= axi_awaddr[15:2];
            end

            
            if (axi_wvalid && !wr_w_done) begin
                axi_wready <= 1'b1;
                wr_w_done  <= 1'b1;
                wr_wdata   <= axi_wdata;
                wr_wstrb   <= axi_wstrb;
            end

            
            if (cpu_arvalid && !cpu_rd_wait && !cpu_rd_pend) begin
                cpu_arready <= 1'b1;
                cpu_rd_wait <= 1'b1;
                cpu_rd_addr <= cpu_araddr[15:2];   
            end

            
            if (axi_arvalid && !axi_rd_wait && !axi_rd_pend) begin
                axi_arready <= 1'b1;
                axi_rd_wait <= 1'b1;
                axi_rd_addr <= axi_araddr[15:2];   
            end

            
            if (do_wr) begin
                
                
                
                sram_cen   <= 1'b1;
                sram_wen   <= 1'b1;
                sram_bwen  <= wr_wstrb;
                sram_addr  <= wr_addr;
                sram_wdata <= wr_wdata;
                wr_aw_done <= 1'b0;
                wr_w_done  <= 1'b0;
                axi_bvalid <= 1'b1;   

            end else if (do_axi_rd) begin
                
                sram_cen      <= 1'b1;
                sram_wen      <= 1'b0;
                sram_bwen     <= 4'hF;
                sram_addr     <= axi_rd_addr;
                axi_rd_wait   <= 1'b0;
                axi_rd_pend   <= 1'b1;   

            end else if (do_cpu_rd) begin
                
                sram_cen      <= 1'b1;
                sram_wen      <= 1'b0;
                sram_bwen     <= 4'hF;
                sram_addr     <= cpu_rd_addr;
                cpu_rd_wait   <= 1'b0;
                cpu_rd_pend   <= 1'b1;   
            end

            
            if (axi_rd_pend) begin
                axi_rvalid  <= 1'b1;
                axi_rdata   <= sram_rdata;   
                axi_rd_pend <= 1'b0;
            end
            if (axi_rvalid && axi_rready)
                axi_rvalid <= 1'b0;

            
            if (cpu_rd_pend) begin
                cpu_rvalid  <= 1'b1;
                cpu_rdata   <= sram_rdata;   
                cpu_rd_pend <= 1'b0;
            end
            if (cpu_rvalid && cpu_rready)
                cpu_rvalid <= 1'b0;

            
            if (axi_bvalid && axi_bready)
                axi_bvalid <= 1'b0;
        end
    end

endmodule
