    # Assemble with `as --32` and `ld -m elf_i386`.
    # Link with `006-01-read-record.o`,
    # `006-01-write-record.o`, `007-01-error-exit.o`,
    # `006-01-count-chars.o` and
    # `006-01-write-newline.o`.
    #
    # PURPOSE:
    #     Solution to Chapter 7, "Use the Concepts":
    #     `007-01-add-year` with error checking after
    #     every system call, and a recovery point: if
    #     `test.dat` can't be opened, the records are
    #     read from STDIN instead.
    #
    # USAGE:
    #     ./0AK-07-01-add-year-robust
    #     ./0AK-07-01-add-year-robust < other.dat
    #
    # NOTES:
    #     System calls return a negative number
    #     (-errno) on failure. A read that returns
    #     more than 0 but less than a whole record
    #     means the file is damaged.
    #
    .include "006-01-linux.s"
    .include "006-01-record-def.s"
        .equ O_CREAT_WRONLY_TRUNC, 03101

    .section .data
        input_file_name:
            .ascii "test.dat\0"
        output_file_name:
            .ascii "testout.dat\0"
        msg_recover:
            .ascii "Warning: can't open test.dat, "
            .ascii "reading STDIN\n"
        msg_recover_end:
        .equ RECOVER_LEN, msg_recover_end - msg_recover
        code_output:
            .ascii "0002: \0"
        msg_output:
            .ascii "Can't Open Output File.\0"
        code_read:
            .ascii "0003: \0"
        msg_read:
            .ascii "Can't Read Input File.\0"
        code_partial:
            .ascii "0004: \0"
        msg_partial:
            .ascii "Incomplete Record.\0"
        code_write:
            .ascii "0005: \0"
        msg_write:
            .ascii "Can't Write Output File.\0"
        code_close:
            .ascii "0006: \0"
        msg_close:
            .ascii "Can't Close Output File.\0"

    .section .bss
        .lcomm record_buffer, RECORD_SIZE

    .section .text
        .globl _start
        # %esi - Input file descriptor.
        # %edi - Output file descriptor.

_start:
    movl  $SYS_OPEN, %eax
    movl  $input_file_name, %ebx
    movl  $0, %ecx           # Read only.
    movl  $0666, %edx
    int   $LINUX_SYSCALL
    movl  %eax, %esi
    cmpl  $0, %eax
    jge   _open_output

    # Recovery point: use STDIN instead.
    movl  $STDIN, %esi
    movl  $SYS_WRITE, %eax
    movl  $STDERR, %ebx
    movl  $msg_recover, %ecx
    movl  $RECOVER_LEN, %edx
    int   $LINUX_SYSCALL     # Nothing useful to do
                             # if this one fails.
_open_output:
    movl  $SYS_OPEN, %eax
    movl  $output_file_name, %ebx
    movl  $O_CREAT_WRONLY_TRUNC, %ecx
    movl  $0666, %edx
    int   $LINUX_SYSCALL
    movl  %eax, %edi
    cmpl  $0, %eax
    jl    _error_output

_loop_begin:
    pushl %esi
    pushl $record_buffer
    call  _read_record
    addl  $8, %esp
    cmpl  $0, %eax
    jl    _error_read        # Read failed.
    je    _loop_end          # End of file.
    cmpl  $RECORD_SIZE, %eax
    jne   _error_partial     # Damaged file.

    incl  record_buffer + RECORD_AGE

    pushl %edi
    pushl $record_buffer
    call  _write_record
    addl  $8, %esp
    cmpl  $RECORD_SIZE, %eax # Everything written?
    jne   _error_write
    jmp   _loop_begin

_loop_end:
    movl  $SYS_CLOSE, %eax   # Closing the output
    movl  %edi, %ebx         # can report a delayed
    int   $LINUX_SYSCALL     # write error.
    cmpl  $0, %eax
    jl    _error_close

    movl  $SYS_EXIT, %eax
    movl  $0, %ebx
    int   $LINUX_SYSCALL

_error_output:
    pushl $msg_output
    pushl $code_output
    call  _error_exit
_error_read:
    pushl $msg_read
    pushl $code_read
    call  _error_exit
_error_partial:
    pushl $msg_partial
    pushl $code_partial
    call  _error_exit
_error_write:
    pushl $msg_write
    pushl $code_write
    call  _error_exit
_error_close:
    pushl $msg_close
    pushl $code_close
    call  _error_exit
