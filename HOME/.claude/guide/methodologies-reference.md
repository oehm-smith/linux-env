# Methodologies Reference

Development methodologies define *how* you and Claude approach work on a project. Selected at project start via `/methodologies` or when Claude asks during initial setup.

## Available Methodologies

### SRDD — Spec-Roundtrip Driven Development
**Author**: Brooke Smith — https://docs-bbos.github.io/srdd/

AI-assisted methodology where specifications and code exist in a closed loop. Specs guide implementation, but code becomes the source of truth. Understanding flows both directions.

**Best for**: Most projects under `Projects/`, feature development, anything with clear requirements.

### SSRDD — Scaled Spec-Roundtrip Driven Development
**Author**: Brooke Smith — https://docs-bbos.github.io/srdd/

Coordination wrapper enabling multiple independent SRDD cycles to coexist across multi-domain systems. Coordinates interfaces and intent, not implementation.

**Best for**: Multi-service systems, projects under `Systems/`, anything with multiple bounded contexts.

### AIRA — AI Implementation Readiness & Adoption
**Author**: Brooke Smith

Methodology for AI-specific consulting engagements. Layers on top of TRAD with specialized frameworks for assessing AI readiness, identifying genuine use cases, and planning adoption.

**Best for**: Client engagements where "we want AI" needs to be translated into concrete plans.

### TRAD — Technology Roadmap & Advisory Discovery
**Author**: Brooke Smith

Consulting methodology for translating vague client requirements into concrete, phased technology roadmaps. Designed for advisory engagements starting with incomplete information.

**Best for**: Advisory and consulting engagements, technology strategy work.

### Vibe — Minimal Process
No formal methodology. For scripts, prototypes, one-off utilities, and exploratory work where process adds overhead without value.

**Best for**: Scripts in `~/bin/`, quick utilities, prototypes, learning experiments.

## Default Recommendations

These are hints — Claude always asks which to use.

| Project Location | Suggested Methodology |
|------------------|-----------------------|
| `~/bin/`, `scripts/`, `utils/` | Vibe |
| `Projects/` | SRDD |
| `Systems/` | SSRDD |
| Consulting work | TRAD or AIRA |

## Methodology vs Worktrees

These are independent choices:
- **Methodology** = *how* you develop (process, documentation, phases)
- **Worktrees** = *where* you develop (parallel git branches)

A simple SRDD project might not need worktrees. A complex vibe project might benefit from them.

## Adding a New Methodology

Create a markdown file in `~/.claude/methodologies/`:

```markdown
# NAME: Short description

Full methodology rules and instructions for Claude to follow.
```

The first line must follow the `# NAME: Description` format — Claude reads this to present options.

---

**Last Updated**: 2026-04-20
