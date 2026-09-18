# pdf-to-docx.sh — delivery-checkbox PDF → DOCX

**Use when:** a recipient wants a `.docx` on file but will not edit it. The DOCX is low-fidelity — LibreOffice approximates layout with text boxes rather than reconstructing semantic structure.

**Not this tool when:**
- Recipient will edit the DOCX → generate from markdown source with `convert-md.md` using `-f docx`, not from a PDF.
- Source is markdown, not PDF → `convert-md.md` or `build-docs.md`.

Run `pdf-to-docx.sh --claude-help` for the full spec (commands, single-file vs batch mode).
