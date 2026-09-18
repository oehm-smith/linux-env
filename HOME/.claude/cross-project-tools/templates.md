# Templates for markdown → PDF/DOCX

**Do NOT hunt for templates.** They live in exactly two well-known locations. Applies to `md-convert.sh`, `md-project-convert.sh`, and `md-combine-doc.sh` (all three share the same resolver).

## Locations (searched in this order)

1. **Per-project**: `<project-root>/Library/templates/`
2. **Global**: `~/Library/Application Support/convert-md/templates/`

Project root is the nearest `.git` ancestor of the input file. Global is macOS's user-scoped app-support dir.

## Layout inside each location

Templates are either **bundles** (preferred) or **flat** files:

- Bundle: `<dir>/<name>/<name>.{typ,docx}` — grouped with a `media/` sibling for images the template references.
- Flat: `<dir>/<name>.{typ,docx}` — legacy layout, still resolved as a fallback.

Extension follows output format: `.typ` for PDF (primary Typst pipeline), `.docx` for DOCX or the legacy `.docx → PDF via soffice` pipeline.

## Selecting a template

- **By name** (`-t lst`): resolver walks the four search points above until it finds `lst/lst.{typ,docx}` (bundle) then `lst.{typ,docx}` (flat).
- **By path** (`-t /abs/path/foo.typ` or `-t ./relative/foo.docx`): used as-is, no search.
- **By classification** (`-c client`): resolves via `.convert-md.toml` at the project root, which maps `client|internal|public` → template name. Falls through to the same search.
- **Interactive** (`-t` alone, no argument): opens a picker over the global library.

## Listing what's available

```bash
ls ~/Library/Application\ Support/convert-md/templates/
ls <project-root>/Library/templates/ 2>/dev/null   # if the project overrides
```

Don't `find /` or grep the filesystem — the two locations above are the only ones the resolver looks at.
