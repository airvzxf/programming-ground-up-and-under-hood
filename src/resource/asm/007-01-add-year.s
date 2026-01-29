    # Assemble with `as --32` and `ld -m elf_i386`.
    #
    .include "006-01-linux.s"      # Linux Definitions.
    .include "006-01-record-def.s" # Record definitions

    .section .data
        input_file_name:
            .ascii "test.dat\0"

        output_file_name:
            .ascii "testout.dat\0"

    .section .bss
        .lcomm record_buffer,  RECORD_SIZE

        # --- Stack offsets of local variables --- #
        #
        .equ ST_INPUT_DESCRIPTOR,  -4
        .equ ST_OUTPUT_DESCRIPTOR, -8

    .section .text
        .globl _start

_start:
    movl  %esp, %ebp        # Copy stack pointer and
    subl  $8, %esp          # make room for local
                            # variables.

    movl  $SYS_OPEN, %eax   # Open file for reading.
    movl  $input_file_name, %ebx
    movl  $0, %ecx
    movl  $0666, %edx
    int   $LINUX_SYSCALL

    movl  %eax, ST_INPUT_DESCRIPTOR(%ebp)

                    # This will test and see if %eax is
                    # negative.  If it is not negative,
                    # it will jump to
                    # _continue_processing. Otherwise
                    # it will handle the error
                    # condition that the negative
                    # number represents.
                    #
    cmpl  $0, %eax
    jge   _continue_processing

    # ----- SEND THE ERROR ----- #
    #
    .section .data
        no_open_file_code:
            .ascii "0001: \0"
        no_open_file_msg:
            .ascii "Can't Open Input File.\0"

    .section .text
    pushl $no_open_file_msg
    pushl $no_open_file_code
    call  _error_exit

_continue_processing:

    movl  $SYS_OPEN, %eax   # Open file for writing.
    movl  $output_file_name, %ebx
    movl  $0101, %ecx
    movl  $0666, %edx
    int   $LINUX_SYSCALL

    movl  %eax, ST_OUTPUT_DESCRIPTOR(%ebp)

_loop_begin:
    pushl ST_INPUT_DESCRIPTOR(%ebp)
    pushl $record_buffer
    call  _read_record
    addl  $8, %esp

    # Returns the number of bytes read. If it is not
    # the same number we requested, then it is either
    # an end-of-file, or an error, so we are quitting.
    #
    cmpl  $RECORD_SIZE, %eax
    jne   _loop_end

                            # Increment the age.
    incl  record_buffer + RECORD_AGE

                            # Write the record out.
    pushl ST_OUTPUT_DESCRIPTOR(%ebp)
    pushl $record_buffer
    call  _write_record
    addl  $8, %esp

    jmp   _loop_begin

_loop_end:
    movl  $SYS_EXIT, %eax
    movl  $0, %ebx
    int   $LINUX_SYSCALL
