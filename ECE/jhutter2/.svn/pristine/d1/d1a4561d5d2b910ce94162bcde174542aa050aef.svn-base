;modified POP to store value in R6.
;read comments
; WRITTEN BY JACOB HUTTER 
; This code will allow you to print parantheses but limited to stack length and cannot cause underflow by starting with right parnethesis. 
; Also checks if parentheses are even 
;R0--> used for trap routine, holds char that is inputted
;R1--> Holds address of stack top
;R2--> holds ascii vals of characters to compare 
;R5--> overflow or underflow indicator
;R6--> evenness of parentheses indicator
;
.ORIG x3000
			AND R6,R6,#0
			ADD R6,R6,#1        ; initially parenthesis are even
CLEAR		AND R0,R0,#0 		; clear R0
			GETC        		; get char from keyboard 
			LD R2,SPACE         ; get val of space
			NOT R2,R2           ; 
			ADD R2,R2,#1        ; inverse R2
			ADD R2,R2,R0
			BRZ IGNORE
			LD R2,NEW_LINE  	; get val of NEW_LINE
			NOT R2,R2    		; 
			ADD R2,R2,#1        ; get inverse of new line char
			ADD R2,R2,R0        ; compare inverse new line and char 
			BRZ HAVE_ALL  		; branch if have all chars
			LD R2,CHAR_RETURN  	; get val of CHAR_RETURNE
			NOT R2,R2    		; 
			ADD R2,R2,#1        ; get inverse of new line char
			ADD R2,R2,R0        ; compare inverse new line and char 
			BRZ HAVE_ALL  		; branch if have all chars			
			JSR IS_BALANCED
PRINT		OUT					; print char to keyboard					
			BR CLEAR        	; loop back to get next char		
IGNORE		BR CLEAR        	; ignore the space and do not print 
HAVE_ALL    HALT 

 			
SPACE		.FILL x0020
NEW_LINE	.FILL x000A
CHAR_RETURN	.FILL x000D
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;if ( push onto stack if ) pop from stack and check if popped value is (
;input - R0 holds the input
;output - R6 set to -1 if unbalanced. else not modified.
IS_BALANCED
			ST R7,SEVEN         ;preserve value of R7
			LD R2,LEFT
			NOT R2,R2
			ADD R2,R2,#1        ; inverse left parenthesis
			ADD R2,R2,R0 
			BRZ ONTO
			ST R6,SIX           ; preserve value of R6
			JSR POP         	; jump and save pc to pop
			LD R6,SIX           ; get preserved value of R6
			ADD R5,R5,#0    	; reference R5
			BRZ CHECK       	; if no underflow then branch to print
			BR  CLEAR       	; no closed parenthesis without pair allowed so get new c   
ONTO        JSR PUSH        	; jump and save pc to push
			ADD R5,R5,#0 		; reference R5	
			BRP CLEAR			; if overflow then do not allow to print 	
CHECK       AND R6,R6,#0        ; clear R6
			ADD R6,R6,#-1   	; set default to negative one for even bit
			LD R2,STACK_START   ; load stack pointer address
			LD R1,STACK_TOP 	; load stack top address 
			AND R2,R1,R2		; check to see if addresses match
			BRZ RESET      	    ; if not matching then R6 should be zero
			AND R6,R6,#0        ; clear R6
			ADD R6,R6,#1   	 	; set parenthesis even bit to one 
RESET		LD R7,SEVEN         ; get original value of R7
			RET


SEVEN       .FILL x0000
SIX         .FILL x0000
STORE       .FILL x0000		
LEFT    	.FILL x0028
RIGHT       .FILL x0029

	
NEG_OPEN .FILL xFFD8
;IN:R0, OUT:R5 (0-success, 1-fail/overflow)
;R3: STACK_END R4: STACK_TOP
;
PUSH	
	ST R3, PUSH_SaveR3	;save R3
	ST R4, PUSH_SaveR4	;save R4
	AND R5, R5, #0		;
	LD R3, STACK_END	;
	LD R4, STACK_TOP	;
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


;OUT: R6, OUT R5 (0-success, 1-fail/underflow)
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
	LDR R6, R4, #0		;
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


