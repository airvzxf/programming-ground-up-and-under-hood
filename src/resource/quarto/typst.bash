#!/usr/bin/env bash
# Runs the Typst bundled with Quarto, adding `--no-pdf-tags` to
# `typst compile`. make.bash points QUARTO_TYPST here.
#
# Typst writes a tagged (accessible) PDF by default. The syntax
# highlighting gives every token of a code listing its own tag, which made
# the PDF about 6.9 MB instead of about 1.4 MB. Quarto has no option for
# this flag, so it is added here.
set -Eeuo pipefail

QUARTO_BIN="$(dirname "$(readlink -f "$(command -v quarto)")")"
TYPST="${QUARTO_BIN}/tools/$(uname -m)/typst"
[[ -x "${TYPST}" ]] || TYPST="${QUARTO_BIN}/tools/typst"

if [[ "${1:-}" == "compile" ]]; then
  shift
  exec "${TYPST}" compile --no-pdf-tags "$@"
fi
exec "${TYPST}" "$@"
