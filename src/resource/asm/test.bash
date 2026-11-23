#!/usr/bin/env bash
# Run the example programs and the solutions of Appendix K, and compare
# their exit status, output and files with the values the book explains.
# Run make.bash first.
set -Eeuo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

FAILED=0
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "${TMP_DIR}"' EXIT

pass() { echo "ok   $1"; }
fail() { echo "FAIL $1"; FAILED=1; }

# expect <program> <exit status> [stdin]
expect() {
  local program="$1" expected="$2" input="${3:-}" status=0
  printf '%s' "${input}" | "./${program}-bin" >/dev/null 2>&1 \
    || status=$?
  if [[ "${status}" == "${expected}" ]]; then
    pass "${program}: status ${status}"
  else
    fail "${program}: expected status ${expected}, got ${status}"
  fi
}

# expect_output <name> <expected stdout> <command...>   (reads $INPUT)
expect_output() {
  local name="$1" expected="$2" actual
  shift 2
  actual="$(printf '%s' "${INPUT:-}" | "$@" 2>/dev/null)" || true
  if [[ "${actual}" == "${expected}" ]]; then
    pass "${name}: output"
  else
    fail "${name}: expected output '${expected}', got '${actual}'"
  fi
}

# expect_file <name> <file> <expected content>
expect_file() {
  if [[ "$(cat "$2" 2>/dev/null)" == "$3" ]]; then
    pass "$1: file $2"
  else
    fail "$1: unexpected content in $2"
  fi
}

# ----- Book examples -----
expect 003-01-exit 0
expect 003-02-maximum 222
expect 004-01-power 33
expect 004-02-factorial 24

# ----- Chapter 3 -----
expect 0AK-03-01-exit-3 3
expect 0AK-03-02-minimum 3
expect 0AK-03-03-maximum-255 125
expect 0AK-03-04-maximum-end-address 222
expect 0AK-03-05-maximum-length 222
# Without `int $0x80` the CPU runs past the code: SIGSEGV is 128 + 11.
expect 0AK-03-06-exit-without-int 139

# ----- Chapter 4 -----
expect 0AK-04-01-square 144
expect 0AK-04-02-maximum-function 99
expect 0AK-04-03-factorial-loop 120
expect 0AK-04-04-power-registers 33

# ----- Chapter 5 -----
INPUT="Hey, diddle 123!" expect_output 0AK-05-01-toupper-stdio \
  "HEY, DIDDLE 123!" ./0AK-05-01-toupper-stdio-bin
printf 'The cow jumped over the moon; the little dog laughed.\n' \
  > "${TMP_DIR}/in.txt"
./0AK-05-02-toupper-bss-bin "${TMP_DIR}/in.txt" "${TMP_DIR}/out.txt"
expect_file 0AK-05-02-toupper-bss "${TMP_DIR}/out.txt" \
  "THE COW JUMPED OVER THE MOON; THE LITTLE DOG LAUGHED."
(cd "${TMP_DIR}" && "${OLDPWD}/0AK-05-03-heynow-bin")
expect_file 0AK-05-03-heynow "${TMP_DIR}/heynow.txt" "Hey diddle diddle!"
INPUT="abc" expect_output 0AK-05-04-toupper-checked "ABC" \
  ./0AK-05-04-toupper-checked-bin
./0AK-05-04-toupper-checked-bin "${TMP_DIR}/in.txt" "${TMP_DIR}/out2.txt"
expect_file 0AK-05-04-toupper-checked "${TMP_DIR}/out2.txt" \
  "THE COW JUMPED OVER THE MOON; THE LITTLE DOG LAUGHED."
expect_output "0AK-05-04-toupper-checked (missing file)" \
  "Error: can't open input file" \
  sh -c "./0AK-05-04-toupper-checked-bin /no/such/file x 2>&1"
expect_output "0AK-05-04-toupper-checked (one argument)" \
  "Usage: toupper [input output]" \
  sh -c "./0AK-05-04-toupper-checked-bin only-one 2>&1"

# ----- Chapter 6 -----
(
  cd "${TMP_DIR}"
  A="${OLDPWD}"
  "${A}/006-01-write-records-bin"          # Creates test.dat.
  "${A}/0AK-06-01-write-records-bin"       # test-phone.dat.
  "${A}/0AK-06-02-write-30-records-bin"    # test30.dat.
)
INPUT="" expect_output 0AK-06-01-read-records \
  "$(printf 'Fredrick: 555-0100\nMarilyn: 555-0199')" \
  sh -c "cd '${TMP_DIR}' && '${PWD}/0AK-06-01-read-records-bin'"
if [[ "$(stat -c %s "${TMP_DIR}/test-phone.dat")" == 688 ]]; then
  pass "0AK-06-01-write-records: 2 records of 344 bytes"
else
  fail "0AK-06-01-write-records: wrong file size"
fi
if [[ "$(stat -c %s "${TMP_DIR}/test30.dat")" == 9720 ]]; then
  pass "0AK-06-02-write-30-records: 30 records of 324 bytes"
else
  fail "0AK-06-02-write-30-records: wrong file size"
fi
in_tmp() { (cd "${TMP_DIR}" && "${OLDPWD}/$1-bin"); }
status_in_tmp() {
  local status=0
  in_tmp "$1" >/dev/null 2>&1 || status=$?
  if [[ "${status}" == "$2" ]]; then pass "$1: status ${status} $3"
  else fail "$1: expected status $2, got ${status} $3"; fi
}
status_in_tmp 0AK-06-03-max-age 45 "(ages 45, 29, 36)"
status_in_tmp 0AK-06-04-min-age 29 "(ages 45, 29, 36)"
in_tmp 0AK-06-05-add-year-in-place
status_in_tmp 0AK-06-03-max-age 46 "(after add-year-in-place)"
status_in_tmp 0AK-06-04-min-age 30 "(after add-year-in-place)"
if [[ "$(stat -c %s "${TMP_DIR}/test.dat")" == 972 ]]; then
  pass "0AK-06-05-add-year-in-place: file size unchanged"
