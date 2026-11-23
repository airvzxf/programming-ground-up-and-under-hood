    # Assemble with `as --32` and `ld -m elf_i386`.
    #
    # PURPOSE:
    #     Solution to Chapter 5, "Use the Concepts":
    #     create the file `heynow.txt` and write
    #     "Hey diddle diddle!" into it.
    #
    .include "006-01-linux.s"
        .equ O_CREAT_WRONLY_TRUNC, 03101

    .section .data
        file_name:
            .ascii "heynow.txt\0"
        text:
            .ascii "Hey diddle diddle!\n"
        text_end:
        .equ TEXT_LENGTH, text_end - text

    .section .text
        .globl _start

_start:
    movl  $SYS_OPEN, %eax
    movl  $file_name, %ebx
    movl  $O_CREAT_WRONLY_TRUNC, %ecx
    movl  $0666, %edx        # Permissions.
    int   $LINUX_SYSCALL
    movl  %eax, %esi         # File descriptor.

    movl  $SYS_WRITE, %eax
    movl  %esi, %ebx
    movl  $text, %ecx
    movl  $TEXT_LENGTH, %edx
    int   $LINUX_SYSCALL

    movl  $SYS_CLOSE, %eax
    movl  %esi, %ebx
    int   $LINUX_SYSCALL

    movl  $SYS_EXIT, %eax
    movl  $0, %ebx
    int   $LINUX_SYSCALL
