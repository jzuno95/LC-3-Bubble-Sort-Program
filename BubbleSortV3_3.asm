; Bubble Sort Program - LC3
; Reads 8 integers (0-100)
; Rejects invalid characters and invalid ranges
; Includes stack PUSH/POP routines

        .ORIG x3000

        LD R6,STACKSTART

        LEA R0,TITLE
        PUTS

;====================
; Read input
;====================

        LEA R5,ARRAY
        AND R4,R4,#0

INPUTLOOP

        ADD R0,R4,#-8
        BRzp SORTSTART

GETVALUE

        LEA R0,PROMPT
        PUTS

        JSR READNUM

; invalid character returns xFFFF

        ADD R0,R1,#1
        BRz GETVALUE

; value >100 ?

        LD R2,NEG100
        ADD R0,R1,R2
        BRp INVALID

        STR R1,R5,#0

        ADD R5,R5,#1
        ADD R4,R4,#1

        BRnzp INPUTLOOP


INVALID

        LEA R0,INVALIDMSG
        PUTS

        BRnzp GETVALUE


;====================
; Bubble sort
;====================

SORTSTART

        AND R2,R2,#0
        ADD R2,R2,#7

OUTER

        LEA R5,ARRAY
        AND R3,R3,#0

INNER

        LDR R0,R5,#0
        LDR R1,R5,#1

        NOT R7,R1
        ADD R7,R7,#1
        ADD R7,R0,R7

        BRnz NOSWAP

        STR R1,R5,#0
        STR R0,R5,#1

NOSWAP

        ADD R5,R5,#1
        ADD R3,R3,#1

        NOT R7,R2
        ADD R7,R7,#1
        ADD R7,R3,R7

        BRn INNER

        ADD R2,R2,#-1
        BRp OUTER


;====================
; Print results
;====================

        LEA R0,RESULT
        PUTS

        LEA R5,ARRAY
        AND R4,R4,#0

PRINTLOOP

        ADD R0,R4,#-8
        BRzp DONE

        LDR R1,R5,#0
        JSR PRINTNUM

        LD R0,SPACE
        OUT

        ADD R5,R5,#1
        ADD R4,R4,#1

        BRnzp PRINTLOOP


DONE
        HALT


;====================
; Read number
;====================

READNUM

        ADD R0,R7,#0
        JSR PUSH

        ADD R0,R2,#0
        JSR PUSH

        ADD R0,R3,#0
        JSR PUSH

        AND R1,R1,#0

READCHAR

        GETC
        OUT

; Enter

        ADD R2,R0,#-10
        BRz INPUTDONE

        ADD R2,R0,#-13
        BRz INPUTDONE


; below '0' ?

        LD R2,NEGASCII
        ADD R2,R0,R2
        BRn BADINPUT


; above '9' ?

        LD R2,NEGASCII57
        ADD R2,R0,R2
        BRp BADINPUT


; convert ASCII

        LD R2,NEGASCII
        ADD R0,R0,R2


; R1=R1*10+digit

        ADD R3,R1,R1

        ADD R2,R1,R1
        ADD R2,R2,R2
        ADD R2,R2,R2

        ADD R1,R3,R2
        ADD R1,R1,R0

        BRnzp READCHAR


BADINPUT

        LEA R0,INVALIDCHAR
        PUTS

; return xFFFF

        AND R1,R1,#0
        ADD R1,R1,#-1

INPUTDONE

        JSR POP
        ADD R3,R0,#0

        JSR POP
        ADD R2,R0,#0

        JSR POP
        ADD R7,R0,#0

        RET


;====================
; Print number
;====================

PRINTNUM

        ADD R0,R7,#0
        JSR PUSH

        ADD R0,R2,#0
        JSR PUSH


; special case 100

        LD R2,NEG100
        ADD R0,R1,R2
        BRnp NOT100

        LD R0,ONEASCII
        OUT

        LD R0,ZEROASCII
        OUT

        LD R0,ZEROASCII
        OUT

        BRnzp PRINTDONE


NOT100

        ADD R0,R1,#-10
        BRn SINGLE

        AND R2,R2,#0

COUNT10

        ADD R1,R1,#-10
        BRn LAST

        ADD R2,R2,#1
        BRnzp COUNT10


LAST

        ADD R1,R1,#10

        LD R0,ASCII48
        ADD R0,R0,R2
        OUT


SINGLE

        LD R0,ASCII48
        ADD R0,R0,R1
        OUT


PRINTDONE

        JSR POP
        ADD R2,R0,#0

        JSR POP
        ADD R7,R0,#0

        RET


;====================
; Stack routines
;====================

PUSH
        ADD R6,R6,#-1
        STR R0,R6,#0
        RET

POP
        LDR R0,R6,#0
        ADD R6,R6,#1
        RET


TITLE         .STRINGZ "Bubble Sort Program"
PROMPT        .STRINGZ "\nEnter number: "
RESULT        .STRINGZ "\nSorted values: "

INVALIDMSG    .STRINGZ "\nInvalid input. Enter value 0-100"
INVALIDCHAR   .STRINGZ "\nInvalid character"

ARRAY         .BLKW #8

SPACE         .FILL x0020

ASCII48       .FILL x0030
ONEASCII      .FILL x0031
ZEROASCII     .FILL x0030

NEGASCII      .FILL xFFD0
NEGASCII57    .FILL xFFC7
NEG100        .FILL xFF9C

STACKSTART    .FILL x4000

        .END