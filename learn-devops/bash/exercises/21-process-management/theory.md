# Theory: Process Management

## Background Jobs

Run commands in background:

```bash
# Start background job
command &

# Get PID
command &
pid=$!

# Multiple background jobs
command1 &
command2 &
command3 &
```

## Process ID Variables

```bash
$!      # PID of last background job
$$      # PID of current shell
$PPID   # PID of parent process
```

## Wait for Processes

```bash
# Wait for all background jobs
wait

# Wait for specific PID
command &
pid=$!
wait $pid

# Capture exit code
command &
pid=$!
wait $pid
exit_code=$?
echo "Process exited with: $exit_code"

# Wait for multiple
pid1=$!
command2 &
pid2=$!
wait $pid1 $pid2
```

## Parallel Execution

```bash
#!/usr/bin/env bash
set -euo pipefail

# Start jobs in parallel
pids=()

command1 &
pids+=($!)

command2 &
pids+=($!)

command3 &
pids+=($!)

# Wait for all
for pid in "${pids[@]}"; do
    wait "$pid" || {
        echo "Process $pid failed" >&2
        exit 1
    }
done

echo "All processes completed"
```

## Timeout Implementation

```bash
timeout_command() {
    local timeout=$1
    shift
    local command=("$@")

    # Start command in background
    "${command[@]}" &
    local pid=$!

    # Wait with timeout
    local count=0
    while kill -0 $pid 2>/dev/null; do
        if (( count >= timeout )); then
            echo "Timeout reached, killing process" >&2
            kill $pid 2>/dev/null || true
            return 124  # Standard timeout exit code
        fi
        sleep 1
        ((count++))
    done

    # Get exit code
    wait $pid
    return $?
}

# Usage
if timeout_command 5 sleep 10; then
    echo "Completed"
else
    echo "Failed or timed out"
fi
```

## Check if Process is Running

```bash
pid=1234

# Check if running
if kill -0 $pid 2>/dev/null; then
    echo "Process is running"
else
    echo "Process is not running"
fi
```

## Kill Processes

```bash
pid=1234

# Graceful termination
kill $pid           # SIGTERM (15)
kill -TERM $pid

# Force kill
kill -9 $pid        # SIGKILL
kill -KILL $pid

# Interrupt
kill -INT $pid      # SIGINT (Ctrl+C)
```

## Process Groups

```bash
# Start process group
(
    command1 &
    command2 &
    command3 &
    wait
)

# Kill entire group
kill -TERM -$$  # Negative PID kills group
```

## Worker Pool Pattern

```bash
#!/usr/bin/env bash

max_workers=3
current_workers=0
pids=()

worker() {
    local item=$1
    echo "Processing: $item"
    sleep 2  # Simulate work
    echo "Done: $item"
}

# Items to process
items=(item1 item2 item3 item4 item5 item6 item7 item8)

for item in "${items[@]}"; do
    # Wait if at max capacity
    while (( current_workers >= max_workers )); do
        # Check for completed workers
        for i in "${!pids[@]}"; do
            pid=${pids[$i]}
            if ! kill -0 $pid 2>/dev/null; then
                wait $pid
                unset 'pids[$i]'
                ((current_workers--))
            fi
        done
        sleep 0.1
    done

    # Start new worker
    worker "$item" &
    pids+=($!)
    ((current_workers++))
done

# Wait for remaining workers
for pid in "${pids[@]}"; do
    wait "$pid"
done

echo "All work completed"
```

## Health Check Pattern

```bash
#!/usr/bin/env bash
set -euo pipefail

SERVICE_PID=""

cleanup() {
    if [[ -n "$SERVICE_PID" ]]; then
        echo "Stopping service (PID: $SERVICE_PID)..."
        kill $SERVICE_PID 2>/dev/null || true
        wait $SERVICE_PID 2>/dev/null || true
    fi
}

trap cleanup EXIT INT TERM

# Start service
python -m http.server 8000 &
SERVICE_PID=$!

echo "Waiting for service to be healthy..."

# Health check with timeout
max_attempts=30
attempt=0

while (( attempt < max_attempts )); do
    if curl -sf http://localhost:8000 >/dev/null; then
        echo "Service is healthy!"
        break
    fi

    # Check if process died
    if ! kill -0 $SERVICE_PID 2>/dev/null; then
        echo "Service died!" >&2
        exit 1
    fi

    ((attempt++))
    sleep 1
done

if (( attempt >= max_attempts )); then
    echo "Health check timeout!" >&2
    exit 1
fi

echo "Service is running and healthy"
```

## Job Control

```bash
# List jobs
jobs

# Bring job to foreground
fg %1

# Send job to background
bg %1

# Kill job
kill %1

# In scripts, disable job control
set +m
```

