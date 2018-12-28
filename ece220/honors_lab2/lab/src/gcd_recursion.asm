;gcd_recursion.asm
;Finds the greatest common demoninator between two numbers. Inputs are provided
;by the inputX.asm files and the output should be stored in a memory location.

;Inputs:
;  x5000 - u
;  x5001 - v

;Outputs:
;  x5002 - gcd

.ORIG x3000

MAIN 	;LD R1,U
		;LD R2,V
		
		LDI R1,IN_U          ; get val of u
		LDI R2,IN_V 	     ; get val of v 
		JSR GCD     	     ; JUMP TO SUBROUTINE GCD 
PUT		STI R1,OUT_GCD       ; PUT U INTO X5002
DONE            HALT

;MAIN data
;U       .FILL x000A
;V       .FILL x0003
IN_U    .FILL x5000
IN_V    .FILL x5001
OUT_GCD .FILL x5002

;GCD
;  DESCRIPTION: computes the greatest common denominator of two numbers u, v
;  INPUTS: R1 - u
;          R2 - v
;  OUTPUTS: R3 - gcd
GCD		ST R7,LOCKER1
GCD1	ADD R2,R2,#0  ; REFERENCE V 
		BRZ GCD_RET   ; IF R2 IS ZERO THEN BRANCH TO GCD RETURN
		ST R7,LOCKER  ; KEEP R7 
		JSR MOD
		JSR POP       ;
		AND R2,R2,#0
		ADD R2,R2,R6  ; PUT POPPED MOD INTO R2 (V)
		JSR POP       ; GET V ORIG
		LD R7,LOCKER
		AND R1,R1,#0  ; CLEAR R1
		ADD R1,R1,R6  ; PUT V ORIG INTO U
		JSR GCD1       ; RECURSIVELY CALL GCD
GCD_RET LD  R7,LOCKER1 ;
  		RET           ; RETURN
LOCKER  .FILL X0000
LOCKER1 .FILL X0000
;MOD
;  DESCRIPTION: computes the the modulus a%b
;  INPUTS: R1 - a
;          R2 - b
;  OUTPUTS: R3 - mod
MOD		ST R2,LOCKUP
		NOT R2,R2      ; get negative of b 
		ADD R2,R2,#1   ; 
AGAIN1	AND R3,R3,#0   ; clear remainder
		ADD R3,R2,R1   ; R3<---A-B
		BRNP REM       ; if remainder is zero then do something
		AND R3,R3,#0   ;
		BR MOD_RET     ; if rem is zero then R3 is zero
REM     ADD R3,R3,#0   ; reference R3
		BRP POS        ; IF R3 is negative then remainder is clearly just a 
		AND R3,R3,#0
		ADD R3,R1,R3   ; R3<----A 
		BR MOD_RET     ; go to mod return
POS     AND R1,R1,#0
		ADD R1,R3,R1   ; NOW remainder becomes new A 
		BR AGAIN1      ; loop back until remainder is definitive 
MOD_RET AND R0,R0,#0   ; clear R0
		LD R2,LOCKUP   ; get non-negative val of R2
		ST R7,BOX      ; keep val of R7
		ADD R0,R2,R0   ; put val of b onto stack 
		JSR PUSH       ; put b onto stack
		AND R0,R0,#0   ; clear R0 again
		ADD R0,R3,R0   ; put remainder onto stack
		JSR PUSH       ;
		LD R7,BOX      ; get back val of R7
  		RET            ; return 

BOX .FILL x0000
REGISTER .FILL x0000
LOCKUP   .FILL x0000










;PUSH
;  DESCRIPTION: pushes data unto stack
;  INPUTS: R0 - value to push
;  OUTPUTS: R5 - success (0) or failure (1)
PUSH	
	ST R3, PUSH_SaveR3	;save R3
	ST R4, PUSH_SaveR4	;save R4
	AND R5, R5, #0
	LD R3, STACK_END
	LD R4, STACk_TOP
	ADD R3, R3, #-1
	NOT R3, R3
	ADD R3, R3, #1
	ADD R3, R3, R4
	BRz OVERFLOW		;stack is full
	STR R0, R4, #0		;no overflow, store value in the stack
	ADD R4, R4, #-1		;move top of the stack
	ST R4, STACK_TOP	;store top of stack pointer
	BRnzp DONE_PUSH
OVERFLOW
	ADD R5, R5, #1
DONE_PUSH
	LD R3, PUSH_SaveR3
	LD R4, PUSH_SaveR4
	RET

;PUSH register data
PUSH_SaveR3	.BLKW #1	;
PUSH_SaveR4	.BLKW #1	;

;POP
;  DESCRIPTION: pops data off stack
;  INPUTS: none
;  OUTPUTS: R5 - success (0) or failure (1)
;           R6 - popped data
POP	
	ST R3, POP_SaveR3	;save R3
	ST R4, POP_SaveR4	;save R3
	AND R5, R5, #0		;clear R5
	LD R3, STACK_START	
	LD R4, STACK_TOP	
	NOT R3, R3		
	ADD R3, R3, #1		
	ADD R3, R3, R4	
	BRz UNDERFLOW	
	ADD R4, R4, #1
	LDR R6, R4, #0
	ST R4, STACK_TOP
	BRnzp DONE_POP
UNDERFLOW
	ADD R5, R5, #1
DONE_POP
	LD R3, POP_SaveR3
	LD R4, POP_SaveR4
	RET

;POP register data
POP_SaveR3	.BLKW #1
POP_SaveR4	.BLKW #1

;Stack data
STACK_END	.FILL x3FF0
STACK_START	.FILL x4000
STACK_TOP	.FILL x4000

.END
