Important System Calls {#syscallap}
======================

These are some of the more important system calls to use when dealing
with Linux. For most cases, however, it is best to use library functions
rather than direct system calls, because the system calls were designed
to be minimalistic while the library functions were designed to be easy
to program with. For information about the Linux C library, see the
manual at http://www.gnu.org/software/libc/manual/

Remember that EAX-INDEXED holds the system call numbers, and that the
return values and error codes are also stored in EAX. PERCENTeax
PERCENTebx PERCENTecx PERCENTedx

  -----------------------------------------------------------------------
  EAX
  -----------------------------------------------------------------------
  1

  3

  4

  5

  6

  12

  19

  20

  39

  40

  41

  42

  45

  54
  -----------------------------------------------------------------------

  : Important Linux System Calls

A more complete listing of system calls, along with additional
information is available at http://www.lxhp.in-berlin.de/lhpsyscal.html
You can also get more information about a system call by typing in
`man 2 SYSCALLNAME` which will return you the information about the
system call from section 2 of the UNIX manualUNIX manual. However, this
refers to the usage of the system call from the C programming languageC
programming language, and may or may not be directly helpful.

For information on how system callssystem calls are implemented on
Linux, see the Linux Kernel 2.4 Internals section on how system calls
are implemented at
http://www.faqs.org/docs/kernel_2\_4/lki-2.html\#ss2.11
