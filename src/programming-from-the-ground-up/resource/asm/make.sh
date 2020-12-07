#!/bin/bash -e

rm -f ./*.o
rm -f ./*-bin

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
  006-01-read-record 006-01-read-records
  006-01-write-newline
  006-01-write-record 006-01-write-records
)

for FILE in "${FILES[@]}"
do
    echo "Assembling: ${FILE}"
    as -o "${FILE}".o   "${FILE}".s  -gstabs+ --32
done

# -----------------------------------------------------
# Link the gneric files.
# -----------------------------------------------------

FILES=(
  003-01-exit
  003-02-maximum
  004-01-power
  004-02-factorial
  005-01-toupper
)

for FILE in "${FILES[@]}"
do
    echo "Linking: ${FILE}"
    ld -o "${FILE}"-bin "${FILE}".o  -m elf_i386
done

# -----------------------------------------------------
# Linked special files.
# -----------------------------------------------------

echo "Linking: 006-01-write-records"
ld -o "006-01-write-records"-bin  -m elf_i386 \
                                  "006-01-write-record".o \
                                  "006-01-write-records".o

echo "Linking: 006-01-read-records"
ld -o "006-01-read-records"-bin  -m elf_i386 \
                                  "006-01-count-chars".o \
                                  "006-01-read-record".o \
                                  "006-01-read-records".o \
                                  "006-01-write-newline".o

echo "Linking: 006-01-add-year"
ld -o "006-01-add-year"-bin  -m elf_i386 \
                                  "006-01-add-year".o \
                                  "006-01-read-record".o \
                                  "006-01-write-record".o
