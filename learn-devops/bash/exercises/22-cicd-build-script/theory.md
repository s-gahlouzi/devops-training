# Theory: CI/CD Build Scripts

## Script Structure

```bash
#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# Configuration
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly BUILD_DIR="${SCRIPT_DIR}/dist"
readonly LOG_FILE="${SCRIPT_DIR}/build.log"

# Cleanup on exit
cleanup() {
    local exit_code=$?
    if (( exit_code != 0 )); then
        log "Build failed with exit code $exit_code"
    fi
    # Cleanup temp files
    rm -rf /tmp/build-*
}
trap cleanup EXIT

# Logging function
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"
}

# Main execution
main() {
    log "Starting build..."
    # Build steps
}

main "$@"
```

## Environment Validation

```bash
validate_environment() {
    local required_vars=(
        "NODE_ENV"
        "BUILD_VERSION"
        "GIT_COMMIT"
    )

    for var in "${required_vars[@]}"; do
        if [[ -z "${!var:-}" ]]; then
            echo "Error: $var is not set" >&2
            exit 1
        fi
    done

    # Check required commands
    local required_commands=(
        "node"
        "npm"
        "git"
    )

    for cmd in "${required_commands[@]}"; do
        if ! command -v "$cmd" &>/dev/null; then
            echo "Error: $cmd is not installed" >&2
            exit 1
        fi
    done
}
```

## Logging

```bash
# Simple logging
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*" >&2
}

# Level-based logging
log_info() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] [INFO] $*" >&2
}

log_warn() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] [WARN] $*" >&2
}

log_error() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] [ERROR] $*" >&2
}

# With colors (if TTY)
if [[ -t 1 ]]; then
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[0;33m'
    NC='\033[0m'  # No Color
else
    RED=''
    GREEN=''
    YELLOW=''
    NC=''
fi

log_success() {
    echo -e "${GREEN}✓${NC} $*"
}

log_failure() {
    echo -e "${RED}✗${NC} $*" >&2
}
```

## Git Information

```bash
get_git_info() {
    GIT_COMMIT=$(git rev-parse HEAD)
    GIT_SHORT_COMMIT=$(git rev-parse --short HEAD)
    GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
    GIT_TAG=$(git describe --tags --exact-match 2>/dev/null || echo "")
    GIT_DIRTY=$(git diff --quiet || echo "-dirty")
}

# Check if working directory is clean
check_git_clean() {
    if ! git diff --quiet; then
        log_warn "Working directory has uncommitted changes"
        return 1
    fi
}
```

## Version Generation

```bash
generate_version() {
    local base_version="${1:-1.0.0}"
    local commit=$(git rev-parse --short HEAD)
    local timestamp=$(date +%Y%m%d%H%M%S)

    if [[ "${GIT_BRANCH}" == "main" ]]; then
        echo "${base_version}"
    else
        echo "${base_version}-${GIT_BRANCH}.${commit}.${timestamp}"
    fi
}

# Semantic version bump
bump_version() {
    local version="$1"
    local type="${2:-patch}"  # major, minor, patch

    IFS='.' read -r major minor patch <<< "$version"

    case "$type" in
        major)
            echo "$((major + 1)).0.0"
            ;;
        minor)
            echo "${major}.$((minor + 1)).0"
            ;;
        patch)
            echo "${major}.${minor}.$((patch + 1))"
            ;;
    esac
}
```

## Build Artifacts

```bash
create_build_info() {
    local status="$1"
    local duration="$2"

    cat > "$BUILD_DIR/build-info.json" <<EOF
{
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "commit": "$GIT_COMMIT",
  "branch": "$GIT_BRANCH",
  "tag": "${GIT_TAG:-none}",
  "nodeVersion": "$(node --version)",
  "npmVersion": "$(npm --version)",
  "status": "$status",
  "buildDuration": $duration,
  "buildNumber": "${BUILD_NUMBER:-0}",
  "environment": "${NODE_ENV:-development}"
}
EOF
}

# Create artifacts archive
create_artifact() {
    local version="$1"
    local archive="artifacts-${version}.tar.gz"

    tar -czf "$archive" \
        -C "$BUILD_DIR" \
        --exclude="*.log" \
        .

    echo "$archive"
}
```

## Step Execution

```bash
run_step() {
    local step_name="$1"
    shift
    local step_command=("$@")

    log "Running: $step_name"

    if "${step_command[@]}"; then
        log_success "$step_name completed"
        return 0
    else
        log_failure "$step_name failed"
        return 1
    fi
}

# Usage
run_step "Install dependencies" npm ci
run_step "Run tests" npm test
run_step "Build" npm run build
```

## Caching

