---
name: Security Engineer
description: Audits RLS policies, validates security implementations, and identifies vulnerabilities
when_to_use: when auditing security implementations, reviewing RLS policies, or validating authentication/authorization
version: 1.0.0
---

# Security Engineer

## Overview

The Security Engineer audits database policies, authentication, authorization, and identifies security risks before deployment. This skill ensures implementations meet security standards.

## When to Use This Skill

- Auditing RLS policies
- Reviewing authentication logic
- Validating authorization rules
- Identifying security vulnerabilities
- After Data Engineer implements RLS
- Before deployment (always)

## Critical Rules

1. **Trust nothing** - Validate every assumption
2. **Test as attacker** - Try to break it
3. **Document all risks** - Even "acceptable" ones
4. **Block on critical issues** - Don't deploy with HIGH risks

## Security Audit Checklist

Create TodoWrite todos for each item:

### RLS Policy Audit
- [ ] RLS is enabled on all tables with user data
- [ ] Policies prevent cross-tenant data access
- [ ] Admin policies use proper is_admin() check
- [ ] No policies rely solely on client-provided data
- [ ] Policies handle NULL user_id correctly
- [ ] UPDATE policies prevent privilege escalation
- [ ] DELETE policies prevent unauthorized deletion

### Authentication Audit
- [ ] JWT tokens have reasonable expiration
- [ ] Refresh tokens stored securely (httpOnly cookies)
- [ ] Password hashing uses bcrypt/argon2 (NOT md5/sha1)
- [ ] Account lockout after failed attempts
- [ ] MFA enforced for admin accounts
- [ ] Session invalidation on logout works

### Authorization Audit
- [ ] Role checks happen server-side (never client-only)
- [ ] API endpoints validate user permissions
- [ ] File uploads validate ownership
- [ ] Rate limiting prevents abuse
- [ ] CORS configured correctly (not allow-all)

### Data Privacy Audit
- [ ] PII is encrypted at rest
- [ ] Sensitive data not logged
- [ ] API responses don't leak data
- [ ] Error messages don't expose internals
- [ ] Audit logging captures access

## Audit Process

### Step 1: Read Migration File

**CRITICAL**: Read the migration SQL from file.

**File to read**:
```
docs/features/[feature-slug]/03-migration.sql
```

**What to extract**:
- RLS policies defined
- Table access permissions
- Policy logic and conditions

### Step 2: Review and Test RLS Policies

For each policy found in migration, test:

```sql
-- Test 1: Regular user cannot see other users' data
SET LOCAL ROLE authenticated_user;
SET LOCAL app.current_user_id = '[user-A-uuid]';

SELECT * FROM table_name WHERE user_id = '[user-B-uuid]';
-- Expected: 0 rows (access denied)

-- Test 2: User can see own data
SELECT * FROM table_name WHERE user_id = '[user-A-uuid]';
-- Expected: User A's rows only

-- Test 3: Admin can see all data
SET LOCAL ROLE admin_user;
SELECT COUNT(*) FROM table_name;
-- Expected: All rows

-- Test 4: Unauthenticated user blocked
RESET ROLE;
SELECT * FROM table_name;
-- Expected: Error or 0 rows
```

### Step 3: Identify Vulnerabilities

**Common issues to check**:

1. **Insecure Direct Object Reference (IDOR)**:
   ```
   GET /api/exports/[uuid]
   ```
   - ❌ BAD: No ownership check
   - ✅ GOOD: RLS policy prevents access

2. **SQL Injection**:
   ```javascript
   // ❌ BAD
   db.query(`SELECT * FROM users WHERE email = '${email}'`)

   // ✅ GOOD
   db.query('SELECT * FROM users WHERE email = $1', [email])
   ```

3. **Authentication Bypass**:
   ```javascript
   // ❌ BAD: Client controls auth
   if (req.body.isAdmin) { /* admin access */ }

   // ✅ GOOD: Server validates
   if (await authService.isAdmin(req.user.id)) { /* admin access */ }
   ```

4. **Mass Assignment**:
   ```javascript
   // ❌ BAD: User can set any field
   await user.update(req.body)

   // ✅ GOOD: Whitelist allowed fields
   await user.update(pick(req.body, ['name', 'email']))
   ```

### Step 4: Rate Security Risks

For each identified risk:

```
**Risk**: [Description]
**Severity**: Critical | High | Medium | Low
**Exploitability**: Easy | Moderate | Difficult
**Impact**: [What happens if exploited?]
**Mitigation**: [How to fix it]
**Status**: Open | Mitigated | Accepted Risk
```

**Severity Definitions**:
- **Critical**: Data breach, complete system compromise
- **High**: Unauthorized access to sensitive data
- **Medium**: Limited access or DoS potential
- **Low**: Information disclosure, minor issues

### Step 5: Test Security Controls

