    # Assemble with `as --32` and `ld -m elf_i386`.
    #
    # PURPOSE:
    #    This program is to demonstrate how to call
    #    printf.
    #
    .section .data
        # This string is called the format string.  It
        # is the first parameter, and printf uses it to
        # find out how many parameters it was given,
        # and what kind they are.
        #
        firststring:
            .ascii
       "Hello! %s is a %s who loves the number %d.\n\0"

        namestring:
            .ascii "Jonathan\0"

        personstring:
            .ascii "person\0"

        # This could also have been an .equ, but we
        # decided to give it a real memory location
        # just for kicks.
        #
        numberloved:
            .long 3

    .section .text
        .globl _start

_start:
    # Note that the parameters are passed in the
    # reverse order that they are listed in the
    # function prototype.
    #
    pushl numberloved       # This is the %d.
    pushl $personstring     # This is the second %s.
    pushl $namestring       # This is the first %s.
    pushl $firststring      # This is the format string
                            # in the prototype.
    call  printf

    pushl $0
    call  exit
