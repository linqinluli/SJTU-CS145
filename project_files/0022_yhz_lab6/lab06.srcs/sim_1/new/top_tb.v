`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/29 14:56:27
// Design Name: 
// Module Name: top_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top_tb(

    );
    
        reg clk, reset;
    always #25 clk = !clk;
    
    multi_top top(.clk(clk), .reset(reset));
    
    initial begin
        $readmemb("code.txt", top.instMem.instFile);
        $readmemh("data.txt", top.dataMem.memFile);
        clk = 1;
        reset = 1;
        #25 reset = 0;
    end
endmodule