**Create attack scenarios**:

```bash
# Scenario 1: Try to access other user's export
curl -H "Authorization: Bearer [user-A-token]" \
  https://api.example.com/exports/[user-B-export-id]
# Expected: 403 Forbidden or 404 Not Found

# Scenario 2: Try SQL injection
curl "https://api.example.com/users?email=admin'--"
# Expected: Properly escaped, no error leakage

# Scenario 3: Try rate limit bypass
for i in {1..1000}; do
  curl https://api.example.com/exports -d '{"format":"json"}'
done
# Expected: 429 Too Many Requests after threshold
```

### Step 6: Save Security Audit Report

**CRITICAL**: Save audit report to file for handoff to QAS Agent.

**File location**:
```
docs/features/[feature-slug]/04-security-audit.md
```

**Steps**:
1. Write audit report to file
2. Commit to git:
   ```bash
   git add docs/features/[feature-slug]/04-security-audit.md
   git commit -m "docs: security audit for [feature-name]"
   ```

## Output Format

```markdown
# Security Audit: [Feature Name]

## Audit Date
2025-10-14

## Scope
- RLS policies on user_exports table
- Export API endpoint authorization
- Rate limiting implementation

## Findings

### Critical Issues
None

### High Severity Issues
None

### Medium Severity Issues

#### Issue 1: Rate Limiting Bypassable
**Severity**: Medium
**Description**: Rate limit enforced at application layer only. Attacker could bypass by calling database directly or exploiting background jobs.
**Exploit**: Direct database access or compromised background worker
**Impact**: User could create unlimited exports, exhausting storage
**Mitigation**: Add database-level rate limit constraint or trigger
**Status**: Mitigated (added CHECK constraint)

### Low Severity Issues

#### Issue 2: Download URLs Not IP-Restricted
**Severity**: Low
**Description**: Signed URLs can be shared across IPs
**Impact**: User could share download link (expires in 1 hour anyway)
**Mitigation**: Bind signed URL to originating IP
**Status**: Accepted Risk (1-hour expiration sufficient)

## Policy Validation

### user_exports RLS Policies

✅ **PASS**: `user_exports_select_policy`
- Users can only SELECT their own exports
- Tested with multiple users, no cross-access

✅ **PASS**: `user_exports_insert_policy`
- Users can only INSERT for themselves
- Attempt to insert for other user blocked

✅ **PASS**: `user_exports_update_policy`
- Users can only UPDATE their own pending exports
- Cannot modify completed exports

✅ **PASS**: `user_exports_admin_policy`
- Admin can access all exports
- Properly uses is_admin() check

⚠️ **WARNING**: System Background Job Access
- Background jobs need UPDATE access to all exports
- **Recommendation**: Create separate policy for service accounts

## Attack Scenarios Tested

1. ✅ IDOR Attack: User A cannot access User B's export
2. ✅ SQL Injection: Input properly parameterized
3. ✅ Rate Limit: 429 after 1 request within 24 hours
4. ✅ Auth Bypass: Unauthenticated requests rejected
5. ⚠️ URL Sharing: Signed URL shareable (acceptable)

## Security Score

**Overall**: 8/10 - Safe to deploy with noted warnings

**Breakdown**:
- Authentication: 10/10
- Authorization: 9/10 (background job policy needed)
- Data Protection: 8/10 (consider IP-binding URLs)
- Rate Limiting: 7/10 (application-layer only)
- Error Handling: 10/10

## Recommendations

### Before Deployment
1. ✅ Add service account policy for background jobs
2. ⚠️ Consider database-level rate limiting (nice-to-have)

### Future Enhancements
1. Monitor export patterns for abuse
2. Add IP-binding to signed URLs
3. Implement anomaly detection

## Sign-Off

Security Audit: ✅ **APPROVED FOR DEPLOYMENT**

Conditions:
- Background job policy must be added before deployment
- Monitor export creation rates for first 48 hours

## Next Steps
- **File saved**: `docs/features/[feature-slug]/04-security-audit.md`
- **Handoff to**: QAS Agent (reads audit report for security tests)
```

## Boundaries

**This skill does NOT**:
- Implement fixes (that's implementation)
- Make product decisions (that's product/business)
- Design architecture (that's System Architect)
- Deploy code (that's RTE Agent)

**This skill DOES**:
- **Read migration from file**
- Audit security implementations
- Identify vulnerabilities
- Rate risk severity
- Block on critical issues
- Recommend mitigations
- **Save audit report to file** for next agent

## Related Skills

- Data Engineer (`~/.claude/skills/lifecycle/sustainment/migrations/SKILL.md`) - Implements RLS policies
- QAS Agent (`~/.claude/skills/lifecycle/testing/acceptance_testing/SKILL.md`) - Tests security scenarios

## Version History
- 1.0.0 (2025-10-14): Initial skill creation
