# Python

## Project tooling: use uv

For **new** Python projects, use [`uv`](https://docs.astral.sh/uv/) in
project mode. For **existing** projects, migrate to uv on the next
tooling touch (adding deps, bumping Python, reworking install). Don't
rewrite a working project just to switch.

Not: `pip + venv + requirements.txt`, Poetry, Pipenv, pyenv. uv
subsumes them all — resolver, lockfile, Python interpreter manager,
venv creation, script execution.

### New-project skeleton

```sh
curl -LsSf https://astral.sh/uv/install.sh | sh   # install uv if missing
uv init <project>
```

Commit `pyproject.toml` AND `uv.lock`. Both are source of truth. Add
`.venv/` to `.gitignore`.

### `pyproject.toml` conventions

- `requires-python = ">=X.Y"` — the floor. Code may use any feature
  from this version up.
- `.python-version` file at repo root — the **active** minor used by
  uv when materialising `.venv/`. Lets you pin a tested minor without
  changing the floor.
- Dev deps live in `[dependency-groups]` (uv-native, auto-installed by
  `uv sync`), **not** `[project.optional-dependencies]` (older style,
  installed only on request).

### Day-to-day commands

| Task                        | Command                                   |
| --------------------------- | ----------------------------------------- |
| Create/refresh `.venv/`     | `uv sync`                                 |
| Run anything in the venv    | `uv run <cmd>` (e.g. `uv run pytest`)     |
| Add a runtime dep           | `uv add <pkg>`                            |
| Add a dev dep               | `uv add --group dev <pkg>`                |
| Bump one dep                | `uv lock --upgrade-package <pkg>`         |
| Change Python minor         | edit `.python-version`, then `uv sync`    |

Never activate `.venv/` manually. Always go through `uv run` — it
re-syncs if the venv is stale, handles orphaned venvs after a
Homebrew Python bump, and keeps the invocation path consistent
between humans and installed shell wrappers.

### Shell wrappers for installed CLIs

CLIs installed outside the project (e.g. into `~/.local/bin`) should
`exec` through uv so they stay bound to the project's locked
environment:

```sh
exec "$UV_BIN" run --project "$PROJECT_ROOT" --quiet python "$SCRIPT" "$@"
```

Bake **absolute paths** at install time (sed-substitute `__UV_BIN__`
and the project dir into a template), not `#!/usr/bin/env`. Reason:
launchd/cron run with a bare `PATH` that may not include uv or the
right Python.

`exec` is deliberate — it replaces the wrapper shell with the uv
process so signals (Ctrl-C) and exit codes propagate cleanly. It is
not a security concern here: no shell string is being interpreted as
code; `"$@"` forwards argv entries, and the baked variables are
install-time constants we control.

### Version drift awareness

Pinning via `.python-version` means you won't notice when Python has
moved on upstream. New Python projects should also write a
`.language-versions.json` at install/sync time once the drift-check
tooling lands — see the design brief at
`file-utils/docs/2026-10-15_handover-for-goc_language-version-tracking.md`.
Deferred until that tool exists.

### When NOT to migrate an existing project

- Project is being archived — no churn.
- Hard upstream constraint (e.g. an AWS Lambda layer or vendor
  pipeline that assumes `pip install -r requirements.txt`).

Everything else: migrate on the next tooling touch.
