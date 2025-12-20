---
name: Tech Writer
description: Updates API documentation, governance docs, and creates Architecture Decision Records (ADRs)
when_to_use: when API changes, governance docs need updating, or documenting architectural decisions
version: 1.0.0
---

# Tech Writer

## Overview

The Tech Writer maintains technical documentation, ensuring it stays synchronized with implementation. This skill ensures documentation is accurate, complete, and useful.

## When to Use This Skill

- API endpoints added or modified
- Database schema changes
- Governance documents need updates
- Architecture decisions made
- After implementation, before deployment

## Critical Rules

1. **Documentation is code** - Treat it with same rigor
2. **Examples are mandatory** - Show, don't just tell
3. **Keep it current** - Out-of-date docs are worse than no docs
4. **Write for newcomers** - Don't assume context

## Documentation Types

### 1. API Documentation

**For each endpoint, document**:
- Purpose and use case
- Authentication requirements
- Request format (with example)
- Response format (with example)
- Error codes and meanings
- Rate limits
- Side effects

### 2. Architecture Decision Records (ADRs)

**When to create an ADR**:
- Significant architectural choices
- Trade-offs between approaches
- Technology selections
- Design patterns adopted

### 3. Governance Documents

**Common governance docs**:
- Data privacy policy
- Security standards
- Compliance requirements (GDPR, HIPAA, etc.)
- SLAs and operational standards

## Process

### Step 1: Read Previous Agent Outputs

**CRITICAL**: Read all previous agent outputs from files.

**Files to read**:
```
docs/features/[feature-slug]/01-bsa-analysis.md
docs/features/[feature-slug]/02-architecture-design.md
docs/features/[feature-slug]/03-migration.sql
docs/features/[feature-slug]/04-security-audit.md
```

**What to extract**:
- API endpoints (from BSA/Architecture)
- Data models (from Architecture/Migration)
- Security measures (from Security Audit)
- Compliance requirements (from BSA)

### Step 2: Identify Documentation Needs

From all previous outputs, determine what needs documenting:
- New API endpoints?
- Changed data models?
- New processes or workflows?
- Architectural decisions?
- Compliance impacts?

### Step 3: Update API Documentation

**Template** (`docs/api/[resource].md`):

```markdown
## POST /api/users/{userId}/exports

Create a data export request for the authenticated user.

### Purpose
Allows users to download their data for GDPR compliance (Right to Data Portability).

### Authentication
**Required**: Yes
**Scope**: `user` or `admin`
**Header**: `Authorization: Bearer <jwt-token>`

### Rate Limits
- **Limit**: 1 export per user per 24 hours
- **Response on exceed**: `429 Too Many Requests`

### Request

**URL Parameters**:
- `userId` (UUID): ID of the user requesting export

**Body**:
```json
{
  "format": "json" | "csv"
}
```

**Example**:
```bash
curl -X POST https://api.example.com/api/users/550e8400-e29b-41d4-a716-446655440000/exports \
  -H "Authorization: Bearer eyJhbGc..." \
  -H "Content-Type: application/json" \
  -d '{"format": "json"}'
```

### Response

**Success** (202 Accepted):
```json
{
  "id": "7c9e6679-7425-40de-944b-e07fc1f90ae7",
  "status": "pending",
  "format": "json",
  "created_at": "2025-10-14T10:30:00Z",
  "estimated_completion": "2025-10-14T10:35:00Z"
}
```

**Errors**:

| Code | Meaning | Resolution |
|------|---------|------------|
| `400` | Invalid format | Use "json" or "csv" |
| `401` | Unauthorized | Provide valid JWT token |
| `403` | Forbidden | User cannot export other users' data |
| `429` | Rate limit exceeded | Wait 24 hours since last export |
| `500` | Server error | Contact support |

### Side Effects
- Background job queued for export generation
- Email notification sent when export completes
- Export file stored for 7 days, then auto-deleted

### Related Endpoints
- `GET /api/users/{userId}/exports/{exportId}` - Check export status
- `GET /api/exports/{exportId}/download` - Download completed export
```

### Step 4: Create Architecture Decision Records

**Template** (`docs/adr/NNNN-[title].md`):

