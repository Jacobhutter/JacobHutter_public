/* Consult x86 ISA manual */
/* Appendix D */


uint32_t kbd_eoi = 1;
//https://github.com/arjun024/mkeykernel/blob/master/keyboard_map.h
unsigned char keyboard_map[128] =
{
    0,  27, '1', '2', '3', '4', '5', '6', '7', '8',	/* 9 */
    '9', '0', '-', '=', '\b',	/* Backspace */
    '\t',			/* Tab */
    'q', 'w', 'e', 'r',	/* 19 */
    't', 'y', 'u', 'i', 'o', 'p', '[', ']', '\n',	/* Enter key */
    0,			/* 29   - Control */
    'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l', ';',	/* 39 */
    '\'', '`',   0,		/* Left shift */
    '\\', 'z', 'x', 'c', 'v', 'b', 'n',			/* 49 */
    'm', ',', '.', '/',   0,				/* Right shift */
    '*',
    0,	/* Alt */
    ' ',	/* Space bar */
    0,	/* Caps lock */
    0,	/* 59 - F1 key ... > */
    0,   0,   0,   0,   0,   0,   0,   0,
    0,	/* < ... F10 */
    0,	/* 69 - Num lock*/
    0,	/* Scroll Lock */
    0,	/* Home key */
    0,	/* Up Arrow */
    0,	/* Page Up */
    '-',
    0,	/* Left Arrow */
    0,
    0,	/* Right Arrow */
    '+',
    0,	/* 79 - End key*/
    0,	/* Down Arrow */
    0,	/* Page Down */
    0,	/* Insert Key */
    0,	/* Delete Key */
    0,   0,   0,
    0,	/* F11 Key */
    0,	/* F12 Key */
    0,	/* All other keys are undefined */
};

/*
 * DIVIDE_ERROR;
 *   Inputs: none
 *   Return Value: none
 *	 Function: Output a string to the console
 */
void DIVIDE_ERROR() {
    printf("DIVIDE_ERROR");
    while(1);
}

/*
 * RESERVED;
 *   Inputs: none
 *   Return Value: none
 *	 Function: Output a string to the console
 */
void RESERVED() {
    printf("RESERVED");
    while (1);
    
}

/*
 * NMI_INTERRUPT;
 *   Inputs: none
 *   Return Value: none
 *	 Function: Output a string to the console
 */
void NMI_INTERRUPT() {
    printf("NMI_INTERRUPT");
    while (1) {
    }
}

/*
 * BREAKPOINT;
 *   Inputs: none
 *   Return Value: none
 *	 Function: Output a string to the console
 */
void BREAKPOINT() {
    printf("BREAKPOINT");
    while(1) {
    }
}

/*
 * OVERFLOW;
 *   Inputs: none
 *   Return Value: none
 *	 Function: Output a string to the console
 */
void OVERFLOW() {
    printf("OVERFLOW");
    while (1) {
    }
}

/*
 * BOUND_RANGE_EXCEEDED;
 *   Inputs: none
 *   Return Value: none
 *	 Function: Output a string to the console
 */
void BOUND_RANGE_EXCEEDED() {
    printf("BOUND_RANGE_EXCEEDED");
    while (1) {
    }
}

/*
 * INVALID_OPCODE;
 *   Inputs: none
 *   Return Value: none
 *	 Function: Output a string to the console
 */
void INVALID_OPCODE() {
    printf("INVALID_OPCODE");
    while (1) {
    }
}

/*
 * DEVICE_NOT_AVAILABLE;
 *   Inputs: none
 *   Return Value: none
 *	 Function: Output a string to the console
 */
void DEVICE_NOT_AVAILABLE() {
    printf("DEVICE_NOT_AVAILABLE");
    while (1) {
    }
}

/*
 * DOUBLE_FAULT;
 *   Inputs: none
 *   Return Value: none
 *	 Function: Output a string to the console
 */
void DOUBLE_FAULT() {
    printf("DOUBLE_FAULT");
    while (1) {
    }
}

