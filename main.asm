;author: KerimAksak
   
; INPUT RULE: Period must be added for each digit of numbers.
; EXAMPLE INPUT: 1.123
include 'emu8086.inc'
DATA SEGMENT
    DIGIT DW 0 ; Number of digits 
    PreviousValue DW 10 
    INPUTVALUE DW 0
    SUMOFNUMBERS DB 0
    TEMP1 DW ?
    TEMP2 DW ?
    TEMP3 DW ?
    TEMP4 DW ?
    MSG1 DB 10,13,"Please enter a number (Max: 65.536 <2^16>)...: $"
    MSG2 DB 10,13,"ERROR! <Two points cannot be made one after the other.> $"   
    MSG3 DB 10,13,"Input value received... $"
    MSG4 DB 10,13,"FIBO continuation... $" 
    MSG5 DB 10,13,"The limit has been reached! $"
ENDS


CODE SEGMENT
ASSUME DS:DATA CS:CODE
START:
    PUSH    BP     ; local variable
    MOV     BP, SP ; local variable 
   
    MOV AX,DATA
    MOV DS,AX
    LEA DX,MSG1
    ;print screen
    MOV AH,9
    INT 21H 
              
    MOV CX, 7H ; loop for 6 value(dot+number)
    label:
        ; into data <data is in AL>
        MOV AH,1
        INT 21H
        
        CMP AL, 0DH   ; ASCII(enter) = 0D 
        JE equalEnter ; If the entered value is ENTER, jump to equalEnter
            
        CMP AL, 2EH ; ASCII(dot<.>) = 2E  
        JA above2E  ; If the entered value is greater than 2E, jump to above2E
        
        CMP BYTE PTR [BP-20], AL
        JE equalPoint ; If the entered two value equal, jump to equalPoint (ONLY ABOVE 2E VALUE) 
        
        MOV BYTE PTR [BP-20], AL
        LOOP label
        JMP continue ; If the entered number reaches the max digit, jump to continue 
        
    above2E: ; ASCII(0-9 number) = 30-39 / If the number is entered, proceed without checking
        MOV BYTE PTR [BP-20], AL
        SUB AL,30H ; convert ASCII to decimal
        INC DIGIT  ; digit ++
        XOR AH, AH ; clear AH
        PUSH AX
        LOOP label

    equalPoint: ; If there are two dots, show an error message and end to process
        LEA DX,MSG2
        MOV AH,9
        INT 21H
        
    equalEnter:
        ;LEA DX,MSG3
        ;MOV AH,9
        ;INT 21H
        JMP continue
        ; The continuation of the program should be here
        
    continue: ; End of user input and next process.(fibo) 
        MOV CX, DIGIT
        MOV DI, 1 ; Let's start directly at 10^1. Then we add the value 10^0 to the result.
         
        MOV BYTE PTR [BP-28],1 ; Counter to compare the number of digits
        MOV DI,1 
        POP BX ; Let's take the first element in the stack. 10^0 value will be added directly! 
        MOV AX,PreviousValue
        JMP convertToHex
        
    convertToHex: ; Since the entered numbers consist of a single digit in decimal, 
                  ;  we keep this by converting to hexadecimal.
        
        POP SI    ; Multiplying other values by their base values.
        
        MUL DI    ; DI = 10^1, 10^2, ...
        MOV PreviousValue, AX ; Since the base product progresses as 10^n (n = 1,2,3, ...), 
                              ;   we constantly keep the previous value and multiply it by it.
                              
        MUL SI
        ADD WORD PTR [BP-36], AX ; Summing the base product results. (x*10^1 + x*10^2 + ...)
        MOV AX, PreviousValue
        MOV DI,10
        INC BYTE PTR [BP-28]
        MOV DX, WORD PTR [BP-28]  
        CMP DX, DIGIT ; If our counter reaches the step value, the process is complete.
        JE  fiboLabel
        JMP convertToHex
        
     fiboLabel:
        ADD WORD PTR [BP-36],BX ; Let's add the value 10 ^ 0.
        XCHG BX,WORD PTR [BP-36] 
        MOV INPUTVALUE, BX
        
        ; clear stack
        PUSH    BP     ; local variable
        MOV     BP, SP ; local variable 
        
        ;LEA DX,MSG4
        ; print screen
        ;MOV AH,9
        ;INT 21H
        CALL ENDL
        CALL FIBO
        
     fiboDone:       
        LEA DX,MSG5
        ; print screen
        MOV AH,9
        INT 21H
        
        JMP endOfFibonacci
            
