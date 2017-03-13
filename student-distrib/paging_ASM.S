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
pushl %ebp
movl %esp, %ebp
movl 8(%esp), %eax
movl %eax, %cr3
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
pushl %ebp
movl %esp, %ebp

# Sets bit to allow 4MB pages
movl %cr4, %eax
orl $0x00000012, %eax
movl %eax, %cr4

# Sets bit to enable paging
movl %cr0, %eax
orl $0x80000001, %eax
movl %eax, %cr0
leave
ret
