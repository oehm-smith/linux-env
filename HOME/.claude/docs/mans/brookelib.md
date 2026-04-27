# brookelib — Shared Python Library

## What It Is

brookelib is a pip-installable Python package at `$BROOKELIB_HOME` (default: `~/dev/Python`). Its modules are **symlinks** back to the projects that own them. A `registry.json` tracks which project owns each module.

Any Python project can `from brookelib.X import Y` after running `pip install -e $BROOKELIB_HOME`.

## Setup

### Environment Variable

Add to shell profile (`.zshrc` or similar):
```bash
export BROOKELIB_HOME="$HOME/dev/Python"
```

### First-Time Install

```bash
pip install -e $BROOKELIB_HOME
```

This installs brookelib in editable mode. Symlinked modules are immediately available.

## Adding a Module from a Project

### 1. Create the module in your project

Place shared code in your project, e.g. `my-project/lib/utils.py`.

### 2. Add to your project's install.sh

```bash
#!/bin/bash
set -euo pipefail

BROOKELIB_HOME="${BROOKELIB_HOME:?Set BROOKELIB_HOME in your shell profile}"
PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Copy modules into brookelib (not symlinks — CloudStation can't sync symlinks)
cp "$PROJECT_DIR/lib/utils.py" "$BROOKELIB_HOME/brookelib/utils.py"

# Update registry with checksum for drift detection
python3 -c "
import hashlib, json
from pathlib import Path

def sha256(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()

reg_path = Path('$BROOKELIB_HOME/brookelib/registry.json')
reg = json.loads(reg_path.read_text()) if reg_path.exists() else {'modules': {}}

reg['modules']['utils'] = {
    'source_project': '$PROJECT_DIR',
    'source_file': 'lib/utils.py',
    'phase': 'in-project',
    'description': 'What this module does',
    'consumers': ['$PROJECT_DIR'],
    'checksum': sha256('$PROJECT_DIR/lib/utils.py')
}

reg_path.write_text(json.dumps(reg, indent=2) + '\n')
"

# Ensure brookelib is pip-installed
pip install -e "$BROOKELIB_HOME" -q

echo "Done. 'from brookelib.utils import ...' is now available."
```

### 3. Run install.sh

```bash
cd my-project && ./install.sh
```

## Graduating a Module to Standalone

When a second project needs a module:

1. Create a new repo for the module (e.g. `~/dev/Python/utils-lib/`)
2. Move the source file there
3. Update the new repo's `install.sh` to symlink and update registry with `phase: "standalone"`
4. Run the new `install.sh` — it overwrites the old symlink
5. Both consuming projects now import from the same source

## Adding a Consumer

When a new project starts using an existing brookelib module, add it to the module's `consumers` list in `registry.json`. This is informational — it helps `doctor` report which projects would break if a module disappeared.

## Checking Health

```bash
python3 $BROOKELIB_HOME/scripts/doctor.py
```

Reports:
- Broken symlinks (source file moved or deleted)
- Missing source projects
- Modules in brookelib not tracked in registry
- Registry entries with no corresponding file

## Module Lifecycle Phases

| Phase | Meaning |
|-------|---------|
| `in-project` | Code maintained in its origin project. One consumer. |
| `standalone` | Extracted to own repo. Multiple consumers. |
| `stable` | API settled. Breaking changes need coordination. |

## Current Modules

| Module | Description | Source |
|--------|-------------|--------|
| manifest | Document build manifest parsing | build-system |
| pandoc | Markdown to PDF/DOCX via pandoc | build-system |
| nas | SMB NAS mount/unmount via Keychain | backup-tools |
| backup | Rsync backup with exclude/include | backup-tools |

## CloudStation / Synology Drive Caveat

Symlinks **do not work** under CloudStation sync — it renames them as `*_Conflict.py` files or deletes them entirely. The SMB symlink settings in DSM only affect SMB share browsing, not sync behaviour.

brookelib uses **copy + checksum** instead. `install.sh` copies source files into brookelib and records SHA256 hashes in `registry.json`. `doctor` detects drift between source and installed copy.

## Conventions

- Module files are always `<name>.py` — no sub-packages yet
- Each module has ABOUTME headers and Google-style docstrings
- The `__init__.py` stays minimal — no wildcard exports
- Projects import specific names: `from brookelib.nas import mount`
- `registry.json` is the single source of truth for module ownership
