.text

.globl start
start:

	# lui $s5, %hi(bios_end)
	# ori $s5, $s5, %lo(bios_end) 

	addi $t0, $0, string1
	addi $t1, $0, 512

loop:
	lb $s0, 0($t0)
	
	beq $s0, $0, endloop

	addi $t1, $t1, 1
	addi $t0, $t0, 1
	sb $s0, 0($t1)

	nop
	j loop

endloop:

	nop
	j end

end:
	j end

.data
string1: .asciiz "Hello World!\n\0"

