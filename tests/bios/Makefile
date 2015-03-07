SRCS=$(wildcard *.c *.asm)
OBJS=$(addsuffix .o,$(basename $(SRCS)))

CFLAGS=-nostdlib -static -mabi=32

%.o : %.c
	mips64-linux-gnu-gcc $(CFLAGS) $< -o $@

%.o : %.asm
	mips64-linux-gnu-as $(ASFLAGS) -g2 $< -o $@

all: $(OBJS)
	mips64-linux-gnu-ld $(OBJS) -T link.ld -o $(BINDIR)/bios.elf	
	mips64-linux-gnu-objcopy -O binary $(BINDIR)/bios.elf $(BINDIR)/bios.bin
	$(BINDIR)/bin2hex $(BINDIR)/bios.bin > $(BINDIR)/kernel.hex

test: all
	@cp bios.bin $(BINDIR)

clean:
	@rm -rf *.o
	@rm -rf bios.bin
	@rm -rf bios.elf

.PHONY: clean
