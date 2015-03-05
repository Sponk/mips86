.globl
start:

	addi $s0, $0, 5
	addi $s1, $0, 25
	add $s2, $s1, $s0
		
	nop
	nop
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

# end:
	# j end
