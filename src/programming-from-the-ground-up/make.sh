#!/bin/bash -ex

RELEASE_PATH="../../release/"
VERSION="v"$(date "+%Y.%m.%d")
HIGHLIGHT_STYLE="default.theme"

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

  #  --lua-filter \
  #        resource/pandoc/lua/include-code-files.lua \

  pandoc -f markdown -t "${OUTPUT}" --standalone \
    --highlight-style \
    ./resource/pandoc/theme/"${HIGHLIGHT_STYLE}" \
    --syntax-definition \
    ./resource/pandoc/syntax/gnuassembler.xml \
    --syntax-definition \
    ./resource/pandoc/syntax/c.xml \
    --syntax-definition \
    ./resource/pandoc/syntax/bash.xml \
    -o "${RELEASE_PATH}ProgrammingGroundUp_${VERSION}.${EXTENSIONS[${INDEX}]}" \
    001-ProgrammingGroundUp.txt \
    002-Book.md &

  INDEX=$((INDEX + 1))
done
