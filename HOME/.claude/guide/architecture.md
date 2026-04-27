# Architecture: How ~/.claude/ Is Organized

## Directory Map

```
~/.claude/
├── CLAUDE.md                  # Global rules for Claude (38KB) — loaded every session
├── settings.json              # Hooks, permissions, plugins, UI preferences
│
├── commands/                  # Slash commands (user-invocable via /command-name)
│   ├── audit-deps.md          # /audit-deps — dependency vulnerability scan
│   ├── health-check.md        # /health-check — project health check
│   ├── toolkit.md             # /toolkit — list all commands and skills
│   ├── add-file-header.md     # /add-file-header — ABOUTME headers
│   ├── create-pdf.md          # /create-pdf — markdown to PDF
│   ├── email-doc.md           # /email-doc — email a document
│   ├── send-message.md        # /send-message — iMessage
│   ├── methodologies.md       # /methodologies — list/select methodology
│   ├── rules.md               # /rules — review rule compliance
│   └── swecom.md              # /swecom — SWECOM skill mapping
│
├── scripts/                   # Shell scripts (hooks, automation)
│   ├── pre-install-check.sh   # PreToolUse hook: blocks known-bad packages
│   ├── post-install-audit.sh  # PostToolUse hook: runs audit after installs
│   ├── pre-commit-audit.sh    # Git pre-commit hook: audits before commit
│   └── known-malicious-packages.txt  # Blocklist for pre-install hook
│
├── skills/                    # Claude skills (implementation phase)
│   ├── brooke-custom-agents/  # Custom agent definitions
│   ├── phase-router/          # Routes to design vs implementation skills
│   └── using-skills/          # Meta-skill for skill discovery
│
├── skills-design/             # Claude skills (design phase, SWECOM-aligned)
│   ├── acceptance-testing/
│   ├── accessibility/
│   ├── architecture/
│   ├── code-quality/
│   ├── documentation/
│   ├── domain-driven-design/
│   ├── metrics/
│   ├── migrations/
│   ├── release-management/
│   ├── requirements-analysis/
│   └── security-audit/
│
├── methodologies/             # Development methodology definitions
│   ├── srdd.md                # Spec-Roundtrip Driven Development
│   ├── ssrdd.md               # Scaled SRDD (multi-domain)
│   ├── aira.md                # AI Implementation Readiness & Adoption
│   ├── trad.md                # Technology Roadmap & Advisory Discovery
│   └── vibe.md                # Minimal process (scripts, prototypes)
│
├── docs/                      # Claude-facing reference material
│   ├── README.md              # Index for docs/
│   ├── claude-skills.md       # Skills system reference
│   ├── superpowers.md         # Superpowers plugin docs
│   ├── seven-agents.md        # Multi-agent workflow docs
│   ├── git-worktrees.md       # Git worktree guidance
│   └── ...
│
├── guide/                     # Human-facing documentation (YOU ARE HERE)
│   ├── README.md
│   ├── architecture.md
│   ├── commands-reference.md
│   ├── skills-reference.md
│   ├── hooks-and-automation.md
│   ├── methodologies-reference.md
│   └── security/
│       └── dependency-auditing.md
│
├── plugins/                   # Installed plugins (Superpowers)
├── projects/                  # Per-project memory and settings
├── backups/                   # Backup files
├── config/                    # Additional configuration
├── session-env/               # Per-session environment state
├── sessions/                  # Session history
├── plans/                     # Saved plans
├── tasks/                     # Task state
├── todos/                     # Todo tracking
└── statusline-philips.sh      # Custom status line script
```

## How the Pieces Connect

```
You type a command
        │
        ▼
┌─────────────────┐
│  CLAUDE.md       │ ← Global rules loaded every session
│  (38KB of rules) │
└────────┬────────┘
         │
         ▼
┌─────────────────┐     ┌──────────────┐
│  settings.json   │────▶│  Hooks       │ ← Fire on tool events
│  (config)        │     │  (scripts/)  │
└────────┬────────┘     └──────────────┘
         │
         ▼
┌─────────────────┐     ┌──────────────┐
│  Superpowers     │────▶│  Skills      │ ← Auto-triggered by context
│  (plugin)        │     │  (skills*/)  │
└────────┬────────┘     └──────────────┘
         │
         ▼
┌─────────────────┐
│  Commands        │ ← Invoked via /slash-command
│  (commands/)     │
└─────────────────┘
```

## Key Files to Know

| File | When you'd edit it |
|------|-------------------|
| `CLAUDE.md` | Changing Claude's global behavior rules |
| `settings.json` | Adding hooks, permissions, changing plugins |
| `scripts/known-malicious-packages.txt` | Adding packages to the blocklist |
| `commands/*.md` | Adding or modifying slash commands |
| `methodologies/*.md` | Adding or modifying development methodologies |

---

**Last Updated**: 2026-04-20
