#!/bin/zsh

# xmv - Move file to same name with custom prefix (defaults to 'x')
# Usage: xmv <filename> [prefix]
# Examples: xmv file.txt     -> moves to xfile.txt
#          xmv file.txt b    -> moves to bfile.txt

xmv() {
    if [ $# -eq 0 ]; then
        echo "Usage: xmv <filename> [prefix]"
        echo "Moves a file to the same name with custom prefix (defaults to 'x')"
        return 1
    fi
    
    local filename="$1"
    local prefix="${2:-x}"  # Use second argument or default to 'x'
    
    if [ ! -e "$filename" ]; then
        echo "Error: File '$filename' does not exist"
        return 1
    fi
    
    mv "$filename" "$prefix$filename"
    echo "Moved '$filename' to '$prefix$filename'"
}
xmv "$@"
