Load Registers with FIXED values
R10 = 0xFFFFFFFF, R11 = 0x0000000A, R7 = 0x00000000, R8 = 0x00000001, R9 = 0x00000011
R4 = 0x00000C18 (7Seg Address), R5 = 0x00000C04 (DIPS Address)

DIP Switches Configuration For Use:
SW0 - Triggers the calculation; Configure other switches for calculations FIRST then turn SW0 On, Computation DONE turn SW0 Off before calculation again
SW2 - MUL/DIV Op Signal: SW2; 0-MUL, 1-DIV	[KIV: SW1; 0-Signed, 1-Unsigned]
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

Keil Simulation
At memory 0xC04 Switch Configurations:
1. 1100 0000 0000 0001 = 0x0000C001 -> Should not execute anything as it is illegal
2. 1000 0000 0000 0001 = 0x00008001 -> 32 Bit Div -> Output = 0x19999999
3. 0100 0000 0000 0001 = 0x00004001 -> 32 Bit Mul -> Output = 0xFFFFFFF6
4. 0000 1010 0101 0001 = 0x00000A51 -> 4 Bit Mul -> Output = 0110010 = 0x00000032
5. 0000 1111 0101 0011 = 0x00000F53 -> 4 Bit Div -> Output = 0101 = 0x00000005