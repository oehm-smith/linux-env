# Git Worktrees with Claude Code

## Overview

Git worktrees allow you to have multiple working directories for the same repository, enabling parallel development without branch switching conflicts. When combined with [Superpowers](./superpowers.md) and the [seven-agent workflow](./seven-agents.md), worktrees become a powerful tool for organized, parallel development.

## What Are Git Worktrees?

Traditional git workflow:
```
/Users/brooke/myproject/  (switch branches here)
```

Git worktree workflow:
```
/Users/brooke/myproject/                    (main branch)
/Users/brooke/myproject.worktree-feature-A/ (feature-A branch)
/Users/brooke/myproject.worktree-feature-B/ (feature-B branch)
/Users/brooke/myproject.worktree-bugfix-C/  (bugfix-C branch)
```

**Benefits**:
- Work on multiple features simultaneously
- No need to commit/stash when switching tasks
- Each worktree has its own build artifacts and dependencies
- Clean separation of concerns
- Easy to see what's in progress (`git worktree list`)

## Basic Git Worktree Commands

### Create a Worktree

```bash
# Create worktree for existing branch
git worktree add ../myproject.worktree-feature-A feature-A

# Create worktree for new branch
git worktree add -b feature-B ../myproject.worktree-feature-B

# Create worktree with automatic naming
git worktree add ../myproject-feature-C -b feature-C
```

### List Worktrees

```bash
git worktree list

# Output:
# /Users/brooke/myproject              abc123d [main]
# /Users/brooke/myproject.worktree-A   def456e [feature-A]
# /Users/brooke/myproject.worktree-B   789ghij [feature-B]
```

### Remove a Worktree

```bash
# Remove worktree directory
rm -rf ../myproject.worktree-feature-A

# Clean up git metadata
git worktree prune

# Or do both at once
git worktree remove ../myproject.worktree-feature-A
```

### Move Between Worktrees

```bash
# Just cd to the worktree
cd ~/myproject.worktree-feature-A

# Work normally
git status
git add .
git commit -m "feat: implement feature A"
```

## Using Worktrees with Claude Code

### Automatic Worktree Creation (via Superpowers)

When Superpowers is enabled, Claude automatically creates worktrees:

```
You: "Let's build the user authentication feature"

Claude:
1. Creating worktree: /Users/brooke/myproject.worktree-feature-auth
2. Switching to worktree...
3. Starting brainstorm phase...
```

### Manual Worktree Creation

Tell Claude explicitly:

```
"Create a worktree for the export feature and start working there"

Claude will:
1. Run: git worktree add ../myproject.worktree-feature-export -b feature/export
2. cd to the worktree
3. Begin work in that isolated environment
```

### Check Current Worktree

```
"Which worktree am I in?"

Claude will show:
Current worktree: /Users/brooke/myproject.worktree-feature-export
Branch: feature/export
Status: Clean (no uncommitted changes)
```

## Per-Project Configuration

### Enable/Disable Worktrees Globally

```bash
# In Claude Code
/plugin config superpowers disable_git_worktrees=false  # Enable
/plugin config superpowers disable_git_worktrees=true   # Disable
```

### Enable/Disable for Specific Project

#### Method 1: Project Configuration File

Create `.claude-project.json` in your project root:

```json
{
  "name": "My Simple Project",
  "superpowers": {
    "disable_git_worktrees": true
  }
}
```

When Claude starts in this project, it will NOT use worktrees.

#### Method 2: Session Instruction

At the start of your Claude session:

```
"For this project, don't use git worktrees. Work directly in the main branch."
```

Claude will remember this preference for the session.

#### Method 3: Task-Specific

```
"For this simple bug fix, skip the worktree and work here directly"
```

Claude will work in the current directory for just that task.

## Configuration Strategy: Global vs Per-Project

### Choosing Your Default Approach

The key question: **What do MOST of your projects look like?**

#### Strategy 1: Mostly Complex Projects → Enable Globally

**Best for**:
- Enterprise developers working on large codebases
- Team environments with frequent feature development
- Developers who regularly work on multiple features in parallel
- Microservices architecture with many repositories

**Configuration**:
```bash
# Enable worktrees for all projects by default
/plugin config superpowers disable_git_worktrees=false
```

**Override for simple projects**:
```json
// In .claude-project.json for simple projects
{
  "superpowers": {
    "disable_git_worktrees": true
  }
}
```

**Example use case**: You work on 10 enterprise APIs (use worktrees) and 2 simple scripts (disable per-project).

