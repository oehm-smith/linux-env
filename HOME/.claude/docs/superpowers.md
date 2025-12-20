# Superpowers: Advanced Claude Code Plugin

## Overview

Superpowers is a plugin for Claude Code created by Jesse Tilly (obra) that transforms Claude into a structured, methodical development partner. It implements a "brainstorm → plan → implement" workflow with automatic git worktree management, Test-Driven Development, and specialized agent capabilities.

**Source**: https://blog.fsck.com/2025/10/09/superpowers/

## Why Superpowers?

Without Superpowers, Claude can be helpful but sometimes inconsistent. Superpowers provides:

- ✅ Structured development workflow
- ✅ Automatic test creation (TDD)
- ✅ Git worktree management for parallel tasks
- ✅ Skills-based agent specialization
- ✅ Memory system for context retention
- ✅ Code review automation
- ✅ GitHub integration

## Installation

### Quick Install

```bash
# Open Claude Code, then run:
/plugin marketplace add obra/superpowers-marketplace
/plugin install superpowers@superpowers-marketplace
```

### Verification

After installation, verify it's active:
```bash
/plugin list
```

You should see `superpowers` in the installed plugins list.

## Core Concepts

### 1. Skills System

Skills are markdown files that teach Claude specialized capabilities. See [claude-skills.md](./claude-skills.md) for details.

**Location**: `~/.claude/skills/`

**Example Structure**:
```
~/.claude/skills/
├── coding/
│   ├── tdd/SKILL.md
│   └── code_review/SKILL.md
├── architecture/
│   └── system_design/SKILL.md
└── meta/
    └── agent_dispatch/SKILL.md
```

### 2. Brainstorm → Plan → Implement Workflow

Superpowers enforces this three-phase process:

#### Phase 1: Brainstorm
- Analyze requirements
- Identify constraints
- Consider alternatives
- Document assumptions

#### Phase 2: Plan
- Create technical specification
- Write failing tests (RED phase)
- Define acceptance criteria
- Identify dependencies

#### Phase 3: Implement
- Write minimal code to pass tests (GREEN phase)
- Refactor while keeping tests green
- Review code
- Create pull request

### 3. Git Worktree Management

Superpowers automatically creates git worktrees for parallel development:

```bash
# Main project directory
/Users/brooke/myproject/

# Superpowers creates worktrees:
/Users/brooke/myproject.worktree-feature-auth/
/Users/brooke/myproject.worktree-feature-api/
```

**Benefits**:
- Work on multiple features simultaneously
- No branch switching conflicts
- Clean separation of concerns
- Easy to review each feature independently

See [git-worktrees.md](./git-worktrees.md) for detailed worktree management.

### 4. Test-Driven Development (TDD)

Superpowers enforces RED/GREEN TDD:

**RED Phase** (Write Failing Test):
```typescript
describe('User Authentication', () => {
  it('should reject invalid passwords', async () => {
    const result = await authenticateUser('user@example.com', 'wrong');
    expect(result).toBeNull();
  });
});
```

**GREEN Phase** (Make Test Pass):
```typescript
async function authenticateUser(email: string, password: string) {
  const user = await findUser(email);
  if (!user) return null;

  const isValid = await comparePasswords(password, user.passwordHash);
  return isValid ? generateToken(user) : null;
}
```

### 5. Agent Specialization

Superpowers enables specialized agent roles. See [seven-agents.md](./seven-agents.md) for the recommended agent team.

### 6. Memory System

Superpowers includes a partially-implemented memory system:

- Vector indexing of past conversations
- SQLite storage for retrieval
- Context-aware suggestions based on history

**Note**: Memory features are still in development.

## Configuration

### Global Configuration

```bash
# Check current configuration
/plugin config superpowers

# Disable git worktrees globally
/plugin config superpowers disable_git_worktrees=true

# Enable automatic PR creation
/plugin config superpowers auto_create_pr=true

# Set default branch
/plugin config superpowers default_branch=main
```

