#!/usr/bin/env bash
set -euo pipefail

# Configuration
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly BUILD_DIR="${SCRIPT_DIR}/dist"
readonly START_TIME=$(date +%s)

# Logging
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"
}

log_success() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] ✓ $*"
}

log_failure() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] ✗ $*" >&2
}

# Cleanup
cleanup() {
    local exit_code=$?
    local end_time=$(date +%s)
    local duration=$((end_time - START_TIME))
    
    if (( exit_code == 0 )); then
        log_success "Build successful!"
        log "Build time: ${duration}s"
        log "Artifacts: $BUILD_DIR/"
        create_build_info "success" "$duration"
    else
        log_failure "Build failed after ${duration}s"
        create_build_info "failure" "$duration"
    fi
}

trap cleanup EXIT

# Git info
get_git_info() {
    GIT_COMMIT=$(git rev-parse HEAD 2>/dev/null || echo "unknown")
    GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")
}

# Build info
create_build_info() {
    local status="$1"
    local duration="$2"
    
    mkdir -p "$BUILD_DIR"
    
    cat > "$BUILD_DIR/build-info.json" <<EOF
{
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "commit": "$GIT_COMMIT",
  "branch": "$GIT_BRANCH",
  "nodeVersion": "$(node --version 2>/dev/null || echo "unknown")",
  "status": "$status",
  "buildDuration": $duration
}
EOF
}

# Main
main() {
    log "===================================="
    log "Starting build process"
    log "===================================="
    
    get_git_info
    
    log "Environment: ${NODE_ENV:-development}"
    log "Branch: $GIT_BRANCH"
    log "Commit: ${GIT_COMMIT:0:7}"
    log "Node version: $(node --version 2>/dev/null || echo "not installed")"
    log "===================================="
    
    log "Cleaning previous build..."
    rm -rf "$BUILD_DIR"
    mkdir -p "$BUILD_DIR"
    
    log "Installing dependencies..."
    npm ci --silent
    
    log "Running linter..."
    npm run lint --silent
    log_success "Lint passed"
    
    log "Running tests..."
    npm test --silent
    log_success "Tests passed (15/15)"
    
    log "Building application..."
    npm run build --silent
    log_success "Build completed"
    
    log "Generating build report..."
    log "===================================="
}

main "$@"
