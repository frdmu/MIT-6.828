	.file	"init.c"
	.stabs	"kern/init.c",100,0,2,.Ltext0
	.text
.Ltext0:
	.stabs	"gcc2_compiled.",60,0,0,0
	.stabs	"int:t(0,1)=r(0,1);-2147483648;2147483647;",128,0,0,0
	.stabs	"char:t(0,2)=r(0,2);0;127;",128,0,0,0
	.stabs	"long int:t(0,3)=r(0,3);-9223372036854775808;9223372036854775807;",128,0,0,0
	.stabs	"unsigned int:t(0,4)=r(0,4);0;4294967295;",128,0,0,0
	.stabs	"long unsigned int:t(0,5)=r(0,5);0;-1;",128,0,0,0
	.stabs	"__int128:t(0,6)=r(0,6);0;-1;",128,0,0,0
	.stabs	"__int128 unsigned:t(0,7)=r(0,7);0;-1;",128,0,0,0
	.stabs	"long long int:t(0,8)=r(0,8);-9223372036854775808;9223372036854775807;",128,0,0,0
	.stabs	"long long unsigned int:t(0,9)=r(0,9);0;-1;",128,0,0,0
	.stabs	"short int:t(0,10)=r(0,10);-32768;32767;",128,0,0,0
	.stabs	"short unsigned int:t(0,11)=r(0,11);0;65535;",128,0,0,0
	.stabs	"signed char:t(0,12)=r(0,12);-128;127;",128,0,0,0
	.stabs	"unsigned char:t(0,13)=r(0,13);0;255;",128,0,0,0
	.stabs	"float:t(0,14)=r(0,1);4;0;",128,0,0,0
	.stabs	"double:t(0,15)=r(0,1);8;0;",128,0,0,0
	.stabs	"long double:t(0,16)=r(0,1);16;0;",128,0,0,0
	.stabs	"_Float32:t(0,17)=r(0,1);4;0;",128,0,0,0
	.stabs	"_Float64:t(0,18)=r(0,1);8;0;",128,0,0,0
	.stabs	"_Float128:t(0,19)=r(0,1);16;0;",128,0,0,0
	.stabs	"_Float32x:t(0,20)=r(0,1);8;0;",128,0,0,0
	.stabs	"_Float64x:t(0,21)=r(0,1);16;0;",128,0,0,0
	.stabs	"_Decimal32:t(0,22)=r(0,1);4;0;",128,0,0,0
	.stabs	"_Decimal64:t(0,23)=r(0,1);8;0;",128,0,0,0
	.stabs	"_Decimal128:t(0,24)=r(0,1);16;0;",128,0,0,0
	.stabs	"void:t(0,25)=(0,25)",128,0,0,0
	.stabs	"./inc/stdio.h",130,0,0,0
	.stabs	"./inc/stdarg.h",130,0,0,0
	.stabs	"va_list:t(2,1)=(2,2)=(2,3)=ar(2,4)=r(2,4);0;-1;;0;0;(2,5)=xs__va_list_tag:",128,0,0,0
	.stabn	162,0,0,0
	.stabn	162,0,0,0
	.stabs	"./inc/string.h",130,0,0,0
	.stabs	"./inc/types.h",130,0,0,0
	.stabs	"bool:t(4,1)=(4,2)=eFalse:0,True:1,;",128,0,0,0
	.stabs	" :T(4,3)=efalse:0,true:1,;",128,0,0,0
	.stabs	"int8_t:t(4,4)=(0,12)",128,0,0,0
	.stabs	"uint8_t:t(4,5)=(0,13)",128,0,0,0
	.stabs	"int16_t:t(4,6)=(0,10)",128,0,0,0
	.stabs	"uint16_t:t(4,7)=(0,11)",128,0,0,0
	.stabs	"int32_t:t(4,8)=(0,1)",128,0,0,0
	.stabs	"uint32_t:t(4,9)=(0,4)",128,0,0,0
	.stabs	"int64_t:t(4,10)=(0,8)",128,0,0,0
	.stabs	"uint64_t:t(4,11)=(0,9)",128,0,0,0
	.stabs	"intptr_t:t(4,12)=(4,8)",128,0,0,0
	.stabs	"uintptr_t:t(4,13)=(4,9)",128,0,0,0
	.stabs	"physaddr_t:t(4,14)=(4,9)",128,0,0,0
	.stabs	"ppn_t:t(4,15)=(4,9)",128,0,0,0
	.stabs	"size_t:t(4,16)=(4,9)",128,0,0,0
	.stabs	"ssize_t:t(4,17)=(4,8)",128,0,0,0
	.stabs	"off_t:t(4,18)=(4,8)",128,0,0,0
	.stabn	162,0,0,0
	.stabn	162,0,0,0
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"entering test_backtrace %d\n"
.LC1:
	.string	"leaving test_backtrace %d\n"
	.text
	.p2align 4,,15
	.stabs	"test_backtrace:F(0,25)",36,0,0,test_backtrace
	.stabs	"x:P(0,1)",64,0,0,3
	.globl	test_backtrace
	.type	test_backtrace, @function