; start of process
FIBO PROC NEAR     
    MOV SI, 1  ; Fibonacci initial value
    MOV DI, 0  ; Fibonacci(n-1) n = 1
    MOV DI, 1  ; Fibonacci(n)   n = 1

    MOV CX, 1  ; 10^n_digits  
        
    loopA:     
        MOV AX, SI   ; Prepare for counting digits
        MOV BX, 10   ; Print as decimal
        MOV SUMOFNUMBERS, 0 ; Zeroing the sum for each number 
        
    loopDigit:  
        XCHG AX, CX  ; Calculate 10^n_digits
        MUL  BX
        XCHG CX, AX
        XOR  DX, DX  
        DIV  BX
        OR   AX, AX  ; Test if the quotient is 0
        JNZ  loopDigit

        MOV  BX, SI
        MOV  BP, 10
        
    loopPrint: 
        MOV  AX, CX   ; Need to divide cx by 10 first
        XOR  DX, DX
        DIV  BP
        MOV  CX, AX
        MOV  AX, BX   ; Get the number
        XOR  DX, DX
        DIV  CX
        MOV  BX, DX   ; The next number to be printed 
        MOV  DL, AL   ; The quotient, current digit 
        ; Every digit -DL-
        MOV BYTE PTR [BP-28], DL ; Last digit
        ADD SUMOFNUMBERS, DL     ; Addition of numbers
 
        ADD  DL, 30H  ; convert to ASCII
        MOV  AH, 2H       
            
        ; control place SI ???
        
        INT  21H
        CMP  CX, 1       ; Should end? - ZF is triggered when flag is 1!
        ; All division rules
        MOV BYTE PTR [BP-44], 1
        ; Next case: JMP Division by 2 rule
        MOV TEMP1, AX ; Do not lose values
        MOV TEMP2, BX
        MOV TEMP3, DX
        MOV TEMP4, CX
        JE CALL DIVISIONBYTWO
        afterDivisionIntoTwoRet:
        CMP  CX, 1
        JE CALL DIVISIONBYTHREE
        afterDivisionIntoThreeRet:
        CMP  CX, 1 
        JE CALL PRIMECONTROL  
        postPrimeRet:   
        MOV AX, TEMP1 
        MOV BX, TEMP2
        MOV DX, TEMP3
        MOV CX, TEMP4 
               
        CMP  CX, 1  
        JNZ  loopPrint

        ADD  DI, SI      ; Fibonacci(n) = Fibonacci(n-1) + Fibonacci(n-2)
        JC   done        ; Overflow, done!
        XCHG DI, SI      ; To keep them in order; si = F(n); di = F(n-1)
        
        ;Comparison of input value and fibonacci number.
        CMP SI,InputValue ; first input > second input
        JG  fiboDone
        
        CALL ENDL 
        JMP  loopA
    done:
        RET   
FIBO ENDP


ENDL PROC NEAR      ; a new line function
    PUSH DX         ; don't lose values
    PUSH AX         ; don't lose values
    MOV DL, 0DH     ; \r
    MOV AH, 02H  
    INT 21h  
    MOV DL, 0AH     ; \n
    MOV AH, 02H
    INT 21H 
    POP AX
    POP DX
    RET
ENDL ENDP

DIVISIONBYTWO PROC NEAR 
    XOR AX, AX ; clear
    XOR BX, BX ; clear
    XOR DX, DX ; clear
     
    MOV AL, BYTE PTR [BP-28] ; Last digit value
    MOV BL, 2 ; division value
    DIV BL
    CMP AH, 0
    JE  dividedByTwo
    
    JMP notDividedTwo
        dividedByTwo:
            XOR AH, AH
            ;PRINT ' "2 Divided"'
            ;LEA DX,MSG6
            ;MOV AH,9
            ;INT 21H  
    notDividedTwo:            
    
    JMP afterDivisionIntoTwoRet 
DIVISIONBYTWO ENDP


DIVISIONBYTHREE PROC NEAR 
    XOR AX, AX ; clear
    XOR BX, BX ; clear
    XOR DX, DX ; clear
     
    MOV AL, SUMOFNUMBERS ; Sum of number
    MOV BL, 3 ; division value
    DIV BL
    CMP AH, 0
    JE  dividedByThree
    
    JMP notDividedThree
        dividedByThree:
            XOR AH, AH
            ;PRINT ' "3 Divided"'
            ;LEA DX,MSG6
            ;MOV AH,9
            ;INT 21H  
    notDividedThree:            
    
    JMP afterDivisionIntoThreeRet 
DIVISIONBYTHREE ENDP

PRIMECONTROL PROC NEAR
    XOR AX, AX ; clear
    XOR BX, BX ; clear
    XOR DX, DX ; clear   
    ; SI control
    MOV AX, SI ; control number
    MOV CX, SI ; loop for number
    MOV BX, 1  ; division border 
    mov BYTE PTR [BP-44], 0 ; If BYTE PTR [BP-44] is 2, the number is prime, if BYTE PTR [BP-44] is more than 2, it is not.
    
    edgeLoop:
        MOV AX, SI ; prime check number 
        MOV DX, 0  ; clear
        DIV BX     ; 1 < BX <primt check number
        CMP DL, 0  ; if it divides completely
        JE divided
        nextNum:
        INC BX
        LOOP edgeLoop
        
        JMP notDivided
            divided:
                INC BYTE PTR [BP-44] ;++1 for the divisible number 
                JMP nextNum
    notDivided:
    
    
    CMP BYTE PTR [BP-44],2  ; If it only has two divisors. (1 and prime chech number)
    JE crossedTheBorder 
    
    JMP notCrossTheBorder
        crossedTheBorder:
        PRINT ' PRIME'    ; Prime print on screen 
    
    notCrossTheBorder:
    JMP postPrimeRet
PRIMECONTROL ENDP

; end of process
   
   
    endOfFibonacci:            
END START
                                   
