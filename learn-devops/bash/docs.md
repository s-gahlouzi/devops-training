# Bash for DevOps & CI/CD

## What, When & Why

**What**: Bash is a Unix shell and command language used for automation, scripting, and system administration.

**When**: Use Bash for CI/CD pipeline scripts, deployment automation, Docker entrypoints, pre-commit hooks, build processes, and system administration tasks.

**Why**:

- Universal availability on Unix/Linux systems
- Direct system access and process control
- Fast execution for automation tasks
- Native integration with CI/CD platforms

## Core Concepts

### 1. Exit Codes & Pipeline Behavior

- Every command returns 0 (success) or 1-255 (failure)
- `$?` captures last exit code
- Pipelines return exit code of last command by default
- `set -e`: Exit on any error
- `set -u`: Exit on undefined variables
- `set -o pipefail`: Pipeline fails if any command fails
- **Always use `set -euo pipefail` in CI/CD scripts**

### 2. Quoting Rules

- `"double quotes"`: Variables expand, command substitution happens
- `'single quotes'`: Everything literal, no expansion
- `$'ANSI'`: ANSI-C quoting for escape sequences
- Unquoted: Word splitting and globbing occur
- **Always quote variables: `"$var"` not `$var`**

### 3. Variable Expansion

```bash
${var}              # Basic
${var:-default}     # Use default if unset/empty
${var:=default}     # Assign default if unset/empty
${var:?error}       # Error if unset/empty
${var:+alt}         # Use alt if set
${#var}             # Length
${var#pattern}      # Remove shortest prefix
${var##pattern}     # Remove longest prefix
${var%pattern}      # Remove shortest suffix
${var%%pattern}     # Remove longest suffix
${var/pattern/str}  # Replace first match
${var//pattern/str} # Replace all matches
${var^^}            # Uppercase
${var,,}            # Lowercase
```

### 4. Conditionals

```bash
[[ ]]               # Modern test command (preferred)
[ ]                 # POSIX test (legacy)
(( ))               # Arithmetic evaluation

# String tests
[[ -z "$str" ]]     # Empty string
[[ -n "$str" ]]     # Non-empty string
[[ "$a" == "$b" ]]  # Equality
[[ "$a" =~ regex ]] # Regex match

# File tests
[[ -f "$file" ]]    # Regular file exists
[[ -d "$dir" ]]     # Directory exists
[[ -x "$cmd" ]]     # Executable
[[ -r "$file" ]]    # Readable
[[ -w "$file" ]]    # Writable

# Numeric tests
(( a > b ))
(( a >= b ))
(( a == b ))
```

### 5. Functions

```bash
function_name() {
    local var="$1"          # Local variable, first argument
    readonly CONST="value"  # Read-only
    echo "result"           # Output (captured via $())
    return 0                # Exit code only (0-255)
}

# Call
result=$(function_name "arg")
```

### 6. Arrays

```bash
# Indexed arrays
arr=(one two three)
arr[3]="four"
echo "${arr[0]}"        # First element
echo "${arr[@]}"        # All elements
echo "${#arr[@]}"       # Length
echo "${!arr[@]}"       # Indices

# Associative arrays
declare -A map
map[key]="value"
echo "${map[key]}"
echo "${!map[@]}"       # Keys
```

### 7. Loops

```bash
# For loop
for item in "${array[@]}"; do
    echo "$item"
done

for ((i=0; i<10; i++)); do
    echo "$i"
done

# While loop
while IFS= read -r line; do
    echo "$line"
done < file.txt

# Until loop
until [[ -f "$file" ]]; do
    sleep 1
done
```

### 8. Redirection & Pipes

```bash
cmd > file          # Redirect stdout (overwrite)
cmd >> file         # Redirect stdout (append)
cmd 2> file         # Redirect stderr
cmd &> file         # Redirect both stdout and stderr
cmd 2>&1            # Redirect stderr to stdout
cmd1 | cmd2         # Pipe stdout
cmd < file          # Redirect stdin

# Here-document
cat <<EOF
multi-line
text
EOF

# Here-string
grep pattern <<<"$variable"

# Process substitution
diff <(cmd1) <(cmd2)
```

### 9. Command Substitution

```bash
result=$(command)       # Modern (preferred)
result=`command`        # Legacy (avoid)
```

### 10. Traps & Cleanup

```bash
cleanup() {
    echo "Cleaning up..."
    rm -f /tmp/tempfile
}
trap cleanup EXIT       # Always run on exit
trap cleanup INT TERM   # Run on interrupt/terminate
```

## Text Processing Tools

### grep - Search patterns

```bash
grep "pattern" file
grep -r "pattern" dir/      # Recursive
grep -i "pattern" file      # Case-insensitive
grep -v "pattern" file      # Invert match
grep -E "regex" file        # Extended regex
grep -o "pattern" file      # Only matching part
```