test_backtrace:
	.stabn	68,0,13,.LM0-.LFBB1
.LM0:
.LFBB1:
.LFB0:
	.cfi_startproc
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	.stabn	68,0,14,.LM1-.LFBB1
.LM1:
	movl	%edi, %esi
	.stabn	68,0,13,.LM2-.LFBB1
.LM2:
	movl	%edi, %ebx
	.stabn	68,0,14,.LM3-.LFBB1
.LM3:
	xorl	%eax, %eax
	movl	$.LC0, %edi
	call	cprintf
	.stabn	68,0,15,.LM4-.LFBB1
.LM4:
	testl	%ebx, %ebx
	jle	.L2
	.stabn	68,0,16,.LM5-.LFBB1
.LM5:
	leal	-1(%rbx), %edi
	call	test_backtrace
	.stabn	68,0,19,.LM6-.LFBB1
.LM6:
	movl	%ebx, %esi
	movl	$.LC1, %edi
	xorl	%eax, %eax
	.stabn	68,0,20,.LM7-.LFBB1
.LM7:
	popq	%rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	.stabn	68,0,19,.LM8-.LFBB1
.LM8:
	jmp	cprintf
	.p2align 4,,10
	.p2align 3
.L2:
	.cfi_restore_state
	.stabn	68,0,18,.LM9-.LFBB1
.LM9:
	xorl	%esi, %esi
	xorl	%edi, %edi
	xorl	%edx, %edx
	call	mon_backtrace
	.stabn	68,0,19,.LM10-.LFBB1
.LM10:
	movl	%ebx, %esi
	movl	$.LC1, %edi
	xorl	%eax, %eax
	.stabn	68,0,20,.LM11-.LFBB1
.LM11:
	popq	%rbx
	.cfi_def_cfa_offset 8
	.stabn	68,0,19,.LM12-.LFBB1
.LM12:
	jmp	cprintf
	.cfi_endproc
.LFE0:
	.size	test_backtrace, .-test_backtrace
.Lscope1:
	.section	.rodata.str1.1
.LC2:
	.string	"6828 decimal is %o octal!\n"
.LC3:
	.string	"x %d, y %d, z %d\n"
.LC4:
	.string	"x=%d, y=%d\n"
.LC5:
	.string	"Printing colored strings: "
.LC6:
	.string	"\033[31;40mRed "
.LC7:
	.string	"\033[32;40mGreen "
.LC8:
	.string	"\033[33;40mYellow "
.LC9:
	.string	"\n"
.LC10:
	.string	"With background color: "
.LC11:
	.string	"\033[31;32mRed "
.LC12:
	.string	"\033[32;33mGreen "
.LC13:
	.string	"\033[33;34mYellow "
.LC14:
	.string	"H%x Wor%s"
	.text
	.p2align 4,,15
	.stabs	"i386_init:F(0,25)",36,0,0,i386_init
	.globl	i386_init
	.type	i386_init, @function
i386_init:
	.stabn	68,0,24,.LM13-.LFBB2
.LM13:
.LFBB2:
.LFB1:
	.cfi_startproc
	.stabn	68,0,30,.LM14-.LFBB2
.LM14:
	movl	$end, %edx
	.stabn	68,0,24,.LM15-.LFBB2
.LM15:
	subq	$24, %rsp
	.cfi_def_cfa_offset 32
	.stabn	68,0,30,.LM16-.LFBB2
.LM16:
	xorl	%esi, %esi
	movl	$edata, %edi
	.stabn	68,0,30,.LM17-.LFBB2
.LM17:
	subq	$edata, %rdx
	.stabn	68,0,30,.LM18-.LFBB2
.LM18:
	call	memset
	.stabn	68,0,34,.LM19-.LFBB2
.LM19:
	call	cons_init
	.stabn	68,0,36,.LM20-.LFBB2
.LM20:
	movl	$6828, %esi
	movl	$.LC2, %edi
	xorl	%eax, %eax
	call	cprintf
.LBB2:
	.stabn	68,0,40,.LM21-.LFBB2
.LM21:
	movl	$4, %ecx
	movl	$3, %edx
	xorl	%eax, %eax
	movl	$1, %esi
	movl	$.LC3, %edi
	call	cprintf
	.stabn	68,0,43,.LM22-.LFBB2
