;*************************************************************************
; Autores: Victoria Pelayo e Ignacio Rabunnal
; grupo: 2301
; Practica 2 apartado A
;*************************************************************************

;**************************************************************************
; DEFINICION DEL SEGMENTO DE DATOS
DATOS SEGMENT
	MATRIZ db 2,3,4,5,6,7,8,9,10
	POSITIVAS dw 3 dup(?)
	NEGATIVAS dw 4 dup(?)
	CLR_PANT DB 	1BH,"[2","J$"
	PREGUNTA 	DB 	1BH,"[2;1fIntroducir datos (1) o calcular valor por defecto (2)?$"
	RES_TXT DB 6 dup(?)
	TEXTO_1   DB  1BH,"[1;1fIntroduzca los nueve numeros(entre 15 y -15) separados por espacios$"
	TEXTO_2   DB  1BH,"[1;1fLa opcion elegida es: VALORES POR DEFECTO$"
	TEXTO_L1   DB  1BH,"[5;5f | $"
	TEXTO_L2   DB  1BH,"[6;2f|A|=| $"
	TEXTO_L3   DB  1BH,"[7;5f | $"
	FLAG DB 0
	A DB  1BH,"[6;1f|A| = $"
	TEXTO_ERROR   DB  1BH,"[1;1fOPCION INTRODUCIDA NO VALIDA$"
	LINEA1 DB 30 dup(?)
	ELECCION DB 3 dup(?)
	NUMEROS DB 15 dup(?)
	RESULTADO DW ?
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

MOV ELECCION[0], 3
INT 21H

;El usuario pide introducir los numeros
cmp ELECCION[2], 31h
je JMP_ETIQUETA1

;El usuario elige valores por defecto
cmp ELECCION[2], 32h
je JMP_ETIQUETA2

MOV AH,9	; BORRA LA PANTALLA
MOV DX, OFFSET CLR_PANT
INT 21H

; Cuando el usuario no introduce ni 1 ni 2
MOV DX,OFFSET TEXTO_ERROR		
INT 21H

MOV AX, 4C00h
INT 21h

;; Utiliza los numeros por defecto
JMP_ETIQUETA2:
	MOV AH,9	; BORRA LA PANTALLA
	MOV DX, OFFSET CLR_PANT
	INT 21H

	MOV DX,OFFSET TEXTO_2		
	INT 21H
	
	MOV DX,OFFSET TEXTO_L1	
	INT 21H
	
	CALL DET
	CALL MOSTRAR_LINEA1
	
	;flag pasa a valer 1 porque hay que imprimir resultado
	MOV AX, 1
	MOV FLAG, AL
	
	;Pasamos los valores de la segunda linea a la primera
	MOV AL, MATRIZ[3]
	MOV AH, MATRIZ[4]
	MOV MATRIZ[0], AL
	MOV MATRIZ[1], AH
	MOV AL, MATRIZ[5]
	MOV MATRIZ[2], AL
	
	MOV AH,9
	MOV DX,OFFSET TEXTO_L2	
	INT 21H
	
	CALL MOSTRAR_LINEA1
	
	;Pasamos valores de la tercera linea a la primera
	MOV AL, MATRIZ[6]
	MOV AH, MATRIZ[7]
	MOV MATRIZ[0], AL
	MOV MATRIZ[1], AH
	MOV AL, MATRIZ[8]
	MOV MATRIZ[2], AL
	
	MOV AH,9
	MOV DX,OFFSET TEXTO_L3	
	INT 21H
	
	CALL MOSTRAR_LINEA1
	
	; FIN DEL PROGRAMA
	MOV AX, 4C00h
	INT 21h

