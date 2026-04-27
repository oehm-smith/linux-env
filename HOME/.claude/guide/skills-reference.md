# Skills Reference

Skills are structured instructions that teach Claude specialized capabilities. They fire automatically based on context (Superpowers) or are invoked explicitly.

## Superpowers Skills (Implementation Phase)

These are provided by the Superpowers plugin and fire automatically during development work.

| Skill | Triggers When |
|-------|--------------|
| **brainstorming** | Before any creative work — features, components, modifications |
| **writing-plans** | You have a spec/requirements for a multi-step task |
| **executing-plans** | You have a written plan to execute |
| **test-driven-development** | Implementing any feature or bugfix |
| **systematic-debugging** | Any bug, test failure, or unexpected behavior |
| **verification-before-completion** | About to claim work is done |
| **requesting-code-review** | Completing tasks, before merging |
| **receiving-code-review** | Processing code review feedback |
| **dispatching-parallel-agents** | 2+ independent tasks that can run in parallel |
| **subagent-driven-development** | Executing plans with independent tasks |
| **using-git-worktrees** | Starting feature work needing isolation |
| **finishing-a-development-branch** | Implementation complete, deciding how to integrate |
| **writing-skills** | Creating or editing skills |

## Design Phase Skills (SWECOM-Aligned)

Located in `~/.claude/skills-design/`. Invoked by saying "design phase" or "let's design", or by directly asking for a specific agent.

| Skill | Agent Role | Use For |
|-------|-----------|---------|
| **requirements-analysis** | BSA Agent | Translating business requirements to technical specs |
| **architecture** | System Architect | Schema design, system architecture decisions |
| **code-quality** | Code Quality Engineer | Complexity, duplication, tech debt review |
| **domain-driven-design** | DDD Specialist | Domain modeling, bounded contexts |
| **acceptance-testing** | QAS Agent | Comprehensive testing strategy |
| **accessibility** | Accessibility Specialist | WCAG compliance auditing |
| **documentation** | Tech Writer | API docs, user guides, developer guides |
| **metrics** | Metrics Analyst | Coverage, complexity, DORA metrics baselines |
| **migrations** | Data Engineer | Database migrations |
| **release-management** | RTE Agent | Deployment planning |
| **security-audit** | Security Engineer | RLS policies, auth, security posture |

## Custom Skills

Located in `~/.claude/skills/`:

| Skill | Purpose |
|-------|---------|
| **phase-router** | Routes to the right skill set based on workflow stage |
| **brooke-custom-agents** | References custom skills organized by phase |
| **using-skills** | Meta-skill for discovering and invoking other skills |

## The Seven-Agent Workflow

For complex features, invoke all agents in sequence:

1. **BSA Agent** → Requirements analysis
2. **System Architect** → Schema/architecture design
3. **Data Engineer** → Migration creation
4. **Security Engineer** → Security audit
5. **Implementation** → Code with TDD
6. **QAS Agent** → Comprehensive testing
7. **Tech Writer** → Documentation
8. **RTE Agent** → Release management

Invoke with: "Use the seven-agent workflow for [feature name]"

## How to Invoke Skills

| Method | Example |
|--------|---------|
| Automatic | Superpowers skills fire based on context |
| Direct request | "Use the Security Engineer skill to audit RLS policies" |
| Phase trigger | "Let's design" activates design phase skills |
| Slash command | `/health-check` invokes multiple skills |

---

**Last Updated**: 2026-04-20
