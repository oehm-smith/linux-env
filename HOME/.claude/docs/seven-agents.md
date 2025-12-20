# Seven Agent Workflow for Claude Code

## Overview

The Seven Agent workflow implements a Bounded Self-improving Agent (BSA) approach using specialized agent roles. Each agent has a specific domain of expertise and responsibility, working together to handle complex software development tasks systematically.

This workflow is particularly effective when combined with [Superpowers](./superpowers.md) and the [Skills system](./claude-skills.md).

## The Seven Core Agents

### 1. BSA Agent (Business Systems Analyst)

**Role**: Translates business requirements into technical specifications

**Responsibilities**:
- Analyzes tickets and feature requests
- Extracts technical requirements from business language
- Identifies stakeholders and constraints
- Documents assumptions and dependencies
- Creates acceptance criteria

**Example Task**:
```
Ticket WOR-315: "Users should be able to export their data for GDPR compliance"

BSA Agent Output:
- Stakeholders: End users, Legal team, Privacy Officer
- Technical Requirements:
  * Data export API endpoint
  * Format support: JSON, CSV
  * User authentication required
  * Data scope: All user-owned records
  * Delivery: Email with download link
- Acceptance Criteria:
  * Export completes within 5 minutes for typical user
  * Export includes all GDPR-required data fields
  * Export is encrypted in transit and at rest
  * User receives email notification when ready
- Dependencies:
  * Background job system
  * Email service
  * Blob storage for export files
- Assumptions:
  * One export per user per 24 hours
  * Export files expire after 7 days
```

**Skills Required**: `~/.claude/skills/analysis/requirements/SKILL.md`

---

### 2. System Architect

**Role**: Designs and validates system architecture and schemas

**Responsibilities**:
- Reviews and validates database schemas
- Ensures architectural consistency
- Identifies scalability concerns
- Validates data models
- Documents architectural decisions

**Example Task**:
```
BSA Output → System Architect

Architect Output:
- Schema Design:
  CREATE TABLE user_exports (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id),
    status VARCHAR(20) NOT NULL DEFAULT 'pending',
    format VARCHAR(10) NOT NULL,
    file_url TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    completed_at TIMESTAMPTZ,
    expires_at TIMESTAMPTZ NOT NULL,
    CONSTRAINT one_export_per_day CHECK (
      created_at >= NOW() - INTERVAL '24 hours'
    )
  );

- Architecture Decision:
  * Use queue-based processing (avoid blocking requests)
  * Store exports in S3-compatible blob storage
  * Implement cleanup job for expired exports
  * Use signed URLs with 7-day expiration

- Scalability Considerations:
  * Index on user_id and created_at
  * Partition table by created_at monthly
  * Rate limit: 1 export per user per day

- Related Components:
  * Background worker (Celery/BullMQ)
  * Blob storage (S3/MinIO)
  * Email service (SendGrid/SES)
```

**Skills Required**: `~/.claude/skills/architecture/schema_validation/SKILL.md`

---

### 3. Data Engineer

**Role**: Implements database changes and Row-Level Security (RLS)

**Responsibilities**:
- Creates database migrations
- Implements RLS policies
- Optimizes queries and indexes
- Manages data transformations
- Ensures data integrity

