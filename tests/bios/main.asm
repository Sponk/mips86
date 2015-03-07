
.globl start

start:
	addi $t3, $0, 0x400
	addi $t0, $0, 0x400 # startAddress = $t0 = 0x7F

	addi $s0, $0, bios_end # counter = $s0 = 0
	addi $s1, $s0, 0x100

loop:
	beq $s0, $s1, end
	
	lb $s2, 0($s0)

	sb $s2, 0($t0)

	addi $s0, $s0, 1	
	addi $t0, $t0, 1

	nop
	j loop

end:
	# j end
	jr $t3

