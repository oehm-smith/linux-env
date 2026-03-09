# SRDD: Spec-Roundtrip Driven Development

An AI-assisted methodology where specifications and code exist in a closed loop. Specs guide implementation, but code becomes the source of truth. Understanding flows both directions.

**Author**: Brooke Smith — https://docs-bbos.github.io/srdd/

---

## Core Principles

| Principle | Meaning |
|-----------|---------|
| The roundtrip is the methodology | Understanding flows both directions — specs→code and code→regenerated specs |
| Specs are snapshots, not contracts | They capture a moment; code evolves and becomes the source of truth |
| The codebase is a curriculum | AI learns from existing code; consistency compounds velocity |
| Guardrails encode judgment structurally | Types, linters, schemas prevent bad patterns before review |
| Coherence matters more than correctness | Reviewers assess fit; AI validates function |
| The developer dreams; the AI disciplines | Humans set direction; AI executes and maintains scope |
| Velocity follows clarity | Speed results from clear systems, not the inverse |

---

## The Six Phases

```
Phase 1: Design ──→ Phase 2: Implementation ──→ Phase 3: Review
                                                       │
Phase 6: Production ←── Phase 5: Triage ←── Phase 4: UAT
                            │
                            ├──→ Phase 1 (regenerate architecture)
                            ├──→ Phase 2 (iterate on bugs)
                            └──→ Phase 6 (ship to production)
```

### Phase 1: Design
Establish intent through 8 structured planning documents:

```
docs/plans/[DATE]_v[N]_[NAME]/
├── 00-PLANNING.md        Initial brain dump from requirements questionnaire
├── 01-REQUIREMENTS.md    Functional & non-functional with MoSCoW prioritization
├── 02-USECASES.md        User stories with acceptance criteria (As a/I want/So that)
├── 03-QA-SESSION.md      Q&A transcript preserving decision context
├── 04-ARCHITECTURE.md    Technical design, components, data models, canonical patterns
├── 05-IMPLEMENTATION.md  Phased breakdown of what gets built in what order
├── 06-TESTPLAN.md        Testing strategy across unit, integration, functional layers
└── 07-NextCycle.md       Forward-looking capture point for production discoveries
```

### Phase 2: Implementation
Test-first loop: failing test → implement → pass.

**AI responsibilities:**
- **Scope guardian**: Prevents feature creep, detects contract changes, asks explicit questions at boundaries. Refuses to silently add scope.
- **Pattern follower**: Replicates canonical patterns from ARCHITECTURE.md. Deviations signal context gaps.

**Contracts**: Public APIs, UI behaviors, domain events, invariants, and observable side effects. External systems depend on these remaining stable unless explicitly versioned.

**Layered test authority:**
- Unit tests: no contractual authority, free to change
- Integration tests: medium authority, validate service boundaries
- Functional/contract tests: highest authority, encode user-visible guarantees

### Phase 3: Review
PRs preserve reasoning and decision context.

**Review focus:**
- Architectural coherence (respect boundaries, detect dependencies)
- Pattern conformance (follow ARCHITECTURE.md conventions)
- Naming and abstraction clarity
- Contractual impacts

**Signal capture:** Non-blocking signals go to 07-NextCycle.md — boundary strain, refactoring candidates.

### Phase 4: UAT (Observe and Accumulate)
Validate fitness against reality using real data, permissions, workflows.

**Key principle: Accumulate findings without fixing them.**

Capture in 07-NextCycle.md:
- Bugs, defects, rough edges
- Implicit contracts discovered through use
- Architectural tensions revealed under real conditions
- Candidate contracts (behaviors users depend on)

### Phase 5: Triage
Analyze accumulated evidence and choose path forward.

**Spaghettification signals:** Duplicated logic, circular dependencies, whack-a-mole regressions, god modules, velocity decay, hedging language, pattern inconsistency.

**Decision paths:**
1. → Phase 1: Architectural misalignment requires design reset (regeneration)
2. → Phase 2: Bugs/minor issues need iteration
3. → Phase 6: System ready to version and release

### Phase 6: Production & Regeneration
Release to production. Trigger regeneration when appropriate.

**Regeneration** produces a new dated planning directory describing the system as it stands, with explicit architectural reset while selectively intervening only on drifted subsystems.

**Regeneration sources:** Current codebase, prior planning docs, git history, issues/tickets, PRs, test suite, 07-NextCycle.md.

---

## Governance Rules

- **Tests are executable witnesses to contracts.** If a test fails, either implementation violated a contract or the contract must be deliberately changed and versioned. No third option.
- **Every inconsistency that merges becomes a template for future AI work.** Pattern enforcement is critical.
- **Crossing issue boundaries requires explicit decision** with option to create new issues.
- **When 5+ significant changes show the same boundary strain**, AI advises regeneration.
- **Regeneration is holistic in diagnosis but selective in intervention.** Stable components are left alone.
- **Human developers retain authority** over directional decisions, tradeoff acceptance, and regeneration timing.

---

## Role Division

| Human | AI |
|-------|-----|
| Direction, scope, architecture | Mechanical execution, pattern replication |
| Recognize misalignment | Detect contract violations |
| Decide regeneration timing | Advise when signals accumulate |
| Assess coherence ("correct but wrong") | Validate function and test passage |
| Design futures | Discipline implementation |