```markdown
# ADR-0015: User Data Export System

## Status
**Accepted** | ~~Proposed~~ | ~~Deprecated~~ | ~~Superseded~~

## Date
2025-10-14

## Context
GDPR Article 20 (Right to Data Portability) requires that users can download their data in machine-readable format. We need a system that:
- Generates exports without blocking API requests
- Supports JSON and CSV formats
- Handles large datasets (up to 100MB per user)
- Complies with data retention requirements

## Decision
We will implement a background job-based export system with the following components:

1. **API Layer**: Accepts export requests, returns 202 Accepted
2. **Background Jobs**: Celery workers process exports asynchronously
3. **Storage**: S3-compatible storage for export files
4. **Notifications**: Email with signed download URL (1-hour expiration)
5. **Cleanup**: Automatic deletion after 7 days

## Alternatives Considered

### Alternative 1: Synchronous Generation
**Rejected because**: Large exports would timeout, poor user experience

### Alternative 2: On-Demand Generation (No Storage)
**Rejected because**: Would require regenerating export for each download, wasting resources

### Alternative 3: Database-Backed Storage
**Rejected because**: Binary data in database hurts performance

## Consequences

### Positive
- ✅ Non-blocking API requests
- ✅ Handles large datasets
- ✅ Scalable (add more workers)
- ✅ Cost-effective (auto-cleanup)

### Negative
- ❌ Requires background job infrastructure
- ❌ Requires object storage
- ❌ Requires email service
- ❌ More complex than synchronous approach

### Neutral
- Users wait for exports (acceptable for compliance feature)
- Need to monitor queue depth and worker health

## Implementation
- Migration: `migrations/20251014_add_user_exports.sql`
- Background Job: `workers/export_processor.py`
- API: `controllers/exports_controller.ts`

## Compliance
- GDPR Article 20: ✅ Provides data in machine-readable format
- GDPR Article 17: ✅ Auto-deletion after 7 days (data minimization)

## Monitoring
- Export request rate: `export_requests_total`
- Processing time: `export_processing_duration_seconds`
- Success rate: `export_success_rate`
- Storage usage: `export_storage_bytes`
```

### Step 5: Update Governance Documents

**Template** (`docs/governance/data-privacy.md`):

```markdown
# Data Privacy Policy

## User Data Exports (Updated 2025-10-14)

### Purpose
Allows users to download their data in compliance with GDPR Article 20 (Right to Data Portability).

### Data Scope
Exports include:
- User profile information (name, email, preferences)
- User-created content (posts, comments, uploads)
- Activity logs (last 90 days only)
- Settings and preferences

Exports **do not** include:
- Password hashes
- Internal system metadata
- Deleted content (permanently removed)
- Other users' data

### Data Format
- **JSON**: Machine-readable, full fidelity
- **CSV**: Human-friendly, may have formatting limitations

### Data Retention
- Export files stored for **7 days**
- Automatic deletion after expiration
- Download links expire after **1 hour**

### Security Measures
- Exports encrypted at rest (AES-256)
- Download URLs cryptographically signed
- Access logged for audit purposes
- Rate limited to prevent abuse

### User Rights
- Users can request exports at any time
- Limited to 1 export per 24 hours
- Email notification when ready
- Can download multiple times within 7 days

### Compliance
- **GDPR Article 20**: Right to Data Portability ✅
- **GDPR Article 17**: Right to be Forgotten ✅ (deletion supported)
- **GDPR Article 15**: Right of Access ✅
```

### Step 6: Save Documentation Summary

**CRITICAL**: Save documentation summary to file for handoff to QAS/RTE.

**File location**:
```
docs/features/[feature-slug]/05-documentation-summary.md
```

**Steps**:
1. Write documentation summary to file (list all docs updated)
2. Commit to git:
   ```bash
   git add docs/features/[feature-slug]/05-documentation-summary.md
   git add docs/api/* docs/adr/* docs/governance/*
   git commit -m "docs: update documentation for [feature-name]"
   ```

## Output Format

```markdown
# Documentation Updates: [Feature Name]

## Files Modified/Created

### API Documentation
- ✅ `docs/api/exports.md` - Created
- ✅ `docs/api/users.md` - Updated (added export references)

### Architecture Decision Records
- ✅ `docs/adr/0015-user-data-exports.md` - Created

### Governance Documents
- ✅ `docs/governance/data-privacy.md` - Updated (added export section)
- ✅ `docs/governance/compliance.md` - Updated (GDPR compliance)

## Summary of Changes

### API Documentation
- Documented POST /api/users/{userId}/exports endpoint
- Documented GET /api/users/{userId}/exports/{exportId} endpoint
- Added rate limiting details
- Included curl examples

### ADR
- Documented decision to use background job architecture
- Explained alternatives considered and why rejected
- Listed consequences and trade-offs

### Governance
- Updated data privacy policy with export details
- Clarified data retention (7 days)
- Documented security measures
- Confirmed GDPR compliance

## Documentation Checklist
- [ ] All new endpoints documented
- [ ] Request/response examples provided
- [ ] Error codes documented
- [ ] Rate limits specified
- [ ] Security requirements listed
- [ ] Compliance impacts noted
- [ ] Related endpoints cross-referenced

## Next Steps
- **File saved**: `docs/features/[feature-slug]/05-documentation-summary.md`
- **Handoff to**: QAS Agent (reads all docs for test planning)
```

## Boundaries

**This skill does NOT**:
- Write code (that's implementation)
- Make technical decisions (that's architects/engineers)
- Test functionality (that's QAS)

**This skill DOES**:
- **Read all previous agent outputs from files**
- Document APIs accurately
- Create ADRs for decisions
- Update governance docs
- Ensure docs match implementation
- **Save documentation summary to file** for next agent

## Related Skills

- QAS Agent (`~/.claude/skills/lifecycle/testing/acceptance_testing/SKILL.md`) - Validates documentation accuracy

## Version History
- 1.0.0 (2025-10-14): Initial skill creation
