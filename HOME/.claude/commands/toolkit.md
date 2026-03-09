Show all available custom commands and skills organized by category.

## Instructions

Read the following directories and present a structured overview:

1. **Custom commands**: List all `.md` files in `~/.claude/commands/` (extract first line as description)
2. **Design phase skills**: List all subdirectories in `~/.claude/skills-design/` (extract the `description:` line from each SKILL.md)
3. **Methodologies**: List all `.md` files in `~/.claude/methodologies/` (extract first heading as description)
4. **Superpowers skills**: List from the active skill registry (these are loaded via the Superpowers plugin)

Present as:

```
Available commands and skills:

Commands (/command-name):
  /toolkit           — This help listing
  /methodologies     — List and select development methodologies
  /swecom            — Show SWECOM skill area mapping and coverage
  /add-file-header   — Add mandatory ABOUTME file header
  /health-check      — Run comprehensive project health check
  /rules             — Review rules and verify compliance

Methodologies (/methodologies <name>):
  srdd               — Spec-Roundtrip Driven Development
  ssrdd              — Scaled SRDD for multi-domain systems
  vibe               — Minimal process for scripts and prototypes

Design Phase Skills (SWECOM-aligned — say "design phase" or "let's design"):
  [Read ~/.claude/skills-design/*/SKILL.md and list each with description]
  Run /swecom to see IEEE SWECOM area mapping and coverage gaps

Superpowers (auto-triggered during implementation):
  brainstorming, test-driven-development, systematic-debugging,
  verification-before-completion, writing-plans, executing-plans,
  requesting-code-review, receiving-code-review,
  finishing-a-development-branch, dispatching-parallel-agents,
  subagent-driven-development, using-git-worktrees
```

If the user provides an argument (`/toolkit design`), filter to show only that category in detail.
