#!/bin/bash
# generate-diff-copy.sh

# generate-diff-copy.sh
#
# PURPOSE:
# This script generates customized diff and copy utilities for comparing and 
# synchronizing files between two specific directories. It creates two scripts:
#
# 1. docopy.sh - Copies files from SOURCE_DIR to DEST_DIR with automatic backup
#    - Supports single files, directories, and recursive directory copying
#    - Creates numbered backups (file-orig, file-orig.1, file-orig.2, etc.)
#    - Parses diff "Only in" output for easy integration with diff workflows
#    - Strips directory prefixes automatically for flexible input formats
#
# 2. dodiff.sh - Shows differences between files in SOURCE_DIR and DEST_DIR
#    - Default side-by-side view for easy comparison
#    - Optional inline mode with --inline flag
#    - Handles full paths with automatic prefix stripping
#
# USAGE:
# generate-diff-copy.sh <source_dir> <dest_dir> <output_dir>
#
# EXAMPLE:
# generate-diff-copy.sh /path/to/source /path/to/destination ./tools
#
# This creates:
# ./tools/docopy.sh - configured to copy from source to destination
# ./tools/dodiff.sh - configured to diff between source and destination
#
# The generated scripts are immediately executable and ready to use.

# Function to show usage
show_usage() {
    echo "Usage: $0 <source_dir> <dest_dir> <output_dir>"
    echo ""
    echo "Generates diff and copy utilities for working with two directories"
    echo ""
    echo "Arguments:"
    echo "  source_dir   Directory to copy FROM (source of files)"
    echo "  dest_dir     Directory to copy TO (destination for files)"
    echo "  output_dir   Where to create the generated scripts"
    echo ""
    echo "Example:"
    echo "  $0 /home/user/project_v1 /home/user/project_v2 ./tools"
    echo ""
    echo "Creates:"
    echo "  ./tools/docopy.sh - Copy files from source_dir to dest_dir"
    echo "  ./tools/dodiff.sh - Diff files between source_dir and dest_dir"
    echo ""
    echo "Both generated scripts include help (-h/--help) and handle various"
    echo "input formats including full paths and diff output."
}

# Check arguments
if [ $# -ne 3 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    show_usage
    exit 1
fi

SOURCE_DIR="$1"
DEST_DIR="$2"
OUTPUT_DIR="$3"

# Validate source and destination directories exist
if [ ! -d "$SOURCE_DIR" ]; then
    echo "Error: Source directory '$SOURCE_DIR' does not exist"
    exit 1
fi

if [ ! -d "$DEST_DIR" ]; then
    echo "Error: Destination directory '$DEST_DIR' does not exist"
    exit 1
fi

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"
if [ ! -d "$OUTPUT_DIR" ]; then
    echo "Error: Could not create output directory '$OUTPUT_DIR'"
    exit 1
fi

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_DIR="$SCRIPT_DIR/generated-script-templates"

# Check if template directory exists
if [ ! -d "$TEMPLATE_DIR" ]; then
    echo "Error: Template directory '$TEMPLATE_DIR' not found"
    echo "Expected templates:"
    echo "  $TEMPLATE_DIR/template_diff-copy_docopy.sh"
    echo "  $TEMPLATE_DIR/template_diff-copy_dodiff.sh"
    exit 1
fi

# Check if template files exist
DOCOPY_TEMPLATE="$TEMPLATE_DIR/template_diff-copy_docopy.sh"
DODIFF_TEMPLATE="$TEMPLATE_DIR/template_diff-copy_dodiff.sh"

if [ ! -f "$DOCOPY_TEMPLATE" ]; then
    echo "Error: Template file '$DOCOPY_TEMPLATE' not found"
    exit 1
fi

if [ ! -f "$DODIFF_TEMPLATE" ]; then
    echo "Error: Template file '$DODIFF_TEMPLATE' not found"
    exit 1
fi

# Generate docopy.sh
echo "Generating docopy.sh..."
DOCOPY_OUTPUT="$OUTPUT_DIR/docopy.sh"
sed -e "s|{{SOURCE_DIR}}|$SOURCE_DIR|g" -e "s|{{DEST_DIR}}|$DEST_DIR|g" "$DOCOPY_TEMPLATE" > "$DOCOPY_OUTPUT"
chmod +x "$DOCOPY_OUTPUT"

# Generate dodiff.sh
echo "Generating dodiff.sh..."
DODIFF_OUTPUT="$OUTPUT_DIR/dodiff.sh"
sed -e "s|{{SOURCE_DIR}}|$SOURCE_DIR|g" -e "s|{{DEST_DIR}}|$DEST_DIR|g" "$DODIFF_TEMPLATE" > "$DODIFF_OUTPUT"
chmod +x "$DODIFF_OUTPUT"

echo ""
echo "Scripts generated successfully:"
echo "  $DOCOPY_OUTPUT"
echo "  $DODIFF_OUTPUT"
echo ""
echo "Configuration:"
echo "  Source directory (copy FROM): $SOURCE_DIR"
echo "  Destination directory (copy TO): $DEST_DIR"
echo ""
echo "Usage examples:"
echo "  $DOCOPY_OUTPUT README.md                    # Copy single file"
echo "  $DOCOPY_OUTPUT -r src/                      # Copy directory recursively"
echo "  $DODIFF_OUTPUT README.md                    # Show side-by-side diff"
echo "  $DODIFF_OUTPUT --inline README.md           # Show inline diff"
echo ""
echo "Both scripts support -h/--help for detailed usage information."
