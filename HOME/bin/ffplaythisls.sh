#!/bin/bash
#
# ffplaythisls.sh - Wrapper script for video playlist playback
#
# This wrapper manages a playlist of video files with navigation controls.
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

VIDEO_EXTS="mp4 mkv avi mov wmv flv webm m4v 3gp mpg mpeg ts m2ts mts vob ogv"

display_filename() {
    local filename="$1"
    local current="$2"
    local total="$3"
    
    clear
    echo -e "\033[1;31m\033[2J\033[H"
    echo -e "\033[1;31m\033[1m"
    echo "===================================="
    echo "($current/$total): $filename"
    echo "===================================="
    echo -e "\033[0m"
}

get_video_files() {
    local find_pattern=""
    for ext in $VIDEO_EXTS; do
        if [ -n "$find_pattern" ]; then
            find_pattern="$find_pattern -o"
        fi
        find_pattern="$find_pattern -iname \"*.$ext\""
    done
    
    eval "find . -maxdepth 1 -type f \\( $find_pattern \\) | sort -r" | while read -r file; do
        echo "${file#./}"
    done
}

# Check if video files were provided as arguments
if [ $# -gt 0 ]; then
    # Use provided video files as the playlist
    VIDEO_FILES=("$@")
    
    # Validate that all provided files exist and are video files
    VALID_FILES=()
    for file in "${VIDEO_FILES[@]}"; do
        if [ ! -f "$file" ]; then
            echo "Warning: File '$file' not found, skipping."
            continue
        fi
        
        # Check if file has a video extension
        extension="${file##*.}"
        extension="${extension,,}" # Convert to lowercase
        is_video=false
        for ext in $VIDEO_EXTS; do
            if [ "$extension" = "$ext" ]; then
                is_video=true
                break
            fi
        done
        
        if [ "$is_video" = true ]; then
            VALID_FILES+=("$file")
        else
            echo "Warning: '$file' doesn't appear to be a video file, skipping."
        fi
    done
    
    VIDEO_FILES=("${VALID_FILES[@]}")
    
    if [ ${#VIDEO_FILES[@]} -eq 0 ]; then
        echo "No valid video files provided as arguments."
        echo "Supported formats: $VIDEO_EXTS"
        exit 1
    fi
    
    echo "Using provided video files as playlist:"
    for i in "${!VIDEO_FILES[@]}"; do
        echo "  [$i] = '${VIDEO_FILES[$i]}'"
    done
    echo ""
else
    # No arguments provided, scan current directory for video files
    VIDEO_FILES=()
    while IFS= read -r file; do
        VIDEO_FILES+=("$file")
    done < <(get_video_files)
    
    if [ ${#VIDEO_FILES[@]} -eq 0 ]; then
        echo "No video files found in current directory."
        echo "Supported formats: $VIDEO_EXTS"
        echo ""
        echo "Usage: $0 [video_file1] [video_file2] ..."
        echo "   or: $0  (to scan current directory)"
        exit 1
    fi
    
    echo "DEBUG: Video files found in current directory (in reverse alphabetical order):"
    for i in "${!VIDEO_FILES[@]}"; do
        echo "DEBUG: [$i] = '${VIDEO_FILES[$i]}'"
    done
    echo "DEBUG: Total: ${#VIDEO_FILES[@]} files"
    echo ""
fi

CURRENT_INDEX=0
TOTAL_FILES=${#VIDEO_FILES[@]}
LAST_PLAYED_INDEX=-1
FFPLAY_SCRIPT="$INSTALL_DIR/ffplay.sh"

while true; do
    CURRENT_FILE="${VIDEO_FILES[$CURRENT_INDEX]}"
    display_filename "$CURRENT_FILE" $((CURRENT_INDEX + 1)) $TOTAL_FILES
    
    if [ $LAST_PLAYED_INDEX -eq -1 ]; then
        echo "Starting playlist..."
        sleep 1
        if [ -f "$FFPLAY_SCRIPT" ]; then
            "$FFPLAY_SCRIPT" "$CURRENT_FILE" 2>&1 | grep -E "^ {0,5}(Screen|Video|Horizontal|Vertical|Playing|Duration)"
        else
            echo "Error: ffplay.sh not found at: $FFPLAY_SCRIPT"
            exit 1
        fi
        LAST_PLAYED_INDEX=$CURRENT_INDEX
        while read -r -t 0; do read -r; done
        sleep 0.5
        continue
    fi
    
    echo ""
    echo -e "\033[1;33m"
    echo "Controls:"
    echo "  SPACE or DOWN ARROW: Next video"
    echo "  UP ARROW: Previous video"
    echo "  ENTER: Play current video"
    echo "  r: Replay last played video"
    echo "  q: Quit"
    echo -e "\033[0m"
    echo ""
    echo "What next?"
    
    while read -r -t 0; do read -r; done
    read -n 1 -s key
    
    # Quit
    if [ "$key" = "q" ]; then
        echo "Exiting..."
        exit 0
    fi
    if [ "$key" = "Q" ]; then
        echo "Exiting..."
        exit 0
    fi
    
    # Arrow keys
    if [ "$key" = $'\x1b' ]; then
        read -n 2 -s -t 0.1 remainder
        if [ "$remainder" = "[A" ]; then
            if [ $CURRENT_INDEX -gt 0 ]; then
                CURRENT_INDEX=$((CURRENT_INDEX - 1))
            else
                echo "Already at first video."
                sleep 1
            fi
            continue
        fi
        if [ "$remainder" = "[B" ]; then
            if [ $CURRENT_INDEX -lt $((TOTAL_FILES - 1)) ]; then
                CURRENT_INDEX=$((CURRENT_INDEX + 1))
            else
                echo "Reached end of playlist."
                sleep 1
            fi
            continue
        fi
        continue
    fi
    
    # Space bar
    if [ "$key" = " " ]; then
        if [ $CURRENT_INDEX -lt $((TOTAL_FILES - 1)) ]; then
            CURRENT_INDEX=$((CURRENT_INDEX + 1))
            PLAY_FILE="${VIDEO_FILES[$CURRENT_INDEX]}"
            if [ -f "$FFPLAY_SCRIPT" ]; then
                "$FFPLAY_SCRIPT" "$PLAY_FILE" 2>&1 | grep -E "^ {0,5}(Screen|Video|Horizontal|Vertical|Playing|Duration)"
            fi
            LAST_PLAYED_INDEX=$CURRENT_INDEX
            while read -r -t 0; do read -r; done
            sleep 0.5
            # Continue to next iteration to show updated display
            continue
        else
            echo "Reached end of playlist."
            sleep 1
        fi
        continue
    fi
    
    # Replay
    if [ "$key" = "r" ]; then
        PLAY_FILE="${VIDEO_FILES[$LAST_PLAYED_INDEX]}"
        if [ -f "$FFPLAY_SCRIPT" ]; then
            "$FFPLAY_SCRIPT" "$PLAY_FILE" 2>&1 | grep -E "^ {0,5}(Screen|Video|Horizontal|Vertical|Playing|Duration)"
        fi
        while read -r -t 0; do read -r; done
        sleep 0.5
        continue
    fi
    if [ "$key" = "R" ]; then
        PLAY_FILE="${VIDEO_FILES[$LAST_PLAYED_INDEX]}"
        if [ -f "$FFPLAY_SCRIPT" ]; then
            "$FFPLAY_SCRIPT" "$PLAY_FILE" 2>&1 | grep -E "^ {0,5}(Screen|Video|Horizontal|Vertical|Playing|Duration)"
        fi
        while read -r -t 0; do read -r; done
        sleep 0.5
        continue
    fi
    
    # Enter or any other key - play current
    PLAY_FILE="${VIDEO_FILES[$CURRENT_INDEX]}"
    if [ -f "$FFPLAY_SCRIPT" ]; then
        "$FFPLAY_SCRIPT" "$PLAY_FILE" 2>&1 | grep -E "^ {0,5}(Screen|Video|Horizontal|Vertical|Playing|Duration)"
    fi
    LAST_PLAYED_INDEX=$CURRENT_INDEX
    # After playing with Enter, advance to next video for display
    if [ $CURRENT_INDEX -lt $((TOTAL_FILES - 1)) ]; then
        CURRENT_INDEX=$((CURRENT_INDEX + 1))
    fi
    while read -r -t 0; do read -r; done
    sleep 0.5
done
