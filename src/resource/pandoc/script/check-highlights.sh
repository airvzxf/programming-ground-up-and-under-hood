#!/usr/bin/env bash
# List the text that each syntax-highlighting class colours in the HTML
# website, to review the GNU Assembler theme. Run src/make.bash first.
set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SITE_PATH="${SCRIPT_DIR}/../../../../release/latest/site"

CLASSES=( al an at bn bu cf ch cn co cv do dt dv er ex fl fu im in kw op ot ot sc ss st va vs wa )
STYLES=( Alert Annotation Attribute BaseN BuiltIn ControlFlow Char Constant Comment CommentVar Documentation DataType DecVal Error Extension Float Function Import Information Keyword Operator Other Preprocessor SpecialChar SpecialString String Variable VerbatimString Warning )

INDEX=0
for CLASS in "${CLASSES[@]}"
do
   echo "${STYLES[${INDEX}]} ---> span.${CLASS}:"
   grep -Piso --line-buffered '<\s*span\s*class=\"'"${CLASS}"'\"[^>]*>(.*?)<\/span>' "${SITE_PATH}"/*.html | sort -n | uniq
   echo ""
   INDEX=$((INDEX + 1))
done
