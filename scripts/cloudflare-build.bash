#!/usr/bin/env bash
# Build command for Cloudflare Pages (Git integration).
#
# Cloudflare Pages settings:
#   Build command:          bash scripts/cloudflare-build.bash
#   Build output directory: release/latest/site
#   Root directory:         (empty)
#
# The Cloudflare build image has no root access, so Pandoc and Typst are
# installed in ~/.local/bin (same pinned, checksum-verified versions as CI).
set -Eeuo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

bash "${ROOT_DIR}/scripts/install-deps.bash" --user
export PATH="${HOME}/.local/bin:${PATH}"

bash "${ROOT_DIR}/src/make.bash"
