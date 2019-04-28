;*************************************************************************
; Autores: Victoria Pelayo e Ignacio Rabunnal
; grupo: 2301
; Practica 1 apartado A
;*************************************************************************

;**************************************************************************
; DEFINICION DEL SEGMENTO DE DATOS
DATOS SEGMENT
	CLR_PANT DB 1BH,"[2","J$"
	ERROR DB 1BH,"[2;1fNuestro driver no esta instalado$"
	TEXTO DB 1BH, "[2;1f","La cadena es: $"	
	COD DB 1BH, "[3;1f","La cadena de caracteres codificada es: $"	
	DECOD DB 1BH, "[3;1f","La cadena de caracteres decodificada es: $"	
	STRING DB 100 DUP(?)
DATOS ENDS
;**************************************************************************
; DEFINICION DEL SEGMENTO DE PILA
PILA SEGMENT STACK "STACK"
DB 40h DUP (0) ;ejemplo de inicialización, 64 bytes inicializados a 0
PILA ENDS
;**************************************************************************
; DEFINICION DEL SEGMENTO EXTRA
EXTRA SEGMENT
RESULT DW 0,0 ;ejemplo de inicialización. 2 PALABRAS (4 BYTES)
EXTRA ENDS
;**************************************************************************
; DEFINICION DEL SEGMENTO DE CODIGO
CODE SEGMENT
ASSUME CS: CODE, DS: DATOS, ES: EXTRA, SS: PILA
; COMIENZO DEL PROCEDIMIENTO PRINCIPAL
INICIO PROC
; INICIALIZA LOS REGISTROS DE SEGMENTO CON SU VALOR
MOV AX, DATOS
MOV DS, AX
MOV AX, PILA
MOV SS, AX
MOV AX, EXTRA
MOV ES, AX
MOV SP, 64 ; CARGA EL PUNTERO DE PILA CON EL VALOR MAS ALTO

; COMIENZO DEL PROGRAMA

;COMENZAMOS "LIMPIANDO" LA PANTALLA
MOV AH,9
MOV DX, OFFSET CLR_PANT
INT 21H

;MIRAMOS SI NUESTRO DRIVER ESTA INSTALADO
CALL DRIVER
CMP AH,1
JE OK

;SI NO ERROR
MOV AH,9
MOV DX, OFFSET ERROR
INT 21H
JMP FIN

OK:

MOV AH,9
MOV DX, OFFSET TEXTO
INT 21H


; FIN DEL PROGRAMA
FIN:
MOV AX, 4C00h
INT 21h
INICIO ENDP

DRIVER PROC NEAR
	PUSH ES BX
	MOV AX,0
	MOV ES,AX
	
	;COMPROBAMOS QUE NO HAYA NINGUN DRIVER
	MOV BX, ES:[57H*4]
	CMP BX,0
	JNE EXISTE
	MOV BX, ES:[57H*4+2]
	CMP BX,0
	JNE EXISTE
OTRO:	
	MOV AH,0
	JMP FINAL
	
EXISTE:
	;COMPROBAMOS QUE SEA EL NUESTRO
	MOV AH, 09
	INT 57H
	CMP AH,1 ;VALOR QUE HEMOS DECIDIDO QUE DEVUELVA EL NUESTRO
	JNE OTRO ;SI NO ES EL NUESTRO QUE SALTE A OTRO
	MOV AH,1	
	
FINAL:
	POP BX ES
	RET

DRIVER ENDP
CODE ENDS
; FIN DEL PROGRAMA INDICANDO DONDE COMIENZA LA EJECUCION
END INICIO