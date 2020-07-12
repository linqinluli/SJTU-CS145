`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/05/31 09:24:26
// Design Name: 
// Module Name: dataMemory
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


module dataMemory(
    input clk,
    input [31:0] address,
    input [31:0] writedata,
    input memwrite,
    input memread,
    output reg [31:0] readdata
    );
    
    reg [31:0] memFile[0:63];
    
    always @ (address)
        begin
            if(memread&&!memwrite)
                readdata=memFile[address];
            else
               readdata=0;
            end
            
    always @ (negedge clk)
    begin
        if(memwrite)
            memFile[address]=writedata;
    end
    
endmodule
