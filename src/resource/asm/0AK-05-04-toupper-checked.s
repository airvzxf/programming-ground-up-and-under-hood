    # Assemble with `as --32` and `ld -m elf_i386`.
    # Link with `0AK-05-00-convert-to-upper.o` and
    # `006-01-count-chars.o`.
    #
    # PURPOSE:
    #     Solution to Chapter 5, "Going Further":
    #     with two arguments, convert the input file
    #     into the output file; with no arguments,
    #     convert STDIN into STDOUT. Every system
    #     call is checked, and errors are reported.
    #
    # USAGE:
    #     ./0AK-05-04-toupper-checked in.txt out.txt
    #     echo "hi" | ./0AK-05-04-toupper-checked
    #
    # NOTES:
    #     The exercise asks for the messages on
    #     STDOUT, but they go to STDERR: that way
    #     they never get mixed with the converted
    #     text when STDOUT is redirected to a file.
    #     Linux returns errors as a negative number
    #     (-errno) in %eax.
    #
    .include "006-01-linux.s"
        .equ O_RDONLY,             0
        .equ O_CREAT_WRONLY_TRUNC, 03101
        .equ ST_ARGC,              0
        .equ ST_ARGV_1,            8
        .equ ST_ARGV_2,            12

    .section .data
        msg_usage:
            .ascii "Usage: toupper [input output]\n\0"
        msg_open_in:
            .ascii "Error: can't open input file\n\0"
        msg_open_out:
            .ascii "Error: can't open output file\n\0"
        msg_read:
            .ascii "Error: read failed\n\0"
        msg_write:
            .ascii "Error: write failed\n\0"

    .section .bss
        .equ   BUFFER_SIZE, 500
        .lcomm BUFFER_DATA, BUFFER_SIZE
        .lcomm FD_IN,  4
        .lcomm FD_OUT, 4

    .section .text
        .globl _start

_start:
    movl  %esp, %ebp
    movl  $STDIN, FD_IN      # Defaults.
    movl  $STDOUT, FD_OUT

    movl  ST_ARGC(%ebp), %eax
    cmpl  $1, %eax           # No arguments.
    je    _read_loop
    cmpl  $3, %eax           # Two arguments.
    je    _open_files
    pushl $msg_usage
    jmp   _fail

_open_files:
    movl  $SYS_OPEN, %eax
    movl  ST_ARGV_1(%ebp), %ebx
    movl  $O_RDONLY, %ecx
    movl  $0666, %edx
    int   $LINUX_SYSCALL
    cmpl  $0, %eax           # Negative = error.
    jl    _fail_open_in
    movl  %eax, FD_IN

    movl  $SYS_OPEN, %eax
    movl  ST_ARGV_2(%ebp), %ebx
    movl  $O_CREAT_WRONLY_TRUNC, %ecx
    movl  $0666, %edx
    int   $LINUX_SYSCALL
    cmpl  $0, %eax
    jl    _fail_open_out
    movl  %eax, FD_OUT

_read_loop:
    movl  $SYS_READ, %eax
    movl  FD_IN, %ebx
    movl  $BUFFER_DATA, %ecx
    movl  $BUFFER_SIZE, %edx
    int   $LINUX_SYSCALL
    cmpl  $0, %eax
    jl    _fail_read
    je    _close_files       # End of file.

    movl  %eax, %esi
    pushl $BUFFER_DATA
    pushl %esi
    call  _convert_to_upper
    addl  $8, %esp

    movl  $SYS_WRITE, %eax
    movl  FD_OUT, %ebx
    movl  $BUFFER_DATA, %ecx
    movl  %esi, %edx
    int   $LINUX_SYSCALL
    cmpl  $0, %eax
    jl    _fail_write
    jmp   _read_loop

_close_files:
    movl  $SYS_CLOSE, %eax   # Closing STDIN or
    movl  FD_OUT, %ebx       # STDOUT is harmless
    int   $LINUX_SYSCALL     # at exit.
    movl  $SYS_CLOSE, %eax
    movl  FD_IN, %ebx
    int   $LINUX_SYSCALL
    movl  $SYS_EXIT, %eax
    movl  $0, %ebx
    int   $LINUX_SYSCALL

_fail_open_in:
    pushl $msg_open_in
    jmp   _fail
_fail_open_out:
    pushl $msg_open_out
    jmp   _fail
_fail_read:
    pushl $msg_read
    jmp   _fail
_fail_write:
    pushl $msg_write

    # Write the message on top of the stack to
    # STDERR and exit with status 1.
_fail:
    call  _count_chars       # Length of message.
    movl  %eax, %edx
    popl  %ecx               # Message address.
    movl  $SYS_WRITE, %eax
    movl  $STDERR, %ebx
    int   $LINUX_SYSCALL
    movl  $SYS_EXIT, %eax
    movl  $1, %ebx
    int   $LINUX_SYSCALL
