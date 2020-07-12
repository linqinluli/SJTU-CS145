`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/05/24 08:45:07
// Design Name: 
// Module Name: ALUCtr
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


module ALUCtr(
    input [1:0] aluop,
    input [5:0] funct,
    output reg [3:0] aluctrout
    );
    always @ (aluop or funct)
    begin
        casex({aluop,funct})
        8'b00xxxxxx:
        aluctrout=4'b0010;
        8'bx1xxxxxx:
        aluctrout=4'b0110;
        8'b1xxx0000:
        aluctrout=4'b0010;
        8'b1xxx0010:
        aluctrout=4'b0110;
        8'b1xxx0100:
        aluctrout=4'b0000;
        8'b1xxx0101:
        aluctrout=4'b0001;
        8'b1xxx1010:
        aluctrout=4'b0111;
      
    endcase
  end
endmodule
