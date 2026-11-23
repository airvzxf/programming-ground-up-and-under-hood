    # Assemble with `as --32` and `ld -m elf_i386`.
    #
    # PURPOSE:
    #     Solution to Chapter 3, "Use the Concepts":
    #     find the minimum number of a set of data
    #     items. A 0 terminates the data.
    #
    # VARIABLES:
    #     %edi - Index of the data item being examined.
    #     %ebx - Smallest data item found.
    #     %eax - Current data item.
    #
    # NOTE:
    #     The terminator must be checked BEFORE the
    #     comparison. Otherwise the final 0 would be
    #     taken as the smallest number of the list.
    #
    .section .data
        data_items:
            .long 3, 67, 34, 222, 45, 22, 11, 125, 0

    .section .text
        .globl _start

_start:
    movl $0, %edi            # Start at index 0.
    movl data_items(,%edi,4), %eax
    movl %eax, %ebx          # The first item is the
                             # smallest so far.

_start_loop:
    incl %edi                # Load the next item.
    movl data_items(,%edi,4), %eax
    cmpl $0, %eax            # End of the list?
    je   _loop_exit
    cmpl %ebx, %eax          # Compare with the
    jge  _start_loop         # smallest; skip it if
                             # it is not smaller.
    movl %eax, %ebx          # New smallest value.
    jmp  _start_loop

_loop_exit:
    movl $1, %eax            # exit(); %ebx holds
    int  $0x80               # the minimum.
