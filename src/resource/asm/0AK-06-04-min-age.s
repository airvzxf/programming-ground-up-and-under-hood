    # Assemble with `as --32` and `ld -m elf_i386`.
    # Link with `006-01-read-record.o`.
    #
    # PURPOSE:
    #     Solution to Chapter 6, "Use the Concepts":
    #     find the smallest age in `test.dat` and
    #     return it as the exit status code.
    #     Create `test.dat` first with
    #     `006-01-write-records`.
    #
    # VARIABLES:
    #     %esi - File descriptor.
    #     %edi - smallest age so far.
    #
    .include "006-01-linux.s"
    .include "006-01-record-def.s"

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
    movl  $0, %ecx           # Read only.
    movl  $0666, %edx
    int   $LINUX_SYSCALL
    movl  %eax, %esi

    movl  $0, %edi           # 0 if there are no
    movl  $1, %ebx           # records; %ebx = 1
                             # marks the first one.
_record_loop:
    pushl %esi
    pushl $record_buffer
    call  _read_record
    addl  $8, %esp
    cmpl  $RECORD_SIZE, %eax
    jne   _finished

    movl  record_buffer + RECORD_AGE, %eax
    cmpl  $1, %ebx           # First record: it is
    je    _new_value         # the smallest so far.
    cmpl  %edi, %eax
    jge   _record_loop       # Not smaller.
_new_value:
    movl  %eax, %edi
    movl  $0, %ebx
    jmp   _record_loop

_finished:
    movl  $SYS_CLOSE, %eax
    movl  %esi, %ebx
    int   $LINUX_SYSCALL

    movl  $SYS_EXIT, %eax
    movl  %edi, %ebx         # The age is the
    int   $LINUX_SYSCALL     # status code.
