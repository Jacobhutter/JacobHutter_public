;bubble_sort.asm
;Sorts the provided array in place from least to greatest.

;Inputs:
;  x5000 - length of array
;  x5001 - starting location of the array

;Outputs:
;  x5001 - starting location of the sorted array

.ORIG x3000

MAIN
  ADD R2,R2,#12 
  ST R2,STORER2          ;counter for bubble sort is needed to properly work
  ;Init data
  LD R0, ARR_LEN
  LDR R0, R0, #0
  LD R1, ARR_PTR

  ;Print unsorted array
  JSR PRINT_ARRAY

  ;Reload data
  LD R0, ARR_LEN
  LDR R0, R0, #0
  LD R1, ARR_PTR

  BACKER ;Sort the array
  JSR BUBBLE_SORT

  ;Reload data
  LD R0, ARR_LEN
  LDR R0, R0, #0
  LD R1, ARR_PTR
  LD R2,STORER2
  ADD R2,R2,#-1   ; decrement bubble sort counter
  ST R2,STORER2
  BRP BACKER
  ;Print sorted array
  JSR PRINT_ARRAY

DONE
  ;End
  HALT

;MAIN data
STORER2 .FILL x0000
ARR_LEN .FILL x5000
ARR_PTR .FILL x5001

;BUBBLE_SORT
;  DESCRIPTION: sorts the provided array from least to greatest
;  INPUTS: R0 - length of array
;          R1 - address of start of array
;  OUTPUTS: R1 - address of the start of the array
BUBBLE_SORT
		ST R7,UPS
		ST R0,FEDEX 
		LD R0,ARR_LEN
		LD R2,FEDEX  	; loads R2 as a counter 
		LDR R3,R1,#0 	; gets first val in loop    ;case where both are positive
		BRN NEGATIVE
		ADD R2,R2,#-1 	; if list only has one val then just finish
		BRZ DONE1      	; 
LOOP2		ADD R1,R1,#1    ; increment pointer 
		ADD R0,R0,#1    ; increment follower   
		LDR R4,R1,#0    ; get val 
		BRN NEG1        ; case where initial num is positive and second is neg, we will just swap
		ST R4,REGSTORE
		NOT R4,R4
		ADD R4,R4,#1    ; invert R4
		ADD R4,R3,R4    ; add them together
		BRNZ INVALID    ; if second number is bigger then do not swap
NEG1		JSR SWAP
INVALID		LDR R3,R1,#0    ; now number two is number one and repeat
		ADD R2,R2,#-1
		BRP LOOP2
		BR  DONE1

NEGATIVE        ADD R2,R2,#-1   ; first number negative second positive
		BRZ DONE1
		ADD R1,R1,#1
		ADD R0,R0,#1    ; increment pointer and follower
		LDR R4,R1,#0    ; Assuming r4 is positive do nothing
		BRZP INVALID    ; if second number is positive then do not switch assuming one is negative
		NOT R4,R4
		ADD R4,R4,#1
		ADD R4,R4,R3
		BRN DONOTHING
		JSR SWAP
DONOTHING       BR INVALID 

DONE1 		LD R7,UPS
		LD R0,FEDEX

BUBBLE_SORT_RET
  RET

;BUBBLE_SORT data
UPS 	.FILL x0000  ;stores r7
FEDEX 	.FILL x0000
REGSTORE .FILL x0000
;SWAP
;  DESCRIPTION: Swaps the data in the two addresses a, b
;  INPUTS: R0 - address a with data a
;          R1 - address b with data b
;  OUTPUTS: R0 - address a with data b
;           R1 - address b with data a
SWAP
		ST R0,A
		ST R1,B
		LDI R0,A
		LDI R1,B
		STI R0,B
		STI R1,A  ;switch vals
		LD R0,A   ; get back original addresses
		LD R1,B
		BR SWAP_RET


A     .FILL x0000
B     .FILl x0000

SWAP_RET
  RET

;SWAP data

;PRINT_ARRAY
;  DESCRIPTION: Prints the array
;  INPUTS: R0 - length of array
;          R1 - address of start of array
;  OUTPUTS: none
PRINT_ARRAY
	ST R7,BOX
	ST R0,STORAGE1
	LD R6,STORAGE1   ;using R6 as a counter 
	;LD R0,ASCII_X
	;OUT
	;LD R0,ASCII_FIVE
	;OUT
	;LD R0,ASCII_ZERO   ;prints five and zeros for initial hexadecimal counter 
	;OUT
	;LD R0,ASCII_ZERO
	;OUT
	;LD R0,ASCII_ZERO
	;OUT
	;LD R0,ASCII_SPACE
	;OUT
	;LD R0,ASCII_DASH
	;OUT
	;LD R0,ASCII_SPACE
	;OUT 
	;LD R0,ASCII_X
	;OUT
	;LD R3,STORAGE1              ; give value of printer to r3
	;JSR PRINTER
	;LD R0,ASCII_SPACE
	;LD R0,ASCII_NEWLN
	;OUT 
	ST R1,PTR
