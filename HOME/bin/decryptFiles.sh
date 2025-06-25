#!/bin/bash
#
# decryptFiles.sh - Wrapper script for decryptFiles.pl
#
# This wrapper calls the Perl decryption script with proper path resolution.
# Template field /Users/brooke/CloudStation/Dev/amnesia/2025-06-18_selectEncRatedContent/enDeCrypt will be replaced during installation.
#

# Path to enDeCrypt directory (set during installation)
ENDECRYPT_DIR="/Users/brooke/CloudStation/Dev/amnesia/2025-06-18_selectEncRatedContent/enDeCrypt"

# Verify the enDeCrypt directory exists
if [ ! -d "$ENDECRYPT_DIR" ]; then
    echo "Error: enDeCrypt directory not found at: $ENDECRYPT_DIR" >&2
    echo "Please check your installation or reinstall the enDeCrypt system." >&2
    exit 1
fi

# Path to the decryption script
DECRYPT_SCRIPT="$ENDECRYPT_DIR/decryptFiles.pl"

# Verify the decryption script exists
if [ ! -f "$DECRYPT_SCRIPT" ]; then
    echo "Error: decryptFiles.pl not found at: $DECRYPT_SCRIPT" >&2
    echo "Please check your enDeCrypt installation." >&2
    exit 1
fi

# Set PERL5LIB to include the enDeCrypt directory for module resolution
export PERL5LIB="$ENDECRYPT_DIR:$PERL5LIB"

# Execute the Perl script with all arguments passed through
exec perl "$DECRYPT_SCRIPT" "$@"