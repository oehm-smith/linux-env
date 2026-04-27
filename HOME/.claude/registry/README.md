# Global Project Registry

Machine-readable registry of all Brooke's active projects. Lives at `~/.claude/registry/` so any Claude Code session can find it regardless of working directory.

## Files

- **projects.json** — All known projects with paths, descriptions, status, and relationships
- **README.md** — This file

## For Claude Sessions

When Brooke mentions a project by name, check `projects.json` to find its path. When creating a new project, add it here. When a project is archived or abandoned, set its status to `archived`.

## Project Fields

| Field | Required | Description |
|-------|----------|-------------|
| path | yes | Absolute path (~ allowed) |
| description | yes | One-line summary |
| language | yes | Primary language |
| status | yes | `active`, `planned`, `archived` |
| brookelib_modules | no | Modules this project contributes to brookelib |
| cli_tools | no | Commands installed to ~/bin |
| notes | no | Anything else worth knowing |

## Maintenance

- Add new projects when they're created
- Update status when projects are archived
- Keep brookelib_modules in sync with brookelib's registry.json
