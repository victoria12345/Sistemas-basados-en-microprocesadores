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
			

PUBLIC _createBarCode						;; Hacer visible y accesible la función desde C
_createBarCode PROC FAR 					;; En C es int unsigned long int factorial(unsigned int n)
	PUSH BP 							;; Salvaguardar BP en la pila para poder modificarle sin modificar su valor
	MOV BP, SP	

	PUSH CX BX DX SI DI DS ES;;salvaguardamos los valores de los registros que vamos a usar
	
	
	LES BX, [BP + 16]	;Guardamos en ES el valor del segmento de country code y en BP el del offset
	MOV AX, [BP + 6]	;Country Code
		
	;;-LEEMOS CODIGO PAIS------------------------------------------------------------
	MOV DL, 100
	DIV DL
	ADD AL, 30h	
	MOV ES:[BX], AL; Lo guardamos 1 CIFRA
	
	MOV DL, 10
	MOV AL, AH
	MOV AH, 00h
	DIV DL
	ADD AL, 30h
	ADD AH, 30h
	MOV ES:[BX + 1], AL	;Lo guardamos 2 CIFRA
	MOV ES:[BX + 2], AH	;guardamos 3 CIFRA
	
	;;-LEEMOS CODIGO EMPRESA--------------------------------------------------------
	MOV DX,00h
	MOV AX, [BP + 8]
	MOV CX, 1000
	DIV CX
	ADD AX, 30h	
	MOV ES:[BX + 3], AL; Lo guardamos 1 CIFRA
	
	MOV AX, DX
	MOV DX,100
	DIV DL
	
	ADD AL, 30h
	MOV ES:[BX + 4], AL	;Lo guardamos 2 CIFRA
	
	MOV DL, 10
	MOV AL, AH
	MOV AH, 00h
	DIV DL
	ADD AL, 30h
	ADD AH, 30h
	MOV ES:[BX + 5], AL	;Lo guardamos 2 CIFRA
	MOV ES:[BX + 6], AH	;guardamos 3 CIFRA
	MOV ES:[BX + 7], BYTE PTR(0) ;Annadimos 0 de fin de cadena
	
	;;-CODIGO PRODUCTO---------------------------------------------------------------
	

	FIN:	
		POP ES DS DI SI DX BX CX
		POP BP				;; Restaurar el valor de BP antes de salir
		RET
_createBarCode ENDP						
			
	
	
_TEXT ENDS
END