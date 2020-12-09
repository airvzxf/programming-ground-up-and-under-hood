    # Assemble with `as --32` and `ld -m elf_i386`.
    #
    .include "006-01-linux.s"      # Linux Definitions.

    # PURPOSE:
    #     Represent the memory layout.
    #

    .section .data
        name:
            .ascii "Leo\0"
        age:
            .int 31
        id:
            .long 89485

    .section .bss
        .lcomm  comment,  128
        .lcomm  author,   3
        .equ    items,    5

    .section .text
        .globl _start

_start:
    movl  $SYS_BRK, %eax
    movl  $0, %ebx
    int   $LINUX_SYSCALL    # Find out the break.

    call  _hello

    call  _fine

    jmp   _bye

_hello:
    pushl %ebp              # Save old base pointer.
    movl  %esp, %ebp        # Make ST the BP.

    pushl %eax
    movl  $name, %eax
    popl  %eax

    movl %ebp, %esp         # Restore the ST.
    popl %ebp               # Restore the BP.
    ret

_fine:
    pushl %ebp              # Save old base pointer.
    movl  %esp, %ebp        # Make ST the BP.

    subl  $12, %esp         # Add local variables.

                # It is the same as %esp storage but
                # using %ebp we need negative numbers.
    movl  $age, 4(%esp)       # Store at 1nd space.
    movl  $author, -8(%ebp)   # Store at 1rd space.

    movl  $id, 8(%esp)        # Store at 2rd space.
    movl  $comment, -4(%ebp)  # Store at 2nd space.

                # Remember the rule: Positive numbers
                # take old stored values, negative
                # numbers take the new stored values.

    pushl age               # Push the age.
    popl  %eax              # Remove the age.

                # It is not necessary since the next
                # line restore the %esp to the %ebp.
    addl  $12, %esp         # Remove local variables.

    movl %ebp, %esp         # Restore the ST.
    popl %ebp               # Restore the BP.
    ret

_bye:
    movl   $SYS_EXIT, %eax
    movl   $0, %ebx
    int    $LINUX_SYSCALL
