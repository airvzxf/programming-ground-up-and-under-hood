    # Assemble with `as --32` and `ld -m elf_i386`.
    #
    .include "linux.s"      # Common Linux Definitions.
    .include "record-def.s" # Record definitions.

    .section .data
        file_name:
            .ascii "test.dat\0"

    .section .bss
        .lcomm record_buffer,  RECORD_SIZE

    .section .text
        .globl _start

_start:
    # ----- Main Program ----- #
    #
    # These are the locations on the stack where we
    # will store the input and output descriptors
    # (FYI - we could have used memory addresses in a
    # .data section instead).
    #
    .equ ST_INPUT_DESCRIPTOR,   -4
    .equ ST_OUTPUT_DESCRIPTOR,  -8

    movl  %esp, %ebp        # Copy the stack pointer to
                            # %ebp.
    subl  $8, %esp          # Allocate space to hold
                            # the file descriptors.

    movl  $SYS_OPEN, %eax   # Open the file.
    movl  $file_name, %ebx
    movl  $0, %ecx          # This says to open
                            # read-only.
    movl  $0666, %edx
    int   $LINUX_SYSCALL

    # ----- Save file descriptor ----- #
    #
    movl  %eax, ST_INPUT_DESCRIPTOR(%ebp)

    # Even though it is a constant, we are saving the
    # output file descriptor in a local variable so
    # that if we later decide that it is not always
    # going to be STDOUT, we can change it easily.
    #
    movl  $STDOUT, ST_OUTPUT_DESCRIPTOR(%ebp)

_record_read_loop:
    pushl ST_INPUT_DESCRIPTOR(%ebp)
    pushl $record_buffer
    call  read_record
    addl  $8, %esp

    # Returns the number of bytes read. If it is not
    # the same number we requested, then it is either
    # an end-of-file, or an error, so we are quitting.
    #
    cmpl  $RECORD_SIZE, %eax
    jne   _finished_reading

    # Otherwise, print out the first name but we must
    # know the size.
    #
    pushl  $RECORD_FIRSTNAME + record_buffer
    call   count_chars
    addl   $4, %esp

    movl   %eax, %edx
    movl   ST_OUTPUT_DESCRIPTOR(%ebp), %ebx
    movl   $SYS_WRITE, %eax
    movl   $RECORD_FIRSTNAME + record_buffer, %ecx
    int    $LINUX_SYSCALL

    pushl  ST_OUTPUT_DESCRIPTOR(%ebp)
    call   write_newline
    addl   $4, %esp

    jmp    _record_read_loop

_finished_reading:
    movl   $SYS_EXIT, %eax
    movl   $0, %ebx
    int    $LINUX_SYSCALL
