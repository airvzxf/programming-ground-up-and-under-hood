#!/usr/bin/env bash
set -ex

# Get script directory to handle relative paths correctly
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "${SCRIPT_DIR}"

VERSION="v$(date "+%Y.%m.%d")"
DATE="$(date "+%Y-%m-%d")"
# Define output paths relative to project root
RELEASE_ROOT_PATH="../release"
RELEASE_VERSION_PATH="${RELEASE_ROOT_PATH}/${VERSION}"
RELEASE_LATEST_PATH="${RELEASE_ROOT_PATH}/latest"

# Clean up previous directories
rm -fR "${RELEASE_VERSION_PATH}"
rm -fR "${RELEASE_LATEST_PATH}"

mkdir -p "${RELEASE_VERSION_PATH}"
mkdir -p "${RELEASE_LATEST_PATH}"

# Copy necessary resources for compilation and release
cp -R resource "${RELEASE_VERSION_PATH}/resource"

# Create resource zip archive
cd "${RELEASE_VERSION_PATH}"
zip -r -9 -D resource.zip resource
cd "${SCRIPT_DIR}"

# ====== Update date in the document ======
sed -E -i "s/^date: [0-9\-]+$/date: ${DATE}/" book.md

# ====== Generate book versions ======
OUTPUTS=(pdf epub3 html5 gfm)
EXTENSIONS=(pdf epub html md)

for i in "${!OUTPUTS[@]}"; do
  OUTPUT="${OUTPUTS[$i]}"
  EXT="${EXTENSIONS[$i]}"

  echo "Generating format: ${OUTPUT}..."

  # Default args
  ARGS=(
    -f markdown
    -t "${OUTPUT}"
    --standalone
    --toc
    --toc-depth 2
    --dpi 300
    --highlight-style ./resource/pandoc/theme/default.theme
    --syntax-definition ./resource/pandoc/syntax/gnuassembler.xml
    --syntax-definition ./resource/pandoc/syntax/c.xml
    --syntax-definition ./resource/pandoc/syntax/bash.xml
    --lua-filter resource/pandoc/lua/include-code-files.lua
    -o "${RELEASE_VERSION_PATH}/ProgrammingGroundUp.${EXT}"
  )

  # Format specific args
  if [[ "$OUTPUT" == "html5" || "$OUTPUT" == "epub3" ]]; then
    ARGS+=(--css resource/pandoc/css/style.css)
  fi

  pandoc "${ARGS[@]}" book.md

  # Post-processing for Markdown
  if [[ "$OUTPUT" == "gfm" ]]; then
    MD_FILE="${RELEASE_VERSION_PATH}/ProgrammingGroundUp.${EXT}"

    # 1. Generate Header dynamically from book.md metadata
    pandoc --template resource/pandoc/template/header.md \
           -t gfm \
           -o header_tmp.md \
           book.md

    # 2. Prepend Header to the main file
    cat header_tmp.md "$MD_FILE" > "${MD_FILE}.tmp" && mv "${MD_FILE}.tmp" "$MD_FILE"
    rm header_tmp.md

    # 3. Fix broken links (remove dot after chapter number in links)
    sed -E -i 's/\]\(#chapter-([0-9]+)\.-/](#chapter-\1-/g' "$MD_FILE"
  fi
done

# Copy everything to 'latest' folder
cp -R "${RELEASE_VERSION_PATH}/"* "${RELEASE_LATEST_PATH}/"

echo "Compilation completed successfully at ${RELEASE_VERSION_PATH}"
