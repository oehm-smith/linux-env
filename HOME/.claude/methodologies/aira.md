# AIRA: AI Implementation Readiness & Adoption

A methodology for AI-specific consulting engagements. Layers on top of TRAD with specialized frameworks for assessing AI readiness, identifying genuine use cases, and planning adoption that sticks. Designed for the common scenario where a client says "we want AI" but the real requirement is buried underneath.

**Author**: Brooke Smith

**Prerequisite**: Use alongside TRAD for the overall engagement structure. AIRA provides the AI-specific lenses and deliverables.

---

## Core Principles

| Principle | Meaning |
|-----------|---------|
| "We want AI" is never the real requirement | AI is a means. Dig until you find the outcome they're paying for |
| Adoption eats technology for breakfast | The best AI system fails if people won't use it. Plan for humans first |
| Start with the workflow, not the model | Map what people actually do before proposing what AI could do |
| Capability vs. maturity are different axes | An org can be capable (skilled people) but immature (no processes), or vice versa |
| Prompting is the tip of the iceberg | If the ask is "prompt training", the need is almost always broader |
| Quick wins build mandate | Early visible successes fund bigger investments |
| AI literacy precedes AI implementation | People who don't understand what AI can and can't do will misuse it or reject it |

---

## AIRA Assessment Framework

### 1. Decode the Ask

When a client says they want AI, systematically explore what's underneath.

**The Decode Matrix:**

| What they say | What they might mean | Questions to ask |
|---------------|---------------------|------------------|
| "We want AI" | We're falling behind competitors | What triggered this? What have you seen others do? |
| "Prompt training" | Staff are using ChatGPT inconsistently | Who's using AI now? What for? What goes wrong? |
| "AI implementation" | We have a specific bottleneck AI could solve | What process takes too long or costs too much? |
| "Digital transformation" | Leadership mandate with unclear scope | What does success look like in 12 months? |
| "Automation" | Manual processes are drowning staff | Which tasks do people hate? Where are the errors? |

**Deliverable:** Decoded Requirements (`docs/discovery/05-DECODED-REQUIREMENTS.md`)

### 2. Assess AI Readiness

Evaluate across five dimensions. Score each Low / Medium / High.

```
┌─────────────────────────────────────────────┐
│              AI READINESS                    │
├──────────┬──────────┬──────────┬────────────┤
│  Data    │  People  │ Process  │ Technology │
│          │          │          │            │
│ Quality  │ Skills   │ Maturity │ Infra      │
│ Access   │ Culture  │ Docs     │ Integration│
│ Governance│ Champions│ Metrics │ Security   │
├──────────┴──────────┴──────────┴────────────┤
│              Leadership & Strategy           │
│                                              │
│  Vision  │  Budget  │  Timeline │  Appetite  │
└─────────────────────────────────────────────┘
```

**Dimensions:**

| Dimension | What to assess | Red flags |
|-----------|---------------|-----------|
| **Data** | Do they have the data AI would need? Is it accessible, clean, governed? | "We have lots of data" but no one knows where it is |
| **People** | AI literacy, technical skills, change readiness, internal champions | No one currently using AI; leadership mandate without ground-level interest |
| **Process** | Are workflows documented? Standardized? Measured? | "Everyone does it differently" — AI can't automate chaos |
| **Technology** | Infrastructure, integration capability, security posture | Legacy systems with no APIs; strict on-prem requirements |
| **Leadership** | Executive sponsorship, budget reality, risk appetite, timeline expectations | "We want AI everywhere by Q3" with no budget allocated |

**Deliverable:** Readiness Assessment (`docs/landscape/04-AI-READINESS.md`)

### 3. Identify Use Cases

Map potential AI applications using a structured evaluation.

**Use Case Evaluation Criteria:**

| Criterion | Weight | Description |
|-----------|--------|-------------|
| Business impact | High | Revenue, cost, risk, or experience improvement |
| Feasibility | High | Technical viability given current readiness |
| Data availability | Medium | Required data exists and is accessible |
| Adoption likelihood | High | Users will actually use this |
| Quick win potential | Medium | Can demonstrate value within weeks, not months |
| Risk | Medium | What could go wrong, and how bad would it be |

**Use Case Categories:**

- **Augmentation**: AI assists humans (copilots, drafting, suggestions) — lowest risk, fastest adoption
- **Automation**: AI handles tasks end-to-end — higher impact, needs more trust and validation
- **Analysis**: AI surfaces insights from data — depends heavily on data quality
- **Generation**: AI creates content, code, or artifacts — needs clear quality guardrails

