.section .text
.global rev_avg_asm
.type rev_avg_asm, @function

#int rev_avg_asm(int arr[], int len)
#  DESCRIPTION: reverses the array in places and returns the array's average
#  INPUTS: arr -- array
#          len -- length of array
#  OUTPUTS: none
#  RETURN VALUE: average of the array
#  SIDE EFFECTS: reverses the data of arr
#  REGISTERS: %eax - average value
#             %ebx - arr pointer
#             %ecx - len
#             %edx - arr data
#             %edi - arr index
#             %esi - arr index

rev_avg_asm:
  #Sets up the stack
  pushl   %ebp
  movl    %esp, %ebp

  #Callee-saved registers
  pushl   %ebx
  pushl   %edi
  pushl   %esi

  #Insert code here

  #Returns
ret_rev_avg:
  popl    %esi
  popl    %edi
  popl    %ebx
  leave
  ret
