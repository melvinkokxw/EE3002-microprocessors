		AREA Exercise1B, CODE, READONLY

		ENTRY
		MOV	r0, #10
		MOV	r1, #1
		MOV r2, r1

Loop	SUBS r0, r0, #1 ; Decrease counter
		ADDNE r1, r1, #1 ; Increment number to be added
		ADDNE r2, r1, r2
		BNE Loop ; Loop until R0 reaches zero
		
Stop	B Stop

		END