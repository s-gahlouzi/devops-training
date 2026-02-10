# Theory: Traps and Cleanup

## Basic Trap Syntax

```bash
trap 'commands' SIGNAL

# Examples
trap 'echo Exiting' EXIT
trap 'echo Interrupted' INT
trap 'rm -f /tmp/tempfile' EXIT
```

## Common Signals

```bash
EXIT    # Script exit (normal or error)
INT     # Interrupt (Ctrl+C)
TERM    # Termination signal
ERR     # Command fails (with set -E)
DEBUG   # Before each command
RETURN  # Function returns
```

## EXIT Trap

Runs when script exits (success or failure):

```bash
#!/usr/bin/env bash

cleanup() {
    echo "Cleaning up..."
    rm -f /tmp/tempfile
}
trap cleanup EXIT

echo "Creating temp file..."
echo "data" > /tmp/tempfile
echo "Done"
# cleanup() runs automatically
```

## INT/TERM Traps

Handle interruption and termination:

```bash
#!/usr/bin/env bash

cleanup() {
    echo "Interrupted! Cleaning up..." >&2
    rm -f /tmp/tempfile
    exit 130  # Standard exit code for SIGINT
}

trap cleanup INT TERM

echo "Running (press Ctrl+C to interrupt)..."
sleep 60
echo "Completed"
```

## Multiple Signals

```bash
trap 'cleanup' EXIT
trap 'handle_interrupt' INT TERM
trap 'handle_error' ERR

# Or combine
trap 'cleanup' EXIT INT TERM
```

## Trap with Functions

```bash
cleanup() {
    local exit_code=$?
    echo "Exit code: $exit_code"

    # Cleanup logic
    [[ -d "$TMPDIR" ]] && rm -rf "$TMPDIR"
    [[ -f "$LOCKFILE" ]] && rm -f "$LOCKFILE"

    echo "Cleanup complete"
}

trap cleanup EXIT
```

## ERR Trap

Runs when command fails (requires `set -E`):

```bash
#!/usr/bin/env bash
set -eE  # -E needed for ERR trap

handle_error() {
    local line=$1
    echo "Error on line $line" >&2
    # Rollback or cleanup
}

trap 'handle_error $LINENO' ERR

echo "Step 1"
false  # Triggers ERR trap
echo "Never reached"
```

## Temporary Files/Directories

```bash
#!/usr/bin/env bash

# Create temp directory
TMPDIR=$(mktemp -d)
trap "rm -rf '$TMPDIR'" EXIT

echo "Working in: $TMPDIR"
# Use TMPDIR
echo "data" > "$TMPDIR/file.txt"

# Cleanup happens automatically
```

## Lock Files

```bash
#!/usr/bin/env bash

LOCKFILE="/tmp/script.lock"

acquire_lock() {
    if [[ -f "$LOCKFILE" ]]; then
        echo "Another instance is running" >&2
        exit 1
    fi
    echo $$ > "$LOCKFILE"
    trap "rm -f '$LOCKFILE'" EXIT
}

acquire_lock
echo "Running..."
sleep 5
echo "Done"
```

## Rollback Pattern

```bash
#!/usr/bin/env bash
set -eE

DEPLOYED=false

rollback() {
    if [[ "$DEPLOYED" == "true" ]]; then
        echo "Rolling back..." >&2
        # Rollback commands
        kubectl rollout undo deployment/app
    fi
}

trap rollback ERR

echo "Deploying..."
kubectl apply -f deployment.yml
DEPLOYED=true

echo "Running smoke tests..."
curl -f https://app.example.com/health

echo "Deployment successful"
```

## Nested Traps

```bash
outer() {
    trap 'echo "Outer cleanup"' EXIT

    inner() {
        trap 'echo "Inner cleanup"' EXIT
        echo "In inner"
    }

    inner
    echo "Back in outer"
}

outer
# Output:
# In inner
# Inner cleanup
# Back in outer
# Outer cleanup
```

## Remove Trap

```bash
# Remove specific trap
trap - EXIT

# Remove multiple
trap - INT TERM EXIT
```

## Preserve Exit Code

```bash
cleanup() {
    local exit_code=$?
    echo "Cleaning up..."
    rm -f /tmp/tempfile
    return $exit_code  # Preserve original exit code
}

trap cleanup EXIT
```

## Real-World Examples

**Safe temp directory:**

```bash
#!/usr/bin/env bash
set -euo pipefail

TMPDIR=$(mktemp -d)
trap "rm -rf '$TMPDIR'" EXIT

cd "$TMPDIR"
# Work with files
curl https://example.com/data > data.txt
process data.txt

# Cleanup happens automatically, even on error
```

