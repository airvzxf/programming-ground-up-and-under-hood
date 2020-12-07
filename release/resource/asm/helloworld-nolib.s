    # Assemble with `as --32` and `ld -m elf_i386`.
    #
    .include "linux.s"      # Common Linux Definitions.

    # PURPOSE:
    #     This program writes the message
    #     "hello world" and exits.
    #
    .section .data
        helloworld:
            .ascii "hello world\n"

        helloworld_end:
            .equ lenght, helloworld_end - helloworld

    .section .text

    .globl _start
_start:
    movl  $STDOUT, %ebx
    movl  $helloworld, %ecx
    movl  $lenght, %edx
    movl  $SYS_WRITE, %eax
    int   $LINUX_SYSCALL

    movl  $0, %ebx
    movl  $SYS_EXIT, %eax
    int   $LINUX_SYSCALL
