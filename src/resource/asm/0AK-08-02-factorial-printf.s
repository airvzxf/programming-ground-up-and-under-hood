    # Assemble with `as --32`. Link dynamically with
    # the factorial library and the C library:
    #     ld -m elf_i386 \
    #       -o 0AK-08-02-factorial-printf \
    #       0AK-08-02-factorial-printf.o \
    #       -L . -l factorial -l c \
    #       -dynamic-linker /usr/lib32/ld-linux.so.2
    # Run with:
    #     LD_LIBRARY_PATH=. \
    #       ./0AK-08-02-factorial-printf
    #
    # PURPOSE:
    #     Solution to Chapter 8, "Use the Concepts":
    #     call `_factorial` from the shared library
    #     `libfactorial.so`, print the result with
    #     `printf` and exit with status 0.
    #
    # OUTPUT:
    #     The factorial of 5 is 120.
    #
    .section .data
        format:
            .ascii "The factorial of %d is %d.\n\0"

    .section .text
        .globl _start
        .equ NUMBER, 5

_start:
    pushl $NUMBER
    call  _factorial         # From libfactorial.so.
    addl  $4, %esp

    pushl %eax               # printf(format, n, n!)
    pushl $NUMBER
    pushl $format
    call  printf
    addl  $12, %esp

    pushl $0                 # exit(0) flushes the
    call  exit               # printf buffer.
