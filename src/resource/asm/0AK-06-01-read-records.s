    # Assemble with `as --32` and `ld -m elf_i386`.
    # Link with `0AK-06-01-record-io.o`,
    # `006-01-count-chars.o` and
    # `006-01-write-newline.o`.
    #
    # PURPOSE:
    #     Print the first name and the phone number
    #     of every record in `test-phone.dat`.
    #
    .include "006-01-linux.s"
    .include "0AK-06-01-record-def.s"

    .section .data
        file_name:
            .ascii "test-phone.dat\0"
        separator:
            .ascii ": "

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
    movl  %eax, %esi         # File descriptor.

_record_loop:
    pushl %esi
    pushl $record_buffer
    call  _read_record
    addl  $8, %esp
    cmpl  $RECORD_SIZE, %eax # A whole record?
    jne   _finished

    pushl $record_buffer + RECORD_FIRSTNAME
    call  _print_string
    addl  $4, %esp

    movl  $SYS_WRITE, %eax   # ": "
    movl  $STDOUT, %ebx
    movl  $separator, %ecx
    movl  $2, %edx
    int   $LINUX_SYSCALL

    pushl $record_buffer + RECORD_PHONE
    call  _print_string
    addl  $4, %esp

    pushl $STDOUT
    call  _write_newline
    addl  $4, %esp
    jmp   _record_loop

_finished:
    movl  $SYS_EXIT, %eax
    movl  $0, %ebx
    int   $LINUX_SYSCALL

    # PURPOSE:
    #     Write a null-terminated string to STDOUT.
    #
        .type _print_string, @function
_print_string:
    pushl %ebp
    movl  %esp, %ebp
    pushl %ebx
    pushl 8(%ebp)
    call  _count_chars
    addl  $4, %esp
    movl  %eax, %edx         # Length.
    movl  $SYS_WRITE, %eax
    movl  $STDOUT, %ebx
    movl  8(%ebp), %ecx
    int   $LINUX_SYSCALL
    popl  %ebx
    movl  %ebp, %esp
    popl  %ebp
    ret
