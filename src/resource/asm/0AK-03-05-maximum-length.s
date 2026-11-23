    # Assemble with `as --32` and `ld -m elf_i386`.
    #
    # PURPOSE:
    #     Solution to Chapter 3, "Use the Concepts":
    #     find the maximum number of a set of data
    #     items, using a length count instead of a
    #     terminating number.
    #
    # VARIABLES:
    #     %edi - Index of the data item being examined.
    #     %ebx - Largest data item found.
    #     %eax - Current data item.
    #
    .section .data
        data_length:         # Number of items.
            .long 8
        data_items:
            .long 3, 67, 34, 222, 45, 22, 11, 125

    .section .text
        .globl _start

_start:
    movl $0, %edi            # Start at index 0.
    movl data_items(,%edi,4), %ebx
                             # The first item is the
                             # largest so far.

_start_loop:
    incl %edi                # Next index.
    cmpl data_length, %edi   # index == length?
    je   _loop_exit
    movl data_items(,%edi,4), %eax
    cmpl %ebx, %eax
    jle  _start_loop
    movl %eax, %ebx          # New largest value.
    jmp  _start_loop

_loop_exit:
    movl $1, %eax            # exit(); %ebx holds
    int  $0x80               # the maximum.
