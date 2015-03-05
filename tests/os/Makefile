SRCS=$(wildcard *.c *.asm)
OBJS=$(addsuffix .o,$(basename $(SRCS)))

CFLAGS=-nostdlib -static -mabi=32

%.o : %.c
	mips64-linux-gnu-gcc $(CFLAGS) $< -o $@

%.o : %.asm
	mips64-linux-gnu-as $(ASFLAGS) $< -o $@

all: $(OBJS)
	mips64-linux-gnu-ld $(OBJS) -T link.ld -o $(BINDIR)/kernel.elf	
	mips64-linux-gnu-objcopy --only-section=.text -O binary $(BINDIR)/kernel.elf $(BINDIR)/kernel.bin
	$(BINDIR)/bin2hex $(BINDIR)/kernel.bin > $(BINDIR)/kernel.hex

test: all
	@cp kernel.bin $(BINDIR)
	$(BINDIR)/mips86emu $(BINDIR)/kernel.bin

clean:
	@rm -rf *.o
	@rm -rf kernel.bin
	@rm -rf kernel.elf

.PHONY: clean
