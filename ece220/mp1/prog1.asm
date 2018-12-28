;
; The code given to you here implements the histogram calculation that 
; we developed in class.  In programming studio, we will add code that
; prints a number in hexadecimal to the monitor.
;
; Your assignment for this program is to combine these two pieces of 
; code to print the histogram to the monitor.
;
; If you finish your program, 
;    ** commit a working version to your repository  **
;    ** (and make a note of the repository version)! **
;	***********************************************************************************
;   ********* SEE WHERE MY CODE STARTS FOR THE INTRO PARAGRAPH AND REGISTER LIST*******
;   ***********************************************************************************


	.ORIG	x3000		; starting address is x3000


;
; Count the occurrences of each letter (A to Z) in an ASCII string 
; terminated by a NUL character.  Lower case and upper case should 
; be counted together, and a count also kept of all non-alphabetic 
; characters (not counting the terminal NUL).
;
; The string starts at x4000.
;
; The resulting histogram (which will NOT be initialized in advance) 
; should be stored starting at x3F00, with the non-alphabetic count 
; at x3F00, and the count for each letter in x3F01 (A) through x3F1A (Z).
;
; table of register use in this part of the code
;    R0 holds a pointer to the histogram (x3F00)
;    R1 holds a pointer to the current position in the string
;       and as the loop count during histogram initialization
;    R2 holds the current character being counted
;       and is also used to point to the histogram entry
;    R3 holds the additive inverse of ASCII '@' (xFFC0)
;    R4 holds the difference between ASCII '@' and 'Z' (xFFE6)
;    R5 holds the difference between ASCII '@' and '`' (xFFE0)
;    R6 is used as a temporary register
;

	LD R0,HIST_ADDR      	; point R0 to the start of the histogram
	
	; fill the histogram with zeroes 
	AND R6,R6,#0		; put a zero into R6
	LD R1,NUM_BINS		; initialize loop count to 27
	ADD R2,R0,#0		; copy start of histogram into R2

	; loop to fill histogram starts here
HFLOOP	STR R6,R2,#0		; write a zero into histogram
	ADD R2,R2,#1		; point to next histogram entry
	ADD R1,R1,#-1		; decrement loop count
	BRp HFLOOP		; continue until loop count reaches zero

	; initialize R1, R3, R4, and R5 from memory
	LD R3,NEG_AT		; set R3 to additive inverse of ASCII '@'
	LD R4,AT_MIN_Z		; set R4 to difference between ASCII '@' and 'Z'
	LD R5,AT_MIN_BQ		; set R5 to difference between ASCII '@' and '`'
	LD R1,STR_START		; point R1 to start of string

	; the counting loop starts here
COUNTLOOP
	LDR R2,R1,#0		; read the next character from the string
	BRz PRINT_HIST		; found the end of the string

	ADD R2,R2,R3		; subtract '@' from the character
	BRp AT_LEAST_A		; branch if > '@', i.e., >= 'A'
NON_ALPHA
	LDR R6,R0,#0		; load the non-alpha count
	ADD R6,R6,#1		; add one to it
	STR R6,R0,#0		; store the new non-alpha count
	BRnzp GET_NEXT		; branch to end of conditional structure
AT_LEAST_A
	ADD R6,R2,R4		; compare with 'Z'
	BRp MORE_THAN_Z         ; branch if > 'Z'

; note that we no longer need the current character
; so we can reuse R2 for the pointer to the correct
; histogram entry for incrementing
ALPHA	ADD R2,R2,R0		; point to correct histogram entry
	LDR R6,R2,#0		; load the count
	ADD R6,R6,#1		; add one to it
	STR R6,R2,#0		; store the new count
	BRnzp GET_NEXT		; branch to end of conditional structure

; subtracting as below yields the original character minus '`'
MORE_THAN_Z
	ADD R2,R2,R5		; subtract '`' - '@' from the character
	BRnz NON_ALPHA		; if <= '`', i.e., < 'a', go increment non-alpha
	ADD R6,R2,R4		; compare with 'z'
	BRnz ALPHA		; if <= 'z', go increment alpha count
	BRnzp NON_ALPHA		; otherwise, go increment non-alpha

GET_NEXT
	ADD R1,R1,#1		; point to next character in string
	BRnzp COUNTLOOP		; go to start of counting loop
	
