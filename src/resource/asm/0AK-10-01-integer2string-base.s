    # Assemble with `as --32` and `ld -m elf_i386`.
    #
    # PURPOSE:
    #     Solution to Chapter 10, "Use the Concepts"
    #     and "Going Further": `_integer2string`
    #     with the base as a parameter, from 2 to 36.
    #     Digits past 9 are the letters a to z, so
    #     base 8 gives octal and base 16 gives
    #     hexadecimal.
    #
    # INPUT:
    #     First argument  - The (unsigned) number.
    #     Second argument - Buffer for the text (33
    #                       bytes is enough for any
    #                       base: 32 digits + null).
    #     Third argument  - The base (2 to 36).
    #
    # OUTPUT:
    #     The buffer holds the null-terminated text.
    #     %eax - Number of characters written.
    #
        .equ ST_VALUE,  8
        .equ ST_BUFFER, 12
        .equ ST_BASE,   16

    .section .data
        digits:
            .ascii "0123456789"
            .ascii "abcdefghijklmnopqrstuvwxyz"

    .section .text
        .globl _integer2string_base
        .type  _integer2string_base, @function
_integer2string_base:
    pushl %ebp
    movl  %esp, %ebp
    pushl %ebx               # Preserve the
    pushl %edi               # callee-saved
    pushl %esi               # registers.

    movl  ST_VALUE(%ebp), %eax
    movl  ST_BASE(%ebp), %edi
    movl  $0, %ecx           # Digit count.

_conversion_loop:
    movl  $0, %edx           # %edx:%eax / base:
    divl  %edi               # %eax = quotient,
                             # %edx = remainder.
    movb  digits(%edx), %bl  # Remainder -> digit.
    pushl %ebx               # Digits come out in
    incl  %ecx               # reverse order, so use
    cmpl  $0, %eax           # the stack to reverse
    jne   _conversion_loop   # them.

    movl  ST_BUFFER(%ebp), %edx
    movl  %ecx, %esi         # Keep the count.
_copy_loop:
    popl  %eax
    movb  %al, (%edx)
    incl  %edx
    decl  %ecx
    jnz   _copy_loop
    movb  $0, (%edx)         # Null terminator.

    movl  %esi, %eax         # Return the count.
    popl  %esi
    popl  %edi
    popl  %ebx
    movl  %ebp, %esp
    popl  %ebp
    ret