**Example Task**:
```
Architect Output → Data Engineer

Data Engineer Output:
- Migration File: migrations/20251014_add_user_exports.sql

-- Create table
CREATE TABLE user_exports (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  status VARCHAR(20) NOT NULL DEFAULT 'pending'
    CHECK (status IN ('pending', 'processing', 'completed', 'failed')),
  format VARCHAR(10) NOT NULL CHECK (format IN ('json', 'csv')),
  file_url TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  completed_at TIMESTAMPTZ,
  expires_at TIMESTAMPTZ NOT NULL DEFAULT (now() + INTERVAL '7 days')
);

-- Indexes
CREATE INDEX idx_user_exports_user_id ON user_exports(user_id);
CREATE INDEX idx_user_exports_created_at ON user_exports(created_at);
CREATE INDEX idx_user_exports_expires_at ON user_exports(expires_at)
  WHERE status = 'completed';

-- RLS Policies
ALTER TABLE user_exports ENABLE ROW LEVEL SECURITY;

-- Users can only see their own exports
CREATE POLICY user_exports_select_policy ON user_exports
  FOR SELECT
  USING (user_id = current_user_id());

-- Users can create their own exports (with rate limit enforced in app)
CREATE POLICY user_exports_insert_policy ON user_exports
  FOR INSERT
  WITH CHECK (user_id = current_user_id());

-- Only system can update status
CREATE POLICY user_exports_update_policy ON user_exports
  FOR UPDATE
  USING (user_id = current_user_id())
  WITH CHECK (user_id = current_user_id() AND created_at = OLD.created_at);

-- Admins can see all exports
CREATE POLICY user_exports_admin_policy ON user_exports
  FOR ALL
  USING (is_admin());

GRANT SELECT, INSERT ON user_exports TO authenticated_users;
GRANT ALL ON user_exports TO admin_users;
```

**Skills Required**: `~/.claude/skills/database/migrations/SKILL.md`

---

### 4. Security Engineer

**Role**: Audits and validates security implementations

**Responsibilities**:
- Reviews RLS policies for vulnerabilities
- Validates authentication and authorization
- Identifies security risks
- Ensures compliance with security standards
- Documents security considerations

**Example Task**:
```
Data Engineer Output → Security Engineer

Security Engineer Audit:
✅ PASS: RLS enabled on user_exports table
✅ PASS: user_id foreign key with ON DELETE CASCADE
✅ PASS: Users can only access own exports
✅ PASS: Separate admin policy with proper is_admin() check

⚠️ CONCERN: Rate limiting
- Risk: Application-level rate limit can be bypassed
- Recommendation: Add database constraint or trigger
- Mitigation: Implement at API gateway level

⚠️ CONCERN: File URL security
- Risk: file_url column may contain sensitive S3 URLs
- Recommendation: Use signed URLs with short expiration
- Implementation: Generate signed URL at read time, don't store

✅ PASS: Status transitions validated via CHECK constraint
✅ PASS: Format restricted to allowed types

🔒 ADDITIONAL RECOMMENDATIONS:
1. Add audit logging for export requests
2. Encrypt export files at rest
3. Add GDPR deletion policy (cascade on user deletion)
4. Implement IP-based rate limiting
5. Log all admin access to exports

Security Score: 8/10 - Safe to proceed with warnings addressed
```

**Skills Required**: `~/.claude/skills/security/policy_auditing/SKILL.md`

---

### 5. Tech Writer

**Role**: Updates and maintains technical documentation

**Responsibilities**:
- Updates API documentation
- Maintains governance documents
- Documents architectural decisions
- Creates user guides
- Ensures documentation accuracy

**Example Task**:
```
Implementation → Tech Writer

Documentation Updates:

1. API Documentation (docs/api/exports.md):
   ## POST /api/users/{userId}/exports
   Create a data export request for the authenticated user.

   ### Authentication
   Requires: JWT token with `user` scope

   ### Request Body
   ```json
   {
     "format": "json" | "csv"
   }
   ```

   ### Response (202 Accepted)
   ```json
   {
     "id": "550e8400-e29b-41d4-a716-446655440000",
     "status": "pending",
     "created_at": "2025-10-14T10:30:00Z",
     "estimated_completion": "2025-10-14T10:35:00Z"
   }
   ```

   ### Rate Limits
   - 1 export per user per 24 hours
   - Returns 429 Too Many Requests if limit exceeded

2. Governance Document (docs/governance/data-privacy.md):
   ## User Data Exports (GDPR Compliance)

   ### Data Retention
   - Export files stored for 7 days
   - Automatic cleanup after expiration
   - Users notified via email when export ready

   ### Data Scope
   All exports include:
   - User profile information
   - User-created content
   - Activity logs (last 90 days)
   - Settings and preferences

   ### Security Measures
   - Exports encrypted at rest (AES-256)
   - Signed URLs with 1-hour expiration
   - Access logged for audit purposes

3. Architecture Decision Record (docs/adr/0015-user-exports.md):
   # ADR 0015: User Data Export System

   ## Status
   Accepted

   ## Context
   GDPR requires providing users their data in portable format

   ## Decision
   - Use background job queue for processing
   - Support JSON and CSV formats
   - Store exports in blob storage with 7-day expiration
   - Implement rate limiting (1 per user per day)

   ## Consequences
   - Requires background job infrastructure
   - Requires blob storage (S3/MinIO)
   - Requires email notification system
```

