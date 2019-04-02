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
	MOV DI,0
	
	;;AQUI ES DONDE TENGO DUDA
	LES BP, [BP + 6]	;Guardamos en ES el valor del segmento de barCodeStr y en BP el del offset
	
SUMA:
	MOV AX, ES:[BP + DI]	;; Lectura parámetro pasado como valor a esta funcion
	MOV BX,0h
	SUB AL, 30h			;;LO PASAMOS A DECIMAL
	MOV BL, AL
	ADD DX, BX			;;SUMAMOS EL IMPAR
	
	SUB AH, 30h		;;PASAMOS DE ASCII A DECIMAL
	MOV AL, AH
	MOV AH, 00h		;;GUARDAMOS EL NUMERO EN AX
	
	MOV BX, 3		;;MULTIPLICAMOS POR 3 LOS PARES
	MUL BL
	
	ADD DX, AX		;;SUMAMOS AL CONTADOR
	
	INC DI
	INC DI			;;SUMAMOS DI+2 PARA LEER SIGUIENTE PAR DE NUMEROS
	DEC SI
	JNZ SUMA
	
	MOV BL, 10
	MOV CX, DX 		;GUARDAMOS RESULTADO DE LAS SUMAS

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
		POP BP				;; Restaurar el valor de BP antes de salir
		RET
_computeControlDigit ENDP						
			
PUBLIC _decodeBarCode					;; Hacer visible y accesible la función desde C
_decodeBarCode PROC FAR 					;; En C es int unsigned long int factorial(unsigned int n)
	PUSH BP 							;; Salvaguardar BP en la pila para poder modificarle sin modificar su valor
	MOV BP, SP	

	PUSH CX BX DX DI AX ES DS ;;salvaguardamos los valores de los registros que vamos a usar
	
	LES BX, [BP + 6] ;Meto en BX el offset y en ES segmento
	
	;;- CODIGO PAIS------------------------------------------------------
	MOV AX, ES:[BX]
	
	; Formamos el codigo pais
	SUB AH, 30h
	SUB AL, 30h
	MOV CX, 00h
	MOV CL, AH ;annadimos las decenas, como unidades
	
	MOV AH, 00h
	MOV DL, 10
	MUL DL
	ADD AX, CX	;Sumamos las centenas, como decenas
	MUL DL 	;ahora lo tenemos de la forma centenas + decenas + 0 unidades
	
	MOV DH, 00h
	MOV DL, ES:[BX + 2] ;Guardamos el ultimo digito
	SUB DL, 30h
	ADD AX, DX
	
	; Lo guardamos
	LDS BX, [BP + 10]	;Meto en BX el offset y en DS segmento
	PUSH BP			;Salvaguardamos el valor de BP
	MOV BP, BX		;Necesitamos utilizar BP para modificar en memoria
	MOV DS:[BP], AX ;Modificamos country-code
	POP BP
	
	
	;; -CODIGO EMPRESA------------------------------------------------------
	
	LES BX, [BP + 6] ;Meto en BX el offset y en ES segmento
	
	
	MOV AX, ES:[BX + 3] ;Guardamos dos primeros digitos
	SUB AH, 30h		;Los transformamos a entero
	SUB AL, 30h
	MOV CX, 00h
	MOV CL, AH ;annadimos la segunda cifra
	
	MOV AH, 00h
	MOV DL, 10
	MUL DL
	ADD AX, CX	;Sumamos la primera cifra, como decenas
	MUL DL
	MOV CX, AX ;1 cifra + 2 cifra + '0'
	
	MOV AX, ES:[BX + 5] ;Guardamos los dos segundos digitos
	SUB AL, 30h		;Los transformamos a entero
	SUB AH, 30h		
	
	MOV DL, AL
	MOV DH, 00h
	ADD CX, DX	;Hemos sumado la tercera cifra
	MOV DH, AH	;Almacenamos la cuarta cifra
	MOV AX, CX
	
	MOV CL,DH	;Almacenamos la cuarta cifra
	MOV CH, 00h
	
	MOV DL, 10
	MOV DH, 00h
	MUL DX
	ADD AX, CX	;Annadimos la ultima cifra

	; Lo guardamos
	LDS BX, [BP + 14]	;Meto en BX el offset y en DS segmento
	PUSH BP			;Salvaguardamos el valor de BP
	MOV BP, BX		;Necesitamos utilizar BP para modificar en memoria
	MOV DS:[BP], AX ;Modificamos codigo-empresa
	POP BP
	
	;;-CODIGO PRODUCTO ------------------------------------------------------
	
	
	
	FIN2:	
		POP DS ES AX DI DX BX CX 
		POP BP				;; Restaurar el valor de BP antes de salir
		RET
_decodeBarCode ENDP			
	
_TEXT ENDS
END