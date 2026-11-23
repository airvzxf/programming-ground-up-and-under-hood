    # Assemble with `as --32` and `ld -m elf_i386`.
    # Link with `0AK-06-01-record-io.o`.
    #
    # PURPOSE:
    #     Write two records with a phone number to
    #     `test-phone.dat`.
    #
    .include "006-01-linux.s"
    .include "0AK-06-01-record-def.s"

    .section .data
        file_name:
            .ascii "test-phone.dat\0"

        # Each field is padded with zeros up to its
        # size; `.space N` reserves N zero bytes.
        record1:
            .ascii "Fredrick\0"
            .space 40 - 9
            .ascii "Bartlett\0"
            .space 40 - 9
            .ascii "4242 S Prairie\nTulsa, OK 55555\0"
            .space 240 - 31
            .long 45
            .ascii "555-0100\0"
            .space 20 - 9
        record2:
            .ascii "Marilyn\0"
            .space 40 - 8
            .ascii "Taylor\0"
            .space 40 - 7
            .ascii "2224 S Johannan St\nChicago, IL\0"
            .space 240 - 31
            .long 29
            .ascii "555-0199\0"
            .space 20 - 9

    .section .text
        .globl _start

_start:
    movl  $SYS_OPEN, %eax
    movl  $file_name, %ebx
    movl  $03101, %ecx       # Create, write, truncate.
    movl  $0666, %edx
    int   $LINUX_SYSCALL
    movl  %eax, %esi         # File descriptor.

    pushl %esi
    pushl $record1
    call  _write_record
    addl  $8, %esp

    pushl %esi
    pushl $record2
    call  _write_record
    addl  $8, %esp

    movl  $SYS_CLOSE, %eax
    movl  %esi, %ebx
    int   $LINUX_SYSCALL

    movl  $SYS_EXIT, %eax
    movl  $0, %ebx
    int   $LINUX_SYSCALL
