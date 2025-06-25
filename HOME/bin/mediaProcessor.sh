#!/bin/bash
#
# mediaProcessor.sh - Wrapper script for media_file_processor.pl
#
# This wrapper sets up the proper Perl module path and calls the media file processor
# with all passed arguments. It ensures the MediaFileProcessor.pm module can be found.
# Template field /Users/brooke/CloudStation/Dev/amnesia/2025-06-18_selectEncRatedContent/mediaFileProcessor will be replaced during installation.
#

# Get the directory where the mediaFileProcessor scripts are located (set during installation)
SCRIPT_DIR="/Users/brooke/CloudStation/Dev/amnesia/2025-06-18_selectEncRatedContent/mediaFileProcessor"

# Verify the script directory exists
if [ ! -d "$SCRIPT_DIR" ]; then
    echo "Error: mediaFileProcessor directory not found at: $SCRIPT_DIR" >&2
    echo "Please check your installation or reinstall the mediaFileProcessor system." >&2
    exit 1
fi

# Set the path to the mediaFileProcessor directory
PROCESSOR_DIR="$SCRIPT_DIR"

# Verify the main script exists
PROCESSOR_SCRIPT="$PROCESSOR_DIR/media_file_processor.pl"
if [ ! -f "$PROCESSOR_SCRIPT" ]; then
    echo "Error: Cannot find media_file_processor.pl at: $PROCESSOR_SCRIPT" >&2
    echo "Please verify the script is in the correct location." >&2
    exit 1
fi

# Verify MediaFileProcessor.pm exists
PROCESSOR_MODULE="$PROCESSOR_DIR/MediaFileProcessor.pm"
if [ ! -f "$PROCESSOR_MODULE" ]; then
    echo "Error: Cannot find MediaFileProcessor.pm at: $PROCESSOR_MODULE" >&2
    echo "Please verify the module is in the correct location." >&2
    exit 1
fi

# Set PERL5LIB to include the mediaFileProcessor directory
export PERL5LIB="$PROCESSOR_DIR:$PERL5LIB"

# Execute the actual Perl script with all arguments passed through
exec perl "$PROCESSOR_SCRIPT" "$@"