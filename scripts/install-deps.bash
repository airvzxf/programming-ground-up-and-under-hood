#!/usr/bin/env bash
# Install the tools needed to build the book and the assembly examples.
#
# Used by the Dockerfile and by the GitHub Actions workflow so both build
# with exactly the same versions. Quarto (which includes Pandoc and Typst)
# comes from its official GitHub release and is verified by SHA-256.
#
# Usage:
#   sudo bash scripts/install-deps.bash         System packages (apt) and
#                                               Quarto in /opt/quarto.
#   bash scripts/install-deps.bash --user       Only Quarto, in
#                                               ~/.local/quarto, without
#                                               root (used by Cloudflare
#                                               Pages).
# Linux amd64; the system mode needs Debian or Ubuntu.
set -Eeuo pipefail

USER_MODE=0
if [[ "${1:-}" == "--user" ]]; then
  USER_MODE=1
fi

QUARTO_VERSION="1.11.9"
QUARTO_SHA256="9d037baa3b38ffac7217edca1d2e53760b0fab4d5749220740a32056e03a1530"
if [[ "${USER_MODE}" == 1 ]]; then
  PREFIX="${PREFIX:-${HOME}/.local}"
  QUARTO_DIR="${PREFIX}/quarto"
else
  PREFIX="${PREFIX:-/usr/local}"
  QUARTO_DIR="/opt/quarto"
fi
mkdir -p "${PREFIX}/bin"

if [[ "${USER_MODE}" == 0 ]]; then
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
fi

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
rm -rf "${QUARTO_DIR}"
mkdir -p "${QUARTO_DIR}"
tar -xzf "${QUARTO_TGZ}" -C "${QUARTO_DIR}" --strip-components=1
ln -sf "${QUARTO_DIR}/bin/quarto" "${PREFIX}/bin/quarto"

"${PREFIX}/bin/quarto" --version
