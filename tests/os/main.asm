.text

.globl start
start:
	nop
	# set up stack	
	lui $sp, %hi(stack)
	ori $sp, %lo(stack)

	addi $s3, $s3, 2
	addi $sp, $sp, 0x100 # STACK_SIZE

	# put something on the stack
	addi $s0, $0, 200
	sw $s0, 0($sp)

	lw $s1, 0($sp)
	sw $s1, 0($sp)

	lui $s0, 0xFFFF
	ori $s0, $s0, 0xFFFD

	sw $s3, 0($s0)

	nop
	j start
	# jr $t0 

.data
string1: .asciiz "Hello World!\n"
stack:
