#!/bin/bash

# Check if an input file was provided
if [ -z "$1" ]; then
    echo "Error: No input file specified."
    echo "Usage: $0 input_video_file"
    exit 1
fi

# Check if the input file exists
if [ ! -f "$1" ]; then
    echo "Error: File '$1' not found."
    exit 1
fi

# Get the filename without extension
filename=$(basename -- "$1")
name="${filename%.*}"

# Create output filename with _rotated suffix and .mp4 extension
output="${name}_rotated.mp4"

# Inform user
echo "Converting $1 to $output..."

# Run ffmpeg to rotate the video
ffmpeg -i "$1" -vf "transpose=1" -c:v libx264 -preset medium -c:a aac "$output"

# Check if conversion was successful
if [ $? -eq 0 ]; then
    echo "Conversion completed successfully."
    echo "Output file: $output"
else
    echo "Error: Conversion failed."
fi
