`timescale 1ns / 1ps
/*
----------------------------------------------------------------------------------
-- Company: NUS	
-- Engineer: (c) Shahzor Ahmad and Rajesh Panicker  
-- 
-- Create Date: 09/23/2015 06:49:10 PM
-- Module Name: ARM
-- Project Name: CG3207 Project
-- Target Devices: Nexys 4 (Artix 7 100T)
-- Tool Versions: Vivado 2015.2
-- Description: ARM Module
-- 
-- Dependencies: NIL
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments: The interface SHOULD NOT be modified. The implementation can be modified
-- 
----------------------------------------------------------------------------------

----------------------------------------------------------------------------------
--	License terms :
--	You are free to use this code as long as you
--		(i) DO NOT post it on any public repository;
--		(ii) use it only for educational purposes;
--		(iii) accept the responsibility to ensure that your implementation does not violate any intellectual property of ARM Holdings or other entities.
--		(iv) accept that the program is provided "as is" without warranty of any kind or assurance regarding its suitability for any particular purpose;
--		(v)	acknowledge that the program was written based on the microarchitecture described in the book Digital Design and Computer Architecture, ARM Edition by Harris and Harris;
--		(vi) send an email to rajesh.panicker@ieee.org briefly mentioning its use (except when used for the course CG3207 at the National University of Singapore);
--		(vii) retain this notice in this file or any files derived from this.
----------------------------------------------------------------------------------
*/

//-- R15 is not stored
//-- Save waveform file and add it to the project
//-- Reset and launch simulation if you add interal signals to the waveform window
// Instruction mem is external
// Data mem is external


module ARM(
    input CLK,
    input RESET,
    //input Interrupt,  // for optional future use
    input [31:0] InstrF,
    input [31:0] ReadData,
    output reg MemWriteM,
    output [31:0] PCF,
    output reg [31:0] ALUResultM,
    output [31:0] WriteData
    );
    
    reg [31:0] InstrD;
	reg[31:0] RD1E;
	wire [31:0] ResultW;
	wire [31:0] PC_Prev;
    
    // RegFile 
    wire WE3 ;
    wire [31:0] WD3 ;
    wire [31:0] R15 ;
    wire [31:0] RD1D ;
    wire [31:0] RD2D ;
    
    // Extend 
    wire [1:0] ImmSrc ;
    wire [23:0] InstrImm ;
    wire [31:0] ExtImmD ;
    
    // Decoder 
    wire [3:0] Rd ;
    wire [1:0] Op ;
    wire [5:0] Funct ;
    wire MemtoRegD ;
    wire ALUSrcD ;
    wire [1:0] RegSrcD ;
    
    // CondLogic 
    wire PCSD ;
    wire RegWD ;
    wire NoWriteD ;
    wire MemWD ;
    wire [1:0] FlagWD ;
    wire [3:0] CondD ;
    wire C_Flag ;

       
    // Shifter 
    wire [1:0] ShD ;
    reg [1:0] ShE;
    wire [4:0] Shamt5D ;
    wire [31:0] ShIn ;
    wire [31:0] ShOut ;
    
    
    // ALU 
    wire [3:0] ALUControlD ;
    wire [3:0] ALUFlags ;
    
    // ProgramCounter 
    wire WE_PC ;    
    wire [31:0] PC_IN ;
        
    

    
    // D to E
    reg PCSE = 1'b0;
    reg RegWE = 1'b0;
    reg MemWE = 1'b0;
    reg [1:0] FlagWE = 1'b0;
    reg NoWriteE = 1'b0;
    reg [3:0] ALUControlE = 1'b0;
    reg MemtoRegE = 1'b0;
    reg ALUSrcE = 1'b0;
    reg [3:0] CondE = 1'b0;
    //reg [31:0] RD1E = 1'b0;
    reg [31:0] RD2E = 1'b0;
    reg [3:0] WA3E = 1'b0;
    reg [31:0] ExtImmE = 1'b0;
    reg [4:0] Shamt5E = 1'b0;
    wire RegWriteE;
    wire MemWriteE;
    wire FlushE;
    wire [31:0] SrcAE;
    wire [31:0] SrcBE;
    wire [1:0] ForwardAE;
    wire [1:0] ForwardBE;
    wire [31:0] WriteDataE;
    wire [31:0] ALUResultE;    
    wire PCSrcE;

    // E to M
    reg PCSrcM = 1'b0;
    reg RegWriteM = 1'b0;
    reg MemtoRegM = 1'b0;
    reg [3:0] WA3M = 1'b0;
    reg [31:0] WriteDataM = 1'b0;
    wire ForwardM;

    // M to W
    reg PCSrcW = 1'b0;
    reg RegWriteW = 1'b0;
    reg MemtoRegW = 1'b0;
    reg [31:0] ReadDataW = 1'b0;
    reg [31:0] ALUResultW = 1'b0;
    reg [3:0] WA3W = 1'b0;

    // Pipelining
    wire StallF;
    
    // F to D
    wire FlushD;
    wire StallD;
    
    
    // Branch Prediction   
    reg [31:0] PCD = 1'b0;
    reg [31:0] PCE = 1'b0;
    
    wire [31:0] PCPlus4F;
    reg [31:0] PCPlus4D = 1'b0;
    reg [31:0] PCPlus4E = 1'b0;
    
    wire WE_PrALUResult;
    wire WE_PrPCSrc;

    reg BranchAcceptD = 1'b0;
    wire [3:0] RA1D;
    wire [3:0] RA2D;
    reg [3:0] RA1E = 1'b0;
    reg [3:0] RA2E = 1'b0;
    reg [3:0] RA2M = 1'b0;
    wire FlushD_H;
    wire FlushE_H;
    
    // Fetch to Decode  
    always @ (posedge CLK) begin
        if (FlushD) begin
            InstrD <= 1'b0;
            PCD <= 1'b0;
            PCPlus4D <= 1'b0;
            
        end
        else if (!StallD) begin
            InstrD <= InstrF;
            PCD <= PCF;
            PCPlus4D <= PCPlus4F;
            
        end
    end 
    
    
    // Decode to Execute  
    always @ (posedge CLK) begin
        if (FlushE) begin
            
            PCSE <= 1'b0;
            RegWE <= 1'b0;
            MemWE <= 1'b0;
            FlagWE <= 1'b0;
            NoWriteE <= 1'b0;
            ALUControlE <= 1'b0;
            MemtoRegE <= 1'b0;
            ALUSrcE <= 1'b0;
            CondE <= 1'b0;
            ShE <= 1'b0;
            RD1E <= 1'b0;
            RD2E <= 1'b0;
            WA3E <= 1'b0;
            ExtImmE <= 1'b0;
            RA1E <= 1'b0;
            RA2E <= 1'b0;
            Shamt5E <= 1'b0;
            PCE <= 1'b0;
            PCPlus4E <= 1'b0;
        end
        else begin    
            ShE <= ShD;
            PCSE <= PCSD;
            RegWE <= RegWD;
            MemWE <= MemWD;
            FlagWE <= FlagWD;
            NoWriteE <= NoWriteD;
            ALUControlE <= ALUControlD;
            MemtoRegE <= MemtoRegD;
            ALUSrcE <= ALUSrcD;
            CondE <= CondD;
            RD1E <= RD1D;
            RD2E <= RD2D;
            WA3E <= InstrD[15:12];
            ExtImmE <= ExtImmD;
            RA1E <= RA1D;
            RA2E <= RA2D;
            Shamt5E <= Shamt5D;
            PCE <= PCD;
            PCPlus4E <= PCPlus4D;
        end
    end
    
    // forwarding
    assign SrcAE = 
        ForwardAE == 2'b00 ? RD1E:
        ForwardAE == 2'b01 ? ResultW:
        ForwardAE == 2'b10 ? ALUResultM:
        1'b0;
            
    assign ShIn = 
        ForwardBE == 2'b00 ? RD2E:
        ForwardBE == 2'b01 ? ResultW:
        ForwardBE == 2'b10 ? ALUResultM:
        1'b0;
    
    assign WriteDataE = ShOut;
    
    assign SrcBE = 
        ALUSrcE == 1'b0 ? WriteDataE: 
        ExtImmE;
    
    // Extend
    assign InstrImm = InstrD[23:0];
    
    // Shifter
    assign Shamt5D = InstrD[11:7]; 
    assign ShD = InstrD[6:5];
   
    // Execute to Memory
    always @ (posedge CLK) begin
        // PCSrcM <= PCSrcE;
        RegWriteM <= RegWriteE;
        MemWriteM <= MemWriteE;
        MemtoRegM <= MemtoRegE;
        ALUResultM <= ALUResultE;
        WriteDataM <= WriteDataE;
        WA3M <= WA3E;
        RA2M <= RA2E;

    end
    
    always @ (posedge CLK) begin
        RegWriteW <= RegWriteM;
        MemtoRegW <= MemtoRegM;
        ReadDataW <= ReadData;
        ALUResultW <= ALUResultM;
        WA3W <= WA3M;
    end
    
    assign ResultW = (MemtoRegW == 1'b1) ? ReadDataW : ALUResultW;
    
    // datapath connections here
    assign WE_PC = !StallF ; // Will need to control it for multi-cycle operations (Multiplication, Division) and/or Pipelining with hazard hardware.


    
    // Instantiate RegFile
    RegFile RegFile1( 
                    CLK,
                    WE3,
                    RA1D,
                    RA2D,
                    WA3W,
                    WD3,
                    R15,
                    RD1D,
                    RD2D     
                );
                
     // Instantiate Extend Module
    Extend Extend1(
                    ImmSrc,
                    InstrImm,
                    ExtImmD
                );
                
    // Instantiate Decoder
    Decoder Decoder1(
                    Rd,
                    Op,
                    Funct,
                    PCSD,
                    RegWD,
                    MemWD,
                    MemtoRegD,
                    ALUSrcD,
                    ImmSrc,
                    RegSrcD,
                    NoWriteD,
                    ALUControlD,
                    FlagWD
                );
                                
    // Instantiate CondLogic
    CondLogic CondLogic1(
                    CLK,
                    PCSE,
                    RegWE,
                    NoWriteE,
                    MemWE,
                    FlagWE,
                    CondE,
                    ALUFlags,
                    C_Flag,
                    PCSrcE,
                    RegWriteE,
                    MemWriteE
                );
                
    // Instantiate Shifter        
    Shifter Shifter1(
                    ShE,
                    Shamt5E,
                    ShIn,
                    ShOut
                );
                
    // Instantiate ALU        
    ALU ALU1(
                    SrcAE,
                    SrcBE,
                    ALUControlE,
                    C_Flag,
                    ALUResultE,
                    ALUFlags
                );           

    hazard_logic hazard_logic1(
                    RA1E,
                    RA2E,
                    RA1D,
                    RA2D,
                    WA3E,
                    MemtoRegE,
                    RegWriteE,
                    RegWriteM,
                    RegWriteW,
                    WA3M,
                    WA3W,
                    RA2M,
                    MemWriteM,
                    MemtoRegW,
                    PCSrcE,
                    //added
                    MemtoRegD,
                    FlushD_H,
                    StallF,
                    StallD,
                    FlushE_H,
                    ForwardAE,
                    ForwardBE,
                    ForwardM
    );
    
                
    assign PCPlus4F = PCF + 3'b100;
    // assign PCPlus8 = PCPlus4F + 3'b100;
    
    // Instantiate ProgramCounter    
    ProgramCounter ProgramCounter1(
                    CLK,
                    RESET,
                    WE_PC,    
                    PC_IN,
                    PCF  
                );                      
                
    // Control Unit 
    assign CondD = InstrD[31:28];
    assign Op = InstrD[27:26];
    assign Funct = InstrD[25:20];
    assign Rd = InstrD[15:12];
    
    // Register File
    assign RA1D = RegSrcD[0] == 1'b0 ? InstrD[19:16] : 4'b1111;
    assign RA2D = RegSrcD[1] == 1'b0 ? InstrD[3:0] : InstrD[15:12];
    assign WD3 = ResultW;
    assign WE3 = RegWriteW;
    assign R15 = (BranchAcceptD) ? PCPlus4D + 3'b100 : PCPlus4F;
    
    assign WriteData = 
        ForwardM == 1'b0 ? WriteDataM :
        ForwardM == 1'b1 ? ResultW :
        1'bZ;   

    assign FlushD = FlushD_H;
    assign FlushE = FlushE_H;
            

    assign PC_IN = (!PCSrcE == 1'b0) ? ALUResultE : PCPlus4F ;
    assign PC_Prev = PC_IN;
endmodule

























