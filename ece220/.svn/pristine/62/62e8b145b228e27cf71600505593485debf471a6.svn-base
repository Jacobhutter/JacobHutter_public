	.file	"hack_stack.c"
	.text
	.globl	safeChar
	.type	safeChar, @function
safeChar:
.LFB2:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%edi, %eax
	movb	%al, -4(%rbp)
	cmpb	$96, -4(%rbp)
	jle	.L2
	cmpb	$122, -4(%rbp)
	jg	.L2
	movzbl	-4(%rbp), %eax
	jmp	.L3
.L2:
	cmpb	$64, -4(%rbp)
	jle	.L4
	cmpb	$90, -4(%rbp)
	jg	.L4
	movzbl	-4(%rbp), %eax
	jmp	.L3
.L4:
	cmpb	$47, -4(%rbp)
	jle	.L5
	cmpb	$57, -4(%rbp)
	jg	.L5
	movzbl	-4(%rbp), %eax
	jmp	.L3
.L5:
	cmpb	$32, -4(%rbp)
	jne	.L6
	movzbl	-4(%rbp), %eax
	jmp	.L3
.L6:
	cmpb	$46, -4(%rbp)
	jne	.L7
	movzbl	-4(%rbp), %eax
	jmp	.L3
.L7:
	cmpb	$45, -4(%rbp)
	jne	.L8
	movzbl	-4(%rbp), %eax
	jmp	.L3
.L8:
	cmpb	$44, -4(%rbp)
	jne	.L9
	movzbl	-4(%rbp), %eax
	jmp	.L3
.L9:
	cmpb	$40, -4(%rbp)
	jne	.L10
	movzbl	-4(%rbp), %eax
	jmp	.L3
.L10:
	cmpb	$41, -4(%rbp)
	jne	.L11
	movzbl	-4(%rbp), %eax
	jmp	.L3
.L11:
	cmpb	$91, -4(%rbp)
	jne	.L12
	movzbl	-4(%rbp), %eax
	jmp	.L3
.L12:
	cmpb	$93, -4(%rbp)
	jne	.L13
	movzbl	-4(%rbp), %eax
	jmp	.L3
.L13:
	cmpb	$123, -4(%rbp)
	jne	.L14
	movzbl	-4(%rbp), %eax
	jmp	.L3
.L14:
	cmpb	$125, -4(%rbp)
	jne	.L15
	movzbl	-4(%rbp), %eax
	jmp	.L3
.L15:
	movl	$64, %eax
.L3:
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2:
	.size	safeChar, .-safeChar
	.section	.rodata
.LC0:
	.string	"%p: 0x%08x %c%c%c%c\n"
	.text
	.globl	printStack
	.type	printStack, @function
printStack:
.LFB3:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	movl	%esi, -28(%rbp)
	movl	$0, -4(%rbp)
	jmp	.L17
.L18:
	movq	-24(%rbp), %rax
	movl	(%rax), %eax
	sarl	$24, %eax
	movsbl	%al, %eax
	movl	%eax, %edi
	call	safeChar
	movb	%al, -5(%rbp)
	movq	-24(%rbp), %rax
	movl	(%rax), %eax
	sarl	$16, %eax
	movsbl	%al, %eax
	movl	%eax, %edi
	call	safeChar
	movb	%al, -6(%rbp)
	movq	-24(%rbp), %rax
	movl	(%rax), %eax
	sarl	$8, %eax
	movsbl	%al, %eax
	movl	%eax, %edi
	call	safeChar
	movb	%al, -7(%rbp)
	movq	-24(%rbp), %rax
	movl	(%rax), %eax
	movsbl	%al, %eax
	movl	%eax, %edi
	call	safeChar
	movb	%al, -8(%rbp)
	movsbl	-5(%rbp), %esi
	movsbl	-6(%rbp), %r8d
	movsbl	-7(%rbp), %edi
	movsbl	-8(%rbp), %ecx
	movq	-24(%rbp), %rax
	movl	(%rax), %edx
	subq	$8, %rsp
	movq	-24(%rbp), %rax
	pushq	%rsi
	movl	%r8d, %r9d
	movl	%edi, %r8d
	movq	%rax, %rsi
	movl	$.LC0, %edi
	movl	$0, %eax
	call	printf
	addq	$16, %rsp
	addl	$1, -4(%rbp)
	addq	$4, -24(%rbp)
