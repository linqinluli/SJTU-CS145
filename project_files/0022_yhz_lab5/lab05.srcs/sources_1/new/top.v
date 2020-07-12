`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/05 09:04:24
// Design Name: 
// Module Name: top
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


module top(
    input clk,
    input reset
    );
    //PC
    reg [31:0] PC;
    wire [31:0] INST;
    InstMemory instMem(.address(PC),.instruction(INST));
    
    //CTR
    wire REG_DST,JUMP,BRANCH,MEM_READ,MEM_TO_REG,MEM_WRITE,ALU_SRC,REG_WRITE;
    wire [1:0] ALU_OP;
    Ctr mainCtr(.opCode(INST[31:26]),.regDst(REG_DST),.jump(JUMP),.brance(BRANCH),
                .memRead(MEM_READ),.memToReg(MEM_TO_REG),.aluOp(ALU_OP),
                .memWrite(MEM_WRITE),.aluSrc(ALU_SRC),.regWrite(REG_WRITE));
                
    //REG
    wire [4:0] WRITE_REG;
    wire [31:0] READ_DATA_1,READ_DATA_2,REG_WRITE_DATA;
    mux5 writeRegMux(.sel(REG_DST),.in1(INST[15:11]),.in0(INST[20:16]),.out(WRITE_REG));
    Registers regs(.clk(clk),.readReg1(INST[25:21]),.readReg2(INST[20:16]),
                   .writeReg(WRITE_REG),.writeData(REG_WRITE_DATA),.reset(reset),
                   .regwrute(REG_WRITE),.readData1(READ_DATA_1),.readData2(READ_DATA_2));
                   
    //ALU
    wire [31:0] IMM_SEXT,ALU_SRC_B,ALU_RESULT;
    wire [3:0] ALU_CTR_OUT;
    wire ZERO;
    signext signext(.inst(INST[15:0]),.data(IMM_SEXT));
    ALUCtr aluCtr(.funct(INST[5:0]),.aluop(ALU_OP),.aluctrout(ALU_CTR_OUT));
    mux32 aluSrcMux(.sel(ALU_SRC),.in1(IMM_SEXT),.in0(READ_DATA_2),.out(ALU_SRC_B)); 
    ALU alu(.input1(READ_DATA_1),.input2(ALU_SRC_B),.aluctr(ALU_CTR_OUT),.zero(ZERO),.alures(ALU_RESULT));
    
    //data memory
    wire [31:0] MEM_READ_DATA;
    dataMemory dataMem(.clk(clk),.address(ALU_RESULT),.writedata(READ_DATA_2),
                        .memwrite(MEM_WRITE),.memread(MEM_READ),.readdata(MEM_READ_DATA)); 
    mux32 regwriteMux(.sel(MEM_TO_REG),.in1(MEM_READ_DATA),.in0(ALU_RESULT),
                        .out(REG_WRITE_DATA));  
                        
     //jump logic
     wire [31:0] PC_PLUS_4,BRANCH_ADDR,SEL_BRANCH_ADDR,JUMP_ADDR,NEXT_PC,SEXT_SHIFT;
     assign PC_PLUS_4=PC+1;
     assign JUMP_ADDR= {PC_PLUS_4[31:28], INST[25:0]<<2};
     assign SEXT_SHIFT=IMM_SEXT;
     assign BRANCH_ADDR=PC_PLUS_4+SEXT_SHIFT;
     mux32 brachchMux(.sel(BRANCH&ZERO),.in1(BRANCH_ADDR),.in0(PC_PLUS_4),
                       .out(SEL_BRANCH_ADDR));
     mux32 jumpMux(.sel(JUMP),.in1(JUMP_ADDR),.in0(SEL_BRANCH_ADDR),.out(NEXT_PC));
     
     always @ (posedge clk)
        begin
            if(reset)
                PC<=0;
            else
                PC<=NEXT_PC;
        end        
                                                              
endmodule
