    # Assemble with `as --32` and `ld -m elf_i386`.
    #
    # PURPOSE:
    #     This program converts an input file to an
    #     output file with all letters converted to
    #     uppercase.
    #
    # PROCESSING:
    #     1) Open the input file.
    #     2) Open the output file.
    #     3) While we are not at the end of the input
    #        file.
    #        a) Read part of file into our memory
    #           buffer.
    #        b) Go through each byte of memory if the
    #           byte is a lower-case letter, convert it
    #           to uppercase.
    #        c) Write the memory buffer to output file.
    #
    .section .data
        # ----- CONSTANTS ----- #
        #
        # System call numbers.
        #
        .equ SYS_OPEN,   5
        .equ SYS_WRITE,  4
        .equ SYS_READ,   3
        .equ SYS_CLOSE,  6
        .equ SYS_EXIT,   1

        # Options for open:
        # Look at /usr/include/asm-generic/fcntl.h or
        # /usr/include/asm/fcntl.h for various values.
        # You can combine them by adding them or ORing
        # them). It is discussed at greater length in
        # "Counting Like a Computer".
        #
        .equ O_RDONLY,              0
        .equ O_CREAT_WRONLY_TRUNC,  03101

        # Standard file descriptors.
        #
        .equ STDIN,   0
        .equ STDOUT,  1
        .equ STDERR,  2

        # System call interrupt.
        #
        .equ LINUX_SYSCALL,     0x80
                            # This is the return value
                            # of read which means we
                            # have hit the end of the
                            # file.
        .equ END_OF_FILE,       0


        .equ NUMBER_ARGUMENTS,  2

    .section .bss
        # Buffer:
        #     This is where the data is loaded into
        #     from the data file and written from into
        #     the output file.  This should never
        #     exceed 16,000 for various reasons.
        #
        .equ   BUFFER_SIZE,     500
        .lcomm BUFFER_DATA,     BUFFER_SIZE

    .section .text
        .globl _start

        # ----- STACK POSITIONS ----- #
        #
        .equ ST_SIZE_RESERVE,   8
        .equ ST_FD_IN,         -4
        .equ ST_FD_OUT,        -8
        .equ ST_ARGC,           0  # Number of args
        .equ ST_ARGV_0,         4  # Name of program.
        .equ ST_ARGV_1,         8  # Input file name.
        .equ ST_ARGV_2,         12 # Output file name.

_start:
    # ----- INITIALIZE PROGRAM ----- #
    #
    movl  %esp, %ebp        # Save the stack pointer.
                            # Allocate space for our
                            # file descriptors on the
                            # stack.
    subl  $ST_SIZE_RESERVE, %esp

__open_files:

__open_fd_in:
    # ----- OPEN INPUT FILE ----- #
    #
    movl  $SYS_OPEN, %eax   # Open syscall.
    movl  ST_ARGV_1(%ebp), %ebx     # Input filename
                                    # into %ebx.
    movl  $O_RDONLY, %ecx   # Read-only flag.
    movl  $0666, %edx       # This does not matter for
                            # reading.
    int   $LINUX_SYSCALL    # Call Linux.

__store_fd_in:
    # ----- STORE INPUT FILE DESCRIPTION ----- #
    #
    movl  %eax, ST_FD_IN(%ebp)      # Save the given
                                    # file descriptor.

__open_fd_out:
    # ----- OPEN OUTPUT FILE ----- #
    #
    movl  $SYS_OPEN, %eax   # Open the file.
                            # Output filename into %ebx
    movl  ST_ARGV_2(%ebp), %ebx
                            # Flags for writing to the
                            # file.
    movl  $O_CREAT_WRONLY_TRUNC, %ecx
    movl  $0666, %edx       # Permission set for new
                            # file (if it is created).
    int   $LINUX_SYSCALL    # Call Linux.

__store_fd_out:
    # ----- STORE OUTPUT FILE DESCRIPTION ----- #
    #
                            # Store the file descriptor
                            # here.
    movl  %eax, ST_FD_OUT(%ebp)

    # ----- BEGIN MAIN LOOP ----- #
    #
