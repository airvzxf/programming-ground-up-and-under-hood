    # Assemble with `as --32` and `ld -m elf_i386`.
    # Link with `0AK-05-00-convert-to-upper.o`.
    #
    # PURPOSE:
    #     Solution to Chapter 5, "Use the Concepts":
    #     convert STDIN to upper case and write it to
    #     STDOUT. No files are opened or closed: the
    #     shell already opened file descriptors 0
    #     and 1 for us.
    #
    # USAGE:
    #     echo "hello" | ./0AK-05-01-toupper-stdio
    #
    .include "006-01-linux.s"

    .section .bss
        .equ   BUFFER_SIZE, 500
        .lcomm BUFFER_DATA, BUFFER_SIZE

    .section .text
        .globl _start

_start:
_read_loop:
    movl  $SYS_READ, %eax
    movl  $STDIN, %ebx
    movl  $BUFFER_DATA, %ecx
    movl  $BUFFER_SIZE, %edx
    int   $LINUX_SYSCALL
    cmpl  $END_OF_FILE, %eax # End of file (0) or
    jle   _exit              # error (negative)?

    movl  %eax, %esi         # Bytes read.
    pushl $BUFFER_DATA
    pushl %esi
    call  _convert_to_upper
    addl  $8, %esp

    movl  $SYS_WRITE, %eax
    movl  $STDOUT, %ebx
    movl  $BUFFER_DATA, %ecx
    movl  %esi, %edx
    int   $LINUX_SYSCALL
    jmp   _read_loop

_exit:
    movl  $SYS_EXIT, %eax
    movl  $0, %ebx
    int   $LINUX_SYSCALL
