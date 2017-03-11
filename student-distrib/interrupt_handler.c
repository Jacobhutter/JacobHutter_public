/* Consult x86 ISA manual */
/* Appendix D */
#include "lib.h"
#include "interrupt_handler.h"
void DIVIDE_ERROR() {
    printf("DIVIDE_ERROR");
    while(1);
}

void RESERVED() {
    printf("RESERVED");
    while (1);

}

void NMI_INTERRUPT() {
    printf("NMI_INTERRUPT");
    while (1) {
    }
}

void BREAKPOINT() {
    printf("BREAKPOINT");
    while(1) {
    }
}

void OVERFLOW() {
    printf("OVERFLOW");
    while (1) {
    }
}

void BOUND_RANGE_EXCEEDED() {
    printf("BOUND_RANGE_EXCEEDED");
    while (1) {
    }
}

void INVALID_OPCODE() {
    printf("INVALID_OPCODE");
    while (1) {
    }
}

void DEVICE_NOT_AVAILABLE() {
    printf("DEVICE_NOT_AVAILABLE");
    while (1) {
    }
}

void DOUBLE_FAULT() {
    printf("DOUBLE_FAULT");
    while (1) {
    }
}

void COPROCESSOR_SEGMENT_OVERRUN() {
    printf("COPROCESSOR_SEGMENT_OVERRUN");
    while (1) {
    }
}

void INVALID_TSS() {
    printf("INVALID_TSS");
    while (1) {
    }
}

void SEGMENT_NOT_PRESENT() {
    printf("SEGMENT_NOT_PRESENT");
    while (1) {
    }
}

void STACK_SEGMENT_FAULT() {
    printf("STACK_SEGMENT_FAULT");
    while (1) {
    }

}

void GENERAL_PROTECTION() {
    printf("GENERAL_PROTECTION");
    while (1) {
    }

}

void PAGE_FAULT() {
    printf("PAGE_FAULT");
    while(1) {
    }

}

void FLOATING_POINT_ERROR() {
    printf("FLOATING_POINT_ERROR");
    while (1) {
    }
}

void ALIGNMENT_CHECK() {
    printf("ALIGNMENT_CHECK");
    while (1) {
    }
}

void MACHINE_CHECK() {
    printf("MACHINE_CHECK");
    while (1) {
    }
}

void FLOATING_POINT_EXCEPTION() {
    printf("FLOATING_POINT_EXCEPTION");
    while (1) {
    }
}

void RTC() {
  printf("RTC\n");
  while(1);

}

void KEYBOARD() {
  printf("KEYBOARD\n");
  while(1);
}

void SYSTEM_CALL() {
  printf("SYSTEM CALL\n");
  while(1);

}
