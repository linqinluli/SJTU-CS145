`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/05 21:28:56
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
    reg clk,reset;
    
    always #50 clk=!clk;
    
    top top(.clk(clk),.reset(reset));
    initial begin
$readmemh("data.txt", top.dataMem.memFile);
$readmemb("code.txt", top.instMem.instFile);
    clk = 1;
    reset = 1;
    #25
    reset = 0;
    #2000;
end
    
endmodule
