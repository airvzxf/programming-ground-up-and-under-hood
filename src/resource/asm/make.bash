#!/usr/bin/env bash
set -Eeuo pipefail

# Get script directory to handle relative paths correctly
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "${SCRIPT_DIR}"

# Clean up previous files
rm -f ./*.o
rm -f ./*-bin
rm -f librecord.so libfactorial.so libexitmsg.so .gdb_history heynow.txt

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
    as -o "${FILE}.o" "${FILE}.s" --32 --gstabs+
done

echo ""

# -----------------------------------------------------
# Link the generic files.
# -----------------------------------------------------

GENERIC_FILES=(
  003-01-exit
  003-02-maximum
  004-01-power
  004-02-factorial
  005-01-toupper
  008-01-hello-world-nolib
  009-01-memory-layout
  010-01-shift-bit
)

for FILE in "${GENERIC_FILES[@]}"
do
    echo "Linking #1: ${FILE}"
    ld -o "${FILE}-bin" "${FILE}.o" -m elf_i386
done

echo ""

# -----------------------------------------------------
# Linked special files.
# -----------------------------------------------------

echo "Linking #2: 006-01-write-records"
ld -o "006-01-write-records-bin" -m elf_i386 \
  "006-01-write-record.o" \
  "006-01-write-records.o"

echo "Linking #2: 006-01-read-records"
ld -o "006-01-read-records-bin" -m elf_i386 \
  "006-01-count-chars.o" \
  "006-01-read-record.o" \
  "006-01-read-records.o" \
  "006-01-write-newline.o"

echo "Linking #2: 006-01-add-year"
ld -o "006-01-add-year-bin" -m elf_i386 \
  "006-01-add-year.o" \
  "006-01-read-record.o" \
  "006-01-write-record.o"

echo "Linking #2: 007-01-add-year"
ld -o "007-01-add-year-bin" -m elf_i386 \
  "006-01-count-chars.o" \
  "006-01-read-record.o" \
  "006-01-write-newline.o" \
  "006-01-write-record.o" \
  "007-01-add-year.o" \
  "007-01-error-exit.o"

echo "Linking #2: 008-01-hello-world-lib"
ld -o "008-01-hello-world-lib-bin" -m elf_i386 \
  "008-01-hello-world-lib.o" \
  --library c \
  --library-path /usr/lib32/ \
  -dynamic-linker /usr/lib32/ld-linux.so.2

echo "Linking #2: 008-02-printf-example"
ld -o "008-02-printf-example-bin" -m elf_i386 \
  "008-02-printf-example.o" \
  --library c \
  --library-path /usr/lib32/ \
  -dynamic-linker /usr/lib32/ld-linux.so.2

echo "Linking #2: librecord.so"
ld -o "librecord.so" -m elf_i386 \
  -shared \
  "006-01-read-record.o" \
  "006-01-write-record.o"

echo "Linking #2: 008-03-write-records"
ld -o "008-03-write-records-bin" -m elf_i386 \
  "006-01-write-records.o" \
  --library record \
  --library-path . \
  -dynamic-linker /usr/lib32/ld-linux.so.2

echo "Linking #2: 009-02-read-records"
ld -o "009-02-read-records-bin" -m elf_i386 \
  "006-01-count-chars.o" \
  "006-01-read-record.o" \
  "006-01-write-newline.o" \
  "009-02-alloc.o" \
  "009-02-read-records.o"

echo "Linking #2: 010-02-conversion-program"
ld -o "010-02-conversion-program-bin" -m elf_i386 \
  "006-01-count-chars.o" \
  "006-01-write-newline.o" \
  "010-02-conversion-program.o" \
  "010-02-integer-to-string.o"

echo ""

echo "Linking #3: 011-01-hello-world-c"
gcc -o "011-01-hello-world-c-bin" "011-01-hello-world.c"

# -----------------------------------------------------
# Solutions to the review questions (Appendix K).
# -----------------------------------------------------

for SOURCE in 0AK-*.s
do
    echo "Assembling: ${SOURCE%.s}"
    as -o "${SOURCE%.s}.o" "${SOURCE}" --32 --gstabs+
done

# Link a solution: link_solution <program> [extra objects/options...]
link_solution() {
    local PROGRAM="$1"
    shift
    echo "Linking #4: ${PROGRAM}"
    ld -o "${PROGRAM}-bin" -m elf_i386 "${PROGRAM}.o" "$@"
}

LIBC=(--library c --library-path /usr/lib32/
      -dynamic-linker /usr/lib32/ld-linux.so.2)

for SOURCE in 0AK-03-*.s 0AK-04-*.s 0AK-05-03-*.s
do
    link_solution "${SOURCE%.s}"
done

link_solution 0AK-05-01-toupper-stdio 0AK-05-00-convert-to-upper.o
link_solution 0AK-05-02-toupper-bss 0AK-05-00-convert-to-upper.o
link_solution 0AK-05-04-toupper-checked \
  0AK-05-00-convert-to-upper.o 006-01-count-chars.o

link_solution 0AK-06-01-write-records 0AK-06-01-record-io.o
link_solution 0AK-06-01-read-records 0AK-06-01-record-io.o \
  006-01-count-chars.o 006-01-write-newline.o
link_solution 0AK-06-02-write-30-records 006-01-write-record.o
link_solution 0AK-06-03-max-age 006-01-read-record.o
link_solution 0AK-06-04-min-age 006-01-read-record.o
link_solution 0AK-06-05-add-year-in-place \
  006-01-read-record.o 006-01-write-record.o
link_solution 0AK-06-07-find-records 0AK-06-06-compare-strings.o \
  006-01-read-record.o 006-01-count-chars.o 006-01-write-newline.o

link_solution 0AK-07-01-add-year-robust \
  006-01-read-record.o 006-01-write-record.o 007-01-error-exit.o \
  006-01-count-chars.o 006-01-write-newline.o

echo "Linking #4: libfactorial.so"
ld -shared -m elf_i386 -o libfactorial.so 0AK-08-01-factorial-lib.o
link_solution 0AK-08-02-factorial-printf \
  --library-path . --library factorial "${LIBC[@]}"
link_solution 0AK-08-03-toupper-libc 0AK-05-00-convert-to-upper.o \
  "${LIBC[@]}"
echo "Linking #4: libexitmsg.so"
ld -shared -m elf_i386 -o libexitmsg.so 0AK-08-04-exit-message.o

link_solution 0AK-09-02-alloc-test 0AK-09-01-alloc.o
echo "Linking #4: 0AK-09-02-alloc-test-book (with 009-02-alloc.o)"
ld -o 0AK-09-02-alloc-test-book-bin -m elf_i386 \
  0AK-09-02-alloc-test.o 009-02-alloc.o
link_solution 0AK-09-03-alloc-auto-init 0AK-09-01-alloc.o

link_solution 0AK-10-02-print-numbers 0AK-10-01-integer2string-base.o \
  0AK-08-01-factorial-lib.o 006-01-write-newline.o
link_solution 0AK-10-03-is-negative
link_solution 0AK-10-04-number2integer \
  0AK-10-01-integer2string-base.o 006-01-write-newline.o
link_solution 0AK-10-05-likes

echo "Linking #4: 0AK-11-01-maximum-c"
gcc -o 0AK-11-01-maximum-c-bin 0AK-11-01-maximum.c


echo ""

echo "Example compilation completed."