;Assuming user will only enter ' ' 0-9 *+/-
;THIS CODE WILL TAKE AN INPUT FROM THE KEYBOARD AND CALCULATE A CERTAIN OPERATION WITH AN INITIAL MINIMUM OF 2 OPERANDS AND ONE OPERATOR, FROM THERE
; A MINIMUM OF ONE OPERATOR IS NEEDED BEFORE EVERY OPERAND. ONLY CHARACTERS 0-9 *+/- WILL BE ACCEPTED. ELSE, WILL PRINT INVALID EXPRESSION.
; ****NOTE***  THE PROGRAM WILL ONLY ECHO OUTPUTS TO THE KEYBOARD THAT ARE VALID. FOR EXAMPLE IF WE ENTERED A PLUS FIRST, THEN THE PROGRAM WILL NOT
; PRINT THE PLUS IN ADDITION TO THE INVALID EXPRESSION. HOWEVER IF WE TYPED IN 1 + THEN THE PROGRAM WILL STILL PRINT THE 1 BUT NOT THE +. 
; BECAUSE OF THE WAY I HAVE DESIGNED IT. EACH ANSWER STORED IN R6 IS CLEARED AFTER EVERY HALT OF THE PROGRAM. SO YOU WILL NOT BE ABLE TO CONTINUE 
; CALCULATIONS FROM RUN TO RUN. HOWEVER, YOU WILL BE ABLE TO RESET THE PC TO X3000 EVERY TIME INSTEAD OF RELOADING THE PROGRAM.
; R0----> USED FOR CLEARING STACK AND ALSO HOLDING THE INPUT CHARACTER AND THEN OUTPUTING IT 
; R1----> HOLDS VALUE TO COMPARE TO R0 TO IDENTIFY R0 AS +, 5, ETC...
; R2----> VARIOUS USES INCLUDING HOLDING STACK TEST TO SEE IF ONLY ONE VAL
; R3,R4----> USED FOR PUSH AND POP SUBROUTINES
; R5------> FLAG FOR UNDERFLOW/OVERFLOW
; R6------> FOR MP2.1 THIS IS WHERE YOU WILL FIND THE ANSWER TO THE CALCULATION TYPED ASSUMING IT IS VALID 
; R7------> OFTEN HOLDS ADDRESS FOR RETURN FUNCTION 
;
;
;
.ORIG x3000
		AND R6,R6,#0 		;                                                                                         
		AND R5,R5,#0 		;                                                                                         
		AND R0,R0,#0 		;                                                                                          
		AND R1,R1,#0 		; clear registers                                                                         
		AND R2,R2,#0 		;  
		AND R3,R3,#0 		;
		AND R4,R4,#0 		;                                                                          |THIS CODE ALLOWS YOU TO RESET
		STI R0,STACK_START 	; clear memory location x4000(may be filled from previous calculation)     |PC TO X3000, AS WELL AS 
		STI R0,STACK_TEST 	;                                                                          |CLEARING ALL REGISTERS 
		LD R0,STACK_START 	; clear stack pointer memory location x4000(may be filled from previous calculation) 
		ST R0,STACK_TOP  	;                                                                                     
;;;;;;;;;;;GET CHAR AND DECIDE IF VALID (except if exponential which branches to push);;;;;;;;;;;		
IGNORE		GETC         	; GET CHARACTER FROM KEYBOARD
		OUT 
		LD R1,NEW_LINE1  	;
		JSR INVERT   	 	; go to invert R1 subroutine check if input value equals space,new line, etc 
		BRZ STOCK    	 	; testing for new lines
		LD R1,NEW_LINE2  	;
		JSR INVERT       	; checking if newline has appeared
		BRZ STOCK 	 		; IF NEW LINE GO TO DIFFERENT SUBSECTION    
		LD R1,SPACE      	; CHECK IF SPACE
		JSR INVERT       	;
		BRZ IGNORE   	 	; get new char if space 
		LD R1,TIMES  	 	; get value of *
		JSR INVERT       	; invert it 
		BRN PRINT        	; IF NOT WITHIN RANGE OF VALUES THEN PRINT INVALID EXPRESSION (INPUT<* IN ASCII)
		LD R1,COMMA      	; CHECKING OUTLIERS WIHTIN ACCEPTED RANGE OF ASCCII VALS 
		JSR INVERT   	 	; check if comma 
		BRZ PRINT        	;
		LD R1,DOT        	;
		JSR INVERT       	;
		BRZ PRINT        	;
		LD R1,RAISE      	; CHECK OUTLIER ABOVE ACCEPTED RANGE 
		JSR INVERT       	;
		BRNP NEW         	; exponent operator found 
		JSR EVALUATE 		;
		BR IGNORE			;
