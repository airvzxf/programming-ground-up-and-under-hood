#!/bin/bash -ev

# Create the final ePUB version.
pandoc -o ProgrammingGroundUp.epub \
  001-ProgrammingGroundUp.txt \
  002-Book.md
