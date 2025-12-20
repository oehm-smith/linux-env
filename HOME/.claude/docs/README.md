# Claude Code Documentation

Personal documentation for using Claude Code with advanced features like Skills, Superpowers, and multi-agent workflows.

## Quick Navigation

### Core Concepts

1. **[Claude Skills](./claude-skills.md)** - Skills system for teaching Claude specialized capabilities
   - What are skills and how they work
   - Creating your own skills
   - Skill directory structure
   - Best practices and examples

2. **[Superpowers Plugin](./superpowers.md)** - Advanced Claude Code plugin by Jesse Tilly
   - Installation and configuration
   - Brainstorm → Plan → Implement workflow
   - Test-Driven Development (TDD)
   - Memory system and persuasion techniques

3. **[Seven Agents](./seven-agents.md)** - Specialized agent roles for complex development
   - BSA Agent, System Architect, Data Engineer
   - Security Engineer, Tech Writer, QAS Agent, RTE Agent
   - When to use each agent
   - Multi-agent workflow examples

4. **[Git Worktrees](./git-worktrees.md)** - Managing parallel development
   - What are worktrees and why use them
   - Enabling/disabling per-project
   - Configuration options
   - Best practices and troubleshooting

## Getting Started

### First Time Setup

1. **Install Superpowers**:
   ```bash
   /plugin marketplace add obra/superpowers-marketplace
   /plugin install superpowers@superpowers-marketplace
   ```

2. **Create Skills Directory**:
   ```bash
   mkdir -p ~/.claude/skills
   ```

3. **Choose Your Workflow**:
   - Simple projects: Disable worktrees, use basic workflow
   - Complex projects: Enable worktrees, use seven-agent workflow

### Common Use Cases

#### Simple Bug Fix
- **Workflow**: Simple (no worktrees)
- **Agents**: None (direct work)
- **Config**: `.claude-project.json` with `disable_git_worktrees: true`

#### Feature Development
- **Workflow**: Full (with worktrees)
- **Agents**: Subset (BSA → Architect → Implementation → QAS → RTE)
- **Config**: Superpowers enabled with auto worktrees

#### Complex Feature (Database + Security)
- **Workflow**: Full multi-agent
- **Agents**: All seven agents
- **Config**: Full Superpowers with agent dispatch skill

## Documentation Structure

```
~/.claude/
├── docs/
│   ├── README.md              (this file)
│   ├── claude-skills.md       (Skills system)
│   ├── superpowers.md         (Superpowers plugin)
│   ├── seven-agents.md        (Agent workflows)
│   └── git-worktrees.md       (Worktree management)
├── skills/
│   ├── analysis/
│   ├── architecture/
│   ├── database/
│   ├── security/
│   ├── documentation/
│   ├── testing/
│   └── deployment/
└── CLAUDE.md                  (Global instructions)
```

## Key Concepts at a Glance

| Concept | What It Is | When to Use |
|---------|------------|-------------|
| **Skills** | Markdown files that teach Claude capabilities | Create for repeated patterns |
| **Superpowers** | Plugin for structured development workflow | Complex features, TDD enforcement |
| **Seven Agents** | Specialized roles (BSA, Architect, etc.) | Large features requiring multiple expertise areas |
| **Worktrees** | Parallel git working directories | Multiple features in progress simultaneously |

## Quick Commands

### Superpowers
```bash
# Install
/plugin install superpowers@superpowers-marketplace

# Configure
/plugin config superpowers disable_git_worktrees=false

# Status
/plugin list
```

### Git Worktrees
```bash
# List worktrees
git worktree list

# Create worktree
git worktree add <path> -b <branch>

# Remove worktree
git worktree remove <path>

# Clean up
git worktree prune
```

### Claude Commands
```bash
# Use specific agent
"Use the BSA Agent to analyze this ticket"

# Use full workflow
"Process this using the seven-agent workflow"

# Disable worktrees for task
"Don't use worktrees for this simple fix"

# Check status
"Show me all active worktrees and their status"
```

## Configuration Examples

### Simple Project (.claude-project.json)
```json
{
  "name": "Simple Website",
  "superpowers": {
    "disable_git_worktrees": true,
    "workflow": "simple"
  }
}
```

### Complex Project (.claude-project.json)
```json
{
  "name": "Enterprise API",
  "superpowers": {
    "disable_git_worktrees": false,
    "auto_create_worktrees": true,
    "worktree_prefix": "api-wt",
    "workflow": "full-agent",
    "require_tests": true
  }
}
```

## Querying Documentation

Ask Claude about this documentation:

```
"What's in my documentation?"
"Tell me about Claude skills"
"How do I use the seven-agent workflow?"
"When should I use git worktrees?"
"How do I disable worktrees for a specific project?"
```

Claude can reference these docs to answer your questions.

## Cross-References

- **Skills** ↔️ **Agents**: Each agent uses specific skills
- **Superpowers** ↔️ **Worktrees**: Superpowers automates worktree creation
- **Agents** ↔️ **Worktrees**: Agents can work in parallel using worktrees
- **Skills** ↔️ **Superpowers**: Superpowers uses the skills system

## Decision Trees

### Should I Use Worktrees?

```
Is it a simple bug fix (< 30 min)?
├─ Yes → Don't use worktrees
└─ No → Is it a complex feature?
    ├─ Yes → Use worktrees
    └─ No → Am I working on multiple features?
        ├─ Yes → Use worktrees
        └─ No → Don't use worktrees
```

### Which Agents Should I Use?

```
Does it involve database changes?
├─ Yes → Need Data Engineer
│   └─ Security sensitive?
│       ├─ Yes → Add Security Engineer
│       └─ No → Continue
└─ No → Continue

Is it a new API endpoint?
├─ Yes → Need System Architect + Tech Writer
└─ No → Continue

Does it need tests?
└─ Yes → Need QAS Agent

Ready to deploy?
└─ Yes → Need RTE Agent
```

## Resources

- **Original Superpowers Blog**: https://blog.fsck.com/2025/10/09/superpowers/
- **GitHub Repository**: https://github.com/obra/superpowers-marketplace
- **Community**: https://www.skool.com/new-society/claude-45-and-agent-orchestration
- **Git Worktrees Docs**: https://git-scm.com/docs/git-worktree

## Maintenance

### Updating Documentation

These docs live in `~/.claude/docs/`. To update:

1. Edit the markdown file directly
2. Or ask Claude: "Update the git-worktrees documentation to include X"
3. Cross-check references between docs

### Adding New Documentation

```
"Create documentation for [new topic] in ~/.claude/docs/"
```

### Backing Up

```bash
# Backup docs and skills
tar -czf ~/claude-backup-$(date +%Y%m%d).tar.gz ~/.claude/docs ~/.claude/skills
```

## Version History

- **2025-10-14**: Initial documentation created
  - claude-skills.md
  - superpowers.md
  - seven-agents.md
  - git-worktrees.md
  - README.md (this file)

---

**Created**: 2025-10-14
**Last Updated**: 2025-10-14
**Owner**: Brooke
**Status**: Active