NEW		LD R1,NINE       	; CHECK GENERAL UPPER BOUNDARY OF ASSCCII RANGE 
		JSR INVERT      	;
		BRP PRINT 			;
		ST R7,STORAGE       ;
		JSR EVALUATE    	; GO TO EVALUATE STAGE
		LD R7,STORAGE 		;
		BR IGNORE        	; GET NEXT CHARACTER FOR CALCULATION 
		

;;;;;;;;;;;PRINT INVALID CHAR;;;;;;;;;
PRINT LEA R1,STRNG      ; GET INVALID EXPRESSION STRING
LOOP  LDR R0,R1,#0      ;loop TO PRINT 
	  BRZ DONE           	;
	  OUT
	  ADD R1,R1,#1       	; prints the string located at strng
	  BRNZP LOOP
;;;;;;;;;;IF StACK only hAs ONe ValuE;;;;;;;;;;
STOCK	LD R1,STACK_TEST   ;get hex 4001
		LD R2,STACK_TOP    ; get stack pointer
		NOT R2,R2          ;invert stack test
		ADD R2,R2,#1
		ADD R2,R2,R1 
		BRNP PRINT         ; if comparison does not yield a zero then print invalid expression
		JSR PRINT_HEX
		LDI R6,STACK_START ; if test is successful then store what is at address 4000 to R6
		BR DONE            ; end program 


DONE		HALT           ;STOP PROGRAM
RAISE     .FILL X005E
NINE      .FILL X0039
COMMA     .FILL X002C
DOT       .FILL X002E
SPACE     .FILL X0020
NEW_LINE1 .FILL X000D
NEW_LINE2 .FILL X000A
TIMES     .FILL X002A
DIVIDE	  .FILL X002F
ONEUP	  .FILL X002B
MINUS     .FILL X002D
STRNG     .STRINGZ "INVALID EXPRESSION"
ZER0      .FILL x0030 
REG01     .FILL x0000
REG02     .FILL x0000
CHAR      .FILL x0000
STORAGE   .FILL x0000
STACK_TEST  .FILL x3FFF ; signifies that there will be only one val in the stack 

INVERT	NOT R1,R1    	; ADDITIVE INVERSE
		ADD R1,R1,#1 	;
		ADD R1,R1,R0 	; check if solution
		RET          	;RETURN

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;R3- value to print in hexadecimal
PRINT_HEX ST R7,STOREP
	  	JSR POP      	;get result in stack R0 now has result
	  	LD R7,STOREP    ;
	  	AND R1,R1,#0 	; 
	  	AND R2,R2,#0 	;
	  	ADD R2,R2,#4 	;
REF	  	ADD R0,R0,#0 	; reference r0
	  	BRZP THREES  	;
	  	ADD R1,R1,#8 	; if digit is zero then put 8 into reg1
THREES  ADD R0,R0,R0 	; shift r0 to the left
	  	BRZP TWOS    	;
	    ADD R1,R1,#4 	; if second digit is 1 then add 4 
TWOS	ADD R0,R0,R0 	; shift R0 to the left
	  	BRZP ONES       ;
	  	ADD R1,R1,#2 	; add decimal 2 to if digit 3 is 1 
ONES	ADD R0,R0,R0  	; shift R0 to the left
	  	BRZP ZEROES     ;
	  	ADD R1,R1,#1    ; if digit 4 is one then add 1 
