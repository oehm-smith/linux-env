# md-combine-doc.sh — manifest-driven combined document builds

**Use when:** a project needs many `.md` files rendered into one ordered combined PDF (and optionally DOCX), reproducibly, into `dist/book_<timestamp>.pdf`. Uses `manifest.ini` to declare which files, in what order, grouped into BUILDs. Also handles a `--no-manifest` (`-n`) mode that skips the manifest and combines every `.md` under the current directory in alpha order (by containing directory, then filename) — for one-shot builds where a formal manifest is overkill.

**Not this tool when:**
- One-off render of a single file → `convert-md.md`.
- Project-aware per-file rendering into mirrored `dist/` tree → `md-project-convert.md`.
- Converting a PDF to DOCX → `pdf-to-docx.md`.

Run `md-combine-doc.sh --claude-help` for the full spec (commands, `manifest.ini` format with BUILD keys, groups, globs, `@refs`, and the recommended workflow for a new project).

**Templates:** see `templates.md` in this folder. Do NOT hunt the filesystem — they live in `~/Library/Application Support/convert-md/templates/` (global) or `<project-root>/Library/templates/` (per-project).
