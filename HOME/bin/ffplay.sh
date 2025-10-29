#!/bin/bash
#
# ffplay.sh - Wrapper script for video playback with optimal sizing
#
# This wrapper calls ffplay with calculated dimensions based on screen size.
# Template field /Users/brooke/dev/amnesia/2025-09-17_playback will be replaced during installation.
#

# Path to installation directory (set during installation)
INSTALL_DIR="/Users/brooke/dev/amnesia/2025-09-17_playback"

# Verify the installation directory exists
if [ ! -d "$INSTALL_DIR" ]; then
    echo "Error: Installation directory not found at: $INSTALL_DIR" >&2
    echo "Please check your installation or reinstall the system." >&2
    exit 1
fi

# Check if video file is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <video_file>"
    exit 1
fi

VIDEO_FILE="$1"

# Check if file exists
if [ ! -f "$VIDEO_FILE" ]; then
    echo "Error: File '$VIDEO_FILE' not found."
    exit 1
fi

# Get screen dimensions (macOS compatible)
if command -v osascript &> /dev/null; then
    # macOS method using AppleScript
    SCREEN_WIDTH=$(osascript -e 'tell application "Finder" to get bounds of window of desktop' | cut -d',' -f3 | tr -d ' ')
    SCREEN_HEIGHT=$(osascript -e 'tell application "Finder" to get bounds of window of desktop' | cut -d',' -f4 | tr -d ' ')
elif command -v xdpyinfo &> /dev/null; then
    # Linux method
    SCREEN_WIDTH=$(xdpyinfo | grep dimensions | awk '{print $2}' | cut -d'x' -f1)
    SCREEN_HEIGHT=$(xdpyinfo | grep dimensions | awk '{print $2}' | cut -d'x' -f2)
else
    # Fallback - assume common resolution
    echo "Warning: Cannot detect screen size, assuming 1920x1080"
    SCREEN_WIDTH=1920
    SCREEN_HEIGHT=1080
fi

# Validate screen dimensions
if [ -z "$SCREEN_WIDTH" ] || [ -z "$SCREEN_HEIGHT" ] || [ "$SCREEN_WIDTH" -le 0 ] || [ "$SCREEN_HEIGHT" -le 0 ]; then
    echo "Warning: Invalid screen dimensions detected, using fallback 1920x1080"
    SCREEN_WIDTH=1920
    SCREEN_HEIGHT=1080
fi

# Get video dimensions using ffprobe
VIDEO_INFO=$(ffprobe -v quiet -print_format csv=p=0 -select_streams v:0 -show_entries stream=width,height "$VIDEO_FILE")
VIDEO_WIDTH=$(echo "$VIDEO_INFO" | cut -d',' -f1)
VIDEO_HEIGHT=$(echo "$VIDEO_INFO" | cut -d',' -f2)

# Check if we got valid dimensions
if [ -z "$VIDEO_WIDTH" ] || [ -z "$VIDEO_HEIGHT" ] || [ "$VIDEO_WIDTH" -eq 0 ] || [ "$VIDEO_HEIGHT" -eq 0 ]; then
    echo "Error: Could not determine video dimensions."
    exit 1
fi

echo "Screen: ${SCREEN_WIDTH}x${SCREEN_HEIGHT}"
echo "Video: ${VIDEO_WIDTH}x${VIDEO_HEIGHT}"

# Calculate margins (leave space for window decorations and menu bar)
MARGIN=100
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS has a menu bar at the top, so leave more vertical margin
    VERTICAL_MARGIN=150
    HORIZONTAL_MARGIN=100
else
    VERTICAL_MARGIN=100
    HORIZONTAL_MARGIN=100
fi

# Determine if video is vertical or horizontal
if [ "$VIDEO_HEIGHT" -gt "$VIDEO_WIDTH" ]; then
    # Vertical video - maximize height
    PLAY_HEIGHT=$((SCREEN_HEIGHT - VERTICAL_MARGIN))
    PLAY_WIDTH=$((PLAY_HEIGHT * VIDEO_WIDTH / VIDEO_HEIGHT))
    echo "Vertical video detected - maximizing height"
    
    # Ensure width doesn't exceed screen width
    if [ "$PLAY_WIDTH" -gt $((SCREEN_WIDTH - HORIZONTAL_MARGIN)) ]; then
        PLAY_WIDTH=$((SCREEN_WIDTH - HORIZONTAL_MARGIN))
        PLAY_HEIGHT=$((PLAY_WIDTH * VIDEO_HEIGHT / VIDEO_WIDTH))
    fi
else
    # Horizontal video - maximize width
    PLAY_WIDTH=$((SCREEN_WIDTH - HORIZONTAL_MARGIN))
    PLAY_HEIGHT=$((PLAY_WIDTH * VIDEO_HEIGHT / VIDEO_WIDTH))
    echo "Horizontal video detected - maximizing width"
    
    # Ensure height doesn't exceed screen height
    if [ "$PLAY_HEIGHT" -gt $((SCREEN_HEIGHT - VERTICAL_MARGIN)) ]; then
        PLAY_HEIGHT=$((SCREEN_HEIGHT - VERTICAL_MARGIN))
        PLAY_WIDTH=$((PLAY_HEIGHT * VIDEO_WIDTH / VIDEO_HEIGHT))
    fi
fi

# Ensure minimum dimensions
if [ "$PLAY_WIDTH" -lt 100 ]; then
    PLAY_WIDTH=100
fi
if [ "$PLAY_HEIGHT" -lt 100 ]; then
    PLAY_HEIGHT=100
fi

echo "Playing at: ${PLAY_WIDTH}x${PLAY_HEIGHT}"

# Launch ffplay with calculated dimensions
ffplay -x "$PLAY_WIDTH" -y "$PLAY_HEIGHT" "$VIDEO_FILE"