ZEROES	ADD R0,R0,R0 	; shift R0 to the left 
	  ST R0,OG_MACCO 	; preserve shifted R0
	  LD R0,ZER0   		; get ascii val of zero into R0
	  ADD R0,R1,R0 		; add offset
	  LD R3,WEIRD       ;
	  NOT R3,R3    		; checking if number is essentially negative 
	  ADD R3,R3,#1 		; 
	  ADD R3,R3,R0 		;		
	  BRN UGH 			;		
	  ADD R0,R0,#7  	; offset for negative numbers
UGH	  OUT          		; print first digit
	  LD R0,OG_MACCO 	; get back shifted R0 
	  AND R1,R1,#0  	; clear R1
	  ADD R2,R2,#-1 	; decrement hex counter 
	  BRP  REF
	  LD R7,STOREP
	  RET 
	  
	  
		



WEIRD    .FILL x003A
OG_MACCO .Fill x0000
STOREP  .FILL x0000


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;R0 - character input from keyboard
;R6 - current numerical output
;
;
EVALUATE
;;;;;;;;;;;;;;;;;OPERAND?;;;;;;;;;;;;;;;;;;
		LD R1,RAISE 
		ST R7,STORAGE1
		JSR INVERT
		LD R7,STORAGE1
		ADD R1,R1,#0
		BRZ SPECIAL           ; branch if char is an exponent
		LD R1,ZER0            ; CHECK IF LOWER BOUNDARY OF INTEGERS
		ST R7,STORAGE1        ; STORE R7
		JSR INVERT            
		LD R7,STORAGE1
		ST  R0,CHAR           ; save input char
		ADD R1,R1,#0          ;reference R1
		BRZP OPERAND1          ; IF NUMBER IS INTEGER, GO DIRECTLY TO OPERAND1 to subtract hex 30 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;; pop two values;;;;;;;;;;;;;;;;;;		 
SPECIAL		ST  R7,STORAGE1       ; PRESERVE R7
POP2	JSR POP    			  ; pop once :)
		LD R7,STORAGE1        ; GET R7
		ST R0,REG02           ; store first operand in REG01
		ST R7,STORAGE1        ; STORE R7
		JSR POP               ; pop twice :D
		LD R7,STORAGE1        ; GET R7
		ST R0,REG01           ;store second operand in REG02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; STACK UNDERFLOW?;;;;;;;;;;;;;;;
		ADD R5,R5,#0          ; CHECK IF UNDER FLOW AND IF SO THEN GO TO PRINT INVALID EXPRESSION 
		BRP PRINT             ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;; APPLY OPERAND;;;;;;;;;;;;;;;;;;;
		LD R0,CHAR    		  ; get value from memory, must be operator
		LD R1,TIMES           ;
		ST R7,STORAGE1        ; THESE NEXT COUPLE OF LINES JUST DETERMINE EXACTLY WHICH OPERATOR IS ENTERED AND BRANCH TO THAT SUBROUTINE 
		JSR INVERT            ; TO COMPLETE THAT OPERATION 
		LD R7,STORAGE1        ;
		ADD R1,R1,#0
		BRNP ONE 
		ST R7,STORAGE1
		JSR MUL
		LD R7,STORAGE1
		BR OPERAND 	;
ONE     	LD R1,DIVIDE         ; CHECK IF DIVISION
		ST R7,STORAGE1
		JSR INVERT
		LD R7,STORAGE1 
		ADD R1,R1,#0
		BRNP TWO
		ST R7,STORAGE1
		JSR DIV
		LD R7,STORAGE1
		BR OPERAND ;
TWO     	LD R1,ONEUP          ; CHECK IF ADDITION
		ST R7,STORAGE1
		JSR INVERT
		LD R7,STORAGE1
		ADD R1,R1,#0
		BRNP THREE
		ST R7,STORAGE1
		JSR PLUS
		LD R7,STORAGE1
		BR OPERAND  	   ; CHECK IF SUBTRACTION
THREE   	LD R1,MINUS
		ST R7,STORAGE1
		JSR INVERT
		LD R7,STORAGE1
		ADD R1,R1,#0
		BRNP FOUR
		ST R7,STORAGE1
		JSR MIN 
		LD R7,STORAGE1
		BR  OPERAND 	   ; CHECK IF EXPONENT
