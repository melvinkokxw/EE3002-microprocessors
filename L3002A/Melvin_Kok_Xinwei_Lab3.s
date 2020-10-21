; Assumption of temperature greater than 32 degrees

				AREA Exercise3, CODE, READONLY

				ENTRY
				MOV r0, #10
				LDR r1, =FahrenheitTable ; Load address of Fahrenheit table
				LDR r2, =0x40000100 ; Load address of Fahrenheit table
				LDR r3, =0x0000471C ; Load approximate value of 1/1.8 in Q17.15 format
				LDR r4, =0x00002000 ; Load constant 32 in Q24.8 format

Loop			LDR r5, [r1], #4 ; Load next value from Celcius table into R5, then increment address
				SUB r5, r5, r4 ; Subtract 32 from temperature, Q24.8 format
				MUL r6, r5, r3 ; Multiply temperature by 1/1.8 and store in R6, Q9.23 format
				MOV r6, r6, LSR #15 ; Convert to Q24.8 format
				STR r6, [r2], #4 ; Store converted temperature value into Celcius table
				SUBS r0, r0, #1

				BNE Loop

Stop			B Stop
FahrenheitTable	DCD 0x00003F80, 0x00004080, 0x00004180, 0x00004280, 0x00006480, 0x00006580, 0x000066E6, 0x00006799, 0x00006833, 0x00006999


				END