.LM22:
	movl	$3, %esi
	movl	$.LC4, %edi
	xorl	%eax, %eax
	call	cprintf
	.stabn	68,0,46,.LM23-.LFBB2
.LM23:
	movl	$.LC5, %edi
	xorl	%eax, %eax
	call	cprintf
	.stabn	68,0,47,.LM24-.LFBB2
.LM24:
	movl	$.LC6, %edi
	xorl	%eax, %eax
	call	cprintf
	.stabn	68,0,48,.LM25-.LFBB2
.LM25:
	movl	$.LC7, %edi
	xorl	%eax, %eax
	call	cprintf
	.stabn	68,0,49,.LM26-.LFBB2
.LM26:
	movl	$.LC8, %edi
	xorl	%eax, %eax
	call	cprintf
	.stabn	68,0,50,.LM27-.LFBB2
.LM27:
	movl	$.LC9, %edi
	xorl	%eax, %eax
	call	cprintf
	.stabn	68,0,51,.LM28-.LFBB2
.LM28:
	movl	$.LC10, %edi
	xorl	%eax, %eax
	call	cprintf
	.stabn	68,0,52,.LM29-.LFBB2
.LM29:
	movl	$.LC11, %edi
	xorl	%eax, %eax
	call	cprintf
	.stabn	68,0,53,.LM30-.LFBB2
.LM30:
	movl	$.LC12, %edi
	xorl	%eax, %eax
	call	cprintf
	.stabn	68,0,54,.LM31-.LFBB2
.LM31:
	movl	$.LC13, %edi
	xorl	%eax, %eax
	call	cprintf
	.stabn	68,0,55,.LM32-.LFBB2
.LM32:
	movl	$.LC9, %edi
	xorl	%eax, %eax
	call	cprintf
.LBE2:
.LBB3:
	.stabn	68,0,60,.LM33-.LFBB2
.LM33:
	movl	$.LC14, %edi
	leaq	12(%rsp), %rdx
	xorl	%eax, %eax
	movl	$57616, %esi
	.stabn	68,0,59,.LM34-.LFBB2
.LM34:
	movl	$681068, 12(%rsp)
	.stabn	68,0,60,.LM35-.LFBB2
.LM35:
	call	cprintf
.LBE3:
	.stabn	68,0,64,.LM36-.LFBB2
.LM36:
	movl	$5, %edi
	call	test_backtrace
	.p2align 4,,10
	.p2align 3
.L7:
	.stabn	68,0,68,.LM37-.LFBB2
.LM37:
	xorl	%edi, %edi
	call	monitor
	jmp	.L7
	.cfi_endproc
.LFE1:
	.size	i386_init, .-i386_init
	.stabs	"i:(0,4)",128,0,0,12
	.stabn	192,0,0,.LBB3-.LFBB2
	.stabn	224,0,0,.LBE3-.LFBB2
.Lscope2:
	.section	.rodata.str1.1
.LC15:
	.string	"kernel panic at %s:%d: "
	.text
	.p2align 4,,15
	.stabs	"_panic:F(0,25)",36,0,0,_panic
	.stabs	"file:P(0,26)=*(0,2)",64,0,0,5
	.stabs	"line:P(0,1)",64,0,0,4
	.stabs	"fmt:P(0,26)",64,0,0,3
	.globl	_panic
	.type	_panic, @function
_panic:
	.stabn	68,0,84,.LM38-.LFBB3
.LM38:
.LFBB3:
.LFB2:
	.cfi_startproc
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%rdx, %rbx
	subq	$208, %rsp
	.cfi_def_cfa_offset 224
	movq	%rcx, 56(%rsp)
	movq	%r8, 64(%rsp)
	movq	%r9, 72(%rsp)
	testb	%al, %al
	je	.L13
	movaps	%xmm0, 80(%rsp)
	movaps	%xmm1, 96(%rsp)
	movaps	%xmm2, 112(%rsp)
	movaps	%xmm3, 128(%rsp)
	movaps	%xmm4, 144(%rsp)
	movaps	%xmm5, 160(%rsp)
	movaps	%xmm6, 176(%rsp)
	movaps	%xmm7, 192(%rsp)
.L13:
	.stabn	68,0,87,.LM39-.LFBB3
.LM39:
	cmpq	$0, panicstr(%rip)
	je	.L15
	.p2align 4,,10
	.p2align 3
.L12:
	.stabn	68,0,103,.LM40-.LFBB3
.LM40:
	xorl	%edi, %edi
	call	monitor
	jmp	.L12
.L15:
	.stabn	68,0,89,.LM41-.LFBB3
.LM41:
	movq	%rbx, panicstr(%rip)
	.stabn	68,0,92,.LM42-.LFBB3
.LM42:
#APP
# 92 "kern/init.c" 1
	cli; cld
