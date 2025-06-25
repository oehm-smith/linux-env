#!/bin/bash
#
# encryptFiles.sh - Wrapper script for encryptFiles.pl
#
# This wrapper calls the Perl encryption script with proper path resolution.
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

# Path to the encryption script
ENCRYPT_SCRIPT="$ENDECRYPT_DIR/encryptFiles.pl"

# Verify the encryption script exists
if [ ! -f "$ENCRYPT_SCRIPT" ]; then
    echo "Error: encryptFiles.pl not found at: $ENCRYPT_SCRIPT" >&2
    echo "Please check your enDeCrypt installation." >&2
    exit 1
fi

# Set PERL5LIB to include the enDeCrypt directory for module resolution
export PERL5LIB="$ENDECRYPT_DIR:$PERL5LIB"

# Execute the Perl script with all arguments passed through
exec perl "$ENCRYPT_SCRIPT" "$@"