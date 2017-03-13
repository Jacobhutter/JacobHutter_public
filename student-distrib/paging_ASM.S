#define ASM 1

.text
.globl loadPageDirectory
.globl enablePaging

# reference: http://wiki.osdev.org/Setting_Up_Paging

#
# loadingPageDirectory
#	DESCRIPTION: Loads page directory into cr3
#	INPUTS: pointer to page directoy
#	OUTPUTS: None
#	RETURN VALUE: None
#	SIDE EFFECTS: Loads page directory into cr3
#	clobers eax
loadPageDirectory:
push %ebp
mov %esp, %ebp
mov 8(%esp), %eax
mov %eax, %cr3
leave
ret


#
# enablePaging
#	DESCRIPTION: Enables Paging
#	INPUTS: none
#	OUTPUTS: None
#	RETURN VALUE: None
#	SIDE EFFECTS: Enables Paging
#	clobers eax
enablePaging:
push %ebp

# Sets bit to allow 4MB pages
mov %cr4, %eax
or $0x00000010, %eax
mov %eax, %cr4

# Sets bit to enable paging
mov %esp, %ebp
mov %cr0, %eax
or $0x80000000, %eax
mov %eax, %cr0
leave
ret
