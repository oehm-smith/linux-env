# Vibe Coding: Minimal Process

For scripts, prototypes, one-off utilities, and exploratory work where formal methodology adds overhead without value.

---

## Rules

- No planning documents required
- No formal phase gates
- Work directly on main branch (or a simple feature branch for non-trivial changes)
- Write tests when they add value, not as ceremony
- Commit frequently with conventional commit messages
- All other CLAUDE.md rules still apply (clean code, security, naming, etc.)

## When to Use

- Single-file scripts and utilities (`~/bin/`, `scripts/`, `utils/`)
- Quick prototypes and spikes
- Configuration changes
- Projects with < 5 files and a clear, bounded scope

## When to Escalate

If the project grows beyond its initial scope, switch to SRDD. Signs you should escalate:
- Multiple files with interdependencies
- Need to coordinate with other systems
- Requirements are ambiguous or evolving
- You find yourself saying "I should document this"
