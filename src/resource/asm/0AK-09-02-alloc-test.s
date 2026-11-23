    # Assemble with `as --32` and `ld -m elf_i386`.
    # Link with `0AK-09-01-alloc.o` (or with
    # `009-02-alloc.o` to compare).
    #
    # PURPOSE:
    #     Test a memory manager. The exit status is
    #     the sum of the checks that failed:
    #       1 - Two allocations overlap.
    #       2 - Freed memory is not reused.
    #       4 - The free region was not split, so a
    #           second small request grew the heap.
    #     `0AK-09-01-alloc` returns 0; the book's
    #     manager returns 4, because it doesn't split.
    #
    .section .data
        failures:
            .long 0

    .section .text
        .globl _start
        # %esi = a, %edi = b, %ebx = c

_start:
    call  _allocate_init

    pushl $100               # a = allocate(100)
    call  _allocate
    addl  $4, %esp
    movl  %eax, %esi

    pushl $100               # b = allocate(100)
    call  _allocate
    addl  $4, %esp
    movl  %eax, %edi

    leal  100(%esi), %eax    # Check 1: b must not
    cmpl  %eax, %edi         # start before the end
    jae   _check_reuse       # of a.
    addl  $1, failures

_check_reuse:
    pushl %esi               # deallocate(a)
    call  _deallocate
    addl  $4, %esp

    pushl $40                # c = allocate(40)
    call  _allocate
    addl  $4, %esp
    movl  %eax, %ebx
    cmpl  %esi, %ebx         # Check 2: c == a.
    je    _check_split
    addl  $2, failures

_check_split:
    pushl $40                # d = allocate(40)
    call  _allocate
    addl  $4, %esp
    cmpl  %edi, %eax         # Check 3: d must be
    jb    _done              # in a's old region,
    addl  $4, failures       # below b.

_done:
    movl  $1, %eax
    movl  failures, %ebx
    int   $0x80
