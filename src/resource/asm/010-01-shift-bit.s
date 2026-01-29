    # Assemble with `as --32` and `ld -m elf_i386`.
    #
    .include "006-01-linux.s"      # Linux Definitions.

    .section .text
        .globl _start

_start:
    movl   $0b00000000000000000000000000001011, %ebx

                # This is the shift operator. It stands
                # for Shift Right Long. This first
                # number is the number of positions to
                # shift, and the second is the register
                # to shift.
    shrl  $1, %ebx

                # This does the masking.
    andl  $0b00000000000000000000000000000001, %ebx

                # Check to see if the result is 1 or 0.
    cmpl  $0b00000000000000000000000000000001, %ebx
    je    _yes_he_likes_dressy_clothes
    jmp   _no_he_doesnt_like_dressy_clothes

_yes_he_likes_dressy_clothes:
_no_he_doesnt_like_dressy_clothes:
    movl   $SYS_EXIT, %eax
    movl   $0, %ebx
    int    $LINUX_SYSCALL
