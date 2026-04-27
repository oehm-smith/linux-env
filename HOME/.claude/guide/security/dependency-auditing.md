# Dependency Auditing Setup

Your Claude Code environment includes three layers of dependency security scanning, all working through Claude's normal workflow.

## Overview

```
Layer 1: Pre-Install Hook ─── Blocks known-bad packages BEFORE install
Layer 2: Post-Install Audit ── Runs vulnerability scan AFTER install
Layer 3: On-Demand / Pre-Commit ── Full audit via /audit-deps or git hook
```

## Layer 1: Pre-Install Blocklist (Automatic)

**How it works**: Every time Claude runs a package install command (`npm install`, `pnpm add`, `pip install`, `uv add`), a hook fires that checks the package name against a local blocklist.

**Blocklist location**: `~/.claude/scripts/known-malicious-packages.txt`

**What's currently blocked**:
- `litellm` — compromised in TeamPCP attack (March 2026, versions 1.82.7/1.82.8)
- `telnyx` — compromised in TeamPCP attack (March 2026, versions 4.87.1/4.87.2)
- `termncolor` — typosquatting package (mimics `termcolor`)
- `colorinal` — malicious dependency of `termncolor`

**To update the blocklist**: Edit the file directly. One package name per line. Lines starting with `#` are comments. Changes take effect immediately.

**If a legitimate package is blocked**: Remove or comment out the entry in the blocklist. For packages where only specific versions are compromised (like litellm), pin to a safe version in your requirements and remove the blocklist entry.

## Layer 2: Post-Install Audit (Automatic)

**How it works**: After any package install command completes, a hook runs the appropriate audit tool and displays findings.

**Tools used** (in order of preference):
| Project Type | Audit Tool |
|-------------|------------|
| Python (uv project) | `uv audit` |
| Python (pip project) | `pip-audit` (if installed) or `uv audit` |
| Node (pnpm) | `pnpm audit` |
| Node (npm) | `npm audit` |

**Note**: This hook runs after the install, so it catches vulnerabilities in the full dependency tree (including transitive dependencies), not just the package you're installing.

## Layer 3: On-Demand and Pre-Commit

### `/audit-deps` Command

Run at any time by typing `/audit-deps`. Claude will:
1. Detect project type (Python and/or Node)
2. Run the appropriate audit tool
3. Cross-reference against the blocklist
4. Check for specific known-compromised versions
5. Report findings in a structured table

**When to use**:
- Starting work on a new-to-you project
- Before creating a PR/MR
- After pulling upstream changes with dependency updates
- Periodically during long development sessions

### Git Pre-Commit Hook

A script at `~/.claude/scripts/pre-commit-audit.sh` can be added to any project's git hooks. It blocks commits when vulnerabilities are found.

**Quick setup** (per project):
```bash
cp ~/.claude/scripts/pre-commit-audit.sh .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit
```

**Or with the pre-commit framework**, add to `.pre-commit-config.yaml`:
```yaml
repos:
  - repo: local
    hooks:
      - id: audit-deps
        name: Dependency Audit
        entry: ~/.claude/scripts/pre-commit-audit.sh
        language: script
        pass_filenames: false
        stages: [pre-commit]
        files: '(package\.json|package-lock\.json|pnpm-lock\.yaml|requirements.*\.txt|pyproject\.toml|uv\.lock)$'
```

## Installing the Audit Tools

### Python

**Recommended**: uv (includes `uv audit` built-in since v0.10.12)
```bash
# If you already have uv, you're set — just run:
uv audit
```

**Alternative**: pip-audit
```bash
# Install globally with uv:
uv tool install pip-audit

# Or with pip:
pip install pip-audit
```

### Node

`npm audit` and `pnpm audit` are built-in — no extra installation needed.

### Socket.dev (Optional — Advanced)

For deeper supply chain analysis (detects suspicious behavior, not just known CVEs):
```bash
npm install -g @socketsecurity/cli
socket npm audit   # or: socket pypi scan
```

Socket analyzes package source code for suspicious patterns (network calls, eval, obfuscated code, install scripts) — catches threats before they have a CVE.

## Background: TeamPCP Supply Chain Attack (March 2026)

This setup was created in response to the TeamPCP campaign, which compromised:

| Date | Package | Malicious Versions | Impact |
|------|---------|-------------------|--------|
| Mar 24 | litellm (PyPI) | 1.82.7, 1.82.8 | Credential stealer |
| Mar 27 | telnyx (PyPI) | 4.87.1, 4.87.2 | Credential stealer |
| Mar 31 | axios (npm) | 1.14.1, 0.30.4 | Remote access trojan |

The attackers compromised Trivy (a security scanner used in CI/CD), stole publishing tokens, and used them to publish malicious versions of popular packages. The litellm compromise was active for ~3 hours before PyPI quarantined it, but it received ~40,000 downloads.

**Key references**:
- [Palo Alto Unit 42 — TeamPCP analysis](https://unit42.paloaltonetworks.com/teampcp-supply-chain-attacks/)
- [Snyk — LiteLLM backdoor](https://snyk.io/blog/poisoned-security-scanner-backdooring-litellm/)
- [Datadog — Full campaign timeline](https://securitylabs.datadoghq.com/articles/litellm-compromised-pypi-teampcp-supply-chain-campaign/)
- [LiteLLM official security update](https://docs.litellm.ai/blog/security-update-march-2026)

---

**Last Updated**: 2026-04-20
