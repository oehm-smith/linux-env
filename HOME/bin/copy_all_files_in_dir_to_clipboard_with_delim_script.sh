#!/bin/zsh

# Script to copy all files in current directory to clipboard with delimiters

output=""
first_file=true

# Loop through all files in current directory (excluding directories and hidden files)
for file in *(.); do
    # Add delimiter before each file (except the first one)
    if [[ $first_file == true ]]; then
        first_file=false
    else
        output+="\n"
    fi
    
    # Add delimiter and filename
    output+="---- $file ----\n"
    
    # Add file contents
    output+="$(cat "$file")"
done

# Copy to clipboard
echo -e "$output" | pbcopy

echo "Copied $(echo *(.N) | wc -w) files to clipboard"