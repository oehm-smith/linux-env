#!/bin/bash
#
# rsync_move.sh - Shell wrapper for rsync_move.pl
#
# This wrapper script provides a convenient shell interface to the rsync_move.pl
# Perl script, handling path resolution and ensuring the Perl script is found
# regardless of where this wrapper is installed.
# Template field /Users/brooke/dev/amnesia/2025-06-18_selectEncRatedContent/utils will be replaced during installation.
#
# Usage: rsync_move.sh <source_directory> <destination>
#
# Examples:
#   rsync_move.sh /data/source_files user@remote:/destination/dir/
#   rsync_move.sh /home/user/photos /backup/photos/
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
PERL_SCRIPT="$UTILS_DIR/rsync/rsync_move.pl"

# Verify the Perl script exists
if [ ! -f "$PERL_SCRIPT" ]; then
    echo "Error: rsync_move.pl not found at: $PERL_SCRIPT" >&2
    echo "Please check your utils installation." >&2
    exit 1
fi

# Check if Perl is available
if ! command -v perl >/dev/null 2>&1; then
    echo "Error: Perl is not installed or not in PATH" >&2
    echo "rsync_move.pl requires Perl to run." >&2
    exit 1
fi

# Pass all arguments to the Perl script
exec perl "$PERL_SCRIPT" "$@"
