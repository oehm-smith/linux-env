#!/bin/bash
# ABOUTME: Post-install hook for Claude Code — runs audit after package installs
# ABOUTME: Runs as a PostToolUse hook on Bash commands, warns about vulnerabilities

set -euo pipefail

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty' 2>/dev/null)
CWD=$(echo "$INPUT" | jq -r '.cwd // empty' 2>/dev/null)

# Exit immediately if not an install command
if ! echo "$COMMAND" | grep -qE '(npm (install|i |add )|pnpm (install|add |i )|pip install |uv (add |pip install ))'; then
    exit 0
fi

cd "$CWD" 2>/dev/null || exit 0

echo ""

# Detect and run appropriate audit
if echo "$COMMAND" | grep -qE '^(npm|pnpm) '; then
    MANAGER="npm"
    echo "$COMMAND" | grep -q '^pnpm' && MANAGER="pnpm"

    echo "Running $MANAGER audit after install..."
    if [ "$MANAGER" = "pnpm" ]; then
        pnpm audit --no-color 2>&1 | tail -20 || true
    else
        npm audit --no-color 2>&1 | tail -20 || true
    fi

elif echo "$COMMAND" | grep -qE '^uv (add|pip install)'; then
    echo "Running uv audit after install..."
    uv audit 2>&1 | tail -20 || true

elif echo "$COMMAND" | grep -qE '^pip3? install'; then
    if command -v pip-audit &>/dev/null; then
        echo "Running pip-audit after install..."
        pip-audit 2>&1 | tail -20 || true
    elif command -v uv &>/dev/null; then
        echo "Running uv audit after install..."
        uv audit 2>&1 | tail -20 || true
    else
        echo "Note: Install pip-audit or uv for automatic vulnerability scanning after pip installs."
    fi
fi

# PostToolUse hooks cannot block, so always exit 0
exit 0
