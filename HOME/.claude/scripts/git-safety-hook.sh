#!/bin/bash
# ABOUTME: PreToolUse hook enforcing git safety rules that must never be violated
# ABOUTME: Blocks: commit on main/master, git add -A, --no-verify, force push to main

set -euo pipefail

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty' 2>/dev/null)

[ -z "$COMMAND" ] && exit 0

# Extract just the git subcommand: first command in chain, strip -m message content
GIT_CMD=$(echo "$COMMAND" | sed 's/\s*&&.*//;s/\s*||.*//;s/\s*;.*//')
# For commit commands, extract only the portion before first -m flag
GIT_CMD_FLAGS=$(echo "$GIT_CMD" | sed 's/ -m .*//')

# --- Block commit on main/master ---
if echo "$GIT_CMD" | grep -qE '^git\s+(-C\s+\S+\s+)?commit'; then
    REPO_DIR="."
    if echo "$GIT_CMD" | grep -qE 'git\s+-C\s+'; then
        REPO_DIR=$(echo "$GIT_CMD" | grep -oE '\-C\s+\S+' | head -1 | awk '{print $2}')
    fi
    BRANCH=$(git -C "$REPO_DIR" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")
    if [ "$BRANCH" = "main" ] || [ "$BRANCH" = "master" ]; then
        echo "" >&2
        echo "======================================" >&2
        echo " BLOCKED: Commit on $BRANCH" >&2
        echo "======================================" >&2
        echo "You are on the $BRANCH branch." >&2
        echo "Create a feature branch first." >&2
        echo "======================================" >&2
        exit 2
    fi
    # Check --no-verify in flags only (before -m messages)
    if echo "$GIT_CMD_FLAGS" | grep -qE '\-\-no-verify'; then
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
if echo "$GIT_CMD" | grep -qE '^git\s+(-C\s+\S+\s+)?add\s+(-A|--all|\.)(\s|$)'; then
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
if echo "$GIT_CMD" | grep -qE '^git\s+(-C\s+\S+\s+)?push'; then
    if echo "$GIT_CMD" | grep -qE '(\-\-force|-f\b)' && echo "$GIT_CMD" | grep -qE '\b(main|master)\b'; then
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

exit 0
