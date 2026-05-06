#!/bin/bash
# ABOUTME: PreToolUse hook that blocks HEREDOCs in Bash commands
# ABOUTME: HEREDOCs break Claude Code permission matching and are harder to review

set -euo pipefail

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty' 2>/dev/null)

[ -z "$COMMAND" ] && exit 0

if echo "$COMMAND" | grep -qE '<<\s*-?\s*['\''"]?EOF|<<\s*-?\s*['\''"]?END|<<\s*-?\s*['\''"]?HEREDOC|<<\s*-?\s*['\''"]?DOC'; then
    echo "" >&2
    echo "======================================" >&2
    echo " BLOCKED: HEREDOC detected" >&2
    echo "======================================" >&2
    echo "Use -m flags for commits, inline" >&2
    echo "strings for arguments instead." >&2
    echo "======================================" >&2
    exit 2
fi

exit 0
