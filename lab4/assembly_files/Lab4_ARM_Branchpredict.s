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
		
			;BRANCH PREDICTION INSTRUCTIONS NOT MEANT FOR PHYSICAL - JUST WANT THE INSTRUCTION FOR HDL SIM
BRANCHPREDICT
		;LOAD REGISTERS FOR BRANCH PREDICTION INSTRUCTIONS
		LDR R1, NINE
		LDR R2, ZERO
		LDR R3, ONE
		LDR R4, SEVENSEG		;R4 = 0x00000C18
		
DOWHILE 
		; a do while loop
		STR R1, [R4]				;7seg
		SUBS R1, R1, R3;
		BNE DOWHILE				    ;BRANCH TO BRANCH5X 5 TIMES -BNE CHECK Z FLAG
		
		LDR R10, NINE;
		
		B SELECTBRANCH

WHILE
		; while loop 1
		STR R10, [R4]				;7seg
		SUBS R10, R10, R3				;CAUSES LOOP 10X TO THIS BRANCH
		
		
SELECTBRANCH
		BMI BRANCHPREDICT			;BRANCH BACK TO START WHEN NEGATIVE FLAG SET MEANS LOOPED 10X COMPLETE
		BPL WHILE				    ;BRANCH BACK TO BRACH10X TO CONTINUE THE LOOP - N FLAG NOT RAISED


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
