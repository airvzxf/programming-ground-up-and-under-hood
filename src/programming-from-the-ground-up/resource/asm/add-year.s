    .code32                             # Generate 32-bit code.
    .include "linux.s"                  # Common Linux Definitions.
    .include "record-def.s"             # Record definitions.

    .section .data
        input_file_name:
            .ascii "test.dat\0"

        output_file_name:
            .ascii "testout.dat\0"

    .section .bss
        .lcomm record_buffer,  RECORD_SIZE

    # ----- Stack offsets of local variables ----- #
    #
    .equ ST_INPUT_DESCRIPTOR,  -4
    .equ ST_OUTPUT_DESCRIPTOR, -8

    .section .text
    .globl _start
_start:
    movl  %esp, %ebp                    # Copy stack pointer and make room
    subl  $8, %esp                      # for local variables.

    movl  $SYS_OPEN, %eax               # Open file for reading.
    movl  $input_file_name, %ebx
    movl  $0, %ecx
    movl  $0666, %edx
    int   $LINUX_SYSCALL

    movl  %eax, ST_INPUT_DESCRIPTOR(%ebp)

    movl  $SYS_OPEN, %eax               # Open file for writing.
    movl  $output_file_name, %ebx
    movl  $0101, %ecx
    movl  $0666, %edx
    int   $LINUX_SYSCALL

    movl  %eax, ST_OUTPUT_DESCRIPTOR(%ebp)

loop_begin:
    pushl ST_INPUT_DESCRIPTOR(%ebp)
    pushl $record_buffer
    call  read_record
    addl  $8, %esp

    # Returns the number of bytes read. If it isn't the same number we
    # requested, then it's either an end-of-file, or an error, so we're
    # quitting.
    #
    cmpl  $RECORD_SIZE, %eax
    jne   loop_end

    incl  record_buffer + RECORD_AGE    # Increment the age.

    pushl ST_OUTPUT_DESCRIPTOR(%ebp)    # Write the record out.
    pushl $record_buffer
    call  write_record
    addl  $8, %esp

    jmp   loop_begin

loop_end:
    movl  $SYS_EXIT, %eax
    movl  $0, %ebx
    int   $LINUX_SYSCALL
