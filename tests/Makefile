
all:
	@echo "Not yet implemented!"

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
clean:
	@echo "Not yet implemented!"
