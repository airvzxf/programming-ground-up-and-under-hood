    # Assemble with `as --32` and `ld -m elf_i386`.
    #
    .include "006-01-linux.s"      # Linux Definitions.
    .include "006-01-record-def.s" # Record definitions

    # PURPOSE:
    #     This function reads a record from the file
    #     descriptor.
    #
    # INPUT:
    #     The file descriptor and a buffer.
    #
    # OUTPUT:
    #     This function writes the data to the buffer
    #     and returns a status code.
    #
    # ----- STACK LOCAL VARIABLES ----- #
    #
        .equ ST_READ_BUFFER,  8
        .equ ST_FILEDES,      12

    .section .text
        .globl _read_record
        .type  _read_record,  @function

_read_record:
    pushl %ebp
    movl  %esp, %ebp

    pushl %ebx
    movl  ST_FILEDES(%ebp), %ebx
    movl  ST_READ_BUFFER(%ebp), %ecx
    movl  $RECORD_SIZE, %edx
    movl  $SYS_READ, %eax
    int   $LINUX_SYSCALL

    popl  %ebx          # NOTE - %eax has the return
                        # value, which we will give
                        # back to our calling program.

    movl  %ebp, %esp
    popl  %ebp
    ret