_read_loop_begin:
    # ----- READ IN A BLOCK FROM THE INPUT FILE ----- #
    #
    movl  $SYS_READ, %eax
                            # Get the input file
                            # descriptor.
    movl  ST_FD_IN(%ebp), %ebx
                            # The location to read into
    movl  $BUFFER_DATA, %ecx
                            # The size of the buffer.
    movl  $BUFFER_SIZE, %edx
    int   $LINUX_SYSCALL    # Size of buffer read is
                            # returned in %eax.

    # ----- EXIT IF WE HAVE REACHED THE END ----- #
    #
                            # Check for end of file
                            # marker.
    cmpl  $END_OF_FILE, %eax
    jle   _lower_case       # If found or on error, go
                            # to the end.

__continue_read_loop:
    # ----- CONVERT THE BLOCK TO UPPER CASE ----- #
    #
    pushl $BUFFER_DATA      # Location of buffer.
    pushl %eax              # Size of the buffer.
    call  _convert_to_upper
    popl  %eax              # Get the size back.
    addl  $4, %esp          # Restore %esp.

    # --- WRITE THE BLOCK OUT TO THE OUTPUT FILE --- #
    #
    movl  %eax, %edx        # Size of the buffer.
    movl  $SYS_WRITE, %eax
                            # File to use.
    movl  ST_FD_OUT(%ebp), %ebx
                            # Location of the buffer.
    movl  $BUFFER_DATA, %ecx
    int   $LINUX_SYSCALL

    # ----- CONTINUE THE LOOP ----- #
    #
    jmp   _read_loop_begin

_lower_case:
    # ----- CLOSE THE FILES ----- #
    # NOTE:
    #     We do not need to do error checking on
    #     these, because error conditions do not
    #     signify anything special here.
    #
    movl  $SYS_CLOSE, %eax
    movl  ST_FD_OUT(%ebp), %ebx
    int   $LINUX_SYSCALL

    movl  $SYS_CLOSE, %eax
    movl  ST_FD_IN(%ebp), %ebx
    int   $LINUX_SYSCALL

    # ----- EXIT ----- #
    #
    movl  $SYS_EXIT, %eax
    movl  $0, %ebx
    int   $LINUX_SYSCALL


    # PURPOSE:
    #     This function actually does the
    #     conversion to upper case for a block.
    #
    # INPUT:
    #     The first parameter is the length of
    #     the block of memory to convert.
    #
    #     The second parameter is the starting
    #     address of that block of memory.
    #
    # OUTPUT:
    #     This function overwrites the current
    #     buffer with the upper-casified version.
    #
    # VARIABLES:
    #     %eax - beginning of buffer.
    #     %ebx - length of buffer.
    #     %edi - current buffer offset.
    #     %cl -  current byte being examined (first
    #            part of %ecx).
    #
    # ----- CONSTANTS ----- #
    #
                            # The lower boundary of our
                            # search.
        .equ  LOWERCASE_A,       'a'
                            # The upper boundary of our
                            # search.
        .equ  LOWERCASE_Z,       'z'
                            # Conversion between upper
                            # lower case.
        .equ  UPPER_CONVERSION,  'A' - 'a'

    # ----- STACK STUFF ----- #
    #
        .equ  ST_BUFFER,      12    # Actual buffer.
        .equ  ST_BUFFER_LEN,  8     # Length of buffer.

_convert_to_upper:
    pushl %ebp
    movl  %esp, %ebp

    # ----- SET UP VARIABLES ----- #
    #
    movl  ST_BUFFER(%ebp), %eax
    movl  ST_BUFFER_LEN(%ebp), %ebx
    movl  $0, %edi

    cmpl  $0, %ebx          # If a buffer with zero
                            # length was given to us,
                            # just leave.
    je    _end_convert_loop

_convert_loop:
                            # Get the current byte.
    movb  (%eax,%edi,1), %cl

                            # Go to the next byte
                            # unless it is between 'a'
                            # and 'z'.
    cmpb  $LOWERCASE_A, %cl

    jl    _next_byte
    cmpb  $LOWERCASE_Z, %cl
    jg    _next_byte

                            # Otherwise convert the
                            # byte to uppercase and
                            # store it back.
    addb  $UPPER_CONVERSION, %cl

    movb  %cl, (%eax,%edi,1)

_next_byte:
    incl  %edi              # Next byte.
    cmpl  %edi, %ebx        # Continue unless we have
                            # reached the end.
    jne   _convert_loop

_end_convert_loop:
    movl  %ebp, %esp        # No return value, just
    popl  %ebp              # leave.
    ret