#### Strategy 2: Mostly Simple Projects → Disable Globally

**Best for**:
- Solo developers with mostly small projects
- Rapid prototyping and experimentation
- Personal projects and learning exercises
- Documentation and configuration repositories

**Configuration**:
```bash
# Disable worktrees for all projects by default
/plugin config superpowers disable_git_worktrees=true
```

**Enable for complex projects**:
```json
// In .claude-project.json for complex projects
{
  "superpowers": {
    "disable_git_worktrees": false,
    "auto_create_worktrees": true
  }
}
```

**Example use case**: You have 15 personal projects (no worktrees) and 3 large open-source contributions (enable per-project).

#### Strategy 3: Mixed Workload → Decide Per-Project

**Best for**:
- Freelancers with diverse client projects
- Developers maintaining both personal and work projects
- Mixed complexity across different repositories

**Configuration**:
```bash
# Disable globally to avoid unexpected worktrees
/plugin config superpowers disable_git_worktrees=true
```

**Then explicitly enable where needed**:
```json
// Client project (complex)
{
  "name": "ClientCorp Enterprise API",
  "superpowers": {
    "disable_git_worktrees": false
  }
}

// Personal website (simple)
{
  "name": "Personal Blog",
  "superpowers": {
    "disable_git_worktrees": true
  }
}
```

**Example use case**: You have 5 client projects (varies by project) and 8 personal projects (varies by complexity).

### Decision Matrix

| Your Typical Projects | Recommendation | Global Setting | Per-Project Override |
|----------------------|----------------|----------------|---------------------|
| 80%+ are complex enterprise projects | Enable Globally | `false` | Disable for simple ones |
| 80%+ are simple/personal projects | Disable Globally | `true` | Enable for complex ones |
| Mixed complexity, no clear pattern | Disable Globally | `true` | Decide per-project |
| Team member, large codebase | Enable Globally | `false` | Rarely override |
| Solo developer, many small projects | Disable Globally | `true` | Enable sparingly |

### Making the Decision

Ask yourself:
1. **How many projects do you actively work on?**
   - Few (1-5): Configure per-project
   - Many (10+): Set global default

2. **What's your typical feature development time?**
   - Hours: Probably don't need worktrees
   - Days/weeks: Worktrees will help

3. **Do you context-switch frequently?**
   - Yes: Enable worktrees
   - No: Disable worktrees

4. **Are you on a team with shared repositories?**
   - Yes: Enable worktrees (helps with parallel work)
   - No: Your preference

5. **Do you work on multiple features simultaneously?**
   - Regularly: Enable worktrees
   - Rarely: Disable worktrees

### Recommendation for Brooke

Based on your setup with global CLAUDE.md and focus on GenAI/RAG security work:

**Suggested approach**:
```bash
# Start with disabled globally (safe default)
/plugin config superpowers disable_git_worktrees=true
```

Then enable per-project for:
- Complex RAG applications
- Multi-service architectures
- Long-running feature development
- Projects where you experiment with multiple approaches

This gives you control and avoids unexpected worktrees in simple projects.

## Project-Level Control Examples

### Simple Project (No Worktrees)

`.claude-project.json`:
```json
{
  "name": "Simple Website",
  "superpowers": {
    "disable_git_worktrees": true,
    "workflow": "simple"
  }
}
```

**Result**: Claude works directly in main directory, uses simple workflow.

### Complex Project (With Worktrees)

`.claude-project.json`:
```json
{
  "name": "Enterprise API",
  "superpowers": {
    "disable_git_worktrees": false,
    "auto_create_worktrees": true,
    "worktree_prefix": "api-worktree",
    "workflow": "full-agent"
  }
}
```

**Result**: Claude automatically creates worktrees like `api-worktree-feature-name`.

### Mixed Approach

`.claude-project.json`:
```json
{
  "name": "Web Application",
  "superpowers": {
    "disable_git_worktrees": false,
    "worktree_threshold": "complex"
  }
}
```

**Result**: Claude creates worktrees only for complex features, works directly for simple changes.

## Worktree Naming Conventions

### Superpowers Default Naming

```
{project}.worktree-{branch-name}/
```

Examples:
- `myapi.worktree-feature-auth/`
- `myapi.worktree-bugfix-login/`
- `myapi.worktree-refactor-db/`

### Custom Naming

Configure in `.claude-project.json`:

```json
{
  "superpowers": {
    "worktree_prefix": "wt",
    "worktree_suffix": ""
  }
}
```

Result:
- `myapi-wt-feature-auth/`

## Worktree Workflows

### Workflow 1: Feature Development

```bash
# Claude creates worktree
Worktree: myproject.worktree-feature-user-export
Branch: feature/user-export

# Claude works through:
1. Brainstorm
2. Plan (write tests)
3. Implement
4. Review
5. Create PR

# You review and merge PR
# Then clean up:
git worktree remove ../myproject.worktree-feature-user-export
```

### Workflow 2: Parallel Features

```bash
# Multiple agents, multiple worktrees
BSA Agent: myproject.worktree-analysis/
Architect:  myproject.worktree-design/
Data Eng:   myproject.worktree-migration/

# Each agent works independently
# Results merged to single PR
```

### Workflow 3: Bug Fix While Developing Feature

```bash
# Working on feature
Current: myproject.worktree-feature-payments/

# Bug reported in production
Claude creates: myproject.worktree-bugfix-auth/

# Fix bug independently
# Merge bugfix to main
# Resume feature work in original worktree
```

## Monitoring Worktrees

### Check What's Modified

```bash
# In each worktree
cd ~/myproject.worktree-feature-A
git status

cd ~/myproject.worktree-feature-B
git status
```

### See All Worktrees at Once

```bash
git worktree list

# Enhanced view
for worktree in $(git worktree list | awk '{print $1}'); do
  echo "=== $worktree ==="
  cd $worktree
  git status -s
  cd -
done
```

### Superpowers Worktree Status

```
"Show me the status of all active worktrees"

Claude will:
1. List all worktrees
2. Show branch for each
3. Show uncommitted changes
4. Show last commit in each
```

## Turning Worktrees On/Off

### Globally Enable

```bash
# For all projects
/plugin config superpowers disable_git_worktrees=false
```

All future projects use worktrees by default.

### Globally Disable

```bash
# For all projects
/plugin config superpowers disable_git_worktrees=true
```

All projects work directly in main directory.

### Per-Project Override

Even with global setting, override for specific project:

**In project root**: `.claude-project.json`
```json
{
  "superpowers": {
    "disable_git_worktrees": true  // Override global setting
  }
}
```

### During Project Creation

```
You: "Let's create a new project with worktree support"

Claude:
1. Initializing git repository
2. Creating .claude-project.json with worktrees enabled
3. Ready to use worktrees for this project
```

Or:

```
You: "Create a simple project without worktrees"

Claude:
1. Initializing git repository
2. Creating .claude-project.json with worktrees disabled
3. Working directly in main directory
```

### Mid-Project Changes

```
You: "Let's start using worktrees for this project going forward"

Claude:
1. Updating .claude-project.json
2. Setting disable_git_worktrees=false
3. Next feature will use a worktree
```

## Best Practices

### When to Use Worktrees

✅ **Use worktrees for**:
- Complex features requiring multiple sessions
- Working on multiple features simultaneously
- Features that might take days/weeks
- Team projects with frequent context switching
- Experimental features you might abandon

❌ **Skip worktrees for**:
- Simple bug fixes (< 30 minutes)
- Documentation-only changes
- Single-file modifications
- Configuration tweaks
- Quick experiments

### Worktree Hygiene

```bash
# Weekly: Clean up merged worktrees
git worktree list | grep feature/ | while read dir; do
  cd $dir
  if git branch --merged main | grep -q $(git branch --show-current); then
    echo "Branch merged, removing worktree: $dir"
    git worktree remove $dir
  fi
done

# Monthly: Prune stale worktree metadata
git worktree prune

# Remove all worktrees (when starting fresh)
git worktree list | tail -n +2 | awk '{print $1}' | xargs -I {} git worktree remove {}
```

### Sharing Worktrees with Team

Worktrees are local to your machine. To share work:

```bash
# In worktree
cd ~/myproject.worktree-feature-A
git push origin feature-A

# Teammate can checkout normally (no worktree needed)
git checkout feature-A
```

### Dependencies and Build Artifacts

Each worktree can have independent dependencies:

```bash
# Main project
cd ~/myproject
npm install  # node_modules for main

# Feature worktree
cd ~/myproject.worktree-feature-A
npm install  # Different node_modules for feature-A
```

**Tip**: Use shared node_modules with symlinks to save space:

```bash
# In worktree
ln -s ~/myproject/node_modules ./node_modules
```

## Common Issues and Solutions

