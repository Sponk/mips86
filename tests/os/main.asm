.globl
start:
	addi $s0, $s0, 5
	addi $s0, $s0, 6

	ori $s1, $s0, 22

	addi $s1, $s1, 12

	j start

