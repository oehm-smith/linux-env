# Skills Environment Restructure Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Restructure ~/.claude skills for phase-based loading with reduced context overhead.

**Architecture:** Backup existing setup, create skills-design/ directory, delete duplicate skills, move SWECOM skills, create phase-router, trim CLAUDE.md.

**Tech Stack:** Bash, Markdown

---

### Task 1: Create Backup

**Files:**
- Create: `~/.claude.bak-2026-02-18/` (full copy)

**Step 1: Create backup**

```bash
cp -r ~/.claude ~/.claude.bak-2026-02-18
```

**Step 2: Verify backup**

```bash
ls -la ~/.claude.bak-2026-02-18/skills/
```

Expected: Should show same structure as ~/.claude/skills/

**Step 3: Commit note (optional)**

No commit needed - backup is outside repo.

---

### Task 2: Create skills-design Directory

**Files:**
- Create: `~/.claude/skills-design/`

**Step 1: Create directory**

```bash
mkdir -p ~/.claude/skills-design
```

**Step 2: Verify**

```bash
ls -la ~/.claude/skills-design/
```

Expected: Empty directory exists

---

### Task 3: Move SWECOM Skills to skills-design

**Files:**
- Move: 11 skill directories from various locations to skills-design/

**Step 1: Move requirements-analysis**

```bash
mv ~/.claude/skills/lifecycle/requirements/requirements_analysis ~/.claude/skills-design/requirements-analysis
```

**Step 2: Move architecture**

```bash
mv ~/.claude/skills/lifecycle/design/architecture ~/.claude/skills-design/architecture
```

**Step 3: Move code-quality**

```bash
mv ~/.claude/skills/lifecycle/construction/code_quality ~/.claude/skills-design/code-quality
```

**Step 4: Move acceptance-testing**

```bash
mv ~/.claude/skills/lifecycle/testing/acceptance_testing ~/.claude/skills-design/acceptance-testing
```

**Step 5: Move migrations**

```bash
mv ~/.claude/skills/lifecycle/sustainment/migrations ~/.claude/skills-design/migrations
```

**Step 6: Move security-audit**

```bash
mv ~/.claude/skills/crosscutting/security/policy_auditing ~/.claude/skills-design/security-audit
```

**Step 7: Move accessibility**

```bash
mv ~/.claude/skills/crosscutting/hci/accessibility ~/.claude/skills-design/accessibility
```

**Step 8: Move metrics**

```bash
mv ~/.claude/skills/crosscutting/measurement/metrics_collection ~/.claude/skills-design/metrics
```

**Step 9: Move documentation**

```bash
mv ~/.claude/skills/crosscutting/quality/documentation ~/.claude/skills-design/documentation
```

**Step 10: Move release-management**

```bash
mv ~/.claude/skills/crosscutting/configuration/release_management ~/.claude/skills-design/release-management
```

**Step 11: Move domain-driven-design**

```bash
mv ~/.claude/skills/methodology/domain_driven_design ~/.claude/skills-design/domain-driven-design
```

**Step 12: Verify all moved**

```bash
ls ~/.claude/skills-design/
```

Expected:
```
accessibility/
acceptance-testing/
architecture/
code-quality/
documentation/
domain-driven-design/
metrics/
migrations/
release-management/
requirements-analysis/
security-audit/
```

**Step 13: Commit**

```bash
cd ~/.claude && git add -A && git commit -m "refactor: move SWECOM skills to skills-design/"
```

---

### Task 4: Delete Duplicate Skills (Superpowers Copies)

**Files:**
- Delete: 13 skill directories that duplicate Superpowers

**Step 1: Delete collaboration duplicates**

```bash
rm -rf ~/.claude/skills/collaboration/brainstorming
rm -rf ~/.claude/skills/collaboration/writing-plans
rm -rf ~/.claude/skills/collaboration/executing-plans
rm -rf ~/.claude/skills/collaboration/using-git-worktrees
rm -rf ~/.claude/skills/collaboration/requesting-code-review
rm -rf ~/.claude/skills/collaboration/receiving-code-review
rm -rf ~/.claude/skills/collaboration/subagent-driven-development
rm -rf ~/.claude/skills/collaboration/dispatching-parallel-agents
rm -rf ~/.claude/skills/collaboration/finishing-a-development-branch
rm -rf ~/.claude/skills/collaboration/remembering-conversations
```

**Step 2: Delete testing duplicates**

```bash
rm -rf ~/.claude/skills/testing/test-driven-development
```

**Step 3: Delete debugging duplicates**

```bash
rm -rf ~/.claude/skills/debugging/systematic-debugging
rm -rf ~/.claude/skills/debugging/verification-before-completion
```

