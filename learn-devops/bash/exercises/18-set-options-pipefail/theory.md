# Theory: Set Options and Pipefail

## Safe Script Header

```bash
#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'
```

## set -e (errexit)

Exit immediately if any command fails:

```bash
set -e

false           # Script exits here
echo "Never reached"
```

**When it doesn't work:**

- Commands in if conditions
- Commands in `&&` or `||`
- Commands in pipelines (except last)

```bash
set -e

# These DON'T cause exit:
if false; then echo "ok"; fi
false || echo "handled"
false && echo "never"

# This DOES cause exit:
false
echo "never reached"
```

## set -u (nounset)

Exit if using undefined variables:

```bash
set -u

echo "$UNDEFINED"    # Error: UNDEFINED: unbound variable
```

**Check if variable is set:**

```bash
set -u

# Safe ways
echo "${VAR:-default}"      # Use default if unset
echo "${VAR:=default}"      # Assign default if unset
: "${VAR:?VAR required}"    # Error with message if unset

# Check before use
if [[ -n "${VAR:-}" ]]; then
    echo "$VAR"
fi
```

## set -o pipefail

Pipelines fail if any command fails (not just last):

```bash
# Without pipefail
false | true
echo $?              # 0 (success, from 'true')

# With pipefail
set -o pipefail
false | true
echo $?              # 1 (failure, from 'false')
```

**Real example:**

```bash
set -o pipefail

# This will fail if curl fails
curl https://api.example.com | jq '.data'

# Without pipefail, only jq exit code matters
# With pipefail, curl failure causes pipeline to fail
```

## set -x (xtrace)

Print commands before executing (debugging):

```bash
set -x

name="test"
echo "Hello, $name"

# Output:
# + name=test
# + echo 'Hello, test'
# Hello, test
```

**Custom trace format:**

```bash
PS4='+ ${BASH_SOURCE}:${LINENO}: '
set -x
```

## IFS (Internal Field Separator)

Control word splitting:

```bash
# Default: space, tab, newline
IFS=$' \t\n'

# Safer for most scripts: newline and tab only
IFS=$'\n\t'

# Restore default
IFS=$' \t\n'
```

## Disable Options Temporarily

```bash
set -e

# Disable temporarily
set +e
command_that_might_fail
exit_code=$?
set -e

# Or use subshell
(set +e; command_that_might_fail)

# Or handle explicitly
command_that_might_fail || true
```

## Handling Expected Failures

```bash
set -e

# Allow failure
grep "pattern" file || true

# Capture exit code
if grep "pattern" file; then
    echo "Found"
else
    echo "Not found"
fi

# Store result
result=$(command) || true
```

## Pipeline Patterns

```bash
set -euo pipefail

# Pipeline with possible failure
if curl -f https://api.example.com | jq '.data'; then
    echo "Success"
else
    echo "Failed"
    exit 1
fi

# Allow grep to fail
cat file | grep "pattern" || true

# Better: avoid UUOC
grep "pattern" file || true

# Or check if found
if grep -q "pattern" file; then
    echo "Found"
fi
```

## Real-World Examples

**Safe CI/CD script:**

```bash
#!/usr/bin/env bash
set -euo pipefail

: "${ENVIRONMENT:?ENVIRONMENT required}"
: "${VERSION:?VERSION required}"

echo "Deploying version $VERSION to $ENVIRONMENT"

if ! curl -f https://api.example.com/health; then
    echo "API health check failed" >&2
    exit 1
fi

echo "Deployment successful"
```

**With error handling:**

```bash
#!/usr/bin/env bash
set -euo pipefail

deploy() {
    local env="$1"
    echo "Deploying to $env..."

    # Command that might fail
    if ! kubectl apply -f deployment.yml; then
        echo "Deployment failed" >&2
        return 1
    fi

    echo "Deployment successful"
}

if deploy "production"; then
    echo "Success"
else
    echo "Failed"
    exit 1
fi
```

**Pipeline with cleanup:**

```bash
#!/usr/bin/env bash
set -euo pipefail

cleanup() {
    rm -f /tmp/data
}
trap cleanup EXIT

curl https://api.example.com/data | \
    jq '.items[]' | \
    while IFS= read -r item; do
        echo "Processing: $item"
    done
```

## Common Patterns

**Retry logic:**

```bash
set -euo pipefail

retry() {
    local max_attempts=3
    local attempt=1

    until "$@"; do
        if (( attempt >= max_attempts )); then
            echo "Failed after $max_attempts attempts" >&2
            return 1
        fi
        echo "Attempt $attempt failed, retrying..." >&2
        ((attempt++))
        sleep 2
    done
}

retry curl -f https://api.example.com
```

**Optional command:**

```bash
set -euo pipefail

# Run if command exists
if command -v docker &>/dev/null; then
    docker --version
fi

# Or with || true
command -v docker &>/dev/null && docker --version || true
```

## Debug Mode

```bash
# Enable debug for entire script
#!/usr/bin/env bash
set -x

# Or for specific section
set -x
  # debug this
set +x

# With custom format
PS4='+ ${BASH_SOURCE}:${LINENO}:${FUNCNAME[0]}: '
set -x
```

## Checking Current Options

```bash
# Check if option is set
if [[ $- == *e* ]]; then
    echo "errexit is on"
fi

# Show all options
echo "$-"

# Check specific option
shopt -p
set -o
```

## When NOT to Use

**set -e not suitable for:**

- Interactive scripts
- Scripts that need custom error handling
- Scripts using complex conditionals

**set -u not suitable for:**

- Scripts relying on optional variables
- Scripts sourcing user configs

## Best Practices

1. **Always use in CI/CD scripts:**

   ```bash
   set -euo pipefail
   ```

2. **Check required variables:**

   ```bash
   : "${VAR:?VAR is required}"
   ```

3. **Handle expected failures:**

   ```bash
   command || true
   ```

4. **Use explicit error handling:**

   ```bash
   if ! command; then
       echo "Failed" >&2
       exit 1
   fi
   ```

5. **Debug with set -x:**

   ```bash
   PS4='+ ${BASH_SOURCE}:${LINENO}: '
   set -x
   ```

6. **Document when disabling:**
   ```bash
   # Disable errexit for this command as failure is expected
   set +e
   optional_command
   set -e
   ```
