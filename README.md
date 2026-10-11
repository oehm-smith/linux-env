# linux-env

My Linux/macOS environment — dotfiles, shell startup config, and `~/bin/`
scripts kept in one git repo so a fresh machine is a clone-and-symlink job.

## Scope

**This repo wires:**

- Shell startup config: `.bash*`, `.profile`, `.zshrc*`, `.inputrc`
- Per-user config dirs: `.claude/`, `.gitconfig`
- `~/bin/` — stdlib-only or compiled scripts and tools
- `/etc/` fragments that need to live outside `$HOME`

**This repo does NOT wire:**

- Tools with Python dependencies — those have their own project repo with
  per-tool venv setup (e.g. `goc`, `iac`, `misc-utils`)
- Runtime state — anything written at runtime by tools (`.hermes/` tree,
  Claude lockfiles, synced caches, SQLite dbs, logs). See `.gitignore`.

## Install on a fresh machine

```
# 1. Clone into /opt/linux-env
sudo mkdir -p /opt && cd /opt
sudo git clone git@github.com:oehm-smith/linux-env.git
sudo chown -R "$USER" /opt/linux-env

# 2. Wire $HOME dotfiles and dirs (as the normal user — not root)
cd /opt/linux-env
./install_home.sh

# 3. Wire /etc fragments (requires root)
sudo ./install_etc.sh
```

Each script iterates its respective tree (`HOME/*` or `ETC/*`) and symlinks
every entry into the target location. Existing files are backed up with a
`.YYYYMMDD-HHMMSS` suffix. Existing symlinks are replaced.

**Adding a new dotfile** = drop it into `HOME/`, re-run `install_home.sh`,
commit. No code changes needed.

## Drift detection

`scripts/drift.sh` reports local drift — files present on this machine but
not yet committed, grouped by top-level `HOME/` subdir, with suggestions
for likely `.gitignore` candidates (locks, databases, caches).

```
./scripts/drift.sh
```

Use before a sync-to-new-machine to make sure nothing you rely on is sitting
uncommitted.

## Known gotchas

- `install_home.sh` must NOT be run as root. On macOS, `sudo` makes `~`
  resolve to `/var/root`, so dotfiles would wire into root's home. The script
  refuses to run as root.
- `~/bin` becomes a dir-symlink to `/opt/linux-env/HOME/bin/`. Anything you
  drop into `~/bin/` lives in this repo. Keep that in mind when writing new
  scripts: either commit them, migrate them to a tool project with its own
  install, or add them to `.gitignore`.
- The `.hermes/` tree and various Claude Code synced/lock files are
  gitignored — they're per-machine runtime state. Hermes recreates its own
  state on install.
