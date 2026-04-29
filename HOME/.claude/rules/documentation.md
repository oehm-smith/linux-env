# Documentation

## Maintenance

Keep project documentation up to date AS YOU WORK — per task, not per phase.

**At project/phase start**, create if missing:
- `docs/USER-GUIDE.md` — end-user docs (commands, workflows, examples)
- `docs/DEVELOPER-GUIDE.md` — developer docs (architecture, setup, conventions)

**When completing features/fixes/config changes**, check and update:
- User/developer guides, README, API docs, config examples

**Doc updates should be**: part of the same PR, clear, following existing style, with examples where helpful.

**Don't over-document**: skip internal implementation details and minor refactors. When in doubt, ask Brooke.

**Goal**: Anyone reading docs can set up and use the system without discovering outdated instructions.

## Markdown Trailing Double Spaces

For stacked single-line paragraphs (address blocks, metadata headers), each line except the last needs two trailing spaces for line breaks.

**Problem**: Edit and Write tools strip trailing whitespace.
**Solution**: Use `@@` placeholder, then replace:
```bash
sed -i '' $'s/\r//' file && sed -i '' 's/@@$/  /g' file
```
Verify: `grep -n '@@' file`
**Alternative**: `sed -i '' '/^PATTERN/s/$/  /' file`
