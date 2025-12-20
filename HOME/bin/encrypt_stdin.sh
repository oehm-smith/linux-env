#!/bin/bash
#
# encrypt_stdin.sh - Wrapper script for encrypt_stdin.pl
#
# This wrapper calls the Perl script with proper path resolution.
# Template field /Users/brooke/CloudStation/Dev/amnesia/2025-06-18_selectEncRatedContent/utils will be replaced during installation.
#

# Path to utils directory (set during installation)
UTILS_DIR="/Users/brooke/CloudStation/Dev/amnesia/2025-06-18_selectEncRatedContent/utils"

# Verify the utils directory exists
if [ ! -d "$UTILS_DIR" ]; then
    echo "Error: Utils directory not found at: $UTILS_DIR" >&2
    echo "Please check your installation or reinstall the utils system." >&2
    exit 1
fi

# Path to the Perl script
PERL_SCRIPT="$UTILS_DIR/edit/encrypt_stdin.pl"

# Verify the Perl script exists
if [ ! -f "$PERL_SCRIPT" ]; then
    echo "Error: encrypt_stdin.pl not found at: $PERL_SCRIPT" >&2
    echo "Please check your utils installation." >&2
    exit 1
fi

# Check if Perl is available
if ! command -v perl >/dev/null 2>&1; then
    echo "Error: Perl is not installed or not in PATH" >&2
    echo "encrypt_stdin.pl requires Perl to run." >&2
    exit 1
fi

# Execute the Perl script with all arguments passed through
exec perl "$PERL_SCRIPT" "$@"

