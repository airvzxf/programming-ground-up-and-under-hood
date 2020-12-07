    # Assemble with `as --32` and `ld -m elf_i386`.
    #
    # PURPOSE:
    #     Program to manage memory usage - allocates
    #     and deallocates memory as requested.
    #
    # NOTES:
    #     The programs using these routines will ask
    #     for a certain size of memory.  We actually
    #     use more than that size, but we put it at the
    #     beginning, before the pointer we hand back.
    #     We add a size field and an
    #     AVAILABLE/UNAVAILABLE marker.  So, the memory
    #     looks like this.
    #
    ###################################################
    # - Available  -#-  Size of  -#-  Actual memory  -#
    # -  Marker    -#-  memory   -#-   locations     -#
    ###################################################
    #                             ^--Returned pointer
    #                                points here.
    #
    # The pointer we return only points to the actual
    # locations requested to make it easier for the
    # calling program.  It also allows us to change our
    # structure without the calling program having to
    # change at all.
    #
    .section .data
        # ----- GLOBAL VARIABLES ----- #
        #
        heap_begin:         # This points to the
            .long  0        # beginning of the memory
                            # we are managing.

        current_break:      # This points to one
            .long  0        # location past the memory
                            # we are managing.

        # ----- STRUCTURE INFORMATION ----- #
        #
        .equ HEADER_SIZE,      8    # Size of space for
                                    # memory region
                                    # header.

        .equ HDR_AVAIL_OFFSET, 0    # Location of the
                                    # "available" flag
                                    # in the header.

        .equ HDR_SIZE_OFFSET,  4    # Location of the
                                    # size field in the
                                    # header.

        # ----- CONSTANTS ----- #
        #
        .equ UNAVAILABLE,    0      # This is the
                                    # number we will
                                    # use to mark space
                                    # that has been
                                    # given out.

        .equ AVAILABLE,      1      # This is the
                                    # number we will
                                    # use to mark space
                                    # that has been
                                    # returned, and is
                                    # available for
                                    # giving.

        .equ SYS_BRK,        45     # System call
                                    # number for the
                                    # break system
                                    # call.

        .equ LINUX_SYSCALL,  0x80   # Make system calls
                                    # easier to read.

    .section .text
    # ----- FUNCTIONS ----- #
    #
    # ----- FUNCTION: _allocate_init ----- #
    #
    # PURPOSE:
    #     Call this function to initialize the
    #     functions (specifically, this sets heap_begin
    #     and current_break). This has no parameters
    #     and no return value.
    #
        .globl _allocate_init
        .type  _allocate_init,  @function

_allocate_init:
    pushl %ebp              # Standard function stuff.
    movl  %esp, %ebp

    # If the brk system call is called with 0 in %ebx,
    # it returns the last valid usable address.
    #
    movl  $SYS_BRK, %eax    # Find out where the
    movl  $0, %ebx          # break is.
    int   $LINUX_SYSCALL

    incl  %eax              # %eax now has the last
                            # valid address, and we
                            # want the memory location
                            # after that.

                            # Store the current break.
    movl  %eax, current_break

    movl  %eax, heap_begin  # Store the current break
                            # as our first address.
                            # This will cause the
                            # allocate function to get
                            # more memory from Linux
                            # the first time it is run.

    movl  %ebp, %esp        # Exit the function.
    popl  %ebp

    ret
    # ----- END OF FUNCTION: _allocate_init ----- #

    # ----- FUNCTION: allocate ----- #
    #
    # PURPOSE:
    #     This function is used to grab a section of
    #     memory. It checks to  see if there are any
    #     free blocks, and, if not, it asks Linux for
    #     a new one.
    #
    # PARAMETERS:
    #     This function has one parameter - the size
    #     of the memory block we want to allocate.
    #
    # RETURN VALUE:
    #     This function returns the address of the
    #     allocated memory in %eax.  If there is no
    #     memory available, it will return 0 in %eax.
    #
    # PROCESSING:
    #     Variables used:
    #       %ecx - hold the size of the requested
    #       memory (first/only parameter).
    #       %eax - current memory region being examined
    #       %ebx - current break position.
    #       %edx - size of current memory region.
    #
    # We scan through each memory region starting with
    # heap_begin. We look at the size of each one, and
    # if it has been allocated.  If it is big enough
    # for the requested size, and its available, it
    # grabs that one. If it does not find a region
    # large enough, it asks Linux for more memory.  In
    # that case, it moves current_break up.
    #
        .globl _allocate
        .type  _allocate,   @function

        .equ ST_MEM_SIZE,  8    # Stack position of the
                                # memory size to
                                # allocate.

_allocate:
    pushl %ebp              # Standard function stuff.
    movl  %esp, %ebp

                            # %ecx will hold the size
                            # we are looking for (which
                            # is the first and only
                            # parameter).
    movl  ST_MEM_SIZE(%ebp), %ecx

    movl  heap_begin, %eax  # %eax will hold the
                            # current search location.

                            # %ebx will hold the
                            # current break.
    movl  current_break, %ebx


