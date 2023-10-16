;----------------------------------------------------------------------------------
;--	License terms :
;--	You are free to use this code as long as you
;--		(i) DO NOT post it on any public repository;
;--		(ii) use it only for educational purposes;
;--		(iii) accept the responsibility to ensure that your implementation does not violate any intellectual property of ARM Holdings or other entities.
;--		(iv) accept that the program is provided "as is" without warranty of any kind or assurance regarding its suitability for any particular purpose;
;--		(v) send an email to rajesh.panicker@ieee.org briefly mentioning its use (except when used for the course CG3207 at the National University of Singapore);
;--		(vi) retain this notice in this file or any files derived from this.
;----------------------------------------------------------------------------------

;Instructions to be executed: 
;LDR, STR [one needs immediate positive offset] + [Support negative immediate offset]
;AND, ORR, ADD, SUB [Src2 is register or immediate shift] + [Src2 support register for immediate shifts LSL,LSR,ASR,ROR]
;B
;CMP,CMN 

	AREA    MYCODE, CODE, READONLY, ALIGN=9 ; 2^9 = 512 bytes (enough space for 128 words). Each section is aligned to an address divisible by 512.
   	  ENTRY
	
; ------- <code memory (ROM mapped to Instruction Memory) begins>
; Total number of instructions should not exceed 127 (126 excluding the last line 'halt B halt').
		
		LDR R10, Calc_val1		;R10 = 0xFFFFEEEE
		LDR R11, Calc_val2		;R11 = 0x0000000A
		LDR R6, F_Mask			;R6 = 0x0000000F
		LDR R7, ZERO 			;R7 = 0x00000000
		LDR R8, ONE				;R8 = 0x00000001 
		LDR R9, THREE			;R9 = 0x00000003
		LDR R4, SEVENSEG		;R1 = 0x00000C18
		LDR R5, DIPS			;R0 = 0x00000C04
		
;Loop Main Branch Until SW0 on -> Use recorded switch value for operation
MAIN		
		STR R7, [R4]				;Fill 7Seg with 0's -> Configure switch for calculations then flip SW0
		LDR R2, [R5]				;Check DIPS STATUS for Instruction -> initial is 0x00000000
		AND R3, R2, R8				;No LSR needed for this status check because It checks SW0 on
		CMP R3, R8
		BNE MAIN
		
		LSR R1, R2, #14				;Shift SW14 and SW15 to LSB
		AND R3, R1, R9
		CMP R3, R9					;Check SW14 and SW15 On at same time
		BEQ Illegal_Op
		
		LSR R1, R2, #14				;Shift SW14 For 32-Bit Mul Check
		AND R3, R1, R8
		CMP R3, R8					;Check SW14 if On (1 - 32-Bit Mul)
		BEQ ThirtyTwoBitMul
		
		LSR R1, R2, #15				;Shift SW15 For 32-Bit Div Check
		AND R3, R1, R8
		CMP R3, R8					;Check SW15 if On (1 - 32-Bit Div)
		BEQ ThirtyTwoBitDiv
		
		LSR R1, R2, #2				;Checking SW2 For Mul or Div
		AND R3, R1, R8
		CMP R3, R8					;Check SW2 if On (1 - DIV)
		BEQ FourBitDiv
		BNE FourBitMul

ThirtyTwoBitMul
		MUL R1, R10, R11			;Multiply: FFFFEEEE * 0000000A
		STR R1, [R4]				;7seg = 0xFFFF554C
		B Reset
		
ThirtyTwoBitDiv
		MLA R1, R10, R11, R7		;Divide: FFFFEEEE * 0000000A
		STR R1, [R4]				;7seg = 0x199997E4
		B Reset

FourBitMul
		LSR R1, R2, #8				;Shift SW11 to SW8 to LSB - Operand 1
		AND R1, R6					;Make 4-bit Operand 0x0000(Operand1)
		LSR R12, R2, #4				;Shift SW7 to SW4 to LSB - Operand 2
		AND R12, R6					;Make 4-bit Operand 0x0000(Operand2)
		MUL R3, R1, R12				;Multiply and Store in R0
		STR R3, [R4]				;Display Result in 7seg
		B Reset

FourBitDiv
		LSR R1, R2, #8				;Shift SW11 to SW8 to LSB - Operand 1
		AND R1, R6					;Make 4-bit Operand 0x0000(Operand1)
		LSR R12, R2, #4				;Shift SW7 to SW4 to LSB - Operand 2
		AND R12, R6					;Make 4-bit Operand 0x0000(Operand2)
		MLA R3, R1, R12, R7			;Divide and Store in R0
		STR R3, [R4]				;Display Result in 7seg
		B Reset

Illegal_Op
		LDR R1, End_7seg
		STR R1, [R4]				;7seg = 0xFFFFFFFF
		B Reset

Reset
		LDR R1, RST					
		STR R1, [R4]				;7seg = 0x0123ABCD
		LDR R2, [R5]				;Check DIPS for SW0 to turn off before resetting to Main
		AND R3, R2, R8				;No LSR needed for this status check because It checks SW0 on
		CMP R3, R7					;Check SW0 Status
		BNE Reset
		BEQ MAIN
		
		;If None Are Valid Configurations -> Go back to MAIN
		B MAIN
halt	
		B    halt           ; infinite loop to halt computation. // A program should not "terminate" without an operating system to return control to
							; good idea to keep halt B halt as the last line of your code. Not really necessary if your program loops infinitely though
; ------- <\code memory (ROM mapped to Instruction Memory) ends>

	AREA    CONSTANTS, DATA, READONLY, ALIGN=9 
; ------- <constant memory (ROM mapped to Data Memory) begins>
; All constants should be declared in this section. This section is read only (Only LDR, no STR).
; Total number of constants should not exceed 128 (124 excluding the 4 used for peripheral pointers).
; If a variable is accessed multiple times, it is better to store the address in a register and use it rather than load it repeatedly.





;Peripheral pointers
DIPS
		DCD 0x00000C04		; Address of DIP switches. //volatile unsigned int * const DIPS = (unsigned int*)0x00000C04;

LEDS 
		DCD 0x00000C00		; Address of LEDs. 

SEVENSEG 
		DCD 0x00000C18		; Address of 7-Segment LEDs. Optionally used in Lab 2 and later


; Rest of the constants should be declared below.
ONE
		DCD 0x00000001		; Bit Mask/Other uses
THREE
		DCD 0x00000003		; Bit Mask -> Last 4 Bits = 0011
ZERO
		DCD 0x00000000		; constant 0
F_Mask
		DCD 0x0000000F		; Bit Mask -> Last 4 Bits = 1111
Calc_val1
		DCD 0xFFFFEEEE

Calc_val2
		DCD 0x0000000A		
RST
		DCD 0x0123ABCD
End_7seg
		DCD 0xFFFFFFFF
		
; ------- <constant memory (ROM mapped to Data Memory) ends>	


	AREA   VARIABLES, DATA, READWRITE, ALIGN=9
; ------- <variable memory (RAM mapped to Data Memory) begins>
; All variables should be declared in this section. This section is read-write.
; Total number of variables should not exceed 128. 
; No initialization possible in this region. In other words, you should write to a location before you can read from it (i.e., write to a location using STR before reading using LDR).

variable1
		DCD 0x00000000		;  // unsigned int variable1;
; ------- <variable memory (RAM mapped to Data Memory) ends>	

		END	
		
;const int* x;         // x is a non-constant pointer to constant data
;int const* x;         // x is a non-constant pointer to constant data 
;int*const x;          // x is a constant pointer to non-constant data
		