### Per-Project Configuration

Create `.claude-project.json` in your project root:

```json
{
  "superpowers": {
    "disable_git_worktrees": false,
    "auto_create_pr": true,
    "default_branch": "develop",
    "require_tests": true,
    "code_review_enabled": true
  }
}
```

## Usage Patterns

### Simple Task (No Worktrees)

```bash
# Tell Claude to work simply
"Let's add a new API endpoint without using worktrees"
```

Claude will work directly in your current branch.

### Complex Feature (With Worktrees and Full Workflow)

```bash
# Enable full workflow
"Let's build the user authentication system using the full Superpowers workflow"
```

Claude will:
1. Create a git worktree
2. Brainstorm the approach
3. Plan the implementation
4. Write failing tests
5. Implement to pass tests
6. Review code
7. Create PR (if configured)

### Multi-Agent Workflow

```bash
# Use specialized agents
"Process ticket WOR-315 using the full BSA agent workflow"
```

Superpowers will dispatch tasks to specialized agents:
1. BSA Agent - Analyze requirements
2. System Architect - Design schema
3. Data Engineer - Create migrations
4. Security Engineer - Audit policies
5. Tech Writer - Update docs
6. QAS Agent - Run tests
7. RTE Agent - Create PR

## Persuasion Techniques (Cialdini's Influence)

Superpowers applies psychological principles to improve AI reliability:

### 1. Authority
Skills establish Claude as an "expert" in specific domains, reducing hallucination.

### 2. Commitment & Consistency
The brainstorm → plan → implement workflow creates commitment at each phase.

### 3. Social Proof
Skills document "proven patterns" that work, encouraging their reuse.

### 4. Scarcity
TDD creates artificial scarcity: "Write ONLY enough code to pass the test."

### 5. Reciprocity
Superpowers "teaches" Claude skills, creating a sense of investment.

### 6. Liking
Structured workflow reduces frustration for both human and AI.

## Workflow Examples

### Example 1: Adding a REST API Endpoint

```
You: "Let's add a POST /api/users endpoint with proper auth"

Claude (with Superpowers):
1. [Brainstorm] Analyzing requirements...
   - Need JWT validation middleware
   - Database schema for users table
   - Input validation (email, password)
   - Password hashing

2. [Plan] Creating technical spec...
   - Creating worktree: myproject.worktree-feature-users-api
   - Writing failing tests for:
     * Endpoint rejects unauthenticated requests
     * Endpoint validates email format
     * Endpoint hashes password before storage

3. [Implement] Writing code...
   - ✅ All tests passing
   - Running code review...
   - Creating PR: "feat: add user registration endpoint"
```

### Example 2: Database Migration

```
You: "Create a migration to add RLS policies for user data"

Claude (with Superpowers):
1. [Brainstorm] Security considerations...
   - Row-level security for multi-tenant isolation
   - Policy for user owns data
   - Policy for admin access

2. [Plan] Using Data Engineer agent...
   - Migration file: 20251014_add_user_rls.sql
   - Tests for policy enforcement

3. [Implement] Creating migration...
   - Security Engineer agent reviewing policies
   - Testing with different user roles
   - Documenting in governance docs (Tech Writer agent)
```

## Advanced Features

### Skill Extraction

Superpowers can extract skills from books and documentation:

```bash
"Extract skills from this article: [paste article]"
```

Claude will:
1. Identify reusable patterns
2. Create skill documents
3. Save to `~/.claude/skills/`

### Skill Testing

Test a skill before using it in production:

```bash
/test-skill requirements-analysis
```

### Skill Marketplace

Share and download skills from the community:

```bash
# Browse available skills
/skills marketplace

# Install a skill
/skills install tdd-patterns@community

# Publish your skill
/skills publish my-custom-skill
```

**Note**: Marketplace features are in development.

## Troubleshooting

### Superpowers Not Working

1. **Check installation**:
   ```bash
   /plugin list
   ```

