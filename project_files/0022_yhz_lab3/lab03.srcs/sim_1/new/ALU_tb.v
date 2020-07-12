`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/05/24 10:29:47
// Design Name: 
// Module Name: ALU_tb
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


module ALU_tb(

    );
 wire zero;
wire [31:0] alures;
reg [31:0] input1;
reg [31:0] input2;
reg [3:0] aluctr;

ALU u0(
    .input1(input1),
    .input2(input2),
    .aluctr(aluctr),
    .zero(zero),
    .alures(alures)
);
initial begin
    input1=0;
    input2=0;
    aluctr=0;
    #100
    input1=15;
    input2=10;
    #100
    aluctr=4'b0001;
    #100
    aluctr=4'b0010;
    #100
    aluctr=4'b0110;
    #100
    input1=10;
    input2=15;
    #100
    input1=15;
    input2=10;
    aluctr=4'b0111;
    #100
    input1=10;
    input2=15;
    #100
    input1=1;
    input2=1;
    aluctr=4'b1100;
    #100
    input1=16;
end
endmodule
