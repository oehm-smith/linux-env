#!/bin/bash
# ABOUTME: Reports local drift in /opt/linux-env — files present on this
# ABOUTME: machine but not committed, grouped by top-level HOME/ subdir, with
# ABOUTME: suggestions for likely .gitignore candidates (locks, dbs, caches).

set -e

cd "$(dirname "$0")/.."
REPO="$PWD"

echo "linux-env drift report — $REPO"
echo "================================"
echo

# Collect porcelain output once.
PORCELAIN=$(git status --porcelain)

if [ -z "$PORCELAIN" ]; then
    echo "Working tree clean. No drift."
    exit 0
fi

print_section() {
    local heading="$1"
    local filter="$2"
    local matched
    matched=$(echo "$PORCELAIN" | grep -E "$filter" || true)
    if [ -n "$matched" ]; then
        echo "## $heading"
        echo "$matched" | sort
        echo
    fi
}

# Modified-but-not-committed (tracked files with local edits).
print_section "Modified (tracked, uncommitted)" "^.M "

# Untracked, grouped by top-level HOME/ subdir.
UNTRACKED=$(echo "$PORCELAIN" | awk '/^\?\? / {print $2}')
if [ -n "$UNTRACKED" ]; then
    echo "## Untracked (grouped by HOME/ subdir)"
    echo
    echo "$UNTRACKED" | awk -F/ '
        /^HOME\// {
            key = $1 "/" $2 "/"
            counts[key]++
            next
        }
        { other[$0]++ }
        END {
            for (k in counts) printf "  %s  (%d items)\n", k, counts[k] | "sort"
            close("sort")
            for (p in other) printf "  %s\n", p | "sort"
        }
    '
    echo
    echo "  (Use \`git status\` for the full file list.)"
    echo
fi

# Suggestions: untracked paths matching runtime-state patterns.
IGNORE_HINTS=$(echo "$UNTRACKED" | grep -E '\.(lock|db|db-shm|db-wal|log|bak|cache|etag|pid)$|/(locks|logs|cache|caches|runtime|sessions|backups|installs|tmp|.update_check|.update_exit_code)/' || true)
if [ -n "$IGNORE_HINTS" ]; then
    echo "## .gitignore candidates (look like runtime state)"
    echo "$IGNORE_HINTS" | sort | sed 's/^/  /'
    echo
fi

echo "Done."
