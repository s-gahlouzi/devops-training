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
    
    log "Database is ready"
}

# Run migrations
run_migrations() {
    if [[ "${MIGRATE:-false}" == "true" ]]; then
        log "Running migrations..."
        npm run migrate
        log "Migrations complete"
    fi
}

# Initialization
init() {
    log "Starting application..."
    log "Environment: ${NODE_ENV:-development}"
    
    # Wait for database if configured
    if [[ -n "${DB_HOST:-}" ]]; then
        wait_for_service "$DB_HOST" "${DB_PORT:-5432}" 30
        run_migrations
    fi
}

# Main
main() {
    init
    
    local command="${1:-server}"
    
    case "$command" in
        server)
            log "Starting server on port ${PORT:-3000}..."
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
            log "Running custom command: $*"
            exec "$@"
            ;;
    esac
}

main "$@"
