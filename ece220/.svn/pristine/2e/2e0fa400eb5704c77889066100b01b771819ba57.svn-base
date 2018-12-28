;Reverse Characters
;n characters are provided to you
;in which n is a positive number stored at x4FFF
;characters stored in sequential memory location
;starting at x5000
;Use the subroutine REVERSE to flip the order

.ORIG x3000
LDI R3,NUM_ADDR 
LD R4,CHAR_ADDR
ADD R3,R4,R3
ADD R3,R3,#-1
ST R3,CHAR_TOP
JSR REVERSE

HALT 





CHAR_TOP .FILL x0000

;REVERSE subroutine:
;reverse the order of n characters starting at x5000
;SWAPMEM subroutine must be called here, not in the main user program
REVERSE
	ST R7,STORE
	LD R0,CHAR_ADDR
	LD R1,CHAR_TOP 
AGAIN	AND R4,R4,#0
	NOT R4,R1
        ADD R4,R4,#1
	ADD R4,R0,R4    ; check if same address 
	BRZ DONE 
	JSR SWAPMEM  
	ADD R0,R0,#1
	ADD R1,R1,#-1 	; decrement addresses
	AND R4,R4,#0    ; check and see if the spaces are one away (even)  
	ADD R4,R0,R4
	ADD R4,R4,#1 
	NOT R4,R4
	ADD R4,R4,#1
	ADD R4,R4,R1
	BRZ DONE1     ; if even switch one last time and then quit 
	BR  AGAIN 
DONE1   JSR SWAPMEM
DONE	LD R7,STORE
	RET

STORE .FILL x0000
;SWAPMEM subroutine:
;address one is in R0, address two in R1
;if mem[R0]=A and mem[R1]=B, then after subroutine call
;   mem[R0]=B and mem[R1]=A
SWAPMEM
    AND R2,R2,#0
    LDR R2,R0,#0     ; get a 
    ST R2,A          ; put a in a 
    LDR R2,R1,#0     ; get b
    ST R2,B
    LD R2,B
    STR R2,R0,#0     ; put b into addres of r0
    LD R2,A     
    STR R2,R1,#0     ; put a inot address of r1
    RET 





A        .FILL x0000
B        .FILL x0000






NUM_ADDR    .FILL x4FFF
CHAR_ADDR   .FILL x5000


.END
