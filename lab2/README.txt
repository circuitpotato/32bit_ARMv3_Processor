How to use:
1. Program FPGA board
2. Initial All DIP switches off
3. To start executing processes turn DIP Switch [0] on
4. Observe 7 Segment for results of various operations (To know results and what instructions are carried refer to assembly file comments)
5. Once FFFF FFFF is displayed, it can be indicated program has ended

Files Description
ARM_sample.s [EDITED FILE]: 
1. Load Registers with Values for calculation, CMP and DIPS address
 
2. Main loop to intitialise program, Load Reg with DIPS state, CMP with Zero from previosu reg, if not Equal proceed, else loop and check again

3. Once initialised, start with basic operations; ADD with src2 imm, STR with neg offset, SUB with src2 imm, STR with Imm [Results Displayed on 7 SEG]

4. Additional DP operations; SUB with src2 reg, ADD with imm shifts: LSL, LSR, ASR, ROR, AND, ORR [Results Displayed on 7 SEG]

5. CMP+CMN Operation; 
Using Z flag - CMP (BEQ) pass = 7seg:0xAAAAAAAA, CMP (BNE) pass = 7seg:0xBBBBBBBB
Using N flag - CMN (BMI) pass = 7seg:0xCCCCCCCC, CMN (BPL) pass = 7seg:0xDDDDDDDD
B to End_loop
B Exit in event that branch conditions 'fails' [7seg: 0xEEEEEEEE]

6. End_loop, delay countdown from 5 to 1, then proceeds to End_display

7. B End_display, 7seg:0xFFFFFFFF

ARM_sample.v:
Instructions and Data Constant Memory to be added into Wrapper.v

TOP_Nexys.vhd:
CLK_DIV_BITS value changed to 26 for 1Hz

Wrapper.v:
Instruction and Data Constant Memory added from Assembly HextoRom

ARM.v:
Connection of all modules in our system - RegFile, Extend, Decoder, CondLogic, Shifter, ALU, ProgramCounter

Decoder.vhd:
Decoding Logic of instruction for different operations - Besides basic operational functions, CMP & CMN, LDR/STR with negative & positive offsets are added

CondLogic.vhd:
Added logic for Instruction execution based on condition mnemonic and condition flags

test_Wrapper:
Simulation of instruction carried out our HDL single cycle processor
1. DIPS Switch all initial off
2. DIPS switch SW[0] = 1 to start processes
3. Instruction carried out in sequence, results to be oberved in 7 Segment

top.bit:
The bitstream file exported 