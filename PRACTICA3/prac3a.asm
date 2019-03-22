;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 			SBM 2016. Victoria Pelayo e Ignacio Rabunnal	;
;   Pareja													;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DGROUP GROUP _DATA, _BSS				;; Se agrupan segmentos de datos en uno

_DATA SEGMENT WORD PUBLIC 'DATA' 		;; Segmento de datos DATA público

_DATA ENDS

_BSS SEGMENT WORD PUBLIC 'BSS'			;; Segmento de datos BSS público

_BSS ENDS

_TEXT SEGMENT BYTE PUBLIC 'CODE' 		;; Definición del segmento de código
ASSUME CS:_TEXT, DS:DGROUP, SS:DGROUP
			

PUBLIC computeControlDigit						;; Hacer visible y accesible la función desde C
computeControlDigit PROC FAR 					;; En C es int unsigned long int factorial(unsigned int n)
	PUSH BP 							;; Salvaguardar BP en la pila para poder modificarle sin modificar su valor
	LES BX, [BP + 6]	

;;LO QUE NOS DABAN DE FACTORAIL					
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
	RET								;; Retorno de la función que nos ha llamado, devolviendo el resultado del factorial en AX
computeControlDigit ENDP							;; Termina la funcion factorial
_TEXT ENDS
END