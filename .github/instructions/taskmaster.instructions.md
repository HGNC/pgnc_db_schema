````instructions
---
description: Taskmaster integration guidelines for db-data service development
applyTo: "**/*"
---

# Taskmaster Integration for DB Data Service

This document outlines how to use Taskmaster for managing development tasks in the db-data service.

## Service-Specific Considerations

The db-data service is primarily a data volume container, so tasks typically involve:

- Database schema design and updates
- SQL initialization script creation and maintenance
- Data migration scripts
- Database testing and validation
- Volume handling and data persistence

## Task Categories

### Database Schema Tasks
- Designing new tables or modifying existing ones
- Creating indexes for performance optimization
- Setting up foreign key relationships
- Defining constraints and triggers

### Initialization Scripts
- Creating SQL scripts for database setup
- Updating existing initialization scripts
- Ensuring idempotent script execution
- Managing script execution order

### Data Migration Tasks
- Creating migration scripts for schema changes
- Handling data transformations
- Testing migration rollback procedures
- Documenting migration steps

### Testing Tasks
- Validating database initialization
- Testing data persistence across container restarts
- Verifying SQL script execution
- Performance testing for large datasets

## Task Structure Example

```json
{
  "id": 1,
  "title": "Add gene_metadata table",
  "description": "Create new table for storing gene metadata",
  "status": "pending",
  "priority": "high",
  "dependencies": [],
  "details": "Design and implement gene_metadata table with appropriate indexes and constraints",
  "testStrategy": "Verify table creation, test insert/update operations, validate constraints",
  "subtasks": [
    {
      "id": 1,
      "title": "Design table schema",
      "description": "Define columns, data types, and constraints"
    },
    {
      "id": 2,
      "title": "Create migration script",
      "description": "Write SQL script for table creation"
    },
    {
      "id": 3,
      "title": "Add indexes",
      "description": "Create appropriate indexes for performance"
    }
  ]
}
```

## Best Practices

- Break down complex database changes into smaller, testable subtasks
- Always include rollback procedures in migration tasks
- Document any dependencies on other database objects
- Include test data creation in testing tasks
- Consider data volume and performance implications

## Integration with Release Workflow

- Tasks related to schema changes should be completed before creating releases
- Use task status to track readiness for release
- Link tasks to specific database version updates
- Document breaking changes in task details

For general Taskmaster usage, refer to the main Taskmaster documentation.
````