.L17:
	movl	-4(%rbp), %eax
	cmpl	-28(%rbp), %eax
	jl	.L18
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3:
	.size	printStack, .-printStack
	.section	.rodata
.LC1:
	.string	"Input username: "
.LC2:
	.string	"Input password: "
.LC3:
	.string	"potok2"
.LC4:
	.string	"password"
.LC5:
	.string	"Login successful!"
.LC6:
	.string	"Login failed!"
	.text
	.globl	login
	.type	login, @function
login:
.LFB4:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	leaq	-16(%rbp), %rax
	movl	$10, %edx
	movl	$112, %esi
	movq	%rax, %rdi
	call	memset
	leaq	-32(%rbp), %rax
	movl	$10, %edx
	movl	$117, %esi
	movq	%rax, %rdi
	call	memset
	leaq	-32(%rbp), %rax
	movl	$11, %esi
	movq	%rax, %rdi
	call	printStack
	movl	$.LC1, %edi
	call	puts
	leaq	-32(%rbp), %rax
	movq	%rax, %rdi
	call	gets
	movl	$.LC2, %edi
	call	puts
	leaq	-16(%rbp), %rax
	movq	%rax, %rdi
	call	gets
	leaq	-32(%rbp), %rax
	movl	$11, %esi
	movq	%rax, %rdi
	call	printStack
	leaq	-32(%rbp), %rax
	movl	$.LC3, %esi
	movq	%rax, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L20
	leaq	-16(%rbp), %rax
	movl	$.LC4, %esi
	movq	%rax, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L20
	movl	$.LC5, %edi
	call	puts
	movl	$1, %eax
	jmp	.L22
.L20:
	movl	$.LC6, %edi
	call	puts
	movl	$0, %eax
.L22:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE4:
	.size	login, .-login
	.section	.rodata
.LC7:
	.string	"Your new key is: %d\n"
	.text
	.globl	generateSessionKey
	.type	generateSessionKey, @function
generateSessionKey:
.LFB5:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movl	$0, -4(%rbp)
	call	rand
	andl	$-16777216, %eax
	orl	%eax, -4(%rbp)
	call	rand
	andl	$16711680, %eax
	orl	%eax, -4(%rbp)
	call	rand
	andl	$65280, %eax
	orl	%eax, -4(%rbp)
	call	rand
	movzbl	%al, %eax
	orl	%eax, -4(%rbp)
	movl	-4(%rbp), %eax
	movl	%eax, %esi
	movl	$.LC7, %edi
	movl	$0, %eax
	call	printf
	movl	-4(%rbp), %eax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE5:
	.size	generateSessionKey, .-generateSessionKey
	.section	.rodata
	.align 8
.LC8:
	.string	"Please input: ./hackStack <username> <password>"
.LC9:
	.string	"Address of login: %p\n"
	.align 8
.LC10:
	.string	"Address of generateSessionKey: %p\n"
	.text
	.globl	main
	.type	main, @function
main:
.LFB6:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movl	%edi, -4(%rbp)
	movq	%rsi, -16(%rbp)
	cmpl	$1, -4(%rbp)
	je	.L26
	movl	$.LC8, %edi
	movl	$0, %eax
	call	printf
.L26:
	movl	$0, %edi
	call	time
	movl	%eax, %edi
	call	srand
	movl	$login, %esi
	movl	$.LC9, %edi
	movl	$0, %eax
	call	printf
	movl	$generateSessionKey, %esi
	movl	$.LC10, %edi
	movl	$0, %eax
	call	printf
	movl	$0, %eax
	call	login
	testl	%eax, %eax
	je	.L27
	movl	$0, %eax
	call	generateSessionKey
.L27:
	movl	$0, %eax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE6:
	.size	main, .-main
	.ident	"GCC: (Debian 4.9.2-10) 4.9.2"
	.section	.note.GNU-stack,"",@progbits
