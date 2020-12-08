    # Assemble with `as --32` and `ld -m elf_i386`.
    #
    .include "006-01-linux.s"      # Linux Definitions.

        .equ ST_ERROR_CODE,  8
        .equ ST_ERROR_MSG,   12

        .globl _error_exit
        .type  _error_exit,   @function

_error_exit:
    pushl %ebp
    movl  %esp, %ebp

                            # Write out error code.
    movl  ST_ERROR_CODE(%ebp), %ecx
    pushl %ecx
    call  _count_chars
    popl  %ecx
    movl  %eax, %edx
    movl  $STDERR, %ebx
    movl  $SYS_WRITE, %eax
    int   $LINUX_SYSCALL

                            # Write out error message.
    movl  ST_ERROR_MSG(%ebp), %ecx
    pushl %ecx
    call  _count_chars
    popl  %ecx
    movl  %eax, %edx
    movl  $STDERR, %ebx
    movl  $SYS_WRITE, %eax
    int   $LINUX_SYSCALL

    pushl $STDERR
    call  _write_newline

                            # Exit with status 1.
    movl  $SYS_EXIT, %eax
    movl  $1, %ebx
    int   $LINUX_SYSCALL
