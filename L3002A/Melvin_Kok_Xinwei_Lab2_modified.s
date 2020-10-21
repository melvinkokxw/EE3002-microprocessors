; The temperature is between 0 to 100 degree Celsius, in Q32.0 format
; r0 contains the counter to extract the 10 temperature values
; r1 contains the loaded temperature in degree Celsius in Q32.0 fixed-point format
; r2 contains the results in degree Fahrenheit in Q32.0 fixed-point format
; Express all constants in the conversion equation in Q17.15 fixed-point format
; Note that multiply Qm.n data by Qp.q data results in Q(m+p).(n+q) data format
; A Fahrenheit table starting at address 0x4000 0100 is used to store the
;temperature in degree Fahrenheit
; There is no need to write down the above comments in your program. But you will
;have to comment on your code.

				AREA Exercise2, CODE, READONLY

				ENTRY
				MOV r0, #10
				LDR r1, =CelsiusTable ; Load address of Celcius table
				LDR r2, =0x40000100 ; Load address of Fahrenheit table
				LDR r3, =0x0000E666 ; Load approximate value of 1.8 in Q17.15 format
				LDR r4, =0x00100000 ; Load constant 32 in Q17.15 format

Loop			LDR r5, [r1], #4 ; Load next value in Celcius table, then increment address
				MUL r6, r5, r3 ; Multiply temperature by 1.8 and store in R6, Q9.23 format
				MOV r6, r6, LSR #8 ; Convert from Q9.23 to Q17.15 format
				ADD r6, r6, r4 ; Add 32 to temperature
				MOV r6, r6, LSR #7 ; Convert to Q24.8 format
				STR r6, [r2], #4 ; Store converted temperature value into Fahrenheit table
				SUBS r0, r0, #1

				BNE Loop

Stop			B Stop
CelsiusTable	DCD 0x00001080, 0x00001199, 0x000012E6, 0x00001419, 0x00001680, 0x00001AB3, 0x00001CE6, 0x00002399, 0x00002433, 0x00002599

				END