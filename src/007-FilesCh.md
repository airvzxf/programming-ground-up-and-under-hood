Dealing with Files {#filesch}
==================

A lot of computer programming deals with filesfiles. After all, when we
reboot our computers, the only thing that remains from previous sessions
are the things that have been put on disk. Data which is stored in files
is called *persistentpersistance* data, because it persists in files
that remain on the disk even when the program isn\'t running..

The UNIX File Concept
---------------------

Each operating system has its own way of dealing with files. However,
the UNIX method, which is used on Linux, is the simplest and most
universal. UNIX files, no matter what program created them, can all be
accessed as a sequential stream of bytes. When you access a file, you
start by opening it by name. The operating system then gives you a
number, called a *file descriptorfile descriptors*, which you use to
refer to the file until you are through with it. You can then read and
write to the file using its file descriptor. When you are done reading
and writing, you then close the file, which then makes the file
descriptor useless.

In our programs we will deal with files in the following ways:

1.  Tell Linux the name of the file to open, and in what mode you want
    it opened (read, write, both read and write, create it if it
    doesn\'t exist, etc.). This is handled with the `openopen` system
    call, which takes a filename, a number representing the mode, and a
    permissionpermissions set as its parameters. EAX-INDEXED will hold
    the system call number, which is 5. The address of the first
    character of the filename should be stored in EBX-INDEXED. The
    read/write intentions, represented as a number, should be stored in
    ECX-INDEXED. For now, use 0 for files you want to read from, and
    03101 for files you want to write to (you must include the leading
    zero).[^1] Finally, the permission set should be stored as a number
    in EDX-INDEXED. If you are unfamiliar with UNIX permissions, just
    use 0666 for the permissions (again, you must include the leading
    zero).

2.  Linux will then return to you a file descriptorfile descriptors in
    EAX-INDEXED. Remember, this is a number that you use to refer to
    this file throughout your program.

3.  Next you will operate on the file doing reads and/or writes, each
    time giving Linux the file descriptor you want to use. `readread` is
    system call 3, and to call it you need to have the file descriptor
    in EBX, the address of a buffer for storing the data that is read in
    ECX, and the size of the buffer in EDX. Buffers will be explained in
    [Buffers and ](#buffersbss). `read` will return with either the
    number of characters read from the file, or an error code. Error
    codes can be distinguished because they are always negative numbers
    (more information on negative numbers can be found in
    [???](#countingchapter)). `writewrite` is system call 4, and it
    requires the same parameters as the `read` system call, except that
    the buffer should already be filled with the data to write out. The
    `write` system call will give back the number of bytes written in
    EAX or an error code.

4.  When you are through with your files, you can then tell Linux to
    close them. Afterwards, your file descriptorfile descriptors is no
    longer valid. This is done using `closeclose`, system call 6. The
    only parameter to `close` is the file descriptor, which is placed in
    EBX

Buffers and `.bss` {#buffersbss}
------------------

In the previous section we mentioned buffersbuffers without explaining
what they were. A buffer is a continuous block of bytes used for bulk
data transfer. When you request to read a file, the operating system
needs to have a place to store the data it reads. That place is called a
buffer. Usually buffers are only used to store data temporarily, and it
is then read from the buffers and converted to a form that is easier for
the programs to handle. Our programs won\'t be complicated enough to
need that done. For an example, let\'s say that you want to read in a
single line of text from a file but you do not know how long that line
is. You would then simply read a large number of bytes/characters from
the file into a buffer, look for the end-of-line character, and copy all
of the characters to that end-of-line character to another location. If
you didn\'t find an end-of-line character, you would allocate another
buffer and continue reading. You would probably wind up with some
characters left over in your buffer in this case, which you would use as
the starting point when you next need data from the file.[^2]

Another thing to note is that buffersbuffers are a fixed size, set by
the programmer. So, if you want to read in data 500 bytes at a time, you
send the `read` system call the address of a 500-byte unused location,
and send it the number 500 so it knows how big it is. You can make it
smaller or bigger, depending on your application\'s needs.

To create a buffer, you need to either reserve static or dynamic
storage. Static storage is what we have talked about so far, storage
locations declared using `.long` or `.byte` directives. Dynamic storage
will be discussed in [???](#dynamicmemory). There are problems, though,
with declaring buffers using `.byte.byte`. First, it is tedious to type.
You would have to type 500 numbers after the `.byte` declaration, and
they wouldn\'t be used for anything but to take up space. Second, it
uses up space in the executable. In the examples we\'ve used so far, it
doesn\'t use up too much, but that can change in larger programs. If you
want 500 bytes you have to type in 500 numbers and it wastes 500 bytes
in the executable. There is a solution to both of these. So far, we have
discussed two program sections, the `.text.text` and the `.data.data`
sections. There is another section called the `.bss.bss`. This section
is like the data section, except that it doesn\'t take up space in the
executable. This section can reserve storage, but it can\'t initialize
it. In the `.data` section, you could reserve storage and set it to an
initial value. In the `.bss` section, you can\'t set an initial value.
This is useful for buffers because we don\'t need to initialize them
anyway, we just need to reserve storage. In order to do this, we do the
following commands:

    .section .bss
        .lcomm my_buffer, 500

This directive, `.lcomm.lcomm`, will create a symbol, `my_buffer`, that
refers to a 500-byte storage location that we can use as a buffer. We
can then do the following, assuming we have opened a file for reading
and have placed the file descriptor in EBX:

        movl $my_buffer, %ecx
        movl 500, %edx
        movl 3, %eax
        int  $0x80

This will read up to 500 bytes into our buffer. In this example, I
placed a dollar sign in front of `my_buffer`. Remember that the reason
for this is that without the dollar sign, `my_buffer` is treated as a
memory location, and is accessed in direct addressing modedirect
addressing mode. The dollar sign switches it to immediate mode
addressing, which actually loads the number represented by `my_buffer`
itself (i.e. - the address of the start of our buffer, which is the
address of `my_buffer`) into ECX.

Standard and Special Files
--------------------------

You might think that programs start without any files open by default.
This is not true. Linux programs usually have at least three open file
descriptorsfile descriptors when they begin. They are:

STDINSTDIN

:   This is the *standard inputstandard input*. It is a read-only file,
    and usually represents your keyboard.[^3] This is always file
    descriptor 0.

STDOUTSTDOUT

:   This is the *standard outputstandard output*. It is a write-only
    file, and usually represents your screen display. This is always
    file descriptor 1.

STDERRSTDERR

:   This is your *standard errorstandard error*. It is a write-only
    file, and usually represents your screen display. Most regular
    processing output goes to `STDOUT`, but any error messages that come
    up in the process go to `STDERR`. This way, if you want to, you can
    split them up into separate places. This is always file
    descriptor 2.

Any of these \"filesfiles\" can be redirected from or to a real file,
rather than a screen or a keyboard. This is outside the scope of this
book, but any good book on the UNIX command-linecommand-line will
describe it in detail. The program itself does not even need to be aware
of this indirection - it can just use the standard file descriptorsfile
descriptors as usual.

Notice that many of the files you write to aren\'t files at all.
UNIX-based operating systems treat all input/output systems as files.
Network connections are treated as filesfiles, your serial port is
treated like a file, even your audio devices are treated as files.
Communication between processes is usually done through special
filesspecial files called pipespipes. Some of these files have different
methods of opening and creating them than regular filesregular files
(i.e. - they don\'t use the `open` system call), but they can all be
read from and written to using the standard `read` and `write` system
calls.

Using Files in a Program
------------------------

We are going to write a simple program to illustrate these concepts. The
program will take two files, and read from one, convert all of its
lower-case letters to upper-case, and write to the other file. Before we
do so, let\'s think about what we need to do to get the job done:

-   Have a function that takes a block of memory and converts it to
    upper-case. This function would need an address of a block of memory
    and its size as parameters.

-   Have a section of code that repeatedly reads in to a buffer, calls
    our conversion function on the buffer, and then writes the buffer
    back out to the other file.

-   Begin the program by opening the necessary files.

Notice that I\'ve specified things in reverse order that they will be
done. That\'s a useful trick in writing complex programs - first decide
the meat of what is being done. In this case, it\'s converting blocks of
characters to upper-case. Then, you think about what all needs to be
setup and processed to get that to happen. In this case, you have to
open files, and continually read and write blocks to disk. One of the
keys of programming is continually breaking down problems into smaller
and smaller chunks until it\'s small enough that you can easily solve
the problem. Then you can build these chunks back up until you have a
working program.[^4]

You may have been thinking that you will never remember all of these
numbers being thrown at you - the system call numbers, the interrupt
number, etc. In this program we will also introduce a new directive,
`.equ` which should help out. `.equ.equ` allows you to assign names to
numbers. For example, if you did `.equ LINUX_SYSCALL, 0x800x80`, any
time after that you wrote `LINUX_SYSCALL`, the assembler would substitue
`0x80` for that. So now, you can write

    int $LINUX_SYSCALL

which is much easier to read, and much easier to remember. Coding is
complex, but there are a lot of things we can do like this to make it
easier.

Here is the program. Note that we have more labelslabels than we
actually use for jumps, because some of them are just there for clarity.
Try to trace through the program and see what happens in various cases.
An in-depth explanation of the program will follow.

    TOUPPER-NOMM-SIMPLIFIED-S

Type in this program as `toupper.s`, and then enter in the following
commands:

    as toupper.s -o toupper.o
    ld toupper.o -o toupper

This builds a program called `toupper`, which converts all of the
lowercase characters in a file to uppercase. For example, to convert the
file `toupper.s` to uppercase, type in the following command:

    ./toupper toupper.s toupper.uppercase

You will now find in the file `toupper.uppercase` an uppercase version
of your original file.

Let\'s examine how the program works.

The first section of the program is marked `CONSTANTS`. In programming,
a constantconstants is a value that is assigned when a program assembles
or compiles, and is never changed. I make a habit of placing all of my
constants together at the beginning of the program. It\'s only necessary
to declare them before you use them, but putting them all at the
beginning makes them easy to find. Making them all upper-case makes it
obvious in your program which values are constants and where to find
them.[^5] In assembly language, we declare constants with the `.equ.equ`
directive as mentioned before. Here, we simply give names to all of the
standard numbers we\'ve used so far, like system call numbers, the
syscall interrupt number, and file open options.

The next section is marked `BUFFERS`. We only use one bufferbuffer in
this program, which we call `BUFFER_DATA`. We also define a constant,
`BUFFER_SIZE`, which holds the size of the buffer. If we always refer to
this constant rather than typing out the number 500 whenever we need to
use the size of the buffer, if it later changes, we only need to modify
this value, rather than having to go through the entire program and
changing all of the values individually.

Instead of going on to the `_start` section of the program, go to the
end where we define the `convert_to_upper` function. This is the part
that actually does the conversion.

This section begins with a list of constants that we will use The reason
these are put here rather than at the top is that they only deal with
this one function. We have these definitions:

        .equ  LOWERCASE_A, 'a'
        .equ  LOWERCASE_Z, 'z'
        .equ  UPPER_CONVERSION, 'A' - 'a' 

The first two simply define the letters that are the boundaries of what
we are searching for. Remember that in the computer, letters are
represented as numbers. Therefore, we can use `LOWERCASE_A` in
comparisons, additions, subtractions, or anything else we can use
numbers in. Also, notice we define the constant `UPPER_CONVERSION`.
Since letters are represented as numbers, we can subtract them.
Subtracting an upper-case letter from the same lower-case letter gives
us how much we need to add to a lower-case letter to make it upper case.
If that doesn\'t make sense, look at the ASCIIASCII code tables
themselves (see [???](#asciilisting)). You\'ll notice that the number
for the character `A` is 65 and the character `a` is 97. The conversion
factor is then -32. For any lowercase letter if you add -32, you will
get its capital equivalent.

After this, we have some constants labelled `STACK POSITIONS`. Remember
that function parametersfunction parameters are pushed onto the stack
before function calls. These constants (prefixed with `ST` for clarity)
define where in the stack we should expect to find each piece of data.
The return addressreturn address is at position 4 + ESP, the length of
the buffer is at position 8 + ESP, and the address of the buffer is at
position 12 + ESP. Using symbols for these numbers instead of the
numbers themselves makes it easier to see what data is being used and
moved.

Next comes the label `convert_to_upper`. This is the entry point of the
function. The first two lines are our standard function lines to save
the stack pointer. The next two lines

        movl  ST_BUFFER(%ebp), %eax
        movl  ST_BUFFER_LEN(%ebp), %ebx

move the function parameters into the appropriate registers for use.
Then, we load zero into EDI. What we are going to do is iterate through
each byte of the buffer by loading from the location EAX + EDI,
incrementing EDI, and repeating until EDI is equal to the buffer length
stored in EBX. The lines

        cmpl  $0, %ebx
        je    end_convert_loop

are just a sanity check to make sure that noone gave us a buffer of zero
size. If they did, we just clean up and leave. Guarding against
potential user and programming errors is an important task of a
programmer. You can always specify that your function should not take a
buffer of zero size, but it\'s even better to have the function check
and have a reliable exit plan if it happens.

Now we start our loop. First, it moves a byte into CL. The code for this
is

        movb  (%eax,%edi,1), %cl

It is using an indexed indirect addressing modeindexed indirect
addressing mode. It says to start at EAX and go EDI locations forward,
with each location being 1 byte big. It takes the value found there, and
put it in CL. After this it checks to see if that value is in the range
of lower-case *a* to lower-case *z*. To check the range, it simply
checks to see if the letter is smaller than *a*. If it is, it can\'t be
a lower-case letter. Likewise, if it is larger than *z*, it can\'t be a
lower-case letter. So, in each of these cases, it simply moves on. If it
is in the proper range, it then adds the uppercase conversion, and
stores it back into the buffer.

Either way, it then goes to the next value by incrementing %cl;. Next it
checks to see if we are at the end of the buffer. If we are not at the
end, we jump back to the beginning of the loop (the `convert_loop`
label). If we are at the end, it simply continues on to the end of the
function. Because we are modifying the buffer directly, we don\'t need
to return anything to the calling program - the changes are already in
the buffer. The label `end_convert_loop` is not needed, but it\'s there
so it\'s easy to see where the parts of the program are.

Now we know how the conversion process works. Now we need to figure out
how to get the data in and out of the files.

Before reading and writing the files we must open them. The UNIX
`openopen` system call is what handles this. It takes the following
parameters:

-   EAX-INDEXED contains the system call number as usual - 5 in this
    case.

-   EBX-INDEXED contains a pointer to a string that is the name of the
    file to open. The string must be terminated with the null
    characternull character.

-   ECX-INDEXED contains the options used for opening the file. These
    tell Linux how to open the file. They can indicate things such as
    open for reading, open for writing, open for reading and writing,
    create if it doesn\'t exist, delete the file if it already exists,
    etc. We will not go into how to create the numbers for the options
    until [???](#truthbinarynumbers). For now, just trust the numbers we
    come up with.

-   EDX-INDEXED contains the permissions that are used to open the file.
    This is used in case the file has to be created first, so Linux
    knows what permissions to create the file with. These are expressed
    in octal, just like regular UNIX permissions.[^6]

permissions After making the system call, the file descriptor of the
newly-opened file is stored in EAX-INDEXED.

So, what files are we opening? In this example, we will be opening the
files specified on the command-linecommand-line. Fortunately,
command-line parameters are already stored by Linux in an easy-to-access
location, and are already null-terminated. When a Linux program begins,
all pointers to command-line arguments are stored on the stack. The
number of arguments is stored at `(%esp)`, the name of the program is
stored at `4(%esp)`, and the arguments are stored from `8(%esp)` on. In
the C Programming language, this is referred to as the `argvargv` array,
so we will refer to it that way in our program.

The first thing our program does is save the current stack position in
EBP and then reserve some space on the stack to store the file
descriptors. After this, it starts opening files.

The first file the program opens is the input file, which is the first
command-line argument. We do this by setting up the system call. We put
the file name into EBX-INDEXED, the read-only mode number into
ECX-INDEXED, the default mode of `$0666` into EDX-INDEXED, and the
system call number into EAX-INDEXED After the system call, the file is
open and the file descriptor is stored in EAX-INDEXED.[^7] The file
descriptor is then transferred to its appropriate place on the stack.

The same is then done for the output file, except that it is created
with a write-only, create-if-doesn\'t-exist, truncate-if-does-exist
mode. Its file descriptor is stored as well.

Now we get to the main part - the read/write loop. Basically, we will
read fixed-size chunks of data from the input file, call our conversion
function on it, and write it back to the output file. Although we are
reading fixed-size chunks, the size of the chunks don\'t matter for this
program - we are just operating on straight sequences of characters. We
could read it in with as little or as large of chunks as we want, and it
still would work properly.

The first part of the loop is to read the data. This uses the `readread`
system call. This call just takes a file descriptor to read from, a
buffer to write into, and the size of the bufferbuffer (i.e. - the
maximum number of bytes that could be written). The system call returns
the number of bytes actually read, or end-of-file (the number 0).

After reading a block, we check EAX-INDEXED for an end-of-file marker.
If found, it exits the loop. Otherwise we keep on going.

After the data is read, the `convert_to_upper` function is called with
the buffer we just read in and the number of characters read in the
previous system call. After this function executes, the buffer should be
capitalized and ready to write out. The registers are then restored with
what they had before.

Finally, we issue a `writewrite` system call, which is exactly like the
`read` system call, except that it moves the data from the buffer out to
the file. Now we just go back to the beginning of the loop.

After the loop exits (remember, it exits if, after a read, it detects
the end of the file), it simply closes its file descriptors and exits.
The close system call just takes the file descriptor to close in
EBX-INDEXED.

The program is then finished!

Review
------

### Know the Concepts

-   Describe the lifecycle of a file descriptor.

-   What are the standard file descriptors and what are they used for?

-   What is a buffer?

-   What is the difference between the `.data` section and the `.bss`
    section?

-   What are the system calls related to reading and writing files?

### Use the Concepts

-   Modify the `toupper` program so that it reads from `STDIN` and
    writes to `STDOUT` instead of using the files on the command-line.

-   Change the size of the buffer.

-   Rewrite the program so that it uses storage in the `.bss` section
    rather than the stack to store the file descriptors.

-   Write a program that will create a file called `heynow.txt` and
    write the words \"Hey diddle diddle!\" into it.

### Going Further

-   What difference does the size of the buffer make?

-   What error results can be returned by each of these system calls?

-   Make the program able to either operate on command-line arguments or
    use `STDIN` or `STDOUT` based on the number of command-line
    arguments specified by `ARGC`.

-   Modify the program so that it checks the results of each system
    call, and prints out an error message to `STDOUT` when it occurs.

[^1]: This will be explained in more detail in
    [???](#truthbinarynumbers).

[^2]: While this sounds complicated, most of the time in programming you
    will not need to deal directly with buffers and file descriptors. In
    [???](#linking) you will learn how to use existing code present in
    Linux to handle most of the complications of file input/output for
    you.

[^3]: As we mentioned earlier, in Linux, almost everything is a
    \"file\". Your keyboard input is considered a file, and so is your
    screen display.

[^4]: Maureen Sprankle\'s Problem Solving and Programming Concepts is an
    excellent book on the problem-solving process applied to computer
    programming.

[^5]: This is fairly standard practice among programmers in all
    languages.

[^6]: If you aren\'t familiar with UNIX permissions, just put `$0666`
    here. Don\'t forget the leading zero, as it means that the number is
    an octaloctal number.

[^7]: Notice that we don\'t do any error checking on this. That is done
    just to keep the program simple. In normal programs, every system
    call should normally be checked for success or failure. In failure
    cases, EAX will hold an error code instead of a return value. Error
    codes are negative, so they can be detected by comparing EAX-INDEXED
    to zero and jumping if it is less than zero.
