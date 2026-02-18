#!/bin/bash
# 3.2.26
# Might need to: brew install basictex

# Ensure the loop doesn't run if no files match the pattern
shopt -s nullglob

for file in *.md; do
    echo "Converting $file..."
    pandoc "$file" -o "${file%.md}.pdf"
done

echo "Done!"
