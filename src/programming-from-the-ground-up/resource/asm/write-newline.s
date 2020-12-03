    .code32                 # Generate 32-bit code.
    .include "linux.s"      # Common Linux Definitions.

        .globl _write_newline
        .type  _write_newline,  @function

    .section .data
        newline:
            .ascii "\n"

    .section .text
        .equ ST_FILEDES,  8

_write_newline:
    pushl %ebp
    movl  %esp, %ebp

    movl  $SYS_WRITE, %eax
    movl  ST_FILEDES(%ebp), %ebx
    movl  $newline, %ecx
    movl  $1, %edx
    int   $LINUX_SYSCALL

    movl  %ebp, %esp
    popl  %ebp
    ret
