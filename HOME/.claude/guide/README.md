# Claude Code Setup Guide

Human-facing documentation for Brooke's Claude Code environment. Everything in `~/.claude/docs/` is written for Claude to consume; everything here is written for you.

## Quick Reference

| What | Where | Description |
|------|-------|-------------|
| [Architecture](./architecture.md) | How `~/.claude/` is organized | Directory map, what lives where, how pieces connect |
| [Commands](./commands-reference.md) | All slash commands | `/toolkit`, `/audit-deps`, `/health-check`, etc. |
| [Skills](./skills-reference.md) | All skills and agents | Superpowers, design phase, custom skills |
| [Hooks & Automation](./hooks-and-automation.md) | What runs automatically | Pre-install checks, post-install audits, pre-commit |
| [Methodologies](./methodologies-reference.md) | Development approaches | SRDD, SSRDD, AIRA, TRAD, Vibe |
| [Dependency Auditing](./security/dependency-auditing.md) | Supply chain security | Hooks, `/audit-deps`, pre-commit, blocklist |

## How This Differs from `~/.claude/docs/`

| `~/.claude/docs/` | `~/.claude/guide/` |
|--------------------|--------------------|
| Written for Claude | Written for Brooke |
| Skill definitions, SWECOM mappings | How-to guides, reference cards |
| Loaded into conversation context | Read by a human at a desk |
| "Here's how to perform this skill" | "Here's what you have and how to use it" |

## Keeping This Up to Date

When adding new commands, skills, hooks, or methodologies to `~/.claude/`, update the relevant guide page. Claude is instructed to remind you when changes affect documentation.

---

**Created**: 2026-04-20
**Last Updated**: 2026-04-20
