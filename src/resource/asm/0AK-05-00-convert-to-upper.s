    # Assemble with `as --32` and `ld -m elf_i386`.
    #
    # PURPOSE:
    #     The `_convert_to_upper` function of
    #     `005-01-toupper`, in its own file so the
    #     Chapter 5 solutions can link it.
    #
    # INPUT:
    #     First argument  - Length of the buffer.
    #     Second argument - Address of the buffer.
    #
    # OUTPUT:
    #     The buffer is converted in place.
    #
        .equ LOWERCASE_A,       'a'
        .equ LOWERCASE_Z,       'z'
        .equ UPPER_CONVERSION,  'A' - 'a'
        .equ ST_BUFFER_LEN,     8
        .equ ST_BUFFER,         12

    .section .text
        .globl _convert_to_upper
        .type  _convert_to_upper, @function
_convert_to_upper:
    pushl %ebp
    movl  %esp, %ebp
    pushl %ebx               # Preserve %ebx and
    pushl %edi               # %edi for the caller.

    movl  ST_BUFFER(%ebp), %eax
    movl  ST_BUFFER_LEN(%ebp), %ebx
    movl  $0, %edi
    cmpl  $0, %ebx           # Empty buffer?
    je    _end_convert_loop

_convert_loop:
    movb  (%eax,%edi,1), %cl
    cmpb  $LOWERCASE_A, %cl  # Only 'a' to 'z'.
    jl    _next_byte
    cmpb  $LOWERCASE_Z, %cl
    jg    _next_byte
    addb  $UPPER_CONVERSION, %cl
    movb  %cl, (%eax,%edi,1)
_next_byte:
    incl  %edi
    cmpl  %edi, %ebx
    jne   _convert_loop

_end_convert_loop:
    popl  %edi
    popl  %ebx
    movl  %ebp, %esp
    popl  %ebp
    ret
