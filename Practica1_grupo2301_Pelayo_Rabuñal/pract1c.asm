;*************************************************************************
; Autores: Victoria Pelayo e Ignacio Rabunnal
; grupo: 2301
; Practica 1 apartado C
;*************************************************************************

;**************************************************************************
; DEFINICION DEL SEGMENTO DE DATOS
DATOS SEGMENT	
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

; No se puede meter directamente un dato al registro DS 
MOV AX, 0535h
; Ahora el valor DS es 0535h
MOV DS,AX
MOV BX, 0210h
MOV DI, 1011h

; Aqui accede a la direccion DS:1234h (de donde obtiene el dato)
MOV AL,DS:[1234h]
; Aqui accede a la direccion DS:0210h (de donde obtiene el dato)
MOV AX,[BX]
; Aqui accede a la direccion DS:1011h (donde guarda el dato)
MOV [DI],AL

; FIN DEL PROGRAMA
MOV AX, 4C00h
INT 21h
INICIO ENDP
; FIN DEL SEGMENTO DE CODIGO
CODE ENDS
; FIN DEL PROGRAMA INDICANDO DONDE COMIENZA LA EJECUCION
END INICIO