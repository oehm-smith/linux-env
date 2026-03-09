Show the IEEE SWECOM skill area mapping and coverage for design phase skills.

## Instructions

1. Read `~/.claude/docs/skills-structure.md` for the full SWECOM-to-skill mapping
2. Read `~/.claude/docs/SWECOM-summary.md` for the 13 SWECOM area definitions
3. Optionally read `~/.claude/docs/swecom-audit-report.md` for the detailed gap analysis

Present a summary showing:

```
IEEE SWECOM Coverage — Design Phase Skills

Lifecycle Skills:
  1. Software Requirements    ✅  → requirements-analysis
  2. Software Design          ⚠️  → architecture, domain-driven-design
  3. Software Construction    ✅  → code-quality
  4. Software Testing         ✅  → acceptance-testing
  5. Software Sustainment     ⚠️  → migrations

Crosscutting Skills:
  6. Software Process         ⚠️  → (Superpowers: dispatching-parallel-agents)
  7. Systems Engineering      ⚠️  → architecture (partial)
  8. Software Quality         ⚠️  → documentation
  9. Software Security        ⚠️  → security-audit
  10. Software Safety         ❌  → not implemented (domain-specific)
  11. Configuration Mgmt      ✅  → release-management
  12. Software Measurement    ✅  → metrics
  13. Human-Computer Int.     ✅  → accessibility

Coverage: 8/13 full or good | 4/13 partial | 1/13 not implemented

Reference docs:
  ~/.claude/docs/skills-structure.md      — Full mapping with coverage matrix
  ~/.claude/docs/swecom-audit-report.md   — Detailed gap analysis
  ~/.claude/docs/SWECOM-summary.md        — 13 area definitions
  ~/.claude/docs/SWECOM.pdf               — Full IEEE SWECOM framework
```

If the user provides an argument (`/swecom gaps`), focus on the gap analysis from the audit report.
If the user provides a number (`/swecom 3`), show details for that specific SWECOM area.
