# Hooks & Automation

Hooks are shell scripts that Claude Code runs automatically in response to events. They're configured in `~/.claude/settings.json` under the `"hooks"` key.

## Active Hooks

### Pre-Install Check (PreToolUse)

**Script**: `~/.claude/scripts/pre-install-check.sh`
**Fires on**: Only install commands (`npm install`, `npm i`, `pnpm add`, `pip install`, `uv add`, etc.) — uses the `if` field so no process spawns for other Bash calls
**What it does**: Checks package names against `~/.claude/scripts/known-malicious-packages.txt` before `npm install`, `pnpm add`, `pip install`, or `uv add` commands execute.
**Blocking**: Yes — exits with code 2 to prevent the install if a match is found.
**Timeout**: 10 seconds

**Example**: If Claude runs `pip install litellm`, the hook blocks it and shows:
```
========================================
 BLOCKED: Known malicious package(s)
========================================
  - litellm
These packages are on the known-malicious blocklist.
========================================
```

### Post-Install Audit (PostToolUse)

**Script**: `~/.claude/scripts/post-install-audit.sh`
**Fires on**: Only install commands (same patterns as pre-install hook) — zero overhead on non-install Bash calls
**What it does**: After a package install completes, runs the appropriate audit tool (`npm audit`, `pnpm audit`, `uv audit`, or `pip-audit`) and shows the last 20 lines of output.
**Blocking**: No — PostToolUse hooks cannot block.
**Timeout**: 30 seconds

## Pre-Commit Hook (Manual Setup)

**Script**: `~/.claude/scripts/pre-commit-audit.sh`

This is NOT a Claude Code hook — it's a git pre-commit hook you add to individual projects. It runs `uv audit` / `npm audit` before each commit and blocks the commit if vulnerabilities are found.

### Option A: Direct Git Hook

```bash
# In your project directory:
cp ~/.claude/scripts/pre-commit-audit.sh .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit
```

### Option B: pre-commit Framework

Add to your project's `.pre-commit-config.yaml`:

```yaml
repos:
  - repo: local
    hooks:
      - id: audit-deps
        name: Dependency Audit
        entry: ~/.claude/scripts/pre-commit-audit.sh
        language: script
        pass_filenames: false
        stages: [pre-commit]
        files: '(package\.json|package-lock\.json|pnpm-lock\.yaml|requirements.*\.txt|pyproject\.toml|uv\.lock)$'
```

The `files` pattern ensures the hook only runs when dependency files change.

## The Blocklist

**File**: `~/.claude/scripts/known-malicious-packages.txt`

Format: one package name per line, `#` for comments. This list is checked by the pre-install hook.

**To add a package**: Edit the file directly. No restart needed — the hook reads it on every invocation.

**To allow a blocked package** (e.g., you need litellm and will pin a safe version): Remove or comment out the entry.

## How Hooks Work

```
Claude calls a tool (e.g., Bash)
        │
        ▼
PreToolUse hooks fire ──── Can block (exit 2) or allow (exit 0)
        │
        ▼
Tool executes (if not blocked)
        │
        ▼
PostToolUse hooks fire ──── Cannot block, informational only
```

**Exit codes**:
- `0` — Success, proceed normally
- `2` — Block the action (PreToolUse only)
- Other — Warning shown, but action proceeds

## Adding a New Hook

Edit `~/.claude/settings.json` and add entries under the appropriate event:

```json
"hooks": {
  "PreToolUse": [
    {
      "matcher": "ToolName",
      "hooks": [
        {
          "type": "command",
          "command": "~/.claude/scripts/your-script.sh",
          "timeout": 10
        }
      ]
    }
  ]
}
```

Available events: `PreToolUse`, `PostToolUse`, `UserPromptSubmit`, `SessionStart`, `Stop`, `FileChanged`, and more. See Claude Code docs for the full list.

---

**Last Updated**: 2026-04-20