**Step 4: Delete meta duplicates**

```bash
rm -rf ~/.claude/skills/meta/writing-skills
```

**Step 5: Verify deletions**

```bash
ls ~/.claude/skills/collaboration/
ls ~/.claude/skills/testing/
ls ~/.claude/skills/debugging/
ls ~/.claude/skills/meta/
```

Expected: Directories should be empty or show only non-duplicate items

**Step 6: Commit**

```bash
cd ~/.claude && git add -A && git commit -m "refactor: remove skills that duplicate Superpowers"
```

---

### Task 5: Delete Unused/Orphaned Skills

**Files:**
- Delete: Remaining unused skills

**Step 1: Delete remaining debugging skills**

```bash
rm -rf ~/.claude/skills/debugging/root-cause-tracing
rm -rf ~/.claude/skills/debugging/defense-in-depth
```

**Step 2: Delete problem-solving directory**

```bash
rm -rf ~/.claude/skills/problem-solving
```

**Step 3: Delete research directory**

```bash
rm -rf ~/.claude/skills/research
```

**Step 4: Delete remaining testing skills**

```bash
rm -rf ~/.claude/skills/testing/testing-anti-patterns
rm -rf ~/.claude/skills/testing/condition-based-waiting
```

**Step 5: Delete architecture directory (not SWECOM one)**

```bash
rm -rf ~/.claude/skills/architecture
```

**Step 6: Delete remaining meta skills**

```bash
rm -rf ~/.claude/skills/meta/testing-skills-with-subagents
rm -rf ~/.claude/skills/meta/gardening-skills-wiki
rm -rf ~/.claude/skills/meta/sharing-skills
rm -rf ~/.claude/skills/meta/pulling-updates-from-skills-repository
```

**Step 7: Delete remaining crosscutting**

```bash
rm -rf ~/.claude/skills/crosscutting
```

**Step 8: Delete remaining lifecycle**

```bash
rm -rf ~/.claude/skills/lifecycle
```

**Step 9: Delete remaining methodology**

```bash
rm -rf ~/.claude/skills/methodology
```

**Step 10: Clean up empty directories**

```bash
find ~/.claude/skills -type d -empty -delete
```

**Step 11: Verify final skills structure**

```bash
ls -la ~/.claude/skills/
```

Expected:
```
using-skills/
brooke-custom-agents/
(and empty directories for collaboration/, testing/, debugging/, meta/ - or deleted)
```

**Step 12: Commit**

```bash
cd ~/.claude && git add -A && git commit -m "refactor: remove unused and orphaned skills"
```

---

### Task 6: Create Phase-Router Skill

**Files:**
- Create: `~/.claude/skills/phase-router/SKILL.md`

**Step 1: Create directory**

```bash
mkdir -p ~/.claude/skills/phase-router
```

**Step 2: Create SKILL.md**

Create file `~/.claude/skills/phase-router/SKILL.md` with content:

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

## Trigger Phrases

| User Says | Phase | Action |
|-----------|-------|--------|
| "design phase", "let's design", "proper design", "SWECOM" | design | Load from skills-design/ |
| "what phases available" | - | List all skills-*/ directories |

## When Triggered

1. Scan for directories matching `~/.claude/skills-*/`
2. List available skills in requested phase:

**Example output:**
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

Future phases discovered automatically:
- `skills-security/` → "security" phase
- `skills-review/` → "review" phase
- Any `skills-*/` directory → phase name from suffix
```

**Step 3: Verify file created**

```bash
cat ~/.claude/skills/phase-router/SKILL.md
```

Expected: Shows the skill content

**Step 4: Commit**

```bash
cd ~/.claude && git add skills/phase-router/ && git commit -m "feat: add phase-router skill for on-demand design skills"
```

---

### Task 7: Trim CLAUDE.md

**Files:**
- Modify: `~/.claude/CLAUDE.md`

**Step 1: Read current CLAUDE.md**

```bash
wc -l ~/.claude/CLAUDE.md
```

Expected: ~823 lines

**Step 2: Create trimmed CLAUDE.md**

Edit `~/.claude/CLAUDE.md` to remove these sections:
- "## Test-Driven Development (TDD)" section (~80 lines) - Superpowers handles
- "## Systematic Debugging Process" section (~50 lines) - Superpowers handles
- "## GenAI RAG Application Security Requirements" detailed content (~200 lines) - keep summary, move details to skills-design/security-audit/

Add these sections:
- Phase routing reference (5 lines)
- Skills policy note (5 lines)

**Step 3: Add skills policy section after "## Proactiveness"**

Add this text:

```markdown
---

