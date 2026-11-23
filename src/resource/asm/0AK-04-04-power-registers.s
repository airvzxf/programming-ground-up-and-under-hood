    # Assemble with `as --32` and `ld -m elf_i386`.
    #
    # PURPOSE:
    #     Solution to Chapter 4, "Going Further":
    #     the power program (2^3 + 5^2) with a custom
    #     calling convention that uses registers
    #     instead of the stack.
    #
    # CALLING CONVENTION:
    #     %ebx - Base (first parameter).
    #     %ecx - Power (second parameter).
    #     %eax - Return value.
    #     The function may change %ecx and %edx; it
    #     preserves %ebx and every other register.
    #
    # OUTPUT:
    #     Exit status code 33.
    #
    .section .data

    .section .text
        .globl _start

_start:
    movl  $2, %ebx           # 2^3
    movl  $3, %ecx
    call  _power
    movl  %eax, %edi         # Save the result.

    movl  $5, %ebx           # 5^2
    movl  $2, %ecx
    call  _power

    addl  %edi, %eax         # 8 + 25
    movl  %eax, %ebx
    movl  $1, %eax
    int   $0x80

        .type _power, @function
_power:
    movl  $1, %eax           # Result.
_power_loop:
    cmpl  $0, %ecx           # Done when power = 0.
    je    _power_end
    imull %ebx, %eax
    decl  %ecx
    jmp   _power_loop
_power_end:
    ret                      # No stack frame needed.
