    # Assemble with `as --32` and `ld -m elf_i386`.
    #
    .include "006-01-linux.s"      # Linux Definitions.

    .section .data          # This is where it will be
        tmp_buffer:         # stored.
            .ascii "\0\0\0\0\0\0\0\0\0\0\0"

    .section .text
        .globl _start

_start:
    movl  %esp, %ebp

    pushl $tmp_buffer       # Storage for the result.
    pushl $824              # Number to convert.
    call  _integer2string
    addl  $8, %esp

    pushl $tmp_buffer       # Get the character count
                            # for our system call.
    call  _count_chars
    addl  $4, %esp

    movl  %eax, %edx        # The count goes in %edx
                            # for SYS_WRITE.

    movl  $SYS_WRITE, %eax  # Make the system call.
    movl  $STDOUT, %ebx
    movl  $tmp_buffer, %ecx

    int   $LINUX_SYSCALL

    pushl $STDOUT           # Write a carriage return.
    call  _write_newline

    movl  $SYS_EXIT, %eax   # Exit.
    movl  $0, %ebx
    int   $LINUX_SYSCALL
