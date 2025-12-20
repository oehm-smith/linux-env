#!/bin/bash

# This script keeps a temporary directory active by monitoring its size.
# If the size of the directory is 0, the script will exit.
# If the size of the directory is greater than 0, the script will sleep for 5 minutes.
# The script will repeat this process until the directory is deleted.

# Set default directory to current directory if no argument provided
TARGET_DIR="${1:-.}"

# Check if the directory exists
if [ ! -d "$TARGET_DIR" ]; then
    echo "Error: Directory '$TARGET_DIR' does not exist."
    exit 1
fi

echo "Monitoring directory: '$TARGET_DIR'"
echo "Press Ctrl+C to stop monitoring"

while true; do
    if [ -d "$TARGET_DIR" ]; then
        # Get directory size in KB
        dir_size=$(du -s "$TARGET_DIR" 2>/dev/null | awk '{print $1}')
        
        if [ "$dir_size" -eq 0 ]; then
            echo "Directory '$TARGET_DIR' is empty. Exiting."
            exit 0
        else
            echo "Directory '$TARGET_DIR' has ${dir_size}KB. Touching all files and directories to keep them active..."
            echo "Current time: $(date)"
            
            # Touch all files and directories recursively
            find "$TARGET_DIR" -type f -exec touch {} \; 2>/dev/null
            find "$TARGET_DIR" -type d -exec touch {} \; 2>/dev/null
            
            echo "Touched all files and directories. Sleeping for 5 minutes..."
            sleep 300
        fi
    else
        echo "Directory '$TARGET_DIR' no longer exists. Exiting."
        exit 0
    fi
done
    