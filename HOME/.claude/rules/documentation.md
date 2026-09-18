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

## Fake Lists — applies to ALL markdown authoring

**Scope: every .md file you write or edit, plus every MR/PR/issue body.** Not just remote descriptions.

A "fake list" is a stacked block of single-line paragraphs — typically bold pseudo-headers like `**Date:**`, `**Author:**`, `**Status:**`, `**Summary**`, `**Why**`, `**Change**`, or address/metadata blocks. Without one of the two fixes below, CommonMark collapses the entire block into ONE MASHED PARAGRAPH. Brooke has flagged this repeatedly.

**Preferred fix: two trailing spaces at the end of every line except the last.** This keeps the block visually stacked in the source (which is what stacked headers should look like) while forcing renderers to insert line breaks. Blank lines between every header work too but bloat the source and turn a tight metadata block into four paragraphs of chrome — reserve that form for genuinely separate paragraphs.

**Wrong** (renders as one mashed paragraph):
```
**Date:** 2026-07-26
**Author:** Brooke + Claude
**Status:** Draft
```

**Right** (trailing double spaces, shown here as `··`):
```
**Date:** 2026-07-26··
**Author:** Brooke + Claude··
**Status:** Draft
```

**Applying it via the tools.** Edit and Write strip trailing whitespace, so use a `@@` placeholder in the edit, then convert with sed:

```bash
sed -i '' 's/@@$/  /g' path/to/file.md
```

If in-place edit doesn't take effect (rare, but happens under some sandboxes), fall back to a temp file:

```bash
F=path/to/file.md
sed 's/@@$/  /g' "$F" > "$F.tmp" && mv "$F.tmp" "$F"
```

Verify no `@@` remains: `grep -c '@@' "$F"` should print `0`. Verify the trailing spaces landed: `sed -n '<lines>p' "$F" | sed 's/ /·/g; s/$/§/'` — every line except the last of the block should end `··§`.

**For MR/PR descriptions specifically** — same rule, delivered as a multi-line quoted string in bash, blank line between header and body:
```
--description "**Summary**

One-line summary.

**Why**

Explanation.

**Change**

What changed."
```

Bash preserves the actual newlines inside the quoted string. Do NOT flatten into a single line hoping markdown will figure it out — it won't.

**After posting**, verify with `glab mr view <id>` (or `gh pr view`) that the body renders as separated blocks, not one paragraph.