## Subshells

```bash
# Commands in () run in subshell
(
    cd /tmp
    echo "In subshell: $(pwd)"
)
echo "In parent: $(pwd)"

# Background subshell group
{
    command1
    command2
} &
```

## Named Pipes (FIFOs)

```bash
# Create named pipe
mkfifo /tmp/mypipe

# Writer
echo "data" > /tmp/mypipe &

# Reader
cat < /tmp/mypipe

# Cleanup
rm /tmp/mypipe
```

## Process Substitution

```bash
# Compare outputs
diff <(command1) <(command2)

# Multiple inputs
paste <(seq 1 5) <(seq 6 10)

# Process in parallel
while IFS= read -r line; do
    echo "Processing: $line"
done < <(find . -name "*.txt")
```

## Real-World Examples

**Parallel API calls:**

```bash
#!/usr/bin/env bash
set -euo pipefail

urls=(
    "https://api1.example.com"
    "https://api2.example.com"
    "https://api3.example.com"
)

pids=()
results=()

for url in "${urls[@]}"; do
    {
        curl -sf "$url" -o "/tmp/result-$$-$url"
        echo "$?" > "/tmp/exit-$$-$url"
    } &
    pids+=($!)
done

# Wait and check results
failed=0
for i in "${!pids[@]}"; do
    pid=${pids[$i]}
    url=${urls[$i]}

    wait "$pid"
    exit_code=$(cat "/tmp/exit-$$-$url")

    if (( exit_code == 0 )); then
        echo "✓ $url"
    else
        echo "✗ $url" >&2
        ((failed++))
    fi

    rm -f "/tmp/result-$$-$url" "/tmp/exit-$$-$url"
done

exit $failed
```

**Build matrix in parallel:**

```bash
#!/usr/bin/env bash

versions=("18" "20" "22")
max_parallel=2

pids=()
for version in "${versions[@]}"; do
    # Wait if at capacity
    while (( ${#pids[@]} >= max_parallel )); do
        for i in "${!pids[@]}"; do
            if ! kill -0 ${pids[$i]} 2>/dev/null; then
                wait ${pids[$i]}
                unset 'pids[$i]'
                pids=("${pids[@]}")  # Re-index
            fi
        done
        sleep 0.5
    done

    # Start build
    {
        echo "Building with Node $version..."
        docker build --build-arg NODE_VERSION=$version -t app:$version .
        echo "Node $version: done"
    } &
    pids+=($!)
done

# Wait for all
for pid in "${pids[@]}"; do
    wait "$pid"
done

echo "All builds complete"
```

**Retry with exponential backoff:**

```bash
retry_with_backoff() {
    local max_attempts=5
    local attempt=1
    local delay=1

    while (( attempt <= max_attempts )); do
        if "$@"; then
            return 0
        fi

        if (( attempt < max_attempts )); then
            echo "Attempt $attempt failed, retrying in ${delay}s..." >&2
            sleep $delay
            ((delay *= 2))
        fi

        ((attempt++))
    done

    echo "Failed after $max_attempts attempts" >&2
    return 1
}

retry_with_backoff curl -f https://api.example.com
```

**Service orchestration:**

```bash
#!/usr/bin/env bash
set -euo pipefail

PIDS=()

cleanup() {
    echo "Stopping all services..."
    for pid in "${PIDS[@]}"; do
        kill $pid 2>/dev/null || true
    done
    wait 2>/dev/null || true
}

trap cleanup EXIT INT TERM

# Start services
python -m http.server 8000 &
PIDS+=($!)

python -m http.server 8001 &
PIDS+=($!)

echo "Services started: ${PIDS[*]}"

# Wait for health
for port in 8000 8001; do
    while ! curl -sf http://localhost:$port >/dev/null; do
        sleep 1
    done
    echo "Port $port is ready"
done

echo "All services healthy, press Ctrl+C to stop"
wait
```

## Best Practices

1. **Always capture PID:**

   ```bash
   command &
   pid=$!
   ```

2. **Wait and check exit codes:**

   ```bash
   wait $pid || handle_error
   ```

3. **Cleanup background processes:**

   ```bash
   trap 'kill $pid 2>/dev/null' EXIT
   ```

4. **Limit parallelism:**

   ```bash
   # Use worker pool pattern
   ```

5. **Check if process exists:**

   ```bash
   kill -0 $pid 2>/dev/null
   ```

6. **Use timeout for long operations:**

   ```bash
   timeout 30s command || handle_timeout
   ```

7. **Handle process failure:**

   ```bash
   pids=()
   command1 & pids+=($!)
   command2 & pids+=($!)

   for pid in "${pids[@]}"; do
       wait $pid || exit 1
   done
   ```
