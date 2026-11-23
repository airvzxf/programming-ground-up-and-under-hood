#!/usr/bin/env bash
# Run the example programs that report their result through the exit status
# and compare it with the value the book explains. Run make.bash first.
set -Eeuo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

FAILED=0
expect() {
  local program="$1" expected="$2" status=0
  "./${program}-bin" >/dev/null 2>&1 || status=$?
  if [[ "${status}" == "${expected}" ]]; then
    echo "ok   ${program}: ${status}"
  else
    echo "FAIL ${program}: expected ${expected}, got ${status}"
    FAILED=1
  fi
}

expect 003-01-exit 0
expect 003-02-maximum 222
expect 004-01-power 33
expect 004-02-factorial 24
expect 0AK-01-exit-3 3
expect 0AK-02-minimum 3
expect 0AK-03-maximum-255 125
expect 0AK-04-maximum-end-address 222
expect 0AK-05-maximum-length 222
# Without `int $0x80` the CPU runs past the code: SIGSEGV is 128 + 11.
expect 0AK-06-exit-without-int 139

exit "${FAILED}"
