# Version Control

## Branch Workflow

**Detect the default branch** at session start:
```bash
git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@'
```
Fallback: `git branch -r | grep -E "origin/(main|master)$" | head -1 | sed 's@origin/@@'`

NEVER assume `main` or `master`. If remote HEAD is misconfigured, warn Brooke.

**Starting new work:**
1. `git checkout <default> && git pull`
2. Check/create issue if non-trivial
3. `git checkout -b feat/your-feature` (reference issue: `feat/123-feature-name`)

**MCP git_create_branch does NOT checkout** — always `git checkout <branch>` after, verify with `git status`.

**When Brooke says "pr merged":** immediately `git checkout <default> && git pull`. Never continue on the old branch.

## General Rules

- If not in a git repo, STOP and ask permission to initialize.
- Ask how to handle uncommitted changes when starting work. Suggest committing existing work first.
- Create a WIP branch when starting work without a clear branch.
- Commit frequently at logical milestones. Commit journal entries.
- **Branch prefixes**: `feat/`, `fix/`, `refactor/`, `docs/`, `test/`, `build/`, `ci/`, `chore/`
- Run all tests before commit.
- PR review feedback: make separate commits (not `--amend`) to preserve review history.

## Commit Standards

Follow [Conventional Commits](https://www.conventionalcommits.org/): `<type>[optional scope]: <description>`

**Types**: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`, `revert`

Breaking changes: add `!` after type or `BREAKING CHANGE:` in footer.

**Signature** (Claude Code commits):
```
🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
```

## Issues

**Detect platform** via `git remote -v`: GitHub → `gh`, GitLab → `glab`.

**Known bug — `#` in Bash commands**: Breaks Claude Code permission matching (issues #34379, #29582, #34007). Use full URLs instead of `#N` refs everywhere: `Closes https://gitlab.com/.../issues/7`.

**Known bug — `$()` substitution**: Also breaks permission matching. Pass descriptions as inline strings, never `$(cat file)`.

**Workaround for MR/PR descriptions**: Use `**Header**` instead of `## Header`. Use full URLs instead of `#N`. Compose as one inline command with zero `#` and zero `$()`.

**Create issues for non-trivial work** (new features, multi-file bug fixes, refactoring, config changes). Skip for typo fixes and single-line changes.

**Issue-Branch-PR flow**: Issue → branch refs issue (`feat/275-llm-failover`) → commits ref issue → PR closes issue.

## Milestones & Task Issues

Use milestones for phased work — NOT epic parent issues. The milestone IS the grouping.

1. **Milestone per phase** — built-in progress tracking, burndown. Backlog phases use `Future N:` prefix.
2. **Task issues** — one per implementation task, assigned to milestone.
3. **Labels** — categorical only (`bug`, `docs`, `refactor`). Not a substitute for milestones.
4. **Release tags** — annotated git tag + Release when phase completes. Close milestone.
5. **Plan docs** — update with issue links.

**Auto-close syntax** — keyword immediately before URL, no colon, no bullet:
```
Closes https://gitlab.com/group/repo/-/issues/7
Closes https://gitlab.com/group/repo/-/issues/8
```

**Milestone API** (GitLab): `glab api projects/<group>%2F<repo>/milestones --method POST -f title="Phase N: Name"`
**Milestone API** (GitHub): `gh api repos/:owner/:repo/milestones --method POST -f title="Phase N: Name"`
