#!/bin/bash
# ABOUTME: PostToolUse hook that warns when code files are written without ABOUTME headers
# ABOUTME: Checks Write and Edit tool results for missing file headers

set -euo pipefail

INPUT=$(cat)
TOOL=$(echo "$INPUT" | jq -r '.tool_name // empty' 2>/dev/null)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty' 2>/dev/null)

[ -z "$FILE_PATH" ] && exit 0

# Only check code files, skip configs/docs/data
case "$FILE_PATH" in
    *.ts|*.tsx|*.js|*.jsx|*.py|*.sh|*.bash|*.rb|*.go|*.rs|*.java|*.c|*.cpp|*.h|*.hpp|*.cs|*.swift|*.kt)
        ;;
    *)
        exit 0
        ;;
esac

# Skip if file doesn't exist yet (Write creates it)
[ ! -f "$FILE_PATH" ] && exit 0

# Check first 5 lines for ABOUTME
if ! head -5 "$FILE_PATH" | grep -q "ABOUTME:"; then
    echo "" >&2
    echo "⚠ Missing ABOUTME header in: $FILE_PATH" >&2
    echo "  Add a 2-line ABOUTME comment at the top." >&2
fi

# PostToolUse hooks can't block, just inform
exit 0
