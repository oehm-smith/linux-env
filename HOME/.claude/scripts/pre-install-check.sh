#!/bin/bash
# ABOUTME: Pre-install hook for Claude Code — checks packages against known malicious list
# ABOUTME: Runs as a PreToolUse hook on Bash commands, blocks installs of known-bad packages

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BLOCKLIST="$SCRIPT_DIR/known-malicious-packages.txt"

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty' 2>/dev/null)

# Exit immediately if not an install command
if ! echo "$COMMAND" | grep -qE '(npm (install|i |add )|pnpm (install|add |i )|pip install |uv (add |pip install ))'; then
    exit 0
fi

# Extract package names from the command
extract_npm_packages() {
    # Strip flags (-D, --save-dev, -g, --global, etc.) and the install verb
    echo "$1" | sed -E 's/^(npm|pnpm) (install|add|i) //' | tr ' ' '\n' | grep -v '^-' | grep -v '^$' | sed 's/@.*//'
}

extract_pip_packages() {
    # Strip flags (-r, --upgrade, etc.) and the install verb
    echo "$1" | sed -E 's/^(pip|pip3|uv pip) install //' | sed -E 's/^uv add //' | tr ' ' '\n' | grep -v '^-' | grep -v '^$' | sed 's/[>=<].*//' | sed 's/\[.*//'
}

PACKAGES=""
if echo "$COMMAND" | grep -qE '^(npm|pnpm) '; then
    PACKAGES=$(extract_npm_packages "$COMMAND")
elif echo "$COMMAND" | grep -qE '^(pip|pip3|uv) '; then
    PACKAGES=$(extract_pip_packages "$COMMAND")
fi

# If no specific packages (bare npm install / pip install -r), skip name check
if [ -z "$PACKAGES" ]; then
    exit 0
fi

# Check blocklist
if [ ! -f "$BLOCKLIST" ]; then
    echo "Warning: blocklist not found at $BLOCKLIST" >&2
    exit 0
fi

BLOCKED=""
while IFS= read -r pkg; do
    [ -z "$pkg" ] && continue
    match=$(grep -i "^${pkg}$" "$BLOCKLIST" 2>/dev/null || true)
    if [ -n "$match" ]; then
        BLOCKED="${BLOCKED}  - ${pkg}\n"
    fi
done <<< "$PACKAGES"

if [ -n "$BLOCKED" ]; then
    echo "" >&2
    echo "========================================" >&2
    echo " BLOCKED: Known malicious package(s)" >&2
    echo "========================================" >&2
    echo -e "$BLOCKED" >&2
    echo "These packages are on the known-malicious blocklist." >&2
    echo "See: ~/.claude/scripts/known-malicious-packages.txt" >&2
    echo "If this is a false positive, remove the entry and retry." >&2
    echo "========================================" >&2
    exit 2
fi

# Typosquatting heuristic: warn (don't block) on very short or unusual names
while IFS= read -r pkg; do
    [ -z "$pkg" ] && continue
    if [ ${#pkg} -le 2 ]; then
        echo "Warning: very short package name '${pkg}' — verify this is intentional" >&2
    fi
done <<< "$PACKAGES"

exit 0
