#!/bin/bash

# --- File Organization Script ---
# This script organizes fragmented files with a .partA-N suffix into new directories
# based on their base filename. It handles the newest file by monitoring its size
# to ensure incomplete transfers are finished.

# Exit immediately if a command exits with a non-zero status.
set -e

# --- Function to display usage ---
usage() {
  echo "Usage: $0 <directory>"
  echo "Organizes fragmented files (*.part*) into subdirectories."
  echo "The script will skip the most recently modified file and monitor its size until it has been stable for 30 seconds before processing it."
  exit 1
}

# --- Main Script Logic ---

# Check if a directory was provided as an argument.
if [ -z "$1" ]; then
  usage
fi

# Store the target directory.
TARGET_DIR="$1"

# Check if the directory exists.
if [ ! -d "$TARGET_DIR" ]; then
  echo "Error: Directory '$TARGET_DIR' not found."
  exit 1
fi

echo "Starting organization of files in: '$TARGET_DIR'..."

# A more portable way to find the newest file.
NEWEST_FILE=$(find "$TARGET_DIR" -maxdepth 1 -type f -name "*.part*" -print0 2>/dev/null | xargs -0 ls -t | head -n 1)

# Check if any files were found.
if [ -z "$NEWEST_FILE" ]; then
  echo "No fragmented files found. Exiting."
  exit 0
fi

echo "Identified the newest file, skipping for now to allow for transfer completion:"
echo "$NEWEST_FILE"

# Process all fragmented files except the newest one.
find "$TARGET_DIR" -maxdepth 1 -type f -name "*.part*" -not -path "$NEWEST_FILE" -print0 | while read -d '' file; do
  # Extract the base filename by removing the .part* suffix.
  base_name=$(basename "$file")
  dir_name="${base_name%%.part*}"

  # Define the full path for the new directory.
  new_dir="$TARGET_DIR/_$dir_name"

  # Create the new directory if it doesn't exist.
  if [ ! -d "$new_dir" ]; then
    echo "Creating directory: '$new_dir'"
    mkdir -p "$new_dir"
  fi

  # Move the file into the new directory.
  echo "Moving '$file' to '$new_dir/'"
  mv "$file" "$new_dir/"
done

# Now, handle the newest file with size-based monitoring.
echo "---"
echo "Initial processing complete. Monitoring the newest file for transfer completion..."

# Define polling interval and stability threshold
POLL_INTERVAL=5
INACTIVITY_THRESHOLD=15
stable_time=0
last_size=$(stat -f%z "$NEWEST_FILE" 2>/dev/null || echo "0")

# Loop to watch for size changes
while [ "$stable_time" -lt "$INACTIVITY_THRESHOLD" ]; do
  echo -n "."
  sleep "$POLL_INTERVAL"
  current_size=$(stat -f%z "$NEWEST_FILE" 2>/dev/null || echo "0")

  if [ "$current_size" -eq "$last_size" ]; then
    stable_time=$((stable_time + POLL_INTERVAL))
  else
    # Reset the stability counter if the size changes
    stable_time=0
    last_size="$current_size"
  fi
done

echo " Waited for $stable_time seconds, file size is stable. Continuing."

# Check if the file still exists and has a .part* extension before proceeding.
if [[ -f "$NEWEST_FILE" && "$NEWEST_FILE" == *.part* ]]; then
  base_name=$(basename "$NEWEST_FILE")
  dir_name="${base_name%%.part*}"
  new_dir="$TARGET_DIR/_$dir_name"

  # Create the directory if it doesn't exist.
  if [ ! -d "$new_dir" ]; then
    echo "Creating directory: '$new_dir'"
    mkdir -p "$new_dir"
  fi

  # Move the file into the new directory.
  echo "Moving '$NEWEST_FILE' to '$new_dir/'"
  mv "$NEWEST_FILE" "$new_dir/"
else
  echo "The newest file no longer exists or has been renamed. Skipping."
fi

echo "---"
echo "All done! Files have been organized."

