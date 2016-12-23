.ORIG x3000

;;R5 - frame pointer
;;R6 - stack pointer

;;MAIN - DO NOT CHANGE ANY CODE HERE
  LD R6, STACK
  LD R5, STACK
  LD R1, X_VAL
  LD R2, Y_VAL
  STR R1, R5, #0    ; push x to stack
  STR R2, R5, #-1   ; push y to stack
  ADD R6, R6, #-2   ; space for z

;IMPLEMENT ME: STACK BUILD-UP FOR FOO1
  ADD R6,R6,#-1             ; move to next slot for parameters
  STR R2,R6,#0              ; Store Y val
  ADD R6,R6,#-1
  STR R1,R6,#0       	    ; store x val 
  ADD R6,R6,#-1             ; make space for Z (ret val)
  ADD R6,R6,#-1             ; make space for ret address (R7)
  ADD R6,R6,#-1             ; address for R5 frame pointer
  AND R0,R0,#0
  ADD R0,R5,R0              ; give the address to R0
  STR R0,R6,#0              ; store old frame pointer 
  ADD R6,R6,#-1             ; first slot for local vars
  AND R5,R5,#0
  ADD R5,R6,R5              ; now R5 and R6 point to local vars for FOO1 (total)




;IMPLEMENT ME: CALL FOO1 SUBROUTINE
JSR FOO1  ; call FOO1 
;IMPLEMENT ME: “return 0“
HALT 






FOO1       ; start of FOO1
		STR R7,R5,#2 ; store R7
		AND R0,R0,#0 
		LDR R0,R5,#4 ; get val of x 
		ST R0,X_STORAGE  ; store x 
		BRNZ FINISH
check		 ADD R6,R6,#-1 
		LDR R1,R5,#0
		STR R2,R6,#0
		ADD R6,R6,#-1   ; add space and store y and total
		STR R1,R6,#0
		ADD R6,R6,#-1  ; space for ret val from Foo2
		ADD R6,R6,#-1
		ADD R6,R6,#-1 ; spaces for R7, and R5 
		JSR FOO2
		LD R0,X_STORAGE ;now total has its val
		ADD R0,R0,#-1   ; decrement x 
		ST R0,X_STORAGE 
		BRP check       ; branch back if it is not below zero or zero
FINISH          LDR R0,R5,#0    ; get final total 
		STR R0,R5,#3    ; store in retval
		LDR R7,R5,#2    ; restore R7
		LDR R5,R5,#1    ; re point R5
		AND R0,R0,#0    ; demolition time

;IMPLEMENT ME: STACK TEAR-DOWN FOR FOO1
		STR R0,R6,#0    ;clear total
		ADD R6,R6,#1    
		STR R0,R6,#0    ; clear old FP
		ADD R6,R6,#1    
		STR R0,R6,#0    ; clear R7 storage
		ADD R6,R6,#1    ; point to ret val
		LDR R0,R6,#0    ; get ret val
		STR R0,R5,#-2   ; store in z 
		AND R0,R0,#0    ; back to business
		STR R0,R6,#0    ; clear ret val
		ADD R6,R6,#1    
		STR R0,R6,#0    ; clear x 
		ADD R6,R6,#1    
		STR R0,R6,#0    ; clear y
		ADD R6,R6,#1    ; R6 points to z
		RET 
		
 










;;IMPLEMENT ME: FOO1 SUBROUTINE









;;IMPLEMENT ME: FOO2 SUBROUTINE
FOO2
   STR R7,R6,#1   ;store R7
   AND R0,R0,#0   ; clear 
   ADD R0,R2,R0   ; get val of Y
   LDR R3,R6,#3   ; get currentTotal
   ADD R0,R0,R3   ; do addition
   STR R0,R6,#2   ; store ret val
   AND R0,R0,#0   ; used to tear down stack
   STR R0,R6,#0   ; clear frame pointer 
   ADD R6,R6,#1   ; move to R7 
   LDR R7,R6,#0   ; restore r7
   STR R0,R6,#0   ; kill that line
   ADD R6,R6,#1
   LDR R0,R6,#0   ; get ret val
   STR R0,R5,#0   ; store it in total
   AND R0,R0,#0
   STR R0,R6,#0   ; clear that line
   ADD R6,R6,#1   ;
   STR R0,R6,#0   ; clear parameter 1
   ADD R6,R6,#1   
   STR R0,R6,#0   ; clear parameter 2
   ADD R6,R6,#1   ; now r5 and 6 point to total
   RET 






X_STORAGE .FILL x0000 
STACK .FILL x6000
X_VAL .FILL x5
Y_VAL .FILL x4

.END 
