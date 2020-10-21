				AREA Exercise2, CODE, READONLY

				ENTRY
				MOV r0, #10
				LDR r1, =CelsiusTable ; Load address of Celcius table
				LDR r2, =0x40000100 ; Load address of Fahrenheit table
				LDR r3, =0x0000E666 ; Load approximate value of 1.8 in Q17.15 format
				LDR r4, =0x00100000 ; Load constant 32 in Q17.15 format

Loop			LDR r5, [r1], #4 ; Load next value in Celcius table, then increment address
				MUL r6, r5, r3 ; Multiply temperature by 1.8 and store in R6, Q17.15 format
				ADD r6, r6, r4 ; Add 32 to temperature
				MOV r6, r6, LSR #15 ; Convert to Q32.0 format
				STR r6, [r2], #4 ; Store converted temperature value into Fahrenheit table
				SUBS r0, r0, #1

				BNE Loop

Stop			B Stop
CelsiusTable	DCD 17, 18, 19, 20, 23, 27, 29, 36, 36, 38

				END