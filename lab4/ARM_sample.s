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


		;R9,R10,R11 to hold values for DP operations
		LDR R9, Calc_val1		;R9 = 0x0000000A
		LDR R10, Calc_val2		;R10 = 0x00000008
		LDR R11, Calc_val3		;R11 = 0x80000000
		LDR R7, ZERO 			;R7 = 0x00000000
		
		LDR R5, DIPS			;R0 = 0x00000C04
main		
		LDR R2, [R5]			;Check DIPS STATUS if SW1 is flipped?
		CMP R2, R7
		BEQ main
		
;This branch showcases our processor's ability to: LDR/STR with Positive & Negative offset, DP Src2 imm operation 
;Basic_operations
		;LDR
		LDR R6, ZERO			;R6 = 0x00000000	;R6 init to 0
		LDR R8, Delay			;R8 = 0x00000005	;Reset Delay value when Looped back into this branch
		LDR R1, LEDS			;R1 = 0x00000C00
		;DP Src2 imm operation
		ADD R1, #0x1C			;R1 = 0x00000C1C
		;STR with Negative offset
		STR R9, [R1, #-4]		;7Seg = 0x0000000A
		;DP Src2 imm operation
		SUB R1, #8				;R1 = 0x00000C14
		;STR with Positive offset
		STR R10, [R1, #4]		;7Seg = 0x00000008	;looking at 0xC18 address which is 7seg addr
		
;DP_operations
		;Setting Up Registers for DP operations
		LDR R1, SEVENSEG		;R1 = 0x00000C18
		
		;DP Src2 Reg
		SUB R6, R9, R10
		STR R6, [R1]			;7seg = 0x00000002
		
		;DP Src2 Reg + imm shifts
		;LSL
		ADD R6, R9, R10, LSL #2
		STR R6, [R1] 			;7seg = 0x0000002A
		;LSR
		ADD R6, R9, R10, LSR #2
		STR R6, [R1]			;7seg = 0x0000000C
		;ASR
		ADD R6, R9, R11, ASR #2
		STR R6, [R1]			;7seg = 0xE000000A
		;ROR
		ADD R6, R9, R10, ROR #4	
		STR R6, [R1]			;7seg = 0x8000000A
		
		;AND 
		AND R6, R9, R10
		STR R6, [R1]			;7seg = 0x00000008
		
		;ORR
		ORR R6, R9, R10
		STR R6, [R1]			;7seg = 0x0000000A
		
		;EOR
		EOR R6, R9, R10			;7seg = 0x00000002
		STR R6, [R1]
		
		;RSB 
		RSB R6, R9, R10			;7seg = 0xFFFFFFFE
		STR R6, [R1]
	
		
		;ADC 
		ADC R6, R9, R10			;7seg = 0x00000013
		STR R6, [R1]
		
		;SBC
		SBC R6, R9, R10			;7seg = 0x00000002
		STR R6, [R1]
		
		;MOV
		MOV R6, R9		        ;7seg = 0x0000000A
		STR R6, [R1]

		;MVN
		MVN R6, R9				;7seg = 0xFFFFFFF5
		STR R6, [R1]

		;BIC
		BIC R6, R6, #0x1F 		;7seg = 0xFFFFFFE0
		STR R6, [R1]
		
		;RSC 
		RSC R6, R9, R10			;7seg = 0xFFFFFFFE
		STR R6, [R1]
		
		;TST
		TST R9, R7 
		BEQ TST_flagup
TST_flagup
		LDR R6, TST_flag
		STR R6, [R1]			;7seg = 0xDEDAAAAA

		;TEQ
		TEQ R9, R9 
		BEQ TEQ_flagup
TEQ_flagup
		LDR R6, TEQ_flag
		STR R6, [R1]			;7seg = 0xDADAAAAA
		
;CMP + CMN Operations
;Cmp_op1	;Using Z flag
		CMP R9, R9
		BEQ Cmp_flagup
		B Exit					; exit condition in case it fails --> just for completeness
Cmp_flagup
		LDR R6, Cmp_flag
		STR R6, [R1]			;7seg = 0xAAAAAAAA


;Cmp_op2	;Using Z flag
		CMP R9, R10
		BNE Cmp_flagdown		
		B Exit
Cmp_flagdown
		LDR R6, Cmp_noflag
		STR R6, [R1] 			;7seg = 0xBBBBBBBB

		
;Cmn_op1	;Using N flag
		CMN R9, R11
		BMI Cmn_flagup
		B Exit
Cmn_flagup
		LDR R6, Cmn_flag
		STR R6, [R1] 			;7seg = 0xCCCCCCCC
	
		
;Cmn_op2 ;Using N flag
		CMN R9, R10
		BPL Cmn_flagdown
		B Exit
Cmn_flagdown
		LDR R6, Cmn_noflag
		STR R6, [R1] 			;7seg = 0xDDDDDDDD
		B End_loop

;Delay loop to serve as countdown before restarting from top
End_loop
		STR R8, [R1]			;7seg = 0x0000000[5,4,3,2,1]
		;SUBS not uses, Combination of CMP + SUB to carry out SUBS function
		CMP R8, #1
		SUB R8, #1
		BNE End_loop
		
		B End_display

;If CMP or CMN does not meet desired flag conditions, which is not meant to, done for completeness	
Exit
		LDR R6, Exit_7seg
		STR R6, [R1]			;7seg = 0xEEEEEEEE
		B halt

End_display 
		LDR R6, End_7seg
		STR R6, [R1]			;7seg = 0xFFFFFFFF

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
ZERO
		DCD 0x00000000		; constant 0
ONE
		DCD 0x00000001		; constant 0
Calc_val1
		DCD 0x0000000A		;Value 1 for DP operations
Calc_val2
		DCD 0x00000008		;Value 2 for DP operations
Calc_val3
		DCD 0x80000000
TST_flag
		DCD 0xDEDAAAAA		;Indicate that TST Z flag raised
TEQ_flag
		DCD 0xDADAAAAA		;Indicate that TST Z flag raised
Cmp_flag
		DCD 0xAAAAAAAA		;Indicate that CMP Z flag raised
Cmp_noflag
		DCD 0xBBBBBBBB		;Indicate that CMP Z flag not raised
Cmn_flag
		DCD 0xCCCCCCCC		;Indicate that CMN V flag raised
Cmn_noflag
		DCD 0xDDDDDDDD		;Indicate that CMN V flag not raised
Delay
		DCD 0x00000005		;5 step delay
Exit_7seg
		DCD 0xEEEEEEEE
End_7seg
		DCD 0XFFFFFfFF
		
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
		
