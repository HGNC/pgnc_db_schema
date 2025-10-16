````instructions
---
description: Guidelines for continuously improving db-data rules based on emerging patterns and best practices.
applyTo: "**/*"
---

# Self-Improvement Guidelines for DB Data Service

## Rule Improvement Triggers

- New database schema patterns not covered by existing rules
- Repeated similar SQL patterns across initialization scripts
- Common database migration errors that could be prevented
- New database tools or utilities being used consistently
- Emerging best practices for PostgreSQL in containers

## Analysis Process

- Compare new SQL scripts with existing rules
- Identify patterns that should be standardized
- Look for references to PostgreSQL documentation
- Check for consistent data migration patterns
- Monitor database initialization patterns

## Rule Updates

### Add New Rules When

- A new database pattern is used in 3+ scripts
- Common migration issues could be prevented by a rule
- Database reviews repeatedly mention the same feedback
- New security or performance patterns emerge for PostgreSQL
- Docker volume handling patterns change

### Modify Existing Rules When

- Better SQL examples exist in the scripts
- Additional edge cases are discovered in migrations
- Related database rules have been updated
- PostgreSQL best practices have evolved

## Example Pattern Recognition

```sql
-- If you see repeated patterns like:
CREATE TABLE IF NOT EXISTS users (
  id SERIAL PRIMARY KEY,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Consider adding to rules:
-- - Standard table creation patterns
-- - Common timestamp defaults
-- - Primary key conventions
```

## Rule Quality Checks

- Rules should be specific to database operations
- Examples should come from actual initialization scripts
- References should point to PostgreSQL documentation
- Patterns should be consistently enforced across scripts

## Continuous Improvement

- Monitor database initialization logs
- Track common database setup questions
- Update rules after major PostgreSQL version upgrades
- Add links to relevant PostgreSQL documentation
- Cross-reference related database rules

## Rule Deprecation

- Mark outdated PostgreSQL patterns as deprecated
- Remove rules that no longer apply to current version
- Update references to deprecated PostgreSQL features
- Document migration paths for old database patterns

## Documentation Updates

- Keep SQL examples synchronized with actual scripts
- Update references to PostgreSQL documentation
- Maintain links between related database rules
- Document breaking changes in PostgreSQL versions

Follow [vscode_rules.instructions.md](.github/instructions/vscode_rules.instructions.md) for proper rule formatting and structure.
````
