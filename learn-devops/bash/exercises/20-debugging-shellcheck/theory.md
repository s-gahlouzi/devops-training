# Theory: Debugging and Shellcheck

## Debugging with set -x

Enable command tracing:

```bash
#!/usr/bin/env bash
set -x

name="test"
echo "Hello, $name"

# Output:
# + name=test
# + echo 'Hello, test'
# Hello, test
```

## Custom PS4 (Trace Prompt)

Better trace output:

```bash
# Default PS4
PS4='+ '

# With line numbers
PS4='+ ${LINENO}: '

# With filename and line
PS4='+ ${BASH_SOURCE}:${LINENO}: '

# With function name
PS4='+ ${BASH_SOURCE}:${LINENO}:${FUNCNAME[0]}: '

# Timestamp
PS4='+ $(date +%H:%M:%S) ${BASH_SOURCE}:${LINENO}: '
```

**Example:**

```bash
#!/usr/bin/env bash
PS4='+ ${BASH_SOURCE}:${LINENO}:${FUNCNAME[0]}: '
set -x

greet() {
    echo "Hello, $1"
}

greet "World"

# Output:
# + script.sh:8:main: greet World
# + script.sh:5:greet: echo 'Hello, World'
# Hello, World
```

## Selective Debugging

Debug specific sections:

```bash
#!/usr/bin/env bash

echo "Normal operation"

# Enable debug
set -x
  problematic_function
  complex_operation
set +x

echo "Back to normal"
```

## Debug Functions

```bash
debug() {
    [[ "${DEBUG:-0}" == "1" ]] && echo "DEBUG: $*" >&2
}

# Usage
debug "Variable value: $var"
debug "Entering function: ${FUNCNAME[1]}"

# Enable with:
DEBUG=1 ./script.sh
```

## Trap DEBUG

Execute before every command:

```bash
#!/usr/bin/env bash

trap 'echo "Executing: $BASH_COMMAND"' DEBUG

name="test"
echo "Hello, $name"

# Output:
# Executing: name="test"
# Executing: echo "Hello, $name"
# Hello, test
```

## Logging

```bash
#!/usr/bin/env bash

LOGFILE="/tmp/script.log"

log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOGFILE" >&2
}

log "Starting script"
log "Processing files..."
log "Completed"
```

## Syntax Check

```bash
# Check syntax without running
bash -n script.sh

# If no output, syntax is valid
```

## Shellcheck

Static analysis tool for bash scripts.

### Installation

```bash
# Ubuntu/Debian
apt-get install shellcheck

# macOS
brew install shellcheck

# Or download binary
# https://github.com/koalaman/shellcheck
```

### Usage

```bash
# Check single file
shellcheck script.sh

# Check multiple files
shellcheck *.sh

# Specific format
shellcheck -f json script.sh

# Ignore specific warnings
shellcheck -e SC2086 script.sh

# Severity levels
shellcheck -S error script.sh    # Only errors
shellcheck -S warning script.sh  # Warnings and errors
```

### Common Warnings

**SC2086: Quote variables**

```bash
# Bad
rm -rf $dir/*

# Good
rm -rf "${dir:?}/"*
```

**SC2045: Don't parse ls**

```bash
# Bad
for file in $(ls *.txt); do
    echo "$file"
done

# Good
for file in *.txt; do
    [[ -f "$file" ]] || continue
    echo "$file"
done
```

**SC2002: Useless cat**

```bash
# Bad
cat file | grep pattern

# Good
grep pattern file
# or
grep pattern < file
```

**SC2086: Unquoted variable**

```bash
# Bad
if [ $var == "value" ]; then

# Good
if [[ "$var" == "value" ]]; then
```

**SC2164: cd without error check**

```bash
# Bad
cd "$dir"
rm -rf *

# Good
cd "$dir" || exit 1
rm -rf *
```

**SC2046: Quote command substitution**

```bash
# Bad
rm $(find . -name "*.tmp")

# Good
find . -name "*.tmp" -delete
# or
while IFS= read -r file; do
    rm "$file"
done < <(find . -name "*.tmp")
```

### Disable Specific Checks

**In-line:**

```bash
# shellcheck disable=SC2086
rm -rf $dir

# Multiple
# shellcheck disable=SC2086,SC2162
```

