# Theory: Case Statements

## Syntax

```bash
case "$var" in
    pattern1)
        # code
        ;;
    pattern2|pattern3)
        # code
        ;;
    *)
        # default case
        ;;
esac
```

## Pattern Matching

```bash
case "$input" in
    start)
        echo "Starting..."
        ;;
    stop|halt)
        echo "Stopping..."
        ;;
    status)
        echo "Status check..."
        ;;
    *)
        echo "Unknown command"
        exit 1
        ;;
esac
```

## Glob Patterns

```bash
case "$file" in
    *.txt)
        echo "Text file"
        ;;
    *.md)
        echo "Markdown file"
        ;;
    [0-9]*)
        echo "Starts with number"
        ;;
    *)
        echo "Other file"
        ;;
esac
```

## When to Use Case vs If

**Use case when:**

- Matching a variable against multiple values
- Pattern matching needed
- More than 2-3 conditions

**Use if when:**

- Complex conditions with &&, ||
- Numeric comparisons
- Testing multiple different variables

## Best Practices

1. Always include `*)` default case
2. End each case with `;;`
3. Quote variables: `"$var"`
4. Use `|` for multiple patterns
5. Exit with proper code in default case
