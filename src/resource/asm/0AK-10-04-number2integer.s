    # Assemble with `as --32` and `ld -m elf_i386`.
    # Link with `0AK-10-01-integer2string-base.o`
    # and `006-01-write-newline.o`.
    #
    # PURPOSE:
    #     Solution to Chapter 10, "Going Further":
    #     the `_number2integer` function, the reverse
    #     of `_integer2string`. The program reads a
    #     number from STDIN, converts it to an
    #     integer, and prints it back with
    #     `_integer2string_base` to test it.
    #
    # USAGE:
    #     echo -0042 | ./0AK-10-04-number2integer
    #     (prints -42)
    #
    .include "006-01-linux.s"
        .equ INPUT_SIZE, 32

    .section .data
        minus:
            .ascii "-"

    .section .bss
        .lcomm input, INPUT_SIZE + 1
        .lcomm output, 33

    .section .text
        .globl _start

_start:
    movl  $SYS_READ, %eax
    movl  $STDIN, %ebx
    movl  $input, %ecx
    movl  $INPUT_SIZE, %edx
    int   $LINUX_SYSCALL
    cmpl  $0, %eax
    jle   _exit
    movb  $0, input(%eax)    # Null-terminate it.

    pushl $input
    call  _number2integer
    addl  $4, %esp
    movl  %eax, %esi         # The integer.

    cmpl  $0, %esi           # Negative: print the
    jge   _print             # sign and the
    movl  $SYS_WRITE, %eax   # absolute value.
    movl  $STDOUT, %ebx
    movl  $minus, %ecx
    movl  $1, %edx
    int   $LINUX_SYSCALL
    negl  %esi

_print:
    pushl $10
    pushl $output
    pushl %esi
    call  _integer2string_base
    addl  $12, %esp

    movl  %eax, %edx
    movl  $SYS_WRITE, %eax
    movl  $STDOUT, %ebx
    movl  $output, %ecx
    int   $LINUX_SYSCALL
    pushl $STDOUT
    call  _write_newline
    addl  $4, %esp

_exit:
    movl  $SYS_EXIT, %eax
    movl  $0, %ebx
    int   $LINUX_SYSCALL

    # PURPOSE:
    #     Convert decimal text to an integer.
    #     An optional '-' sign is accepted at the
    #     start; the conversion stops at the first
    #     character that is not a digit (such as the
    #     newline or the null byte).
    #
    # INPUT:
    #     First argument - Address of the text.
    #
    # OUTPUT:
    #     %eax - The integer.
    #
    # VARIABLES:
    #     %eax - Result so far.
    #     %edx - Address of the current character.
    #     %ecx - Current character / digit value.
    #     %ebx - 1 if the number is negative.
    #
        .globl _number2integer
        .type  _number2integer, @function
_number2integer:
    pushl %ebp
    movl  %esp, %ebp
    pushl %ebx

    movl  8(%ebp), %edx
    movl  $0, %eax
    movl  $0, %ebx
    cmpb  $'-', (%edx)       # Sign?
    jne   _digit_loop
    movl  $1, %ebx
    incl  %edx

_digit_loop:
    movzbl (%edx), %ecx      # Byte -> 32 bits.
    subl  $'0', %ecx         # '0'..'9' -> 0..9.
    cmpl  $9, %ecx           # Not a digit? (Also
    ja    _digits_end        # catches < '0'.)
    imull $10, %eax          # result = result*10
    addl  %ecx, %eax         #          + digit
    incl  %edx
    jmp   _digit_loop

_digits_end:
    cmpl  $1, %ebx
    jne   _number_end
    negl  %eax               # Apply the sign.

_number_end:
    popl  %ebx
    movl  %ebp, %esp
    popl  %ebp
    ret
