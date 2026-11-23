    # Assemble with `as --32` and `ld -m elf_i386`.
    # Link with `006-01-write-record.o`.
    #
    # PURPOSE:
    #     Solution to Chapter 6, "Use the Concepts":
    #     write 30 identical records to `test30.dat`
    #     with a loop.
    #
    # OUTPUT:
    #     A file of 30 * 324 = 9720 bytes.
    #
    .include "006-01-linux.s"
    .include "006-01-record-def.s"

    .section .data
        file_name:
            .ascii "test30.dat\0"
        record:
            .ascii "Fredrick\0"
            .space 40 - 9
            .ascii "Bartlett\0"
            .space 40 - 9
            .ascii "4242 S Prairie\nTulsa, OK 55555\0"
            .space 240 - 31
            .long 45

    .section .text
        .globl _start
        .equ RECORD_COUNT, 30

_start:
    movl  $SYS_OPEN, %eax
    movl  $file_name, %ebx
    movl  $03101, %ecx       # Create, write, truncate.
    movl  $0666, %edx
    int   $LINUX_SYSCALL
    movl  %eax, %esi         # File descriptor.

    movl  $RECORD_COUNT, %edi    # Loop counter.
_write_loop:
    pushl %esi
    pushl $record
    call  _write_record
    addl  $8, %esp
    decl  %edi
    jnz   _write_loop        # Until %edi = 0.

    movl  $SYS_CLOSE, %eax
    movl  %esi, %ebx
    int   $LINUX_SYSCALL

    movl  $SYS_EXIT, %eax
    movl  $0, %ebx
    int   $LINUX_SYSCALL