**Database migration with rollback:**

```bash
#!/usr/bin/env bash
set -eE

MIGRATED=false

rollback() {
    if [[ "$MIGRATED" == "true" ]]; then
        echo "Migration failed, rolling back..." >&2
        psql -c "SELECT rollback_migration();"
    fi
}

trap rollback ERR

echo "Running migration..."
psql -f migration.sql
MIGRATED=true

echo "Verifying..."
psql -c "SELECT verify_migration();"

echo "Migration successful"
```

**API with cleanup:**

```bash
#!/usr/bin/env bash
set -euo pipefail

SERVER_PID=""

cleanup() {
    if [[ -n "$SERVER_PID" ]]; then
        echo "Stopping server (PID: $SERVER_PID)..."
        kill "$SERVER_PID" 2>/dev/null || true
        wait "$SERVER_PID" 2>/dev/null || true
    fi
}

trap cleanup EXIT INT TERM

echo "Starting test server..."
python -m http.server 8000 &
SERVER_PID=$!

echo "Running tests..."
sleep 2
curl http://localhost:8000

echo "Tests complete"
# Server stopped automatically
```

**Progress tracking:**

```bash
#!/usr/bin/env bash

STATUS_FILE="/tmp/deploy.status"

update_status() {
    echo "$1" > "$STATUS_FILE"
}

cleanup() {
    local exit_code=$?
    if (( exit_code == 0 )); then
        update_status "SUCCESS"
    else
        update_status "FAILED"
    fi
    echo "Final status: $(cat "$STATUS_FILE")"
}

trap cleanup EXIT

update_status "IN_PROGRESS"
echo "Deploying..."
sleep 2
echo "Done"
```

**Concurrent execution guard:**

```bash
#!/usr/bin/env bash

LOCKFILE="/var/run/myscript.lock"
LOCKFD=200

acquire_lock() {
    eval "exec $LOCKFD>$LOCKFILE"

    if ! flock -n $LOCKFD; then
        echo "Another instance is running" >&2
        exit 1
    fi

    trap "rm -f '$LOCKFILE'" EXIT
}

acquire_lock
echo "Running exclusively..."
sleep 5
```

**CI/CD artifact cleanup:**

```bash
#!/usr/bin/env bash
set -euo pipefail

ARTIFACT_DIR="/tmp/build-$$"

cleanup() {
    echo "Cleaning up artifacts..."
    rm -rf "$ARTIFACT_DIR"

    # Also cleanup remote if uploaded
    if [[ "${UPLOADED:-false}" == "true" ]]; then
        echo "Cleaning remote artifacts..."
        aws s3 rm "s3://bucket/temp-$$/`` --recursive
    fi
}

trap cleanup EXIT

mkdir -p "$ARTIFACT_DIR"
echo "Building..."
npm run build --output="$ARTIFACT_DIR"

echo "Uploading..."
aws s3 sync "$ARTIFACT_DIR" "s3://bucket/temp-$$/"
UPLOADED=true
```

## Trap in Functions

```bash
deploy() {
    local temp=$(mktemp -d)

    # Local cleanup
    cleanup() {
        rm -rf "$temp"
    }
    trap cleanup RETURN  # Runs when function returns

    echo "Using temp: $temp"
    # Work with temp directory
}

deploy
# cleanup runs when function returns
```

## Debug Traps

```bash
#!/usr/bin/env bash

# Run before each command
trap 'echo "Executing: $BASH_COMMAND"' DEBUG

echo "Hello"
ls /tmp
echo "Done"

# Output:
# Executing: echo "Hello"
# Hello
# Executing: ls /tmp
# (ls output)
# Executing: echo "Done"
# Done
```

## Best Practices

1. **Always cleanup temp files:**

   ```bash
   trap "rm -rf '$TMPDIR'" EXIT
   ```

2. **Handle interruption:**

   ```bash
   trap cleanup INT TERM EXIT
   ```

3. **Preserve exit codes:**

   ```bash
   cleanup() {
       local exit_code=$?
       # cleanup
       return $exit_code
   }
   ```

4. **Use for rollback:**

   ```bash
   trap rollback ERR
   ```

5. **Quote trap commands:**

   ```bash
   trap 'rm -f "$FILE"' EXIT  # Good
   trap "rm -f $FILE" EXIT    # Bad: $FILE expanded immediately
   ```

6. **Lock files for exclusivity:**

   ```bash
   trap "rm -f '$LOCKFILE'" EXIT
   ```

7. **Test your traps:**
   - Normal exit
   - Error exit
   - Ctrl+C interruption
   - SIGTERM
