# md-project-convert.sh — project-aware markdown → PDF/DOCX under dist/

**Use when:** rendering `.md` files from a git project and wanting outputs mirrored under `<project-root>/dist/<relative-path>/`. Each input becomes its own output — this tool does NOT combine files.

**Not this tool when:**
- Combining files into one PDF → `convert-md.md` (with a file `-o`) or `build-docs.md`.
- No git repo / one-off render → `convert-md.md`.
- Converting a PDF to DOCX → `pdf-to-docx.md`.

Run `md-project-convert.sh --claude-help` for the full spec (commands, template resolution, `-d`/`-o` overrides, `--project` substitution).

**Templates:** see `templates.md` in this folder. Do NOT hunt the filesystem — they live in `~/Library/Application Support/convert-md/templates/` (global) or `<project-root>/Library/templates/` (per-project).
