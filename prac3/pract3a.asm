;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 			SBM 2016. Practica 3 - Ejemplo					;
;   Pareja													;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DGROUP GROUP _DATA, _BSS				;; Se agrupan segmentos de datos en uno

_DATA SEGMENT WORD PUBLIC 'DATA' 		;; Segmento de datos DATA público

_DATA ENDS

_BSS SEGMENT WORD PUBLIC 'BSS'			;; Segmento de datos BSS público

_BSS ENDS

_TEXT SEGMENT BYTE PUBLIC 'CODE' 		;; Definición del segmento de código
ASSUME CS:_TEXT, DS:DGROUP, SS:DGROUP
			

PUBLIC _computeControlDigit						;; Hacer visible y accesible la función desde C
_computeControlDigit PROC FAR 					;; En C es int unsigned long int factorial(unsigned int n)
	PUSH BP 							;; Salvaguardar BP en la pila para poder modificarle sin modificar su valor
	MOV BP, SP	

	PUSH CX BX DX SI DI		;;salvaguardamos los valores de los registros que vamos a usar
	
	MOV DX,0
	MOV CX, 0
	MOV SI, 6
	MOV DI, 6
	
	LES BX, [BP + DI]
	
SUMA:
	MOV AX, ES:[BP + DI]	;; Lectura parámetro pasado como valor a esta funcion
	
	MOV BX,0h
	SUB AH, 30h			;;LO PASAMOS A DECIMAL
	MOV BL, AH
	ADD DX, BX			;;SUMAMOS EL IMPAR
	
	SUB AL, 30h		;;PASAMOS DE ASCII A DECIMAL
	MOV AH, 00h
	
	MOV BX, 3		;;MULTIPLICAMOS POR 3 LOS PARES
	MUL BL
	
	ADD DX, AX		;;SUMAMOS AL CONTADOR
	
	INC DI
	INC DI			;;SUMAMOS DI+2 PARA LEER SIGUIENTE PAR DE NUMEROS
	DEC SI
	JNZ SUMA
	
	MOV BL, 10
	MOV CX, DX 		;GUARDAMOS RESULTADOD DE LAS SUMAS

DECENA:
	MOV AX,DX
	DIV BL			;;DIVISIMOS ENTRE 10 PARA VER SI ES UNA DECENA
	INC DX		
	CMP AH,0		;PARAMOS CUANDO AX ES MULTIPLO DE 10
	JNE DECENA
	
	MUL BL			;;MULTIPLICAMOS POR 10 PARA OBTENER EL NUMERO, A PARTR DEL COCIENTE
	SUB AX, CX	;GUARDAMOS EL DIGITO DE CONTROL EN AX
	

	FIN:	
		POP DI SI DX BX CX
		POP BP							;; Restaurar el valor de BP antes de salir
_computeControlDigit ENDP						


PUBLIC _decodeBarCode						;; Hacer visible y accesible la función desde C
_decodeBarCode PROC FAR 					;; En C es int unsigned long int factorial(unsigned int n)
	PUSH BP 							;; Salvaguardar BP en la pila para poder modificarle sin modificar su valor
	MOV BP, SP	

	
	LES BX, [BP + 6]

	FIN:	
		POP BP							;; Restaurar el valor de BP antes de salir
_decodeBarCode ENDP					
	
_TEXT ENDS
END