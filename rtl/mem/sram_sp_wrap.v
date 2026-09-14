

`timescale 1ns / 1ps

module sram_sp_wrap #(
    parameter DEPTH = 16384,   
    parameter WIDTH = 32       
)(
    input  wire              clk,
    input  wire              cen,    
    input  wire              wen,    
    input  wire [3:0]        bwen,   
    input  wire [13:0]       addr,
    input  wire [31:0]       wdata,
    output reg  [31:0]       rdata
);

`ifdef HARD_MACRO
    
    
    
    
    
    
    
    wire [31:0] bweb_n;
    assign bweb_n = { {8{~bwen[3]}}, {8{~bwen[2]}},
                      {8{~bwen[1]}}, {8{~bwen[0]}} };

    
    
    
    
    

    TS1N28HPCPSVTB16384X32M8SW u_sram_macro (
        .CLK   ( clk    ),
        .CEB   (~cen    ),   
        .WEB   (~wen    ),   
        .BWEB  ( bweb_n ),   
        .A     ( addr   ),   
        .D     ( wdata  ),   
        .Q     ( rdata  ),   
        
        .RTSEL ( 2'b01  ),   
        .WTSEL ( 2'b01  )    
    );

`else
    
    
    
    reg [WIDTH-1:0] mem [0:DEPTH-1];

    always @(posedge clk) begin
        if (cen) begin
            if (wen) begin
                
                if (bwen[0]) mem[addr][ 7: 0] <= wdata[ 7: 0];
                if (bwen[1]) mem[addr][15: 8] <= wdata[15: 8];
                if (bwen[2]) mem[addr][23:16] <= wdata[23:16];
                if (bwen[3]) mem[addr][31:24] <= wdata[31:24];
            end else begin
                rdata <= mem[addr];
            end
        end
    end

`endif

endmodule
