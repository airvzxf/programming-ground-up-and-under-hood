    # Assemble with `as --32` and `ld -m elf_i386`.
    #
    # PURPOSE:
    #     Solution to Chapter 3, "Use the Concepts":
    #     find the maximum number of a set of data
    #     items. A 255 terminates the data, so 0 is
    #     now a valid item.
    #
    # VARIABLES:
    #     %edi - Index of the data item being examined.
    #     %ebx - Largest data item found.
    #     %eax - Current data item.
    #
    .section .data
        data_items:
            .long 3, 67, 34, 0, 45, 22, 11, 125, 255

    .section .text
        .globl _start

_start:
    movl $0, %edi            # Start at index 0.
    movl data_items(,%edi,4), %eax
    movl %eax, %ebx          # The first item is the
                             # largest so far.

_start_loop:
    incl %edi                # Load the next item.
    movl data_items(,%edi,4), %eax
    cmpl $255, %eax          # End of the list?
    je   _loop_exit          # (Checked first, or
                             # 255 would win.)
    cmpl %ebx, %eax
    jle  _start_loop
    movl %eax, %ebx          # New largest value.
    jmp  _start_loop

_loop_exit:
    movl $1, %eax            # exit(); %ebx holds
    int  $0x80               # the maximum.
