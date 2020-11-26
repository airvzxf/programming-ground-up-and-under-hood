    # PURPOSE:    Simple program that exits and returns a
    #             status code back to the Linux kernel.
    #
    # INPUT:      None.
    #
    # OUTPUT:     Returns a status code.  This can be viewed
    #             by typing `echo $?` after running the program
    #
    # VARIABLES:
    #             %eax holds the system call number.
    #             %ebx holds the return status .
    #
    .section .data
    .section .text
    .globl _start
_start:
    movl $1, %eax      # This is the Linux kernel command
                       # number (system call) for exiting
                       # a program.
    movl $0, %ebx      # This is the status number we will
                       # return to the operating system.
                       # Change this around and it will
                       # return different things to
                       # `echo $?`.
    int $0x80          # This wakes up the kernel to run
                       # the exit command.
