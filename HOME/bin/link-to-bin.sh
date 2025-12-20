#!/bin/bash
#
# link-to-bin.sh - Create symbolic links from bin directory to repository scripts
#
# This script creates symbolic links from ~/bin to scripts in the repository.
# It handles existing files intelligently:
# - If already a symlink to the same place: leave it
# - If a regular file: check mod times and show diff command
# - If doesn't exist: create symlink
#

set -e

# Configuration - will be set from command line arguments
BIN_DIR=""
REPO_DIR=""
VERBOSE=false
DRY_RUN=false
RECURSIVE=false

# Function to display usage information
usage() {
    echo "Usage: $0 <repository_directory> <bin_directory> [options]"
    echo ""
    echo "Create symbolic links from bin directory to repository scripts."
    echo ""
    echo "Arguments:"
    echo "  repository_directory    Directory containing the repository scripts"
    echo "  bin_directory          Directory where symlinks will be created (e.g., ~/bin)"
    echo ""
    echo "Options:"
    echo "  -h, --help     Show this help message"
    echo "  -v, --verbose  Verbose output"
    echo "  -d, --dry-run  Show what would be done without making changes"
    echo "  -r, --recursive Process subdirectories recursively (default: top-level only)"
    echo ""
    echo "Examples:"
    echo "  $0 /path/to/repo ~/bin"
    echo "  $0 /path/to/repo ~/bin --verbose"
    echo "  $0 /path/to/repo ~/bin --dry-run"
    echo "  $0 /path/to/repo ~/bin --recursive"
    exit 0
}

# Function to log messages
log_message() {
    if [ "$VERBOSE" = true ]; then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
    fi
}

# Function to check if file is a symlink to specific target
is_symlink_to() {
    local file="$1"
    local target="$2"
    
    if [ -L "$file" ]; then
        local link_target=$(readlink "$file")
        if [ "$link_target" = "$target" ]; then
            return 0
        fi
    fi
    return 1
}

# Function to get file modification time
get_mtime() {
    local file="$1"
    if [ -f "$file" ]; then
        stat -f "%m" "$file" 2>/dev/null || stat -c "%Y" "$file" 2>/dev/null
    else
        echo "0"
    fi
}

# Parse command line arguments
VERBOSE=false
DRY_RUN=false

# Check for help flags first
if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    usage
fi

# Check minimum number of arguments
if [ $# -lt 2 ]; then
    echo "Error: Missing required arguments." >&2
    echo "" >&2
    usage
fi

# Get required arguments
REPO_DIR="$1"
BIN_DIR="$2"
shift 2

# Parse remaining options
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            usage
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        -d|--dry-run)
            DRY_RUN=true
            shift
            ;;
        -r|--recursive)
            RECURSIVE=true
            shift
            ;;
        *)
            echo "Unknown option: $1" >&2
            usage
            ;;
    esac
done

# Verify directories exist
if [ ! -d "$REPO_DIR" ]; then
    echo "Error: Repository directory not found: $REPO_DIR" >&2
    exit 1
fi

if [ ! -d "$BIN_DIR" ]; then
    echo "Error: Bin directory not found: $BIN_DIR" >&2
    echo "Please create the bin directory first: mkdir -p $BIN_DIR" >&2
    exit 1
fi

# Convert to absolute paths
REPO_DIR_ABS=$(cd "$REPO_DIR" && pwd)
BIN_DIR_ABS=$(cd "$BIN_DIR" && pwd)

echo "=== LINK TO BIN SCRIPT ==="
echo "Repository: $REPO_DIR"
echo "Bin directory: $BIN_DIR"
if [ "$DRY_RUN" = true ]; then
    echo "Mode: DRY RUN (no changes will be made)"
fi
echo ""

# Save current directory
ORIGINAL_DIR=$(pwd)

# Find all .sh files in the repository
log_message "Scanning repository for .sh files..."

# Check for subdirectories if not recursive
if [ "$RECURSIVE" = false ]; then
    subdirs=$(find "$REPO_DIR_ABS" -mindepth 1 -maxdepth 1 -type d)
    if [ -n "$subdirs" ]; then
        echo "Warning: Subdirectories found in repository. Use -r/--recursive to process them:"
        echo "$subdirs" | sed 's/^/  /'
        echo ""
    fi
fi

# Find .sh files based on recursive setting
if [ "$RECURSIVE" = true ]; then
    repo_files=$(find "$REPO_DIR_ABS" -name "*.sh" -type f)
