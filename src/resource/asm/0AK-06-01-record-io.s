    # Assemble with `as --32` and `ld -m elf_i386`.
    #
    # PURPOSE:
    #     `_read_record` and `_write_record` for the
    #     record with a phone number. The code is the
    #     same as in `006-01-read-record.s` and
    #     `006-01-write-record.s`; only RECORD_SIZE
    #     changes, so they must be reassembled.
    #
    # INPUT (both functions):
    #     First argument  - Address of the buffer.
    #     Second argument - File descriptor.
    #
    # OUTPUT:
    #     %eax - Result of the read/write call.
    #
    .include "006-01-linux.s"
    .include "0AK-06-01-record-def.s"
        .equ ST_BUFFER,   8
        .equ ST_FILEDES,  12

    .section .text
        .globl _read_record
        .type  _read_record, @function
_read_record:
    pushl %ebp
    movl  %esp, %ebp
    pushl %ebx
    movl  ST_FILEDES(%ebp), %ebx
    movl  ST_BUFFER(%ebp), %ecx
    movl  $RECORD_SIZE, %edx
    movl  $SYS_READ, %eax
    int   $LINUX_SYSCALL
    popl  %ebx
    movl  %ebp, %esp
    popl  %ebp
    ret

        .globl _write_record
        .type  _write_record, @function
_write_record:
    pushl %ebp
    movl  %esp, %ebp
    pushl %ebx
    movl  ST_FILEDES(%ebp), %ebx
    movl  ST_BUFFER(%ebp), %ecx
    movl  $RECORD_SIZE, %edx
    movl  $SYS_WRITE, %eax
    int   $LINUX_SYSCALL
    popl  %ebx
    movl  %ebp, %esp
    popl  %ebp
    ret
