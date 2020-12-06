#!/bin/bash -e

rm -f ./*.o
rm -f ./*-bin

FILES=(
  003-01-exit 003-02-maximum 004-01-power 004-02-factorial 005-01-toupper
)

for FILE in "${FILES[@]}"
do
    echo "Assembling: ${FILE}"
    as -o "${FILE}".o   "${FILE}".s  -gstabs+ --32
    ld -o "${FILE}"-bin "${FILE}".o  -m elf_i386
done
