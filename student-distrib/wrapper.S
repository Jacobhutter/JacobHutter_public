#define ASM 1
#include "wrapper.h"
/*
* Wrapper.S
* Assembly linkage for idt to c function
* recieves call by address by processor, pushes all registers and calls c func
*/

.text
.globl _RTC,_KEYBOARD,_SYSTEM_CALL
# exception table is called to give address of each entry in the table
.globl 	_DIVIDE_ERROR,_RESERVED, _NMI_INTERRUPT, _BREAKPOINT, _OVERFLOW, _BOUND_RANGE_EXCEEDED, _INVALID_OPCODE, _DEVICE_NOT_AVAILABLE, _DOUBLE_FAULT, _COPROCESSOR_SEGMENT_OVERRUN, _INVALID_TSS, _SEGMENT_NOT_PRESENT, _STACK_SEGMENT_FAULT, _GENERAL_PROTECTION, _PAGE_FAULT, _FLOATING_POINT_ERROR, _ALIGNMENT_CHECK, _MACHINE_CHECK, _FLOATING_POINT_EXCEPTION, fake_ret

jump_table:
    .long HALT,HALT,EXECUTE,READ,WRITE,OPEN,CLOSE,GETARGS,VIDMAP,SET_HANDLER,SIGRETURN


/*
*_DIVIDE_ERROR:
* routes program to c function, pushes all register
*
*/
_DIVIDE_ERROR:
  pushal
  call DIVIDE_ERROR
  popal
  iret
/*
*_RESERVED:
* routes program to c function, pushes all register
*
*/
_RESERVED:
pushal
call RESERVED
popal
iret
/*
*_NMI_INTERRUPT:
* routes program to c function, pushes all register
*
*/
_NMI_INTERRUPT:
pushal
call NMI_INTERRUPT
popal
iret
/*
*_BREAKPOINT:
* routes program to c function, pushes all register
*
*/
_BREAKPOINT:
pushal
call BREAKPOINT
popal
iret
/*
*_OVERFLOW:
* routes program to c function, pushes all register
*
*/
_OVERFLOW:
pushal
call OVERFLOW
popal
iret
/*
*_BOUND_RANGE_EXCEEDED:
* routes program to c function, pushes all register
*
*/
_BOUND_RANGE_EXCEEDED:
pushal
call BOUND_RANGE_EXCEEDED
popal
iret
/*
*_INVALID_OPCODE:
* routes program to c function, pushes all register
*
*/
_INVALID_OPCODE:
pushal
call INVALID_OPCODE
popal
iret
/*
*_DEVICE_NOT_AVAILABLE:
* routes program to c function, pushes all register
*
*/
_DEVICE_NOT_AVAILABLE:
pushal
call DEVICE_NOT_AVAILABLE
popal
iret
/*
*_DOUBLE_FAULT:
* routes program to c function, pushes all register
*
*/
_DOUBLE_FAULT:
pushal
call DOUBLE_FAULT
popal
iret
/*
*_COPROCESSOR_SEGMENT_OVERRUN:
* routes program to c function, pushes all register
*
*/
_COPROCESSOR_SEGMENT_OVERRUN:
pushal
call COPROCESSOR_SEGMENT_OVERRUN
popal
iret
/*
*_INVALID_TSS:
* routes program to c function, pushes all register
*
*/
_INVALID_TSS:
pushal
call INVALID_TSS
popal
iret
/*
*_SEGMENT_NOT_PRESENT:
* routes program to c function, pushes all register
*
*/
_SEGMENT_NOT_PRESENT:
pushal
call SEGMENT_NOT_PRESENT
popal
iret
/*
*_STACK_SEGMENT_FAULT:
* routes program to c function, pushes all register
*
*/
_STACK_SEGMENT_FAULT:
pushal
call STACK_SEGMENT_FAULT
popal
iret
/*
*_GENERAL_PROTECTION:
* routes program to c function, pushes all register
*
*/
_GENERAL_PROTECTION:
pushal
call GENERAL_PROTECTION
popal
iret
/*
*_PAGE_FAULT:
* routes program to c function, pushes all register
*
*/
_PAGE_FAULT:
pushal
call PAGE_FAULT
popal
iret
/*
*_FLOATING_POINT_ERROR:
* routes program to c function, pushes all register
*
*/
_FLOATING_POINT_ERROR:
pushal
call FLOATING_POINT_ERROR
popal
iret
/*
*_ALIGNMENT_CHECK:
* routes program to c function, pushes all register
*
*/
_ALIGNMENT_CHECK:
pushal
call ALIGNMENT_CHECK
popal
iret
/*
*_MACHINE_CHECK:
* routes program to c function, pushes all register
*
*/
_MACHINE_CHECK:
pushal
call MACHINE_CHECK
popal
iret
/*
*_FLOATING_POINT_EXCEPTION:
* routes program to c function, pushes all register
*
*/
_FLOATING_POINT_EXCEPTION:
pushal
call FLOATING_POINT_EXCEPTION
popal
iret
/*
*_RTC:
* routes program to c function, pushes all register
*
*/
_RTC:
pushal
call RTC
popal
iret
/*
*_KEYBOARD:
* routes program to c function, pushes all register
*
*/
_KEYBOARD:
  pushal
  call KEYBOARD
  popal
  iret
/*
*_SYSTEM_CALL:
* routes program to c function, pushes all register
*
*/
_SYSTEM_CALL:

    pushl %ebx
    pushl %ecx
    pushl %edx
    pushl %edi
    pushl %esi
    pushl %esp
    pushl %ebp
    pushfl

    pushl %edx
    pushl %ecx # push args
    pushl %ebx

    call *jump_table(,%eax,4) # call jump table entry
    fake_ret:
    addl $12,%esp # remove args

    popfl
    popl %ebp
    popl %esp
    popl %esi
    popl %edi
    popl %edx
    popl %ecx
    popl %ebx

    iret
