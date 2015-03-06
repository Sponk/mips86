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

	# 6 * 6 = 36
	# addi $s0, $0, 6 # $s0 = 6
	# addi $s1, $0, 3 # $s0 = 6 

	# addi $t0, $0, 0
	# addi $t1, $0, 6

# loop:
	# beq $t0, $s1, end

	# addi $s0, $s0, 6 	
	# addi $t0, $t0, 1

	# addi $t3, $0, 0xDE 
	# j loop

.data
string1: .asciiz "Hello World!\n"

