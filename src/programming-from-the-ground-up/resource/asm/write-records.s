    .code32                             # Generate 32-bit code.
    .include "linux.s"                  # Common Linux Definitions.
    .include "record-def.s"             # Record definitions.

    .section .data
        # ----- CONSTANTS ----- #
        #
        # Constant data of the records we want to write. Each text data
        # item is padded to the proper length with null (i.e. 0) bytes.
        #
        # `.rept` is used to pad each item.  It tells the assembler to
        # repeat the section between `.rept` and `.endr` the number of
        # times specified. This is used in this program to add extra null
        # characters at the end of each field to fill it up.
        #
        record1:
            .ascii "Fredrick\0"
            .rept 31                    # Padding to 40 bytes.
            .byte 0
            .endr

            .ascii "Bartlett\0"
            .rept 31                    # Padding to 40 bytes.
            .byte 0
            .endr

            .ascii "4242 S Prairie\nTulsa, OK 55555\0"
            .rept 209                   # Padding to 240 bytes.
            .byte 0
            .endr

            .long 45

        record2:
            .ascii "Marilyn\0"
            .rept 32                    # Padding to 40 bytes.
            .byte 0
            .endr

            .ascii "Taylor\0"
            .rept 33                    # Padding to 40 bytes.
            .byte 0
            .endr

            .ascii "2224 S Johannan St\nChicago, IL 12345\0"
            .rept 203                   # Padding to 240 bytes.
            .byte 0
            .endr

            .long 29

        record3:
            .ascii "Derrick\0"
            .rept 32                    # Padding to 40 bytes.
            .byte 0
            .endr

            .ascii "McIntire\0"
            .rept 31                    # Padding to 40 bytes.
            .byte 0
            .endr

            .ascii "500 W Oakland\nSan Diego, CA 54321\0"
            .rept 206                   # Padding to 240 bytes.
            .byte 0
            .endr

            .long 36

        file_name:
            .ascii "test.dat\0"         # This is the name of the file we
                                        # will write to.

        .equ ST_FILE_DESCRIPTOR,  -4

    .globl _start
_start:
    movl  %esp, %ebp                    # Copy the stack pointer to %ebp.
    subl  $4, %esp                      # Allocate space to hold the file
                                        # descriptor.

    movl  $SYS_OPEN, %eax               # Open the file.
    movl  $file_name, %ebx
    movl  $0101, %ecx                   # This says to create if it doesn't
                                        # exist, and open for writing.
    movl  $0666, %edx
    int   $LINUX_SYSCALL

    movl  %eax, ST_FILE_DESCRIPTOR(%ebp)  # Store the file descriptor away.

    pushl ST_FILE_DESCRIPTOR(%ebp)      # Write the first record.
    pushl $record1
    call  write_record
    addl  $8, %esp

    pushl ST_FILE_DESCRIPTOR(%ebp)      # Write the second record.
    pushl $record2
    call  write_record
    addl  $8, %esp

    pushl ST_FILE_DESCRIPTOR(%ebp)      # Write the third record.
    pushl $record3
    call  write_record
    addl  $8, %esp

    movl  $SYS_CLOSE, %eax              # Close the file descriptor.
    movl  ST_FILE_DESCRIPTOR(%ebp), %ebx
    int   $LINUX_SYSCALL

    movl  $SYS_EXIT, %eax               # Exit the program.
    movl  $0, %ebx
    int   $LINUX_SYSCALL