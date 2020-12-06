#!/bin/bash -e

rm -f ./*.o
rm -f ./*-bin

#as --statistics --warn -ag -L -o 01-exit.o 01-exit.s
#as --warn -al -L -o 01-exit.o 01-exit.s
#as -L -o 01-exit.o 01-exit.s

FILES=(
  003-01-exit
)

for FILE in "${FILES[@]}"
do
    echo "Assembling: ${FILE}"
    as -o "${FILE}".o   "${FILE}".s  -gstabs+
    ld -o "${FILE}"-bin "${FILE}".o
done
