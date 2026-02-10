# Theory: Conditionals (if/else)

## if/else Syntax

```bash
if [[ condition ]]; then
    # code
elif [[ condition ]]; then
    # code
else
    # code
fi
```

## Test Operators [[]]

**String tests:**

```bash
[[ -z "$var" ]]          # Empty string
[[ -n "$var" ]]          # Non-empty string
[[ "$a" == "$b" ]]       # Equality
[[ "$a" != "$b" ]]       # Inequality
[[ "$a" =~ regex ]]      # Regex match
```

**File tests:**

```bash
[[ -f "$file" ]]         # File exists
[[ -d "$dir" ]]          # Directory exists
[[ -e "$path" ]]         # Path exists (file or dir)
[[ -x "$file" ]]         # Executable
```

**Logical operators:**

```bash
[[ condition1 && condition2 ]]    # AND
[[ condition1 || condition2 ]]    # OR
[[ ! condition ]]                 # NOT
```

## Environment Variables

```bash
# Check if set
[[ -n "${VAR:-}" ]]

# Check if set and not empty
[[ -n "$VAR" ]]

# Require variable
: "${VAR:?Error: VAR is required}"
```

## String Comparison

```bash
# Exact match
if [[ "$var" == "value" ]]; then
    echo "Match"
fi

# Multiple values
if [[ "$var" == "val1" || "$var" == "val2" ]]; then
    echo "Match"
fi
```

## Best Practices

1. Use `[[ ]]` not `[ ]` (modern Bash)
2. Always quote variables: `"$var"`
3. Use `-n` to check non-empty
4. Use `-z` to check empty
