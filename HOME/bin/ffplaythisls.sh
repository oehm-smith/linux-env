#!/bin/bash

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

VIDEO_FILES=()
while IFS= read -r file; do
    VIDEO_FILES+=("$file")
done < <(get_video_files)

if [ ${#VIDEO_FILES[@]} -eq 0 ]; then
    echo "No video files found in current directory."
    echo "Supported formats: $VIDEO_EXTS"
    exit 1
fi

echo "DEBUG: Video files found (in reverse alphabetical order):"
for i in "${!VIDEO_FILES[@]}"; do
    echo "DEBUG: [$i] = '${VIDEO_FILES[$i]}'"
done
echo "DEBUG: Total: ${#VIDEO_FILES[@]} files"
echo ""

START_INDEX=0
if [ $# -gt 0 ]; then
    START_FILE="$1"
    for i in "${!VIDEO_FILES[@]}"; do
        if [ "${VIDEO_FILES[$i]}" = "$START_FILE" ]; then
            START_INDEX=$i
            break
        fi
    done
    
    if [ $START_INDEX -eq 0 ] && [ "${VIDEO_FILES[0]}" != "$START_FILE" ]; then
        echo "Warning: File '$START_FILE' not found in video list. Starting from beginning."
    fi
fi

CURRENT_INDEX=$START_INDEX
TOTAL_FILES=${#VIDEO_FILES[@]}
LAST_PLAYED_INDEX=-1
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FFPLAY_SCRIPT="$SCRIPT_DIR/ffplay.sh"

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
