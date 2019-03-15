;*************************************************************************
; Autores: Victoria Pelayo e Ignacio Rabunnal
; grupo: 2301
; Practica 2 apartado A
;*************************************************************************

;**************************************************************************
; DEFINICION DEL SEGMENTO DE DATOS
DATOS SEGMENT
	matriz db 2,2,3,4,5,6,7,8,9
	positivas dw 3 dup(?)
	negativas dw 3 dup(?)
	CLR_PANT 	DB 	1BH,"[2","J$"
	PREGUNTA 	DB 	1BH,"Introducir datos (1) o calcular valor por defecto (2)?"
	ELECCION DB ?
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
; FIN DE LAS INICIALIZACIONES
; COMIENZO DEL PROGRAMA

MOV AH,9	; BORRA LA PANTALLA
MOV DX, OFFSET CLR_PANT
INT 21H

MOV DX,OFFSET PREGUNTA		;MUESTRA "ESCRIBE ...
INT 21H

MOV AH,0AH			;ALMACENA LA ELECCION TECLEADA
MOV DX,OFFSET ELECCION





; FIN DEL PROGRAMA
MOV AX, 4C00h
INT 21h
INICIO ENDP

DET PROC NEAR
	;;EMPIEZA EL CALUCLO DEL DETERMINANTE

	MOV AL, matriz[0]
	IMUL matriz[4]
	IMUL matriz[8]

	MOV positivas[0], AX

	MOV AL, matriz[2]
	IMUL matriz[3]
	IMUL matriz[7]

	MOV positivas[1], AX

	MOV AL, matriz[1]
	IMUL matriz[5]
	IMUL matriz[6]

	MOV positivas[2], AX

	;;;

	MOV AL, matriz[2]
	IMUL matriz[4]
	IMUL matriz[6]

	MOV negativas[0], AX

	MOV AL, matriz[0]
	IMUL matriz[5]
	IMUL matriz[7]

	MOV negativas[1], AX

	MOV AL, matriz[1]
	IMUL matriz[3]
	IMUL matriz[8]

	MOV negativas[2], AX

	;;
	MOV AX, positivas[0]
	ADD AX, positivas[1]
	ADD positivas[2], AX

	MOV AX, negativas[0]
	ADD AX, negativas[1]
	ADD negativas[2], AX

	MOV AX, negativas[2]
	SUB positivas[2], AX
	; FIN DEL SEGMENTO DE CODIGO
DET ENDP 
CODE ENDS
; FIN DEL PROGRAMA INDICANDO DONDE COMIENZA LA EJECUCION
END INICIO