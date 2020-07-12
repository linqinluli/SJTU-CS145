`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/05/31 09:27:35
// Design Name: 
// Module Name: datamemory_tb
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


module datamemory_tb(

    );
    reg Clk; 
    reg [31:0] address; 
    reg [31:0] writeData; 
    reg memWrite; 
    reg memRead; 
    wire [31:0] readdata;
    
    dataMemory mem(
    .clk(Clk), 
    .address(address), 
    .writedata(writeData), 
    .memwrite(memWrite), 
    .memread(memRead),
    .readdata(readdata)); 
    always #100 
        Clk = !Clk; 
    initial begin // Initialization 
    Clk = 0; 
    address = 0; 
    writeData = 0; 
    memWrite = 0; 
    memRead = 0; 
    #185; // 185 ns 
    memWrite = 1'b1; 
    address = 7; 
    writeData = 32'he0000000; 
    #100; // 285 ns 
    address = 6;
     writeData = 32'hffffffff; 
     #185; 
     // 470 ns 
     memRead = 1'b1; 
     memWrite = 1'b0; 
     address = 7; 
     #80; // 550 ns 
     memWrite = 1'b1;
      address = 8; 
      writeData = 32'haaaaaaaa;
      
      #80;//630ns
      address=6;
      memWrite=1'b0;
      memRead=1'b1;
      end
endmodule
