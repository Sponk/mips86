
all:

fpu-test:
	@echo "************************************************************"
	@echo Executing fpu-test...
	@iverilog -Iinclude fpu/*.v ../src/fpu/*.v -o $(BINDIR)/fpu-test
	@$(BINDIR)/fpu-test
	@echo Finished fpu-test.
	@echo "************************************************************"

alu-test:
	@echo "************************************************************"
	@echo Executing alu-test...
	@iverilog -Iinclude alu/*.v ../src/alu/*.v -o $(BINDIR)/alu-test
	@$(BINDIR)/alu-test
	@echo Finished alu-test.
	@echo "************************************************************"

extend-test:
	@echo "************************************************************"
	@echo Executing extend-test...
	@iverilog -Iinclude extender/*.v ../src/extender/*.v -o $(BINDIR)/extend-test
	@$(BINDIR)/extend-test
	@echo Finished extend-test.
	@echo "************************************************************"

utils-test:
	@echo "************************************************************"
	@echo Executing utils-test...
	@iverilog -Iinclude utils/*.v ../src/utils/*.v -o $(BINDIR)/utils-test
	@$(BINDIR)/utils-test
	@echo Finished utils-test.
	@echo "************************************************************"

ram-test:
	@echo "************************************************************"
	@echo Executing ram-test...
	@iverilog -Iinclude ram/*.v ../src/ram/*.v -o $(BINDIR)/ram-test
	@$(BINDIR)/ram-test
	@echo Finished ram-test.
	@echo "************************************************************"

rom-test:
	$(MAKE) -C os
	@echo "************************************************************"
	@echo Executing rom-test...
	@iverilog -Iinclude rom/*.v ../src/rom/*.v -o $(BINDIR)/rom-test
	@cd $(BINDIR) && ./rom-test
	@echo Finished rom-test.
	@echo "************************************************************"

mmu-test:
	$(MAKE) -C os
	@echo "************************************************************"
	@echo Executing mmu-test...
	@iverilog -Iinclude ../platform/simulation/*.v mmu/*.v ../src/mmu/*.v ../src/rom/*.v ../src/ram/*.v -o $(BINDIR)/mmu-test
	@cd $(BINDIR) && ./mmu-test
	@echo Finished mmu-test.
	@echo "************************************************************"

opcode-buffer-test:
	$(MAKE) -C os
	@echo "************************************************************"
	@echo Executing opcode-buffer-test...
	@iverilog -Iinclude ../platform/simulation/*.v opcode-buffer/*.v ../src/opcode-buffer/*.v ../src/mmu/*.v ../src/rom/*.v ../src/ram/*.v -o $(BINDIR)/opcode-buffer-test
	@cd $(BINDIR) && ./opcode-buffer-test
	@echo Finished opcode-buffer-test.
	@echo "************************************************************"

dataflow-test:
	$(MAKE) -C bios
	$(MAKE) -C os
	@echo "************************************************************"
	@echo Executing dataflow-test...
	@iverilog -Iinclude ../platform/simulation/*.v ../src/extender/*.v ../src/utils/*.v dataflow/*.v ../src/opcode-buffer/*.v ../src/mmu/*.v ../src/rom/*.v ../src/ram/*.v ../src/dataflow/*.v ../src/alu/*.v -o $(BINDIR)/dataflow-test
	@cd $(BINDIR) && ./dataflow-test
	@echo Finished dataflow-test.
	@echo "************************************************************"

emu-test:
	# $(MAKE) -C bios test
	# $(MAKE) -C os test
	# $(BINDIR)/mips86emu $(BINDIR)/kernel.bin

clean:
	@rm -rf $(BINDIR)/*
	$(MAKE) -C bios clean
	$(MAKE) -C os clean
