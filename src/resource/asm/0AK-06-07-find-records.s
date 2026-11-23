    # Assemble with `as --32` and `ld -m elf_i386`.
    # Link with `0AK-06-06-compare-strings.o`,
    # `006-01-read-record.o`, `006-01-count-chars.o`
    # and `006-01-write-newline.o`.
    #
    # PURPOSE:
    #     Solution to Chapter 6, "Going Further":
    #     read up to 5 characters from STDIN and
    #     print the first name of every record in
    #     `test.dat` that starts with them.
    #
    # USAGE:
    #     echo Mar | ./0AK-06-07-find-records
    #
    .include "006-01-linux.s"
    .include "006-01-record-def.s"
        .equ INPUT_SIZE, 5

    .section .data
        file_name:
            .ascii "test.dat\0"

    .section .bss
        .lcomm record_buffer, RECORD_SIZE
        .lcomm input, INPUT_SIZE + 1  # + null byte.

    .section .text
        .globl _start

_start:
    movl  $SYS_READ, %eax    # Read the prefix.
    movl  $STDIN, %ebx
    movl  $input, %ecx
    movl  $INPUT_SIZE, %edx
    int   $LINUX_SYSCALL
    cmpl  $0, %eax           # Nothing read (or an
    jle   _exit              # error): stop.

    # End the text at the first newline, if any,
    # so "Mar\n" is used as "Mar".
    movl  $0, %ecx
_find_newline:
    cmpl  %eax, %ecx
    je    _open_file
    cmpb  $'\n', input(%ecx)
    je    _cut
    incl  %ecx
    jmp   _find_newline
_cut:
    movb  $0, input(%ecx)

_open_file:
    movl  $SYS_OPEN, %eax
    movl  $file_name, %ebx
    movl  $0, %ecx
    movl  $0666, %edx
    int   $LINUX_SYSCALL
    movl  %eax, %esi

_record_loop:
    pushl %esi
    pushl $record_buffer
    call  _read_record
    addl  $8, %esp
    cmpl  $RECORD_SIZE, %eax
    jne   _exit

    pushl $record_buffer + RECORD_FIRSTNAME
    pushl $input
    call  _compare_strings
    addl  $8, %esp
    cmpl  $1, %eax
    jne   _record_loop       # No match.

    pushl $record_buffer + RECORD_FIRSTNAME
    call  _count_chars
    addl  $4, %esp
    movl  %eax, %edx
    movl  $SYS_WRITE, %eax
    movl  $STDOUT, %ebx
    movl  $record_buffer + RECORD_FIRSTNAME, %ecx
    int   $LINUX_SYSCALL
    pushl $STDOUT
    call  _write_newline
    addl  $4, %esp
    jmp   _record_loop

_exit:
    movl  $SYS_EXIT, %eax
    movl  $0, %ebx
    int   $LINUX_SYSCALL
