#!/bin/zsh

# find-recent-folders.sh
# Uses Spotlight (mdfind) to find recently modified directories system-wide.

# Default 'since' value in seconds (1 hour = 3600)
SINCE=${1:-3600}

# Help menu
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: ./find-recent-folders.sh [seconds]"
    echo "Example: ./find-recent-folders.sh 86400  (finds folders modified in the last day)"
    exit 0
fi

echo "Searching for folders modified in the last $SINCE seconds..."
echo "-----------------------------------------------------------"

# mdfind query
# -0: Use a null character as a separator (safely handles spaces in names)
# kMDItemContentType == "public.folder": Limits to directories
# xargs -0: Pairs with mdfind -0 to process paths correctly
mdfind -0 'kMDItemContentType == "public.folder" && kMDItemContentModificationDate >= "$time.now(-'$SINCE')"' | xargs -0 ls -ldT
