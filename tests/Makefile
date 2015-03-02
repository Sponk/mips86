
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


emu-test:
	$(MAKE) -C os test

clean:
	@echo "Not yet implemented!"
