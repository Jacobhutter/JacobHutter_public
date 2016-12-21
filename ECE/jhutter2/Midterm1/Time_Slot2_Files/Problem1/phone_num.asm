.ORIG x3000
	AND R5,R5,#0   
	AND R1,R1,#0       ;PART 1
	AND R4,R4,#0
	AND R2,R2,#0
	ADD R5,R5,#10
INPUT   LDI R3,KBSR 
	BRZP  INPUT
L3      LDI R0,KBDR 
	LDI R3,DSR
	BRZP L3
	STI R0,DDR     ;   part 1 ^^ ^gets input and echoes to terminal
	LD R4,NEW 
	NOT R4,R4
	ADD R4,R4,#1
	ADD R4,R4,R0
	BRZ CHECK 
	LD R4,zero     
	NOT R4,R4
	ADD R4,R4,#1
	ADD R4,R4,R0 ; compare r0 with lower bound of acceptable range 
	BRN WRONG 
	LD R4,NINE 
	NOT R4,R4
	ADD R4,R4,#1  ; compare R0 with upper bound of acceptable range 
	ADD R4,R4,R0  ;
	BRP WRONG     ; if it is wrong it'll just repeat the wrong step
	ADD R5,R5,#-1 ;
	BR  INPUT     ; if counter is not zero loop back up
CHECK	LD R2,GOOD ; check if invalid char was ever typed 
	BRP BAD
	ADD R5,R5,#0
	BRNP BAD       ; if ten bit counter is bad then print a bad message  
        LEA R1,VAL_MSG 
	LDR R0,R1,#0
AGAIN	OUT               ; instrucions say i can use traps in part 2 so this IS allowed *****************
	ADD R1,R1,#1
	LDR R0,R1,#0
	BRNP AGAIN
DONE	HALT
	 
BAD     LEA R1,INV_MSG
	LDR R0,R1,#0
AGAIN1	OUT 
	ADD R1,R1,#1
	LDR R0,R1,#0
	BRNP AGAIN1	
	HALT   
	
	
	
	
	
	 
WRONG   AND R2,R2,#0
	ADD R2,R2,#1
	ST R2,GOOD 
	ADD R5,R5,#-1
	BR  INPUT 
	HALT 

;your program starts here




NEW     .FILL x000D
NINE    .FILL x0039
GOOD   .FILL x0000
zero    .FILL x0030
KBSR    .FILL xFE00
KBDR    .FILL xFE02
DSR     .FILL xFE04
DDR     .FILL xFE06
INV_MSG .STRINGZ "Invalid Phone Number."
VAL_MSG .STRINGZ "Valid Phone Number."

.END
