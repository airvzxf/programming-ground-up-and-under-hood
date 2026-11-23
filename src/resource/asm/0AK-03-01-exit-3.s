    # Assemble with `as --32` and `ld -m elf_i386`.
    #
    # PURPOSE:
    #     Solution to Chapter 3, "Use the Concepts":
    #     the first program, returning 3 instead of 0.
    #
    # OUTPUT:
    #     Exit status code 3. Check it with `echo $?`.
    #
    .section .data

    .section .text
        .globl _start

_start:
    movl $1, %eax      # exit() system call number.
    movl $3, %ebx      # Status code returned to the
                       # shell.
    int  $0x80         # Call the kernel.
