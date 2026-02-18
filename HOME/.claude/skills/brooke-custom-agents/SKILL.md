---
name: Brooke's Custom Agent Skills
description: References custom skills organized by phase in ~/.claude/skills/ and ~/.claude/skills-design/
when_to_use: when needing specialized skills beyond Superpowers, especially for design phase work
version: 2.0.0
---

# Brooke's Custom Agent Skills

## Overview

Custom skills are organized by phase. Core skills are always available; design skills load on-demand.

## Directory Structure

```
~/.claude/skills/           # Core skills (always available)
├── using-skills/           # Entry point
├── phase-router/           # Phase-based routing (say "design phase")
└── brooke-custom-agents/   # This file

~/.claude/skills-design/    # Design phase skills (on-demand via phase-router)
├── requirements-analysis/  # Requirements gathering
├── architecture/           # System architecture
├── code-quality/           # Quality standards
├── security-audit/         # Security review (includes GenAI/RAG)
├── accessibility/          # WCAG compliance
├── metrics/                # Engineering metrics
├── documentation/          # Doc standards
├── release-management/     # Release planning
├── acceptance-testing/     # Test planning
├── migrations/             # Migration planning
└── domain-driven-design/   # DDD patterns
```

## How to Access Design Skills

Say one of these to trigger the phase-router:
- "design phase"
- "let's design"
- "proper design"
- "SWECOM"

The phase-router will list available design skills and load your selection.

## Integration with Superpowers

- **Superpowers**: TDD, debugging, verification, code review, brainstorming, planning
- **Design skills**: SWECOM-style analysis, architecture, security audits
- **Phase-router**: Bridges the two - loads design skills on demand

## Adding New Phases

Create a new `~/.claude/skills-<phasename>/` directory. The phase-router auto-discovers it.
