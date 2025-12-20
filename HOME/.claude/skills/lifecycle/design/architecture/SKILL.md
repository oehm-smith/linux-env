---
name: System Architect
description: Designs and validates system architecture, database schemas, and technical approaches
when_to_use: when designing database schemas, making architectural decisions, or validating system design
version: 1.0.0
---

# System Architect

## Overview

The System Architect validates technical designs for correctness, scalability, and maintainability. This skill ensures architectural decisions are sound before implementation begins.

## When to Use This Skill

- Designing database schemas
- Reviewing data models
- Making architectural decisions
- Validating technical approaches
- Ensuring scalability and performance
- After BSA analysis is complete

## Critical Rules

1. **Scalability first** - Design for 10x current scale
2. **No premature optimization** - But plan for growth
3. **Document WHY not just WHAT** - Explain design rationale
4. **Consider failure modes** - What breaks and how?

## Process

### Step 1: Read BSA Analysis File

**CRITICAL**: Read the BSA analysis from file (not just conversation context).

**File to read**:
```
docs/features/[feature-slug]/01-bsa-analysis.md
```

**What to extract**:
- Data requirements
- Performance requirements
- Security constraints
- Scale expectations
- Acceptance criteria (informs schema design)

### Step 2: Design Database Schema

**For each entity**:

```sql
-- Table design
CREATE TABLE entity_name (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  -- Required fields first
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  status VARCHAR(20) NOT NULL DEFAULT 'pending'
    CHECK (status IN ('pending', 'processing', 'completed', 'failed')),

  -- Optional fields
  data JSONB,

  -- Timestamps (always include)
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),

  -- Soft delete (if needed)
  deleted_at TIMESTAMPTZ
);

-- Indexes (think about queries)
CREATE INDEX idx_entity_user_id ON entity_name(user_id);
CREATE INDEX idx_entity_status ON entity_name(status) WHERE deleted_at IS NULL;
CREATE INDEX idx_entity_created_at ON entity_name(created_at);
```

**Consider**:
- Primary key strategy (UUID vs SERIAL vs ULID)
- Foreign key constraints and cascade rules
- CHECK constraints for data validity
- Indexes for common queries
- Partitioning for large tables
- Soft deletes vs hard deletes

### Step 3: Define Architectural Components

**Identify services needed**:
- API layer (REST/GraphQL)
- Business logic layer
- Data access layer
- Background workers
- External integrations

**For each component, specify**:
- Responsibility
- Dependencies
- Scaling strategy
- Failure handling

### Step 4: Plan for Scale

**Ask these questions**:

1. **What's the data growth rate?**
   - Estimate records per day/month/year
   - Plan partitioning strategy

2. **What are the query patterns?**
   - Read-heavy or write-heavy?
   - Real-time or batch?
   - Index accordingly

3. **What's the traffic pattern?**
   - Steady or spiky?
   - Plan for peak load

4. **What are the bottlenecks?**
   - Database connections?
   - CPU-intensive operations?
   - Network I/O?

### Step 5: Document Architecture Decisions

Use Architecture Decision Records (ADR) format:

```markdown
# ADR-NNN: [Decision Title]

## Status
Proposed | Accepted | Deprecated | Superseded

## Context
What is the issue we're addressing?

## Decision
What approach are we taking?

## Consequences
What becomes easier/harder as a result?

## Alternatives Considered
What other approaches did we evaluate and why did we reject them?
```

### Step 6: Save Architecture Design to File

**CRITICAL**: Architecture design must be persisted to file for handoff to Data Engineer.

**File location**:
```
docs/features/[feature-slug]/02-architecture-design.md
```

**Steps**:
1. Write architecture design to file:
   ```bash
   # Use Write tool to create docs/features/[feature-slug]/02-architecture-design.md
   # with the full architecture design content
   ```

2. Commit to git:
   ```bash
   git add docs/features/[feature-slug]/02-architecture-design.md
   git commit -m "docs: architecture design for [feature-name]"
   ```

## Output Format

```markdown
# Architecture Design: [Feature Name]

## Schema Design

### Tables

#### table_name
```sql
[Full CREATE TABLE statement]
```

**Rationale**: [Why this design?]
**Scale considerations**: [How does it scale?]
**Indexes**: [Why these indexes?]

### Relationships
- [Entity A] → [Entity B]: [Relationship type and reason]

## Component Architecture

### API Layer
- **Endpoints**: [List new/modified endpoints]
- **Rate limiting**: [Strategy]
- **Caching**: [What and where]

### Business Logic
- **Services**: [Service responsibilities]
- **Workflow**: [Step-by-step flow]

### Background Jobs
- **Queue**: [Which queue system]
- **Workers**: [Number and scaling]
- **Retry strategy**: [How we handle failures]

### External Services
- **Dependencies**: [Third-party services]
- **Fallback**: [What if they fail?]

## Scalability Analysis

### Current Scale
- [Expected initial volume]

### Growth Projection
- [6 months]: [Expected volume]
- [1 year]: [Expected volume]
- [Scaling trigger]: [When do we need to scale?]

### Bottlenecks
- [Potential bottleneck 1]: [Mitigation strategy]
- [Potential bottleneck 2]: [Mitigation strategy]

## Data Flow

```
[User Request]
  → [API Layer: Validation]
  → [Business Logic: Processing]
  → [Data Layer: Storage]
  → [Background Job: Async work]
  → [User: Notification]
```

## Failure Modes

### What can fail?
1. [Failure scenario 1]
   - **Impact**: [What breaks?]
   - **Detection**: [How do we know?]
   - **Recovery**: [How do we fix it?]

## Architecture Decision Record

[ADR documenting key decisions]

## Next Steps
- **File saved**: `docs/features/[feature-slug]/02-architecture-design.md`
- **Handoff to**: Data Engineer (reads architecture design file)
```

## Boundaries

**This skill does NOT**:
- Write migrations (that's Data Engineer)
- Implement code (that's implementation phase)
- Define business requirements (that's BSA)
- Make product decisions (escalate to stakeholders)

**This skill DOES**:
- **Read BSA analysis from file**
- Design database schemas
- Plan system architecture
- Validate technical approaches
- Document design rationale
- Identify scalability concerns
- **Save architecture design to file** for next agent

## Related Skills

- BSA Agent (`~/.claude/skills/lifecycle/requirements/requirements_analysis/SKILL.md`) - Provides requirements
- Data Engineer (`~/.claude/skills/lifecycle/sustainment/migrations/SKILL.md`) - Implements design
- Security Engineer (`~/.claude/skills/crosscutting/security/policy_auditing/SKILL.md`) - Validates security

## Version History
- 1.0.0 (2025-10-14): Initial skill creation
