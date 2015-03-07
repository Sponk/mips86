ENTRY(start)
SECTIONS
{
 . = 0x0000;
 .text : { *(.text) }
 /*. = . + 256;*/
 .data : { *(.data) }
 .bss : { *(.bss COMMON) }
 /*. = ALIGN(8);*/
 /*. = . + 0x1000;*/ /* 4kB of stack memory */
 stack_top = .;
 bios_end = .;
}
