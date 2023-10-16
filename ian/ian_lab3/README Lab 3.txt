README FOR CODES THAT WERE EDITED FOR LAB 3

####################################################################
ARM_sample.s [INSTRUCTION FOR SIMPLE MULTIPLY/DIVIDE CALCULATOR]:
####################################################################
Load Registers with FIXED values
R10 = 0xFFFFEEEE, R11 = 0x0000000A, R7 = 0x00000000, R8 = 0x00000001, R9 = 0x00000011
R4 = 0x00000C18 (7Seg Address), R5 = 0x00000C04 (DIPS Address)

DIP Switches Configuration For Use:
SW0 - Triggers the calculation; Configure other switches for calculations FIRST then turn SW0 On, Computation DONE turn SW0 Off before calculation again
SW2 - MUL/DIV Op Signal: SW2; 0-MUL, 1-DIV	
SW11, SW10, SW9, SW8 - Operand 1; SW12 MSB, SW9 LSB
SW7, SW6, SW5, SW4 - Operand 2; SW7 MSB, SW4 LSB
SW14 - 32-Bit Mul
SW15 - 32-Bit Div

Instruction Flow:
1. Initialised Progam Load Registers with Fixed values

2. Enter MAIN Branch: 
Fill 7Segment with 0's, Check for DIP switch 0 ON
Once on proceed to check Switch Configuration for Desired Computation - 4-Bit Mul, 4-Bit Div, 32-Bit Mul, 32-Bit Div
Done by:
	1. First Checking if 32 Bit Operation Switches On if eith SW14 or SW15 On - system does not have to care about other SW configurations, If 	Both On the system will count it as Illegal Operation and Branch back to start of system. It will check SW14 for Mul then check SW15 for 	Div - Branch to desired 32-bit Operation -> Execute
	2. If not a 32-Bit Operation it will Check SW2 for 4-Bit Mul or Div - Branch to desired 4-Bit Operation -> Execute
	3. Once Operation Executed - Branch to Reset (7seg = 0123ABCD) -> SW0 -> Goes back to Main

Keil Simulation [Also Switch Configurations also done for Hardware Demonstration]
At memory 0xC04 Switch Configurations:
1. 1100 0000 0000 0001 = 0x0000C001 -> Should not execute anything as it is illegal
2. 1000 0000 0000 0001 = 0x00008001 -> 32 Bit Div -> Output = FFFFEEEE/0000000A = 0x199997E4
3. 0100 0000 0000 0001 = 0x00004001 -> 32 Bit Mul -> Output = FFFFEEEE*0000000A = 0xFFFF554C	
4. 0000 1010 0101 0001 = 0x00000A51 -> 4 Bit Mul -> Output = 0xA * 0x5 = 0x32
5. 0000 1111 0101 0101 = 0x00000F55 -> 4 Bit Div -> Output = 0xF / 0x5 = 0x4B

####################################################################
MCycle.v:
####################################################################
Added Divide Functionality
Upgraded Multiplier -> More efficient as it now looks at 2nd last and LSB before computation, initially was just LSB checked at every iteration

In the code, pre-processing is done when instruction was a signed operation and pre-processing not executed - pre-processing checks operand signs if it is negative value, convert to positive value for computation in the multiply/division block (negative flag is raised of operand was negative) -> Once computation is completed at the end, when processing results, we check for flag difference, if Negative flag is different for the operands it means that result would need to be converted go negative value

Multipication is carried out based MCycleOp[1] being 0, here it is similar to the sequential multiplier, however we have a combinational circuit that allows to check the 2nd last and the LSB for 0 or 1, by doing so, we are able to skip unnecessary computation if the LSB is 0. (Look ahead by 1 bit)

Division is carried out based on whether MCycleOp[1] being 1, here we carry our division by first checking if Op1 is less than Op2 (Dividend lesser than Divisor) - here Remainder does not change, Quotient is 0 (left shifted, a 0), only when Divisor is smaller will division actually take place - we take Remainder - Divisor, Store the above result into temp, Represent new 'Remainder' aka dividend, Quotient Shift left logic 1, continue to finish

Results as explained earlier

####################################################################
Arm.v
####################################################################
A1, A2, A3 Checks if it is MUL or MLA, if it is, interpret instruction for registers associated wit Op1 and Op2
Op1 and Op2 connected to RD ports
Result 1 is used Result2 Discarded
Check for Start - Whether to use Mul/Mla

####################################################################
Decoder 
####################################################################
Start will be 1 if Instr[7:4] = 1001 for Mul/Ml and OP = 00
MCycleOp logic to check Instr(21) if 1 is Divide, if 0 is Multiply