;*************************************************************************
; Autores: Victoria Pelayo e Ignacio Rabunnal
; grupo: 2301
; Practica 1 apartado A
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

; Metemos los datos en los registros correspondientes
MOV AX, 15h
MOV BX, 0BBh
MOV CX, 3412h
MOV DX, CX

; La direcciones son de 20 bits, la partimos en segm + offset
MOV AX, 6553h
MOV DS, AX
MOV BH, DS:[6h]

MOV AX, 6553h
MOV DS, AX
MOV BL, DS:[7h]

MOV AX, 5000h
MOV DS, AX
MOV DS:[5h], CH

; Carga el contenido de la direccion que esta 10 bytes por encima que la apuntada por BP
MOV AX, [SI]
MOV BX, [BP] + 10


; FIN DEL PROGRAMA
MOV AX, 4C00h
INT 21h
INICIO ENDP
; FIN DEL SEGMENTO DE CODIGO
CODE ENDS
; FIN DEL PROGRAMA INDICANDO DONDE COMIENZA LA EJECUCION
END INICIO