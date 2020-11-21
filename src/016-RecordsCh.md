Reading and Writing Simple Records {#records}
==================================

As mentioned in [???](#filesch), many applications deal with data that
is *persistentpersistent* - meaning that the data lives longer than the
program by being stored on disk in files. You can shut down the program
and open it back up, and you are back where you started. Now, there are
two basic kinds of persistent data - structured and unstructured.
Unstructured dataunstructured data is like what we dealt with in the
`toupper` program. It just dealt with text files that were entered by a
person. The contents of the files weren\'t usable by a program because a
program can\'t interpret what the user is trying to say in random text.

Structured datastructured data, on the other hand, is what computers
excel at handling. Structured data is data that is divided up into
fieldsfields and recordsrecords. For the most part, the fields and
records are fixed-length. Because the data is divided into fixed-length
records and fixed-format fields, the computer can interpret the data.
Structured data can contain variable-length fields, but at that point
you are usually better off with a databasedatabase. [^1]

This chapter deals with reading and writing simple fixed-length
recordsrecords. Let\'s say we wanted to store some basic information
about people we know. We could imagine the following example
fixed-length record about people:

-   Firstname - 40 bytes

-   Lastname - 40 bytes

-   Address - 240 bytes

-   Age - 4 bytes

In this, everything is character data except for the age, which is
simply a numeric field, using a standard 4-byte word (we could just use
a single byte for this, but keeping it at a word makes it easier to
process).

In programming, you often have certain definitions that you will use
over and over again within the program, or perhaps within several
programs. It is good to separate these out into files that are simply
included into the assembly language files as needed. For example, in our
next programs we will need to access the different parts of the record
above. This means we need to know the offsetsoffsets of each field from
the beginning of the record in order to access them using base pointer
addressingbase pointer addressing mode. The following constants describe
the offsets to the above structure. Put them in a file named
`record-def.s`:

    RECORD-DEF

In addition, there are several constants that we have been defining over
and over in our programs, and it is useful to put them in a file, so
that we don\'t have to keep entering them. Put the following
constantsconstants in a file called `linux.s`:

    LINUX

We will write three programs in this chapter using the structure defined
in `record-def.s`. The first program will build a file containing
several records as defined above. The second program will display the
records in the file. The third program will add 1 year to the age of
every record.

In addition to the standard constants we will be using throughout the
programs, there are also two functions that we will be using in several
of the programs - one which reads a record and one which writes a
record.

What parameters do these functions need in order to operate? We
basically need:

-   The location of a buffer that we can read a record into

-   The file descriptor that we want to read from or write to

Let\'s look at our reading function first:

    READ-RECORD

It\'s a pretty simple function. It just reads data the size of our
structure into an appropriately sized buffer from the given file
descriptor. The writing one is similar:

    WRITE-RECORD

Now that we have our basic definitions down, we are ready to write our
programs.

Writing Records
---------------

This program will simply write some hardcoded records to disk. It will:

-   Open the file

-   Write three records

-   Close the file

Type the following code into a file called `write-records.s`: .rept
.endr padding null

    WRITE-RECORDS

This is a fairly simple program. It merely consists of defining the data
we want to write in the `.data.data` section, and then calling the right
system calls and function calls to accomplish it. For a refresher of all
of the system calls used, see [???](#syscallap).

You may have noticed the lines:

        .include "linux.s"
        .include "record-def.s"

.include These statements cause the given files to basically be pasted
right there in the code. You don\'t need to do this with functions,
because the linkerlinker can take care of combining functions exported
with `.globl.globl`. However, constantsconstants defined in another file
do need to be imported in this way.

Also, you may have noticed the use of a new assembler directive,
`.rept.rept`. This directive repeats the contents of the file between
the `.rept` and the `.endr.endr` directives the number of times
specified after `.rept`. This is usually used the way we used it - to
padpad values in the `.data.data` section. In our case, we are adding
null charactersnull characters to the end of each field until they are
their defined lengths.

To build the application, run the commands:

    as write-records.s -o write-records.o
    as write-record.s -o write-record.o
    ld write-record.o write-records.o -o write-records

Here we are assembling two files separately, and then combining them
together using the linkerlinker. To run the program, just type the
following:

    ./write-records

This will cause a file called `test.dat` to be created containing the
records. However, since they contain non-printable characters (the null
character, specifically), they may not be viewable by a text editor.
Therefore we need the next program to read them for us.

Reading Records
---------------

Now we will consider the process of reading records. In this program, we
will read each record and display the first name listed with each
record.

Since each person\'s name is a different length, we will need a function
to count the number of characters we want to write. Since we pad each
field with null charactersnull characters, we can simply count
characters until we reach a null character.[^2] Note that this means our
records must contain at least one null character each.

Here is the code. Put it in a file called `count-chars.s`:

    COUNT-CHARS

As you can see, it\'s a fairly straightforward function. It simply loops
through the bytes, counting as it goes, until it hits a null character.
Then it returns the count.

Our record-reading program will be fairly straightforward, too. It will
do the following:

-   Open the file

-   Attempt to read a record

-   If we are at the end of the file, exit

-   Otherwise, count the characters of the first name

-   Write the first name to `STDOUT`

-   Write a newline to `STDOUT`

-   Go back to read another record

To write this, we need one more simple function - a function to write
out a newline to `STDOUT`. Put the following code into
`write-newline.s`:

    WRITE-NEWLINE-S

Now we are ready to write the main program. Here is the code to
`read-records.s`:

    READ-RECORDS

To build this program, we need to assemble all of the parts and link
them together:

    as read-record.s -o read-record.o
    as count-chars.s -o count-chars.o
    as write-newline.s -o write-newline.o
    as read-records.s -o read-records.o
    ld read-record.o count-chars.o write-newline.o \
       read-records.o -o read-records

The backslash in the first line simply means that the command continues
on the next line. You can run your program by doing `./read-records`.

As you can see, this program opens the file and then runs a loop of
reading, checking for the end of file, and writing the firstname. The
one construct that might be new is the line that says:

        pushl  $RECORD_FIRSTNAME + record_buffer

It looks like we are combining and add instruction with a push
instruction, but we are not. You see, both `RECORD_FIRSTNAME` and
`record_buffer` are constantsconstants. The first is a direct constant,
created through the use of a `.equ.equ` directive, while the latter is
defined automatically by the assemblerassembler through its use as a
label (it\'s value being the addressaddress that the data that follows
it will start at). Since they are both constants that the assembler
knows, it is able to add them together while it is assembling your
program, so the whole instruction is a single immediate-modeimmediate
mode addressing push of a single constant.

The `RECORD_FIRSTNAME` constantconstants is the number of bytes after
the beginning of a record before we hit the first name. `record_buffer`
is the name of our buffer for holding records. Adding them together gets
us the address of the first name member of the record stored in
`record_buffer`.

Modifying the Records
---------------------

In this section, we will write a program that:

-   Opens an input and output file

-   Reads records from the input

-   Increments the age

-   Writes the new record to the output file

Like most programs we\'ve encountered recently, this program is pretty
straightforward.[^3]

    ADD-YEAR

You can type it in as `add-year.s`. To build it, type the following[^4]:

    as add-year.s -o add-year.o
    ld add-year.o read-record.o write-record.o -o add-year

To run the program, just type in the following[^5]:

    ./add-year

This will add a year to every record listed in `test.dat` and write the
new records to the file `testout.dat`.

As you can see, writing fixed-length records is pretty simple. You only
have to read in blocks of data to a buffer, process them, and write them
back out. Unfortunately, this program doesn\'t write the new ages out to
the screen so you can verify your program\'s effectiveness. This is
because we won\'t get to displaying numbers until [???](#linking) and
[???](#countingchapter). After reading those you may want to come back
and rewrite this program to display the numeric data that we are
modifying.

Review
------

### Know the Concepts

-   What is a record?

-   What is the advantage of fixed-length records over variable-length
    records?

-   How do you include constants in multiple assembly source files?

-   Why might you want to split up a project into multiple source files?

-   What does the instruction `incl record_buffer + RECORD_AGE` do? What
    addressing mode is it using? How many operands does the `incl`
    instructions have in this case? Which parts are being handled by the
    assembler and which parts are being handled when the program is run?

### Use the Concepts

-   Add another data member to the person structure defined in this
    chapter, and rewrite the reading and writing functions and programs
    to take them into account. Remember to reassemble and relink your
    files before running your programs.

-   Create a program that uses a loop to write 30 identical records to a
    file.

-   Create a program to find the largest age in the file and return that
    age as the status code of the program.

-   Create a program to find the smallest age in the file and return
    that age as the status code of the program.

### Going Further

-   Rewrite the programs in this chapter to use command-line arguments
    to specify the filesnames.

-   Research the `lseek` system call. Rewrite the `add-year` program to
    open the source file for both reading and writing (use \$2 for the
    read/write mode), and write the modified records back to the same
    file they were read from.

-   Research the various error codes that can be returned by the system
    calls made in these programs. Pick one to rewrite, and add code that
    checks EAX-INDEXED for error conditions, and, if one is found,
    writes a message about it to `STDERR` and exit.

-   Write a program that will add a single record to the file by reading
    the data from the keyboard. Remember, you will have to make sure
    that the data has at least one null character at the end, and you
    need to have a way for the user to indicate they are done typing.
    Because we have not gotten into characters to numbers conversion,
    you will not be able to read the age in from the keyboard, so
    you\'ll have to have a default age.

-   Write a function called `compare-strings` that will compare two
    strings up to 5 characters. Then write a program that allows the
    user to enter 5 characters, and have the program return all records
    whose first name starts with those 5 characters.

[^1]: A database is a program which handles persistent structured data
    for you. You don\'t have to write the programs to read and write the
    data to disk, to do lookups, or even to do basic processing. It is a
    very high-level interface to structured data which, although it adds
    some overhead and additional complexity, is very useful for complex
    data processing tasks. References for learning how databases work
    are listed in [???](#wherenextch).

[^2]: If you have used C, this is what the `strlenstrlen` function does.

[^3]: You will find that after learning the mechanics of programming,
    most programs are pretty straightforward once you know exactly what
    it is you want to do. Most of them initialize data, do some
    processing in a loop, and then clean everything up.

[^4]: This assumes that you have already built the object files
    `read-record.o` and `write-record.o` in the previous examples. If
    not, you will have to do so.

[^5]: This is assuming you created the file in a previous run of
    `write-records`. If not, you need to run `write-records` first
    before running this program.
