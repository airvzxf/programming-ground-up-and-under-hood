    # Assemble with `as --32` and `ld -m elf_i386`.
    # Link with `006-01-read-record.o` and
    # `006-01-write-record.o`.
    #
    # PURPOSE:
    #     Solution to Chapter 6, "Going Further":
    #     add a year to every age in `test.dat`,
    #     writing each record back into the same
    #     file.
    #
    # HOW IT WORKS:
    #     The file is opened for reading and writing
    #     (O_RDWR = 2). After reading a record, the
    #     file offset points to the next record, so
    #     `lseek(fd, -RECORD_SIZE, SEEK_CUR)` moves it
    #     back to the start of the record just read
    #     before writing it again.
    #
    .include "006-01-linux.s"
    .include "006-01-record-def.s"
        .equ SYS_LSEEK,  19
        .equ SEEK_CUR,   1
        .equ O_RDWR,     2

    .section .data
        file_name:
            .ascii "test.dat\0"

    .section .bss
        .lcomm record_buffer, RECORD_SIZE

    .section .text
        .globl _start

_start:
    movl  $SYS_OPEN, %eax
    movl  $file_name, %ebx
    movl  $O_RDWR, %ecx
    movl  $0666, %edx
    int   $LINUX_SYSCALL
    movl  %eax, %esi         # File descriptor.

_record_loop:
    pushl %esi
    pushl $record_buffer
    call  _read_record
    addl  $8, %esp
    cmpl  $RECORD_SIZE, %eax
    jne   _finished

    incl  record_buffer + RECORD_AGE

    movl  $SYS_LSEEK, %eax   # Go back one record.
    movl  %esi, %ebx
    movl  $-RECORD_SIZE, %ecx
    movl  $SEEK_CUR, %edx
    int   $LINUX_SYSCALL

    pushl %esi               # Overwrite it.
    pushl $record_buffer
    call  _write_record
    addl  $8, %esp
    jmp   _record_loop

_finished:
    movl  $SYS_CLOSE, %eax
    movl  %esi, %ebx
    int   $LINUX_SYSCALL
    movl  $SYS_EXIT, %eax
    movl  $0, %ebx
    int   $LINUX_SYSCALL
