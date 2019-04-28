;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 
;; PRACTICA 4
;; AUTORES: Victoria Pelayo e Ignacio Rabunnal$
;; Pareja 21 grupo 2301
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

CODIGO SEGMENT
	ASSUME CS : CODIGO
	ORG 256	
INICIO: 
XOR AX,AX
MOV AL, DS:[80h]

MOV AH,9
MOV DX, OFFSET CLR_PANT
INT 21H

CMP AL,0
JE IMPRIMIR_
CMP AL,3
JNE IMPRIMIR_
JMP ARGUMENTOS
JMP FINAL

IMPRIMIR_:
	CALL IMPRIMIR
	JMP FINAL

ARGUMENTOS:
	;SI TODO VA BIEN HAY 3 ARGUMENTOS
	CMP AL, 3
	JNE IMPRIMIR_
	
	MOV AX, DS:[82h]
	CMP AL, '/'
	JNE IMPRIMIR_
	CMP AH, 'I' ;CASO INSTALAR DRIVE
	JE INSTALACION
	CMP AH, 'D' ;CASO DESINSTALAR DRIVER
	JE DESINSTALACION
	JNE IMPRIMIR_	;SI NO ES IGUAL A LOS ANTERIORES MAL PARAMETRO
	
INSTALACION:
	MOV AH,9
	MOV DX, OFFSET INSTALANDO
	INT 21H
	CALL INSTALADOR
	JMP FINAL

DESINSTALACION:
	MOV AH,9
	MOV DX, OFFSET DESINSTALANDO
	INT 21H
	CALL DESINSTALADOR
	
;Fin del programa
FINAL:
	MOV AX, 4C00h
	INT 21h
	
; VARIABLES GLOBALES
	CLR_PANT DB 1BH,"[2","J$"
	TABLA_L DB "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
	TABLA_N DW "43","44","45","46","51","52","53","54","55","56","61","62","63","64","65","66","11","12","13","14","15","16","21","22","23","24","25","26","31","32","33","34","35","36","41","42"
	ESTADO DB 1BH,"[1;1fEstado de instalacion: $"
	INST_SI DB 1BH,"[2;3fEl driver esta instalado$"
	INST_NO DB 1BH,"[2;3fEl driver no esta instalado$"
	NUM_GRUPO DB 1BH,"[4;1fNumero de grupo en Polibio: 31 32 25 26.$" 
	NOMBRES DB 1BH,"[6;1fAutores: Victoria Pelayo e Ignacio Rabunnal$"
	INSTRU DB 1BH,"[8;1fInstrucciones: $"
	INSTRUCCIONES DB 1BH,"[9;3fEjecutar el programa con el parametro /I si quiere instalar el driver$"
	INSTRUCCIONES_2 DB 1BH,"[10;3fEjecutar el programa con el parametro /D si quiere desinstalar el driver$"
	FALLO DB 1BH, "[7;1fNo se han introducido los parametros correctos$"
	YA_INS DB 1BH, "[3;2fEl driver ya esta instalado$"
	INSTALANDO DB 1BH, "[1;1FINSTALANDO...$"
	DESINSTALANDO DB 1BH, "[1;1FDESINSTALANDO...$"
	INSTALADO DB 0
	OK DB 1BH, "[1;5FOK$"
	OTRO DB 1BH, "[1;5FERROR. Ya hay otro driver instalado$"
	OTRO2 DB 1BH, "[1;5FERROR. No hay driver que desinstalar$"
	AUX DB 1BH, "[9:1FComprobando ah$"
	COD DB 1BH, "[9:1FHa seleccionado pasar a Polibio$"
	DECOD DB 1BH, "[9:1FHa seleccionado decodificar Polibio$"
;RUTINA IMPRIMIR INFORMACION CUANDO NO HAY PARAMETROS DE ENTRADA
IMPRIMIR PROC 
	CMP AL,0
	JE INI
	MOV AH,9
	MOV DX, OFFSET FALLO	;CUANDO NO SE HAN INTRODUCIDO BIEN LOS ARGUMENTOS
	INT 21H
	CMP AL,3
	JNE IN_
