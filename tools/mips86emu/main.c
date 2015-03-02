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

uint32_t swap_uint32(uint32_t val)
{
	val = ((val << 8) & 0xFF00FF00 ) | ((val >> 8) & 0xFF00FF); 
	return val; //(val << 16) | (val >> 16);
}

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

	uint32_t opcode;
	while(fread(&opcode, sizeof(opcode), 1, f) != 0)
	{
		uint32_t op = opcode & (1 << 6) - 1;
		
		if(op == 0)
		{
			uint32_t rs = opcode & ((1 << 5) - 1) << 6;
			uint32_t rt = opcode & ((1 << 5) - 1) << 11;
			uint32_t rd = opcode & ((1 << 5) - 1) << 16;
			uint32_t shamt = opcode & ((1 << 5) - 1) << 21;
			uint32_t func = opcode & ((1 << 6) -1 ) << 26;

			printf("Got opcode: op = 0x%x rs = 0x%x rt = 0x%x rd = 0x%x\n", op,  rs, rt, rd);
		}	
	
	}

	fclose(f);
	return 0;
}
