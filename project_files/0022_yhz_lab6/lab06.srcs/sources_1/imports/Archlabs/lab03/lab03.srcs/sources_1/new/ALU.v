`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/05/24 10:16:33
// Design Name: 
// Module Name: ALU
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


module ALU(
    input [31:0] input1,
    input [31:0] input2,
    input [3:0] aluctr,
    output reg zero,
    output reg [31:0] alures
    );
    
    always @ (input1 or input2 or aluctr)
    begin
        if(aluctr==4'b0010)//add
            alures=input1+input2;
        else if(aluctr==4'b0110)//sub
        begin
            alures=input1-input2;
            if(alures==0)
                zero=1;
            else
                zero=0;
         end
         else if(aluctr==4'b0000)//and
            begin
            alures=input1&input2;
            if(alures==0)
                zero=1;
            else
                zero=0;
            end
         else if(aluctr==4'b0001)//or
            begin 
            alures=input1|input2;
            if(alures==0)
                zero=1;
            else
                zero=0;
                end
         else if(aluctr==4'b0111)//set on less than
         begin
               if(input1<input2)
                alures=1;
               else
               alures=0;
               if(alures==0)
                zero=1;
            else
                zero=0;           
         end
         else if(aluctr==4'b1100)//nor
         begin
            alures=~(input1|input2);
            if(alures==0)
                zero=1;
            else
                zero=0;
                end
    end
endmodule
