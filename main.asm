;author: KerimAksak
   
; INPUT RULE: Period must be added for each digit of numbers.
; EXAMPLE INPUT: 1.123
DATA SEGMENT
    MSG1 DB 10,13,"Please enter a number (Max: 65.536 <2^16>)...: $"
    MSG2 DB 10,13,"ERROR! <Two points cannot be made one after the other.> $"   
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
              
    MOV CX, 6H ; loop for 6 value(dot+number)
    label:
        ; into data <data is in AL>
        MOV AH,1
        INT 21H
            
        CMP AL, 2EH ; ASCII(dot<.>) = 2E  
        JA above2E  ; If the entered value is greater than 2E, jump to above2E
        
        CMP BYTE PTR [BP-20], AL
        JE equalPoint ; If the entered two value equal, jump to equalPoint (ONLY ABOVE 2E VALUE) 
        MOV BYTE PTR [BP-20], AL
        LOOP label

    above2E: ; ASCII(0-9 number) = 30-39 / If the number is entered, proceed without checking
        MOV BYTE PTR [BP-20], AL
        SUB AL,30H
        LOOP label

    equalPoint: ; If there are two dots, show an error message and end to process
        LEA DX,MSG2
        MOV AH,9
        INT 21H
        END START
                
END START
                                   
