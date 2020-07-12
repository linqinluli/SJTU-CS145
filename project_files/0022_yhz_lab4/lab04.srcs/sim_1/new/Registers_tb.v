`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/05/31 08:47:06
// Design Name: 
// Module Name: Registers_tb
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


module Registers_tb(

    );
    reg clk;
    reg [25:21] readReg1;
    reg [20:16] readReg2;
    reg [4:0] writeReg;
    reg [31:0] writeData;
    reg regwrite;
    wire [31:0] readData1;
    wire [31:0] readData2;
    
    Registers registers(
    .clk(clk),
    .readReg1(readReg1),
    .readReg2(readReg2),
    .writeReg(writeReg),
    .writeData(writeData),
    .regwrute(regwrite),
    .readData1(readData1),
    .readData2(readData2)
    );
    
  
    always #100 
    clk=!clk;
    
    initial begin 
   
    clk = 0; 
    readReg1 = 0; 
    readReg2 = 0; 
    regwrite = 0; 
    writeReg = 0; 
    writeData = 0; 
    #100
    clk=0;
    #185; // 285 ns 
    regwrite = 1'b1; 
    writeReg = 5'b10101; 
    writeData = 32'b11111111111111110000000000000000;
    #200; // 485 ns 
    writeReg = 5'b01010; 
    writeData = 32'b0000000000000001111111111111111; 
    #200 // 685 ns
    regwrite = 1'b0; 
    writeReg = 5'b00000; 
    writeData = 32'b000000000000000000000000000000; 
    #50; // 735 ns 
    readReg1 = 5'b10101; 
    readReg2 = 5'b01010;
     end
endmodule
