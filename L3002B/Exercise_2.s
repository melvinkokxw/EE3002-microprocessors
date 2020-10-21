ram_base 		EQU 0x40000000

				AREA Exercise2, CODE, READONLY

				ENTRY
				LDR r0, =0x40000200 ; Load address of table of h(m) values
				LDR r1, =0x40000300 ; Load address of table of x(n-m) values

				MOV r2, #7 ; Start counter m at 7
				MOV r3, #0 ; Clear r3 for accumulating multiplication later
				MOV r4, #0 ; Clear r4 for accumulating multiplication later

				LDR	sp, =ram_base + 0x0100
				
				STMFD sp!, {r0-r4}
				BL digitalfilter
				LDMFD sp!, {r0-r5}
				
				LDR r6, =0x40000400 ; Load address to store output
				
				STR r0, [r6] ; Store output into 0x4000 0400

stop			B		stop

digitalfilter	STMFD	sp!, {lr}
				STMFD	sp!, {lr} ; Move the stack pointer down by 1 more
				LDR r0, [sp, #8] ; Load h(m) (coefficients) table address
				LDR r1, [sp, #12] ; Load x(n-m) (input data) table address
				LDR r2, [sp, #16] ; Load counter
				LDR r3, [sp, #20] ; Load higher 32 bits of accumulator value
				LDR r4, [sp, #24] ; Load lower 32 bits of accumulator value

Loop			SUBS r2, r2, #1 ; Reduce m by 1
				LDR r5, [r0, r2, LSL #2] ; Load h(m) from htable
				LDR r6, [r1, r2, LSL #2] ; Load x(n-m) from xtable 
				SMLAL r4, r3, r5, r6 ; Multiply h(m) with x(n-m) and store into r3 & r4, Q49.15 format

				BNE Loop ; Loop if m not equal 0
				
				MOV r9, r4, LSR #15 ; Extract first 17 bits of r4 into last 16 bits of r9
				ORR r9, r9, r3, LSL #17; Move the last 15 bits from r3 into the first 15 bits of r9

				STR r9, [sp, #4] ; Store output into stack to return to main routine

				; The code below checks if first 18 bits of r3 are identical
				; If they are not identical (Z flag cleared), this indicates a signed overflow

				MOV r7, r3, ASR #14
				CMP r7, r3, ASR #15

				LDMFD	sp!, {pc}

				END