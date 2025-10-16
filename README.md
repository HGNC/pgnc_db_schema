# PGNC Database Seed

Artifacts in this directory prime the PostgreSQL volume that backs the stack. The `pgnc-data` service in `docker-compose.yml` builds from here and ships your database dump into `/docker-entrypoint-initdb.d`, allowing the main `postgres:17` container to initialize with PGNC data on first run.

## Repository Contents

- `Dockerfile` – minimalist Alpine image that simply exposes `/var/lib/postgresql` as a volume
- `docker-entrypoint-initdb.d/01-pgncdb.sql.gz` – gzip-compressed dump consumed by the upstream Postgres entrypoint

## Updating the Seed Dump

1. **Obtain the latest dump** from the PGNC AWS RDS instance (`pg_dump` is recommended). Capture both schema and data:

	```bash
	pg_dump --format=custom --clean --create --if-exists \
	  --dbname=postgresql://USER:PASSWORD@HOST:PORT/pgnc_database \
	  | gzip > /tmp/pgncdb.sql.gz
	```

2. **Replace the existing file**:

	```bash
	mv /tmp/pgncdb.sql.gz db-data/docker-entrypoint-initdb.d/01-pgncdb.sql.gz
	```

	Keep the filename identical so the import order remains deterministic. The numeric prefix ensures predictable execution if additional SQL files are introduced later.

3. **Exclude credentials**. Verify the dump does not contain user-specific credentials or secrets before committing.

4. **Rebuild the helper image** if you intend to refresh an environment:

	```bash
	docker compose build pgnc-data
	```

5. **Recreate the database volume** to trigger initialization (data volumes are not overwritten automatically):

	```bash
	docker compose down --volumes pgnc-data
	docker compose up -d pgnc-data
	```

	Bringing the stack back up (`docker compose up -d`) will now load the fresh dump during Postgres start-up.

## Verification

- Inspect the archive:

  ```bash
  gzip -l db-data/docker-entrypoint-initdb.d/01-pgncdb.sql.gz
  ```

- Restore to a scratch database locally before shipping if you need certainty:

  ```bash
  createdb pgnc_verify
  gunzip -c db-data/docker-entrypoint-initdb.d/01-pgncdb.sql.gz | psql pgnc_verify
  ```

## Best Practices

- Keep dumps as small as practical; drop transient tables before exporting where possible.
- Never commit database dumps containing personal data from environments that require sanitization.
- Document the dump source and timestamp in your pull request to aid traceability.