FOUR   		ST R7,STORAGE1
			JSR EXP
			LD R7,STORAGE1
			BR OPERAND               ; AFTER ALL OPERATIONS HAVE BEEN COMPLETED GO TO OPERAND 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;OPERAND;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
OPERAND1 	LD R2,HEX    ; get val of hex 30
		NOT R2,R2     ; get negative 30
		ADD R2,R2,#1  ; get negative 30  
		LD R0,CHAR    ;get stored val of r0
		ADD R0,R2,R0  ;subtract x0030 from number 
		ST R0,CHAR    ; store R0 back in char 
OPERAND ST R7,STORAGE1   
		JSR PUSH        ; PUSH VALUE ONTO STACK 
		LD R7,STORAGE1 
		RET
 
STACK_START	.FILL x4000	;
STACK_TOP	.FILL x4000	;
STORAGE1 .FILL x0000
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;input R3, R4
;out R0
PLUS 	 LD R1,REG01    ; GET TWO OPERANDS
	 LD R2,REG02    ; 
	 AND R0,R0,#0   ; CLEAR R0
	 ADD R0,R1,R2   ; PUT RESULT INTO R0
	 RET 	        ; RETURN 
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;input R3, R4
;out R0
MIN	LD  R1,REG01     ; get two operands
	LD  R2,REG02     ; assuming (r1-r2)
	NOT R2,R2        ; invert R2
	ADD R2,R2,#1     ; add 1 
	ADD R0,R2,R1     ; put final val in R0
	RET

	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;input R3, R4
;out R0
MUL	LD R1,REG01     ; get two operands
 	LD R2,REG02     ; assuming(R1*R2)
		AND R0,R0,#0
 		ADD R2,R2,#0
		BRZ BACK
		BRN LOOP2
		ADD R1,R1,#0
		BRZ BACK 
LOOP1   ADD R0,R1,R0    ; add r1 to r0
		ADD R2,R2,#-1   ; decrement counter 
		BRP LOOP1       ; if loop counter is not zero continue adding 
		RET
LOOP2   ADD R0,R1,#0
		ADD R2,R2,#1    ; if counter negative add 1 instead of subtracting 1 
		BRN LOOP2       ; keep adding if not done
		ADD R0,R0,#0
		BRZP IDK
		NOT R0,R0		; if result is negative we must flip because negative times negative is positive
		ADD R0,R0,#1    ; result is now flipped to adjust 
IDK		RET 
BACK    AND R0,R0,#0	; if counter is zero then immediately set r0 to zero 
		RET 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;input R3, R4
;out R0
DIV     LD R1,REG01      ; get two values
		LD R2,REG02      ; assuming (R1/R2)
		AND R0,R0,#0
		NOT R2,R2
		ADD R2,R2,#1     ; invert R2
IT 		ADD R1,R1,R2     ; subtract r2 from r1
		BRN FINISHIT     ; if number is negative then assume number is no longer bigger than denominator
		ADD R0,R0,#1	 ; not assuming rounding here
		BR IT
		
FINISHIT RET
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;input R3, R4
;out R0
EXP     ST R7,RHINO
		LD R1,REG01	; get two vals
		LD R2,REG02	; assume (R1^R2)
		BRZ QUICK   ; if exponent is zero then answer is zero
		ADD R2,R2,#-1
		BRZ MOLLY
		ST R1,REG02
MOLE	ST R1,REG01
		ST R2,REG03
		JSR MUL 
		LD R2,REG03
		AND R1,R1,#0
		ADD R1,R0,R1
		AND R0,R0,#0
		ADD R2,R2,#-1
		BRP MOLE
		ADD R0,R1,R0
		LD R7,RHINO
		RET      		
QUICK   AND  R0,R0,#0
		ADD  R0,R0,#1
		LD R7,RHINO  
		RET  
MOLLY   ADD R0,R0,R1 ;answer is just R1 
		LD R7,RHINO
		RET           
RHINO .FILL x0000
REG03 .FILL x0000
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


HEX         .FILL X0030


.END