    # Assemble with `as --32` and `ld -m elf_i386`.
    #
    .include "006-01-linux.s"      # Linux Definitions.
    .include "006-01-record-def.s" # Record definitions

    # PURPOSE:
    #     This function writes a record to the given
    #     file descriptor.
    #
    # INPUT:
    #     The file descriptor and a buffer.
    #
    # OUTPUT:
    #     This function produces a status code.
    #
    # ----- STACK LOCAL VARIABLES ----- #
    #
        .equ ST_WRITE_BUFFER,  8
        .equ ST_FILEDES,       12

    .section .text
        .globl _write_record
        .type  _write_record,  @function

_write_record:
    pushl %ebp
    movl  %esp, %ebp

    pushl %ebx
    movl  $SYS_WRITE, %eax
    movl  ST_FILEDES(%ebp), %ebx
    movl  ST_WRITE_BUFFER(%ebp), %ecx
    movl  $RECORD_SIZE, %edx
    int   $LINUX_SYSCALL

    popl  %ebx      # NOTE - %eax has the return value,
                    # which we will give back to our
                    # calling program.

    movl  %ebp, %esp
    popl  %ebp
    ret
