    # Assemble with `as --32` and `ld -m elf_i386`.
    #
    # PURPOSE:
    #     Solution to Chapter 10, "Going Further":
    #     store likes and dislikes in a single word
    #     and compare two people.
    #
    # LAYOUT OF THE WORD:
    #     Bits 0 to 15  - Likes.
    #     Bits 16 to 31 - Dislikes, same order.
    #
    # OUTPUT:
    #     Exit status code: shared likes * 10 +
    #     shared dislikes. For the people below:
    #     books and games (2), sports (1) -> 21.
    #
        .equ MUSIC,   1 << 0
        .equ BOOKS,   1 << 1
        .equ MOVIES,  1 << 2
        .equ SPORTS,  1 << 3
        .equ COOKING, 1 << 4
        .equ GAMES,   1 << 5
        .equ ART,     1 << 6
        .equ DISLIKE, 16     # Shift for dislikes.

    .section .data
        .equ A_LIKES,    MUSIC | BOOKS | GAMES
        .equ A_DISLIKES, SPORTS | COOKING
        .equ B_LIKES,    BOOKS | GAMES | ART
        .equ B_DISLIKES, SPORTS | MOVIES
        person_a:
            .long A_LIKES | (A_DISLIKES << DISLIKE)
        person_b:
            .long B_LIKES | (B_DISLIKES << DISLIKE)

    .section .text
        .globl _start

_start:
    movl  person_a, %eax
    andl  person_b, %eax     # Bits set in both.
    movl  %eax, %esi

    andl  $0xffff, %eax      # Shared likes only.
    pushl %eax
    call  _count_bits
    addl  $4, %esp
    imull $10, %eax, %edi

    movl  %esi, %eax
    shrl  $DISLIKE, %eax     # Shared dislikes.
    pushl %eax
    call  _count_bits
    addl  $4, %esp
    addl  %eax, %edi

    movl  %edi, %ebx
    movl  $1, %eax
    int   $0x80

    # PURPOSE:
    #     Count the bits set to 1 in a word.
    #
    # INPUT:
    #     First argument - The word.
    #
    # OUTPUT:
    #     %eax - Number of bits set.
    #
        .type _count_bits, @function
_count_bits:
    movl  4(%esp), %edx
    movl  $0, %eax
_count_loop:
    cmpl  $0, %edx
    je    _count_end
    testl $1, %edx           # Lowest bit set?
    jz    _count_next
    incl  %eax
_count_next:
    shrl  $1, %edx           # Next bit.
    jmp   _count_loop
_count_end:
    ret
