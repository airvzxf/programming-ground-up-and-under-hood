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
        first_string:
            .ascii "Hi! %s is the %s number #%d.\n\0"

        name_string:
            .ascii "Jonathan\0"

        person_string:
            .ascii "person\0"

        # This could also have been an .equ, but we
        # decided to give it a real memory location
        # just for kicks.
        #
        number_loved:
            .long 3

    .section .text
        .globl _start

_start:
    # Note that the parameters are passed in the
    # reverse order that they are listed in the
    # function prototype.
    #
    pushl number_loved      # This is the %d.
    pushl $person_string    # This is the second %s.
    pushl $name_string      # This is the first %s.
    pushl $first_string     # This is the format string
                            # in the prototype.
    call  printf

    pushl $0
    call  exit
