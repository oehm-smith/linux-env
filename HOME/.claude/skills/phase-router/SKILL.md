---
name: Phase Router
description: Routes to phase-specific skills based on workflow stage
when_to_use: when starting design work, entering a new phase, or asking "what phase skills are available"
version: 1.0.0
---

# Phase Router

## Overview

Routes to phase-specific skills. Auto-discovers `~/.claude/skills-*/` directories.

## Trigger Phrases

| User Says | Phase | Action |
|-----------|-------|--------|
| "design phase", "let's design", "proper design", "SWECOM" | design | Load from skills-design/ |
| "what phases available" | - | List all skills-*/ directories |

## When Triggered

1. Scan for directories matching `~/.claude/skills-*/`
2. List available skills in requested phase:

**Example output for design phase:**
```
Design phase skills available in ~/.claude/skills-design/:

- requirements-analysis: Requirements gathering and analysis
- architecture: System architecture design
- code-quality: Code quality standards
- acceptance-testing: Test planning and acceptance criteria
- migrations: Migration planning
- security-audit: Security review and policy
- accessibility: WCAG compliance
- metrics: Engineering metrics
- documentation: Documentation standards
- release-management: Release planning
- domain-driven-design: DDD patterns

Which skill would you like to use? Or "all" for full design process.
```

3. Load requested skill(s) using Read tool on `~/.claude/skills-<phase>/<skill>/SKILL.md`

## Auto-Discovery

Future phases discovered automatically by naming convention:
- `skills-security/` → "security" phase
- `skills-review/` → "review" phase
- Any `skills-*/` directory → phase name from suffix

To add a new phase: create `~/.claude/skills-<phasename>/` and add skill directories.
