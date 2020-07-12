`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/05 08:40:17
// Design Name: 
// Module Name: mux32
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


module mux32(
    input sel,
    input [31:0] in1,
    input [31:0] in0,
    output [31:0] out
    );
    
    assign out =sel?in1:in0;
    
endmodule