### Issue: "Cannot create worktree, branch already exists"

```bash
# Solution 1: Use different branch name
git worktree add ../myproject.worktree-feature-v2 -b feature-auth-v2

# Solution 2: Remove old worktree first
git worktree remove ../old-worktree
git worktree add ../myproject.worktree-feature -b feature-auth
```

### Issue: "Worktree directory still exists but git doesn't know about it"

```bash
# Clean up orphaned directory
rm -rf ../myproject.worktree-old

# Prune git metadata
git worktree prune
```

### Issue: "Too many worktrees, can't remember which is which"

```bash
# Use descriptive names
git worktree add ../myproject.worktree-auth-jwt -b feature/auth-jwt
git worktree add ../myproject.worktree-auth-oauth -b feature/auth-oauth

# Or ask Claude to track them
"Show me all my worktrees and what they're for"
```

### Issue: "Want to delete worktree but have uncommitted changes"

```bash
# Option 1: Commit the changes
cd ~/myproject.worktree-feature
git add .
git commit -m "WIP: save progress"
git push origin feature-branch

# Option 2: Create a patch
git diff > ~/feature.patch

# Option 3: Force remove (loses changes)
git worktree remove --force ../myproject.worktree-feature
```

### Issue: "Claude created worktree in wrong location"

Configure worktree location in `.claude-project.json`:

```json
{
  "superpowers": {
    "worktree_base_path": "/Users/brooke/worktrees"
  }
}
```

Now worktrees go to:
```
/Users/brooke/worktrees/myproject.worktree-feature-A/
/Users/brooke/worktrees/myproject.worktree-feature-B/
```

## Integration with Seven Agents

See [seven-agents.md](./seven-agents.md) for how agents use worktrees.

### Parallel Agent Work

```
BSA Agent:
  Worktree: myproject.worktree-bsa-analysis/
  Output: requirements.md

System Architect (depends on BSA):
  Worktree: myproject.worktree-arch-design/
  Input: requirements.md from BSA worktree
  Output: schema.sql

Data Engineer (depends on Architect):
  Worktree: myproject.worktree-data-migration/
  Input: schema.sql from Architect worktree
  Output: migration.sql
```

### Sequential Agent Work (Same Worktree)

```
All agents work in: myproject.worktree-feature-export/

BSA Agent → creates requirements.md
Architect → reads requirements.md, creates schema.sql
Data Engineer → reads schema.sql, creates migration.sql
Security → audits migration.sql
QAS → creates tests
RTE → creates PR
```

## Quick Reference

| Command | Purpose |
|---------|---------|
| `git worktree add <path> -b <branch>` | Create new worktree |
| `git worktree list` | List all worktrees |
| `git worktree remove <path>` | Remove worktree |
| `git worktree prune` | Clean up metadata |
| `cd <worktree-path>` | Switch to worktree |
| `/plugin config superpowers disable_git_worktrees=true` | Disable globally |
| `.claude-project.json` | Configure per-project |

## Configuration Reference

### Global Configuration (via /plugin config)

```bash
/plugin config superpowers disable_git_worktrees=false
/plugin config superpowers worktree_prefix="wt"
/plugin config superpowers auto_cleanup_worktrees=true
```

### Project Configuration (.claude-project.json)

```json
{
  "superpowers": {
    "disable_git_worktrees": false,
    "worktree_prefix": "myapp-wt",
    "worktree_base_path": "/Users/brooke/worktrees",
    "auto_create_worktrees": true,
    "worktree_threshold": "complex",
    "auto_cleanup_merged": true
  }
}
```

### Configuration Precedence

1. **Session instruction** (highest priority)
   - "Don't use worktrees for this task"

2. **Project configuration** (.claude-project.json)
   - Project-specific settings

3. **Global configuration** (/plugin config)
   - Default for all projects

4. **Superpowers defaults** (lowest priority)
   - Built-in defaults

## See Also

- [Superpowers](./superpowers.md) - Plugin that automates worktrees
- [Seven Agents](./seven-agents.md) - Using worktrees with agent workflows
- [Claude Skills](./claude-skills.md) - Skills for worktree management

## External Resources

- [Git Worktree Documentation](https://git-scm.com/docs/git-worktree)
- [Superpowers GitHub](https://github.com/obra/superpowers-marketplace)

---

**Last Updated**: 2025-10-14
**Git Version**: 2.30+ required for full worktree support
**Superpowers**: Compatible with all versions
