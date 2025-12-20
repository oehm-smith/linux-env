#!/bin/bash
#
# view_manifest.sh - Wrapper script for view_manifest.pl
#
# This wrapper calls the Perl view manifest script with proper path resolution.
# Template field /Users/brooke/dev/amnesia/2025-06-18_selectEncRatedContent/enDeCrypt will be replaced during installation.
#

# Path to enDeCrypt directory (set during installation)
ENDECRYPT_DIR="/Users/brooke/dev/amnesia/2025-06-18_selectEncRatedContent/enDeCrypt"

# Verify the enDeCrypt directory exists
if [ ! -d "$ENDECRYPT_DIR" ]; then
    echo "Error: enDeCrypt directory not found at: $ENDECRYPT_DIR" >&2
    echo "Please check your installation or reinstall the enDeCrypt system." >&2
    exit 1
fi

# Path to the view manifest script
VIEW_MANIFEST_SCRIPT="$ENDECRYPT_DIR/view_manifest.pl"

# Verify the script exists
if [ ! -f "$VIEW_MANIFEST_SCRIPT" ]; then
    echo "Error: view_manifest.pl not found at: $VIEW_MANIFEST_SCRIPT" >&2
    echo "Please check your installation or reinstall the enDeCrypt system." >&2
    exit 1
fi

# Execute the Perl script with all arguments passed through
exec perl "$VIEW_MANIFEST_SCRIPT" "$@"