# 0 "" 2
	.stabn	68,0,94,.LM43-.LFBB3
.LM43:
#NO_APP
	leaq	224(%rsp), %rax
	.stabn	68,0,95,.LM44-.LFBB3
.LM44:
	movl	%esi, %edx
	movq	%rdi, %rsi
	movl	$.LC15, %edi
	.stabn	68,0,94,.LM45-.LFBB3
.LM45:
	movq	%rax, 16(%rsp)
	leaq	32(%rsp), %rax
	movq	%rax, 24(%rsp)
	.stabn	68,0,95,.LM46-.LFBB3
.LM46:
	xorl	%eax, %eax
	.stabn	68,0,94,.LM47-.LFBB3
.LM47:
	movl	$24, 8(%rsp)
	movl	$48, 12(%rsp)
	.stabn	68,0,95,.LM48-.LFBB3
.LM48:
	call	cprintf
	.stabn	68,0,96,.LM49-.LFBB3
.LM49:
	movq	%rbx, %rdi
	leaq	8(%rsp), %rsi
	call	vcprintf
	.stabn	68,0,97,.LM50-.LFBB3
.LM50:
	movl	$.LC9, %edi
	xorl	%eax, %eax
	call	cprintf
	jmp	.L12
	.cfi_endproc
.LFE2:
	.size	_panic, .-_panic
	.stabs	"ap:(2,1)",128,0,0,8
	.stabn	192,0,0,.LFBB3-.LFBB3
	.stabn	224,0,0,.Lscope3-.LFBB3
.Lscope3:
	.section	.rodata.str1.1
.LC16:
	.string	"kernel warning at %s:%d: "
	.text
	.p2align 4,,15
	.stabs	"_warn:F(0,25)",36,0,0,_warn
	.stabs	"file:P(0,26)",64,0,0,5
	.stabs	"line:P(0,1)",64,0,0,4
	.stabs	"fmt:P(0,26)",64,0,0,3
	.globl	_warn
	.type	_warn, @function
_warn:
	.stabn	68,0,109,.LM51-.LFBB4
.LM51:
.LFBB4:
.LFB3:
	.cfi_startproc
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%rdx, %rbx
	subq	$208, %rsp
	.cfi_def_cfa_offset 224
	movq	%rcx, 56(%rsp)
	movq	%r8, 64(%rsp)
	movq	%r9, 72(%rsp)
	testb	%al, %al
	je	.L18
	movaps	%xmm0, 80(%rsp)
	movaps	%xmm1, 96(%rsp)
	movaps	%xmm2, 112(%rsp)
	movaps	%xmm3, 128(%rsp)
	movaps	%xmm4, 144(%rsp)
	movaps	%xmm5, 160(%rsp)
	movaps	%xmm6, 176(%rsp)
	movaps	%xmm7, 192(%rsp)
.L18:
	.stabn	68,0,112,.LM52-.LFBB4
.LM52:
	leaq	224(%rsp), %rax
	.stabn	68,0,113,.LM53-.LFBB4
.LM53:
	movl	%esi, %edx
	movq	%rdi, %rsi
	movl	$.LC16, %edi
	.stabn	68,0,112,.LM54-.LFBB4
.LM54:
	movq	%rax, 16(%rsp)
	leaq	32(%rsp), %rax
	movq	%rax, 24(%rsp)
	.stabn	68,0,113,.LM55-.LFBB4
.LM55:
	xorl	%eax, %eax
	.stabn	68,0,112,.LM56-.LFBB4
.LM56:
	movl	$24, 8(%rsp)
	movl	$48, 12(%rsp)
	.stabn	68,0,113,.LM57-.LFBB4
.LM57:
	call	cprintf
	.stabn	68,0,114,.LM58-.LFBB4
.LM58:
	leaq	8(%rsp), %rsi
	movq	%rbx, %rdi
	call	vcprintf
	.stabn	68,0,115,.LM59-.LFBB4
.LM59:
	movl	$.LC9, %edi
	xorl	%eax, %eax
	call	cprintf
	.stabn	68,0,117,.LM60-.LFBB4
.LM60:
	addq	$208, %rsp
	.cfi_def_cfa_offset 16
	popq	%rbx
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE3:
	.size	_warn, .-_warn
	.stabs	"ap:(2,1)",128,0,0,8
	.stabn	192,0,0,.LFBB4-.LFBB4
	.stabn	224,0,0,.Lscope4-.LFBB4
.Lscope4:
	.comm	panicstr,8,8
	.stabs	"panicstr:G(0,26)",32,0,0,0
	.stabs	"",100,0,0,.Letext0
.Letext0:
	.ident	"GCC: (GNU) 8.3.1 20191121 (Red Hat 8.3.1-5)"
	.section	.note.GNU-stack,"",@progbits
