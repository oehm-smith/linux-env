#!/bin/bash

# Read JSON input from stdin
input=$(cat)

# Debug: Log the actual input to see what data we're receiving
echo "=== STATUSLINE DEBUG $(date) ===" >> /tmp/statusline-debug.log
echo "$input" | jq '.' >> /tmp/statusline-debug.log 2>&1
echo "" >> /tmp/statusline-debug.log

# Extract Claude Code metadata
model_display=$(echo "$input" | jq -r '.model.display_name')
model_id=$(echo "$input" | jq -r '.model.id')
output_style=$(echo "$input" | jq -r 'if .output_style | type == "string" then .output_style elif .output_style.name then .output_style.name else "default" end')
cwd=$(echo "$input" | jq -r '.workspace.current_dir')
project_dir=$(echo "$input" | jq -r '.workspace.project_dir')
version=$(echo "$input" | jq -r '.version')

# Extract cost information
cost_usd=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')
duration_ms=$(echo "$input" | jq -r '.cost.total_duration_ms // 0')
lines_added=$(echo "$input" | jq -r '.cost.total_lines_added // 0')
lines_removed=$(echo "$input" | jq -r '.cost.total_lines_removed // 0')

# Extract transcript path to get token usage
transcript_path=$(echo "$input" | jq -r '.transcript_path // empty')

# Try to get token usage from transcript file
tokens_used=0
tokens_total=200000  # Default for most Claude models

echo "Transcript path: $transcript_path" >> /tmp/statusline-debug.log

if [ -f "$transcript_path" ]; then
    echo "Transcript file exists" >> /tmp/statusline-debug.log
    # Parse JSONL transcript for ACTUAL context token usage
    # File is JSON Lines format - each line is a separate JSON object
    # Only sum: input_tokens + output_tokens (actual context, not cache)
    tokens_data=$(jq -s '[.[] | select(.message.usage != null) | .message.usage | (.input_tokens // 0) + (.output_tokens // 0)] | add // 0' "$transcript_path" 2>/dev/null)
    echo "Tokens data (actual context): $tokens_data" >> /tmp/statusline-debug.log
    if [ "$tokens_data" != "0" ] && [ -n "$tokens_data" ]; then
        tokens_used=$tokens_data
    fi
else
    echo "Transcript file NOT found" >> /tmp/statusline-debug.log
fi

echo "Final tokens_used: $tokens_used, tokens_total: $tokens_total" >> /tmp/statusline-debug.log
echo "Cost: $cost_usd, Lines: +$lines_added/-$lines_removed" >> /tmp/statusline-debug.log

# Get username (matching ZSH %n)
username=$(whoami)

# Get current time (matching ZSH %*)
current_time=$(date +%H:%M:%S)

# Format token numbers with comma separators
format_number() {
    printf "%'d" "$1" 2>/dev/null || echo "$1"
}

# Build token and cost display string
info_display=""

# Add token usage if available
if [ "$tokens_used" != "0" ] && [ "$tokens_total" != "0" ]; then
    # Format numbers with commas
    used_formatted=$(format_number "$tokens_used")
    total_formatted=$(format_number "$tokens_total")

    # Calculate percentage
    percentage=$((tokens_used * 100 / tokens_total))

    info_display=" ${used_formatted}/${total_formatted} (${percentage}%)"
fi

# Add cost if available
if [ "$cost_usd" != "0" ] && [ "$cost_usd" != "null" ] && [ "$cost_usd" != "0.0" ]; then
    # Add separator if we already have token info
    if [ -n "$info_display" ]; then
        info_display="${info_display} •"
    fi

    info_display="${info_display} \$$(printf "%.4f" "$cost_usd")"
fi

# Add lines changed if available
if [ "$lines_added" != "0" ] || [ "$lines_removed" != "0" ]; then
    if [ -n "$info_display" ]; then
        info_display="${info_display} •"
    fi
    info_display="${info_display} +${lines_added}/-${lines_removed}"
fi

# Simplify model name for display
model_short="$model_display"
if [[ "$model_display" == *"Sonnet"* ]]; then
    model_short=$(echo "$model_display" | sed -E 's/Claude ([0-9.]+) Sonnet/Sonnet \1/')
elif [[ "$model_display" == *"Opus"* ]]; then
    model_short=$(echo "$model_display" | sed -E 's/Claude ([0-9.]+) Opus/Opus \1/')
elif [[ "$model_display" == *"Haiku"* ]]; then
    model_short=$(echo "$model_display" | sed -E 's/Claude ([0-9.]+) Haiku/Haiku \1/')
fi

# Get directory name (matching ZSH %c)
dir=$(basename "$cwd")

# Get git information if in a git repository
git_branch=""
git_dirty=""
if git -C "$cwd" rev-parse --git-dir >/dev/null 2>&1; then
    git_branch=$(git -C "$cwd" branch --show-current 2>/dev/null || echo "detached")

    # Check if repository is dirty
    if git -C "$cwd" status --porcelain 2>/dev/null | grep -q .; then
        git_dirty="*"
    fi
fi

# Build status line matching philips theme
# Format: username:dir/ (git) [Model tokens/cost/lines | Style: style] [time]
if [ -n "$git_branch" ]; then
    printf "\033[32;1m%s\033[0m:\033[34;1m%s/\033[0m \033[1;34m(\033[0;31m\033[1m%s%s\033[0m\033[1;34m)\033[0m \033[35;1m[%s\033[0;32m%s\033[0m \033[2m|\033[0m \033[36mStyle:\033[0m \033[33m%s\033[35;1m]\033[0m \033[2m[%s]\033[0m\n" \
        "$username" "$dir" "$git_branch" "$git_dirty" "$model_short" "$info_display" "$output_style" "$current_time"
else
    printf "\033[32;1m%s\033[0m:\033[34;1m%s/\033[0m \033[35;1m[%s\033[0;32m%s\033[0m \033[2m|\033[0m \033[36mStyle:\033[0m \033[33m%s\033[35;1m]\033[0m \033[2m[%s]\033[0m\n" \
        "$username" "$dir" "$model_short" "$info_display" "$output_style" "$current_time"
fi