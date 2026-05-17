#!/bin/bash
# ABOUTME: PreToolUse hook enforcing git safety rules that must never be violated
# ABOUTME: Blocks: commit on main/master, git add -A, --no-verify, force push to main

set -euo pipefail

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty' 2>/dev/null)

[ -z "$COMMAND" ] && exit 0

# Split chained commands (&&, ||, ;) and check each segment for git operations.
# This handles patterns like: cd /some/dir && git commit -m "msg"
# Track directory changes from cd/pushd commands in the chain
EFFECTIVE_DIR=""

check_git_segment() {
    local segment="$1"
    # Trim leading whitespace
    segment=$(echo "$segment" | sed 's/^[[:space:]]*//')

    # Track cd/pushd to know the effective working directory for git commands
    if echo "$segment" | grep -qE '^(cd|pushd)\s'; then
        EFFECTIVE_DIR=$(echo "$segment" | awk '{print $2}')
        return 0
    fi

    # Skip non-git commands
    echo "$segment" | grep -qE '^git\s' || return 0

    # For commit checks, strip -m message content to avoid false positives
    local flags_only
    flags_only=$(echo "$segment" | sed 's/ -m .*//')

    # --- Block commit on main/master ---
    if echo "$segment" | grep -qE '^git\s+(-C\s+\S+\s+)?commit'; then
        local repo_dir="${EFFECTIVE_DIR:-.}"
        if echo "$segment" | grep -qE 'git\s+-C\s+'; then
            repo_dir=$(echo "$segment" | grep -oE '\-C\s+\S+' | head -1 | awk '{print $2}')
        fi
        local branch
        branch=$(git -C "$repo_dir" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")
        if [ "$branch" = "main" ] || [ "$branch" = "master" ]; then
            echo "" >&2
            echo "======================================" >&2
            echo " BLOCKED: Commit on $branch" >&2
            echo "======================================" >&2
            echo "You are on the $branch branch." >&2
            echo "Create a feature branch first." >&2
            echo "======================================" >&2
            exit 2
        fi
        if echo "$flags_only" | grep -qE '\-\-no-verify'; then
            echo "" >&2
            echo "======================================" >&2
            echo " BLOCKED: --no-verify flag" >&2
            echo "======================================" >&2
            echo "Pre-commit hooks must not be skipped." >&2
            echo "======================================" >&2
            exit 2
        fi
    fi

    # --- Block git add -A / git add . ---
    if echo "$segment" | grep -qE '^git\s+(-C\s+\S+\s+)?add\s+(-A|--all|\.)(\s|$)'; then
        echo "" >&2
        echo "======================================" >&2
        echo " BLOCKED: git add -A / git add ." >&2
        echo "======================================" >&2
        echo "Use explicit file names instead." >&2
        echo "Run git status first, then add specific files." >&2
        echo "======================================" >&2
        exit 2
    fi

    # --- Block force push to main/master ---
    if echo "$segment" | grep -qE '^git\s+(-C\s+\S+\s+)?push'; then
        if echo "$segment" | grep -qE '(\-\-force|-f\b)' && echo "$segment" | grep -qE '\b(main|master)\b'; then
            echo "" >&2
            echo "======================================" >&2
            echo " BLOCKED: Force push to main/master" >&2
            echo "======================================" >&2
            echo "Force pushing to main/master is" >&2
            echo "destructive and irreversible." >&2
            echo "======================================" >&2
            exit 2
        fi
    fi
}

# Split on &&, ||, and ; then check each segment.
# Use process substitution to avoid subshell (so exit 2 terminates the script).
while IFS= read -r segment; do
    [ -z "$segment" ] && continue
    check_git_segment "$segment"
done < <(echo "$COMMAND" | sed 's/&&/\n/g;s/||/\n/g;s/;/\n/g')

exit 0