;;
;; Etiqueta para introducir datos
JMP_ETIQUETA1:
	MOV AH,9	; BORRA LA PANTALLA
	MOV DX, OFFSET CLR_PANT
	INT 21H

	MOV DX,OFFSET TEXTO_1		
	INT 21H

	MOV AH,0AH			;ALMACENA LA ELECCION TECLEADA
	MOV DX,OFFSET NUMEROS

	MOV NUMEROS[0], 60
	INT 21H
	
	MOV BX,2
	MOV SI,0
	ALMACENAR:
		;Si es un espacio salta a aux
		CMP NUMEROS[BX], 20h
		JE AUX
		
		MOV AX, 1
		CMP NUMEROS[BX], 2Dh
		JNE POSITIVO
		
		;SI ES NEGATIVO ax PASA A VALER -1
		NEG AX	
		INC BX
		
		POSITIVO:
		;Comprobamos si empieza por 1
		CMP NUMEROS[BX], 31h
		JE MULTIPLO_10
		
		GUARDAR:
		MOV CL, 30h
		SUB NUMEROS[BX], CL
		
		IMUL NUMEROS[BX]
		MOV MATRIZ[SI], AL
		
		INC SI
		INC BX
		CMP SI, 9
		
		;Si no ha introduce nueve numeros salta a almacenar el siguiente
		JNE ALMACENAR
		JE FIN
		
		MULTIPLO_10:
		;Si el siguiente caracter es un espacio es el 1
		CMP NUMEROS[BX + 1], 20h
		je GUARDAR 
		;Si es el ultimo numero se guarda
		CMP NUMEROS[BX + 1], 0Dh
		JE GUARDAR
		
		INC BX
		
		;Lo vamos a multiplicar por 10
		MOV CL, 10
		
		MOV CH, 30h
		SUB NUMEROS[BX], CH
		
		ADD CL, NUMEROS[BX]
		IMUL CL
		MOV MATRIZ[SI], AL
		INC SI
		
		;en aux incrementamos BX y saltamos si corresponde a Almacenar
		AUX:
		INC BX
		CMP SI, 9
		JNE ALMACENAR
		JE FIN
	
	FIN:
	
	CALL DET
	
	;A partir de aqui hace la misma rutina que cuando elige la otra opcion
	
	MOV AH,9
	MOV DX,OFFSET TEXTO_L1
	INT 21H
	
	CALL MOSTRAR_LINEA1
	
	MOV AX, 1
	MOV FLAG, AL
	
	MOV AL, MATRIZ[3]
	MOV AH, MATRIZ[4]
	MOV MATRIZ[0], AL
	MOV MATRIZ[1], AH
	MOV AL, MATRIZ[5]
	MOV MATRIZ[2], AL
	
	MOV AH,9
	MOV DX,OFFSET TEXTO_L2	
	INT 21H
	
	CALL MOSTRAR_LINEA1
	
	MOV AL, MATRIZ[6]
	MOV AH, MATRIZ[7]
	MOV MATRIZ[0], AL
	MOV MATRIZ[1], AH
	MOV AL, MATRIZ[8]
	MOV MATRIZ[2], AL
	
	MOV AH,9
	MOV DX,OFFSET TEXTO_L3	
	INT 21H
	
	CALL MOSTRAR_LINEA1
		
	MOV AX, 4C00h
	INT 21h
INICIO ENDP

DET PROC NEAR

	;;EMPIEZA EL CALUCLO DEL DETERMINANTE

	;;POSITIVAS
	;PRIMERA DIAGONAL +
	MOV AX, 000h
	MOV BX, 000h
	MOV AL, MATRIZ[0]
	IMUL MATRIZ[4]
	
	;Hacemos lo siguiente por si matriz[8]es negativo
	MOV BX, AX
	MOV AX, 000h
	MOV AL, 1
	IMUL MATRIZ[8]
	IMUL BX
	MOV POSITIVAS[0], AX
	
	MOV AX, 000h
	MOV BX, 000h
	
	;2 DIAGONAL +
	MOV AL, MATRIZ[2]
	IMUL MATRIZ[3]
	
	MOV BX, AX
	MOV AX, 000h
	MOV AL, 1
	IMUL MATRIZ[7]
	IMUL BX
	MOV POSITIVAS[2], AX
	

	;3 DIAGONAL +
	MOV AX, 000h
	MOV BX, 000h
	MOV AL, MATRIZ[1]
	IMUL MATRIZ[5]
	
	MOV BX, AX
	MOV AX, 000h
	MOV AL, 1
	IMUL MATRIZ[6]
	IMUL BX
	MOV POSITIVAS[4], AX
	

	;;NEGATIVAS
	;1 DIAGONAL -
	MOV AX, 000h
	MOV BX, 000h
	MOV AL, MATRIZ[2]
	IMUL MATRIZ[4]
	MOV BX, AX
	MOV AX, 000h
	MOV AL, 1
	IMUL MATRIZ[6]
	IMUL BX
	MOV NEGATIVAS[0], AX
	

	;2 DIAGONAL -
	MOV AX, 000h
	MOV BX, 000h
	MOV AL, MATRIZ[0]
	IMUL MATRIZ[5]
	MOV BX, AX
	MOV AX, 000h
	MOV AL, 1
	IMUL MATRIZ[7]
	IMUL BX
	MOV NEGATIVAS[2], AX
	

	;3 DIAGONAL -
	MOV AX, 000h
	MOV BX, 000h
	MOV AL, MATRIZ[1]
	IMUL MATRIZ[3]
	MOV BX, AX
	MOV AX, 000h
	MOV AL, 1
	IMUL MATRIZ[8]
	IMUL BX
	MOV NEGATIVAS[4], AX
	
	MOV AX, 000h
	MOV AX, POSITIVAS[0]
	MOV BX, POSITIVAS[2]
	
	;Sumamos los productos de las "diagonales" positivas
	ADD POSITIVAS[4], AX
	ADD POSITIVAS[4], BX
	
	;Sumamos los productos de las "diagonales" negativas
	MOV AX, NEGATIVAS[0]
	MOV BX, NEGATIVAS[2]
	
	ADD NEGATIVAS[4], AX
	ADD NEGATIVAS[4], BX
	
	;Guardamos en positivas el resultado del determinante (POSITIVAS - NEGATIVAS)
	MOV AX, POSITIVAS[4]
	SUB AX, NEGATIVAS[4]
	
	;El resultado guardamos el determinante
	MOV RESULTADO, AX
	RET
	; FIN DEL SEGMENTO DE CODIGO
