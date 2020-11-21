Your First Programs {#firstprogs}
===================

In this chapter you will learn the process for writing and building
Linux assembly-language programs. In addition, you will learn the
structure of assembly-language programs, and a few assembly-language
commands. As you go through this chapter, you may want to refer also to
[???](#instructionsappendix) and [???](#gdbappendix).

These programs may overwhelm you at first. However, go through them with
diligence, read them and their explanations as many times as necessary,
and you will have a solid foundation of knowledge to build on. Please
tinker around with the programs as much as you can. Even if your
tinkering does not work, every failure will help you learn.

Entering in the Program
-----------------------

Okay, this first program is simple. In fact, it\'s not going to do
anything but exit! It\'s short, but it shows some basics about assembly
language and Linux programming. You need to enter the program in an
editor exactly as written, with the filename `exit.s`. The program
follows. Don\'t worry about not understanding it. This section only
deals with typing it in and running it. In [Outline of an Assembly
Language Program](#assemblyoutline) we will describe how it works.

    EXIT-S

What you have typed in is called the *source codesource code*. Source
code is the human-readable form of a program. In order to transform it
into a program that a computer can run, we need to *assembleassemble*
and *linklink* it.

The first step is to *assemble* it. Assembling is the process that
transforms what you typed into instructions for the machine. The machine
itself only reads sets of numbers, but humans prefer words. An *assembly
languageassembly language* is a more human-readable form of the
instructions a computer understands. Assembling transforms the
human-readable file into a machine-readable one. To assembly the program
type in the command

    as exit.s -o exit.o

`as``as` is the command which runs the assembler, `exit.s` is the source
filesource file, and `-o exit.o` tells the assemble to put its output in
the file `exit.o`. `exit.o` is an *object fileobject file*. An object
file is code that is in the machine\'s language, but has not been
completely put together. In most large programs, you will have several
source files, and you will convert each one into an object file. The
*linker*linker is the program that is responsible for putting the object
files together and adding information to it so that the kernel knows how
to load and run it. In our case, we only have one object file, so the
linker is only adding the information to enable it to run. To *linklink*
the file, enter the command

    ld exit.o -o exit

`ld`ld is the command to run the linker, `exit.o` is the object file we
want to link, and `-o exit` instructs the linker to output the new
program into a file called `exit`.[^1] If any of these commands reported
errors, you have either mistyped your program or the command. After
correcting the program, you have to re-run all the commands. *You must
always re-assemble and re-link programs after you modify the source file
for the changes to occur in the program*. You can run `exit` by typing
in the command

    ./exit

The `./``./` is used to tell the computer that the program isn\'t in one
of the normal program directories, but is the current directory
instead[^2]. You\'ll notice when you type this command, the only thing
that happens is that you\'ll go to the next line. That\'s because this
program does nothing but exit. However, immediately after you run the
program, if you type in echo \$?

    echo $?

It will say `0`. What is happening is that every program when it exits
gives Linux an *exit status codeexit status code*, which tells it if
everything went all right. If everything was okay, it returns 0. UNIX
programs return numbers other than zero to indicate failure or other
errors, warnings, or statuses. The programmer determines what each
number means. You can view this code by typing in `echo $?`. In the
following section we will look at what each part of the code does.

Outline of an Assembly Language Program {#assemblyoutline}
---------------------------------------

Take a look at the program we just entered. At the beginning there are
lots of lines that begin with hashes (`#`). These are
*commentscomments*. Comments are not translated by the assembler. They
are used only for the programmer to talk to anyone who looks at the code
in the future. Most programs you write will be modified by others. Get
into the habit of writing comments in your code that will help them
understand both why the program exists and how it works. Always include
the following in your comments:

-   The purpose of the code

-   An overview of the processing involved

-   Anything strange your program does and why it does it[^3]

After the comments, the next line says

        .section .data

Anything starting with a period isn\'t directly translated into a
machine instruction. Instead, it\'s an instruction to the assembler
itself. These are called *assembler directivesassembler directives* or
*pseudo-operationspseudo-operations* because they are handled by the
assembler and are not actually run by the computer. The
`.section``.section` command breaks your program up into sections. This
command starts the data sectiondata section, where you list any memory
storage you will need for data. Our program doesn\'t use any, so we
don\'t need the section. It\'s just here for completeness. Almost every
program you write in the future will have data.

Right after this you have

        .section .text

`.text` which starts the text section. The text sectiontext section of a
program is where the program instructions live.

The next instruction is

        .globl _start

This instructs the assembler that `_start``_start` is important to
remember. `_start` is a *symbolsymbol*, which means that it is going to
be replaced by something else either during assembly or linking. Symbols
are generally used to mark locations of programs or data, so you can
refer to them by name instead of by their location number. Imagine if
you had to refer to every memory location by its address. First of all,
it would be very confusing because you would have to memorize or look up
the numeric memory address of every piece of code or data. In addition,
every time you had to insert a piece of data or code you would have to
change all the addresses in your program! Symbols are used so that the
assembler and linker can take care of keeping track of addresses, and
you can concentrate on writing your program.

`.globl``.globl` means that the assembler shouldn\'t discard this symbol
after assembly, because the linker will need it. `_start``_start` is a
special symbol that always needs to be marked with `.globl` because it
marks the location of the start of the program. *Without marking this
location in this way, when the computer loads your program it won\'t
know where to begin running your program*.

The next line

    _start:

*defines* the value of the `_start`\_start label. A *labellabels* is a
symbolsymbol followed by a colon. Labels define a symbol\'s value. When
the assemblerassembler is assembling the program, it has to assign each
data value and instruction an address. Labels tell the assembler to make
the symbol\'s value be wherever the next instruction or data element
will be. This way, if the actual physical location of the data or
instruction changes, you don\'t have to rewrite any references to it -
the symbol automatically gets the new value.

Now we get into actual computer instructions. The first such instruction
is this:

    movl $1, %eax

When the program runs, this instruction transfers the number `1` into
the EAX register. In assembly language, many instructions have
*operands*operands. `movl`movl has two operands - the *source* and the
*destination*. In this case, the source is the literal number 1, and the
destination is the EAX register. Operands can be numbers, memory
location references, or registers. Different instructions allow
different types of operands. See [???](#instructionsappendix) for more
information on which instructions take which kinds of operands.

On most instructions which have two operands, the first one is the
source operand and the second one is the destination. Note that in these
cases, the source operand is not modified at all. Other instructions of
this type are, for example, `addl`addl, `subl`subl, and `imull`imull.
These add/subtract/multiply the source operand from/to/by the
destination operand and and save the result in the destination operand.
Other instructions may have an operand hardcoded in. `idivl`idivl, for
example, requires that the dividend be in EAX, and EDX be zero, and the
quotient is then transferred to EAX and the remainder to EDX. However,
the divisor can be any register or memory location.

On x86 processors, there are several general-purpose
registersgeneral-purpose registers[^4] (all of which can be used with
`movl`):

-   EAX-INDEXED

-   EBX-INDEXED

-   ECX-INDEXED

-   EDX-INDEXED

-   EDI-INDEXED

-   ESI-INDEXED

In addition to these general-purpose registers, there are also several
special-purpose registersspecial-purpose registers, including:

-   EBP-INDEXED

-   ESP-INDEXED

-   EIP-INDEXED

-   EFLAGS-INDEXED

We\'ll discuss these later, just be aware that they exist.[^5] Some of
these registers, like EIP-INDEXED and EFLAGS-INDEXED can only be
accessed through special instructions. The others can be accessed using
the same instructions as general-purpose registers, but they have
special meanings, special uses, or are simply faster when used in a
specific way.

So, the `movl``movl` instruction moves the number `1` into `%eax`. The
dollar-sign in front of the one indicates that we want to use immediate
mode addressingimmediate mode addressing (refer back to
[???](#dataaccessingmethods)). Without the dollar-sign it would do
direct addressingdirect addressing mode, loading whatever number is at
address `1`. We want the actual number `1` loaded in, so we have to use
immediate mode.

The reason we are moving the number 1 into EAX is because we are
preparing to call the Linux Kernel. The number `1` is the number of the
`exit``exit` *system call* system call. We will discuss system calls in
more depth soon, but basically they are requests for the operating
system\'s help. Normal programs can\'t do everything. Many operations
such as calling other programs, dealing with files, and exiting have to
be handled by the operating system through system callssystem calls.
When you make a system call, which we will do shortly, the system call
number has to be loaded into EAX-INDEXED (for a complete listing of
system calls and their numbers, see [???](#syscallap)). Depending on the
system call, other registers may have to have values in them as well.
Note that system calls is not the only use or even the main use of
registers. It is just the one we are dealing with in this first program.
Later programs will use registers for regular computation.

The operating system, however, usually needs more information than just
which call to make. For example, when dealing with files, the operating
system needs to know which file you are dealing with, what data you want
to write, and other details. The extra details, called
*parametersparameters* are stored in other registers. In the case of the
`exit` system call, the operating system requires a status code be
loaded in EBX-INDEXED. This value is then returned to the system. This
is the value you retrieved when you typed `echo $?`. So, we load EBX
with `0` by typing the following:

    movl $0, %ebx

Now, loading registersregisters with these numbers doesn\'t do anything
itself. Registers are used for all sorts of things besides system calls.
They are where all program logic such as addition, subtraction, and
comparisons take place. Linux simply requires that certain registers be
loaded with certain parameter values before making a system call.
EAX-INDEXED is always required to be loaded with the system call number.
For the other registers, however, each system call has different
requirements. In the `exitexit` system call, EBX-INDEXED is required to
be loaded with the exit statusexit status code. We will discuss
different system calls as they are needed. For a list of common system
calls and what is required to be in each register, see [???](#syscallap)

The next instruction is the \"magic\" one. It looks like this:

        int $0x80

The `intint` stands for *interruptinterrupts*. The `0x800x80` is the
interrupt number to use.[^6] An *interruptinterrupts* interrupts the
normal program flow, and transfers control from our program to
LinuxLinux so that it will do a system call.[^7]. You can think of it as
like signaling Batman(or Larry-BoyLarry-Boy[^8], if you prefer). You
need something done, you send the signal, and then he comes to the
rescue. You don\'t care how he does his work - it\'s more or less magic
- and when he\'s done you\'re back in control. In this case, all we\'re
doing is asking Linux to terminate the program, in which case we won\'t
be back in control. If we didn\'t signal the interrupt, then no system
call would have been performed.

::: {.note}
::: {.title}
Quick System Call Review
:::

To recap - Operating System features are accessed through system
callssystem calls. These are invoked by setting up the registers in a
special way and issuing the instruction `int $0x80`. Linux knows which
system call we want to access by what we stored in the EAX-INDEXED
register. Each system call has other requirements as to what needs to be
stored in the other registers. System call number 1 is the `exit` system
call, which requires the status codestatus code to be placed in
EBX-INDEXED.
:::

Now that you\'ve assembled, linked, run, and examined the program, you
should make some basic edits. Do things like change the number that is
loaded into `%ebx`, and watch it come out at the end with
`echo $?echo$?`. Don\'t forget to assemble and link it again before
running it. Add some comments. Don\'t worry, the worse thing that would
happen is that the program won\'t assemble or link, or will freeze your
screen. That\'s just part of learning!

Planning the Program
--------------------

In our next program we will try to find the maximum of a list of
numbers. Computers are very detail-oriented, so in order to write the
program we will have to have planned out a number of details. These
details include:

-   Where will the original list of numbers be stored?

-   What procedure will we need to follow to find the maximum number?

-   How much storage do we need to carry out that procedure?

-   Will all of the storage fit into registers, or do we need to use
    some memory as well?

You might not think that something as simple as finding the maximum
number from a list would take much planning. You can usually tell people
to find the maximum number, and they can do so with little trouble.
However, our minds are used to putting together complex tasks
automatically. Computers need to be instructed through the process. In
addition, we can usually hold any number of things in our mind without
much trouble. We usually don\'t even realize we are doing it. For
example, if you scan a list of numbers for the maximum, you will
probably keep in mind both the highest number you\'ve seen so far, and
where you are in the list. While your mind does this automatically, with
computers you have to explicitly set up storage for holding the current
position on the list and the current maximum number. You also have other
problems such as how to know when to stop. When reading a piece of
paper, you can stop when you run out of numbers. However, the computer
only contains numbers, so it has no idea when it has reached the last of
*your* numbers.

In computers, you have to plan every step of the way. So, let\'s do a
little planning. First of all, just for reference, let\'s name the
address where the list of numbers starts as `data_items`. Let\'s say
that the last number in the list will be a zero, so we know where to
stop. We also need a value to hold the current position in the list, a
value to hold the current list element being examined, and the current
highest value on the list. Let\'s assign each of these a register:

-   EDI will hold the current position in the list.

-   EBX will hold the current highest value in the list.

-   EAX will hold the current element being examined.

When we begin the program and look at the first item in the list, since
we haven\'t seen any other items, that item will automatically be the
current largest element in the list. Also, we will set the current
position in the list to be zero - the first element. From then, we will
follow the following steps:

1.  Check the current list element (EAX) to see if it\'s zero (the
    terminating element).

2.  If it is zero, exit.

3.  Increase the current position (EDI).

4.  Load the next value in the list into the current value register
    (EAX). What addressing mode might we use here? Why?

5.  Compare the current value (EAX) with the current highest value
    (EBX).

6.  If the current value is greater than the current highest value,
    replace the current highest value with the current value.

7.  Repeat.

That is the procedure. Many times in that procedure I made use of the
word \"if\". These places are where decisions are to be made. You see,
the computer doesn\'t follow the exact same sequence of instructions
every time. Depending on which \"if\"s are correct, the computer may
follow a different set of instructions. The second time through, it
might not have the highest value. In that case, it will skip step 6, but
come back to step 7. In every case except the last one, it will skip
step 2. In more complicated programs, the skipping around increases
dramatically.

These \"if\"s are a class of instructions called *flow controlflow
control* instructions, because they tell the computer which steps to
follow and which paths to take. In the previous program, we did not have
any flow control instructions, as there was only one possible path to
take - exit. This program is much more dynamic in that it is directed by
data. Depending on what data it receives, it will follow different
instruction paths.

In this program, this will be accomplished by two different
instructions, the conditional jumpconditional jump and the unconditional
jumpunconditional jump. The conditional jump changes paths based on the
results of a previous comparison or calculation. The unconditional jump
just goes directly to a different path no matter what. The unconditional
jump may seem useless, but it is very necessary since all of the
instructions will be laid out on a line. If a path needs to converge
back to the main path, it will have to do this by an unconditional jump.
We will see more of both of these jumps in the next section.

Another use of flow controlflow control is in implementing loopsloops. A
loop is a piece of program code that is meant to be repeated. In our
example, the first part of the program (setting the current position to
0 and loading the current highest value with the current value) was only
done once, so it wasn\'t a loop. However, the next part is repeated over
and over again for every number in the list. It is only left when we
have come to the last element, indicated by a zero. This is called a
*loop* because it occurs over and over again. It is implemented by doing
unconditional jumps to the beginning of the loop at the end of the loop,
which causes it to start over. However, you have to always remember to
have a conditional jump to exit the loop somewhere, or the loop will
continue forever! This condition is called an *infinite loopinfinite
loop*. If we accidentally left out step 1, 2, or 3, the loop (and our
program) would never end.

In the next section, we will implement this program that we have
planned. Program planning sounds complicated - and it is, to some
degree. When you first start programming, it\'s often hard to convert
our normal thought process into a procedure that the computer can
understand. We often forget the number of \"temporary storage
locations\" that our minds are using to process problems. As you read
and write programs, however, this will eventually become very natural to
you. Just have patience.

Finding a Maximum Value {#maximum}
-----------------------

Enter the following program as `maximum.s`:

    MAXIMUM-S

Now, assemble and link it with these commands:

    as maximum.s -o maximum.o
    ld maximum.o -o maximum

Now run it, and check its status.

    ./maximum
    echo $?

You\'ll notice it returns the value `222`. Let\'s take a look at the
program and what it does. If you look in the comments, you\'ll see that
the program finds the maximum of a set of numbers (aren\'t comments
wonderful!). You may also notice that in this program we actually have
something in the data sectiondata section. These lines are the data
section:

    data_items:                       #These are the data items
            .long 3,67,34,222,45,75,54,34,44,33,22,11,66,0

Lets look at this. `data_items` is a labellabels that refers to the
location that follows it. Then, there is a directive that starts with
`.long.long`. That causes the assembler to reserve memory for the list
of numbers that follow it. `data_items` refers to the location of the
first one. Because `data_items` is a label, any time in our program
where we need to refer to this address we can use the `data_items`
symbol, and the assembler will substitute it with the address where the
numbers start during assembly. For example, the instruction
`movl data_items, %eax` would move the value 3 into EAX. There are
several different types of memory locations other than `.long.long` that
can be reserved. The main ones are as follows:

`.byte.byte`

:   Bytes take up one storage location for each number. They are limited
    to numbers between 0 and 255.

`.int.int`

:   Ints (which differ from the `int` instruction) take up two storage
    locations for each number. These are limitted to numbers between 0
    and 65535.[^9]

`.long.long`

:   Longs take up four storage locations. This is the same amount of
    space the registers use, which is why they are used in this program.
    They can hold numbers between 0 and 4294967295.

`.ascii.ascii`

:   The `.ascii` directive is to enter in characters into memory.
    Characters each take up one storage location (they are converted
    into bytes internally). So, if you gave the directive
    `.ascii "Hello there\0"`, the assembler would reserve 12 storage
    locations (bytes). The first byte contains the numeric code for `H`,
    the second byte contains the numeric code for `e`, and so forth. The
    last character is represented by `\0`\\0, and it is the terminating
    character (it will never display, it just tells other parts of the
    program that that\'s the end of the characters). Letters and numbers
    that start with a backslash represent characters that are not
    typeable on the keyboard or easily viewable on the screen. For
    example, `\n`\\n refers to the \"newline\"newline character which
    causes the computer to start output on the next line and `\t` \\t
    refers to the \"tab\"tab character. All of the letters in an
    `.ascii` directive should be in quotes.

In our example, the assembler reserves 14 `.long`s, one right after
another. Since each long takes up 4 bytes, that means that the whole
list takes up 56 bytes. These are the numbers we will be searching
through to find the maximum. `data_items` is used by the assembler to
refer to the address of the first of these values.

Take note that the last data item in the list is a zero. I decided to
use a zero to tell my program that it has hit the end of the list. I
could have done this other ways. I could have had the size of the list
hard-coded into the program. Also, I could have put the length of the
list as the first item, or in a separate location. I also could have
made a symbol which marked the last location of the list items. No
matter how I do it, I must have some method of determining the end of
the list. The computer knows nothing - it can only do what it is told.
It\'s not going to stop processing unless I give it some sort of signal.
Otherwise it would continue processing past the end of the list into the
data that follows it, and even to locations where we haven\'t put any
data.

Notice that we don\'t have a `.globl.globl` declaration for
`data_items`. This is because we only refer to these locations within
the program. No other file or program needs to know where they are
located. This is in contrast to the `_start_start` symbol, which Linux
needs to know where it is so that it knows where to begin the program\'s
execution. It\'s not an error to write `.globl data_items`, it\'s just
not necessary. Anyway, play around with this line and add your own
numbers. Even though they are `.long`, the program will produce strange
results if any number is greater than 255, because that\'s the largest
allowed exit statusexit status code. Also notice that if you move the 0
to earlier in the list, the rest get ignored. *Remember that any time
you change the source file, you have to re-assemble and re-link your
program. Do this now and see the results*.

All right, we\'ve played with the data a little bit. Now let\'s look at
the code. In the comments you will notice that we\'ve marked some
*variablesvariables* that we plan to use. A variable is a dedicated
storage location used for a specific purpose, usually given a distinct
name by the programmer. We talked about these in the previous section,
but didn\'t give them a name. In this program, we have several
variables:

-   a variable for the current maximum number found

-   a variable for which number of the list we are currently examining,
    called the index

-   a variable holding the current number being examined

In this case,we have few enough variables that we can hold them all in
registers. In larger programs, you have to put them in memory, and then
move them to registersregisters when you are ready to use them. We will
discuss how to do that later. When people start out programming, they
usually underestimate the number of variables they will need. People are
not used to having to think through every detail of a process, and
therefore leave out needed variables in their first programming
attempts.

In this program, we are using EBX as the location of the largest item
we\'ve found. EDI is used as the *indexindex* to the current data item
we\'re looking at. Now, let\'s talk about what an index is. When we read
the information from `data_items`, we will start with the first one
(data item number 0), then go to the second one (data item number 1),
then the third (data item number 2), and so on. The data item number is
the *indexindex* of `data_items`. You\'ll notice that the first
instruction we give to the computer is:

        movl $0, %edi

Since we are using `%edi` as our index, and we want to start looking at
the first item, we load `%edi` with 0. Now, the next instruction is
tricky, but crucial to what we\'re doing. It says:

        movl data_items(,%edi,4), %eax

movl

Now to understand this line, you need to keep several things in mind:

-   `data_items` is the location number of the start of our number list.

-   Each number is stored across 4 storage locations (because we
    declared it using `.long`)

-   `%edi` is holding 0 at this point

So, basically what this line does is say, \"start at the beginning of
data_items, and take the first item number (because `%edi` is 0), and
remember that each number takes up four storage locations.\" Then it
stores that number in `%eax`. This is how you write indexed addressing
modeindexed addressing mode instructions in assembly language. The
instruction in a general form is this:

    movl  BEGINNINGADDRESS(,%INDEXREGISTER,WORDSIZE)

In our case `data_items` was our beginning address, EDI was our index
registerindex register, and 4 was our word size. This topic is discussed
further in [Addressing Modes](#movaddrmodes).

If you look at the numbers in `data_items`, you will see that the number
3 is now in EAX. If EDI was set to 1, the number 67 would be in EAX, and
if it was set to 2, the number 34 would be in EAX, and so forth. Very
strange things would happen if we used a number other than 4 as the size
of our storage locations.[^10] The way you write this is very awkward,
but if you know what each piece does, it\'s not too difficult. For more
information about this, see [Addressing Modes](#movaddrmodes)

Let\'s look at the next line:

        movl %eax, %ebx

We have the first item to look at stored in `%eax`. Since it is the
first item, we know it\'s the biggest one we\'ve looked at. We store it
in `%ebx`, since that\'s where we are keeping the largest number found.
Also, even though `movlmovl` stands for *move*, it actually copies the
value, so `%eax` and `%ebx` both contain the starting value.[^11]

Now we move into a *looploop*. A loop is a segment of your program that
might run more than once. We have marked the starting location of the
loop in the symbol `start_loop`. The reason we are doing a loop is
because we don\'t know how many data items we have to process, but the
procedure will be the same no matter how many there are. We don\'t want
to have to rewrite our program for every list length possible. In fact,
we don\'t even want to have to write out code for a comparison for every
list item. Therefore, we have a single section of code (a loop) that we
execute over and over again for every element in `data_items`.

In the previous section, we outlined what this loop needed to do. Let\'s
review:

-   Check to see if the current value being looked at is zero. If so,
    that means we are at the end of our data and should exit the loop.

-   We have to load the next value of our list.

-   We have to see if the next value is bigger than our current biggest
    value.

-   If it is, we have to copy it to the location we are holding the
    largest value in.

-   Now we need to go back to the beginning of the loop.

Okay, so now lets go to the code. We have the beginning of the loop
marked with `start_loop`. That is so we know where to go back to at the
end of our loop. Then we have these instructions:

        cmpl $0, %eax
        je loop_exit

The `cmplcmpl` instruction compares the two values. Here, we are
comparing the number 0 to the number stored in EAX This compare
instruction also affects a register not mentioned here, the
EFLAGS-INDEXED register. This is also known as the status registerstatus
register, and has many uses which we will discuss later. Just be aware
that the result of the comparison is stored in the status register. The
next line is a flow controlflow control instruction which says to *jump*
to the `loop_exit` location if the values that were just compared are
equal (that\'s what the `e` of `je` means). It uses the status register
to hold the value of the last comparison. We used `je`, but there are
many jump statements that you can use:

`je`

:   Jump if the values were equal

`jg`

:   Jump if the second value was greater than the first value[^12]

`jge`

:   Jump if the second value was greater than or equal to the first
    value

`jl`

:   Jump if the second value was less than the first value

`jle`

:   Jump if the second value was less than or equal to the first value

`jmp`

:   Jump no matter what. This does not need to be preceeded by a
    comparison.

The complete list is documented in [???](#instructionsappendix). In this
case, we are jumping if EAX holds the value of zero. If so, we are done
and we go to `loop_exit`.[^13]

If the last loaded element was not zero, we go on to the next
instructions:

        incl %edi
        movl data_items(,%edi,4), %eax

If you remember from our previous discussion, EDI contains the
indexindex to our list of values in `data_items`. `inclincl` increments
the value of EDI by one. Then the `movl` is just like the one we did
beforehand. However, since we already incremented EDI, EAX is getting
the next value from the list. Now EAX has the next value to be tested.
So, let\'s test it!

        cmpl %ebx, %eax
        jle start_loop

Here we compare our current value, stored in EAX to our biggest value so
far, stored in EBX. If the current value is less or equal to our biggest
value so far, we don\'t care about it, so we just jump back to the
beginning of the loop. Otherwise, we need to record that value as the
largest one:

        movl %eax, %ebx
        jmp start_loop

which moves the current value into EBX, which we are using to store the
current largest value, and starts the loop over again.

Okay, so the loop executes until it reaches a 0, when it jumps to
`loop_exit`. This part of the program calls the Linux kernel to exit. If
you remember from the last program, when you call the operating system
(remember it\'s like signaling Batman), you store the system callsystem
call number in EAX-INDEXED (1 for the `exit` call), and store the other
values in the other registers. The exit call requires that we put our
exit statusexit status code in EBX-INDEXED We already have the exit
status there since we are using EBX as our largest number, so all we
have to do is load EAX with the number one and call the kernel to exit.
Like this:

        movl $1, %eax
        int  $0x80

Okay, that was a lot of work and explanation, especially for such a
small program. But hey, you\'re learning a lot! Now, read through the
whole program again, paying special attention to the comments. Make sure
that you understand what is going on at each line. If you don\'t
understand a line, go back through this section and figure out what the
line means.

You might also grab a piece of paper, and go through the program
step-by-step, recording every change to every register, so you can see
more clearly what is going on.

Addressing Modes {#movaddrmodes}
----------------

In [???](#dataaccessingmethods) we learned the different types of
addressing modesaddressing modes available for use in assembly language.
This section will deal with how those addressing modes are represented
in assembly language instructions.

The general form of memory addressmemory address references is this:

    ADDRESS_OR_OFFSET(%BASE_OR_OFFSET,%INDEX,MULTIPLIER)

All of the fields are optional. To calculate the address, simply perform
the following calculation:

    FINAL ADDRESS = ADDRESS_OR_OFFSET + %BASE_OR_OFFSET + MULTIPLIER * %INDEX

`ADDRESS_OR_OFFSET` and `MULTIPLIER` must both be constants, while the
other two must be registers. If any of the pieces is left out, it is
just substituted with zero in the equation.

All of the addressing modes mentioned in [???](#dataaccessingmethods)
except immediate-mode can be represented in this fashion.

direct addressing modedirect addressing mode

:   This is done by only using the `ADDRESS_OR_OFFSET` portion. Example:

        movl ADDRESS, %eax

    This loads EAX with the value at memory address `ADDRESS`.

indexed addressing modeindexed addressing mode

:   This is done by using the `ADDRESS_OR_OFFSET` and the `%INDEX`
    portion. You can use any general-purpose register as the index
    register. You can also have a constant multipliermultiplier of 1, 2,
    or 4 for the index registerindex register, to make it easier to
    index by bytes, double-bytes, and words. For example, let\'s say
    that we had a string of bytes as `string_start` and wanted to access
    the third one (an index of 2 since we start counting the index at
    zero), and ECX held the value 2. If you wanted to load it into EAX
    you could do the following:

        movl string_start(,%ecx,1), %eax

    This starts at `string_start`, and adds `1 * %ecx` to that address,
    and loads the value into EAX.

indirect addressing modeindirect addressing mode

:   Indirect addressing mode loads a value from the address indicated by
    a register. For example, if EAX held an address, we could move the
    value at that address to EBX by doing the following:

        movl (%eax), %ebx

base pointer addressing modebase pointer addressing mode

:   Base-pointer addressing is similar to indirect addressing, except
    that it adds a constant value to the address in the register. For
    example, if you have a record where the age value is 4 bytes into
    the record, and you have the address of the record in EAX, you can
    retrieve the age into EBX by issuing the following instruction:

        movl  4(%eax), %ebx

immediate modeimmediate mode addressing

:   Immediate mode is very simple. It does not follow the general form
    we have been using. Immediate mode is used to load direct values
    into registers or memory locations. For example, if you wanted to
    load the number 12 into EAX, you would simply do the following:

        movl $12, %eax

    Notice that to indicate immediate mode, we used a dollar sign in
    front of the number. If we did not, it would be direct addressing
    mode, in which case the value located at memory location 12 would be
    loaded into EAX rather than the number 12 itself.

register addressing moderegister addressing mode

:   Register mode simply moves data in or out of a register. In all of
    our examples, register addressing mode was used for the other
    operand.

These addressing modes are very important, as every memory access will
use one of these. Every mode except immediate mode can be used as either
the source or destination operanddestination operand. Immediate mode can
only be a source operandsource operand.

In addition to these modes, there are also different instructions for
different sizes of values to move. For example, we have been using
`movl` to move data a wordword at a time. in many cases, you will only
want to move data a bytebytes at a time. This is accomplished by the
instruction `movbmovb`. However, since the registers we have discussed
are word-sized and not byte-sized, you cannot use the full register.
Instead, you have to use a portion of the register.

Take for instance EAX. If you only wanted to work with two bytes at a
time, you could just use AX-INDEXED. AX is the least-significant half
(i.e. - the last part of the number) of the EAX register, and is useful
when dealing with two-byte quantities. AX is further divided up into
AL-INDEXED and AH-INDEXED. AL is the least-significant byte of AX, and
AH is the most significant byte.[^14] Loading a value into EAX will wipe
out whatever was in AL and AH (and also AX, since AX is made up of
them). Similarly, loading a value into either AL or AH will corrupt any
value that was formerly in EAX. Basically, it\'s wise to only use a
register for either a byte or a word, but never both at the same time.

![*Layout of the EAX register*](resource/image/registerdescription.png)

For a more comprehensive list of instructions, see
[???](#instructionsappendix).

Review
------

### Know the Concepts

-   What does it mean if a line in the program starts with the \'\#\'
    character?

-   What is the difference between an assembly language file and an
    object code file?

-   What does the linker do?

-   How do you check the result status code of the last program you ran?

-   What is the difference between `movl $1, %eax` and `movl 1, %eax`?

-   Which register holds the system call number?

-   What are indexes used for?

-   Why do indexes usually start at 0?

-   If I issued the command `movl data_items(,%edi,4), %eax` and
    data_items was address 3634 and EDI held the value 13, what address
    would you be using to move into EAX?

-   List the general-purpose registers.

-   What is the difference between `movl` and `movb`?

-   What is flow control?

-   What does a conditional jump do?

-   What things do you have to plan for when writing a program?

-   Go through every instruction and list what addressing mode is being
    used for each operand.

### Use the Concepts

-   Modify the first program to return the value 3.

-   Modify the `maximum` program to find the minimum instead.

-   Modify the `maximum` program to use the number 255 to end the list
    rather than the number 0

-   Modify the `maximum` program to use an ending address rather than
    the number 0 to know when to stop.

-   Modify the `maximum` program to use a length count rather than the
    number 0 to know when to stop.

-   What would the instruction `movl _start, %eax` do? Be specific,
    based on your knowledge of both addressing modes and the meaning of
    `_start`. How would this differ from the instruction
    `movl $_start, %eax`?

### Going Further

-   Modify the first program to leave off the `int` instruction line.
    Assemble, link, and execute the new program. What error message do
    you get. Why do you think this might be?

-   So far, we have discussed three approaches to finding the end of the
    list - using a special number, using the ending address, and using
    the length count. Which approach do you think is best? Why? Which
    approach would you use if you knew that the list was sorted? Why?

[^1]: If you are new to Linux and UNIX, you may not be aware that files
    don\'t have to have extensions. In fact, while Windows uses the
    `.exe` extension to signify an executable program, UNIX executables
    usually have no extension.

[^2]: `.` refers to the current directory in Linux and UNIX systems.

[^3]: You\'ll find that many programs end up doing things strange ways.
    Usually there is a reason for that, but, unfortunately, programmers
    never document such things in their comments. So, future programmers
    either have to learn the reason the hard way by modifying the code
    and watching it break, or just leaving it alone whether it is still
    needed or not. You should *always* document any strange behavior
    your program performs. Unfortunately, figuring out what is strange
    and what is straightforward comes mostly with experience.

[^4]: Note that on x86 processors, even the general-purpose registers
    have some special purposes, or used to before it went 32-bit.
    However, these are general-purpose registers for most instructions.
    Each of them has at least one instruction where it is used in a
    special way. However, for most of them, those instructions aren\'t
    covered in this book.

[^5]: You may be wondering, *why do all of these registers begin with
    the letter `e`?* The reason is that early generations of x86
    processors were 16 bits rather than 32 bits. Therefore, the
    registers were only half the length they are now. In later
    generations of x86 processors, the size of the registers doubled.
    They kept the old names to refer to the first half of the register,
    and added an `e` to refer to the extended versions of the register.
    Usually you will only use the extended versions. Newer models also
    offer a 64-bit mode, which doubles the size of these registers yet
    again and uses an `r` prefix to indicate the larger registers (i.e.
    RAX is the 64-bit version of EAX). However, these processors are not
    widely used, and are not covered in this book.

[^6]: You may be wondering why it\'s `0x80` instead of just `80`. The
    reason is that the number is written in hexadecimalhexadecimal. In
    hexadecimal, a single digit can hold 16 values instead of the normal
    10. This is done by utilizing the letters `a` through `f` in
    addition to the regular digits. `a` represents 10, `b` represents
    11, and so on. 0x10 represents the number 16, and so on. This will
    be discussed more in depth later, but just be aware that numbers
    starting with `0x` are in hexadecimal. Tacking on an `H` at the end
    is also sometimes used instead, but we won\'t do that in this book.
    For more information about this, see [???](#countingchapter)

[^7]: Actually, the interrupt transfers control to whoever set up an
    *interrupt handler* for the interrupt number. In the case of Linux,
    all of them are set to be handled by the Linux kernel.

[^8]: If you don\'t watch Veggie Tales, you should. Start with Dave and
    the Giant Pickle.

[^9]: Note that no numbers in assembly language (or any other computer
    language I\'ve seen) have commas embedded in them. So, always write
    numbers like `65535`, and never like `65,535`.

[^10]: The instruction doesn\'t really use 4 for the size of the storage
    locations, although looking at it that way works for our purposes
    now. It\'s actually what\'s called a *multipliermultiplier*.
    basically, the way it works is that you start at the location
    specified by `data_items`, then you add `%edi`\*4 storage locations,
    and retrieve the number there. Usually, you use the size of the
    numbers as your multiplier, but in some circumstances you\'ll want
    to do other things.

[^11]: Also, the `l` in `movlmovl` stands for *move long* since we are
    moving a value that takes up four storage locations.

[^12]: notice that the comparison is to see if the *second* value is
    greater than the first. I would have thought it the other way
    around. You will find a lot of things like this when learning
    programming. It occurs because different things make sense to
    different people. Anyway, you\'ll just have to memorize such things
    and go on.

[^13]: The names of these symbols can be anything you want them to be,
    as long as they only contain letters and the underscore
    character(`_`). The only one that is forced is `_start_start`, and
    possibly others that you declare with `.globl.globl`. However, if it
    is a symbol you define and only you use, feel free to call it
    anything you want that is adequately descriptive (remember that
    others will have to modify your code later, and will have to figure
    out what your symbols mean).

[^14]: When we talk about the most or least *significant* byte, it may
    be a little confusing. Let\'s take the number 5432. In that number,
    54 is the most significant half of that number and 32 is the least
    significant half. You can\'t quite divide it like that for
    registers, since they operate on base 2 rather than base 10 numbers,
    but that\'s the basic idea. For more information on this topic, see
    [???](#countingchapter).
