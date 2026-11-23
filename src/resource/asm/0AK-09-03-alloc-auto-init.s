    # Assemble with `as --32` and `ld -m elf_i386`.
    # Link with `0AK-09-01-alloc.o`.
    #
    # PURPOSE:
    #     Allocate memory WITHOUT calling
    #     `_allocate_init`, write to it and read it
    #     back. With the book's manager this crashes,
    #     because the heap was never initialized.
    #
    # OUTPUT:
    #     Exit status code 42.
    #
    .section .text
        .globl _start

_start:
    pushl $16
    call  _allocate          # No _allocate_init.
    addl  $4, %esp
    cmpl  $0, %eax
    je    _failed

    movl  $42, (%eax)        # Use the memory.
    movl  (%eax), %ebx
    movl  $1, %eax
    int   $0x80

_failed:
    movl  $1, %eax
    movl  $255, %ebx
    int   $0x80
