ENTRY(start)
SECTIONS
{
 . = 0x400;
 
 .text : { *(.text) }
 .data : { *(.data) }
 .bss : { *(.bss COMMON) }
/* . = ALIGN(8);
 . = . + 0x1000; /* 4kB of stack memory */
 stack_top = .;
}
