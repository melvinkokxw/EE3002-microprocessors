		AREA Tut7Q1, CODE, READONLY

counter RN	0				; r0 holds value of n
F_n2 	RN	1				; r1 holds value of F_n-2
F_n1	RN	2				; r2 value of F_n-1
F_n		RN	3				; r3 holds value of F_n
N		RN	4				; r4 holds value of N
table	RN	5				; r5 holds value of table in memory

TABLE_ADD EQU 0x40000000	; Starting address of table in memory

		ENTRY
		
		MOV		table, #TABLE_ADD				; Load starting address of table
		
		MOV 	counter, #0						; Initialise counter to 0
		MOV 	N, #20							; Initialise N to 20
		MOV 	F_n2, #0						; Initialise F_n-2 to 0
		MOV 	F_n1, #1						; Initialise F_n-1 to 1

		MOV 	F_n, F_n2 						; F_n = 0
		STR 	F_n, [table] 					; Store value of F_0
		ADD 	counter, counter, #1			; Increment counter
		
		MOV 	F_n, F_n1 ; F_n = 1
		STR		F_n, [table, counter, LSL #2]	; Store value of F_1
		ADD 	counter, counter, #1			; Increment counter
		
loop	ADD 	F_n, F_n1, F_n2					; Sum of F_n-2 and F_n-1 stored into F_n
		STR 	F_n, [table, counter, LSL #2] 	; Store value of F_n
		MOV 	F_n2, F_n1 						; Assign value of F_n-1 to F_n-2
		MOV 	F_n1, F_n 						; Assign value of F_n to F_n-1
		ADD 	counter, counter, #1			; Increment counter
		
		CMP 	counter, N 						; Compare counter to N
		BLE 	loop							; Loop if counter less than or equal to N
		
stop 	B 		stop
		END