#!/usr/bin/env python3
# ABOUTME: PreToolUse hook that blocks MR/PR creation without a Closes <url> reference
# ABOUTME: Enforces the auto-close convention so merged MRs/PRs automatically close their tracked issues

import json
import re
import shlex
import sys

# Close-keywords that GitHub and GitLab recognise. Case-insensitive.
CLOSE_KEYWORDS = (
    "close", "closes", "closed", "closing",
    "fix", "fixes", "fixed", "fixing",
    "resolve", "resolves", "resolved", "resolving",
)

# Pattern: a close keyword, whitespace, then an issue URL.
CLOSE_REF = re.compile(
    r"\b(" + "|".join(CLOSE_KEYWORDS) + r")\s+https?://\S+/issues/\d+",
    re.IGNORECASE,
)

# Opt-out marker the assistant can include if there is genuinely no related issue.
OPT_OUT_MARKER = "[no-close-required]"


def is_mr_create(tokens):
    """Return True if the tokens contain a `glab mr create` or `gh pr create` invocation."""
    seqs = (
        ("glab", "mr", "create"),
        ("gh", "pr", "create"),
    )
    for i in range(len(tokens) - 2):
        if tuple(tokens[i:i + 3]) in seqs:
            return True
    return False


def find_description(tokens):
    """Find the body/description argument value among CLI tokens.

    Supports --description, --body, -d, and -b (the conventional flags for glab and gh).
    Returns None if not present.
    """
    flag_names = {"--description", "--body", "-d", "-b"}
    for i, tok in enumerate(tokens):
        if tok in flag_names and i + 1 < len(tokens):
            return tokens[i + 1]
        # Handle --description=value form
        for flag in ("--description=", "--body="):
            if tok.startswith(flag):
                return tok[len(flag):]
    return None


def block(message):
    """Print a blocking message to stderr and exit 2."""
    sys.stderr.write("\n")
    sys.stderr.write("======================================\n")
    sys.stderr.write(" BLOCKED: MR/PR missing 'Closes' reference\n")
    sys.stderr.write("======================================\n")
    sys.stderr.write(message + "\n")
    sys.stderr.write("\n")
    sys.stderr.write("Add a line like:\n")
    sys.stderr.write("  Closes https://gitlab.com/group/repo/-/issues/7\n")
    sys.stderr.write("\n")
    sys.stderr.write("Or, if there is genuinely no related issue, include the marker\n")
    sys.stderr.write("  " + OPT_OUT_MARKER + "\n")
    sys.stderr.write("anywhere in the description.\n")
    sys.stderr.write("======================================\n")
    sys.exit(2)


def main():
    """Parse the tool input, detect MR/PR create commands, enforce Closes reference."""
    try:
        payload = json.load(sys.stdin)
    except (json.JSONDecodeError, ValueError):
        sys.exit(0)

    command = (payload.get("tool_input") or {}).get("command", "")
    if not command:
        sys.exit(0)

    try:
        tokens = shlex.split(command, posix=True)
    except ValueError:
        # Unparseable — let other hooks/tools handle it
        sys.exit(0)

    if not is_mr_create(tokens):
        sys.exit(0)

    description = find_description(tokens)

    if description is None:
        block("No --description / --body / -d / -b argument found.")

    if OPT_OUT_MARKER in description:
        sys.exit(0)

    if not CLOSE_REF.search(description):
        block("Description does not contain a 'Closes <issue-url>' line.")

    sys.exit(0)


if __name__ == "__main__":
    main()
