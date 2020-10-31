		AREA Tut7Q2, CODE, READONLY

addr	RN	0		; r0 holds value of current address being searched
key		RN	1		; r1 holds search key
length	RN	2 		; r2 holds length of list
counter	RN	3 		; r3 is the counter
value	RN	4 		; r4 holds value of item being checked
table	RN	5		; r5 holds copy of base address for incrementing list length

		ENTRY
		
		MOV		addr, #0x40000000 		; Starting address of table
		LDR		key, =0x9ABCDEF0 		; Set search key, LDR because number too big for MOV
		MOV		counter, #0 			; Initialise value of counter
		
		LDR 	length, [addr] 			; Load length from table and increment address to point to next value
		
loop	LDR 	value, [addr, #4]!		; Load value from table

		CMP 	key, value 				; Check if value are equal
		BEQ 	stop 					; If equal, end program
		
		ADD 	counter, counter, #1 	; Increment counter
		CMP 	counter, length 		; Ccompare counter and length of list
		BLE 	loop 					; If counter hasn't reached length of list, loop

		STR 	key, [addr, #4]			; Search failed, store search key into end of list
		ADD 	length, length, #1		; Increment length
		STR 	length, [table]			; Store new length of list

stop	B 		stop
		END