# Claude Skills System

## Overview

The Claude Skills system is a framework for teaching Claude specialized capabilities through structured markdown files. Skills act as "training modules" that give Claude enhanced abilities for specific tasks, improving consistency and reliability.

## What Are Skills?

Skills are markdown documents that:
- Teach Claude how to perform specific tasks
- Provide structured patterns and best practices
- Enable Claude to self-improve within defined boundaries
- Can be combined to create complex workflows

Think of skills as reusable instruction sets that Claude can reference and apply when needed.

## Skills Directory Structure

**Current Structure** (SWECOM-aligned as of 2025-10-17):

```
~/.claude/
├── skills/
│   ├── lifecycle/                    # 5 Life Cycle Skill Areas
│   │   ├── requirements/
│   │   │   └── requirements_analysis/     # BSA Agent
│   │   │       └── SKILL.md
│   │   ├── design/
│   │   │   └── architecture/              # System Architect
│   │   │       └── SKILL.md
│   │   ├── construction/
│   │   │   └── code_quality/              # Code Quality Engineer
│   │   │       └── SKILL.md
│   │   ├── testing/
│   │   │   └── acceptance_testing/        # QAS Agent
│   │   │       └── SKILL.md
│   │   └── sustainment/
│   │       └── migrations/                # Data Engineer
│   │           └── SKILL.md
│   │
│   ├── crosscutting/                 # 8 Crosscutting Skill Areas
│   │   ├── process/
│   │   │   └── agent_dispatch/            # Agent Dispatcher
│   │   │       └── SKILL.md
│   │   ├── quality/
│   │   │   └── documentation/             # Tech Writer
│   │   │       └── SKILL.md
│   │   ├── security/
│   │   │   └── policy_auditing/           # Security Engineer
│   │   │       └── SKILL.md
│   │   ├── configuration/
│   │   │   └── release_management/        # RTE Agent
│   │   │       └── SKILL.md
│   │   ├── measurement/
│   │   │   └── metrics_collection/        # Metrics Analyst
│   │   │       └── SKILL.md
│   │   └── hci/
│   │       └── accessibility/             # Accessibility Specialist
│   │           └── SKILL.md
│   │
│   └── methodology/
│       └── domain_driven_design/          # DDD
│           └── SKILL.md
```

**See**: `~/.claude/skills-structure.md` for complete reference and `~/.claude/swecom-audit-report.md` for SWECOM mapping.

## Creating a Skill

### Basic Skill Template

```markdown
# Skill: [Skill Name]

## Purpose
What this skill teaches Claude to do.

## When to Use
Specific situations where this skill should be applied.

## Process
1. Step-by-step instructions
2. Decision points
3. Error handling

## Examples
Concrete examples of applying this skill.

## Boundaries
Limitations and constraints for this skill.

## Related Skills
Links to other relevant skills.
```

### Example: Requirements Analysis Skill

```markdown
# Skill: Business Requirements Analysis

## Purpose
Translate business requirements from tickets into technical specifications.

## When to Use
- When analyzing feature requests
- When breaking down user stories
- When clarifying ambiguous requirements

## Process
1. **Read the full requirement** - Don't skim, understand completely
2. **Identify stakeholders** - Who is affected by this change?
3. **Extract technical constraints** - Database, API, UI, security
4. **List acceptance criteria** - What defines "done"?
5. **Identify dependencies** - What must exist first?
6. **Document assumptions** - What are we assuming to be true?

## Examples
Given ticket: "Users should be able to export their data"

Analysis output:
- Stakeholder: End users
- Technical requirements:
  - Data serialization (JSON, CSV formats)
  - Authorization check (user owns data)
  - API endpoint: GET /api/users/{id}/export
  - Background job for large datasets
- Acceptance criteria:
  - User clicks "Export" button
  - Receives download link within 5 minutes
  - File contains all user data per GDPR requirements
- Dependencies:
  - Background job system
  - Email notification system
- Assumptions:
  - Exports are for personal use only
  - Data is not anonymized

## Boundaries
- Do not implement solutions during analysis phase
- Flag security concerns but don't design security solutions
- Stop if requirements are too vague - ask for clarification

## Related Skills
- [System Architecture](../architecture/schema_validation/SKILL.md)
- [Security Auditing](../security/policy_auditing/SKILL.md)
```

## Using Skills in Claude Code

### Method 1: Direct Reference
```
Claude, please use the requirements analysis skill to analyze ticket WOR-315.
```

