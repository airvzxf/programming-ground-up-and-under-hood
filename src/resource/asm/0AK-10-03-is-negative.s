    # Assemble with `as --32` and `ld -m elf_i386`.
    #
    # PURPOSE:
    #     Solution to Chapter 10, "Use the Concepts":
    #     the `_is_negative` function.
    #
    # OUTPUT:
    #     Exit status code 100:
    #     is_negative(-5) * 100   -> 1 * 100
    #     + is_negative(7) * 10   -> 0 * 10
    #     + is_negative(0)        -> 0
    #
    .section .text
        .globl _start

_start:
    pushl $-5
    call  _is_negative
    addl  $4, %esp
    imull $100, %eax, %esi

    pushl $7
    call  _is_negative
    addl  $4, %esp
    imull $10, %eax, %eax
    addl  %eax, %esi

    pushl $0
    call  _is_negative
    addl  $4, %esp
    addl  %eax, %esi

    movl  %esi, %ebx
    movl  $1, %eax
    int   $0x80

    # PURPOSE:
    #     Return 1 if the number is negative, 0 if
    #     it is zero or positive.
    #
    # HOW IT WORKS:
    #     In two's complement, the highest bit (bit
    #     31) is the sign bit. Shifting the number 31
    #     places to the right leaves only that bit.
    #
    # INPUT:
    #     First argument - The number.
    #
    # OUTPUT:
    #     %eax - 1 or 0.
    #
        .type _is_negative, @function
_is_negative:
    movl  4(%esp), %eax
    shrl  $31, %eax          # Logical shift: fills
    ret                      # with zeros.
