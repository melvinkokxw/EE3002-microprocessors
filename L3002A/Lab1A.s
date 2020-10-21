		AREA Exercise1A, CODE, READONLY
		ENTRY
		MOV	r0, #10
		MOV	r1, r0

Loop	SUBS r1, r1, #1 ; Updates flags
		ADDNE r0, r1, r0
		BNE Loop ; Loop until R1 reaches zero
		
Stop	B Stop

		END