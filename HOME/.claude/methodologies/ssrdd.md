# SSRDD: Scaled Spec-Roundtrip Driven Development

A coordination wrapper enabling multiple independent SRDD cycles to coexist across multi-domain systems. SSRDD coordinates interfaces and intent, not implementation.

**Author**: Brooke Smith — https://docs-bbos.github.io/srdd/
**Prerequisite**: Familiarity with SRDD (see `~/.claude/methodologies/srdd.md`)

---

## Core Concept

SSRDD is not a new methodology layered on top of SRDD. It is a coordination wrapper that allows multiple independent SRDD loops to coexist without collapsing into chaos or bureaucracy.

Each domain operates autonomously:
- Maintains its own planning artifacts and SRDD cycles
- Evolves at its own pace
- Regenerates based on local signals

SSRDD does NOT synchronize development cadence, force shared tooling, or impose uniform internal practices.

---

## System-Level Coordination

### 1. Shared Constitutions (CONSTITUTION.md)
Agreed integration standards defining how domains present themselves to one another:
- API conventions
- Event schemas
- Versioning rules
- Compatibility expectations

Constitutions govern interaction patterns, not internal design decisions.

### 2. Explicit Contracts
Public-facing APIs, events, and invariants are declared and versioned. Domains retain internal freedom provided contracts remain stable or undergo deliberate evolution.

### 3. Dependency Visibility
What each domain consumes and produces is visible by design. Hidden couplings are surfaced early, before they calcify into architectural traps.

### 4. Boundary Drift Detection
Actively monitor for erosion indicators:
- Duplicated responsibilities across domains
- Circular dependencies between domains
- Unauthorized knowledge of internal implementations

These trigger regeneration or boundary renegotiation.

---

## Dependency Permissions

Modeled on Java 9+ Project Jigsaw principles.

**Core rule:** If a domain does not declare that it consumes another domain, it cannot see it.

Each domain maintains `contracts/consumes.yaml`:

```yaml
consumes:
  - identity-management/api-users
  - inventory/api-stock
```

Dependency changes are architectural events, not implementation conveniences. They are mediated at the system level by architects or designated system stewards.

---

## SRDD vs SSRDD

| Aspect | SRDD | SSRDD |
|--------|------|-------|
| Scope | Single bounded context | Multiple domains/services |
| Planning | Domain-level artifacts | Domain + system-level artifacts |
| Autonomy | Implementation decisions | Domain independence + system coordination |
| Authority | Local specifications | Local specs + shared constitution |
| Coupling | Internal pattern consistency | Explicit boundary enforcement |
| Regeneration | Domain-level cycles | Coordinated multi-domain realignment |

---

## When to Use SSRDD

- Multi-service or multi-domain systems
- Projects with 2+ bounded contexts that need to coordinate
- Systems where multiple teams or AI agents work on different subsystems
- When you need domain independence with system-level coherence

For single bounded contexts, use standard SRDD.

---

## Governance

- Architects curate the shape in which code is allowed to grow
- Domain developers typically lack direct write access to system-level coordination artifacts
- Integration dependency changes require explicit review
- SSRDD scales understanding, not bureaucracy
