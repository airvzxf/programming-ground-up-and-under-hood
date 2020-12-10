#!/bin/bash -ex

RELEASE_PATH="../../release/"
VERSION="v"$(date "+%Y.%m.%d")

mkdir -p "${RELEASE_PATH}"
rm -f "${RELEASE_PATH}"ProgrammingGroundUp*
rm -fR "${RELEASE_PATH}"resource
cp -R resource "${RELEASE_PATH}"resource

# ====== Create the release versions. ====== #

OUTPUTS=(html5 epub3 markdown_strict commonmark gfm pdf)
EXTENSIONS=(html epub strict.md common.md github.md pdf)

INDEX=0
for OUTPUT in ${OUTPUTS[*]}; do
  echo "OUTPUT: ${OUTPUT} = ${EXTENSIONS[${INDEX}]}"

  pandoc -f markdown -t "${OUTPUT}" \
    --standalone \
    --toc \
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
    -o "${RELEASE_PATH}ProgrammingGroundUp_${VERSION}.${EXTENSIONS[${INDEX}]}" \
    book.md &

  INDEX=$((INDEX + 1))
done
