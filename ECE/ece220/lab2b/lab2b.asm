;number to print in decimal is in R3.
;it will be positive.
; ASSUMING NUMBER IS POSITIVE WHEN ENTERED INTO R3, THIS CODE WILL TAKE THE VALUE STORED IN R3, AND CONVERT IT FROM BAS16 (HEXADECIMAL) TO BASE 10
; (DECIMAL). FOR EXAMPLE HAVING A VALUE OF X0010 IN R3 WOULD BE PRINTED ON THE TERMINAL WINDOW AS 16. 
; R0----> HOLDS QUOTIENT AND USED FOR INPUT OUTPUT
; R1---> UNUSED BY MY CODE, POSSIBLY USED BY PUSH OR POP
; R2---> ^^^^^^^^^^
; R3----> ALSO HOLDS QUOTIENT AND SOMETIMES REMAINDER 
; R4 -----> HOLDS NEGATIVE 10 
; R5------> USED FOR UNDERFLOW/OVERFLOW INDICATOR 
; R6------> USED FOR MISCELLANEOUS ADDING 
.ORIG x3000
;;;;assuming value is already in R3;;;;
;			LD R3,THEORET   ; USED FOR THEORETICAL TESTING 
			ADD R3,R3,#0	; REFERNCE R3
			BRZ PRINT_ZERO  ; IF R3 IS ZERO JUST PRINT ZERO
			AND R1,R1,#0    ; CLEAR REGISTERS
			AND R6,R6,#0    ;
			AND R0,R0,#0    ; 
			JSR DIV        ; go to divide subroutine
FIVE		JSR POP        ;
			ADD R5,R5,#0   ; reference R5 
			BRP FINISH 
			LD  R6,ASCII_0 ; get offset 
			ADD R0,R6,R0   ; added r6 to offset  
			OUT            ; print to the screen
			BR FIVE        
FINISH		HALT    
PRINT_ZERO  LD R0,ASCII_0
			OUT 
			BR FINISH 

		












;THEORET .FILL x7888
ASCII_0 .FILL x30
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;input R3, R4
;out R0-quotient, R1-remainder
CDIV	AND R0,R0,#0      ; CLEAR R0
DIV		AND R4,R4,#0      ; CLEAR R0 
		ADD R4,R4,#-10    ; ADD -10 
		ADD R3,R3,R4      ; subtract 10 from r3
		BRN NEXT          ; IF ANSWER IS BELOW ZERO BRANCH
		ADD R0,R0,#1      ;increment quotient
		ADD R3,R3,#0      ;reference R3
		BRZ DOWN
		BR DIV 
NEXT    ADD R3,R3,#10   ; add ten back to R1 to find remainder
DOWN	ST R3,REMAINDER ; store remainder
		ST R0,QUOTIENT  ; store quotient 
		LD R0,REMAINDER ; LOAD R0 with remainder
		ST R7,STORE     ; PRESERVE R7
		JSR PUSH        ; PUSH VAL ON STACK
		LD R7,STORE     ; GET BACK R7
		LD R3,QUOTIENT  ; GET THE QUOTIENT AS THE NEW VAL TO DIVIDE BY
		BRP CDIV        ; do step one again  
REET 	RET



QUOTIENT  .FILL x0000
REMAINDER .FILL x0000
STORE     .FILL x0000


;IN:R0, OUT:R5 (0-success, 1-fail/overflow)
;R3: STACK_END R4: STACK_TOP
;
PUSH	
	ST R3, PUSH_SaveR3	;save R3
	ST R4, PUSH_SaveR4	;save R4
	AND R5, R5, #0		;
	LD R3, STACK_END	;
	LD R4, STACk_TOP	;
	ADD R3, R3, #-1		;
	NOT R3, R3		;
	ADD R3, R3, #1		;
	ADD R3, R3, R4		;
	BRz OVERFLOW		;stack is full
	STR R0, R4, #0		;no overflow, store value in the stack
	ADD R4, R4, #-1		;move top of the stack
	ST R4, STACK_TOP	;store top of stack pointer
	BRnzp DONE_PUSH		;
OVERFLOW
	ADD R5, R5, #1		;
DONE_PUSH
	LD R3, PUSH_SaveR3	;
	LD R4, PUSH_SaveR4	;
	RET


PUSH_SaveR3	.BLKW #1	;
PUSH_SaveR4	.BLKW #1	;


;OUT: R0, OUT R5 (0-success, 1-fail/underflow)
;R3 STACK_START R4 STACK_TOP
;
POP	
	ST R3, POP_SaveR3	;save R3
	ST R4, POP_SaveR4	;save R3
	AND R5, R5, #0		;clear R5
	LD R3, STACK_START	;
	LD R4, STACK_TOP	;
	NOT R3, R3		;
	ADD R3, R3, #1		;
	ADD R3, R3, R4		;
	BRz UNDERFLOW		;
	ADD R4, R4, #1		;
	LDR R0, R4, #0		;
	ST R4, STACK_TOP	;
	BRnzp DONE_POP		;
UNDERFLOW
	ADD R5, R5, #1		;
DONE_POP
	LD R3, POP_SaveR3	;
	LD R4, POP_SaveR4	;
	RET


POP_SaveR3	.BLKW #1	;
POP_SaveR4	.BLKW #1	;
STACK_END	.FILL x3FF0	;
STACK_START	.FILL x4000	;
STACK_TOP	.FILL x4000	;

.END

