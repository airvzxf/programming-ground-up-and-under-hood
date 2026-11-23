    # Assemble with `as --32`.
    # Build the shared library with:
    #     ld -shared -m elf_i386 \
    #       -o libexitmsg.so 0AK-08-04-exit-message.o
    # Use it with a 32-bit program linked with the
    # C library:
    #     LD_PRELOAD=./libexitmsg.so \
    #       ./008-02-printf-example
    #
    # PURPOSE:
    #     Solution to Chapter 8, "Going Further": a
    #     shared library with its own `exit` function.
    #     With LD_PRELOAD, the dynamic linker finds
    #     this `exit` before the one in the C
    #     library, so every call to `exit` writes a
    #     message to STDERR first.
    #
    # NOTES:
    #     This `exit` doesn't flush the C library
    #     buffers, so text that `printf` wrote
    #     without a final newline may be lost.
    #     A shared library can't use the absolute
    #     address of its data, because it doesn't
    #     know where it will be loaded. `call` +
    #     `popl` gets the current address, and the
    #     message is found relative to it.
    #
        .equ SYS_WRITE, 4
        .equ SYS_EXIT,  1
        .equ STDERR,    2

    .section .text
        .globl exit
        .type  exit, @function
exit:
    call  _here              # Pushes the address of
_here:                       # `_here` and jumps to
    popl  %ecx               # it; pop it to %ecx.
    addl  $message - _here, %ecx  # %ecx = &message

    movl  $SYS_WRITE, %eax
    movl  $STDERR, %ebx
    movl  $MESSAGE_LEN, %edx
    int   $0x80

    movl  $SYS_EXIT, %eax
    movl  4(%esp), %ebx      # exit(status)
    int   $0x80

    message:
        .ascii "exit() called: bye!\n"
    message_end:
        .equ MESSAGE_LEN, message_end - message
