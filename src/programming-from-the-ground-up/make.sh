#!/bin/bash -ex

RELEASE_PATH="../../release/"
VERSION="v"$(date "+%Y.%m.%d")

mkdir -p "${RELEASE_PATH}"
rm -f "${RELEASE_PATH}"ProgrammingGroundUp*
rm -fR "${RELEASE_PATH}"resource
cp -R resource "${RELEASE_PATH}"resource

# Create the final ePUB version.
pandoc -f markdown -t epub3 --standalone -o \
  "${RELEASE_PATH}ProgrammingGroundUp_${VERSION}.epub" \
  001-ProgrammingGroundUp.txt \
  002-Book.md

pandoc -f markdown -t markdown_github --standalone -o \
  "${RELEASE_PATH}ProgrammingGroundUp_${VERSION}_github.md" \
  001-ProgrammingGroundUp.txt \
  002-Book.md

pandoc -f markdown -t gfm --standalone -o \
  "${RELEASE_PATH}ProgrammingGroundUp_${VERSION}_gfm.md" \
  001-ProgrammingGroundUp.txt \
  002-Book.md

pandoc -f markdown -t commonmark --standalone -o \
  "${RELEASE_PATH}ProgrammingGroundUp_${VERSION}_commonmark.md" \
  001-ProgrammingGroundUp.txt \
  002-Book.md

pandoc -f markdown -t commonmark_x --standalone -o \
  "${RELEASE_PATH}ProgrammingGroundUp_${VERSION}_commonmarkx.md" \
  001-ProgrammingGroundUp.txt \
  002-Book.md

pandoc -f markdown -t markdown --standalone -o \
  "${RELEASE_PATH}ProgrammingGroundUp_${VERSION}_markdown.md" \
  001-ProgrammingGroundUp.txt \
  002-Book.md

pandoc -f markdown -t markdown_mmd --standalone -o \
  "${RELEASE_PATH}ProgrammingGroundUp_${VERSION}_markdown_mmd.md" \
  001-ProgrammingGroundUp.txt \
  002-Book.md

pandoc -f markdown -t markdown_phpextra --standalone -o \
  "${RELEASE_PATH}ProgrammingGroundUp_${VERSION}_markdown_phpextra.md" \
  001-ProgrammingGroundUp.txt \
  002-Book.md

pandoc -f markdown -t markdown_strict --standalone -o \
  "${RELEASE_PATH}ProgrammingGroundUp_${VERSION}_markdown_strict.md" \
  001-ProgrammingGroundUp.txt \
  002-Book.md

pandoc -f markdown -t html5 --standalone --highlight-style pygments -o \
  "${RELEASE_PATH}ProgrammingGroundUp_${VERSION}.html" \
  001-ProgrammingGroundUp.txt \
  002-Book.md

pandoc -f markdown -t pdf --standalone -o \
  "${RELEASE_PATH}ProgrammingGroundUp_${VERSION}.pdf" \
  001-ProgrammingGroundUp.txt \
  002-Book.md
