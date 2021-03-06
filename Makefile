
export BINDIR="$(CURDIR)/bin"

all:
	@$(MAKE) -s -C tools 
	@$(MAKE) -s -C tests 

tools:
	@$(MAKE) -s -C tools

clean:
	@$(MAKE) -s -C tools clean
	@$(MAKE) -s -C tests clean

alu-test: 
	@$(MAKE) -s -C tests alu-test

fpu-test: 
	@$(MAKE) -s -C tests fpu-test

emu-test:
	@$(MAKE) -s -C tests emu-test

extend-test: 
	@$(MAKE) -s -C tests extend-test

utils-test: 
	@$(MAKE) -s -C tests utils-test

ram-test: 
	@$(MAKE) -s -C tests ram-test

rom-test: 
	@$(MAKE) -s -C tests rom-test

mmu-test: 
	@$(MAKE) -s -C tests mmu-test

opcode-buffer-test: 
	@$(MAKE) -s -C tests opcode-buffer-test

dataflow-test: 
	@$(MAKE) -s -C tests dataflow-test

test: all emu-test alu-test fpu-test extend-test utils-test ram-test rom-test mmu-test opcode-buffer-test dataflow-test

statistics:
	@cloc .

lint:
	@verilator --lint-only src/ram/*.v src/rom/*.v src/alu/*.v src/mmu/*.v src/extender/*.v src/utils/*.v src/fpu/*.v src/opcode-buffer/*.v

.PHONY: clean 