```bash
# Check if dependencies need update
dependencies_changed() {
    local lock_file="package-lock.json"
    local cache_file=".npm-cache-hash"

    if [[ ! -f "$cache_file" ]]; then
        return 0  # No cache
    fi

    local current_hash=$(sha256sum "$lock_file" | cut -d' ' -f1)
    local cached_hash=$(cat "$cache_file")

    [[ "$current_hash" != "$cached_hash" ]]
}

# Update cache
update_dependencies_cache() {
    sha256sum package-lock.json | cut -d' ' -f1 > .npm-cache-hash
}

# Usage
if dependencies_changed; then
    log "Installing dependencies..."
    npm ci
    update_dependencies_cache
else
    log "Using cached dependencies"
fi
```

## Timing

```bash
# Start timer
start_time=$(date +%s)

# End timer and calculate duration
end_time=$(date +%s)
duration=$((end_time - start_time))

log "Build completed in ${duration}s"

# Formatted duration
format_duration() {
    local seconds=$1
    local minutes=$((seconds / 60))
    local remaining=$((seconds % 60))

    if (( minutes > 0 )); then
        echo "${minutes}m ${remaining}s"
    else
        echo "${seconds}s"
    fi
}
```

## Complete Build Script Template

```bash
#!/usr/bin/env bash
set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

# Configuration
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly BUILD_DIR="${SCRIPT_DIR}/dist"
START_TIME=$(date +%s)

# Logging
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*" >&2
}

log_success() {
    echo -e "${GREEN}✓${NC} $*"
}

log_failure() {
    echo -e "${RED}✗${NC} $*" >&2
}

# Cleanup
cleanup() {
    local exit_code=$?
    local end_time=$(date +%s)
    local duration=$((end_time - START_TIME))

    if (( exit_code == 0 )); then
        log_success "Build completed in ${duration}s"
        create_build_info "success" "$duration"
    else
        log_failure "Build failed after ${duration}s"
        create_build_info "failure" "$duration"
    fi
}
trap cleanup EXIT

# Validate environment
validate_environment() {
    : "${NODE_ENV:?NODE_ENV is required}"

    for cmd in node npm git; do
        command -v "$cmd" &>/dev/null || {
            log_failure "$cmd is not installed"
            exit 1
        }
    done
}

# Get git info
get_git_info() {
    GIT_COMMIT=$(git rev-parse HEAD)
    GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
}

# Create build info
create_build_info() {
    local status="$1"
    local duration="$2"

    mkdir -p "$BUILD_DIR"

    cat > "$BUILD_DIR/build-info.json" <<EOF
{
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "commit": "$GIT_COMMIT",
  "branch": "$GIT_BRANCH",
  "nodeVersion": "$(node --version)",
  "status": "$status",
  "buildDuration": $duration
}
EOF
}

# Main
main() {
    log "Starting build..."
    validate_environment
    get_git_info

    log "Environment: $NODE_ENV"
    log "Branch: $GIT_BRANCH"
    log "Commit: $GIT_COMMIT"

    log "Cleaning..."
    rm -rf "$BUILD_DIR"

    log "Installing dependencies..."
    npm ci

    log "Running linter..."
    npm run lint
    log_success "Lint passed"

    log "Running tests..."
    npm test
    log_success "Tests passed"

    log "Building..."
    npm run build
    log_success "Build completed"
}

main "$@"
```

## CI Integration Patterns

**GitHub Actions usage:**

```bash
#!/usr/bin/env bash
set -euo pipefail

# CI environment detection
if [[ "${CI:-false}" == "true" ]]; then
    log "Running in CI environment"

    # GitHub Actions specific
    if [[ -n "${GITHUB_ACTIONS:-}" ]]; then
        log "GitHub Actions detected"
        GIT_COMMIT="${GITHUB_SHA}"
        GIT_BRANCH="${GITHUB_REF_NAME}"
    fi
fi

# Output for GitHub Actions
github_output() {
    local key="$1"
    local value="$2"
    echo "${key}=${value}" >> "${GITHUB_OUTPUT:-/dev/null}"
}

# Set GitHub Actions outputs
github_output "version" "$VERSION"
github_output "artifact" "$ARTIFACT_PATH"
```

## Best Practices

1. **Always use safe options:**

   ```bash
   set -euo pipefail
   ```

2. **Validate environment:**

   ```bash
   : "${VAR:?VAR is required}"
   ```

3. **Log everything:**

   ```bash
   log "Step: $step_name"
   ```

4. **Cleanup on exit:**

   ```bash
   trap cleanup EXIT
   ```

5. **Generate build artifacts:**

   ```bash
   create_build_info "success" "$duration"
   ```

6. **Time operations:**

   ```bash
   start=$(date +%s)
   # operation
   duration=$(($(date +%s) - start))
   ```

7. **Cache when possible:**

   ```bash
   if dependencies_changed; then npm ci; fi
   ```

8. **Make scripts idempotent:**
   - Can be run multiple times safely
   - Clean previous state before building