DET ENDP 

MOSTRAR_LINEA1 PROC NEAR 

	MOV SI, 0
	MOV DI, 0
	MOV DX,0
	
	;Vamos a dividir entre 10 para pasar a ASCII
	MOV BL, 10
SA:	
	;Miramos si el numero es negativo
	CMP MATRIZ[DI], 0
	JS NEGA
POS:
	;GUARDAMOSVALOR ABSOLUTO
	MOV AL, MATRIZ[DI]
SA4:
	;Dividimos entre 10
	MOV AH, 00h
	IDIV BL
	
	;Sumamos al resto 30 para pasar a ASCII
	ADD AH, 30h
	MOV LINEA1[SI], AH
	
	INC SI
	MOV AH, 00h
	
	;Cuando el cociente es 0 ya hemos guardado el numero
	CMP AL, 0
	JNE SA4
	JE OTRO
	
SA2: 
	;IMPRIMIMOS ESPACIO
	MOV DL, 20h
	MOV AH,2
	INT 21H
	
	INC DI
	CMP DI, 3
	
	;DI = 3 cuando llegamos al fin de linea
	JNE SA
	JE SA3
	
	;SI DI ES IGUAL A 3, MOSTRAMOS EL RESULTADO POR PANTALLA
OTRO: 
	;Comprueba si el numero era negativo para imprimir antes '-'
	CMP DX, -1
	JE IMPRIMIR_NEG

IMPRIMIR_POSITIVO:
	;IMPRIMIMOS VALOR ABSOLUTO DEL NUMERO
	MOV DL, LINEA1[SI - 1]
	MOV AH, 2
	INT 21H
	
	DEC SI
	MOV LINEA1[SI], 00h
	
	;Cuando SI es 0 imprimimos un espacio
	CMP SI, 0
	JNE IMPRIMIR_POSITIVO
	JE SA2
	
	;FIN DE LA LINEA
SA3:
	;Imprimimos fin de linea
	MOV DL, '|'
	MOV AH, 2
	INT 21H
	
	;Si estamos en linea 2 llamamos a IMPR_RESULTADO
	CMP FLAG, 1
	JE IMPR_RESULTADO
	
	RET
	
NEGA:
	;Guarda en DX -1 para saber luego que era negativo
	MOV DX,-1
	;Guardamos el valor absoluto
	NEG MATRIZ[DI]
	INC SI
	
	CMP AH,0
	JNE POS
	
IMPRIMIR_NEG:
	;IMPRIMIMOS CARACTER '-'
	MOV DL, 2Dh
	MOV AH, 2
	INT 21H
	
	CMP DL,0
	JNE IMPRIMIR_POSITIVO
	
MOSTRAR_LINEA1 ENDP

IMPR_RESULTADO PROC NEAR

	;Imprimimos " = " 
	MOV DL, ' '
	MOV AH, 2
	INT 21H
	
	MOV DL, '='
	MOV AH, 2
	INT 21H
	
	MOV DL, ' '
	MOV AH, 2
	INT 21H
	
	CMP RESULTADO,0
	JNS INIC
	
	MOV DL, '-'
	MOV AH, 2
	INT 21H
	
	NEG RESULTADO

	;Obtenemos el codigo ASCII del resultado
	;Seguimos el mismo modelo de antes pero con divisiones de 16 bits 
INIC:
	MOV SI, 0
	MOV AX, RESULTADO
	MOV BX, 10
DIVISION:	
	
	MOV DX, 000h
	
	IDIV BX
	
	ADD DX, 30h
	MOV RES_TXT[SI], DL
	
	INC SI
	CMP AX, 0000h
	JNE DIVISION	
	
	;Imprimimos el resultado
IMPRESION_RES:
	MOV DL, RES_TXT[SI - 1]
	MOV AH, 2
	INT 21H
	
	DEC SI
	CMP SI, 0
	JNE IMPRESION_RES
	
	MOV AX, 0
	MOV FLAG, AL
	RET

IMPR_RESULTADO ENDP

CODE ENDS
; FIN DEL PROGRAMA INDICANDO DONDE COMIENZA LA EJECUCION
END INICIO