else
    repo_files=$(find "$REPO_DIR_ABS" -maxdepth 1 -name "*.sh" -type f)
fi

if [ -z "$repo_files" ]; then
    echo "No .sh files found in repository"
    exit 1
fi

# Change to bin directory before processing files
cd "$BIN_DIR_ABS"

for repo_file in $repo_files; do
    # Skip this script itself (check both absolute and relative paths)
    if [ "$repo_file" = "${BASH_SOURCE[0]}" ] || [ "$repo_file" = "./link-to-bin.sh" ] || [ "$repo_file" = "link-to-bin.sh" ]; then
        continue
    fi
    
    # Skip files in test directories
    if [[ "$repo_file" == */test/* ]]; then
        continue
    fi
    
    # Skip files in bin subdirectories (to avoid linking to already installed wrappers)
    # Only skip if the file is in a subdirectory called "bin", not if the repo root contains "bin"
    if [[ "$repo_file" == "$REPO_DIR_ABS"/*/bin/* ]]; then
        continue
    fi
    
    # Skip template files (they should not be linked directly)
    if [[ "$repo_file" == *"_template.sh" ]]; then
        continue
    fi
    
    # Get the script name
    script_name=$(basename "$repo_file")
    
    log_message "Processing $script_name"
    
    # Check if file exists in bin directory
    if [ -L "$script_name" ]; then
        # It's a symlink
        if is_symlink_to "$script_name" "$repo_file"; then
            echo "✅ $script_name: Already linked to repository"
        else
            current_target=$(readlink "$script_name")
            echo "⚠️  $script_name: Symlink exists but points to different location"
            echo "   Current: $current_target"
            echo "   Desired: $repo_file"
            if [ "$DRY_RUN" = false ]; then
                echo "   Updating symlink..."
                ln -sf "$repo_file" "$script_name"
                echo "   ✅ Updated symlink"
            else
                echo "   [DRY RUN] Would update symlink"
            fi
        fi
    elif [ -f "$script_name" ]; then
        # It's a regular file - check if it's identical to repository file
        echo "⚠️  $script_name: Regular file exists in bin directory"
        
        # Check if files are identical
        if diff "$repo_file" "$script_name" >/dev/null 2>&1; then
            # Files are identical - replace with symlink
            echo "   Files are identical - replacing with symlink"
            if [ "$DRY_RUN" = false ]; then
                rm "$script_name"
                ln -s "$repo_file" "$script_name"
                echo "   ✅ Replaced regular file with symlink"
            else
                echo "   [DRY RUN] Would replace regular file with symlink"
            fi
        else
            # Files differ - show diff information
            repo_mtime=$(get_mtime "$repo_file")
            bin_mtime=$(get_mtime "$script_name")
            
            echo "   Files differ - manual review required"
            echo "   Repository: $repo_file (mtime: $repo_mtime)"
            echo "   Bin file: $script_name (mtime: $bin_mtime)"
            
            if [ "$repo_mtime" -gt "$bin_mtime" ]; then
                echo "   Repository file is newer"
            elif [ "$bin_mtime" -gt "$repo_mtime" ]; then
                echo "   Bin file is newer"
            else
                echo "   Files have same modification time"
            fi
            
            echo "   To compare files, run:"
            echo "   diff \"$repo_file\" \"$script_name\""
            echo "   vimdiff \"$repo_file\" \"$script_name\""
            echo "   To manually replace with symlink:"
            echo "   rm \"$script_name\" && ln -s \"$repo_file\" \"$script_name\""
            
            if [ "$DRY_RUN" = false ]; then
                echo "   [SKIPPED] Files differ - manual review required"
            else
                echo "   [DRY RUN] Would skip files that differ"
            fi
        fi
    else
        # File doesn't exist
        echo "➕ $script_name: Creating symlink"
        if [ "$DRY_RUN" = false ]; then
            ln -s "$repo_file" "$script_name"
            echo "   ✅ Created symlink"
        else
            echo "   [DRY RUN] Would create symlink: ln -s \"$repo_file\" \"$script_name\""
        fi
    fi
done

# Change back to original directory
cd "$ORIGINAL_DIR"

echo ""
echo "=== SUMMARY ==="
echo "Repository: $REPO_DIR"
echo "Bin directory: $BIN_DIR"
echo "Script completed successfully!"

if [ "$DRY_RUN" = true ]; then
    echo ""
    echo "This was a dry run. To make actual changes, run without --dry-run"
fi