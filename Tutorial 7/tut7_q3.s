		AREA Tut7Q3, CODE, READONLY
		
		ENTRY
		
start
		MOV		r0, #0					; Arithmetic operation choice
		MOV		r1, #3					; Operand 1
		MOV 	r2, #2					; Operand 2
		BL		arithfunc				; Call function

stop 	B		stop

arithfunc
		ADR		r3, jumpTable			; Load address of jump table to r3
		LDR		pc, [r3, r0, LSL #2]
jumpTable
		DCD		DoAdd
		DCD		DoSubtract
		DCD		DoMultiply
DoAdd
		ADD		r4, r1, r2
		BX		lr
DoSubtract
		SUB		r4, r1, r2
		BX		lr
DoMultiply
		MUL		r4, r1, r2
		BX 		lr
		
		END