    # Assemble with `as --32` and `ld -m elf_i386`.
    #
    # PURPOSE:
    #     Solution to Chapter 3, "Use the Concepts":
    #     find the maximum number of a set of data
    #     items, stopping at an ending address
    #     instead of a terminating number.
    #
    # VARIABLES:
    #     %ecx - Address of the data item examined.
    #     %ebx - Largest data item found.
    #     %eax - Current data item.
    #
    .section .data
        data_items:
            .long 3, 67, 34, 222, 45, 22, 11, 125
        data_end:            # First address AFTER
                             # the last item.

    .section .text
        .globl _start

_start:
    movl $data_items, %ecx   # Address of item 0.
    movl (%ecx), %ebx        # The first item is the
                             # largest so far.

_start_loop:
    addl $4, %ecx            # Next item (4 bytes).
    cmpl $data_end, %ecx     # Past the last item?
    je   _loop_exit
    movl (%ecx), %eax        # Indirect addressing.
    cmpl %ebx, %eax
    jle  _start_loop
    movl %eax, %ebx          # New largest value.
    jmp  _start_loop

_loop_exit:
    movl $1, %eax            # exit(); %ebx holds
    int  $0x80               # the maximum.
