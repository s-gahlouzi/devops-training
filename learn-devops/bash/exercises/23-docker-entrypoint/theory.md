# Theory: Docker Entrypoint Scripts

## Basic Structure

```bash
#!/usr/bin/env bash
set -euo pipefail

# Logging
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"
}

# Initialization
init() {
    log "Initializing application..."
    # Setup tasks
}

# Main
main() {
    init

    # Replace shell with application (important for signals)
    exec "$@"
}

main "$@"
```

## exec Command

Replace shell process with application:

```bash
# WITHOUT exec (shell remains as PID 1)
node server.js

# WITH exec (node becomes PID 1)
exec node server.js
```

**Why exec is important:**

- Application receives signals directly
- No zombie processes
- Proper shutdown handling
- Container stops cleanly

## Signal Handling

```bash
#!/usr/bin/env bash

# Forward signals to child process
trap 'kill -TERM $PID' TERM INT

# Start application in background
node server.js &
PID=$!

# Wait for process
wait $PID
```

## Wait for Dependencies

```bash
wait_for_service() {
    local host="$1"
    local port="$2"
    local timeout="${3:-30}"
    local count=0

    log "Waiting for $host:$port..."

    while ! nc -z "$host" "$port" 2>/dev/null; do
        if (( count >= timeout )); then
            log "Timeout waiting for $host:$port"
            return 1
        fi
        sleep 1
        ((count++))
    done

    log "$host:$port is available"
}

# Usage
if [[ -n "${DB_HOST:-}" ]]; then
    wait_for_service "$DB_HOST" "${DB_PORT:-5432}" 30
fi
```

## Environment Validation

```bash
validate_environment() {
    local required=(
        "NODE_ENV"
        "DATABASE_URL"
        "SECRET_KEY"
    )

    for var in "${required[@]}"; do
        if [[ -z "${!var:-}" ]]; then
            log "ERROR: $var is required" >&2
            exit 1
        fi
    done
}

# Development vs Production
if [[ "${NODE_ENV}" == "production" ]]; then
    : "${SECRET_KEY:?SECRET_KEY is required in production}"
fi
```

## Command Modes

```bash
#!/usr/bin/env bash
set -euo pipefail

main() {
    case "${1:-server}" in
        server)
            log "Starting server..."
            exec node server.js
            ;;
        worker)
            log "Starting worker..."
            exec node worker.js
            ;;
        migrate)
            log "Running migrations..."
            npm run migrate
            exit 0
            ;;
        shell)
            log "Starting shell..."
            exec /bin/bash
            ;;
        *)
            # Run custom command
            log "Running: $*"
            exec "$@"
            ;;
    esac
}

main "$@"
```

## Configuration from Environment

```bash
generate_config() {
    local config_file="/app/config.json"

    log "Generating configuration..."

    cat > "$config_file" <<EOF
{
  "port": ${PORT:-3000},
  "database": {
    "host": "${DB_HOST}",
    "port": ${DB_PORT:-5432},
    "name": "${DB_NAME}"
  },
  "logging": {
    "level": "${LOG_LEVEL:-info}"
  }
}
EOF

    log "Configuration written to $config_file"
}
```

## Template Substitution

```bash
# Using envsubst
envsubst < config.template > config.json

# Manual substitution
substitute_env() {
    local template="$1"
    local output="$2"

    sed "s/\${PORT}/${PORT}/g; s/\${DB_HOST}/${DB_HOST}/g" \
        "$template" > "$output"
}
```

## Database Migrations

```bash
run_migrations() {
    local migrate="${MIGRATE:-false}"

    if [[ "$migrate" == "true" ]]; then
        log "Running database migrations..."

        # Wait for database
        wait_for_service "$DB_HOST" "$DB_PORT" 30

        # Run migrations
        if npm run migrate; then
            log "Migrations completed successfully"
        else
            log "Migration failed" >&2
            exit 1
        fi
    fi
}
```

## Health Check Script

```bash
#!/usr/bin/env bash
# healthcheck.sh

set -euo pipefail

# Check if application is responding
if curl -sf http://localhost:${PORT:-3000}/health >/dev/null; then
    echo "healthy"
    exit 0
else
    echo "unhealthy"
    exit 1
fi
```

## Complete Entrypoint Template

