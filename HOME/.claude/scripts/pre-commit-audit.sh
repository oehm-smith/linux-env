#!/bin/bash
# ABOUTME: Git pre-commit hook script for dependency vulnerability scanning
# ABOUTME: Add to projects via .pre-commit-config.yaml or direct git hook installation

set -euo pipefail

FOUND_ISSUES=0

# Detect Python project
if [ -f "pyproject.toml" ] || [ -f "requirements.txt" ] || [ -f "uv.lock" ]; then
    echo "Auditing Python dependencies..."
    if command -v uv &>/dev/null; then
        if ! uv audit 2>&1; then
            FOUND_ISSUES=1
        fi
    elif command -v pip-audit &>/dev/null; then
        if ! pip-audit 2>&1; then
            FOUND_ISSUES=1
        fi
    else
        echo "Warning: No Python audit tool found. Install uv or pip-audit."
    fi
fi

# Detect Node project
if [ -f "package.json" ]; then
    echo "Auditing Node dependencies..."
    if [ -f "pnpm-lock.yaml" ] && command -v pnpm &>/dev/null; then
        if ! pnpm audit --no-color 2>&1; then
            FOUND_ISSUES=1
        fi
    elif [ -f "package-lock.json" ] && command -v npm &>/dev/null; then
        # npm audit exits non-zero on findings — capture and check
        AUDIT_OUTPUT=$(npm audit --no-color 2>&1) || true
        echo "$AUDIT_OUTPUT"
        if echo "$AUDIT_OUTPUT" | grep -q "found [1-9]"; then
            FOUND_ISSUES=1
        fi
    elif [ -f "yarn.lock" ] && command -v yarn &>/dev/null; then
        if ! yarn audit --no-color 2>&1; then
            FOUND_ISSUES=1
        fi
    fi
fi

if [ "$FOUND_ISSUES" -ne 0 ]; then
    echo ""
    echo "========================================="
    echo " Dependency audit found vulnerabilities"
    echo " Review above and fix before committing"
    echo "========================================="
    exit 1
fi

exit 0