**File-wide:**

```bash
#!/usr/bin/env bash
# shellcheck disable=SC2086
```

### Shellcheck Directives

```bash
# Specify shell
# shellcheck shell=bash

# Source directive for shellcheck
# shellcheck source=./utils.sh
source ./utils.sh

# External sources
# shellcheck source=/dev/null
source unknown-file.sh
```

## Common Debugging Patterns

**Print all variables:**

```bash
set | grep ^MY_VAR
```

**Trace function calls:**

```bash
PS4='+ $(date +%H:%M:%S) ${FUNCNAME[0]}: '
set -x
```

**Check if function exists:**

```bash
if declare -f function_name >/dev/null; then
    echo "Function exists"
fi
```

**Check if command exists:**

```bash
if command -v docker >/dev/null 2>&1; then
    echo "Docker installed"
fi
```

## Real-World Debugging

**Debug CI/CD script:**

```bash
#!/usr/bin/env bash

# Enable debug if DEBUG env var is set
[[ "${DEBUG:-0}" == "1" ]] && set -x

# Better trace output
PS4='+ ${BASH_SOURCE}:${LINENO}:${FUNCNAME[0]}: '

# Log everything to file
exec 1> >(tee -a build.log)
exec 2>&1

echo "Starting build..."
# rest of script
```

**Conditional debugging:**

```bash
#!/usr/bin/env bash

debug_log() {
    if [[ "${DEBUG:-0}" == "1" ]]; then
        echo "[DEBUG] $*" >&2
    fi
}

debug_log "Variable value: $var"
debug_log "Function called with: $*"
```

**Error context:**

```bash
#!/usr/bin/env bash
set -eE

error_handler() {
    local line=$1
    local cmd=$2
    echo "Error on line $line: $cmd" >&2
    echo "Stack trace:" >&2

    local frame=0
    while caller $frame >&2; do
        ((frame++))
    done

    exit 1
}

trap 'error_handler $LINENO "$BASH_COMMAND"' ERR
```

## Performance Profiling

```bash
#!/usr/bin/env bash

# Time each command
PS4='+ $(date +%s%N | cut -b1-13) ${BASH_SOURCE}:${LINENO}: '
set -x

# Or measure specific sections
start=$(date +%s%N)
expensive_operation
end=$(date +%s%N)
duration=$(( (end - start) / 1000000 ))
echo "Operation took ${duration}ms"
```

## Testing Scripts

**Run with different interpreters:**

```bash
bash script.sh
sh script.sh
dash script.sh
```

**Test with different options:**

```bash
bash -x script.sh      # Debug
bash -n script.sh      # Syntax check
bash -v script.sh      # Print script as read
bash -u script.sh      # Treat unset vars as error
```

## Best Practices

1. **Always use shellcheck:**

   ```bash
   shellcheck *.sh
   ```

2. **Custom PS4 for better traces:**

   ```bash
   PS4='+ ${BASH_SOURCE}:${LINENO}:${FUNCNAME[0]}: '
   ```

3. **Selective debugging:**

   ```bash
   set -x; problematic_code; set +x
   ```

4. **Log to file:**

   ```bash
   exec 1> >(tee script.log)
   exec 2>&1
   ```

5. **Debug mode:**

   ```bash
   [[ "${DEBUG:-0}" == "1" ]] && set -x
   ```

6. **Syntax check before commit:**

   ```bash
   bash -n script.sh && shellcheck script.sh
   ```

7. **Use debug functions:**
   ```bash
   debug() {
       [[ "${DEBUG:-}" == "1" ]] && echo "DEBUG: $*" >&2
   }
   ```

## CI/CD Integration

**Pre-commit hook:**

```bash
#!/usr/bin/env bash

for file in $(git diff --cached --name-only --diff-filter=ACM | grep '\.sh$'); do
    if ! shellcheck "$file"; then
        echo "Shellcheck failed for $file" >&2
        exit 1
    fi
done
```

**GitHub Actions:**

```yaml
- name: Run shellcheck
  uses: ludeeus/action-shellcheck@master
  with:
    severity: warning
```

**GitLab CI:**

```yaml
shellcheck:
  image: koalaman/shellcheck-alpine
  script:
    - shellcheck **/*.sh
```
