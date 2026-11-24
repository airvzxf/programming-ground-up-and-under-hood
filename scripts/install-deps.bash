#!/usr/bin/env bash
# Install the tools needed to build the book and the assembly examples.
#
# Used by the Dockerfile and by the GitHub Actions workflow so both build
# with exactly the same versions. Quarto (which includes Pandoc and Typst)
# comes from its official GitHub release and is verified by SHA-256.
#
# Usage: sudo bash scripts/install-deps.bash   (Debian/Ubuntu, amd64)
set -Eeuo pipefail

QUARTO_VERSION="1.11.9"
QUARTO_SHA256="9d037baa3b38ffac7217edca1d2e53760b0fab4d5749220740a32056e03a1530"
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

# Quarto bundles its own Pandoc and Typst.
QUARTO_TGZ="${TMP_DIR}/quarto.tar.gz"
download \
  "https://github.com/quarto-dev/quarto-cli/releases/download/v${QUARTO_VERSION}/quarto-${QUARTO_VERSION}-linux-amd64.tar.gz" \
  "${QUARTO_SHA256}" "${QUARTO_TGZ}"
rm -rf /opt/quarto
mkdir -p /opt/quarto
tar -xzf "${QUARTO_TGZ}" -C /opt/quarto --strip-components=1
ln -sf /opt/quarto/bin/quarto "${PREFIX}/bin/quarto"

quarto --version
quarto pandoc --version | head -n 1
quarto typst --version