## Skills Organization

- **Implementation skills**: Use Superpowers (TDD, debugging, verification, code review)
- **Design skills**: Invoke phase-router skill to access SWECOM-style design skills in `~/.claude/skills-design/`
- **Trigger phrases**: "let's design", "design phase", "SWECOM" → loads design skills

---
```

**Step 4: Remove TDD section**

Delete the entire "## Test-Driven Development (TDD)" section (approximately lines 200-280). Superpowers provides this.

**Step 5: Remove Systematic Debugging section**

Delete the entire "## Systematic Debugging Process" section (approximately lines 470-520). Superpowers provides this.

**Step 6: Trim GenAI Security section**

Replace the detailed GenAI RAG Security section with a brief summary:

```markdown
## GenAI/RAG Security

Follow security best practices for AI applications. For detailed checklists, invoke the security-audit skill via phase-router.

Key principles:
- Input validation and prompt injection prevention
- PII protection in embeddings and logs
- API key security (never in code)
- Output content moderation
```

**Step 7: Verify word count reduced**

```bash
wc -w ~/.claude/CLAUDE.md
```

Expected: ~1,500-2,000 words (down from 5,575)

**Step 8: Commit**

```bash
cd ~/.claude && git add CLAUDE.md && git commit -m "refactor: trim CLAUDE.md, remove content duplicated by Superpowers skills"
```

---

### Task 8: Update brooke-custom-agents Skill

**Files:**
- Modify: `~/.claude/skills/brooke-custom-agents/SKILL.md`

**Step 1: Update the skill to reflect new structure**

Edit `~/.claude/skills/brooke-custom-agents/SKILL.md` to update directory references:

Replace the "Directory Structure" section with:

```markdown
## Directory Structure

Custom skills are organized by phase:

```
~/.claude/skills/           # Core skills (always available)
├── using-skills/           # Entry point
├── phase-router/           # Phase-based routing
└── brooke-custom-agents/   # This file

~/.claude/skills-design/    # Design phase skills (on-demand)
├── requirements-analysis/
├── architecture/
├── code-quality/
├── security-audit/
├── accessibility/
├── metrics/
├── documentation/
├── release-management/
├── acceptance-testing/
├── migrations/
└── domain-driven-design/
```
```

**Step 2: Verify update**

```bash
cat ~/.claude/skills/brooke-custom-agents/SKILL.md
```

**Step 3: Commit**

```bash
cd ~/.claude && git add skills/brooke-custom-agents/ && git commit -m "docs: update brooke-custom-agents to reflect new skill structure"
```

---

### Task 9: Clean Up Stale Files

**Files:**
- Delete: Leftover files from audit

**Step 1: Remove stale markdown files in root**

```bash
rm -f ~/.claude/audit-skills.md
rm -f ~/.claude/skills-structure.md
rm -f ~/.claude/swecom-audit-report.md
rm -f ~/.claude/CLAUDE.md.bak.brookes.2025-10-14
```

**Step 2: Remove empty skills directories**

```bash
find ~/.claude/skills -type d -empty -delete 2>/dev/null
```

**Step 3: Verify clean state**

```bash
ls ~/.claude/skills/
```

Expected:
```
brooke-custom-agents/
phase-router/
using-skills/
```

**Step 4: Commit**

```bash
cd ~/.claude && git add -A && git commit -m "chore: clean up stale files and empty directories"
```

---

### Task 10: Verify Final State

**Step 1: Check skills directory**

```bash
ls -la ~/.claude/skills/
```

Expected: 3 directories (brooke-custom-agents, phase-router, using-skills)

**Step 2: Check skills-design directory**

```bash
ls -la ~/.claude/skills-design/
```

Expected: 11 directories (all SWECOM skills)

**Step 3: Check CLAUDE.md size**

```bash
wc -w ~/.claude/CLAUDE.md
```

Expected: ~1,500-2,000 words

**Step 4: Verify phase-router exists**

```bash
cat ~/.claude/skills/phase-router/SKILL.md | head -20
```

Expected: Shows phase-router skill frontmatter

**Step 5: Test phase-router discovery (manual)**

Start new Claude session and say: "let's do design"

Expected: Claude should find and use phase-router, list design skills

---

## Success Criteria

- [ ] Backup exists at ~/.claude.bak-2026-02-18/
- [ ] ~/.claude/skills/ contains only 3 directories
- [ ] ~/.claude/skills-design/ contains 11 SWECOM skills
- [ ] CLAUDE.md is under 2,000 words
- [ ] Phase-router skill exists and lists design skills when triggered
- [ ] Superpowers TDD/debugging still works normally