INI:
	MOV DX, OFFSET ESTADO
	INT 21H
	
	MOV AX,0
	MOV ES,AX
	CMP ES:[57H*4], OFFSET RSI
	JE READY
	MOV AX, CS
	CMP ES:[57H*4+2], AX
	JE READY
	
	NO_READY:
		MOV AH,9
		MOV DX, OFFSET INST_NO
		INT 21H
		JMP NG
	READY: 
		MOV AH,9
		MOV DX, OFFSET INST_SI
		INT 21H
	NG:	
		MOV DX, OFFSET NUM_GRUPO
		INT 21H
		MOV DX, OFFSET NOMBRES
		INT 21H
		MOV DX, OFFSET INSTRU
		INT 21H
	IN_:MOV DX, OFFSET INSTRUCCIONES
		INT 21H
		MOV DX, OFFSET INSTRUCCIONES_2
		INT 21H
	RET
IMPRIMIR ENDP

; RUTINA DE SERVICIO A LA INTERRUPCIÓN
RSI PROC FAR
	PUSHF
	PUSH DX
	;COMPARAMOS AH CON 9 PARA UTILIZAR FUNCION ADICIONAL
	CMP AH, 9
	JE COMPROBAR
	
	CMP AH, 10
	JE COD_
	
	CMP AH,11
	JE DECOD_
	
COD_:
	MOV AH,9
	MOV DX, OFFSET COD
	INT 21H
	MOV AX, 0CAFEh
	JMP FIN
	
DECOD_:
	MOV AH,9
	MOV DX, OFFSET DECOD
	INT 21H
	JMP FIN
	
COMPROBAR:
	MOV AH, 1 ;NUMERO QUE HEMOS DECIDIDO
	
FIN:
	POP DX
	POPF
	IRET
RSI ENDP

INSTALADOR PROC 
	;MIRAMOS SI ESTA YA INSTALADO
	MOV AX, 0
	MOV ES, AX
	MOV BX, ES:[57H*4]
	CMP BX,000H
	JNE OTRO_
	MOV AX, 0
	MOV ES, AX
	MOV BX, ES:[57H*4+2]
	CMP BX,000H
	JNE OTRO_

INSTALACION_: 

	MOV INSTALADO, 1
	
	MOV AH,9
	MOV DX, OFFSET OK
	INT 21H
	POP BX

	CLI 
	MOV ES:[ 57H*4 ], OFFSET RSI
	MOV ES:[ 57H*4+2 ], CS
	STI 
	MOV DX, OFFSET INSTALADOR 
	INT 27H ; ACABA Y DEJA RESIDENTE ; PSP, VARIABLES Y RUTINA RSI. 
	
	HECHO:
		MOV AH,9
		MOV DX, OFFSET YA_INS
		INT 21H
		RET
	OTRO_:
		MOV AH,9
		MOV DX, OFFSET OTRO
		INT 21H
		RET
INSTALADOR ENDP 

DESINSTALADOR PROC ; DESINSTALA RSI DE INT 57H
	PUSH AX BX CX DS ES
	
	;SI NO HAY NINGUN DRIVER INSTALADO
	MOV AX, 0
	MOV ES, AX
	MOV BX, ES:[57H*4]
	CMP BX,000H
	JE NO_
	MOV AX, 0
	MOV ES, AX
	MOV BX, ES:[57H*4+2]
	CMP BX,000H
	JE NO_
	
	
	MOV AH,9
	MOV DX, OFFSET OK
	INT 21H
	
	MOV CX, 0
	MOV DS, CX ; SEGMENTO DE VECTORES INTERRUPCIÓN
	MOV ES, DS:[ 57H*4+2 ] ; LEE SEGMENTO DE RSI
	MOV BX, ES:[ 2CH ] ; LEE SEGMENTO DE ENTORNO DEL PSP DE RSI
	MOV AH, 49H
	INT 21H ; LIBERA SEGMENTO DE RSI (ES)
	MOV ES, BX
	INT 21H ; LIBERA SEGMENTO DE VARIABLES DE ENTORNO DE RSI
	;PONE A CERO VECTOR DE INTERRUPCIÓN 57H
	CLI
	MOV CX,0
	MOV DS:[ 57H*4 ], CX ; CX = 0
	MOV DS:[ 57H*4+2 ], CX
	STI
	
FN:	POP ES DS CX BX AX
	RET
	
NO_:
	MOV AH,9
	MOV DX, OFFSET OTRO2
	INT 21H
	JMP FN
DESINSTALADOR ENDP

; TRADUCIR PROC NEAR
	; ;RECIBIMOS EN AX LA LETRA
	; PUSH SI BX
	; MOV SI, 0
	
	; OTRA_MAS: 
		; MOV BL, TABLA_L[SI]
		; INC SI
		; CMP BX, AX
		; JNE OTRA_MAS
	
	; MOV AX, TABLA_N[SI-1]
	; POP BX SI
; TRADUCIR ENDP

CODIGO ENDS 
END INICIO