**Deliverable:** Use Case Register (`docs/landscape/05-USE-CASES.md`)

### 4. Design the Adoption Path

Plan implementation in layers that build on each other.

**The Adoption Ladder:**

```
Level 5: AI-Native Workflows
    ↑   Processes redesigned around AI capabilities
Level 4: Embedded AI
    ↑   AI integrated into existing tools and workflows
Level 3: Managed AI Tools
    ↑   Organization-approved tools with guidelines and governance
Level 2: AI Literacy
    ↑   Staff understand AI capabilities, limitations, and responsible use
Level 1: Awareness
    ↑   Leadership and staff know what AI is and why it matters
Level 0: Current State
        Where most organizations start
```

**Phase Design Principles:**
- Each level must be solid before building the next
- Skipping levels creates fragile adoption that collapses under pressure
- Most organizations asking for "AI implementation" are at Level 0-1
- "Prompt training" lives at Level 2 — but is often requested by orgs at Level 0
- Quick wins can exist at any level — use them to demonstrate value and build momentum

**Deliverable:** Adoption Roadmap (`docs/roadmap/05-ADOPTION-PATH.md`)

### 5. Plan for Sustainability

AI implementations fail when the initial enthusiasm wears off. Plan for the long game.

**Sustainability Checklist:**
- [ ] Who owns the AI tools/processes after the engagement ends?
- [ ] How will prompts, templates, and workflows be maintained?
- [ ] What happens when the AI model changes or the vendor updates?
- [ ] How will new staff be trained?
- [ ] How will success be measured ongoing (not just at launch)?
- [ ] What governance is in place for responsible AI use?
- [ ] Who handles incidents when AI produces bad output?

**Deliverable:** Sustainability Plan (`docs/roadmap/06-SUSTAINABILITY.md`)

---

## Common Engagement Patterns

### Pattern A: "We Want Prompt Training"
**Surface ask:** Teach our staff to use ChatGPT / Copilot better.
**Likely actual need:** AI literacy + guidelines + governed tool access + use case identification.
**Recommended approach:** Start with Level 1-2, identify 2-3 quick-win use cases for Level 3, build guidelines and governance alongside training.

### Pattern B: "We Want to Automate X"
**Surface ask:** Use AI to replace a specific manual process.
**Likely actual need:** Process documentation + data assessment + feasibility study + change management.
**Recommended approach:** Map the process first, assess data availability, pilot with augmentation before automation.

### Pattern C: "Our Competitors Are Using AI"
**Surface ask:** We need an AI strategy.
**Likely actual need:** Leadership alignment on AI vision + competitive analysis + prioritized use cases.
**Recommended approach:** Full TRAD discovery, landscape scan with competitor analysis, strategic roadmap with quick wins.

### Pattern D: "We Have a Specific Problem"
**Surface ask:** Can AI solve [concrete problem]?
**Likely actual need:** Feasibility assessment + proof of concept + integration plan.
**Recommended approach:** Focused assessment, rapid PoC, then broaden if successful.

---

## Deliverable Standards

### Client-Facing Documents
- Lead with outcomes and business value, not technology
- Use the client's language, not ours
- Visualize where possible (diagrams, matrices, roadmap timelines)
- Include "What This Means For You" sections that translate technical findings
- Every recommendation must answer: what, why, what it costs (effort), and what it delivers

### Internal Documents
- Track all assumptions with confidence levels
- Document what we don't know as explicitly as what we do
- Record the reasoning behind recommendations (not just the recommendations)
- Note client-specific sensitivities and political dynamics

---

## Governance Rules

- **Never recommend AI where a simpler solution works.** If a spreadsheet solves the problem, say so.
- **Always assess responsible AI implications.** Bias, privacy, transparency, and accountability.
- **Quick wins must be genuinely quick.** If it takes 3 months, it's not a quick win.
- **Training without tools is waste.** Don't teach prompting if the org hasn't approved any AI tools.
- **Tools without training is risk.** Don't deploy AI tools without teaching responsible use.
- **Measure adoption, not deployment.** "We rolled it out" means nothing. "70% of staff use it weekly" means something.

---

## Role Division

| Human (Brooke / Michael) | AI (Claude) |
|---------------------------|-------------|
| Client relationship and trust building | Research, analysis, and document drafting |
| Industry-specific domain knowledge | AI technology landscape and capability assessment |
| Organizational politics and dynamics | Structured readiness assessment |
| Training delivery and facilitation | Training material development |
| Pricing and commercial terms | Use case evaluation and prioritization |
| Final review of all recommendations | Assumption tracking and gap identification |
