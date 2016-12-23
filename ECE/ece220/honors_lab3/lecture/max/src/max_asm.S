.section .text
.global find_max_asm
.type find_max_asm, @function

#int find_max_asm(int arr[], int len)
#  DESCRIPTION: finds the max value in the array
#  INPUTS: arr -- array
#          len -- length of the array
#  OUTPUTS: none
#  RETURN VALUE: max value
#  SIDE EFFECTS: none
#  Registers: %eax - max value
#             %ebx - arr pointer
#             %ecx - len
#             %edx - arr data
#             %esi - arr index

find_max_asm:
  #Sets up the stack
  pushl   %ebp
  movl    %esp, %ebp

  #Callee-saved registers
  pushl   %ecx
  pushl   %edx
  pushl   %esi

  #Gets params and init registers
  movl    8(%ebp), %ebx           #%ebx = arr
  movl    12(%ebp), %ecx          #%ecx = len
  xorl    %eax, %eax              #%eax = 0
  xorl    %esi, %esi              #%esi = 0

  #Checks params
  cmpl    $0, %ebx                #if arr == NULL
  je      ret_max
  cmpl    $0, %ecx                #if len == 0
  jle     ret_max

  #Loop
  movl    (%ebx, %esi, 4), %eax   #%eax = arr[0]
  incl    %esi                    #%esi++
max_loop:
  cmpl    %ecx, %esi              #if %esi == len
  jge     ret_max

  #Value comparison
  movl    (%ebx, %esi, 4), %edx   #%edx = arr[%esi]
  cmpl    %eax, %edx              
  jle     max_loop_cont           #if %eax < %edx
  movl    %edx, %eax              #%eax = %edx

max_loop_cont:
  incl    %esi                    #%esi++
  jmp max_loop

#Restores registers and returns
ret_max:
  popl    %esi
  popl    %edx
  popl    %ecx
  leave
  ret