_alloc_loop_begin:          # Here we iterate through
                            # each memory region.

    cmpl  %ebx, %eax        # Need more memory if these
    je    _move_break       # are equal.

                            # Grab the size of this
                            # memory.
    movl  HDR_SIZE_OFFSET(%eax), %edx

                            # If the space is
                            # unavailable, go to the
                            # next one.
    cmpl  $UNAVAILABLE, HDR_AVAIL_OFFSET(%eax)
    je    _allocate_init


    cmpl  %edx, %ecx        # If the space is
    jle   _allocate_here    # available, compare the
                            # size to the needed size.
                            # If its big enough, go to
                            # _allocate_here.

__next_location:
                    # The total size of the memory
                    # region is the sum of the size
                    # requested (currently stored in
                    # %edx), plus another 8 bytes for
                    # the header (4 for the
                    # AVAILABLE/UNAVAILABLE flag, and
                    # 4 for the size of the region).
                    # So, adding %edx and $8 to %eax
                    # will get the address of the next
                    # memory region.
                    #
    addl  $HEADER_SIZE, %eax
    addl  %edx, %eax

                    # Go look at the next location.
    jmp   _alloc_loop_begin

_allocate_here:     # If we have made it here, that
                    # means that the region header of
                    # the region to allocate is in
                    # %eax.

                            # Mark space as unavailable
    movl  $UNAVAILABLE, HDR_AVAIL_OFFSET(%eax)

                            # Move %eax past the header
                            # to the usable memory
                            # (since that is what we
                            # return).
    addl  $HEADER_SIZE, %eax



    movl  %ebp, %esp        # Return from the function.
    popl  %ebp
    ret

_move_break:        # If we have made it here, that
                    # means that we have exhausted all
                    # addressable memory, and we need
                    # to ask for more. %ebx holds the
                    # current endpoint of the data,
                    # and %ecx holds its size.

                    # We need to increase %ebx to
                    # where we _want_ memory to end,
                    # so we add space for the headers
                    # structure.
    addl  $HEADER_SIZE, %ebx



    addl  %ecx, %ebx        # Add space to the break
                            # for the data requested.

                            # Now its time to ask Linux
                            # for more memory.

    pushl %eax              # Save needed registers.
    pushl %ecx
    pushl %ebx

    movl  $SYS_BRK, %eax    # Reset the break (%ebx has
                            # the requested break
                            # point).

    int   $LINUX_SYSCALL    # Under normal conditions,
                            # this should return the
                            # new break in %eax, which
                            # will be either 0 if it
                            # fails, or it will be
                            # equal to or larger than
                            # we asked for. We do not
                            # care in this program
                            # where it actually sets
                            # the break, so as long as
                            # %eax is not 0, we do not
                            # care what it is.

    cmpl  $0, %eax          # Check for error
    je    _error            # conditions.

    popl  %ebx              # Restore saved registers.
    popl  %ecx
    popl  %eax

                            # Set this memory as
                            # unavailable, since we are
                            # about to give it away.
    movl  $UNAVAILABLE, HDR_AVAIL_OFFSET(%eax)



                            # Set the size of the
                            # memory.
    movl  %ecx, HDR_SIZE_OFFSET(%eax)

                            # Move %eax to the actual
                            # start of usable memory.
                            # %eax now holds the return
                            # value.
    addl  $HEADER_SIZE, %eax

    movl  %ebx, current_break   # Save the new break.

    movl  %ebp, %esp        # Return the function.
    popl  %ebp
    ret

_error:
    movl  $0, %eax          # On error, we return zero.
    movl  %ebp, %esp
    popl  %ebp
    ret
    # ----- END OF FUNCTION: allocate ----- #


    # ----- FUNCTION: _deallocate ----- #
    #
    # PURPOSE:
    #     The purpose of this function is to give back
    #     a region of memory to the pool after we are
    #     done using it.
    #
    # PARAMETERS:
    #     The only parameter is the address of the
    #     memory we want to return to the memory pool.
    #
    # RETURN VALUE:
    #     There is no return value
    #
    # PROCESSING:
    #     If you remember, we actually hand the program
    #     the start of the memory that they can use,
    #     which is 8 storage locations after the actual
    #     start of the memory region.  All we have to
    #     do is go back 8 locations and mark that
    #     memory as available, so that the allocate
    #     function knows it can use it.
    #
        .globl _deallocate
        .type  _deallocate,   @function

        .equ ST_MEMORY_SEG,  4  # Stack position of the
                                # memory region to free

_deallocate:        # Since the function is so simple,
                    # we do not need any of the fancy
                    # function stuff.

                    # Get the address of the memory to
                    # free (normally this is 8(%ebp),
                    # but since we did not push %ebp or
                    # move %esp to %ebp, we can just
                    # do 4(%esp).
    movl  ST_MEMORY_SEG(%esp), %eax


                            # Get the pointer to the
                            # real beginning of the
                            # memory.
    subl  $HEADER_SIZE, %eax

                            # Mark it as available.
    movl  $AVAILABLE, HDR_AVAIL_OFFSET(%eax)

    ret
    # ----- END OF FUNCTION: _deallocate ----- #
