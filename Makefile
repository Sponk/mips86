
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


test: alu-test fpu-test

.PHONY: clean tools
