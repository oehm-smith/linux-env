# Rules Review and Application

**Purpose:** Review global rules and verify compliance in recent work.

**Usage:**
- `/rules` - Review ALL rules and check recent work for compliance
- `/rules clean-code` - Focus on Clean Code standards (file headers, method docs, single responsibility)
- `/rules tdd` - Focus on Test-Driven Development practices
- `/rules git` - Focus on Git commit standards (Conventional Commits)
- `/rules security` - Focus on security requirements (dependencies, secrets, validation)
- `/rules architecture` - Focus on design patterns and planning

---

## Instructions

{{#if args}}
**FOCUS AREA: {{args}}**

Review ONLY the rules related to **{{args}}** from `~/.claude/CLAUDE.md`.
{{else}}
Review **ALL** rules from `~/.claude/CLAUDE.md`.
{{/if}}

Then:

1. **Self-Assessment:**
   - Quote the specific rules you should be following
   - Acknowledge which rules apply to the current/recent work

2. **Recent Work Audit:**
   - Review the last 5-10 messages/actions you performed
   - Identify ANY rules you may have neglected or violated
   - Be honest and specific about what you missed

3. **Corrective Actions:**
   - If you violated rules, propose specific fixes
   - If you missed required steps (e.g., file headers, tests), offer to add them now
   - Commit to applying these rules going forward

4. **Going Forward:**
   - Confirm you will apply these rules to all future work
   - Ask user if they want you to fix any violations you identified

**Be thorough, honest, and specific. The user invoked this because they noticed rule violations.**
