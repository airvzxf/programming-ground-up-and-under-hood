    # Assemble with `as --32` and `ld -m elf_i386`.
    #
    # PURPOSE:
    #     Solution to Chapter 4, "Use the Concepts":
    #     a `_square` function and a program that
    #     tests it with the number 12.
    #
    # OUTPUT:
    #     Exit status code 144 (12 * 12).
    #
    .section .data

    .section .text
        .globl _start

_start:
    pushl $12                # Argument.
    call  _square
    addl  $4, %esp           # Remove the argument.

    movl  %eax, %ebx         # Result as the status.
    movl  $1, %eax           # exit()
    int   $0x80

    # PURPOSE:
    #     Return the square of a number.
    #
    # INPUT:
    #     First argument - The number.
    #
    # OUTPUT:
    #     %eax - The number multiplied by itself.
    #
        .type _square, @function
_square:
    pushl %ebp               # Standard function
    movl  %esp, %ebp         # prologue.

    movl  8(%ebp), %eax      # %eax = argument.
    imull %eax, %eax         # %eax = %eax * %eax.

    movl  %ebp, %esp         # Standard function
    popl  %ebp               # epilogue.
    ret
