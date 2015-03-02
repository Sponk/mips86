#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

uint32_t registers[32];
uint32_t ip = 0;

struct instruction
{
	unsigned int op : 6;
	unsigned int data : 26;
}__attribute__((packed));

struct r_instruction 
{
	unsigned int op : 6;
	unsigned int rs : 5;
	unsigned int rt : 5;
	unsigned int rd : 5;
	unsigned int shamt : 5;
	unsigned int funct : 6;
}__attribute__((packed));

struct  i_instruction
{
	unsigned int op : 6;
	unsigned int rs : 5;
	unsigned int rt : 5;
	unsigned int imm : 16;
}__attribute__((packed));

struct j_instruction
{

}__attribute__((packed));

int main(int argc, char* argv[])
{
	if(argc <= 1)
	{
		printf("Usage: mips86emu <flat binary>\n");
		return 0;
	}

	const char* fname = argv[1];
	FILE* f = fopen(fname, "rb");

	if(!f)
	{
		printf("Could not open file.\n");
		return 1;
	}

	struct instruction opcode;
	while(fread(&opcode, sizeof(opcode), 1, f) != 0)
	{
		struct instruction inst = (struct instruction) opcode;	
		
		printf("Got opcode: 0x%x (%b)\n", inst.op, inst.op);
	}	

	fclose(f);
	return 0;
}
