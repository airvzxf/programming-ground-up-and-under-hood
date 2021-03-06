#!/bin/bash -e

rm -f ./*.o
rm -f ./*-bin
rm -f librecord.so .gdb_history

# -----------------------------------------------------
# Compile all the files.
# -----------------------------------------------------

FILES=(
  003-01-exit
  003-02-maximum
  004-01-power
  004-02-factorial
  005-01-toupper
  006-01-add-year
  006-01-count-chars
  006-01-read-record
  006-01-read-records
  006-01-write-newline
  006-01-write-record
  006-01-write-records
  007-01-error-exit
  007-01-add-year
  008-01-hello-world-lib
  008-01-hello-world-nolib
  008-02-printf-example
  009-01-memory-layout
  009-02-alloc
  009-02-read-records
  010-01-shift-bit
  010-02-conversion-program
  010-02-integer-to-string
  0AA-01-gnome-example
)

for FILE in "${FILES[@]}"
do
    echo "Assembling: ${FILE}"
    as -o "${FILE}".o   "${FILE}".s  --32 --gstabs+
done

echo""

# -----------------------------------------------------
# Link the gneric files.
# -----------------------------------------------------

FILES=(
  003-01-exit
  003-02-maximum
  004-01-power
  004-02-factorial
  005-01-toupper
  008-01-hello-world-nolib
  009-01-memory-layout
  010-01-shift-bit
)

for FILE in "${FILES[@]}"
do
    echo "Linking #1: ${FILE}"
    ld -o "${FILE}"-bin "${FILE}".o  -m elf_i386
done

echo""

# -----------------------------------------------------
# Linked special files.
# -----------------------------------------------------

echo "Linking #2: 006-01-write-records"
ld -o "006-01-write-records"-bin  -m elf_i386 \
                                  "006-01-write-record".o \
                                  "006-01-write-records".o

echo "Linking #2: 006-01-read-records"
ld -o "006-01-read-records"-bin  -m elf_i386 \
                                  "006-01-count-chars".o \
                                  "006-01-read-record".o \
                                  "006-01-read-records".o \
                                  "006-01-write-newline".o

echo "Linking #2: 006-01-add-year"
ld -o "006-01-add-year"-bin  -m elf_i386 \
                             "006-01-add-year".o \
                             "006-01-read-record".o \
                             "006-01-write-record".o

echo "Linking #2: 007-01-add-year"
ld -o "007-01-add-year"-bin  -m elf_i386 \
                             "006-01-count-chars".o \
                             "006-01-read-record".o \
                             "006-01-write-newline".o \
                             "006-01-write-record".o \
                             "007-01-add-year".o \
                             "007-01-error-exit".o

echo "Linking #2: 008-01-hello-world-lib"
ld -o "008-01-hello-world-lib"-bin  -m elf_i386 \
                                   "008-01-hello-world-lib".o \
                                   --library        c \
                                   --library-path   /usr/lib32/ \
                                   -dynamic-linker  /usr/lib32/ld-linux.so.2

echo "Linking #2: 008-02-printf-example"
ld -o "008-02-printf-example"-bin  -m elf_i386 \
                                   "008-02-printf-example".o \
                                   --library        c \
                                   --library-path   /usr/lib32/ \
                                   -dynamic-linker  /usr/lib32/ld-linux.so.2

echo "Linking #2: librecord.so"
ld -o "librecord.so"  -m elf_i386 \
                      -shared \
                      "006-01-read-record".o \
                      "006-01-write-record".o

echo "Linking #2: 008-03-write-records"
ld -o "008-03-write-records"-bin  -m elf_i386 \
                                  "006-01-write-records".o \
                                  --library        record \
                                  --library-path   . \
                                  -dynamic-linker  /usr/lib32/ld-linux.so.2

echo "Linking #2: 009-02-read-records"
ld -o "009-02-read-records"-bin  -m elf_i386 \
                                 "006-01-count-chars".o \
                                 "006-01-read-record".o \
                                 "006-01-write-newline".o \
                                 "009-02-alloc".o \
                                 "009-02-read-records".o

echo "Linking #2: 010-02-conversion-program"
ld -o "010-02-conversion-program"-bin  -m elf_i386 \
                                       "006-01-count-chars".o \
                                       "006-01-write-newline".o \
                                       "010-02-conversion-program".o \
                                       "010-02-integer-to-string".o

echo ""

echo "Linking #3: 011-01-hello-world-c"
gcc -o "011-01-hello-world-c"-bin  "011-01-hello-world".c

#echo "Linking #3: 0AA-01-gnome-example"
#gcc -o "0AA-01-gnome-example"-bin  -m32 \
#                                   `gnome-config --libs gnomeui` \
#                                   "0AA-01-gnome-example".o

#echo "Linking #3: 0AA-01-gnome-example-c"
#gcc -o "0AA-01-gnome-example-c"-bin  `gnome-config --cflags --libs gnomeui` \
#                                     "0AA-01-gnome-example-c".c
