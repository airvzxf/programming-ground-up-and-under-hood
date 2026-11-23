#!/usr/bin/env bash
# Install the tools needed to build the book and the assembly examples.
#
# Used by the Dockerfile and by the GitHub Actions workflow so both build
# with exactly the same versions. Pandoc and Typst come from their official
# GitHub releases (Ubuntu ships an old Pandoc) and are verified by SHA-256.
#
# Usage: sudo bash scripts/install-deps.bash   (Debian/Ubuntu, amd64)
set -Eeuo pipefail

PANDOC_VERSION="3.13"
PANDOC_SHA256="38aa33b325a2bc96a4c39409631212db55702f564250bcdbead180b3bf646389"
TYPST_VERSION="0.15.1"
TYPST_SHA256="a6d077d0a95eed5a2eba715b2dae06be954f624ccbf85758a03f389ded33118c"
PREFIX="${PREFIX:-/usr/local}"

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y --no-install-recommends \
  build-essential \
  ca-certificates \
  curl \
  gcc-multilib \
  xz-utils \
  zip
rm -rf /var/lib/apt/lists/*

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "${TMP_DIR}"' EXIT

download() {
  local url="$1" sha256="$2" output="$3"
  curl --fail --silent --show-error --location --output "${output}" "${url}"
  echo "${sha256}  ${output}" | sha256sum --check --strict -
}

PANDOC_TGZ="${TMP_DIR}/pandoc.tar.gz"
download \
  "https://github.com/jgm/pandoc/releases/download/${PANDOC_VERSION}/pandoc-${PANDOC_VERSION}-linux-amd64.tar.gz" \
  "${PANDOC_SHA256}" "${PANDOC_TGZ}"
tar -xzf "${PANDOC_TGZ}" -C "${TMP_DIR}"
install -m 0755 "${TMP_DIR}/pandoc-${PANDOC_VERSION}/bin/pandoc" "${PREFIX}/bin/pandoc"

TYPST_TXZ="${TMP_DIR}/typst.tar.xz"
download \
  "https://github.com/typst/typst/releases/download/v${TYPST_VERSION}/typst-x86_64-unknown-linux-musl.tar.xz" \
  "${TYPST_SHA256}" "${TYPST_TXZ}"
tar -xJf "${TYPST_TXZ}" -C "${TMP_DIR}"
install -m 0755 "${TMP_DIR}/typst-x86_64-unknown-linux-musl/typst" "${PREFIX}/bin/typst"

pandoc --version | head -n 1
typst --version
