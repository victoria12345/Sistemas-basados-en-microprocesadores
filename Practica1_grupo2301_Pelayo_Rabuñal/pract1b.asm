;*************************************************************************
; Autores: Victoria Pelayo e Ignacio Rabunnal
; grupo: 2301
; Practica 1 apartado B
;*************************************************************************

;**************************************************************************
; DEFINICION DEL SEGMENTO DE DATOS
DATOS SEGMENT	
	CONTADOR DB ?
	TOME DW 0CAFEh
	TABLA100 DB 100 dup(?)
	ERROR1 DB  "Atencion: Entrada de datos incorrecta."
	
	
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

MOV AL, ERROR1[2]
MOV TABLA100[63h], AL

;Como TOME son 2 bytes lo movemos a AX y lo guardamos en la tabla en el orden correspondiente
MOV AX, TOME
MOV TABLA100[23h], AL
MOV TABLA100[24h], AH

; Copiamos el byte massignificativo en CONTADOR
MOV CONTADOR, AH

; FIN DEL PROGRAMA
MOV AX, 4C00h
INT 21h
INICIO ENDP
; FIN DEL SEGMENTO DE CODIGO
CODE ENDS
; FIN DEL PROGRAMA INDICANDO DONDE COMIENZA LA EJECUCION
END INICIO