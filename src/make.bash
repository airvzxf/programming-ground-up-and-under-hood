#!/usr/bin/env bash
# Build every edition of the book with Quarto (see _quarto.yml).
#
#   release/latest/
#     site/                    -> website (one page per chapter, search,
#                                 PDF and ePUB downloads), for Cloudflare
#     ProgrammingGroundUp.pdf  -> PDF (Typst)
#     ProgrammingGroundUp.epub -> ePUB
#     resource.zip             -> source code of the examples
#   release/<version>/         -> a copy of release/latest/
#
# Requires Quarto (see scripts/install-deps.bash or the Dockerfile).
set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "${SCRIPT_DIR}"

for tool in quarto; do
  command -v "${tool}" >/dev/null || {
    echo "error: '${tool}' is not installed (see scripts/install-deps.bash)" >&2
    exit 1
  }
done

DATE="${BOOK_DATE:-$(date "+%Y-%m-%d")}"
VERSION="v${DATE//-/.}"
NAME="ProgrammingGroundUp"
RELEASE_ROOT_PATH="${SCRIPT_DIR}/../release"
RELEASE_LATEST_PATH="${RELEASE_ROOT_PATH}/latest"
RELEASE_VERSION_PATH="${RELEASE_ROOT_PATH}/${VERSION}"
SITE_PATH="${RELEASE_LATEST_PATH}/site"

rm -rf "${RELEASE_LATEST_PATH}" "${RELEASE_VERSION_PATH}"
mkdir -p "${RELEASE_LATEST_PATH}"

echo "==> Quarto (HTML, PDF and ePUB)"
rm -rf _book
quarto render --metadata "date:${DATE}"
mv _book "${SITE_PATH}"

echo "==> Downloads"
# Only the example sources (no build artifacts). `zip` may be missing (for
# example on Cloudflare Pages); Python can do it too.
SOURCES=(resource/asm/*.s resource/asm/*.c resource/asm/*.py
         resource/asm/*.pl resource/asm/*.bash resource/asm/*.md)
if command -v zip >/dev/null; then
  zip -q -9 -D -j "${RELEASE_LATEST_PATH}/resource.zip" "${SOURCES[@]}"
else
  python3 -m zipfile -c "${RELEASE_LATEST_PATH}/resource.zip" "${SOURCES[@]}"
fi
cp "${RELEASE_LATEST_PATH}/resource.zip" "${SITE_PATH}/"
cp "${SITE_PATH}/${NAME}".{pdf,epub} "${RELEASE_LATEST_PATH}/"
cp resource/site/_headers "${SITE_PATH}/_headers"

cp -R "${RELEASE_LATEST_PATH}" "${RELEASE_VERSION_PATH}"

echo "Build completed: ${RELEASE_LATEST_PATH}"