/*
 * COPROCESSOR_SEGMENT_OVERRUN;
 *   Inputs: none
 *   Return Value: none
 *	 Function: Output a string to the console
 */
void COPROCESSOR_SEGMENT_OVERRUN() {
    printf("COPROCESSOR_SEGMENT_OVERRUN");
    while (1) {
    }
}

/*
 * INVALID_TSS;
 *   Inputs: none
 *   Return Value: none
 *	 Function: Output a string to the console
 */
void INVALID_TSS() {
    printf("INVALID_TSS");
    while (1) {
    }
}

/*
 * SEGMENT_NOT_PRESENT;
 *   Inputs: none
 *   Return Value: none
 *	 Function: Output a string to the console
 */
void SEGMENT_NOT_PRESENT() {
    printf("SEGMENT_NOT_PRESENT");
    while (1) {
    }
}

/*
 * STACK_SEGMENT_FAULT;
 *   Inputs: none
 *   Return Value: none
 *	 Function: Output a string to the console
 */
void STACK_SEGMENT_FAULT() {
    printf("STACK_SEGMENT_FAULT");
    while (1) {
    }
    
}

/*
 * GENERAL_PROTECTION;
 *   Inputs: none
 *   Return Value: none
 *	 Function: Output a string to the console
 */
void GENERAL_PROTECTION() {
    printf("GENERAL_PROTECTION");
    while (1) {
    }
    
}

/*
 * PAGE_FAULT;
 *   Inputs: none
 *   Return Value: none
 *	 Function: Output a string to the console
 */
void PAGE_FAULT() {
    printf("PAGE_FAULT");
    while(1) {
    }
    
}

/*
 * FLOATING_POINT_ERROR;
 *   Inputs: none
 *   Return Value: none
 *	 Function: Output a string to the console
 */
void FLOATING_POINT_ERROR() {
    printf("FLOATING_POINT_ERROR");
    while (1) {
    }
}

/*
 * DIVIDE_ERROR;
 *   Inputs: none
 *   Return Value: none
 *	 Function: Output a string to the console
 */
void ALIGNMENT_CHECK() {
    printf("ALIGNMENT_CHECK");
    while (1) {
    }
}

/*
 * MACHINE_CHECK;
 *   Inputs: none
 *   Return Value: none
 *	 Function: Output a string to the console
 */
void MACHINE_CHECK() {
    printf("MACHINE_CHECK");
    while (1) {
    }
}

/*
 * FLOATING_POINT_EXCEPTION;
 *   Inputs: none
 *   Return Value: none
 *	 Function: Output a string to the console
 */
void FLOATING_POINT_EXCEPTION() {
    printf("FLOATING_POINT_EXCEPTION");
    while (1) {
    }
}

/*
 * RTC;
 *   Inputs: none
 *   Return Value: none
 *	 Function: Output a string to the console
 */
void RTC() {
    uint32_t reg_c;
    uint32_t period_mask = 0x00000040;
    
    reg_c = inb(RTC_C);
    if((reg_c & period_mask) != 0) {
        test_interrupts();
    }
    send_eoi(RTC_IRQ);
}
#define KEYBOARD_ADDR 0x64
#define KEYBOARD_PORT 0x60

/*
 * KEYBOARD;
 *   Inputs: none
 *   Return Value: none
 *	 Function: Outputs a character on interrupt
 */
void KEYBOARD() {
    // write eoi
    unsigned char status;
    char key;
    
    status = inb(KEYBOARD_ADDR);
    if(status & 0x01){
        key = inb(KEYBOARD_PORT);
        if(key < 0)
            return;
        putc(keyboard_map[(int)key]);
    }
    
    send_eoi(kbd_eoi); // 1 is the irq for keyboard
}

/*
 * SYSTEM_CALL;
 *   Inputs: none
 *   Return Value: none
 *	 Function: Output a string to the console
 */
void SYSTEM_CALL() {
    printf("SYSTEM CALL\n");
    while(1);
    
}
