#!/bin/bash

print_items() {
  local ITEMS=${*}
  for ITEM in ${ITEMS}; do
    echo "      <item>${ITEM}</item>"
  done
}

echo '    <list name="data_types">'
print_items {".ascii",".asciz",".byte",".double",".float",".int",".long",".octa",".quad",".short",".single"}
echo '    </list>'
echo '    <list name="variable">'
print_items {"$","%"}{"e",}{"a","b","c","d"}"x"
print_items {"$","%"}{"a","b","c","d"}{"h","l"}
print_items {"$","%"}{"e",}{"si","di","sp","bp"}
echo '    </list>'
echo '    <list name="keyword">'
print_items {"mov","push","pop","lea"}{"","b","s","w","l","q","t"}
echo '    </list>'
echo '    <list name="operator">'
print_items {"cmp","add","sub","inc","dec","imul","idiv","and","or","xor","not","neg","shl","shr"}{"","b","s","w","l","q","t"}
echo '    </list>'
echo '    <list name="control_flow">'
print_items {"call","ret","jmp","je","ja","jae","jb","jbe","jc","jcxz","jg","jge","jl","jle","jna","jnae","jnb","jnbe","jnc","jne","jng","jnge","jnl","jnle","jno","jnp","jns","jnz","jo","jp","jpe","jpo","js","jz","loop","loope","loopz","loopne","loopnz"}
echo '    </list>'
echo '    <list name="preprocessor">'
print_items {".section",".code64",".code32",".code16",".arm"}
echo '    </list>'
echo '    <list name="import">'
print_items {".include",}
echo '    </list>'
echo '    <list name="others">'
print_items {"int",}
echo '    </list>'
echo '    <list name="annotation">'
print_items {".rodata",".data",".bss",".text",".globl",".global",".type",".rept",".endr"}
echo '    </list>'
echo '    <list name="constant">'
print_items {".equ",".comm",".lcomm"}
echo '    </list>'
echo '    <list name="function">'
print_items {"@function",}
echo '    </list>'
