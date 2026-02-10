# Theory: Functions

## Function Definition

```bash
# Method 1 (preferred)
function_name() {
    # code
}

# Method 2
function function_name {
    # code
}
```

## Arguments

```bash
my_function() {
    local arg1="$1"      # First argument
    local arg2="$2"      # Second argument
    local all_args="$@"  # All arguments
    local count="$#"     # Argument count

    echo "Processing: $arg1, $arg2"
}

# Call
my_function "value1" "value2"
```

## Local Variables

```bash
my_function() {
    local var="value"    # Local to function
    global="value"       # Global (avoid)
}
```

## Return Values

**Return codes** (0-255):

```bash
is_valid() {
    [[ "$1" -gt 0 ]] && return 0
    return 1
}

if is_valid 5; then
    echo "Valid"
fi
```

**Output** (any string):

```bash
get_name() {
    echo "result"
}

result=$(get_name)
echo "$result"
```

## Function Best Practices

1. Use local variables
2. Quote all variables
3. Return 0 for success, 1 for failure
4. Use echo/printf for string output
5. Validate arguments
6. Add error messages to stderr

## Common Patterns

**Required arguments:**

```bash
do_something() {
    local file="${1:?File argument required}"
    # use $file
}
```

**Default values:**

```bash
greet() {
    local name="${1:-World}"
    echo "Hello, $name"
}
```

**Multiple returns:**

```bash
parse_version() {
    local version="$1"
    local major minor patch
    IFS='.' read -r major minor patch <<< "$version"
    echo "$major"
    echo "$minor"
    echo "$patch"
}

# Use
read -r major minor patch < <(parse_version "1.2.3")
```

## Sourcing Files

```bash
# Load functions from another file
source utils.sh
# or
. utils.sh

# Check if already sourced
[[ -n "${UTILS_LOADED:-}" ]] && return
UTILS_LOADED=1
```

## Timestamps

```bash
date +%Y-%m-%d           # 2026-02-04
date +%H:%M:%S           # 10:30:45
date +"%Y-%m-%d %H:%M:%S"  # 2026-02-04 10:30:45
```
