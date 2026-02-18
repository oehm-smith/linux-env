#!/bin/bash
#
# debug_manifest.sh - Wrapper script for debug_manifest.pl
#
# This wrapper calls the Perl debug script with proper path resolution.
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

# Path to the debug script
DEBUG_SCRIPT="$ENDECRYPT_DIR/debug_manifest.pl"

# Verify the debug script exists
if [ ! -f "$DEBUG_SCRIPT" ]; then
    echo "Error: debug_manifest.pl not found at: $DEBUG_SCRIPT" >&2
    echo "Please check your enDeCrypt installation." >&2
    exit 1
fi

# Set PERL5LIB to include the enDeCrypt directory for module resolution
export PERL5LIB="$ENDECRYPT_DIR:$PERL5LIB"

# Execute the Perl script with all arguments passed through
exec perl "$DEBUG_SCRIPT" "$@"
