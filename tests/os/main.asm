.text

.globl start
start:

	addi $s0, $0, 5
	addi $s1, $0, 25
	add $s2, $s1, $s0

	lui $s3, 0xDEAD
	ori $s3, $s3, 0xBEEF	

	lui $s4, 0xCAFE	
	ori $s4, $s4, 0xBABE

	lui $s5, %hi(string1)
	ori $s5, $s5, %lo(string1) 

	nop
	j start

.data
string1: .asciiz "Hello World!\n"