else
  fail "0AK-06-05-add-year-in-place: file size changed"
fi
INPUT="Mar" expect_output 0AK-06-07-find-records "Marilyn" \
  sh -c "cd '${TMP_DIR}' && '${PWD}/0AK-06-07-find-records-bin'"
INPUT="Fredrickson" expect_output "0AK-06-07-find-records (5 chars)" \
  "Fredrick" \
  sh -c "cd '${TMP_DIR}' && '${PWD}/0AK-06-07-find-records-bin'"
INPUT="Zed" expect_output "0AK-06-07-find-records (no match)" "" \
  sh -c "cd '${TMP_DIR}' && '${PWD}/0AK-06-07-find-records-bin'"

# ----- Chapter 7 -----
# Ages of the three records in a record file, one per line.
ages() {
  local offset
  for offset in 320 644 968; do
    od -A n -t d4 -j "${offset}" -N 4 "$1" | tr -d ' '
  done
}
C7="${TMP_DIR}/c7"
mkdir -p "${C7}"
(cd "${C7}" && "${OLDPWD}/006-01-write-records-bin")
(cd "${C7}" && "${OLDPWD}/0AK-07-01-add-year-robust-bin")
if [[ "$(ages "${C7}/testout.dat" | paste -sd ' ')" == "46 30 37" ]]; then
  pass "0AK-07-01-add-year-robust: ages 46 30 37"
else
  fail "0AK-07-01-add-year-robust: wrong ages"
fi
mv "${C7}/test.dat" "${C7}/input.dat"
rm "${C7}/testout.dat"
MESSAGE="$(cd "${C7}" && "${OLDPWD}/0AK-07-01-add-year-robust-bin" \
  < input.dat 2>&1)"
if [[ "${MESSAGE}" == "Warning: can't open test.dat, reading STDIN" \
   && "$(ages "${C7}/testout.dat" | paste -sd ' ')" == "46 30 37" ]]; then
  pass "0AK-07-01-add-year-robust: recovery from STDIN"
else
  fail "0AK-07-01-add-year-robust: recovery from STDIN"
fi
head -c 100 "${C7}/input.dat" > "${C7}/test.dat"  # Damaged file.
expect_output "0AK-07-01-add-year-robust (damaged file)" \
  "0004: Incomplete Record." \
  sh -c "cd '${C7}' && '${PWD}/0AK-07-01-add-year-robust-bin' 2>&1"
rm "${C7}/testout.dat"
mkdir "${C7}/testout.dat"  # A directory can't be opened for writing.
expect_output "0AK-07-01-add-year-robust (output error)" \
  "0002: Can't Open Output File." \
  sh -c "cd '${C7}' && '${PWD}/0AK-07-01-add-year-robust-bin' 2>&1"

# ----- Chapter 8 -----
expect_output 0AK-08-02-factorial-printf "The factorial of 5 is 120." \
  env LD_LIBRARY_PATH=. ./0AK-08-02-factorial-printf-bin
./0AK-08-03-toupper-libc-bin "${TMP_DIR}/in.txt" "${TMP_DIR}/out3.txt"
expect_file 0AK-08-03-toupper-libc "${TMP_DIR}/out3.txt" \
  "THE COW JUMPED OVER THE MOON; THE LITTLE DOG LAUGHED."
expect_output "0AK-08-03-toupper-libc (missing file)" \
  "Error: can't open the files" \
  ./0AK-08-03-toupper-libc-bin /no/such/file "${TMP_DIR}/x"
# Through a pipe, stdout is fully buffered and this `exit` doesn't flush
# it, so only the message remains: the text of printf is lost.
expect_output 0AK-08-04-exit-message "exit() called: bye!" \
  sh -c "LD_PRELOAD=./libexitmsg.so ./008-02-printf-example-bin 2>&1"
expect_output "008-02-printf-example (without LD_PRELOAD)" \
  "Hi! Jonathan is the person number #3." ./008-02-printf-example-bin

# ----- Chapter 9 -----
expect 0AK-09-02-alloc-test 0
# The book's manager reuses memory but doesn't split regions (4).
expect 0AK-09-02-alloc-test-book 4
expect 0AK-09-03-alloc-auto-init 42

# ----- Chapter 10 -----
expect_output 0AK-10-02-print-numbers \
  "$(printf '120\n3628800\n377\nff\n11111111\n73')" \
  ./0AK-10-02-print-numbers-bin
expect 0AK-10-03-is-negative 100
for CASE in "1234:1234" "-56:-56" "007:7" "0:0" "42abc:42" \
            "2147483647:2147483647" "-2147483648:-2147483648"; do
  INPUT="${CASE%%:*}"$'\n' expect_output \
    "0AK-10-04-number2integer (${CASE%%:*})" "${CASE#*:}" \
    ./0AK-10-04-number2integer-bin
done
expect 0AK-10-05-likes 21

# ----- Chapter 11 -----
expect 0AK-11-01-maximum-c 222
if command -v python3 >/dev/null; then
  STATUS=0
  python3 0AK-11-01-maximum.py || STATUS=$?
  if [[ "${STATUS}" == 222 ]]; then pass "0AK-11-01-maximum.py: status 222"
  else fail "0AK-11-01-maximum.py: expected status 222, got ${STATUS}"; fi
fi


exit "${FAILED}"
