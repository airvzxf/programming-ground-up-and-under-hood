    .code32                 # Generate 32-bit code.

    # PURPOSE:
    #     This program finds the maximum number of a
    #     set of data items.
    #
    # VARIABLES:
    #     The registers have the following uses:
    #       %edi - Holds the index of the data item
    #       being examined.
    #       %ebx - Largest data item found.
    #       %eax - Current data item.
    #
    # The following memory locations are used:
    #     data_items - contains the item data.  A 0 is
    #                  usedto terminate the data.
    #
    .section .data
        data_items:         # These are the data items.
            .long 3, 67, 34, 222, 45, 75, 54, 34,
                  44, 33, 22, 11, 66, 0

    .section .text
        .globl _start

_start:
    movl $0, %edi           # Move 0 into the index
                            # register.
    movl data_items(,%edi,4), %eax  # Load the first
                                    # byte of data.
    movl %eax, %ebx         # Since this is the first
                            # item, %eax is the biggest

_start_loop:                # Start loop.
    cmpl $0, %eax           # Check to see if we have
    je _loop_exit           #  hit the end.
    incl %edi               # Increment %edi by 1.
    movl data_items(,%edi,4), %eax   # Load next value.
    cmpl %ebx, %eax         # Compare values.
    jle _start_loop         # Jump to loop beginning if
                            # the new one is not bigger
    movl %eax, %ebx         # Move the value as the
                            # largest.
    jmp _start_loop         # Jump to loop beginning.

_loop_exit:
                            # %ebx is the status code
                            # for the exit systemcall
        movl $1, %eax       # and it already has the
        int  $0x80          # maximum number 1 is the
                            # exit() syscall.
