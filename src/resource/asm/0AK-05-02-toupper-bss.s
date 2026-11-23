    # Assemble with `as --32` and `ld -m elf_i386`.
    # Link with `0AK-05-00-convert-to-upper.o`.
    #
    # PURPOSE:
    #     Solution to Chapter 5, "Use the Concepts":
    #     `005-01-toupper` storing the file
    #     descriptors in the .bss section instead of
    #     the stack. The buffer is also smaller
    #     (16 bytes), which only means more read and
    #     write calls; the result is the same.
    #
    # USAGE:
    #     ./0AK-05-02-toupper-bss input.txt output.txt
    #
    .include "006-01-linux.s"
        .equ O_RDONLY,             0
        .equ O_CREAT_WRONLY_TRUNC, 03101
        .equ ST_ARGV_1,            8
        .equ ST_ARGV_2,            12

    .section .bss
        .equ   BUFFER_SIZE, 16
        .lcomm BUFFER_DATA, BUFFER_SIZE
        .lcomm FD_IN,  4     # File descriptors.
        .lcomm FD_OUT, 4

    .section .text
        .globl _start

_start:
    movl  %esp, %ebp

    movl  $SYS_OPEN, %eax    # Open the input file.
    movl  ST_ARGV_1(%ebp), %ebx
    movl  $O_RDONLY, %ecx
    movl  $0666, %edx
    int   $LINUX_SYSCALL
    movl  %eax, FD_IN

    movl  $SYS_OPEN, %eax    # Open the output file.
    movl  ST_ARGV_2(%ebp), %ebx
    movl  $O_CREAT_WRONLY_TRUNC, %ecx
    movl  $0666, %edx
    int   $LINUX_SYSCALL
    movl  %eax, FD_OUT

_read_loop:
    movl  $SYS_READ, %eax
    movl  FD_IN, %ebx
    movl  $BUFFER_DATA, %ecx
    movl  $BUFFER_SIZE, %edx
    int   $LINUX_SYSCALL
    cmpl  $END_OF_FILE, %eax
    jle   _close_files

    movl  %eax, %esi         # Bytes read.
    pushl $BUFFER_DATA
    pushl %esi
    call  _convert_to_upper
    addl  $8, %esp

    movl  $SYS_WRITE, %eax
    movl  FD_OUT, %ebx
    movl  $BUFFER_DATA, %ecx
    movl  %esi, %edx
    int   $LINUX_SYSCALL
    jmp   _read_loop

_close_files:
    movl  $SYS_CLOSE, %eax
    movl  FD_OUT, %ebx
    int   $LINUX_SYSCALL
    movl  $SYS_CLOSE, %eax
    movl  FD_IN, %ebx
    int   $LINUX_SYSCALL

    movl  $SYS_EXIT, %eax
    movl  $0, %ebx
    int   $LINUX_SYSCALL
