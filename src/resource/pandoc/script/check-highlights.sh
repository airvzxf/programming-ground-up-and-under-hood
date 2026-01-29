#!/bin/bash -e

RELEASE_PATH="../release/"
VERSION="v"$(date "+%Y.%m.%d")
HTML_FILE="${RELEASE_PATH}ProgrammingGroundUp_${VERSION}.html"

CLASSES=( al an at bn bu cf ch cn co cv do dt dv er ex fl fu im in kw op ot ot sc ss st va vs wa )
STYLES=( Alert Annotation Attribute BaseN BuiltIn ControlFlow Char Constant Comment CommentVar Documentation DataType DecVal Error Extension Float Function Import Information Keyword Operator Other Preprocessor SpecialChar SpecialString String Variable VerbatimString Warning )

INDEX=0
for CLASS in "${CLASSES[@]}"
do
   echo "${STYLES[${INDEX}]} ---> span.${CLASS}:"
   grep -Piso --line-buffered '<\s*span\s*class=\"'"${CLASS}"'\"[^>]*>(.*?)<\/span>' "${HTML_FILE}" | sort -n | uniq
   echo ""
   INDEX=$((INDEX + 1))
done
