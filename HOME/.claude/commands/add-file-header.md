# Add Mandatory File Header

**Purpose:** Add comprehensive file header following global standards from `~/.claude/CLAUDE.md`.

**Usage:**
- `/add-file-header` - Add header to currently open/recently discussed file
- `/add-file-header path/to/file.ts` - Add header to specific file

---

## Instructions

Add a comprehensive file header to {{#if args}}**{{args}}**{{else}}the current file{{/if}} following the **MANDATORY** format from `~/.claude/CLAUDE.md`:

### Required Sections:

1. **PURPOSE:**
   - What this file does and why it exists
   - Be specific and concise

2. **ARCHITECTURE CONTEXT:**
   - What component/layer it belongs to
   - What it depends on (with file paths)
   - What depends on it (with file paths)
   - Design pattern used (if applicable)

3. **WHY THIS APPROACH:**
   - Rationale for static vs dynamic decisions
   - Configuration choices explained
   - Performance/scalability considerations
   - Why this pattern over alternatives

4. **RELATED FILES:** (if applicable)
   - References to related components with file paths
   - Configuration files
   - Test files

### Example Format:
```typescript
/**
 * Service Name
 *
 * PURPOSE:
 * Brief description of what this file does and why.
 *
 * ARCHITECTURE CONTEXT:
 * - Layer: [Service/Controller/Repository/Config/etc.]
 * - Dependencies: path/to/dependency.ts, path/to/config.ts
 * - Used by: path/to/consumer.ts
 * - Pattern: [Strategy/Factory/Repository/Plugin/etc.]
 *
 * WHY THIS APPROACH:
 * Explanation of key design decisions.
 *
 * RELATED FILES:
 * - path/to/related-file.ts - Description
 */
```

**Action:** Read the file, analyze its purpose and context, then add the header.
