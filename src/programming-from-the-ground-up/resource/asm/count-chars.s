    .code32                 # Generate 32-bit code.

    # PURPOSE:
    #     Count the characters until a null byte is
    #     reached.
    #
    # INPUT:
    #     The address of the character string.
    #
    # OUTPUT:
    #     Returns the count in %eax.
    #
    # PROCESS:
    #     Registers used:
    #       %ecx - character count.
    #       %al  - current character.
    #       %edx - current character address.
    #
        .globl _count_chars
        .type  _count_chars,  @function

                            # The parameter is on the
                            # stack.
        .equ ST_STRING_START_ADDRESS,  8

_count_chars:
    pushl %ebp
    movl  %esp, %ebp

    movl  $0, %ecx          # Counter starts at zero.

                            # Starting address of data.
    movl  ST_STRING_START_ADDRESS(%ebp), %edx

_count_loop_begin:
    movb  (%edx), %al       # Grab the current
                            # character.

    cmpb  $0, %al           # Is it null?
    je    _count_loop_end   # If yes, we are done.

    incl  %ecx              # Otherwise, increment the
                            # counter and the pointer.
    incl  %edx
    jmp   _count_loop_begin # Go back to the beginning
                            # of the loop.

_count_loop_end:
    movl  %ecx, %eax        # We are done.  Move the
                            # count into %eax and
                            # return.

    popl  %ebp
    ret
