ORG 1000H ; Set variables
	LNGTH EQU 9 ; Total length
	FNUM DB LNGTH DUP(030H)
	CLOSE DB 01H
	SNUM DB LNGTH DUP(030H)
	CLOSE2 DB 01H
	RESULT DB 9 DUP(030H)
    CLOSE3 DB 00H
	init_txt DB "Programa para sumar 2 numeros en base 10"
	NEND DB 00H
	sec_txt DB "Ingrese el primer numero de maximo 8 digitos.  Ingrese enter para continuar" 
	NEND2 DB 00H ;End of sec_txt
	third_txt DB "Ingrese el segundo numero de maximo 8 digitos. Ingrese enter para continuar" 
	NEND3 DB 00H ;End of third_txt
	fo_txt DB "El resultado es:" 
	NEND4 DB 00H ;End of third_txt
ORG 3000H ;**********ALL Methods Here********
PRINT_INIT:	MOV AL, OFFSET NEND - OFFSET init_txt ; Move to AL how many characters print
	MOV BX, OFFSET init_txt ; Move to BX dir of init_txt
	INT 7 ; INT 7 to print init_txt
	RET
PRINT_SEC: MOV AL, OFFSET NEND2 - OFFSET sec_txt ; Move to AL how many characters print 	
	MOV BX, OFFSET sec_txt ; Move to BX dir of sec_txt
	INT 7 ; INT 7 to print sec_txt
	RET
GETNUM1: MOV BX, AX
	INT 6 ;INT 6 to get the int from user
	MOV DL, [BX] 
	CMP BYTE PTR[BX], 0DH ;CMP if user hit enter
	JZ GETOUT1 ; End Loop
	DEC AX ;DEC 1 to AX dir
	CALL GETNUM1 ;Call GETNUM1 to receive a new number
GETOUT1: MOV BYTE PTR[BX], 030H 
	RET ;END of GETNUM1
PRINTNUM1: MOV AL, OFFSET CLOSE - OFFSET FNUM ;Print the entire number entered by user
	MOV BX, OFFSET FNUM
	INT 7
	RET
PRINT_THIRD: MOV AL, OFFSET NEND3 - OFFSET third_txt ; Move to AL how many characters print
	MOV BX, OFFSET third_txt ; Move to BX dir of third_txt
	INT 7 ; INT 7 to print third_txt
	RET
GETNUM_2: MOV BX, AX
	INT 6 ;INT 6 to get the int from user
	MOV DL, [BX] 
	CMP BYTE PTR[BX], 0DH ;CMP if user hit enter
	JZ GETOUT_2 ; End Loop
	DEC AX ;DEC 1 to AX dir
	CALL GETNUM_2 ;Call GETNUM2 to receive a new number
GETOUT_2: MOV BYTE PTR[BX], 030H  
	RET ;END of GETNUM2
PRINT_N2: MOV AL, OFFSET CLOSE2 - OFFSET SNUM ;Print the entire number entered by user
	MOV BX, OFFSET SNUM
	INT 7
	RET
PRINT_FO: MOV AL, OFFSET NEND4 - OFFSET fo_txt ; Move to AL how many characters print 	
	MOV BX, OFFSET fo_txt ; Move to BX dir of fo_txt
	INT 7 ; INT 7 to print fo_txt
	RET
ADDI: DEC CH
	DEC CL
	DEC DH
	MOV BL, CH
	MOV AL, [BX]
	SUB AL, 030H
	MOV BL, CL
	MOV DL, [BX]
	SUB DL, 030H
	ADD AL,DL
	ADD AL, AH
	MOV AH, 00H
	CMP AL, 09H
	JNS CARRY
	JS KP
	CARRY: MOV AH, 1
	SUB AL,0AH
	KP: MOV BL, DH
	ADD AL, 030H
	MOV [BX], AL 
	CMP BX, OFFSET RESULT
	JNZ ADDI
	RET
PRINT_RES: MOV AL, OFFSET CLOSE3 - OFFSET RESULT ;Print the entire number entered by user
	MOV BX, OFFSET RESULT
	INT 7
	RET
ORG 2000H ; ***********Main program***********
	CALL PRINT_INIT
	CALL PRINT_SEC
	MOV AX, OFFSET CLOSE - 1
	CALL GETNUM1
	CALL PRINTNUM1
	CALL PRINT_THIRD
	MOV AX, OFFSET CLOSE2 - 1
	CALL GETNUM_2
	CALL PRINT_N2
	MOV BX, OFFSET CLOSE
	MOV CX, OFFSET CLOSE2
	MOV DX, OFFSET CLOSE3
	MOV CH, BL
	MOV DH, DL
	MOV AH, 00H
	CALL ADDI
	CALL PRINT_FO
	CALL PRINT_RES
	HLT
END