**Skills Required**: `~/.claude/skills/documentation/governance/SKILL.md`

---

### 6. QAS Agent (Quality Assurance & Security)

**Role**: Creates and runs comprehensive tests

**Responsibilities**:
- Designs acceptance tests
- Creates unit, integration, and E2E tests
- Validates acceptance criteria
- Runs test suites
- Reports test results and coverage

**Example Task**:
```
Implementation → QAS Agent

Test Suite: User Exports

Unit Tests (tests/unit/exports.test.ts):
describe('ExportService', () => {
  describe('createExport', () => {
    it('should create export with valid format', async () => {
      const result = await exportService.createExport(userId, 'json');
      expect(result.format).toBe('json');
      expect(result.status).toBe('pending');
    });

    it('should reject invalid format', async () => {
      await expect(
        exportService.createExport(userId, 'xml')
      ).rejects.toThrow('Invalid format');
    });

    it('should enforce rate limit', async () => {
      await exportService.createExport(userId, 'json');
      await expect(
        exportService.createExport(userId, 'json')
      ).rejects.toThrow('Rate limit exceeded');
    });
  });
});

Integration Tests (tests/integration/exports.test.ts):
describe('Export API', () => {
  it('should create export and send email notification', async () => {
    // Create export
    const response = await request(app)
      .post(`/api/users/${userId}/exports`)
      .set('Authorization', `Bearer ${token}`)
      .send({ format: 'json' })
      .expect(202);

    // Wait for processing
    await waitForExportCompletion(response.body.id);

    // Verify email sent
    const emails = await getTestEmails(userEmail);
    expect(emails).toHaveLength(1);
    expect(emails[0].subject).toContain('Your data export is ready');
  });
});

E2E Tests (tests/e2e/exports.test.ts):
describe('User Export Flow', () => {
  it('should complete full export workflow', async () => {
    // Login as user
    await page.goto('/login');
    await page.fill('#email', testUser.email);
    await page.fill('#password', testUser.password);
    await page.click('button[type=submit]');

    // Request export
    await page.goto('/settings/privacy');
    await page.click('button:has-text("Export My Data")');
    await page.selectOption('#format', 'json');
    await page.click('button:has-text("Create Export")');

    // Verify confirmation
    await expect(page.locator('.toast-success')).toContainText(
      'Export requested'
    );

    // Check email (in test environment)
    const email = await waitForEmail(testUser.email);
    expect(email.subject).toContain('Your data export is ready');

    // Download and verify export
    const downloadLink = extractLinkFromEmail(email);
    const exportData = await downloadExport(downloadLink);
    expect(exportData).toHaveProperty('user');
    expect(exportData).toHaveProperty('content');
    expect(exportData).toHaveProperty('activity');
  });
});

Test Coverage Report:
- Unit Tests: 95% coverage
- Integration Tests: 85% coverage
- E2E Tests: 100% of user flows
- Security Tests: All RLS policies validated

Acceptance Criteria Validation:
✅ Export completes within 5 minutes
✅ All GDPR-required fields included
✅ Export encrypted in transit and at rest
✅ Email notification sent
✅ Rate limiting enforced
✅ Exports expire after 7 days
```

**Skills Required**: `~/.claude/skills/testing/acceptance_testing/SKILL.md`

---

### 7. RTE Agent (Release Train Engineer)

**Role**: Manages releases and deployment processes

