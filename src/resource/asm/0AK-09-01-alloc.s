    # Assemble with `as --32` and `ld -m elf_i386`.
    #
    # PURPOSE:
    #     Solution to Chapter 9, "Use the Concepts":
    #     the memory manager of `009-02-alloc.s` with
    #     two improvements:
    #     1. `_allocate` calls `_allocate_init` by
    #        itself the first time.
    #     2. When the chosen free region is bigger
    #        than needed, it is split in two: the part
    #        that is used and a new free region with
    #        its own header.
    #     It also checks the result of `brk` the
    #     right way: on failure, `brk` returns the
    #     old break, not 0.
    #
    # MEMORY LAYOUT OF A REGION:
    #     | available | size | size bytes of memory |
    #       4 bytes    4 bytes  ^-- returned pointer
    #
    .section .data
        heap_begin:
            .long 0
        current_break:
            .long 0

        .equ HEADER_SIZE,      8
        .equ HDR_AVAIL_OFFSET, 0
        .equ HDR_SIZE_OFFSET,  4
        .equ UNAVAILABLE,      0
        .equ AVAILABLE,        1
        # Split only if the free part can hold a
        # header and at least this many bytes.
        .equ MIN_SPLIT,        8
        .equ SYS_BRK,          45
        .equ LINUX_SYSCALL,    0x80

    .section .text

    # PURPOSE:
    #     Set heap_begin and current_break to the
    #     current end of the program's memory.
    #
        .globl _allocate_init
        .type  _allocate_init, @function
_allocate_init:
    pushl %ebp
    movl  %esp, %ebp
    pushl %ebx
    movl  $SYS_BRK, %eax     # brk(0) returns the
    movl  $0, %ebx           # current break.
    int   $LINUX_SYSCALL
    movl  %eax, current_break
    movl  %eax, heap_begin
    popl  %ebx
    movl  %ebp, %esp
    popl  %ebp
    ret

    # PURPOSE:
    #     Reserve memory.
    #
    # INPUT:
    #     First argument - Number of bytes wanted.
    #
    # OUTPUT:
    #     %eax - Address of the memory, or 0 if
    #     there is no memory available.
    #
    # VARIABLES:
    #     %ecx - Size requested.
    #     %eax - Region being examined.
    #     %ebx - Current break.
    #     %edx - Size of the region being examined.
    #
        .globl _allocate
        .type  _allocate, @function
        .equ ST_MEM_SIZE, 8
_allocate:
    pushl %ebp
    movl  %esp, %ebp
    pushl %ebx
    pushl %esi

    cmpl  $0, heap_begin     # Improvement 1:
    jne   _initialized       # initialize on the
    call  _allocate_init     # first call.
_initialized:
    movl  ST_MEM_SIZE(%ebp), %ecx
    movl  heap_begin, %eax
    movl  current_break, %ebx

_alloc_loop_begin:
    cmpl  %ebx, %eax         # End of the heap?
    je    _move_break
    movl  HDR_SIZE_OFFSET(%eax), %edx
    cmpl  $UNAVAILABLE, HDR_AVAIL_OFFSET(%eax)
    je    _next_location     # Region in use.
    cmpl  %edx, %ecx         # Big enough?
    jle   _allocate_here
_next_location:
    addl  $HEADER_SIZE, %eax
    addl  %edx, %eax
    jmp   _alloc_loop_begin

_allocate_here:
    # Improvement 2: split the region if the rest
    # (size - requested - header) is big enough.
    movl  %edx, %esi
    subl  %ecx, %esi
    subl  $HEADER_SIZE, %esi # %esi = size of the
    cmpl  $MIN_SPLIT, %esi   # new free region.
    jl    _mark_used
    movl  %ecx, HDR_SIZE_OFFSET(%eax)
    leal  HEADER_SIZE(%eax,%ecx,1), %edx
    movl  $AVAILABLE, HDR_AVAIL_OFFSET(%edx)
    movl  %esi, HDR_SIZE_OFFSET(%edx)
_mark_used:
    movl  $UNAVAILABLE, HDR_AVAIL_OFFSET(%eax)
    addl  $HEADER_SIZE, %eax
    jmp   _allocate_return

_move_break:
    # Grow the heap by header + requested size.
    movl  %eax, %esi         # New region.
    addl  $HEADER_SIZE, %ebx
    addl  %ecx, %ebx         # %ebx = new break.
    movl  $SYS_BRK, %eax
    int   $LINUX_SYSCALL
    cmpl  %ebx, %eax         # brk returns the old
    jl    _error             # break on failure.

    movl  %esi, %eax
    movl  $UNAVAILABLE, HDR_AVAIL_OFFSET(%eax)
    movl  %ecx, HDR_SIZE_OFFSET(%eax)
    addl  $HEADER_SIZE, %eax
    movl  %ebx, current_break
    jmp   _allocate_return

_error:
    movl  $0, %eax

_allocate_return:
    popl  %esi
    popl  %ebx
    movl  %ebp, %esp
    popl  %ebp
    ret

    # PURPOSE:
    #     Give back memory reserved by _allocate.
    #
    # INPUT:
    #     First argument - Address returned by
    #     _allocate.
    #
        .globl _deallocate
        .type  _deallocate, @function
        .equ ST_MEMORY_SEG, 4
_deallocate:
    movl  ST_MEMORY_SEG(%esp), %eax
    subl  $HEADER_SIZE, %eax
    movl  $AVAILABLE, HDR_AVAIL_OFFSET(%eax)
    ret
