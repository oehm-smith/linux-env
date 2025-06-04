#!/bin/bash

# Function to display help message
show_help() {
    echo "Navigation:"
    echo "  Up Arrow    - Previous file (wraps to last if at first)"
    echo "  Down Arrow  - Next file (wraps to first if at last)"
    echo "  Ctrl+C      - Exit the viewer"
    echo "  h           - Show this help message"
    echo ""
    echo "Supports image files (displayed with imgcat) and video files (played with ffplay)"
}
# Function to get terminal dimensions and determine which parameter to use
get_terminal_dimensions() {
    # Get terminal width and height
    if command -v tput &>/dev/null; then
        TERM_WIDTH=$(tput cols)
        TERM_HEIGHT=$(tput lines)
    else
        # Fallback if tput is not available
        TERM_WIDTH=80
        TERM_HEIGHT=24
    fi
    
    # Adjust height to account for status line and prompt
    TERM_HEIGHT=$((TERM_HEIGHT - 3))
    
    # Determine which dimension is relatively smaller
    # tput cols and tput lines have a 1:2 ratio, so we need to adjust
    # Double the width for comparison
    ADJUSTED_WIDTH=$((TERM_WIDTH * 2))
    
    if [ $ADJUSTED_WIDTH -le $TERM_HEIGHT ]; then
        # Width is relatively smaller, use --width
        IMG_PARAM="--width"
        IMG_VALUE="$TERM_WIDTH"
    else
        # Height is relatively smaller, use --height
        IMG_PARAM="--height"
        IMG_VALUE="$TERM_HEIGHT"
    fi
}

# Function to detect OS and display image accordingly
display_image_with_viewer() {
    local image_file="$1"
    
    # Get terminal dimensions and determine parameter
    get_terminal_dimensions
    
    # Detect OS
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS - use imgcat with appropriate parameter based on terminal dimensions
        imgcat "$IMG_PARAM" "$IMG_VALUE" "$image_file"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux - check for GNOME and use eog (Eye of GNOME)
        if [ -n "$GNOME_DESKTOP_SESSION_ID" ] || [ "$XDG_CURRENT_DESKTOP" == "GNOME" ] || [ "$XDG_CURRENT_DESKTOP" == *"GNOME"* ]; then
            # Use eog in background mode so script continues
            eog "$image_file" &>/dev/null &
        else
            # Fallback for other Linux environments - try display from ImageMagick
            if command -v display &>/dev/null; then
                display "$image_file" &>/dev/null &
            elif command -v feh &>/dev/null; then
                feh "$image_file" &>/dev/null &
            elif command -v xdg-open &>/dev/null; then
                xdg-open "$image_file" &>/dev/null &
            else
                echo "No suitable image viewer found. Please install eog, ImageMagick, feh, or another image viewer."
                echo "Filename: $image_file"
            fi
        fi
    else
        # Unknown OS - just show filename
        echo "Unknown OS. Cannot display image directly."
        echo "Filename: $image_file"
    fi
}

# Check if arguments are being passed to the original imgcatshow.sh functionality
if [ "$1" = "--display-only" ]; then
    # This is the actual image display functionality
    shift
    display_image_with_viewer "$1"
    exit 0
fi

# Check if any arguments were provided
if [ $# -eq 0 ]; then
    echo "Error: No image files provided."
    echo "Usage: $0 image1 [image2 ...]"
    exit 1
fi

# Store all image files in an array
image_files=("$@")
total_images=${#image_files[@]}
current_index=0
last_viewed="${image_files[0]}"

# Function to display the current image
display_image() {
    clear
    echo "Image $((current_index+1))/$total_images: ${image_files[$current_index]}"
    # Call this script with the --display-only flag to avoid recursion
    "$0" --display-only "${image_files[$current_index]}"
    last_viewed="${image_files[$current_index]}"
}

# Function to check if a file is a video
is_video() {
    local file="$1"
    local extension="${file##*.}"
    extension="${extension,,}" # Convert to lowercase

    # List of common video extensions
    local video_extensions=("mp4" "avi" "mkv" "mov" "wmv" "flv" "webm" "mpg" "mpeg" "m4v")

    for ext in "${video_extensions[@]}"; do
        if [[ "$extension" == "$ext" ]]; then
            return 0 # True, it is a video
        fi
    done

    return 1 # False, it is not a video
}

# Function to display/play a file based on its type
display_file() {
    local file="$1"

    # Check if the file is a video
    if is_video "$file"; then
        # Play video with ffplay
        if command -v ffplay &>/dev/null; then
            # Use ffplay with minimal interface and exit when done
            ffplay -autoexit -loglevel quiet -nodisp -hide_banner "$file" &
            FFPLAY_PID=$!
            echo "Playing video: $file (press q to stop)"
            # Wait for ffplay to finish or user to continue
            wait $FFPLAY_PID 2>/dev/null || true
            # If ffplay is still running, kill it
            if kill -0 $FFPLAY_PID 2>/dev/null; then
                kill $FFPLAY_PID 2>/dev/null || true
            fi
        else
            echo "ffplay not found. Please install ffmpeg to play videos."
            echo "Video file: $file"
        fi
    else
        # Display image with imgcat or alternative viewers
        display_image_with_viewer "$file"
    fi
}

# Function to display help and wait for any key to continue
display_help() {
    echo ""
    show_help
    echo ""
    echo "Press any key to continue..."
    read -rsn1
    display_image
}

# Function to go to previous image
previous_image() {
    ((current_index--))
    if [ $current_index -lt 0 ]; then
        current_index=$((total_images-1))
    fi
    display_image
}

# Function to go to next image
next_image() {
    ((current_index++))
    if [ $current_index -ge $total_images ]; then
        current_index=0
    fi
    display_image
}

# Set up trap to show last viewed image on exit
trap 'echo "Last viewed image: $last_viewed"' EXIT

# Initial display
display_image

# Process keyboard input
while true; do
    # Use a simpler approach that works more reliably across different terminals
    read -rsn1
    
    # Check for escape sequence (arrow keys)
    if [[ $REPLY == $'\e' ]]; then
        read -rsn2
        
        # Process arrow keys
        if [[ $REPLY == "[A" ]]; then
            # Up arrow
            previous_image
        elif [[ $REPLY == "[B" ]]; then
            # Down arrow
            next_image
        fi
    elif [[ $REPLY == "q" ]]; then
        # q key - can be used to stop video playback or exit
        # If we're displaying a video, this will just return to the loop
        # Otherwise, we'll exit
        if ! is_video "${all_files[$current_index]}"; then
            echo "Exiting..."
            exit 0
        fi
    elif [[ $REPLY == "h" ]]; then
        # h key
        display_help
    fi
done