;**********************************************************************************************
;JACOB HUTTER AND SANJAY KALIDINI
; CODE FOR PRINTING A HISTOGRAM STARS BELOW AT PRINT_HIST. THE CODE ABOVE, CLEARS THE DATA SLOTS WHERE THE NUMBER OF APPEARANCES EACH CHARACTER MAKES IS STORED, AND THEN PUTS THE 
;NUMBER OF APPERANCES OF A CHARACTER FROM A NEW STRING STARTING AT X4000 INTO THE MEMORY SLOTS STARTING AT 3F00 WITH @ AND GOING TO THE CORRESPONDING Z MEMORY ADDRESS. THE CODE 
;BELOW WILL LOAD THE FOUR DIGIT HEX NUMBER, MODIFY AND COPY IT INTO A REGISTER AND THEN PRINT EACH DIGIT EXACTLY AS IT WOULD APPEAR IN THE MEMORY SLOT.
; IN ADDITION TO THIS, THE CODE ALSO PRINTS A THE CORRESPONDING LETTER OR NON LETTER FOR WHICH THE PROGRAM ABOVE IS COUNTING, FOLLOWED BY A SPACE AND EVENTUALLY A NEW LINE 
;CHARACTER.
;R0==> USED FOR TRAP X21 INSTRUCTION
;R1==> HOLDS DECIMAL 27 TO KNOW WHEN TO STOP LOOP
;R2==> DIGIT COUNTER
;R3==> ADDRESS OF CONTENTS OF HISTOGRAM LINES
;R4==> DIGIT
;R5==> BIT COUNTER
;R6==> HOLDS INCREMENTABLE ASCII CHARACTER STARTING WITH @



PRINT_HIST LD R1,NUM_BINS ;load R1 with 27
	       LD R6,ASCII    ; loads with ascii value of @ 
TOP	       AND R0,R0,#0   ;clear R0
	       ADD R0,R6,R0   ;Add r6 to r0
	       TRAP X21       ;print       
	       LD R0,SPACE    ; loads with ascii value of a space
	       TRAP X21 
	       LDI R3,TEMP 	  ; loads contents of first line of histogram
	         ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	        AND R2,R2,#0 ; initialize R2 as digit counter to zero
 			ADD R2,R2,#4 ;added loop counter to R2
CHECK 		BRP NEXT
 			BRNZP NEW_LINE       ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;HALT statement
 NEXT   	AND R4,R4,#0  ; Initialize digit
 			AND R5,R5,#0  ; Initialize bit counter
 			ADD R5,R5,#4  ; set to 4 
REF 		ADD R5,R5,#0  ; reference R5 for branching
 			BRZ PRINT
 			ADD R4,R4,R4  ; shift digit left
 			ADD R3,R3,#0  ;reference R3 for branching
SHIFT 		BRN NEGATIVE
 			ADD R4,R4,#0  ;fills bit in digit 
 			ADD R3,R3,R3  ;Shift R3 left
 			ADD R5,R5,#-1 ;decrement bit counter 
 			BRNZP REF
NEGATIVE    ADD R4,R4,#1  ;fill bit in digit (1)
			ADD R3,R3,R3  ;Shift R3 left
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
			AND R0,R0,#0  ; clear R0
			ADD R0,R0,R4  ;prep for trap
			TRAP X21      ; output to the monitor 
			ADD R2,R2,#-1 ; decrement digit counter
			BRNZP CHECK   ;loops back to check if done with digit counter
ZERO        LD R4,STORE   ; get unaltered val of R4
			ADD R4,R4,#15 ;
			ADD R4,R4,#15 ;
			ADD R4,R4,#15 ; Adds 48 to R4 to signify '0'
			ADD R4,R4,#3  ;
			AND R0,R0,#0  ; clear R0 for trap 
			ADD R0,R4,R0  ; Add contents of R4 to R0
			TRAP X21      ; output to monitor
			ADD R2,R2,#-1 ; Decrement digit counter
			BRNZP CHECK   ; loop back to beginning 
	         ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
NEW_LINE   LD R0,LINE     ;loads new line character into R0
		   TRAP x21       ;prints new line char 
		   LD  R3,TEMP    ;loads incrementable 3F00
		   ADD R3,R3,#1   ;increments the load address 
		   ST  R3,TEMP    ;stores incremented address 
	       ADD R6,R6,#1   ;increment ascii char
	       ADD R1,R1,#-1  ;decrement line counter
	       BRP TOP
DONE     	HALT			; done


; the data needed by the program
NUM_BINS	.FILL #27	; 27 loop iterations
NEG_AT		.FILL xFFC0	; the additive inverse of ASCII '@'
AT_MIN_Z	.FILL xFFE6	; the difference between ASCII '@' and 'Z'
AT_MIN_BQ	.FILL xFFE0	; the difference between ASCII '@' and '`'
HIST_ADDR	.FILL x3F00     ; histogram starting address
STR_START	.FILL x4000	; string starting address
ASCII       .FILL X0040 ; ascii of @
SPACE       .FILL x0020 ; ascii value of a space
TEMP        .FILL x3F00 ;holds incrementable 3F00
STORE 		.FILL x0000 ;val for R4
LINE        .FILL x000A ;new line char ascii code

; for testing, you can use the lines below to include the string in this
; program...
; STR_START	.FILL STRING	; string starting address
; STRING		.STRINGZ "This is a test of the counting frequency code.  AbCd...WxYz."



	; the directive below tells the assembler that the program is done
	; (so do not write any code below it!)

	.END
