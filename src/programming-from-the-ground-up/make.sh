#!/bin/bash -ev

RELEASE_PATH="../../release/"
VERSION="v"$(date "+%Y.%m.%d")

mkdir -p "${RELEASE_PATH}"
rm -f "${RELEASE_PATH}ProgrammingGroundUp_*"
rm -fR "${RELEASE_PATH}resource"
cp -R "resource" "${RELEASE_PATH}resource"

# Create the final ePUB version.
pandoc -f markdown -t epub3 -o "${RELEASE_PATH}ProgrammingGroundUp_${VERSION}.epub" \
  001-ProgrammingGroundUp.txt \
  002-Book.md

pandoc -f markdown -t markdown_github -o "${RELEASE_PATH}ProgrammingGroundUp_${VERSION}.md" \
  001-ProgrammingGroundUp.txt \
  002-Book.md

pandoc -f markdown -t html5 -o "${RELEASE_PATH}ProgrammingGroundUp_${VERSION}.html" \
  001-ProgrammingGroundUp.txt \
  002-Book.md

pandoc -f markdown -t pdf -o "${RELEASE_PATH}ProgrammingGroundUp_${VERSION}.pdf" \
  001-ProgrammingGroundUp.txt \
  002-Book.md
