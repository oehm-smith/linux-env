#!/bin/bash
# template_diff-copy_docopy.sh

# Base directories - modify these as needed
DEST_DIR="{{DEST_DIR}}"
SOURCE_DIR="{{SOURCE_DIR}}"

# Function to handle "Only in <dir>: <file>" format
handle_diff_single_file() {
    local diff_dir="$1"
    local filename="$2"
    
    # Check if the directory matches SOURCE_DIR
    if [ "$diff_dir" != "$SOURCE_DIR" ]; then
        echo "Error: Directory '$diff_dir' does not match expected SOURCE_DIR '$SOURCE_DIR'"
        exit 1
    fi
    
    # Extract the relative path from SOURCE_DIR
    local rel_path="${diff_dir#$SOURCE_DIR/}"
    if [ "$rel_path" = "$diff_dir" ]; then
        # DIFF_DIR is exactly SOURCE_DIR, so file is in root
        FILE_PATH="$filename"
    else
        # File is in a subdirectory
        FILE_PATH="$rel_path/$filename"
    fi
    
    echo "Detected diff output format (single file)"
    echo "Source directory: $diff_dir"
    echo "Filename: $filename"
    echo "Computed file path: $FILE_PATH"
}

# Function to handle "Only in <dir>" format (directory only)
handle_diff_directory() {
    local diff_dir="$1"
    local recursive="$2"
    
    # Check if the directory matches SOURCE_DIR
    if [[ ! "$diff_dir" =~ ^$SOURCE_DIR(/.*)?$ ]]; then
        echo "Error: Directory '$diff_dir' does not start with expected SOURCE_DIR '$SOURCE_DIR'"
        exit 1
    fi
    
    # Check if source directory exists
    if [ ! -d "$diff_dir" ]; then
        echo "Error: Source directory '$diff_dir' does not exist"
        exit 1
    fi
    
    # Extract the relative path from SOURCE_DIR
    local rel_path="${diff_dir#$SOURCE_DIR}"
    rel_path="${rel_path#/}"  # Remove leading slash if present
    
    # Destination directory
    local dest_dir
    if [ -z "$rel_path" ]; then
        dest_dir="$DEST_DIR"
    else
        dest_dir="$DEST_DIR/$rel_path"
    fi
    
    echo "Detected diff output format (directory only)"
    echo "Source directory: $diff_dir"
    echo "Destination directory: $dest_dir"
    if [ "$recursive" = true ]; then
        echo "Recursively copying all files and subdirectories from '$diff_dir' to '$dest_dir'"
    else
        echo "Copying all files from '$diff_dir' to '$dest_dir'"
    fi
    
    copy_directory_files "$diff_dir" "$dest_dir" "$recursive" true
}

# Function to handle regular directory input
handle_regular_directory() {
    local file_path="$1"
    local recursive="$2"
    local potential_dir="$SOURCE_DIR/$file_path"
    
    if [ ! -d "$potential_dir" ]; then
        return 1  # Not a directory
    fi
    
    local dest_dir="$DEST_DIR/$file_path"
    
    echo "Detected directory input: $file_path"
    echo "Source directory: $potential_dir"
    echo "Destination directory: $dest_dir"
    if [ "$recursive" = true ]; then
        echo "Recursively copying all files and subdirectories from '$potential_dir' to '$dest_dir'"
    else
        echo "Copying all files from '$potential_dir' to '$dest_dir'"
    fi
    
    copy_directory_files "$potential_dir" "$dest_dir" "$recursive" true
    return 0
}

