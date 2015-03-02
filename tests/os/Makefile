SRCS=$(wildcard *.c *.asm)
OBJS=$(addsuffix .o,$(basename $(SRCS)))

%.o : %.c
	mips64-linux-gnu-gcc $(CFLAGS) $< -o $@

%.o : %.asm
	mips64-linux-gnu-as $(ASFLAGS) $< -o $@

all: $(OBJS)
	mips64-linux-gnu-ld $(OBJS) -T link.ld -o kernel.elf	
	mips64-linux-gnu-objcopy --only-section=.text -O binary kernel.elf kernel.bin

test: all
	@cp kernel.bin $(BINDIR)
	$(BINDIR)/mips86emu $(BINDIR)/kernel.bin

clean:
	@rm -rf *.o
	@rm -rf kernel.bin
	@rm -rf kernel.elf

.PHONY: clean
