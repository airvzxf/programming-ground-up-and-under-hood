#!/bin/bash -ex

RELEASE_PATH="../../release/"
VERSION="v"$(date "+%Y.%m.%d")
HIGHLIGHT_STYLE="default.theme"               # default.theme | pygments tango kate haddock


mkdir -p "${RELEASE_PATH}"
rm -f "${RELEASE_PATH}"ProgrammingGroundUp*
rm -fR "${RELEASE_PATH}"resource
cp -R resource "${RELEASE_PATH}"resource


# Create the release versions.

#  --lua-filter \
#        resource/pandoc/lua/include-code-files.lua \

#  --highlight-style \
#        pygments \

pandoc -f markdown -t html5 --standalone \
  --highlight-style \
        ./resource/pandoc/theme/"${HIGHLIGHT_STYLE}" \
  -o "${RELEASE_PATH}ProgrammingGroundUp_${VERSION}.html" \
  001-ProgrammingGroundUp.txt \
  002-Book.md \
  &


pandoc -f markdown -t epub3 --standalone \
  --highlight-style \
        ./resource/pandoc/theme/"${HIGHLIGHT_STYLE}" \
  -o "${RELEASE_PATH}ProgrammingGroundUp_${VERSION}.epub" \
  001-ProgrammingGroundUp.txt \
  002-Book.md \
  &

pandoc -f markdown -t markdown_strict --standalone \
  --highlight-style \
        ./resource/pandoc/theme/"${HIGHLIGHT_STYLE}" \
  -o "${RELEASE_PATH}ProgrammingGroundUp_${VERSION}_markdown_strict.md" \
  001-ProgrammingGroundUp.txt \
  002-Book.md \
  &

pandoc -f markdown -t commonmark --standalone \
  --highlight-style \
        ./resource/pandoc/theme/"${HIGHLIGHT_STYLE}" \
  -o "${RELEASE_PATH}ProgrammingGroundUp_${VERSION}_commonmark.md" \
  001-ProgrammingGroundUp.txt \
  002-Book.md \
  &

pandoc -f markdown -t gfm --standalone \
  --highlight-style \
        ./resource/pandoc/theme/"${HIGHLIGHT_STYLE}" \
  -o "${RELEASE_PATH}ProgrammingGroundUp_${VERSION}_github.md" \
  001-ProgrammingGroundUp.txt \
  002-Book.md \
  &

pandoc -f markdown -t pdf --standalone \
  --highlight-style \
        ./resource/pandoc/theme/"${HIGHLIGHT_STYLE}" \
  -o "${RELEASE_PATH}ProgrammingGroundUp_${VERSION}.pdf" \
  001-ProgrammingGroundUp.txt \
  002-Book.md \
  &
