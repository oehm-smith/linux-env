# Project Management

## Project Registry

Global registry at `~/.claude/registry/projects.json`. Single source of truth across all sessions.

**YOU MUST:**
- Check the registry when starting work in any project — update stale entries
- Add new projects when creating them
- Update `status` and `notes` when status changes, milestones are reached, or significant decisions are made
- Fill in `language: "unknown"` when determinable from project contents
- Generate a status report when Brooke asks — formatted table with columns: Project, Language, Status, Path, Notes. Sorted by status: `active`, `rewrite`, `released`, `paused`, `archived`. Within `active`, sort by `priority` (1 = highest)

**Valid statuses:** `active` (being worked on), `planned` (not yet started), `released` (functional, in use), `paused` (temporarily stopped), `rewrite` (planned rearchitecture), `archived` (no longer relevant)

## Project Setup

When starting work in a NEW project, ask:

1. **Methodology** — list available from `~/.claude/methodologies/*.md`, or "None" for vibe coding
2. **Complexity** — simple (< 5 files) or complex (multi-service, long-term)? Multiple features simultaneously? Git worktrees?
3. **Apply answers**: methodology selected → import it; simple → no worktrees; complex → offer worktrees + agent workflow
4. **Update registry** — add if missing, verify if exists, fill unknowns
5. **Record preference** — check for `.claude-project.json`, offer to create if none

**Don't ask if**: Brooke already stated preference, it's a one-file change, or preferences were established earlier in session.

**Default**: Worktrees DISABLED. See `~/.claude/docs/git-worktrees.md` for guidance.

**Methodology hints** (always ask, these are suggestions only):

| Path Pattern | Methodology | Worktrees |
|---|---|---|
| `~/bin/`, `scripts/` | Vibe | No |
| `Projects/` | SRDD | Ask |
| `Systems/` | SCALED-SRDD | Yes |

Methodology and worktrees are independent choices.

**Existing .claude-project.json**: Check for `"superpowers"` key — ask Brooke which version. Config schema may differ between versions.

## Issue Tracking

- Use TodoWrite to track what you're doing. NEVER discard tasks without Brooke's approval.
- Create GitLab/GitHub issues following the Milestone + Tasks pattern (see version-control rules).
- Close task issues when completed; close milestone when all tasks done.
- Keep plan documents up to date with issue links.

## Planning Documents

**MANDATORY**: Plans go in `docs/plans/YYYY-MM-DD_<topic>.md` in the project repo, not in chat.

1. Write plan on a new branch
2. Commit and open MR for review
3. After approval, break into sub-issues assigned to a milestone
4. Link plan from milestone and sub-issues

## Learning & Memory

- Use the journal frequently for technical insights, failed approaches, and user preferences
- Search the journal before starting complex tasks
- Document architectural decisions and outcomes
- When you notice unrelated issues, journal them rather than fixing immediately
