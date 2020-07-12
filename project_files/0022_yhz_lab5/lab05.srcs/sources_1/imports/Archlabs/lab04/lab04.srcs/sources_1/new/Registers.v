`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/05/31 08:41:00
// Design Name: 
// Module Name: Registers
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


module Registers(
    input clk,
    input [25:21] readReg1,
    input [20:16] readReg2,
    input [4:0] writeReg,
    input [31:0] writeData,
    input regwrute,
    input reset,
    output reg [31:0] readData1,
    output reg [31:0] readData2
    );
    
    reg [31:0] regFile[0:31];
    reg [5:0] i;
    always @ (readReg1 or readReg2 or writeReg)
    begin
        if(readReg1)
            readData1=regFile[readReg1];
        else
            readData1=0;
        if(readReg2)
            readData2=regFile[readReg2];
        else
            readData2=0;     
    end
 always @ (negedge clk) 
    begin
        if (regwrute)
         regFile[writeReg] = writeData; 
         end   
  always @ (posedge clk)
    begin
        if(reset)
                begin
                    for(i=0;i<32;i=i+1)
                        regFile[i]<=0;
                end
         end
endmodule
