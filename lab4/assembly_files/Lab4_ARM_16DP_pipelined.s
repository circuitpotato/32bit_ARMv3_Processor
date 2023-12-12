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
;Loop Main Branch Until SW0 on -> Use recorded switch value for operation	
		;REGISTERS FOR SWITCH CHECK AND 16 DP INSTRUCTION LOADED
		LDR R10, Calc_val1		;R10 = 0x0000000A
		LDR R11, Calc_val2		;R11 = 0x00000008
		LDR R7, ZERO 			;R7 = 0x00000000
		LDR R8, ONE				;R8 = 0x00000001 
		LDR R9, THREE			;R9 = 0x00000003
		LDR R4, SEVENSEG		;R4 = 0x00000C18
		LDR R5, DIPS			;R5 = 0x00000C04
		
		
MAIN
		STR R7, [R4]				;Fill 7Seg with 0's -> Configure switch for operation then flip SW0
		LDR R2, [R5]				;Check DIPS STATUS for Instruction -> initial is 0x00000000
		;AND R3, R2, R8				;It checks SW0 on
		CMP R2, R7
		BNE MAIN
		
		
		;AND
		AND R1, R10, R11			;0x0000000A AND 0x00000008
		STR R1, [R4]				;7seg = 0x00000008
		
		;EOR
		EOR R1, R10, R11			;0x0000000A EOR 0x00000008
		STR R1, [R4]				;7seg = 0x00000002
		
		;SUB
		SUB R1, R10, R9				;0x0000000A SUB 0x00000003
		STR R1, [R4]				;7seg = 0x00000007
		
		;RSB
		RSB R1, R10, R11			;0x0000000A RSB 0x00000008
		STR R1, [R4]				;7seg = 0xFFFFFFFE

		;ADD
		ADD R1, R10, R11			;0x0000000A ADD 0x00000008
		STR R1, [R4]				;7seg = 0x00000012
		
		;ADC
		LDR R2, End_7seg			;R2 = 0xFFFFFFFF
		ADDS R1, R2, R8				;Raise Carry Flag
		ADC R1, R10, R11			;0x0000000A ADD 0x00000008 + 0x00000001
		STR R1, [R4]				;7seg = 0x00000013
		
		;SBC
		ADDS R1, R2, R7				;reset carry = 0
		SBC R1, R10, R11			;0x0000000A SUB 0x00000008 - 0x00000001 i
		STR R1, [R4]				;7seg = 0x00000001
		
		;RSC
		ADDS R1, R2, R7				;reset carry = 0 
		RSC R1, R10, R11			;0x00000008 SUB 0x0000000A - 0x00000001 (not Carry Flag = not 0 = 1)
		STR R1, [R4]				;7seg = 0xFFFFFFFD
		
		;TST
		TST R2, R7					;0xFFFFFFFF AND 0x00000000	= 0x00000000
		BEQ TST_FLAGUP

TST_FLAGUP
		STR R4, [R4]				;7seg = 0x00000C18	JUST TO SHOW IT BRANCHED
		
		;TEQ
		TEQ R2, R2					;0xFFFFFFFF XOR 0xFFFFFFFF	= 0x00000000
		BEQ TEQ_FLAGUP

TEQ_FLAGUP
		STR R5, [R4]				;7seg = 0x00000C04	JUST TO SHOW IT BRANCHED
		
		;CMP
		CMP R2, R2					;0xFFFFFFFF SUB 0xFFFFFFFF	= 0x00000000
		BEQ CMP_FLAGUP
		
CMP_FLAGUP
		STR R4, [R4]				;7seg = 0x00000C18	JUST TO SHOW IT BRANCHED

		;CMN
		CMN R2, R7					;C FLAG IS NOT RAISE
		BCC CMN_FLAGUP

CMN_FLAGUP
		STR R5, [R4]				;7seg = 0x00000C04	JUST TO SHOW IT BRANCHED
		
		;ORR
		ORR R1, R10, R11			;0x0000000A ORR 0x00000008
		STR R1, [R4]				;7seg = 0x0000000A
		
		;MOV
		MOV R1, R8					;MOVE 0X00000001 TO R1
		STR R1, [R4]				;7seg = 0x00000001
		
		;BIC
		BIC R1, R2, R8				;BIT CLEAR 1 FIRST BIT OF 0xFFFFFFFF
		STR R1, [R4]				;7seg = 0xFFFFFFFE
		
		;MVN
		MVN R1, R10					;NOT A MOVE TO R1
		STR R1, [R4]				;7seg = 0xFFFFFFF5
		
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
FIVE
		DCD 0x00000005		;CONSTANT 5
SEVEN
		DCD 0x00000007      ;CONSTANT 7
NINE
		DCD 0X00000009		;CONSTANT 9
Calc_val1
		DCD 0x0000000A

Calc_val2
		DCD 0x00000008		
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