LOOP	;LD R3,PTR
	;LD R0,ASCII_X
	;OUT 
	;JSR PRINTER
	;LD R0,ASCII_SPACE
	;OUT 
	;LD R0,ASCII_DASH
	;OUT 
	;LD R0,ASCII_SPACE
	;OUT 
	;LD R0,ASCII_X
	;OUT
	LDI R3,PTR
	JSR PRINTER     ; print val stored in the first pointer
	LD R0,ASCII_SPACE        ;;;;;;;;;
	OUT                      ;;;;;;;;;;;;
	LD R3,PTR
	ADD R3,R3,#1    ; increment pointer 
	ST R3,PTR       ; put back incremented val for loop functions
	;LD R0,ASCII_NEWLN
	;OUT 
	ADD R6,R6,#-1
	BRP LOOP        ; if counter is zero then go back up 
	LD R0,ASCII_NEWLN ;;;;;;;;;;;;;;;;
	OUT            ;;;;;;;;;;;;;;;;;

	LD R7,BOX
	RET
BOX    .FILL x0000
PRINTER
	ST R7,STOREEM                              ; expects value in R3 and prints it 
	AND R4,R4,#0                 ;clear R4
	ADD R4,R4,#4                 ; give digit counter 4 ;;;;;;;;;;;begining of loop to print general hex number
AGAIN	AND R0,R0,#0
	ADD R3,R3,#0                 ; reference R3
	BRZP  ADD8
	ADD R0,R0,#8                 ; add 8 if number starts with a one
ADD8    ADD R3,R3,R3                 ; SHIFT LEFT
	BRZP  ADD4
	ADD R0,R0,#4                 ; add 4 if num 2nd digit is a one
ADD4    ADD R3,R3,R3                 ; shift left
	BRZP  ADD2
	ADD R0,R0,#2
ADD2	ADD R3,R3,R3
	BRZP ADD1
	ADD R0,R0,#1
ADD1    ADD R3,R3,R3                 ; number is transferred 
	LD R2,ASCII_ZERO
	ADD R0,R0,R2                 ; give offset of zero 
	LD R2,OFFSET                 ;testing if it is bigger than 9
	NOT R2,R2
	ADD R2,R2,#1  
	ADD R2,R2,R0
	BRN NOPE
	ADD R0,R0,#7 
NOPE	OUT
	ADD R4,R4,#-1                 ; decrement counter
	BRP AGAIN
	LD R7,STOREEM ;
	RET
	
	


;PRINT_ARRAY data
STOREEM     .FILL x0000
PTR         .FILL x0000
OFFSET      .FILL x003A 
ASCII_DASH  .FILL x002D
STORAGE1    .FILL x0000
ASCII_FIVE  .FILL x0035
ASCII_ZERO  .FILL x0030
ASCII_X     .FILL x0078
ASCII_SPACE .FILL x0020
ASCII_NEWLN .FILL x000A

;PRINT_DATA ; didnt even use this, i just used my version oops 
;  DESCRIPTION: Prints the data
;  INPUTS: R0 - data 
;  OUTPUTS: none
;  REGISTERS: R1 - digit loop
;             R2 - bit loop
;             R3 - digit storage
;             R6 - temp
PRINT_DATA
  ;Callee-saved
  ST R1, PD_R1
  ST R2, PD_R2
  ST R3, PD_R3
  ST R6, PD_R6
  ST R7, PD_R7

  ;Loops over all digits
  AND R1, R1, #0
DIGIT_LOOP

  ;Loop to obtain a digit
  AND R2, R2, #0
  AND R3, R3, #0
BIT_LOOP
  ;Check input MSB
  ADD R3, R3, R3
  ADD R0, R0, #0
  BRzp MSB_ZERO
  ADD R3, R3, #1
  
  ;Update and check if obtained digit
MSB_ZERO
  ADD R0, R0, R0
  ADD R2, R2, #1
  ADD R6, R2, #-4
  BRn BIT_LOOP

  ;Check if greater than xA
  ADD R6, R3, #-10		
	BRzp HIGH_DIGIT

  ;Handle number digit
  ADD R6, R3, #0
  LD R6, ASCII_NUM
	BRnzp PRINT_DIGIT

  ;Handle letter digit
HIGH_DIGIT
	LD R6, ASCII_LET
  ADD R3, R3, #-10

  ;Print the digit to console
PRINT_DIGIT
  ST R0, PD_IN
	ADD R0, R3, R6
	OUT
  LD R0, PD_IN

  ;Check if all digits printed
	ADD R1,R1,#1
	ADD R6,R1,#-4
	BRn DIGIT_LOOP

PRINT_DATA_RET
  ;Callee-saved registers
  LD R1, PD_R1
  LD R2, PD_R2
  LD R3, PD_R3
  LD R6, PD_R6
  LD R7, PD_R7
  RET

;PRINT_DATA
PD_R1 .BLKW #1
PD_R2 .BLKW #1
PD_R3 .BLKW #1
PD_R6 .BLKW #1
PD_R7 .BLKW #1
PD_IN .BLKW #1
ASCII_NUM .FILL x0030
ASCII_LET .FILL x0041

.END