2. **Verify skills directory**:
   ```bash
   ls -la ~/.claude/skills/
   ```

3. **Reinstall**:
   ```bash
   /plugin uninstall superpowers
   /plugin install superpowers@superpowers-marketplace
   ```

### Worktrees Creating Issues

1. **List active worktrees**:
   ```bash
   git worktree list
   ```

2. **Clean up stale worktrees**:
   ```bash
   git worktree prune
   ```

3. **Disable temporarily**:
   ```
   "For this task, don't use worktrees"
   ```

### Tests Failing Unexpectedly

1. **Check test output** - Don't skip error messages
2. **Verify test isolation** - Are tests affecting each other?
3. **Review recent changes** - What changed since tests passed?
4. **Ask Claude**: "Why is this test failing?"

### Claude Not Following Workflow

1. **Explicit instruction**:
   ```
   "Use the Superpowers brainstorm → plan → implement workflow for this task"
   ```

2. **Check project config** - Is Superpowers enabled for this project?

3. **Restart session** - Sometimes Claude needs a fresh start

## Best Practices

### Do's
- ✅ Start with brainstorming for complex features
- ✅ Let Claude create worktrees for parallel work
- ✅ Trust the TDD process (RED → GREEN → Refactor)
- ✅ Review code before merging
- ✅ Create project-specific skills for repeated patterns
- ✅ Use full agent workflow for large features

### Don'ts
- ❌ Don't skip the planning phase
- ❌ Don't disable tests to "move faster"
- ❌ Don't manually manage worktrees (let Superpowers handle it)
- ❌ Don't override safety boundaries in skills
- ❌ Don't forget to clean up old worktrees

## Performance Tips

1. **Use worktrees for features, not fixes** - Simple bug fixes don't need worktrees
2. **Cache dependencies** - Don't reinstall packages in each worktree
3. **Prune worktrees regularly** - `git worktree prune`
4. **Use `.claude-project.json`** - Set project defaults once
5. **Create reusable skills** - Invest time in good skills, save time later

## Integration with Your Workflow

### For Solo Development
- Use simple mode for quick fixes
- Use full workflow for features
- Disable worktrees for small projects

### For Team Development
- Enable PR creation
- Share skills via marketplace
- Document conventions in project skills
- Use full agent workflow for complex features

### For Open Source
- Create contributor skills
- Document coding standards as skills
- Use worktrees for each PR
- Enable code review agents

## Future Features

From Jesse's blog post, upcoming features include:

- **Skill Sharing** - Community marketplace for skills
- **Enhanced Memory** - Better context retention across sessions
- **Multi-Agent Orchestration** - Improved agent coordination
- **Performance Monitoring** - Track agent effectiveness
- **Custom Workflows** - Define your own workflow phases

## See Also

- [Claude Skills](./claude-skills.md) - Deep dive into skills system
- [Seven Agents](./seven-agents.md) - Specialized agent team
- [Git Worktrees](./git-worktrees.md) - Managing parallel development
- [Jesse's Blog](https://blog.fsck.com/2025/10/09/superpowers/) - Original article

## Community

- **GitHub**: https://github.com/obra/superpowers-marketplace
- **Skool Community**: https://www.skool.com/new-society/claude-45-and-agent-orchestration
- **YouTube**: Scott Graham's video on agent orchestration

## Quick Reference

| Command | Purpose |
|---------|---------|
| `/plugin install superpowers@superpowers-marketplace` | Install Superpowers |
| `/plugin config superpowers` | View configuration |
| `/plugin config superpowers disable_git_worktrees=true` | Disable worktrees |
| `git worktree list` | List active worktrees |
| `git worktree prune` | Clean up stale worktrees |
| `/skills marketplace` | Browse available skills |
| `/test-skill <name>` | Test a skill |

---

**Last Updated**: 2025-10-14
**Version**: Based on obra/superpowers-marketplace initial release
**Status**: Active development, some features in beta
