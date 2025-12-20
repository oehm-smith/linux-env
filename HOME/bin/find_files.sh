#!/bin/bash
#
# find_files.sh - Shell wrapper for find_files.pl
#
# This wrapper script provides a convenient shell interface to the find_files.pl
# Perl script, handling path resolution and ensuring the Perl script is found
# regardless of where this wrapper is installed.
# Template field /Users/brooke/dev/amnesia/2025-06-18_selectEncRatedContent/utils will be replaced during installation.
#
# Usage: find_files.sh "search_terms"
#
# Examples:
#   ls *.txt | find_files.sh "error warning"
#   cat files.txt | find_files.sh "test data"
#   media_file_processor.pl --show-copied --db db.db | find_files.sh "keyword"
#

# Path to utils directory (set during installation)
UTILS_DIR="/Users/brooke/dev/amnesia/2025-06-18_selectEncRatedContent/utils"

# Verify the utils directory exists
if [ ! -d "$UTILS_DIR" ]; then
    echo "Error: Utils directory not found at: $UTILS_DIR" >&2
    echo "Please check your installation or reinstall the utils system." >&2
    exit 1
fi

# Path to the Perl script
PERL_SCRIPT="$UTILS_DIR/search/find_files.pl"

# Verify the Perl script exists
if [ ! -f "$PERL_SCRIPT" ]; then
    echo "Error: find_files.pl not found at: $PERL_SCRIPT" >&2
    echo "Please check your utils installation." >&2
    exit 1
fi

# Check if Perl is available
if ! command -v perl >/dev/null 2>&1; then
    echo "Error: Perl is not installed or not in PATH" >&2
    echo "find_files.pl requires Perl to run." >&2
    exit 1
fi

# Pass stdin and all arguments to the Perl script
exec perl "$PERL_SCRIPT" "$@"