**Responsibilities**:
- Creates pull requests
- Generates deployment checklists
- Coordinates release activities
- Documents rollback procedures
- Validates deployment readiness

**Example Task**:
```
All Agents → RTE Agent

Release Preparation:

Pull Request: #247 - User Data Export (GDPR Compliance)
Branch: feature/user-data-export → develop

PR Description:
## Summary
Implements GDPR-compliant user data export functionality allowing users
to download their data in JSON or CSV format.

## Changes
- Database schema: `user_exports` table with RLS policies
- API endpoint: POST /api/users/:userId/exports
- Background job: Export processing and file generation
- Email notification: Signed download links
- Rate limiting: 1 export per user per 24 hours
- Automatic cleanup: Expires after 7 days

## Testing
- ✅ Unit tests (95% coverage)
- ✅ Integration tests (85% coverage)
- ✅ E2E tests (100% user flows)
- ✅ Security audit (8/10, warnings addressed)
- ✅ All acceptance criteria met

## Documentation
- ✅ API documentation updated
- ✅ Governance docs updated
- ✅ ADR created (ADR-0015)

## Security Review
- ✅ RLS policies audited
- ✅ Rate limiting implemented
- ✅ Signed URLs with expiration
- ✅ Encryption at rest and in transit

## Deployment Checklist
- [ ] Run migration: migrations/20251014_add_user_exports.sql
- [ ] Set environment variables:
  - EXPORT_STORAGE_BUCKET=user-exports-prod
  - EXPORT_SIGNED_URL_EXPIRATION=3600
  - EXPORT_RATE_LIMIT_WINDOW=86400
- [ ] Deploy background workers (2 instances minimum)
- [ ] Verify email templates deployed
- [ ] Run smoke tests on staging
- [ ] Monitor export queue for first 24 hours
- [ ] Set up alerts:
  - Export processing time > 5 minutes
  - Export failure rate > 5%
  - Queue depth > 100 items

## Rollback Procedure
If issues arise:
1. Stop background workers
2. Mark feature flag `user_exports_enabled` = false
3. Revert API deployment
4. Keep database table (do not rollback migration)
5. Review logs and fix issues
6. Redeploy when ready

## Monitoring
- Export request rate: `export_requests_total`
- Processing time: `export_processing_duration_seconds`
- Success rate: `export_success_rate`
- Storage usage: `export_storage_bytes`

## Review Required
- [ ] Backend Lead (@alice)
- [ ] Security Team (@security)
- [ ] Privacy Officer (@privacy)
- [ ] DevOps (@devops)

---

Deployment Ready: ✅
Estimated Deployment Time: 30 minutes
Risk Level: Medium (new background job infrastructure)
```

**Skills Required**: `~/.claude/skills/deployment/release_management/SKILL.md`

---

## Using the Seven Agent Workflow

### Method 1: Manual Agent Dispatch

Explicitly tell Claude which agent to use:

```
"Please analyze this ticket using the BSA Agent approach"
"Now have the System Architect review the schema"
"Security Engineer: audit these RLS policies"
```

### Method 2: Automatic Workflow

With [Superpowers](./superpowers.md) installed, use a single command:

```
"Process ticket WOR-315 using the full seven-agent workflow"
```

Claude will automatically:
1. Dispatch to BSA Agent
2. Pass results to System Architect
3. Continue through all seven agents
4. Produce final PR with full documentation

### Method 3: Agent Dispatcher Skill

Create a meta-skill that teaches Claude when to use each agent:

**File**: `~/.claude/skills/meta/agent_dispatch/SKILL.md`

