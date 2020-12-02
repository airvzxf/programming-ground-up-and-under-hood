#!/bin/bash -ex

RELEASE_PATH="../../release/"
VERSION="v"$(date "+%Y.%m.%d")


mkdir -p "${RELEASE_PATH}"
rm -f "${RELEASE_PATH}"ProgrammingGroundUp*
rm -fR "${RELEASE_PATH}"resource
cp -R resource "${RELEASE_PATH}"resource


# Create the release versions.
pandoc -f markdown -t epub3 --standalone --highlight-style pygments \
  --lua-filter \
    resource/pandoc/lua/include-code-files.lua \
  -o "${RELEASE_PATH}ProgrammingGroundUp_${VERSION}.epub" \
  001-ProgrammingGroundUp.txt \
  002-Book.md \
  &

pandoc -f markdown -t markdown_strict --standalone --highlight-style pygments \
  --lua-filter \
    resource/pandoc/lua/include-code-files.lua \
  -o "${RELEASE_PATH}ProgrammingGroundUp_${VERSION}_markdown_strict.md" \
  001-ProgrammingGroundUp.txt \
  002-Book.md \
  &

pandoc -f markdown -t commonmark --standalone --highlight-style pygments \
  --lua-filter \
    resource/pandoc/lua/include-code-files.lua \
  -o "${RELEASE_PATH}ProgrammingGroundUp_${VERSION}_commonmark.md" \
  001-ProgrammingGroundUp.txt \
  002-Book.md \
  &

pandoc -f markdown -t gfm --standalone --highlight-style pygments \
  --lua-filter \
    resource/pandoc/lua/include-code-files.lua \
  -o "${RELEASE_PATH}ProgrammingGroundUp_${VERSION}_github.md" \
  001-ProgrammingGroundUp.txt \
  002-Book.md \
  &

pandoc -f markdown -t html5 --standalone --highlight-style pygments \
  --lua-filter \
    resource/pandoc/lua/include-code-files.lua \
  -o "${RELEASE_PATH}ProgrammingGroundUp_${VERSION}.html" \
  001-ProgrammingGroundUp.txt \
  002-Book.md \
  &

pandoc -f markdown -t pdf --standalone --highlight-style pygments \
  --lua-filter \
    resource/pandoc/lua/include-code-files.lua \
  -o "${RELEASE_PATH}ProgrammingGroundUp_${VERSION}.pdf" \
  001-ProgrammingGroundUp.txt \
  002-Book.md \
  &