### Method 2: Automatic Application
When Superpowers plugin is installed, Claude will automatically apply relevant skills based on context.

### Method 3: Skill Chains (The Seven Agents)
```
Claude, use the seven-agent workflow from Agent Dispatcher for [feature name]:
1. BSA Agent (Requirements analysis)
2. System Architect (Schema design)
3. Data Engineer (Migration creation)
4. Security Engineer (Security audit)
5. Implementation (with TDD)
6. QAS Agent (Comprehensive testing)
7. Tech Writer (Documentation)
8. RTE Agent (Release management)
```

### Method 4: Targeted Skill Application
For focused work, use specific skills:

```
# Code review
"Use Code Quality Engineer skill to review src/services/"

# Establish metrics
"Use Metrics Analyst skill to set up DORA metrics for this project"

# Accessibility audit
"Use Accessibility Specialist skill to audit the dashboard page"

# Security review
"Use Security Engineer skill to audit RLS policies on user_data table"
```

### Method 5: Project Health Check
Use the `/health-check` slash command (if configured) or directly request:

```
"Run a project health check using:
- Code Quality Engineer (complexity, duplication, tech debt)
- Metrics Analyst (establish baseline metrics)
- Accessibility Specialist (WCAG compliance)
- Security Engineer (review security posture)
- Tech Writer (documentation completeness)"
```

## Self-Improvement Skills

Create a meta-skill that teaches Claude how to create new skills:

```markdown
# Skill: Skill Creation

## Purpose
Teach Claude how to create new skills based on observations and patterns.

## When to Use
- After successfully completing a complex task
- When identifying repetitive patterns
- When receiving feedback on improvements

## Process
1. Identify the pattern or capability
2. Extract the reusable components
3. Define clear boundaries
4. Write the skill document
5. Test with an example
6. Save to appropriate skills directory

## Boundaries
- Only create skills for proven patterns
- Skills must have clear success criteria
- Skills cannot override safety guidelines
```

## Practical Skill Usage Patterns

### When to Use Which Skills

**Starting a new project**:
1. Use Metrics Analyst to establish baseline metrics
2. Use Code Quality Engineer to set up linting/quality gates
3. Use Accessibility Specialist to audit initial UI (if web app)

**Working on a feature**:
1. Use Agent Dispatcher's seven-agent workflow for complex features
2. Use BSA Agent alone for simple requirement clarification
3. Use Code Quality Engineer during code review
4. Use QAS Agent for comprehensive testing

**Before releases**:
1. Use Security Engineer for security review
2. Use Accessibility Specialist for UI changes
3. Use Tech Writer to verify documentation
4. Use RTE Agent to create deployment plan

**Ongoing maintenance**:
1. Use Metrics Analyst monthly/quarterly to track trends
2. Use Code Quality Engineer for refactoring guidance
3. Use Security Engineer for security audits

### Incremental Adoption Strategy

Don't try to use all skills at once. Adopt incrementally:

**Week 1**: Start using Agent Dispatcher for complex features
**Week 2**: Add Code Quality Engineer to code review process
**Week 3**: Run baseline with Metrics Analyst
**Month 2**: Add Accessibility Specialist for UI work
**Quarterly**: Full project health check with multiple skills

### Integration with Workflows

**For CI/CD**:
- Use Metrics Analyst skill to define quality gates
- Use Code Quality Engineer skill to establish linting rules
- Use QAS Agent skill to design test strategy

**For Agile/Scrum**:
- Use BSA Agent during sprint planning (user story analysis)
- Use Metrics Analyst for sprint retrospectives (velocity, quality metrics)
- Use Agent Dispatcher for complex epics

**For Code Review**:
- Use Code Quality Engineer skill as review checklist
- Focus on SOLID principles, tech debt, complexity
- Track issues found for improvement trends

## Best Practices

### Do's
- ✅ Keep skills focused on single responsibilities
- ✅ Include concrete examples
- ✅ Define clear boundaries and constraints
- ✅ Cross-reference related skills
- ✅ Update skills based on feedback
- ✅ Use targeted skills rather than reviewing against all 12
- ✅ Integrate skills into existing workflow incrementally

### Don'ts
- ❌ Don't create overly broad skills
- ❌ Don't skip the boundaries section
- ❌ Don't create duplicate skills
- ❌ Don't override fundamental safety rules
- ❌ Don't create skills without testing them
- ❌ Don't run all skills on every project (overwhelming)
- ❌ Don't ignore skill recommendations without reason

## Skill Lifecycle

