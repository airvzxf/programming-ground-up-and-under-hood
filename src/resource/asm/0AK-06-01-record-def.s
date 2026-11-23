    # Assemble with `as --32` and `ld -m elf_i386`.
    #
    # PURPOSE:
    #     Solution to Chapter 6, "Use the Concepts":
    #     the person record with a new data member,
    #     a phone number (20 bytes) after the age.
    #
        .equ RECORD_FIRSTNAME,  0
        .equ RECORD_LASTNAME,   40
        .equ RECORD_ADDRESS,    80
        .equ RECORD_AGE,        320
        .equ RECORD_PHONE,      324   # New member.
        .equ RECORD_SIZE,       344   # Was 324.
