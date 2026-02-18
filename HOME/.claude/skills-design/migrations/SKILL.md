---
name: Data Engineer
description: Creates database migrations, implements RLS policies, and manages data transformations
when_to_use: when implementing database changes, RLS policies, or data migrations from architect designs
version: 1.0.0
---

# Data Engineer

## Overview

The Data Engineer implements database schemas and Row-Level Security policies designed by the System Architect. This skill ensures database changes are correct, reversible, and secure.

## When to Use This Skill

- Creating database migrations
- Implementing RLS (Row-Level Security) policies
- Writing data transformation scripts
- Optimizing database performance
- After System Architect completes schema design

## Critical Rules

1. **All migrations must be reversible** - Always include DOWN migration
2. **Test RLS policies thoroughly** - Verify they work as intended
3. **Never skip indexes** - Slow queries = production incidents
4. **Document migration risks** - What could go wrong?

## Process

### Step 1: Read Architecture Design File

**CRITICAL**: Read the architecture design from file.

**File to read**:
```
docs/features/[feature-slug]/02-architecture-design.md
```

**What to extract**:
- Table structures
- Relationships
- Indexes needed
- Scale considerations
- RLS requirements

### Step 2: Create Migration File

**Naming convention**: `YYYYMMDDHHMMSS_description.sql`

```sql
-- Migration: Add user_exports table with RLS
-- Created: 2025-10-14
-- Author: [Your name]
-- Ticket: WOR-315

-- UP Migration
BEGIN;

-- Create table
CREATE TABLE IF NOT EXISTS user_exports (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  status VARCHAR(20) NOT NULL DEFAULT 'pending'
    CHECK (status IN ('pending', 'processing', 'completed', 'failed')),
  format VARCHAR(10) NOT NULL CHECK (format IN ('json', 'csv')),
  file_url TEXT,
  error_message TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  completed_at TIMESTAMPTZ,
  expires_at TIMESTAMPTZ NOT NULL DEFAULT (now() + INTERVAL '7 days')
);

-- Create indexes
CREATE INDEX idx_user_exports_user_id ON user_exports(user_id);
CREATE INDEX idx_user_exports_status ON user_exports(status);
CREATE INDEX idx_user_exports_created_at ON user_exports(created_at);
CREATE INDEX idx_user_exports_expires_at ON user_exports(expires_at)
  WHERE status = 'completed';

-- Enable RLS
ALTER TABLE user_exports ENABLE ROW LEVEL SECURITY;

-- RLS Policy: Users can only see their own exports
CREATE POLICY user_exports_select_policy ON user_exports
  FOR SELECT
  USING (user_id = current_user_id());

-- RLS Policy: Users can create their own exports
CREATE POLICY user_exports_insert_policy ON user_exports
  FOR INSERT
  WITH CHECK (user_id = current_user_id());

-- RLS Policy: Users can update only their own pending exports
CREATE POLICY user_exports_update_policy ON user_exports
  FOR UPDATE
  USING (user_id = current_user_id() AND status = 'pending')
  WITH CHECK (user_id = current_user_id());

-- RLS Policy: Admins can do everything
CREATE POLICY user_exports_admin_policy ON user_exports
  FOR ALL
  USING (is_admin());

-- Grant permissions
GRANT SELECT, INSERT ON user_exports TO authenticated_users;
GRANT ALL ON user_exports TO admin_users;

COMMIT;

-- DOWN Migration
BEGIN;

DROP POLICY IF EXISTS user_exports_admin_policy ON user_exports;
DROP POLICY IF EXISTS user_exports_update_policy ON user_exports;
DROP POLICY IF EXISTS user_exports_insert_policy ON user_exports;
DROP POLICY IF EXISTS user_exports_select_policy ON user_exports;

DROP TABLE IF EXISTS user_exports CASCADE;

COMMIT;
```

### Step 3: Implement RLS Policies

**For each table with multi-tenant data**:

1. **Enable RLS**:
   ```sql
   ALTER TABLE table_name ENABLE ROW LEVEL SECURITY;
   ```

2. **Create user policy** (users see only their data):
   ```sql
   CREATE POLICY table_select_policy ON table_name
     FOR SELECT
     USING (user_id = current_user_id());
   ```

3. **Create admin policy** (admins see everything):
   ```sql
   CREATE POLICY table_admin_policy ON table_name
     FOR ALL
     USING (is_admin());
   ```

