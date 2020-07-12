`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/05/24 08:50:42
// Design Name: 
// Module Name: ALUCtr_tb
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


module ALUCtr_tb(

    );


wire [3:0] ALUCtrOut;
reg [5:0] Funct;
reg [1:0] ALUOp;
ALUCtr u0(
    .aluop(ALUOp),
    .funct(Funct),
    .aluctrout(ALUCtrOut));
initial begin
    ALUOp=2'b00;
    Funct=6'b000000;
    #160
    ALUOp=2'b01;
    #60
    ALUOp=2'b10;
    #60
    Funct=6'b000010;
    #60
    Funct=6'b00100;
    #60
    Funct=6'b000101;
    #60
    Funct=6'b001010;
    end
    
endmodule
