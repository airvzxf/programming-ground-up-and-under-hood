    # Assemble with `as --32` and `ld -m elf_i386`.
    #
    # PURPOSE:
    #     Solution to Chapter 4, "Use the Concepts":
    #     the maximum program as a function that
    #     receives a pointer to a list of numbers
    #     ended by 0, called with 3 different lists.
    #
    # OUTPUT:
    #     The maximum of the last list (99) as the
    #     exit status code.
    #
    .section .data
        list_1:
            .long 3, 67, 34, 222, 45, 0
        list_2:
            .long 5, 4, 3, 2, 1, 0
        list_3:
            .long 10, 99, 18, 50, 0

    .section .text
        .globl _start

_start:
    pushl $list_1
    call  _maximum           # %eax = 222
    addl  $4, %esp

    pushl $list_2
    call  _maximum           # %eax = 5
    addl  $4, %esp

    pushl $list_3
    call  _maximum           # %eax = 99
    addl  $4, %esp

    movl  %eax, %ebx         # Last result as the
    movl  $1, %eax           # status code.
    int   $0x80

    # PURPOSE:
    #     Find the largest number of a list.
    #
    # INPUT:
    #     First argument - Address of the list. The
    #     list ends with a 0.
    #
    # OUTPUT:
    #     %eax - The largest number (0 if the list
    #     is empty).
    #
    # VARIABLES:
    #     %edx - Address of the current item.
    #     %ecx - Current item.
    #
        .type _maximum, @function
_maximum:
    pushl %ebp
    movl  %esp, %ebp

    movl  8(%ebp), %edx      # Address of item 0.
    movl  (%edx), %eax       # Largest so far.

_maximum_loop:
    movl  (%edx), %ecx       # Current item.
    cmpl  $0, %ecx           # End of the list?
    je    _maximum_end
    cmpl  %eax, %ecx
    jle   _maximum_next
    movl  %ecx, %eax         # New largest value.
_maximum_next:
    addl  $4, %edx           # Next item.
    jmp   _maximum_loop

_maximum_end:
    movl  %ebp, %esp
    popl  %ebp
    ret