```markdown
# Skill: Agent Dispatcher

## Purpose
Determine which specialized agent should handle each task.

## Agent Selection Rules

### Use BSA Agent when:
- Analyzing business requirements
- Breaking down user stories
- Clarifying ambiguous tickets

### Use System Architect when:
- Designing database schemas
- Making architectural decisions
- Validating system design

### Use Data Engineer when:
- Creating migrations
- Implementing RLS policies
- Optimizing queries

### Use Security Engineer when:
- Auditing security policies
- Reviewing authentication logic
- Validating authorization rules

### Use Tech Writer when:
- API changes require documentation
- Governance docs need updating
- ADRs need creation

### Use QAS Agent when:
- Acceptance criteria defined
- Implementation complete
- Test coverage needed

### Use RTE Agent when:
- Code is tested and reviewed
- Ready to create PR
- Deployment planning needed

## Workflow
For complex features, use agents in sequence:
BSA → Architect → Data Engineer → Security → Implementation → QAS → RTE
```

## Git Worktrees and Multi-Agent Workflows

When using multiple agents with [git worktrees](./git-worktrees.md):

### Parallel Agent Work

Different agents can work in different worktrees simultaneously:

```
Main project: /Users/brooke/myproject/

Worktrees:
- myproject.worktree-schema/     (System Architect)
- myproject.worktree-migration/  (Data Engineer)
- myproject.worktree-tests/      (QAS Agent)
```

### Sequential Agent Work

Agents work in the same worktree, passing results:

```
BSA Agent → System Architect → Data Engineer
    (all in: myproject.worktree-feature-exports/)
```

## Integration with TDD

Seven-agent workflow + TDD:

1. **BSA Agent** - Defines acceptance criteria (what to test)
2. **System Architect** - Designs interfaces (what to mock)
3. **Data Engineer** - Creates schema (integration test setup)
4. **QAS Agent** - Writes failing tests (RED)
5. **Implementation** - Make tests pass (GREEN)
6. **Security Engineer** - Security tests
7. **RTE Agent** - Final validation

## Best Practices

### Do's
- ✅ Use full seven-agent workflow for complex features
- ✅ Let agents pass context to each other
- ✅ Document agent decisions for future reference
- ✅ Use specialized skills for each agent role
- ✅ Validate at each agent handoff

### Don'ts
- ❌ Don't use all seven agents for simple tasks
- ❌ Don't skip security review
- ❌ Don't bypass QAS testing
- ❌ Don't create PR without RTE validation
- ❌ Don't ignore warnings from any agent

## When to Use Full Seven-Agent Workflow

**Use full workflow for**:
- New features with database changes
- Security-sensitive implementations
- GDPR/compliance requirements
- API changes affecting multiple teams
- Releases requiring coordination

**Use simplified workflow for**:
- Bug fixes
- Refactoring
- Documentation-only changes
- Configuration updates
- Simple UI changes

## Troubleshooting

### Agent Produces Incomplete Analysis

```
"BSA Agent, please provide more detail on the acceptance criteria"
"Security Engineer, expand your analysis of this policy"
```

### Agents Disagree

```
"System Architect and Data Engineer disagree on schema design.
Please discuss and reach consensus."
```

### Missing Agent Role

Create a custom agent skill:

```markdown
# Skill: Performance Engineer

## Purpose
Analyze and optimize performance

## When to Use
After implementation, before deployment

## Process
1. Profile application
2. Identify bottlenecks
3. Recommend optimizations
```

## Quick Reference

| Agent | When to Use | Key Output |
|-------|-------------|-----------|
| BSA Agent | Requirements analysis | Technical specs, acceptance criteria |
| System Architect | Design decisions | Schema, architecture docs |
| Data Engineer | Database work | Migrations, RLS policies |
| Security Engineer | Security review | Audit report, vulnerabilities |
| Tech Writer | Documentation | API docs, ADRs, governance |
| QAS Agent | Testing | Test suites, coverage reports |
| RTE Agent | Release | PR, deployment checklist |

## See Also

- [Claude Skills](./claude-skills.md) - Create agent-specific skills
- [Superpowers](./superpowers.md) - Automates agent dispatch
- [Git Worktrees](./git-worktrees.md) - Parallel agent work

---

**Last Updated**: 2025-10-14
**Framework**: Bounded Self-improving Agent (BSA) approach
**Minimum Agents**: 7 (can be extended with custom agents)
