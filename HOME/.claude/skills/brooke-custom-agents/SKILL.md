---
name: Brooke's Custom Agent Skills
description: References custom agent and specialized skills in ~/.claude/skills/
when_to_use: when needing specialized agent roles or custom skill implementations for complex features
version: 1.0.0
---

# Brooke's Custom Agent Skills

## Overview

This skill points to Brooke's custom skills repository at `~/.claude/skills/`. This directory contains specialized agent skills and custom implementations that extend Superpowers' built-in capabilities.

## Custom Skills Location

**All custom skills live in**: `~/.claude/skills/`

## Directory Structure

Custom skills are organized by category:

```
~/.claude/skills/
├── analysis/          (Requirements analysis, business logic)
├── architecture/      (System design, schema validation)
├── database/          (Migrations, RLS policies, data engineering)
├── security/          (Security audits, policy validation)
├── documentation/     (Technical writing, governance docs)
├── testing/           (Test strategies, acceptance testing)
├── deployment/        (Release management, deployment planning)
└── meta/              (Meta-skills for orchestration and dispatch)
```

Each category may contain multiple specialized skills as subdirectories with their own `SKILL.md` files.

## When to Check Custom Skills

**Before starting any task**, check both:
1. Superpowers skills (via `find-skills`)
2. Custom skills in `~/.claude/skills/`

**Browse custom skills by listing directories**:
```bash
ls -la ~/.claude/skills/*/*/SKILL.md
```

This shows all available custom skills across all categories.

## How to Use Custom Skills

1. **Check if relevant custom skill exists**:
   - Browse by category: `ls ~/.claude/skills/{category}/`
   - Or list all: `ls ~/.claude/skills/*/*/SKILL.md`

2. **Read the full skill**:
   ```
   Read tool: ~/.claude/skills/{category}/{skill-name}/SKILL.md
   ```

3. **Announce usage**:
   ```
   "I've read the {Skill Name} skill and I'm using it to {purpose}"
   ```

4. **Follow the skill exactly**

## Integration with Superpowers

These custom skills work alongside Superpowers skills:
- **Superpowers provides**: TDD, brainstorming, systematic debugging, code review
- **Custom skills provide**: Specialized roles, domain-specific workflows, project-specific patterns

**Use both**: Superpowers skills for general process, custom skills for specialized expertise.

## Meta Skills

Check `~/.claude/skills/meta/` for orchestration and coordination skills, such as:
- Agent dispatch and coordination
- Workflow automation
- Custom process implementations

## Documentation

Full documentation for custom skills system:
- `~/.claude/docs/claude-skills.md` - Skills system overview
- `~/.claude/docs/seven-agents.md` - Agent workflow examples
- `~/.claude/docs/superpowers.md` - Superpowers integration

## Mandatory Reading

When any task matches a custom skill's domain:
1. Find the relevant skill in `~/.claude/skills/`
2. Use Read tool with full path to SKILL.md
3. Follow the skill's instructions exactly

**Not optional.** If a custom skill exists for your task, you must use it.

## Adding New Skills

Brooke can add new skills at any time to `~/.claude/skills/`. The category structure is flexible - new categories and skills can be added without updating this pointer skill.
