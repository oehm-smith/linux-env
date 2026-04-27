# brookelib Organisation Model

## Problem

Python projects are multiplying. Shared library code (brookelib) needs to be:
- **Visible** — know what reusable code exists without digging through projects
- **Traceable** — know which project owns each module
- **Decoupled** — projects stay in their own repos, lib is a shared install target

Currently, brookelib has modules as plain files with no record of where they came from or which project owns them.

## Model: Copy + Checksum Registry

brookelib becomes an **assembly point** — a pip-installable package whose modules are copies from their source projects. A `registry.json` tracks ownership, lifecycle phase, and SHA256 checksums for drift detection. (Symlinks were the original design but Synology CloudStation sync doesn't support them.)

### Module Lifecycle

```
Phase 1: IN-PROJECT
  Code lives in project repo, project's install.sh symlinks it into brookelib.
  brookelib/nas.py → ~/dev/Python/backup-tools/lib/nas.py

Phase 2: STANDALONE
  When a second project needs the module, extract to its own repo.
  The new repo's install.sh updates the symlink.
  brookelib/nas.py → ~/dev/Python/nas-utils/nas.py

Phase 3: STABLE
  Module is mature, API settled, multiple consumers.
  Same as STANDALONE but marked stable in registry.
```

### Directory Structure

```
~/dev/Python/                          # $BROOKELIB_HOME
  pyproject.toml                       # pip package config
  brookelib/
    __init__.py
    registry.json                      # module → source mapping + checksums
    manifest.py                        # copy from source project
    pandoc.py                          # copy from source project
    nas.py                             # copy from source project
    backup.py                          # copy from source project
  scripts/
    doctor.py                          # health check: checksums, drift, missing files
```

### registry.json Schema

```json
{
  "modules": {
    "<module_name>": {
      "source_project": "<absolute path to project>",
      "source_file": "<relative path within project>",
      "phase": "in-project | standalone | stable",
      "description": "<what this module does>",
      "consumers": ["<project paths that import this module>"],
      "checksum": "<SHA256 hex digest of source file at install time>"
    }
  }
}
```

### Environment Variable

`BROOKELIB_HOME` — points to `~/dev/Python` (the directory containing `brookelib/` and `pyproject.toml`). Set in shell profile. Used by:
- Project `install.sh` scripts to know where to create symlinks
- `brookelib doctor` to find and validate the registry

### Project install.sh Convention

Each project that contributes modules to brookelib has an `install.sh` that:
1. Checks `$BROOKELIB_HOME` is set
2. Copies source files into `$BROOKELIB_HOME/brookelib/<module>.py`
3. Updates `registry.json` with module metadata and SHA256 checksums
4. Runs `pip install -e $BROOKELIB_HOME` if needed
5. Installs any CLI wrapper scripts to `~/bin/` (with source path baked in)

### brookelib doctor

A health check script that:
- Reads `registry.json`
- Verifies each installed module exists
- Compares checksums between installed copy and source file (detects drift)
- Reports missing files, missing projects, untracked modules, stale checksums

## Current Module Inventory

| Module | Source Project | Phase | Consumers |
|--------|---------------|-------|-----------|
| manifest.py | ~/dev/documentation/2026-02-07_build-system | in-project | manifest_build.py |
| pandoc.py | ~/dev/documentation/2026-02-07_build-system | in-project | convert_md.py, convertproj.py |
| nas.py | (new, backup-tools) | in-project | backup-install |
| backup.py | (new, backup-tools) | in-project | backup-install |

Note: manifest.py and pandoc.py were originally extracted from the build-system project. The build-system's `manifest_build.py` and `convert_md.py` import from brookelib. The canonical shared code lives in brookelib; the build-system is the owning project.

## Migration Steps

1. Create `registry.json` in brookelib
2. For manifest.py / pandoc.py: these are canonical in brookelib (born there), register them
3. Create backup-tools project, move backup code there, install.sh copies into brookelib
4. Move backup-install from linux-env to backup-tools
5. Add `install.sh` to build-system and backup-tools
6. Create `doctor.py` in brookelib
7. Set `BROOKELIB_HOME` in shell profile
8. Update global project registry

## CloudStation Constraint

Synology CloudStation sync does not support symlinks at all — it renames them as `*_Conflict.py` files or deletes them. The SMB symlink settings in DSM only affect SMB share browsing, not sync. This is why brookelib uses copy + checksum instead of symlinks.

## Open Questions

- Should `registry.json` updates be automated (install.sh does it) or manual?
  **Decision: Automated via install.sh** — each project's install.sh is authoritative for its modules.
- What happens if two projects try to own the same module?
  **Decision: Last install wins, doctor reports the conflict.** In practice this shouldn't happen — modules have one owner.
