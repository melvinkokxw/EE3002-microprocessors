				AREA Exercise1, CODE, READONLY

				ENTRY
				LDR r0, =htable ; Load address of table of h(m) values
				LDR r1, =xtable ; Load address of table of x(n-m) values
				LDR r8, =0x40000100 ; Load address to store output
				
				MOV r3, #0 ; Clear r3 for accumulating multiplication later
				MOV r4, #0 ; Clear r4 for accumulating multiplication later

				MOV r7, #3 ; Start second counter at number of samples over 7
SamplesLoop		CMP r7, #0 ; Check if r5 is less than 0
				BLT Stop

				MOV r2, #7 ; Start counter m at 7, as it will be immediately subtracted
InnerLoop		SUBS r2, r2, #1 ; Reduce m by 1
				LDR r5, [r0, r2, LSL #2] ; Load h(m) from htable
				ADD r10, r2, r7 ; Offset the xtable by number of additional samples
				LDR r6, [r1, r10, LSL #2] ; Load x(n-m) from xtable 
				SMLAL r4, r3, r5, r6 ; Multiply h(m) with x(n-m) and store into r3 & r4, Q49.15 format

				BNE InnerLoop ; Loop if m not equal 0
				
				MOV r9, r4, LSR #15 ; Extract first 17 bits of r4 into last 16 bits of r9
				ORR r9, r9, r3, LSL #17; Move the last 15 bits from r3 into the first 15 bits of r9
				
				STR r9, [r8], #4 ; Store output into 0x4000 0100, offset by number of samples

				; The code below checks if first 18 bits of r3 are identical
				; If they are not identical (Z flag cleared), this indicates a signed overflow
				
				MOV r9, r3, ASR #14
				CMP r9, r3, ASR #15
				
				SUBS r7, r7, #1 ; Reduce counter by 1
				B SamplesLoop

Stop			B Stop

htable			DCD 0xFFFFFBE7, 0x000004DD, 0x00000625, 0xFFFFF9DB, 0x00000625, 0x000004DD, 0xFFFFFBE7 ; h(m) for m=0 to m=6 in Q15 format
				; -0.032, 0.038, 0.048, -0.048, 0.048, 0.038, -0.032
xtable			DCD 0x0034, 0xFF24, 0xFF12, 0x0034, 0x0024, 0x0012, 0x0010, 0x0120, 0x0142, 0x0030 ; x(n-m) for m=0 to m=6 in Q0 format
				; 52, 36, 18, 16, 288, 322, 48

				END