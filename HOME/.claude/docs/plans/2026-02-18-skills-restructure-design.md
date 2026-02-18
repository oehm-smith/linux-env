# Skills Environment Restructure Design

> **For Claude:** Use `skills/collaboration/executing-plans/SKILL.md` to implement this plan task-by-task.

**Goal:** Restructure Claude skills for phase-based loading - design skills on-demand, implementation skills via Superpowers.

**Architecture:** Keep Superpowers as base for implementation workflows (TDD, debugging, verification). Move SWECOM design skills to separate `skills-design/` directory. Add phase-router skill for on-demand loading. Trim CLAUDE.md to remove duplication.

**Tech Stack:** Markdown skills, Superpowers plugin 4.3.0

---

## Design Decisions

### Approach: Minimal Restructure
- Keep Superpowers (well-maintained, handles implementation)
- Remove duplicate skills (yours vs Superpowers)
- Move SWECOM skills to `skills-design/` (out of default search)
- Add phase-router with auto-discovery of `skills-*` directories
- Trim CLAUDE.md from 5,575 words to ~1,300 words

### Phase-Router Behavior
- Auto-discovers directories matching `~/.claude/skills-*/`
- Extracts phase name from directory (e.g., `skills-design` → "design" phase)
- User triggers: "let's design", "proper design", "SWECOM", "design phase"
- Lists available skills, loads on request

---

## Directory Structure (Final State)

```
~/.claude/
├── CLAUDE.md                          # ~1,300 words (trimmed)
├── settings.json                      # Unchanged
├── skills/
│   ├── using-skills/SKILL.md          # Superpowers entry point
│   ├── phase-router/SKILL.md          # NEW: phase routing
│   └── brooke-custom-agents/SKILL.md  # Pointer to custom skills
├── skills-design/                     # NEW: design phase skills
│   ├── requirements-analysis/SKILL.md
│   ├── architecture/SKILL.md
│   ├── code-quality/SKILL.md
│   ├── acceptance-testing/SKILL.md
│   ├── migrations/SKILL.md
│   ├── security-audit/SKILL.md
│   ├── accessibility/SKILL.md
│   ├── metrics/SKILL.md
│   ├── documentation/SKILL.md
│   ├── release-management/SKILL.md
│   └── domain-driven-design/SKILL.md
├── plugins/                           # Superpowers stays
└── (other directories unchanged)
```

---

## Skills to Delete

Duplicates of Superpowers:
- skills/testing/test-driven-development/
- skills/debugging/systematic-debugging/
- skills/debugging/verification-before-completion/
- skills/collaboration/brainstorming/
- skills/collaboration/writing-plans/
- skills/collaboration/executing-plans/
- skills/collaboration/using-git-worktrees/
- skills/collaboration/requesting-code-review/
- skills/collaboration/receiving-code-review/
- skills/collaboration/subagent-driven-development/
- skills/collaboration/dispatching-parallel-agents/
- skills/collaboration/finishing-a-development-branch/
- skills/collaboration/remembering-conversations/
- skills/meta/writing-skills/
- skills/meta/testing-skills-with-subagents/
- skills/meta/gardening-skills-wiki/
- skills/meta/sharing-skills/
- skills/meta/pulling-updates-from-skills-repository/

Unused/orphaned:
- skills/debugging/root-cause-tracing/
- skills/debugging/defense-in-depth/
- skills/problem-solving/ (entire directory - 6 abstract skills)
- skills/research/ (entire directory)
- skills/testing/testing-anti-patterns/
- skills/testing/condition-based-waiting/
- skills/architecture/ (entire directory)
- skills/crosscutting/process/

---

## Skills to Move to skills-design/

| From | To |
|------|-----|
| skills/lifecycle/requirements/requirements_analysis/ | skills-design/requirements-analysis/ |
| skills/lifecycle/design/architecture/ | skills-design/architecture/ |
| skills/lifecycle/construction/code_quality/ | skills-design/code-quality/ |
| skills/lifecycle/testing/acceptance_testing/ | skills-design/acceptance-testing/ |
| skills/lifecycle/sustainment/migrations/ | skills-design/migrations/ |
| skills/crosscutting/security/policy_auditing/ | skills-design/security-audit/ |
| skills/crosscutting/hci/accessibility/ | skills-design/accessibility/ |
| skills/crosscutting/measurement/metrics_collection/ | skills-design/metrics/ |
| skills/crosscutting/quality/documentation/ | skills-design/documentation/ |
| skills/crosscutting/configuration/release_management/ | skills-design/release-management/ |
| skills/methodology/domain_driven_design/ | skills-design/domain-driven-design/ |

---

## CLAUDE.md Changes

**Keep:**
- Foundational Rules
- Our Relationship
- Proactiveness
- Clean Code & Documentation Standards
- File Headers requirement
- Naming rules
- Version Control / Git rules
- Security Requirements (summary only)

**Remove:**
- TDD section (Superpowers handles)
- Systematic Debugging Process (Superpowers handles)
- Root Cause Tracking details (Superpowers handles)
- GenAI RAG Security full details (move to skills-design/security-audit/)

**Add:**
- Phase-router reference
- Skills policy (Superpowers for implementation, skills-design for design)

---

## Phase-Router Skill Spec

**File:** `~/.claude/skills/phase-router/SKILL.md`

```markdown
---
name: Phase Router
description: Routes to phase-specific skills based on workflow stage
when_to_use: when starting design work, entering a new phase, or asking "what phase skills are available"
version: 1.0.0
---

# Phase Router

## Overview

Routes to phase-specific skills. Auto-discovers `~/.claude/skills-*/` directories.

## Phases

| Trigger | Phase | Location |
|---------|-------|----------|
| "design", "proper design", "SWECOM", "design phase" | design | ~/.claude/skills-design/ |

## Usage

When triggered, list available skills in that phase directory:

"Design phase skills available:
- requirements-analysis: Requirements gathering
- architecture: System design
- security-audit: Security review
- [etc.]

Which skill, or 'all' for full design process?"

## Auto-Discovery

Scan for directories matching `~/.claude/skills-*/`. Phase name = directory suffix.
Future phases (skills-security/, skills-review/) discovered automatically.
```

---

## Implementation Prerequisites

1. Backup: `cp -r ~/.claude ~/.claude.bak-2026-02-18`

---

## Success Criteria

- [ ] Default session context reduced to ~1,500 words
- [ ] "Let's design" triggers phase-router, shows design skills
- [ ] Superpowers TDD/debugging works unchanged
- [ ] No duplicate skills between custom and Superpowers
- [ ] SWECOM skills available on-demand only
