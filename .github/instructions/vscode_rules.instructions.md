````instructions
---
description: Guidelines for creating and maintaining VS Code rules specific to db-data service
applyTo: ".github/instructions/*.instructions.md"
---

# VS Code Rules for DB Data Service

## Required Rule Structure

```markdown
---
description: Clear, one-line description of what the rule enforces
globs: sql/**/*.sql, docker-entrypoint-initdb.d/**/*
alwaysApply: boolean
---

- **Main Points in Bold**
  - Sub-points with details
  - Examples and explanations
```

## File References

- Use `[filename](mdc:path/to/file)` for file references
- Example: [schema.sql](mdc:docker-entrypoint-initdb.d/schema.sql)
- Example: [Dockerfile](mdc:Dockerfile)

## SQL Code Examples

```sql
-- ✅ DO: Show good examples
CREATE TABLE IF NOT EXISTS genes (
  id SERIAL PRIMARY KEY,
  symbol VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ❌ DON'T: Show anti-patterns
CREATE TABLE genes (
  id INT,
  symbol VARCHAR(255)
);
```

## Rule Content Guidelines

- Start with high-level overview of database patterns
- Include specific, actionable SQL requirements
- Show examples of correct SQL implementation
- Reference PostgreSQL documentation when relevant
- Keep rules DRY by referencing other rules

## Service-Specific Patterns

### Database Schema Rules
- Table naming conventions (lowercase, underscores)
- Primary key patterns (id SERIAL PRIMARY KEY)
- Timestamp field standards (created_at, updated_at)
- Foreign key naming conventions

### SQL Script Rules
- Use `IF NOT EXISTS` for idempotent scripts
- Include proper transaction handling
- Add comments for complex queries
- Follow PostgreSQL style guide

### Docker Volume Rules
- Document volume mount points
- Specify data persistence requirements
- Note backup and restore procedures

## Rule Quality Checks

- Rules should be specific to database operations
- Examples should come from actual initialization scripts
- References should point to PostgreSQL documentation
- Patterns should be consistently enforced

## Example Rule

```markdown
---
description: PostgreSQL table creation standards
globs: docker-entrypoint-initdb.d/**/*.sql
alwaysApply: true
---

- **Table Creation Standards:**
  - Use `CREATE TABLE IF NOT EXISTS` for idempotent scripts
  - Always define PRIMARY KEY constraint
  - Use SERIAL for auto-incrementing IDs
  - Include created_at and updated_at timestamps where appropriate

- **Example:**
  ```sql
  CREATE TABLE IF NOT EXISTS genes (
    id SERIAL PRIMARY KEY,
    symbol VARCHAR(255) NOT NULL UNIQUE,
    name TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  );
  ```
```

## Continuous Improvement

- Monitor SQL script patterns in the codebase
- Update rules when PostgreSQL best practices evolve
- Add new rules for emerging patterns
- Remove outdated rules that no longer apply
- Keep examples synchronized with actual scripts
````
