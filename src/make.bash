#!/usr/bin/env bash
# Build every edition of the book from book.md.
#
#   release/<version>/ and release/latest/
#     ProgrammingGroundUp.{pdf,epub,html,md}, resource/, resource.zip
#     site/  -> static website (index.html + downloads), deployed to Cloudflare
#
# Requires pandoc and typst (see scripts/install-deps.bash or the Dockerfile).
set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "${SCRIPT_DIR}"

for tool in pandoc typst zip; do
  command -v "${tool}" >/dev/null || {
    echo "error: '${tool}' is not installed (see scripts/install-deps.bash)" >&2
    exit 1
  }
done

DATE="${BOOK_DATE:-$(date "+%Y-%m-%d")}"
VERSION="v${DATE//-/.}"
NAME="ProgrammingGroundUp"
RELEASE_ROOT_PATH="../release"
RELEASE_VERSION_PATH="${RELEASE_ROOT_PATH}/${VERSION}"
RELEASE_LATEST_PATH="${RELEASE_ROOT_PATH}/latest"
TYPST_FILE="${SCRIPT_DIR}/${NAME}.typ"

trap 'rm -f "${TYPST_FILE}"' EXIT

rm -rf "${RELEASE_VERSION_PATH}" "${RELEASE_LATEST_PATH}"
mkdir -p "${RELEASE_VERSION_PATH}" "${RELEASE_LATEST_PATH}"

# Resources (examples, images) are shipped next to the book.
cp -R resource "${RELEASE_VERSION_PATH}/resource"
(cd "${RELEASE_VERSION_PATH}" && zip -q -r -9 -D resource.zip resource)

COMMON_ARGS=(
  --from markdown
  --standalone
  --metadata "date=${DATE}"
  --dpi 300
  --syntax-highlighting ./resource/pandoc/theme/default.theme
  --syntax-definition ./resource/pandoc/syntax/gnuassembler.xml
  --syntax-definition ./resource/pandoc/syntax/c.xml
  --syntax-definition ./resource/pandoc/syntax/bash.xml
  --lua-filter resource/pandoc/lua/include-code-files.lua
  --lua-filter resource/pandoc/lua/typst-layout.lua
)

echo "==> PDF (Typst)"
pandoc "${COMMON_ARGS[@]}" \
  --to typst \
  --template resource/pandoc/template/book.typst \
  --output "${TYPST_FILE}" \
  book.md
typst compile --root "${SCRIPT_DIR}" "${TYPST_FILE}" "${RELEASE_VERSION_PATH}/${NAME}.pdf"

echo "==> ePUB"
pandoc "${COMMON_ARGS[@]}" \
  --to epub3 --toc --toc-depth 2 \
  --css resource/pandoc/css/style.css \
  --output "${RELEASE_VERSION_PATH}/${NAME}.epub" \
  book.md

echo "==> HTML"
pandoc "${COMMON_ARGS[@]}" \
  --to html5 --toc --toc-depth 2 \
  --css resource/pandoc/css/style.css \
  --include-before-body resource/pandoc/template/downloads.html \
  --output "${RELEASE_VERSION_PATH}/${NAME}.html" \
  book.md

echo "==> GitHub Markdown"
MD_FILE="${RELEASE_VERSION_PATH}/${NAME}.md"
pandoc "${COMMON_ARGS[@]}" \
  --to gfm --toc --toc-depth 2 \
  --output "${MD_FILE}.body" \
  book.md
pandoc --metadata "date=${DATE}" \
  --template resource/pandoc/template/header.md \
  --to gfm \
  --output "${MD_FILE}.header" \
  book.md
cat "${MD_FILE}.header" "${MD_FILE}.body" > "${MD_FILE}"
rm "${MD_FILE}.header" "${MD_FILE}.body"
# GitHub drops the dot after the chapter number in its heading anchors.
sed -E -i 's/\]\(#chapter-([0-9]+)\.-/](#chapter-\1-/g' "${MD_FILE}"

echo "==> Website"
SITE_PATH="${RELEASE_VERSION_PATH}/site"
mkdir -p "${SITE_PATH}/resource/pandoc"
cp "${RELEASE_VERSION_PATH}/${NAME}.html" "${SITE_PATH}/index.html"
cp "${RELEASE_VERSION_PATH}/${NAME}".{pdf,epub} "${RELEASE_VERSION_PATH}/resource.zip" "${SITE_PATH}/"
cp -R resource/image "${SITE_PATH}/resource/"
cp -R resource/pandoc/css "${SITE_PATH}/resource/pandoc/"
cp resource/site/_headers "${SITE_PATH}/_headers"

cp -R "${RELEASE_VERSION_PATH}/." "${RELEASE_LATEST_PATH}/"

echo "Build completed: ${RELEASE_VERSION_PATH}"
