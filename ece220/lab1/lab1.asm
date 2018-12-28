 ;Lab 1 
 ; assignment: develop a code to print a value stored in a register 
 ;             as a hexadecimal number to the monitor
 ; algorithm: turnin each group of four bits into a digit
 ;            calculate the corresponding ASCII character;
 ;            print the character to the monitor
 ;My name is Jacob Hutter, this code will print a character stored in R3. I have commented out the lines that give values to R3 or clear them. Line : 15 and 70
 ; R2--> Digit counter
 ; R3---> given value
 ; R4--> DIGIT 
 ; R5--> BIT counter
 ; R0---> Used for trap routine

 			.ORIG x3000
 ;			LD R3,DATA ; loads value of R3
 			AND R2,R2,#0 ; initialize R2 as digit counter to zero
 			ADD R2,R2,#4 ;added loop counter to R2
CHECK 		BRP NEXT
 			HALT
 NEXT   	AND R4,R4,#0 ; Initialize digit
 			AND R5,R5,#0 ; Initialize bit counter
 			ADD R5,R5,#4 ; set to 4 
REF 		ADD R5,R5,#0 ; reference R5 for branching
 			BRZ PRINT
 			ADD R4,R4,R4 ; shift digit left
 			ADD R3,R3,#0 ;reference R3 for branching
SHIFT 		BRN NEGATIVE
 			ADD R4,R4,#0 ;fills bit in digit 
 			ADD R3,R3,R3 ;Shift R3 left
 			ADD R5,R5,#-1 ;decrement bit counter 
 			BRNZP REF
NEGATIVE    ADD R4,R4,#1 ;fill bit in digit (1)
			ADD R3,R3,R3 ;Shift R3 left
			ADD R5,R5,#-1 ;decrement bit counter
			BRNZP REF
PRINT       ST R4,STORE
			ADD R4,R4,#-9
			BRNZ ZERO
			LD R4,STORE ; retrieve original value of R4
			ADD R4,R4,#15 ;
			ADD R4,R4,#15 ;
			ADD R4,R4,#15 ; adds decimal 65 to R4 to signify 'A'
			ADD R4,R4,#15 ;
			ADD R4,R4,#5  ;
			ADD R4,R4,#-10; subtracts 10 
			AND R0,R0,#0    ; clear R0
			ADD R0,R0,R4 ;prep for trap
			TRAP X21     ; output to the monitor 
			ADD R2,R2,#-1; decrement digit counter
			BRNZP CHECK  ;loops back to check if done with digit counter
ZERO        LD R4,STORE  ; get unaltered val of R4
			ADD R4,R4,#15 ;
			ADD R4,R4,#15 ;
			ADD R4,R4,#15 ; Adds 48 to R4 to signify '0'
			ADD R4,R4,#3  ;
			AND R0,R0,#0  ; clear R0 for trap 
			ADD R0,R4,R0  ; Add contents of R4 to R0
			TRAP X21      ; output to monitor
			ADD R2,R2,#-1 ; Decrement digit counter
			BRNZP CHECK   ; loop back to beginning 
 		
 
 



 ; stop the computer

 ; program data section starts here
;DATA  .FILL x0000 ;initial val of R3
STORE .FILL x0000 ;val for R4
DDR   .FILL xFE06
DSR   .FILL xFE04

 .END

