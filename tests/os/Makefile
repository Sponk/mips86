SRCS=$(wildcard *.c *.asm)
OBJS=$(addsuffix .o,$(basename $(SRCS)))

CFLAGS=-nostdlib -static -ffreestanding

%.o : %.c
	mips64-linux-gnu-gcc $(CFLAGS) -g -c $< -o $@

%.o : %.asm
	mips64-linux-gnu-as $(ASFLAGS) -g2 $< -o $@

all: $(OBJS)
	mips64-linux-gnu-ld $(OBJS) -T link.ld -o $(BINDIR)/kernel.elf	
	mips64-linux-gnu-objcopy -O binary $(BINDIR)/kernel.elf $(BINDIR)/kernel.bin
	$(BINDIR)/bin2hex $(BINDIR)/kernel.bin >> $(BINDIR)/kernel.hex

test: all

clean:
	@rm -rf *.o
	@rm -rf kernel.bin
	@rm -rf kernel.elf

.PHONY: clean
