# Theory: Variables and Quoting

## Variable Declaration

```bash
var="value"              # No spaces around =
readonly VAR="constant"  # Read-only variable
```

## Command Substitution

```bash
result=$(command)        # Modern syntax (preferred)
result=`command`         # Legacy syntax (avoid)
```

## Quoting Types

**Single quotes** - Literal, no expansion:

```bash
echo '$var'    # Outputs: $var
```

**Double quotes** - Variables and commands expand:

```bash
echo "$var"    # Outputs: value of var
```

**No quotes** - Word splitting occurs:

```bash
var="one two"
echo $var      # Two separate arguments
echo "$var"    # One argument
```

## Best Practices

1. Always quote variables: `"$var"`
2. Use `${var}` for clarity
3. Use command substitution with `$()`
4. Never put spaces around `=` in assignments

## Useful Commands

```bash
date +%Y-%m-%d           # Current date
echo "text"              # Print text
printf "%s\n" "text"     # Formatted print
```
