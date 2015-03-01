
export BINDIR="$(CURDIR)/bin"

all:
	@$(MAKE) -s -C tools 
	@$(MAKE) -s -C tests 
	@$(MAKE) -s -C src 

tools:
	@$(MAKE) -s -C tools

clean:
	@$(MAKE) -s -C tools clean
	@$(MAKE) -s -C tests clean
	@$(MAKE) -s -C src clean

alu-test: 
	@$(MAKE) -s -C tests alu-test

test: alu-test

.PHONY: clean tools
