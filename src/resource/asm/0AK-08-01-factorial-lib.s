    # Assemble with `as --32`.
    # Build the shared library with:
    #     ld -shared -m elf_i386 \
    #       -o libfactorial.so \
    #       0AK-08-01-factorial-lib.o
    #
    # PURPOSE:
    #     Solution to Chapter 8, "Use the Concepts":
    #     the recursive `_factorial` function of
    #     Chapter 4, alone in a file, to build the
    #     shared library `libfactorial.so`.
    #
    # INPUT:
    #     First argument - n.
    #
    # OUTPUT:
    #     %eax - n!
    #
    # NOTES:
    #     The recursive call uses a local label. A
    #     call to the global name `_factorial` would
    #     need a relocation in the code when the
    #     library is loaded (DT_TEXTREL), because
    #     another library could replace that name.
    #
    .section .text
        .globl _factorial
        .type  _factorial, @function
_factorial:
_factorial_local:            # Local name, see below.
    pushl %ebp
    movl  %esp, %ebp
    pushl %ebx               # Callee-saved register.

    movl  8(%ebp), %eax
    cmpl  $1, %eax           # 1! = 1 (and 0! = 1).
    jle   _end_factorial
    decl  %eax
    pushl %eax
    call  _factorial_local   # (n - 1)!
    addl  $4, %esp
    movl  8(%ebp), %ebx
    imull %ebx, %eax         # n * (n - 1)!

_end_factorial:
    popl  %ebx
    movl  %ebp, %esp
    popl  %ebp
    ret
