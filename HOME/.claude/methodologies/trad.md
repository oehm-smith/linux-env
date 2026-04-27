# TRAD: Technology Roadmap & Advisory Discovery

A consulting methodology for translating vague client requirements into concrete, phased technology roadmaps. Designed for advisory engagements where you start with incomplete information and need to deliver actionable plans.

**Author**: Brooke Smith

---

## Core Principles

| Principle | Meaning |
|-----------|---------|
| Start with outcomes, not technology | Understand what the client is trying to achieve before proposing solutions |
| Absence of detail is information | What the client doesn't say reveals assumptions, gaps, and implicit constraints |
| Roadmaps are hypotheses | Every recommendation is a bet — make the reasoning visible so it can be challenged |
| Progressive disclosure | Deliver layered documents: executive summary first, technical detail behind it |
| The intermediary is a channel, not a filter | When working through a third party, design deliverables that survive telephone-game distortion |
| Advisory precedes implementation | Don't jump to building — establish trust and alignment through the planning process itself |

---

## The Five Phases

```
Phase 1: Discovery ──→ Phase 2: Landscape ──→ Phase 3: Roadmap
                                                      │
                            Phase 5: Engage ←── Phase 4: Propose
```

### Phase 1: Discovery (Understand the Ask)

Gather and analyze whatever information is available, then systematically identify what's missing.

**Activities:**
- Document verbatim what was communicated (preserve original language — it carries intent)
- Identify the client's stated needs vs. likely actual needs
- Map stakeholders: who asked, who decides, who pays, who uses
- List assumptions you're making due to missing information
- Generate targeted questions to fill critical gaps
- Research the client's organization, industry, and public-facing technology

**Deliverable:** Discovery Brief
```
docs/discovery/
├── 00-RAW-INPUT.md          Verbatim requirements as received
├── 01-STAKEHOLDER-MAP.md    Who's involved, their roles and likely motivations
├── 02-ASSUMPTIONS.md        What we're assuming and why (with confidence levels)
├── 03-QUESTIONS.md          Prioritized questions to validate assumptions
└── 04-RESEARCH.md           What we learned about the client's context
```

**Exit criteria:** You have enough understanding (confirmed or assumed) to describe the problem space, even if assumptions remain unvalidated.

### Phase 2: Landscape (Map the Territory)

Assess the current state and identify where technology can create value.

**Activities:**
- Map current processes, tools, and pain points (known or inferred)
- Identify capability gaps between current state and desired outcomes
- Survey relevant technology options (don't commit to solutions yet)
- Assess organizational readiness: skills, culture, infrastructure, budget signals
- Identify risks, constraints, and dependencies

**Deliverable:** Landscape Assessment
```
docs/landscape/
├── 00-CURRENT-STATE.md      How things work today (known or inferred)
├── 01-GAP-ANALYSIS.md       What's missing between current and desired state
├── 02-TECHNOLOGY-SCAN.md    Relevant technologies and approaches surveyed
└── 03-READINESS.md          Organizational readiness assessment
```

**Exit criteria:** You can articulate what needs to change and have a shortlist of viable approaches.

### Phase 3: Roadmap (Design the Path)

Build a phased, prioritized technology roadmap.

**Activities:**
- Define workstreams (logical groupings of related changes)
- Sequence phases: quick wins first, dependencies respected, risk managed
- For each phase: scope, outcomes, estimated effort level, prerequisites
- Identify decision points where client input is needed
- Define success metrics for each phase

**Deliverable:** Technology Roadmap
```
docs/roadmap/
├── 00-EXECUTIVE-SUMMARY.md  One-page overview for decision makers
├── 01-WORKSTREAMS.md        Logical groupings of work with rationale
├── 02-PHASES.md             Sequenced phases with scope and outcomes
├── 03-DECISION-POINTS.md    Where client choices affect the path
└── 04-SUCCESS-METRICS.md    How to measure whether each phase delivered value
```

**Exit criteria:** A roadmap that a non-technical stakeholder can understand and a technical team can act on.

### Phase 4: Propose (Package for Decision)

Package the roadmap into a client-facing proposal.

**Activities:**
- Write for the actual audience (executives, technical leads, board — know who reads it)
- Lead with business value, follow with technical approach
- Include options where genuine alternatives exist (don't fabricate false choices)
- Be explicit about what you don't know and what needs validation
- Include rough effort/investment levels (T-shirt sizing, not fake precision)

**Deliverable:** Client Proposal
```
docs/proposal/
├── 00-PROPOSAL.md           The client-facing document
└── 01-INTERNAL-NOTES.md     Context, strategy, and talking points for the engagement team
```

**Exit criteria:** A document you'd be confident handing to the client.

### Phase 5: Engage (Iterate with the Client)

Present, discuss, refine, and move toward engagement.

**Activities:**
- Present the proposal (or send via intermediary with supporting context)
- Capture feedback and new requirements
- Iterate on roadmap based on client input
- Define next steps: pilot, SOW, deeper discovery, or walk away

**Deliverable:** Updated proposal and engagement plan, or a clear decision not to proceed.

---

## Working Through Intermediaries

When you don't have direct client access (common in partnership models):

- **Design documents that speak for themselves** — assume the intermediary won't add context
- **Include a "How to Present This" section** in internal notes
- **Keep jargon minimal** — the intermediary may not be technical
- **Provide specific questions** for the intermediary to ask, not open-ended "find out more"
- **Version everything** — assumptions change as information flows back

---

## Governance Rules

- **Never present assumptions as facts.** Label confidence levels explicitly.
- **Roadmap phases must have clear outcomes**, not just activities. "Deploy X" is an activity. "Reduce manual processing time by 50%" is an outcome.
- **Technology choices are recommendations, not prescriptions.** The client owns the decision.
- **Update discovery documents as new information arrives.** Don't let early assumptions fossilize.
- **When information is contradictory, surface the contradiction** rather than resolving it silently.

---

## Role Division

| Human (Brooke / Michael) | AI (Claude) |
|---------------------------|-------------|
| Client relationships and communication | Research, analysis, and document drafting |
| Business context and industry knowledge | Technology landscape scanning |
| Strategic direction and pricing | Structured gap analysis and roadmap sequencing |
| Final review of all client-facing materials | Assumption tracking and question generation |
| Decision on what to propose | Options analysis with tradeoffs |