```bash
#!/usr/bin/env bash
set -euo pipefail

# Logging
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"
}

log_error() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] ERROR: $*" >&2
}

# Wait for service
wait_for_service() {
    local host="$1"
    local port="$2"
    local timeout="${3:-30}"
    local count=0

    log "Waiting for $host:$port..."

    while ! nc -z "$host" "$port" 2>/dev/null; do
        if (( count >= timeout )); then
            log_error "Timeout waiting for $host:$port"
            return 1
        fi
        sleep 1
        ((count++))
    done

    log "$host:$port is available"
}

# Validate environment
validate_environment() {
    case "${NODE_ENV:-development}" in
        production)
            : "${SECRET_KEY:?SECRET_KEY is required in production}"
            : "${DATABASE_URL:?DATABASE_URL is required in production}"
            ;;
        development)
            log "Running in development mode"
            ;;
        *)
            log_error "Invalid NODE_ENV: ${NODE_ENV}"
            exit 1
            ;;
    esac
}

# Run migrations
run_migrations() {
    if [[ "${MIGRATE:-false}" == "true" ]]; then
        log "Running database migrations..."
        npm run migrate
        log "Migrations complete"
    fi
}

# Initialization
init() {
    log "Initializing application..."
    log "Environment: ${NODE_ENV:-development}"

    validate_environment

    # Wait for database
    if [[ -n "${DB_HOST:-}" ]]; then
        wait_for_service "$DB_HOST" "${DB_PORT:-5432}" 30
        run_migrations
    fi

    log "Initialization complete"
}

# Main
main() {
    init

    local command="${1:-server}"

    case "$command" in
        server)
            log "Starting server..."
            exec node server.js
            ;;
        worker)
            log "Starting worker..."
            exec node worker.js
            ;;
        migrate)
            log "Running migrations..."
            npm run migrate
            exit 0
            ;;
        shell)
            log "Starting shell..."
            exec /bin/bash
            ;;
        *)
            # Custom command
            log "Running custom command: $*"
            exec "$@"
            ;;
    esac
}

main "$@"
```

## Dockerfile Integration

```dockerfile
FROM node:20-alpine

WORKDIR /app

# Install dependencies
COPY package*.json ./
RUN npm ci --production

# Copy application
COPY . .

# Copy entrypoint
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Health check
COPY healthcheck.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/healthcheck.sh

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s \
  CMD /usr/local/bin/healthcheck.sh

# Entrypoint
ENTRYPOINT ["docker-entrypoint.sh"]

# Default command
CMD ["server"]
```

## wait-for-it.sh (Advanced)

```bash
#!/usr/bin/env bash
# wait-for-it.sh - Wait for service to be available

set -euo pipefail

usage() {
    cat <<EOF
Usage: $0 host:port [-t timeout] [-- command args]

Wait for a TCP service to be available

Options:
  -t TIMEOUT    Timeout in seconds (default: 15)
  -- COMMAND    Execute command after service is available
EOF
    exit 1
}

# Parse arguments
HOST=""
PORT=""
TIMEOUT=15
COMMAND=()

while [[ $# -gt 0 ]]; do
    case "$1" in
        -t)
            TIMEOUT="$2"
            shift 2
            ;;
        --)
            shift
            COMMAND=("$@")
            break
            ;;
        *:*)
            HOST="${1%:*}"
            PORT="${1#*:}"
            shift
            ;;
        *)
            echo "Unknown option: $1"
            usage
            ;;
    esac
done

[[ -z "$HOST" || -z "$PORT" ]] && usage

# Wait for service
echo "Waiting for $HOST:$PORT..."
start=$(date +%s)

while ! nc -z "$HOST" "$PORT" 2>/dev/null; do
    elapsed=$(($(date +%s) - start))
    if (( elapsed >= TIMEOUT )); then
        echo "Timeout after ${TIMEOUT}s waiting for $HOST:$PORT"
        exit 1
    fi
    sleep 1
done

echo "$HOST:$PORT is available after ${elapsed}s"

# Execute command if provided
if (( ${#COMMAND[@]} > 0 )); then
    exec "${COMMAND[@]}"
fi
```

## Advanced Patterns

**Multi-stage initialization:**

```bash
init_stage_1() {
    log "Stage 1: Environment setup"
    validate_environment
}

init_stage_2() {
    log "Stage 2: External dependencies"
    wait_for_service "$DB_HOST" "$DB_PORT"
    wait_for_service "$REDIS_HOST" "$REDIS_PORT"
}

init_stage_3() {
    log "Stage 3: Application setup"
    run_migrations
    generate_config
}

init() {
    init_stage_1
    init_stage_2
    init_stage_3
    log "Initialization complete"
}
```

**User switching:**

```bash
# Run as non-root user
if [[ "$(id -u)" == "0" ]]; then
    log "Switching to app user..."
    exec su-exec app "$0" "$@"
fi

# Or with gosu
exec gosu app "$@"
```

**Graceful shutdown:**

```bash
#!/usr/bin/env bash

APP_PID=""

shutdown() {
    log "Received shutdown signal"
    if [[ -n "$APP_PID" ]]; then
        log "Stopping application (PID: $APP_PID)..."
        kill -TERM "$APP_PID" 2>/dev/null || true
        wait "$APP_PID" 2>/dev/null || true
        log "Application stopped"
    fi
    exit 0
}

trap shutdown TERM INT

# Start application in background
node server.js &
APP_PID=$!

# Wait
wait $APP_PID
```

## Best Practices

1. **Use exec for final command:**

   ```bash
   exec node server.js
   ```

2. **Wait for dependencies:**

   ```bash
   wait_for_service "$DB_HOST" "$DB_PORT"
   ```

3. **Validate environment:**

   ```bash
   : "${VAR:?VAR is required}"
   ```

4. **Support multiple modes:**

   ```bash
   case "$1" in server|worker|migrate) ...
   ```

5. **Handle signals properly:**

   ```bash
   trap shutdown TERM INT
   ```

6. **Log everything:**

   ```bash
   log "Starting application..."
   ```

7. **Fail fast:**

   ```bash
   set -euo pipefail
   ```

8. **Make idempotent:**
   - Can be run multiple times safely
   - Check before creating/modifying
