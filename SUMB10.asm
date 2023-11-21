ORG 1000H ; Set variables
	LNGTH EQU 9 ; Total length
	FNUM DB LNGTH DUP(030H)
	CLOSE DB 01H
	SNUM DB LNGTH DUP(030H)
	CLOSE2 DB 01H
	RESULT DB LNGTH DUP(030H)
    CLOSE3 DB 00H
	AMT_DI DB 03H
	INIT_TXT DB "Programa para sumar 2 numeros en base 10"
	NEND DB 00H
	SEC_TXT DB "Ingrese el primer numero. Ingrese enter para continuar" 
	NEND2 DB 00H ;End of SEC_TXT
	THIRD_TXT DB "Ingrese el segundo numero. Ingrese enter para continuar" 
	NEND3 DB 00H ;End of THIRD_TXT
	FO_TXT DB "El resultado es:" 
	NEND4 DB 00H ;End of THIRD_TXT
	MDIGITS1 DB "De cuantas cifras es el numero?" 
	NEND5 DB 00H ;End of THIRD_TXT
ORG 3000H ;**********ALL Methods Here********
PRINT_INIT:	MOV AL, OFFSET NEND - OFFSET INIT_TXT ; Move to AL how many characters print
	MOV BX, OFFSET INIT_TXT ; Move to BX dir of INIT_TXT
	INT 7 ; INT 7 to print INIT_TXT
	RET
PRINT_DIG: MOV AL, OFFSET NEND5 - OFFSET MDIGITS1 ; Move to AL how many characters print 	
	MOV BX, OFFSET MDIGITS1 ; Move to BX dir of MDIGITS1
	INT 7 ; INT 7 to print SEC_TXT
	RET
GETDIG1: MOV BX, OFFSET AMT_DI
	INT 6 ;INT 6 to get the int from user
	SUB BYTE PTR[BX], 030H
	MOV DL, [BX] ; Could skip
	CMP DL, 08H
	JNS EXIT
	JS GETODIG1
	EXIT: INT 0
GETODIG1: RET
PRINT_SEC: MOV AL, OFFSET NEND2 - OFFSET SEC_TXT ; Move to AL how many characters print 	
	MOV BX, OFFSET SEC_TXT ; Move to BX dir of SEC_TXT
	INT 7 ; INT 7 to print SEC_TXT
	MOV AX, OFFSET CLOSE ; Prepare GETNUM1
	SUB AL, AMT_DI
	RET
GETNUM1: MOV BX, AX
	INT 6 ;INT 6 to get the int from user
	MOV DL, [BX] ; Could skip
	CMP BYTE PTR[BX], 0DH ;CMP if user hit enter
	JZ GETOUT1 ; End Loop
	INC AX ;DEC 1 to AX dir
	CALL GETNUM1 ;Call GETNUM1 to receive a new number
GETOUT1: MOV BYTE PTR[BX], 030H 
	RET ;END of GETNUM1
PRINTNUM1: MOV AL, OFFSET CLOSE - OFFSET FNUM ;Print the entire number entered by user
	MOV BX, OFFSET FNUM
	INT 7
	RET
PRINT_THIRD: MOV AL, OFFSET NEND3 - OFFSET THIRD_TXT ; Move to AL how many characters print
	MOV BX, OFFSET THIRD_TXT ; Move to BX dir of THIRD_TXT
	INT 7 ; INT 7 to print THIRD_TXT
	MOV AX, OFFSET CLOSE2 ; Prepare GETNUM2
	SUB AL, AMT_DI
	RET ; END OF PRINT_THIRD
GETNUM_2: MOV BX, AX
	INT 6 ;INT 6 to get the int from user
	MOV DL, [BX] 
	CMP BYTE PTR[BX], 0DH ;CMP if user hit enter
	JZ GETOUT_2 ; End Loop
	INC AX ;DEC 1 to AX dir
	CALL GETNUM_2 ;Call GETNUM2 to receive a new number
GETOUT_2: MOV BYTE PTR[BX], 030H  
	RET ;END of GETNUM2
PRINT_N2: MOV AL, OFFSET CLOSE2 - OFFSET SNUM ;Print the entire number entered by user
	MOV BX, OFFSET SNUM
	INT 7
	RET ; END PRINT_N2
PRINT_FO: MOV AL, OFFSET NEND4 - OFFSET FO_TXT ; Move to AL how many characters print 	
	MOV BX, OFFSET FO_TXT ; Move to BX dir of FO_TXT
	INT 7 ; INT 7 to print FO_TXT
	RET ; PRINT_FO
ORG_D:	MOV BX, OFFSET CLOSE
	MOV CX, OFFSET CLOSE2
	MOV DX, OFFSET CLOSE3
	MOV CH, BL
	MOV DH, DL
	MOV AH, 00H
	RET ; END ORG_D
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
	RET ; END ADDI
PRINT_RES: MOV AL, OFFSET CLOSE3 - OFFSET RESULT ;Print the entire number entered by user
	MOV BX, OFFSET RESULT
	INT 7
	RET ; END PRINT_RES
ORG 2000H ; ***********Main program***********
	CALL PRINT_INIT
	CALL PRINT_DIG
	CALL GETDIG1
	CALL PRINT_SEC
	CALL GETNUM1
	CALL PRINTNUM1
	CALL PRINT_DIG
	CALL GETDIG1
	CALL PRINT_THIRD
	CALL GETNUM_2
	CALL PRINT_N2
	CALL ORG_D
	CALL ADDI
	CALL PRINT_FO
	CALL PRINT_RES
	HLT
END

