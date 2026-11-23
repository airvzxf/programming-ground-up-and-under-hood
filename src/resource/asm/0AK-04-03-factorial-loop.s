    # Assemble with `as --32` and `ld -m elf_i386`.
    #
    # PURPOSE:
    #     Solution to Chapter 4, "Going Further":
    #     the factorial function without recursion.
    #     It returns the factorial of 5.
    #
    # OUTPUT:
    #     Exit status code 120.
    #
    .section .data

    .section .text
        .globl _start

_start:
    pushl $5
    call  _factorial
    addl  $4, %esp

    movl  %eax, %ebx
    movl  $1, %eax
    int   $0x80

    # PURPOSE:
    #     Compute n! with a loop:
    #     result = 1; while (n > 1) result *= n--;
    #
    # INPUT:
    #     First argument - n.
    #
    # OUTPUT:
    #     %eax - n! (1 for n = 0 or 1).
    #
        .type _factorial, @function
_factorial:
    pushl %ebp
    movl  %esp, %ebp

    movl  $1, %eax           # Result.
    movl  8(%ebp), %ecx      # Counter = n.

_factorial_loop:
    cmpl  $1, %ecx           # Done when n <= 1.
    jle   _factorial_end
    imull %ecx, %eax         # result *= n
    decl  %ecx               # n--
    jmp   _factorial_loop

_factorial_end:
    movl  %ebp, %esp
    popl  %ebp
    ret
