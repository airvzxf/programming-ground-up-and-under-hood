    # Assemble with `as --32` and `ld -m elf_i386`.
    # Link with `0AK-10-01-integer2string-base.o`,
    # `0AK-08-01-factorial-lib.o` and
    # `006-01-write-newline.o`.
    #
    # PURPOSE:
    #     Solution to Chapter 10, "Use the Concepts":
    #     print a result instead of returning it as
    #     the exit status (the factorial of 5, which
    #     no longer has the 255 limit: 10! works too),
    #     and print 255 in several bases.
    #
    # OUTPUT:
    #     120
    #     3628800
    #     377
    #     ff
    #     11111111
    #     73
    #
    .include "006-01-linux.s"

    .section .bss
        .lcomm buffer, 33

    .section .text
        .globl _start

_start:
    pushl $5                 # 5!
    call  _factorial
    addl  $4, %esp
    pushl $10                # In base 10.
    pushl %eax
    call  _print_number
    addl  $8, %esp

    pushl $10                # 10! = 3628800, too
    call  _factorial         # big for an exit
    addl  $4, %esp           # status code.
    pushl $10
    pushl %eax
    call  _print_number
    addl  $8, %esp

    pushl $8                 # 255 in octal,
    pushl $255
    call  _print_number
    addl  $8, %esp
    pushl $16                # hexadecimal,
    pushl $255
    call  _print_number
    addl  $8, %esp
    pushl $2                 # binary
    pushl $255
    call  _print_number
    addl  $8, %esp
    pushl $36                # and base 36.
    pushl $255
    call  _print_number
    addl  $8, %esp

    movl  $SYS_EXIT, %eax
    movl  $0, %ebx
    int   $LINUX_SYSCALL

    # PURPOSE:
    #     Print a number in a base and a newline.
    #
    # INPUT:
    #     First argument  - The number.
    #     Second argument - The base.
    #
        .type _print_number, @function
_print_number:
    pushl %ebp
    movl  %esp, %ebp
    pushl %ebx

    pushl 12(%ebp)           # Base.
    pushl $buffer
    pushl 8(%ebp)            # Number.
    call  _integer2string_base
    addl  $12, %esp

    movl  %eax, %edx         # Length.
    movl  $SYS_WRITE, %eax
    movl  $STDOUT, %ebx
    movl  $buffer, %ecx
    int   $LINUX_SYSCALL

    pushl $STDOUT
    call  _write_newline
    addl  $4, %esp

    popl  %ebx
    movl  %ebp, %esp
    popl  %ebp
    ret
