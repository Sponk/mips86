
.globl start

start:
	addi $t3, $0, 0x400
	addi $t0, $0, 0x400 # startAddress = $t0 = 0x7F

	addi $s0, $0, bios_end # counter = $s0 = 0
	addi $s1, $s0, 0x100

loop:
	nop
	beq $s0, $s1, end
	
	lw $s2, 0($s0)

	sw $s2, 0($t0)

	addi $s0, $s0, 4	
	addi $t0, $t0, 4 

	nop
	j loop

end:
	# j end
	jr $t3

