    # Assemble with `as --32` and `ld -m elf_i386`.
    #
    # PURPOSE:
    #     Given a number, this program computes the
    #     factorial.  For example, the factorial of
    #     3 is 3 * 2 * 1, or 6.  The factorial of
    #     4 is 4 * 3 * 2 * 1, or 24, and so on.
    #
    # This program shows how to call a function
    # recursively. This program has no global data.
    #
    .section .data

    .section .text
        .globl _start
        .globl _factorial   # This is unneeded unless
                            # we want to share this
                            # function among other
                            # programs.
_start:
    pushl $4                # The factorial takes one
                            # argument - the number we
                            # want a factorial of.  So,
    call  _factorial        # it gets pushed. Run the
    addl  $4, %esp          # factorial function.
                            # Scrubs the parameter that
                            # was pushed on the stack.
    movl  %eax, %ebx        # Factorial returns the
                            # answer in %eax, but we
                            # want it in %ebx to send
                            # it as our exit status.
    movl  $1, %eax          # Call the kernel exit
                            # function.
    int   $0x80


    # This is the actual function definition.
    #
    .type  _factorial,  @function
_factorial:
    pushl %ebp              # Atandard function stuff -
                            # we have to restore %ebp
                            # to its prior state before
                            # returning, so we have to
                            # push it.
    movl  %esp, %ebp        # This is because we do not
                            # want to modify the stack
                            # pointer, so we use %ebp.

    movl  8(%ebp), %eax     # This moves the first
                            # argument to %eax 4(%ebp)
                            # holds the return address,
                            # and 8(%ebp) holds the
                            # first parameter.
    cmpl  $1, %eax          # If the number is 1, that
                            # is our base case, and we
                            # simply return (1 is
                            # already in %eax as the
                            # return value).
    je _end_factorial
    decl  %eax              # Otherwise, decrease the
                            # value.
    pushl %eax              # Push it for our call to
                            # factorial.
    call  _factorial        # Call factorial.
    movl  8(%ebp), %ebx     # %eax has the return
                            # value, so we reload our
                            # parameter into %ebx.
    imull %ebx, %eax        # Multiply that by the
                            # result of the last call
                            # to factorial (in %eax)
                            # the answer is stored in
                            # %eax, which is good since
                            # that is where return
                            # values go.
_end_factorial:
    movl  %ebp, %esp        # Standard function return
    popl  %ebp              # stuff - we have to
                            # restore %ebp and %esp to
    ret                     # where they were before
                            # the function started
                            # return from the function
                            # (this pops the return
                            # value, too).
