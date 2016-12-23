;print_binary
;Prints out the binary equivalent of word to the console. Inputs are
;provided by the inputX.asm files and the output should be printed to the

; WRITTEN BY JACOB HUTTER
; PRINTS BINARY REPRESENTATION OF HEXADECIMAL NUMBER STORED AT ADDRESS X4000
;
;console

;Inputs:
;  x4000 - input to be printed

;Outputs;
;  Printed to console
;R1-->counter for the 16 bits of binary
;R0-->USED FOR TRAP X21 ROUTINE
;R2-->HOLDS CHANGEABLE VALUE OF HEX VALUE STORED AT X4000, IE NUMBER THAT IS BEING TESTED AND PRINTED

.ORIG x3000

MAIN
			AND R1,R1,#0 ; clear the value of R1
			ADD R1,R1,#8 ;
			ADD R1,R1,#8 ; ADD 16 to use as counter
			LDI R2,IN1   ; Load val at X4000 into R2
CHECK		ADD R2,R2,#0 ; Reference R1 for branching reasons
			BRZP POSITIVE ; branch if number is positve
			LD  R0,ONE   ; load ascii char of one into r0 
			OUT          ; print one
			ADD R2,R2,R2 ; shift bits of R2 over one (adding it to itself or multiplying by 2)
			ADD R1,R1,#-1; decrement counter
			BRZ DONE
			BR  CHECK
POSITIVE    LD  R0,ZERO  ; load ascii value of zero into R0
			OUT          ; Print zero
			ADD R2,R2,R2 ; double R2, shift bits
			ADD R1,R1,#-1; decrement counter
			BRZ DONE     ; branch if counter is zero
			BR CHECK     ; unconditional branch back to check R2

DONE        HALT
 	 
IN1  .FILL x4000
ZERO .FILL x0030
ONE  .FILL x0031

.END
