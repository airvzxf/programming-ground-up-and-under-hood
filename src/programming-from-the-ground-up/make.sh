#!/bin/bash -ex

VERSION="v"$(date "+%Y.%m.%d")
DATE=$(date "+%Y-%m-%d")
RELEASE_PATH="../../release/${VERSION}/"

mkdir -p "${RELEASE_PATH}"
rm -f "${RELEASE_PATH}"ProgrammingGroundUp*
rm -fR "${RELEASE_PATH}"resource
cp -R resource "${RELEASE_PATH}"resource

# ====== Create the release versions ====== #
OUTPUTS=(pdf epub3 html5 gfm)
EXTENSIONS=(pdf epub html md)
INDEX=0

sed -E -i "s/^date: [0-9\-]+$/date: ${DATE}/" book.md

for OUTPUT in ${OUTPUTS[*]}; do
  pandoc -f markdown -t "${OUTPUT}" \
    --standalone \
    --toc \
    --toc-depth 2 \
    --dpi 300 \
    --highlight-style \
      ./resource/pandoc/theme/default.theme \
    --syntax-definition \
      ./resource/pandoc/syntax/gnuassembler.xml \
    --syntax-definition \
      ./resource/pandoc/syntax/c.xml \
    --syntax-definition \
      ./resource/pandoc/syntax/bash.xml \
    --lua-filter \
      resource/pandoc/lua/include-code-files.lua \
    -o "${RELEASE_PATH}ProgrammingGroundUp.${EXTENSIONS[${INDEX}]}" \
    book.md &

  INDEX=$((INDEX + 1))
done