1. **Creation** - Write the skill document
2. **Testing** - Verify it works with examples
3. **Refinement** - Improve based on usage
4. **Deprecation** - Remove or replace outdated skills

## Integration with Superpowers

The Superpowers plugin (see [superpowers.md](./superpowers.md)) provides:
- Automatic skill discovery
- Skill marketplace for sharing
- Skill testing framework
- Memory integration with skills

## Advanced: Bounded Self-Improvement

Skills enable "Bounded Self-improving Agent" (BSA) behavior:

1. **Learning Boundaries** - Skills define what can be learned
2. **Improvement Protocols** - Skills define how to improve
3. **Safety Constraints** - Skills enforce limitations
4. **Performance Tracking** - Skills include success metrics

This creates an agent that improves within safe, predefined boundaries.

## Troubleshooting

### Skill Not Being Applied
- Check file path: `~/.claude/skills/[category]/[skill-name]/SKILL.md`
- Verify markdown formatting
- Explicitly reference skill: "Use the [skill name] skill"

### Conflicting Skills
- Review skill boundaries
- Create a meta-skill to resolve conflicts
- Ask Claude: "Which skill should apply here?"

### Skill Too Broad
- Split into multiple focused skills
- Use skill chains instead

## Creating a Health Check Slash Command

To make project health checks easy, create `.claude/commands/health-check.md`:

```markdown
Run a comprehensive project health check using relevant skills:

**Scope**: Select skills based on project type:
- All projects: Code Quality, Metrics baseline
- Web apps: + Accessibility
- Database-heavy: + Security (RLS policies)
- Public APIs: + Documentation

**For each selected skill**:

1. **Code Quality Engineer**:
   - Review 3-5 main modules
   - Calculate complexity, duplication, tech debt
   - Top 3 refactoring priorities with effort estimates

2. **Metrics Analyst**:
   - Establish baseline: coverage, complexity, duplication
   - Set improvement targets (3-month goals)
   - Recommend metrics dashboard setup

3. **Accessibility Specialist** (if web app):
   - Audit main user flows for WCAG compliance
   - Identify critical/high/medium issues
   - Provide fix estimates

4. **Security Engineer** (if database-heavy):
   - Review RLS policies
   - Check authentication/authorization
   - Identify security gaps

5. **Tech Writer**:
   - Check API documentation completeness
   - Verify README accuracy
   - Identify missing docs

**Output**:
- Executive summary (1 paragraph)
- Findings by skill (prioritized: Critical/High/Medium/Low)
- Recommended action plan with effort estimates
- Suggested next steps (pick top 3 items)

**Format**: Actionable, not overwhelming. Focus on impact vs. effort.
```

Then run: `/health-check` to audit any project.

## Example Health Check Output

```markdown
# Project Health Check: MyApp

## Executive Summary
Overall health: GOOD with 3 areas needing attention. Code quality is
solid (complexity 12, coverage 84%) but accessibility has critical gaps.
Recommend addressing WCAG violations before next release.

## Findings

### Code Quality Engineer ✅
- Complexity: 12 (target <10) - 60% of target
- Coverage: 84% (target >80%) ✅
- Duplication: 2.1% (target <3%) ✅
- **Top Priority**: Refactor `UserService.ts` (complexity 45)

### Accessibility Specialist ⚠️
- **CRITICAL**: 2 issues (skip link, form labels)
- **HIGH**: 5 issues (color contrast, missing alt text)
- WCAG Level: Currently C, Target AA
- **Top Priority**: Fix critical issues before release

### Metrics Analyst 📊
- **Baseline established**: All metrics tracked
- **Recommended**: Set up DORA metrics dashboard
- **Quick Win**: Enable automated coverage reporting

## Action Plan (Next 30 Days)

1. **CRITICAL** (This week): Fix 2 accessibility blockers (4 hours)
2. **HIGH** (Week 2): Refactor UserService complexity (2 days)
3. **MEDIUM** (Week 3): Set up DORA metrics dashboard (1 day)

**Estimated Total**: 4 days of effort for significant improvement
```

## See Also

- [Superpowers Framework](./superpowers.md) - Plugin that enhances skills
- [Seven Agents](./seven-agents.md) - Specialized agent roles using skills
- [Git Worktrees](./git-worktrees.md) - Parallel work with skills
- [Skills Structure](../skills-structure.md) - Complete SWECOM-aligned skill reference
- [SWECOM Audit Report](../swecom-audit-report.md) - Gap analysis and recommendations
