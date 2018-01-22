ORIGIN 4x0000
    ;; Refer to the LC-3b manual for the operation of each
    ;; instruction.  (LDR, STR, ADD, AND, NOT, BR)
SEGMENT  CodeSegment:
    ;; R0 is assumed to contain zero, because of the construction
    ;; of the register file.  (After reset, all registers contain
    ;; zero.)

    ;; Note that the comments in this file should not be taken as
    ;; an example of good commenting style!!  They are merely provided
    ;; in an effort to help you understand the assembly style.

    LDR  R1, R0, ONE    ; R1 <= 1
    ;; Note that the "ONE" above is a data label.  It is defined near
    ;;  the bottom of the file.
    LDR  R2, R0, TWO    ; R2 <= 2
    LDR  R3, R0, EIGHT  ; R3 <= 8

    ADD R4, R3, R2      ; R4 <= R3 + R2

LOOP1:
    ADD R3, R3, R3      ; R3 <= R3 + R3
    NOT R5, R2          ; R5 <= not(R2)
    ADD R5, R5, R1      ; R5 <= R5 + R1
    ADD R4, R4, R5      ; R4 <= R4 + R5
    BRzp LOOP1          ; Branch if last result was zero or positive.

    AND R7, R3, R4
    STR R7, R0, RESULT
    LDR R1, R0, RESULT
    NOT R0, R7
    AND R0, R1, R0
    STR R0, R0, RESULT

    LDR R1, R0, GOOD

FACTORIAL:
    NOT R1, R0          ; R1 <= ~R0 (clear)
    AND R0, R1, R0      ; R0 <= ~R0 & R0
    LDR R1, R0, FIVE    ; R1 <= 5 (result)
    LDR R2, R0, FIVE    ; R2 <= 5 (counter1)
    LDR R3, R0, NEGONE  ; R3 <= -1 (subtractor)

FLOOP1:
    LDR R4, R0, ZERO    ; R4 <= 0
    LDR R5, R0, ZERO    ; R5 <= 0
    ADD R2, R2, R3      ; R2--
    ADD R5, R5, R2      ; R5 <= R2

FLOOP2:
    ADD R4, R4, R1     ; R4 <= R4 + R1
    ADD R5, R5, R3     ; R5 <= R5 - 1
    BRp FLOOP2         ; branch if R5 > 0
    
    LDR R1, R0, ZERO   ; R1 <= 0
    ADD R1, R4, R1     ; R1 <= R1 + R4
    ADD R2, R2, R0     ; R2 <= R2 + 0
    BRp FLOOP1

HALT:
    BRnzp HALT          ; Infinite loop to keep the processor
                        ; from trying to execute the data below.
                        ; Your own programs should also make use
                        ; of an infinite loop at the end.
NEGONE: DATA2 4xFFFE
ZERO:   DATA2 4x0000
ONE:    DATA2 4x0001
TWO:    DATA2 4x0002
FIVE:   DATA2 4x0005
EIGHT:  DATA2 4x0008
RESULT: DATA2 4x0000
GOOD:   DATA2 4x600D
