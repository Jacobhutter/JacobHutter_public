//
//  interrupt_handler.h
//  
//
//  Created by Cameron Long on 3/9/17.
//
//

#ifndef interrupt_handler_h
#define interrupt_handler_h

void DIVIDE_ERROR();
void RESERVED();
void NMI_INTERRUPT();
void BREAKPOINT();
void OVERFLOW();
void BOUND_RANGE_EXCEEDED();
void INVALID_OPCODE();
void DEVICE_NOT_AVAILABLE();
void DOUBLE_FALUT();
void COPROCESSOR_SEGMENT_OVERRUN();
void INVALID_TSS();
void SEGMENT_NOT_PRESENT();
void STACK_SEGMENT_FAULT();
void GENERAL_PROTECTION();
void PAGE_FAULT();
void FLOATING_POINT_ERROR();
void ALIGNMENT_CHECK();
void MACHINE_CHECK();
void FLOATING_POINT_EXCEPTION();

#endif /* interrupt_handler_h */
