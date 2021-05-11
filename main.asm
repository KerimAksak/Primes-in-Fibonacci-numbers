;name "hi-world"
   
; macros
WRITE_STRING MACRO string_offset     
    MOV DX, OFFSET user_message
    MOV AH, 09H
    INT 21H  
    ENDM ; end macro 
; end of macros


; start main

org 100h  

.data
    user_message DB 'Please give me a number...: ','$'

.code 

    PUSH    BP     ; local variable
    MOV     BP, SP ; local variable
    
    WRITE_STRING user_message 
    
      
    MOV AH, 1H  ; keyboard input subprogram
    INT 21H     ; read character into AL  
      
    
   
    
    MOV BYTE PTR [BP-20], AL ; user input value into WORD PTR [BP-4]
    MOV DI, WORD PTR [BP-20]
    
    
    CALL ASCII2DEC
    
    CALL ENDL   ; new line process
    
    MOV AH, 2H      ; character output subprogram 
    MOV DL, AL      ; copy character to DL 
    INT 21H         ; display character in DL 

ret 

; end of main




; start process

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
ENDL ENDP           ; end process     


ASCII2HEX PROC NEAR
    
    MOV WORD PTR [BP-20], DI
    SUB WORD PTR [BP-20], 30H
    RET
    
ASCII2DEC ENDP
; end of process
                                   