# Function to copy all files from source directory to destination
copy_directory_files() {
    local source_dir="$1"
    local dest_dir="$2"
    local recursive="$3"
    local is_root_call="${4:-true}"
    local has_subdirs=false
    local files_copied=0
    local files_skipped=0
    
    # Create destination directory if it doesn't exist
    mkdir -p "$dest_dir"
    
    # Copy all files from source to destination
    if [ "$(ls -A "$source_dir" 2>/dev/null)" ]; then
        for item in "$source_dir"/*; do
            if [ -f "$item" ]; then
                local filename=$(basename "$item")
                local dest_file="$dest_dir/$filename"
                
                # Check if files differ before copying
                if [ -f "$dest_file" ] && cmp -s "$item" "$dest_file"; then
                    echo "Skipping '$item' (identical to destination)"
                    files_skipped=$((files_skipped + 1))
                else
                    # Files differ or destination doesn't exist - backup and copy
                    if [ -f "$dest_file" ]; then
                        create_backup "$dest_file"
                    fi
                    
                    echo "Copying '$item' to '$dest_file'"
                    cp "$item" "$dest_file"
                    files_copied=$((files_copied + 1))
                fi
            elif [ -d "$item" ] && [ "$recursive" = true ]; then
                # Recursively process subdirectories
                local dirname=$(basename "$item")
                local dest_subdir="$dest_dir/$dirname"
                echo "Recursively processing directory: $dirname"
                copy_directory_files "$item" "$dest_subdir" true false
            elif [ -d "$item" ] && [ "$recursive" = false ]; then
                # Note that there are subdirectories but we're not processing them
                has_subdirs=true
            fi
        done
        
        # Only show warnings and completion message for the root call
        if [ "$is_root_call" = true ]; then
            # Show summary
            if [ $files_copied -gt 0 ] || [ $files_skipped -gt 0 ]; then
                echo ""
                echo "Summary: $files_copied file(s) copied, $files_skipped file(s) skipped (identical)"
            fi
            
            # Warn about subdirectories if not in recursive mode
            if [ "$has_subdirs" = true ] && [ "$recursive" = false ]; then
                echo ""
                echo "WARNING: Directory contains subdirectories that were not copied."
                echo "Use -r flag to recursively copy subdirectories and their contents."
            fi
            
            echo "Operation completed successfully!"
            exit 0
        fi
    else
        if [ "$is_root_call" = true ]; then
            echo "No files found in '$source_dir'"
            exit 0
        fi
    fi
}

# Function to create backup of a file
create_backup() {
    local file="$1"
    local dir_part=$(dirname "$file")
    local basename=$(basename "$file")
    local backup_file
    
    # Split filename and extension
    if [[ "$basename" == *.* ]]; then
        local name="${basename%.*}"
        local ext="${basename##*.}"
        backup_file="${dir_part}/${name}-orig.${ext}"
    else
        backup_file="${file}-orig"
    fi
    
    # Find an available backup filename
    local counter=0
    local final_backup="$backup_file"
    
    while [ -f "$final_backup" ]; do
        counter=$((counter + 1))
        if [[ "$basename" == *.* ]]; then
            local name="${basename%.*}"
            local ext="${basename##*.}"
            final_backup="${dir_part}/${name}-orig.${counter}.${ext}"
        else
            final_backup="${file}-orig.${counter}"
        fi
    done
    
    echo "Backing up '$file' to '$final_backup'"
    mv "$file" "$final_backup"
}

# Check if file path argument is provided
if [ $# -eq 0 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    echo "Usage: $0 [-r] <file_path>"
    echo "Example: $0 README.md"
    echo "    Copies README.md from $SOURCE_DIR to $DEST_DIR, backing up existing file"
    echo "Example: $0 docs/README.md"
    echo "    Copies docs/README.md from $SOURCE_DIR to $DEST_DIR, backing up existing file"
    echo "Example: $0 {{DEST_DIR}}/docs/README.md"
    echo "    Strips {{DEST_DIR}} prefix, copies docs/README.md from $SOURCE_DIR to $DEST_DIR"
    echo "Example: $0 {{SOURCE_DIR}}/src/file.js"
    echo "    Strips {{SOURCE_DIR}} prefix, copies src/file.js from $SOURCE_DIR to $DEST_DIR"
    echo "Example: $0 {{SOURCE_DIR}}/src/assets/backgrounds"
    echo "    Strips prefix, copies all files from src/assets/backgrounds/ in $SOURCE_DIR to $DEST_DIR"
    echo "Example: $0 -r {{SOURCE_DIR}}/src/assets"
    echo "    Recursively copies all files and subdirectories from src/assets/ in $SOURCE_DIR to $DEST_DIR"
    echo "Example: $0 'Only in {{SOURCE_DIR}}/src/assets/backgrounds: bwca-day.png'"
    echo "    Parses diff output, copies specific file bwca-day.png from backgrounds/ directory"
    echo "Example: $0 'Only in {{SOURCE_DIR}}/src/assets/backgrounds'"
    echo "    Parses diff output, copies all files from backgrounds/ directory"
    echo "Example: $0 -r 'Only in {{SOURCE_DIR}}/src/assets'"
    echo "    Parses diff output, recursively copies all files and subdirectories from assets/ directory"
    echo ""
    echo "Options:"
    echo "  -r          Recursively copy subdirectories and their contents"
    echo ""
    echo "This will:"
    echo "1. For single files: Rename existing file in $DEST_DIR to <filename>-orig (if it exists)"
    echo "2. For single files: Copy the file from $SOURCE_DIR to $DEST_DIR"
    echo "3. For directories: Copy all files from $SOURCE_DIR directory to same directory in $DEST_DIR"
    echo "4. With -r: Also recursively copy all subdirectories and their contents"
    echo "5. Full paths with $DEST_DIR or $SOURCE_DIR prefixes will be automatically stripped"
    exit 1
fi

# Parse arguments
RECURSIVE=false
RAW_INPUT=""

while [[ $# -gt 0 ]]; do
    case $1 in
        -r)
            RECURSIVE=true
            shift
            ;;
        *)
            RAW_INPUT="$1"
            shift
            ;;
    esac
done

# Check if we have input after parsing arguments
if [ -z "$RAW_INPUT" ]; then
    echo "Error: No file path provided"
    exit 1
fi

# Check if input starts with DEST_DIR or SOURCE_DIR and strip it
if [[ "$RAW_INPUT" =~ ^$DEST_DIR/(.+)$ ]]; then
    INPUT="${BASH_REMATCH[1]}"
    echo "Detected full path with $DEST_DIR, using relative path: $INPUT"
elif [[ "$RAW_INPUT" =~ ^$SOURCE_DIR/(.+)$ ]]; then
    INPUT="${BASH_REMATCH[1]}"
    echo "Detected full path with $SOURCE_DIR, using relative path: $INPUT"
else
    # Use input as-is
    INPUT="$RAW_INPUT"
fi

# Parse input and determine action
if [[ "$INPUT" =~ ^Only\ in\ ([^:]+):\ (.+)$ ]]; then
    # Format: "Only in <dir>: <file>"
    handle_diff_single_file "${BASH_REMATCH[1]}" "${BASH_REMATCH[2]}"
elif [[ "$INPUT" =~ ^Only\ in\ ([^:]+)$ ]]; then
    # Format: "Only in <dir>" (directory only, no file)
    handle_diff_directory "${BASH_REMATCH[1]}" "$RECURSIVE"
else
    # Regular file path input or directory path
    FILE_PATH="$INPUT"
    
    # Check if this is a directory first
    if handle_regular_directory "$FILE_PATH" "$RECURSIVE"; then
        exit 0
    fi
    
    # If not a directory, treat as regular file
fi

# Regular file processing (only reached if not a directory or diff format)
FILE1="${DEST_DIR}/${FILE_PATH}"
FILE2="${SOURCE_DIR}/${FILE_PATH}"

# Check if source file exists
if [ ! -f "$FILE2" ]; then
    echo "Error: Source file '$FILE2' does not exist"
    exit 1
fi

# Create directory structure if it doesn't exist
mkdir -p "$(dirname "$FILE1")"

# Check if files differ before copying
if [ -f "$FILE1" ] && cmp -s "$FILE2" "$FILE1"; then
    echo "Files are identical - no copy needed"
    echo "Source: $FILE2"
    echo "Destination: $FILE1"
else
    # Files differ or destination doesn't exist - backup and copy
    if [ -f "$FILE1" ]; then
        create_backup "$FILE1"
    else
        echo "No existing file to backup in $DEST_DIR"
    fi

    # Copy file from SOURCE_DIR to DEST_DIR
    echo "Copying '$FILE2' to '$FILE1'"
    cp "$FILE2" "$FILE1"
fi

echo "Operation completed successfully!"
