# Claude Skills Structure (SWECOM-Aligned)

**Last Updated**: 2025-10-17
**Framework**: IEEE SWECOM Software Engineering Competency Model

## Directory Structure

```
~/.claude/skills/
│
├── lifecycle/                          # 5 Life Cycle Skill Areas
│   ├── requirements/
│   │   └── requirements_analysis/      ✅ SWECOM 1: Software Requirements
│   │       └── SKILL.md                   (BSA Agent)
│   │
│   ├── design/
│   │   └── architecture/               ✅ SWECOM 2: Software Design
│   │       └── SKILL.md                   (System Architect)
│   │
│   ├── construction/
│   │   └── code_quality/               ✅ SWECOM 3: Software Construction
│   │       └── SKILL.md                   (Code Quality Engineer) 🆕
│   │
│   ├── testing/
│   │   └── acceptance_testing/         ✅ SWECOM 4: Software Testing
│   │       └── SKILL.md                   (QAS Agent)
│   │
│   └── sustainment/
│       └── migrations/                 ⚠️ SWECOM 5: Software Sustainment (partial)
│           └── SKILL.md                   (Data Engineer)
│
├── crosscutting/                       # 8 Crosscutting Skill Areas
│   ├── process/
│   │   └── agent_dispatch/             ⚠️ SWECOM 6: Software Process (partial)
│   │       └── SKILL.md                   (Agent Dispatcher)
│   │
│   ├── quality/
│   │   └── documentation/              ⚠️ SWECOM 8: Software Quality (partial)
│   │       └── SKILL.md                   (Tech Writer)
│   │
│   ├── security/
│   │   └── policy_auditing/            ⚠️ SWECOM 9: Software Security (partial)
│   │       └── SKILL.md                   (Security Engineer)
│   │
│   ├── configuration/
│   │   └── release_management/         ✅ SWECOM 11: Configuration Management
│   │       └── SKILL.md                   (RTE Agent)
│   │
│   ├── measurement/
│   │   └── metrics_collection/         ✅ SWECOM 12: Software Measurement
│   │       └── SKILL.md                   (Metrics Analyst) 🆕
│   │
│   └── hci/
│       └── accessibility/              ✅ SWECOM 13: Human-Computer Interaction
│           └── SKILL.md                   (Accessibility Specialist) 🆕
│
└── methodology/                        # Design Methodologies
    └── domain_driven_design/           (Crosscutting - influences all areas)
        └── SKILL.md                       (DDD)
```

## SWECOM Coverage Matrix

| # | SWECOM Area | Coverage | Skills | Status |
|---|-------------|----------|--------|--------|
| **1** | Software Requirements | ✅ **FULL** | BSA Agent | Complete |
| **2** | Software Design | ⚠️ **PARTIAL** | System Architect, DDD | 60% |
| **3** | Software Construction | ✅ **FULL** | Code Quality Engineer 🆕 | Complete |
| **4** | Software Testing | ✅ **FULL** | QAS Agent | Complete |
| **5** | Software Sustainment | ⚠️ **PARTIAL** | Data Engineer (migrations) | 40% |
| **6** | Software Process | ⚠️ **PARTIAL** | Agent Dispatcher | 50% |
| **7** | Systems Engineering | ⚠️ **PARTIAL** | System Architect | 40% |
| **8** | Software Quality | ⚠️ **PARTIAL** | Tech Writer, QAS | 50% |
| **9** | Software Security | ⚠️ **PARTIAL** | Security Engineer | 60% |
| **10** | Software Safety | ❌ **NONE** | — | 0% |
| **11** | Configuration Mgmt | ✅ **GOOD** | RTE Agent, Data Engineer | 70% |
| **12** | Software Measurement | ✅ **FULL** | Metrics Analyst 🆕 | Complete |
| **13** | HCI | ✅ **FULL** | Accessibility Specialist 🆕 | Complete |

**Overall Coverage**: 8 of 13 areas with full/good coverage (62%)

## Skill Overview

### Lifecycle Skills (5)

#### 1. Requirements Analysis (SWECOM 1) ✅
- **Skill**: BSA Agent
- **Path**: `lifecycle/requirements/requirements_analysis/SKILL.md`
- **Covers**: Requirements elicitation, analysis, specification, acceptance criteria
- **When to use**: Analyzing tickets, user stories, business requirements

