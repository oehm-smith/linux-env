# md-convert.sh — render markdown to PDF or DOCX

**Use when:** a task needs one or more `.md` files rendered to PDF or DOCX ad-hoc, without a manifest or project layout. Handles single-file, combined-file, and one-per-file output modes.

**Not this tool when:**
- Building the same combined document repeatedly with a defined file order → `build-docs.md`.
- Preserving project directory structure under `dist/` → `md-project-convert.md`.
- Converting a PDF to DOCX for delivery → `pdf-to-docx.md`.

Run `md-convert.sh --claude-help` for the full spec (commands, template resolution, classification, `--project` substitution).

**Templates:** see `templates.md` in this folder. Do NOT hunt the filesystem — they live in `~/Library/Application Support/convert-md/templates/` (global) or `<project-root>/Library/templates/` (per-project).
