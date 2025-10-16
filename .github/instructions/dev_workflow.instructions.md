````instructions
---
description: Development workflow guidelines for the db-data service
applyTo: "**/*"
---

# DB Data Development Workflow

This document provides development workflow guidelines specific to the db-data service.

## Service Overview

The db-data service provides a PostgreSQL data volume container for the PGNC external stack. It's built on Alpine Linux and designed to hold database initialization scripts and data.

## Development Process

### 1. Making Changes

- Database schema or initialization script changes should be placed in `docker-entrypoint-initdb.d/`
- Keep the Dockerfile minimal - it's primarily a data volume container
- Test changes locally with docker-compose before committing

### 2. Building Locally

```bash
# Build the image
docker build -t pgnc-db-data:local .

# Test with docker-compose
docker-compose up db-data
```

### 3. Release Process

The db-data service uses automated semantic versioning and releases:

- Commits to the `release` branch trigger automatic releases
- Manual releases can be triggered via GitHub Actions workflow dispatch
- Each release creates:
  - A GitHub Release with auto-generated notes
  - Docker images pushed to `ghcr.io/hgnc/pgnc-db-data` with tags:
    - Semantic version (e.g., `v1.0.0`)
    - `latest`
    - `release`

### 4. Version Management

- **Patch releases**: Bug fixes, small updates to scripts
- **Minor releases**: New database initialization scripts, schema additions
- **Major releases**: Breaking changes to database structure

Use workflow dispatch inputs to control release type:
- `release_type`: Choose patch/minor/major
- `explicit_version`: Override with a specific version (e.g., v2.0.0)
- `confirm_major`: Required confirmation for major releases
- `notes_override`: Custom release notes

## Docker Image Usage

The built images are multi-platform (linux/amd64, linux/arm64) and include:
- Build metadata (version, commit SHA, build date)
- OCI labels for container registry integration

Pull the latest release:
```bash
docker pull ghcr.io/hgnc/pgnc-db-data:latest
```

## Best Practices

- Keep the image lightweight - only include necessary initialization scripts
- Document any changes to database schema or structure
- Test database initialization with a fresh PostgreSQL container
- Ensure scripts are idempotent where possible
- Consider backwards compatibility for data migrations
````
