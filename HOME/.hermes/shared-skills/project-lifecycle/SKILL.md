---
name: project-lifecycle
description: Track project lifecycle state in its Git repository.
version: 0.1.0
author: Brooke, Hermes Agent
license: MIT
platforms: [linux, macos, windows]
metadata:
  hermes:
    tags: [projects, lifecycle, status, git, planning]
    related_skills: []
---

# Project Lifecycle

Use a repository-owned status file to distinguish high-level project phase from Hermes workspace and task state.

## Core rules

1. Treat `PROJECT_STATUS.md` at the repository root as the authoritative project lifecycle record when it exists.
2. Keep lifecycle state separate from Hermes mechanisms:
   - Hermes Project identifies and groups the workspace.
   - Hermes Kanban tracks executable tasks and dependencies.
   - ADRs record accepted technical decisions.
   - `PROJECT_STATUS.md` records the overall project phase, focus, gates, and next state.
3. Use lowercase, hyphenated machine-readable values in YAML frontmatter. Example:

   ```yaml
   ---
   status: discussing-and-planning
   phase: discovery
   updated: YYYY-MM-DD
   ---
   ```

4. In the body, record:
   - a plain-language current state;
   - current focus;
   - blockers or unresolved decisions when present;
   - explicit criteria for entering the next state.
5. Do not infer readiness from an empty Kanban queue, completed discussion, generated plan, or model consensus. Change the lifecycle state only when its stated exit criteria are met or the user directs the change.
6. When changing state, update the frontmatter date, revise the body so it agrees with the new state, validate the diff, and commit the status change as a coherent Git change when the repository uses Git.
7. Do not duplicate volatile task lists in `PROJECT_STATUS.md`; link to Kanban or project plans instead.
8. If a repository has its own documented lifecycle convention, follow that project-specific rule over this default.

## Suggested states

Use only the states a project needs. Prefer these defaults:

- `idea` — concept captured but not yet being actively shaped.
- `discussing-and-planning` — scope, design, name, requirements, or pilot is under discussion.
- `ready-for-implementation` — scope, acceptance criteria, dependencies, and approvals are sufficient to start.
- `implementing` — approved work is underway.
- `verifying` — implementation is complete enough for independent checks.
- `blocked` — progress requires an unresolved external input or decision; explain the blocker.
- `maintaining` — the initial outcome is delivered and ongoing work is incremental.
- `paused` — intentionally inactive but expected to resume.
- `completed` — intended outcome and acceptance criteria are met.
- `archived` — no further active work is expected.

## Verification

Before reporting a lifecycle change as complete:

- read back or otherwise verify `PROJECT_STATUS.md`;
- confirm frontmatter and body name the same state;
- confirm the date reflects the change;
- run the repository's whitespace/diff check when available;
- verify Git status or the resulting commit when a commit was requested or is the repository convention.
