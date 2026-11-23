    # Assemble with `as --32`. Link with
    # `0AK-05-00-convert-to-upper.o` and the C
    # library (see `make.bash`).
    #
    # PURPOSE:
    #     Solution to Chapter 8, "Use the Concepts":
    #     `005-01-toupper` using the C library file
    #     functions (fopen, fread, fwrite, fclose)
    #     instead of system calls.
    #
    # USAGE:
    #     ./0AK-08-03-toupper-libc input.txt output.txt
    #
    # NOTES:
    #     The C library functions preserve %ebx,
    #     %esi, %edi and %ebp, so the FILE pointers
    #     are kept in %esi and %edi.
    #
    .section .data
        mode_read:
            .ascii "r\0"
        mode_write:
            .ascii "w\0"
        msg_error:
            .ascii "Error: can't open the files\n\0"

    .section .bss
        .equ   BUFFER_SIZE, 500
        .lcomm BUFFER_DATA, BUFFER_SIZE

    .section .text
        .globl _start
        .equ ST_ARGV_1, 8
        .equ ST_ARGV_2, 12

_start:
    movl  %esp, %ebp

    pushl $mode_read         # fopen(argv[1], "r")
    pushl ST_ARGV_1(%ebp)
    call  fopen
    addl  $8, %esp
    movl  %eax, %esi         # FILE * or NULL.

    pushl $mode_write        # fopen(argv[2], "w")
    pushl ST_ARGV_2(%ebp)
    call  fopen
    addl  $8, %esp
    movl  %eax, %edi

    cmpl  $0, %esi           # NULL means error.
    je    _error
    cmpl  $0, %edi
    je    _error

_read_loop:
    pushl %esi               # fread(buffer, 1,
    pushl $BUFFER_SIZE       #       size, in)
    pushl $1
    pushl $BUFFER_DATA
    call  fread
    addl  $16, %esp
    cmpl  $0, %eax           # 0 = end of file or
    je    _close_files       # error.
    movl  %eax, %ebx         # Bytes read.

    pushl $BUFFER_DATA
    pushl %ebx
    call  _convert_to_upper
    addl  $8, %esp

    pushl %edi               # fwrite(buffer, 1,
    pushl %ebx               #        count, out)
    pushl $1
    pushl $BUFFER_DATA
    call  fwrite
    addl  $16, %esp
    jmp   _read_loop

_close_files:
    pushl %edi
    call  fclose
    addl  $4, %esp
    pushl %esi
    call  fclose
    addl  $4, %esp
    pushl $0
    call  exit

_error:
    pushl $msg_error         # printf(msg_error)
    call  printf
    addl  $4, %esp
    pushl $1
    call  exit
