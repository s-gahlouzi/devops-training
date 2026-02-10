# Exercise 23: Docker Entrypoint Script

## Goal

Create a production-ready Docker entrypoint script with configuration and health checks.

## Requirements

Create `docker-entrypoint.sh` that:

1. Uses safe bash options
2. Runs as PID 1 and handles signals properly
3. Validates required environment variables
4. Performs these initialization steps:
   - Wait for database to be ready (if DB_HOST is set)
   - Run database migrations (if MIGRATE=true)
   - Set up application config from env vars
5. Supports different command modes:
   - `server`: Start the web server (default)
   - `worker`: Start background worker
   - `migrate`: Run migrations and exit
   - `shell`: Drop into bash shell
6. Uses `exec` to replace shell with application
7. Forwards signals to child processes

Create `Dockerfile` that uses the entrypoint

Create `wait-for-it.sh` helper script that:

- Waits for TCP service to be available
- Supports timeout
- Used by entrypoint to wait for dependencies

## Expected Behavior

```bash
# Default: start server
docker run myapp
[2026-02-04 10:00:00] Starting application...
[2026-02-04 10:00:00] Environment: production
[2026-02-04 10:00:00] Waiting for database...
[2026-02-04 10:00:02] Database is ready
[2026-02-04 10:00:02] Running migrations...
[2026-02-04 10:00:05] Migrations complete
[2026-02-04 10:00:05] Starting server on port 3000...

# Worker mode
docker run myapp worker
[2026-02-04 10:00:00] Starting worker...

# Migration only
docker run myapp migrate
[2026-02-04 10:00:00] Running migrations...
[2026-02-04 10:00:02] Migrations complete
(exits)

# Shell access
docker run -it myapp shell
root@container:/app#

# With custom command
docker run myapp npm run custom-script
[2026-02-04 10:00:00] Running custom command...
```

## Success Criteria

- Proper signal handling
- Uses exec for final command
- Waits for dependencies
- Environment validation
- Multiple command modes
- Production-ready patterns
