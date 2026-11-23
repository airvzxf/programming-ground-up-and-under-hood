    # Assemble with `as --32` and `ld -m elf_i386`.
    #
    # PURPOSE:
    #     Solution to Chapter 3, "Going Further":
    #     the first program without the `int`
    #     instruction. It crashes on purpose.
    #
    .section .data

    .section .text
        .globl _start

_start:
    movl $1, %eax      # exit() system call number.
    movl $0, %ebx      # Status code.
                       # No `int $0x80`: the kernel
                       # is never called, so the CPU
                       # keeps executing whatever
                       # bytes follow in memory.