#### 2. Architecture & Design (SWECOM 2) ⚠️
- **Skills**:
  - System Architect (`lifecycle/design/architecture/SKILL.md`)
  - Domain-Driven Design (`methodology/domain_driven_design/SKILL.md`)
- **Covers**: Database schema design, architectural decisions, DDD patterns
- **Gaps**: Design principles (SOLID), API design, design evaluation metrics

#### 3. Software Construction (SWECOM 3) ✅
- **Skill**: Code Quality Engineer 🆕
- **Path**: `lifecycle/construction/code_quality/SKILL.md`
- **Covers**: Code review, refactoring, technical debt, SOLID principles, clean code
- **When to use**: Reviewing code, managing tech debt, enforcing standards

#### 4. Software Testing (SWECOM 4) ✅
- **Skill**: QAS Agent
- **Path**: `lifecycle/testing/acceptance_testing/SKILL.md`
- **Covers**: Unit/integration/E2E testing, security testing, test planning
- **When to use**: Creating test suites, validating acceptance criteria

#### 5. Software Sustainment (SWECOM 5) ⚠️
- **Skill**: Data Engineer
- **Path**: `lifecycle/sustainment/migrations/SKILL.md`
- **Covers**: Database migrations, schema evolution
- **Gaps**: Incident management, production support, legacy modernization

### Crosscutting Skills (8)

#### 6. Software Process (SWECOM 6) ⚠️
- **Skill**: Agent Dispatcher
- **Path**: `crosscutting/process/agent_dispatch/SKILL.md`
- **Covers**: Agent coordination, workflow orchestration
- **Gaps**: Process improvement, retrospectives, maturity assessment

#### 7. Systems Engineering (SWECOM 7) ⚠️
- **Skill**: System Architect (shared with SWECOM 2)
- **Covers**: Component design, system architecture
- **Gaps**: System-level requirements, integration verification, deployment

#### 8. Software Quality (SWECOM 8) ⚠️
- **Skills**:
  - Tech Writer (`crosscutting/quality/documentation/SKILL.md`)
  - QAS Agent (shared with SWECOM 4)
- **Covers**: Documentation, testing, quality verification
- **Gaps**: Quality management plans, formal reviews, statistical control

#### 9. Software Security (SWECOM 9) ⚠️
- **Skill**: Security Engineer
- **Path**: `crosscutting/security/policy_auditing/SKILL.md`
- **Covers**: RLS policy audits, security testing, vulnerability identification
- **Gaps**: Threat modeling, secure design patterns, security requirements

#### 10. Software Safety (SWECOM 10) ❌
- **Status**: Not implemented (domain-specific)
- **Use cases**: Safety-critical systems (medical, automotive, aerospace)

#### 11. Configuration Management (SWECOM 11) ✅
- **Skills**:
  - RTE Agent (`crosscutting/configuration/release_management/SKILL.md`)
  - Data Engineer (schema versioning)
- **Covers**: Release management, deployment, rollback, schema versioning
- **When to use**: Creating PRs, deployment planning, managing releases

#### 12. Software Measurement (SWECOM 12) ✅
- **Skill**: Metrics Analyst 🆕
- **Path**: `crosscutting/measurement/metrics_collection/SKILL.md`
- **Covers**: GQM approach, code quality metrics, DORA metrics, dashboards
- **When to use**: Establishing metrics, tracking quality, measuring performance

#### 13. Human-Computer Interaction (SWECOM 13) ✅
- **Skill**: Accessibility Specialist 🆕
- **Path**: `crosscutting/hci/accessibility/SKILL.md`
- **Covers**: WCAG compliance, ARIA patterns, assistive tech testing
- **When to use**: UI design, frontend review, accessibility audits

### Methodology

#### Domain-Driven Design (Crosscutting)
- **Path**: `methodology/domain_driven_design/SKILL.md`
- **Applies to**: All SWECOM areas (strategic and tactical patterns)
- **When to use**: Complex domain modeling, bounded contexts, rich domain models

## The Seven Agents Workflow

The Agent Dispatcher coordinates these seven specialized agents:

```
1. BSA Agent (Requirements Analysis)
   ↓
2. System Architect (Design)
   ↓
3. Data Engineer (Database Implementation)
   ↓
4. Security Engineer (Security Audit)
   ↓
5. [Implementation with TDD]
   ↓
6. QAS Agent (Comprehensive Testing)
   ↓
7. Tech Writer (Documentation)
   ↓
8. RTE Agent (Release Management)
```

**Supporting Skills** (used as needed):
- Code Quality Engineer (during code review)
- Metrics Analyst (for measurement & improvement)
- Accessibility Specialist (for UI/UX work)
- Domain-Driven Design (for domain modeling)

## Recent Changes (2025-10-17)

### Reorganization
- ✅ Reorganized all skills into SWECOM-aligned structure
- ✅ Moved from flat categories to lifecycle/crosscutting hierarchy
- ✅ Updated all cross-references between skills

### New Skills Added
- 🆕 **Code Quality Engineer** (SWECOM 3: Construction)
  - Code review, refactoring, technical debt, SOLID principles
- 🆕 **Metrics Analyst** (SWECOM 12: Measurement)
  - GQM, DORA metrics, code quality metrics, dashboards
- 🆕 **Accessibility Specialist** (SWECOM 13: HCI)
  - WCAG compliance, ARIA, assistive technology testing

## Gaps & Future Additions

### High Priority
- ❌ Design Principles skill (SWECOM 2)
- ❌ Threat Modeling skill (SWECOM 9)
- ❌ Incident Management skill (SWECOM 5)

### Medium Priority
- ❌ Process Improvement skill (SWECOM 6)
- ❌ Quality Management skill (SWECOM 8)

### Low Priority (Domain-Specific)
- ❌ Software Safety skill (SWECOM 10) - Only for safety-critical domains

## Usage Guide

### Finding a Skill

**By SWECOM Area**:
```bash
# Requirements
~/.claude/skills/lifecycle/requirements/requirements_analysis/SKILL.md

# Design
~/.claude/skills/lifecycle/design/architecture/SKILL.md

# Construction
~/.claude/skills/lifecycle/construction/code_quality/SKILL.md

# Testing
~/.claude/skills/lifecycle/testing/acceptance_testing/SKILL.md

# Sustainment
~/.claude/skills/lifecycle/sustainment/migrations/SKILL.md
```

**By Task Type**:
- Analyzing requirements → BSA Agent
- Designing schema → System Architect
- Reviewing code → Code Quality Engineer
- Writing tests → QAS Agent
- Auditing security → Security Engineer
- Creating documentation → Tech Writer
- Measuring quality → Metrics Analyst
- Checking accessibility → Accessibility Specialist
- Releasing software → RTE Agent
- Coordinating workflow → Agent Dispatcher

### Quick Reference

```bash
# List all skills
find ~/.claude/skills -name "SKILL.md"

# Search for a specific skill
grep -r "when_to_use" ~/.claude/skills --include="SKILL.md"

# View skill metadata
head -10 ~/.claude/skills/lifecycle/*/SKILL.md
```

## Migration Notes

### Old Paths → New Paths

| Old Path | New Path |
|----------|----------|
| `analysis/requirements/` | `lifecycle/requirements/requirements_analysis/` |
| `architecture/schema_validation/` | `lifecycle/design/architecture/` |
| `database/migrations/` | `lifecycle/sustainment/migrations/` |
| `testing/acceptance_testing/` | `lifecycle/testing/acceptance_testing/` |
| `deployment/release_management/` | `crosscutting/configuration/release_management/` |
| `documentation/governance/` | `crosscutting/quality/documentation/` |
| `meta/agent_dispatch/` | `crosscutting/process/agent_dispatch/` |
| `security/policy_auditing/` | `crosscutting/security/policy_auditing/` |
| `construction/code_quality/` | `lifecycle/construction/code_quality/` |
| `measurement/metrics_collection/` | `crosscutting/measurement/metrics_collection/` |
| `hci/accessibility/` | `crosscutting/hci/accessibility/` |

All cross-references have been updated automatically.

---

**See Also**:
- Full audit report: `~/.claude/swecom-audit-report.md`
- SWECOM reference: `~/.claude/docs/swecom-summary.md`