4. **Test policies**:
   ```sql
   -- Test as regular user
   SET LOCAL ROLE authenticated_user;
   SET LOCAL app.current_user_id = '[user-uuid]';
   SELECT * FROM table_name; -- Should only see own rows

   -- Test as admin
   SET LOCAL ROLE admin_user;
   SELECT * FROM table_name; -- Should see all rows
   ```

### Step 4: Add Indexes

**Index strategy**:

```sql
-- Foreign keys (always index)
CREATE INDEX idx_table_foreign_key ON table_name(foreign_key_id);

-- Common WHERE clauses
CREATE INDEX idx_table_status ON table_name(status);

-- Common ORDER BY clauses
CREATE INDEX idx_table_created_at ON table_name(created_at DESC);

-- Partial indexes (for filtered queries)
CREATE INDEX idx_table_active ON table_name(user_id)
  WHERE deleted_at IS NULL;

-- Composite indexes (for multi-column queries)
CREATE INDEX idx_table_user_status ON table_name(user_id, status);
```

### Step 5: Save Migration Files

**CRITICAL**: Save migration SQL to file for handoff to Security Engineer.

**File location**:
```
docs/features/[feature-slug]/03-migration.sql
```

**Steps**:
1. Write migration SQL to file
2. Commit to git:
   ```bash
   git add docs/features/[feature-slug]/03-migration.sql
   git commit -m "feat: database migration for [feature-name]"
   ```

### Step 6: Handle Data Migrations

**If migrating existing data**:

```sql
-- Backfill new column with default values
UPDATE table_name
SET new_column = 'default_value'
WHERE new_column IS NULL;

-- Or use batching for large tables
DO $$
DECLARE
  batch_size INT := 1000;
  rows_updated INT;
BEGIN
  LOOP
    UPDATE table_name
    SET new_column = 'default_value'
    WHERE id IN (
      SELECT id FROM table_name
      WHERE new_column IS NULL
      LIMIT batch_size
    );

    GET DIAGNOSTICS rows_updated = ROW_COUNT;
    EXIT WHEN rows_updated = 0;

    -- Commit every batch (if using autocommit mode)
    PERFORM pg_sleep(0.1);
  END LOOP;
END $$;
```

## Output Format

```markdown
# Data Engineering: [Feature Name]

## Migration File

**Filename**: `migrations/20251014120000_add_user_exports.sql`

[Full SQL content]

## RLS Policies

### user_exports Table

**Policies implemented**:
1. ✅ `user_exports_select_policy` - Users see only their exports
2. ✅ `user_exports_insert_policy` - Users create only their exports
3. ✅ `user_exports_update_policy` - Users update only pending exports
4. ✅ `user_exports_admin_policy` - Admins have full access

**Testing performed**:
- ✅ Regular user cannot see other users' exports
- ✅ Regular user cannot create exports for other users
- ✅ Admin can see all exports
- ✅ System user (background job) can update any export

## Indexes

| Index Name | Columns | Type | Rationale |
|------------|---------|------|-----------|
| `idx_user_exports_user_id` | `user_id` | B-tree | Foreign key, common filter |
| `idx_user_exports_status` | `status` | B-tree | Status filtering queries |
| `idx_user_exports_created_at` | `created_at DESC` | B-tree | Recent exports query |
| `idx_user_exports_expires_at` | `expires_at` | Partial | Cleanup job filter |

## Performance Impact

**Estimated impact**:
- Migration time: < 1 second (no data)
- Index creation: < 1 second (no existing rows)
- Ongoing query performance: Negligible (all queries use indexes)

**Risk level**: Low (no data modification, reversible)

## Rollback Plan

```bash
# If migration causes issues, run DOWN migration:
psql -f migrations/20251014120000_add_user_exports.sql --variable=direction=down
```

## Next Steps
- **File saved**: `docs/features/[feature-slug]/03-migration.sql`
- **Handoff to**: Security Engineer (reads migration file for audit)
```

## Boundaries

**This skill does NOT**:
- Design schemas (that's System Architect)
- Audit security (that's Security Engineer)
- Write application code (that's implementation)
- Make architecture decisions (that's System Architect)

**This skill DOES**:
- **Read architecture design from file**
- Write SQL migrations
- Implement RLS policies
- Create indexes
- Handle data transformations
- Ensure reversibility
- **Save migration to file** for next agent

## Related Skills

- System Architect (`~/.claude/skills/lifecycle/design/architecture/SKILL.md`) - Provides schema design
- Security Engineer (`~/.claude/skills/crosscutting/security/policy_auditing/SKILL.md`) - Audits RLS policies

## Version History
- 1.0.0 (2025-10-14): Initial skill creation
