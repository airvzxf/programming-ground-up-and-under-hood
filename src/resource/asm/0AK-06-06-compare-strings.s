    # Assemble with `as --32` and `ld -m elf_i386`.
    #
    # PURPOSE:
    #     Solution to Chapter 6, "Going Further": the
    #     `_compare_strings` function, which compares
    #     two strings up to 5 characters.
    #
    # INPUT:
    #     First argument  - Address of string A.
    #     Second argument - Address of string B.
    #
    # OUTPUT:
    #     %eax - 1 if A is a prefix of B (comparing
    #     at most 5 characters of A and stopping at
    #     the null byte of A), 0 otherwise.
    #     An empty A matches every string.
    #
        .equ MAX_CHARS, 5
        .equ ST_STRING_A, 8
        .equ ST_STRING_B, 12

    .section .text
        .globl _compare_strings
        .type  _compare_strings, @function
_compare_strings:
    pushl %ebp
    movl  %esp, %ebp
    pushl %ebx
    pushl %esi
    pushl %edi

    movl  ST_STRING_A(%ebp), %esi
    movl  ST_STRING_B(%ebp), %edi
    movl  $0, %ecx           # Index.

_compare_loop:
    cmpl  $MAX_CHARS, %ecx   # 5 characters done?
    je    _match
    movb  (%esi,%ecx,1), %al
    cmpb  $0, %al            # End of A?
    je    _match
    movb  (%edi,%ecx,1), %bl
    cmpb  %al, %bl
    jne   _no_match
    incl  %ecx
    jmp   _compare_loop

_match:
    movl  $1, %eax
    jmp   _compare_end
_no_match:
    movl  $0, %eax

_compare_end:
    popl  %edi
    popl  %esi
    popl  %ebx
    movl  %ebp, %esp
    popl  %ebp
    ret
