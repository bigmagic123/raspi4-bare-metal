SECTIONS {
	/*
	* First and formost we need the .init section, containing the code to 
        * be run first. We allow room for the ATAGs and stack and conform to 
        * the bootloader's expectation by putting this code at 0x8000.
	*/
    . = 0x8000;
    .text : { 
        KEEP(*(.text.boot)) 
        *(.text .text.* .gnu.linkonce.t*) 
    }

	/* 
	* Next we put the data.
	*/
	.data : {
		*(.data)
	}

  .bss : {
        . = ALIGN(16);
        __bss_start = .; 
        *(.bss*) 
        *(COMMON*) 
        __bss_end = .;
    }
}
__bss_size = (__bss_end - __bss_start) >> 3;