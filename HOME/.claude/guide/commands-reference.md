# Commands Reference

All slash commands available in Claude Code. These are defined as markdown files in `~/.claude/commands/`.

## Development Commands

### `/toolkit`
List all available commands, skills, and methodologies in a structured overview. Use this when you forget what's available.

### `/methodologies`
List available development methodologies and select one for the current project. Reads from `~/.claude/methodologies/`.

### `/health-check`
Run a comprehensive project health check covering code quality, metrics, accessibility, documentation, and security. Uses multiple specialized agents.

### `/rules`
Review and verify compliance with CLAUDE.md rules. Useful for checking that work follows all conventions.

### `/add-file-header`
Add the mandatory ABOUTME file header to code files. All code files must start with a 2-line ABOUTME comment.

### `/swecom`
Show the IEEE SWECOM skill area mapping and coverage for design phase skills.

## Security Commands

### `/audit-deps`
Scan the current project's dependencies for known vulnerabilities and supply chain risks. Detects Python (uv/pip) and Node (npm/pnpm/yarn) projects automatically. Cross-references against the local blocklist at `~/.claude/scripts/known-malicious-packages.txt`.

**When to use:**
- After adding new dependencies
- Before creating a PR/MR
- When starting work on a new project
- Periodically during development

## Document Commands

### `/create-pdf`
Convert a markdown document to PDF using `convertproj.sh`. Output goes to `dist/`.

### `/email-doc`
Email a document to someone. Generates PDF if needed, composes in Mail.app for review before sending. Always CCs brooke@oehmsmith.com.

### `/send-message`
Send an iMessage via Messages.app. Sends immediately (no review step).

## Adding a New Command

Create a markdown file in `~/.claude/commands/`:

```markdown
Description of what the command does.

## Instructions

Step-by-step instructions for Claude to follow when this command is invoked.
```

The filename becomes the command name: `foo.md` → `/foo`.

---

**Last Updated**: 2026-04-20
