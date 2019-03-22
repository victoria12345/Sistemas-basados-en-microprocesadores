;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 			SBM 2016. Practica 3 - Ejemplo					;
;   Pareja													;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DGROUP GROUP _DATA, _BSS				;; Se agrupan segmentos de datos en uno

_DATA SEGMENT WORD PUBLIC 'DATA' 		;; Segmento de datos DATA p�blico

_DATA ENDS

_BSS SEGMENT WORD PUBLIC 'BSS'			;; Segmento de datos BSS p�blico

_BSS ENDS

_TEXT SEGMENT BYTE PUBLIC 'CODE' 		;; Definici�n del segmento de c�digo
ASSUME CS:_TEXT, DS:DGROUP, SS:DGROUP
			

PUBLIC _factorial						;; Hacer visible y accesible la funci�n desde C
_factorial PROC FAR 					;; En C es int unsigned long int factorial(unsigned int n)
	PUSH BP 							;; Salvaguardar BP en la pila para poder modificarle sin modificar su valor
	MOV BP, SP							;; Igualar BP el contenido de SP
	MOV AX, [BP + 6]					;; Lectura par�metro pasado como valor a esta funcion
	MOV CX, AX							
	MOV AX, 0001H 						;; El valor devuelto por la funci�n se retornar� en AX
	XOR CH,CH 							
	CMP CX, 0000H 						
	JE FIN 								
	MOV DX, 0000H						

	CONT:								
										
		PUSH AX							
		MOV AX, DX						
		MUL CX							
		MOV BX, AX						
		POP AX							
		MUL CX 							
		ADD DX, BX						
		DEC CX 							
		JNE CONT						
	FIN:								
		POP BP							;; Restaurar el valor de BP antes de salir
		RET								;; Retorno de la funci�n que nos ha llamado, devolviendo el resultado del factorial en AX
_factorial ENDP							;; Termina la funcion factorial
_TEXT ENDS
END