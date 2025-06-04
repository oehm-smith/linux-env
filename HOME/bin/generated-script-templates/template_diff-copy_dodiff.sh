#!/bin/bash
# template_diff-copy_dodiff.sh

# Base directories - modify these as needed
DEST_DIR="{{DEST_DIR}}"
SOURCE_DIR="{{SOURCE_DIR}}"

# Check if file path argument is provided
if [ $# -eq 0 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    echo "Usage: $0 [--inline] <file_path>"
    echo "Example: $0 README.md"
    echo "    Shows side-by-side diff of README.md between $DEST_DIR and $SOURCE_DIR"
    echo "Example: $0 docs/README.md"
    echo "    Shows side-by-side diff of docs/README.md between $DEST_DIR and $SOURCE_DIR"
    echo "Example: $0 {{DEST_DIR}}/docs/README.md"
    echo "    Strips {{DEST_DIR}} prefix, shows side-by-side diff of docs/README.md"
    echo "Example: $0 {{SOURCE_DIR}}/src/file.js"
    echo "    Strips {{SOURCE_DIR}} prefix, shows side-by-side diff of src/file.js"
    echo "Example: $0 --inline README.md"
    echo "    Shows traditional inline diff format instead of side-by-side"
    echo ""
    echo "Options:"
    echo "  --inline    Use inline diff format (default is side-by-side)"
    echo ""
    echo "Note: Full paths with $DEST_DIR or $SOURCE_DIR prefixes will be automatically stripped"
    exit 1
fi

# Parse arguments
INLINE_MODE=false
INPUT=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --inline)
            INLINE_MODE=true
            shift
            ;;
        *)
            INPUT="$1"
            shift
            ;;
    esac
done

# Check if we have a file path after parsing arguments
if [ -z "$INPUT" ]; then
    echo "Error: No file path provided"
    exit 1
fi

# Check if input starts with DEST_DIR or SOURCE_DIR and strip it
if [[ "$INPUT" =~ ^$DEST_DIR/(.+)$ ]]; then
    FILE_PATH="${BASH_REMATCH[1]}"
    echo "Detected full path with $DEST_DIR, using relative path: $FILE_PATH"
elif [[ "$INPUT" =~ ^$SOURCE_DIR/(.+)$ ]]; then
    FILE_PATH="${BASH_REMATCH[1]}"
    echo "Detected full path with $SOURCE_DIR, using relative path: $FILE_PATH"
else
    # Regular file path input
    FILE_PATH="$INPUT"
fi

# Construct full paths
FILE1="${DEST_DIR}/${FILE_PATH}"
FILE2="${SOURCE_DIR}/${FILE_PATH}"

# Check if both files exist
if [ ! -f "$FILE1" ]; then
    echo "Error: File '$FILE1' does not exist"
    exit 1
fi

if [ ! -f "$FILE2" ]; then
    echo "Error: File '$FILE2' does not exist"
    exit 1
fi

# Execute diff with appropriate format
if [ "$INLINE_MODE" = true ]; then
    # Standard inline diff
    diff "$FILE1" "$FILE2"
else
    # Side-by-side diff (default)
    diff -y "$FILE1" "$FILE2"
fi
