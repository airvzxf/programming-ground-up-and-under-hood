    .code32                 # Generate 32-bit code.

    # PURPOSE:
    #     Convert an integer number to a decimal string
    #     for display.
    #
    # INPUT:
    #     A buffer large enough to hold the largest
    #     possible number an integer to convert.
    #
    # OUTPUT:
    #     The buffer will be overwritten with the
    #     decimal string.
    #
    # Variables:
    #     %ecx will hold the count of characters
    #     processed.
    #     %eax will hold the current value.
    #     %edi will hold the base (10).
    #
        .equ ST_VALUE,   8
        .equ ST_BUFFER,  12

        .globl _integer2string
        .type  _integer2string,  @function

_integer2string:
    pushl %ebp              # Normal function beginning
    movl  %esp, %ebp

    movl  $0, %ecx          # Current character count.

                            # Move the value into
                            # position.
    movl  ST_VALUE(%ebp), %eax

    movl  $10, %edi         # When we divide by 10, the
                            # 10 must be in a register
                            # or memory location.

_conversion_loop:
    # Division is actually performed on the combined
    # %edx:%eax register, so first clear out %edx.
    #
    movl  $0, %edx

    # Divide %edx:%eax (which are implied) by 10. Store
    # the quotient in %eax and the remainder in %edx
    # (both of which are implied).
    #
    divl  %edi

    # Quotient is in the right place.  %edx has the
    # remainder, which now needs to be converted into a
    # number.  So, %edx has a number that is 0 through
    # 9.  You could also interpret this as an index on
    # the ASCII table starting from the character '0'.
    # The ascii code for '0' plus zero is still the
    # ascii code for '0'.  The ascii code for '0' plus
    # 1 is the ascii code for the character '1'.
    # Therefore, the following instruction will give us
    # the character for the number stored in %edx.
    #
    addl  $'0', %edx

    # Now we will take this value and push it on the
    # stack.  This way, when we are done, we can just
    # pop off the characters one-by-one and they will
    # be in the right order.  Note that we are pushing
    # the whole register, but we only need the byte in
    # %dl (the last byte of the %edx register) for the
    # character.
    #
    pushl %edx

    incl  %ecx              # Increment the digit count

    cmpl  $0, %eax          # Check to see if %eax is
                            # zero yet,
    je    _end_conversion_loop  # go to next step if so
                            # %eax already has its new
                            # value.

    jmp _conversion_loop

_end_conversion_loop:
    # The string is now on the stack, if we pop it off
    # a character at a time we can copy it into the
    # buffer and be done.
    #
    movl  ST_BUFFER(%ebp), %edx     # Get the pointer
                                    # to the buffer in
                                    # %edx.

_copy_reversing_loop:
    # We pushed a whole register, but we only need the
    # last byte.  So we are going to pop off to the
    # entire %eax register, but then only move the
    # small part (%al) into the character string.
    #
    popl  %eax
    movb  %al, (%edx)

    decl  %ecx              # Decreasing %ecx so we
                            # know when we are finished

    incl  %edx              # Increasing %edx so that
                            # it will be pointing to
                            # the next byte.

    cmpl  $0, %ecx          # Check to see if we are
                            # finished.
    je    _end_copy_reversing_loop  # If so, jump to
                                    # the end of the
                                    # function.
    jmp   _copy_reversing_loop      # Otherwise, repeat
                                    # the loop.

_end_copy_reversing_loop:
    movb  $0, (%edx)        # Done copying.  Now write
                            # a null byte and return.

    movl  %ebp, %esp
    popl  %ebp
    ret