### sed - Stream editor

```bash
sed 's/old/new/' file       # Replace first occurrence
sed 's/old/new/g' file      # Replace all
sed -i 's/old/new/g' file   # In-place edit
sed -n '10,20p' file        # Print lines 10-20
sed '/pattern/d' file       # Delete matching lines
```

### awk - Text processing

```bash
awk '{print $1}' file       # First column
awk -F: '{print $1}' file   # Custom delimiter
awk '$3 > 100' file         # Filter by condition
awk '{sum+=$1} END {print sum}' file  # Sum column
```

### cut - Extract columns

```bash
cut -d: -f1 file            # First field, : delimiter
cut -c1-10 file             # Characters 1-10
```

### jq - JSON processor

```bash
jq '.key' file.json         # Extract key
jq -r '.key' file.json      # Raw output (no quotes)
jq '.[] | .name' file.json  # Array iteration
jq 'select(.key == "val")' file.json  # Filter
```

### yq - YAML processor

```bash
yq '.key' file.yaml
yq -i '.key = "value"' file.yaml  # In-place edit
```

## CI/CD Critical Patterns

### 1. Safe Script Header

```bash
#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'
```

### 2. Environment Variables

```bash
# Check required vars
: "${VAR:?VAR is required}"

# With defaults
PORT="${PORT:-8080}"

# Load from .env
set -a
source .env
set +a
```

### 3. Error Handling

```bash
if ! command; then
    echo "Command failed" >&2
    exit 1
fi

# Or with explicit check
command || {
    echo "Command failed" >&2
    exit 1
}
```

### 4. Logging

```bash
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*" >&2
}

log "Starting deployment"
```

### 5. Input Validation

```bash
validate_input() {
    local input="$1"
    [[ "$input" =~ ^[a-zA-Z0-9_-]+$ ]] || {
        echo "Invalid input: $input" >&2
        return 1
    }
}
```

### 6. Timeouts

```bash
timeout 30s command || {
    echo "Command timed out" >&2
    exit 1
}
```

### 7. Parallel Execution

```bash
command1 &
command2 &
wait  # Wait for all background jobs

# Or with error checking
pids=()
command1 & pids+=($!)
command2 & pids+=($!)

for pid in "${pids[@]}"; do
    wait "$pid" || exit 1
done
```

## Common Pitfalls

### 1. Unquoted Variables

```bash
# BAD
rm -rf $dir/*

# GOOD
rm -rf "${dir:?}/"*
```

### 2. Ignoring Errors

```bash
# BAD
curl https://api.example.com/data
process_data

# GOOD
if ! curl -f https://api.example.com/data; then
    echo "Failed to fetch data" >&2
    exit 1
fi
process_data
```

### 3. Word Splitting

```bash
# BAD
for file in $(ls *.txt); do
    echo "$file"
done

# GOOD
for file in *.txt; do
    [[ -f "$file" ]] || continue
    echo "$file"
done
```

### 4. Pipeline Errors Hidden

```bash
# BAD
cat file | process | output

# GOOD
set -o pipefail
cat file | process | output
```

### 5. Subshell Variable Assignment

```bash
# BAD (variable not set in parent)
echo "data" | while read line; do
    result="$line"
done
echo "$result"  # Empty

# GOOD
while read line; do
    result="$line"
done < <(echo "data")
echo "$result"  # Contains "data"
```

## Security Best Practices

1. **Never echo secrets**: Use `printf` or write to files with restricted permissions
2. **Validate all inputs**: Sanitize user input and environment variables
3. **Use specific paths**: Avoid relying on PATH for critical commands
4. **Set proper permissions**: `chmod 600` for sensitive files
5. **Avoid eval**: Use arrays and proper quoting instead
6. **Check command existence**: `command -v cmd` before use
7. **Use shellcheck**: Static analysis for common issues

## Performance Tips

1. Use built-in commands over external programs when possible
2. Minimize subshells and pipes
3. Use `read` instead of `cat | while`
4. Avoid repeated calls in loops
5. Use `xargs` for bulk operations
6. Cache expensive operations

## Key APIs/Commands for CI/CD

- `curl` - HTTP requests, API calls
- `git` - Version control operations
- `docker` - Container operations
- `jq/yq` - Parse JSON/YAML configs
- `date` - Timestamps, version tags
- `tar/zip` - Archive artifacts
- `sha256sum` - Checksums, integrity
- `envsubst` - Template variable substitution
- `mktemp` - Temporary files/directories

## Debugging

```bash
# Enable trace
set -x              # Print commands as executed
PS4='+ ${BASH_SOURCE}:${LINENO}: '  # Better trace format

# Debug specific sections
set -x
  # code to debug
set +x

# Check syntax
bash -n script.sh

# Run shellcheck
shellcheck script.sh
```
