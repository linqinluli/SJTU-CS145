`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/29 09:30:00
// Design Name: 
// Module Name: multi_top
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


module multi_top(
    input clk,
    input reset
    );
    

  // Pipeline stage registers
    // IF/ID
    reg [31:0] IFID_pc4, IFID_instr;
    wire [4:0] IFID_instrs = IFID_instr[25:21], IFID_instrt = IFID_instr[20:16],
        IFID_instrd = IFID_instr[15:11];
    wire BRANCH;
    
    // ID/EX
    reg [31:0] IDEX_readData1, IDEX_readData2, IDEX_immSext;
    reg [4:0] IDEX_instrRs, IDEX_instrRt, IDEX_instrRd;
    reg [8:0] IDEX_ctrl;
    wire [1:0] IDEX_aluop = IDEX_ctrl[7:6];
    wire IDEX_regdst = IDEX_ctrl[8], IDEX_ALUSRC= IDEX_ctrl[5], 
        IDEX_branch = IDEX_ctrl[4], IDEX_MEMREAD = IDEX_ctrl[3], 
        IDEX_MEMWRITE = IDEX_ctrl[2], IDEX_REGWRITE = IDEX_ctrl[1],
        IDEX_MEMTOREG = IDEX_ctrl[0];
        
    // EX/EM
    reg [31:0] EXMEM_aluRes, EXMEM_writeData;
    reg [4:0] EXMEM_dstReg;
    reg [4:0] EXMEM_ctrl;
    reg EXMEM_zero;
    wire EXMEM_branch = EXMEM_ctrl[4], EXMEM_memread = EXMEM_ctrl[3],
        EXMEM_memwrite = EXMEM_ctrl[2], EXMEM_regwrite = EXMEM_ctrl[1],
        EXMEM_memtoreg = EXMEM_ctrl[0];
        
    // MEM/WB
    reg [31:0] MEMWB_readData, MEMWB_aluRes;
    reg [4:0] MEMWB_dstReg;
    reg [1:0] MEMWB_ctrl;
    wire MEMWB_regwrite = MEMWB_ctrl[1], MEMWB_memtoreg = MEMWB_ctrl[0];
    
    // Hazard detection
    wire STALL = IDEX_MEMREAD & 
        (IDEX_instrRt == IFID_instrs | IDEX_instrRt == IFID_instrt);
    
    // Stage settings
    // Instruction Fetch Stage
    reg [31:0] PC;
    wire [31:0] PC_PLUS_4, BRANCH_addr, NEXT_PC, IF_inst;
    assign PC_PLUS_4 = PC + 1;
    mux32 nextPCmux(.in0(PC_PLUS_4), .in1(BRANCH_addr), .out(NEXT_PC),
        .sel(BRANCH));
    InstMemory instMem(.address(PC), .instruction(IF_inst));
    
    always @ (posedge clk)
    begin
        if (!STALL)
        begin
            IFID_pc4 <= PC_PLUS_4;
            IFID_instr <= IF_inst;
            PC <= NEXT_PC;
        end
        if (BRANCH)
            IFID_instr <= 0; // flush
    end
    
    // Decode Stage
    wire [8:0] CTRL_out;
    Ctr mainCtrl(.opCode(IFID_instr[31:26]), .regDst(CTRL_out[8]), 
        .aluOp(CTRL_out[7:6]), .aluSrc(CTRL_out[5]), .brance(CTRL_out[4]),
        .memRead(CTRL_out[3]), .memWrite(CTRL_out[2]), .regWrite(CTRL_out[1]),
        .memToReg(CTRL_out[0]));
    
    wire [31:0] READ_DATA_1, READ_DATA_2, REG_WRITE_DATA;
    Registers regs(.clk(clk), .readReg1(IFID_instrs), .readReg2(IFID_instrt), 
        .writeReg(MEMWB_dstReg), .writeData(REG_WRITE_DATA), 
        .regwrute(MEMWB_regwrite), .reset(reset), .readData1(READ_DATA_1), 
        .readData2(READ_DATA_2));
    
    wire [31:0] IMM_sext;
    signext sext(.inst(IFID_instr[15:0]), .data(IMM_sext));
    wire [31:0] IMM_sext_SHIFT = IMM_sext << 2;
    assign BRANCH_addr = IMM_sext_SHIFT + IFID_pc4;
    assign BRANCH = (READ_DATA_1 == READ_DATA_2) & CTRL_out[4];
    
    always @ (posedge clk)
    begin
        IDEX_ctrl <= STALL ? 0 : CTRL_out;
        IDEX_readData1 <= READ_DATA_1;
        IDEX_readData2 <= READ_DATA_2;
        IDEX_immSext <= IMM_sext;
        IDEX_instrRs <= IFID_instrs;
        IDEX_instrRt <= IFID_instrt;
        IDEX_instrRd <= IFID_instrd;
    end
    
    // Forwarding Unit
    wire FWD_EX_A = EXMEM_regwrite & EXMEM_dstReg != 0 & EXMEM_dstReg == IDEX_instrRs;
    wire FWD_EX_B = 
 EXMEM_regwrite & EXMEM_dstReg != 0 & EXMEM_dstReg == IDEX_instrRt;
    wire FWD_MEM_A = 
        MEMWB_regwrite & MEMWB_dstReg != 0 & 
        !(EXMEM_regwrite & EXMEM_dstReg != 0 & EXMEM_dstReg == IDEX_instrRs) &
        MEMWB_dstReg == IDEX_instrRs;
    wire FWD_MEM_B = 
        MEMWB_regwrite & MEMWB_dstReg != 0 & 
        !(EXMEM_regwrite & EXMEM_dstReg != 0 & EXMEM_dstReg == IDEX_instrRt) &
        MEMWB_dstReg == IDEX_instrRt;
        
    // Execution Stage
    wire [31:0] ALU_SRC_A = FWD_EX_A ? EXMEM_aluRes : 
        FWD_MEM_A ? REG_WRITE_DATA : IDEX_readData1;
    wire [31:0] ALU_SRC_B = IDEX_ALUSRC ? IDEX_immSext : FWD_EX_B ? EXMEM_aluRes :
        FWD_EX_B ? EXMEM_aluRes : FWD_MEM_B ? REG_WRITE_DATA : IDEX_readData2;
    wire [31:0] MEM_WRITE_DATA = FWD_EX_B ? EXMEM_aluRes :
        FWD_EX_B ? EXMEM_aluRes : FWD_MEM_B ? REG_WRITE_DATA : IDEX_readData2;
         
    wire [3:0] ALU_CTRL_out;
    ALUCtr aluCtr(.funct(IDEX_immSext[5:0]), .aluop(IDEX_aluop), 
        .aluctrout(ALU_CTRL_out));
    
    wire [31:0] ALU_RES;
    wire ZERO;
    ALU alu(.input1(ALU_SRC_A), .input2(ALU_SRC_B), .aluctr(ALU_CTRL_out), .zero(ZERO),
        .alures(ALU_RES));
        
    wire [4:0] DST_reg;
    mux5 dstRegmux(.in0(IDEX_instrRt), .in1(IDEX_instrRd), .sel(IDEX_regdst),
        .out(DST_reg));
        
    always @ (posedge clk)
    begin
        EXMEM_ctrl <= IDEX_ctrl[4:0];
        EXMEM_zero <= ZERO;
        EXMEM_aluRes <= ALU_RES;
        EXMEM_writeData <= MEM_WRITE_DATA;
        EXMEM_dstReg <= DST_reg;
    end
    
    // Memory Stage
    wire [31:0] MEM_READ_DATA;
    dataMemory dataMem(.clk(clk), .address(EXMEM_aluRes), 
        .writedata(EXMEM_writeData), .memread(EXMEM_memread), 
        .memwrite(EXMEM_memwrite), .readdata(MEM_READ_DATA));
        
    always @ (posedge clk)
    begin
        MEMWB_ctrl <= EXMEM_ctrl[1:0];
        MEMWB_readData <= MEM_READ_DATA;
        MEMWB_aluRes <= EXMEM_aluRes;
        MEMWB_dstReg <= EXMEM_dstReg;
    end
    
    // Write Back Stage
    mux32 writeDatamux(.in1(MEMWB_readData), .in0(MEMWB_aluRes), 
        .sel(MEMWB_memtoreg), .out(REG_WRITE_DATA));
        
    always @ (reset)
    begin
        PC = 0;
        IFID_pc4 = 0;
        IFID_instr = 0;
        IDEX_instrRs = 0;
        IDEX_readData1 = 0;
        IDEX_readData2 = 0;
        IDEX_immSext = 0;
        IDEX_instrRt = 0;
        IDEX_instrRd = 0;
        IDEX_ctrl = 0;
        EXMEM_aluRes = 0;
        EXMEM_writeData = 0;
        EXMEM_dstReg = 0;
        EXMEM_ctrl = 0;
        EXMEM_zero = 0;
        MEMWB_readData = 0;
        MEMWB_aluRes = 0;
        MEMWB_dstReg = 0;
        MEMWB_ctrl = 0;
    end
    
endmodule

