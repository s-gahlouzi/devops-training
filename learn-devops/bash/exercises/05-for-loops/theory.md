# Theory: For Loops

## Basic For Loop

```bash
# Iterate over list
for item in one two three; do
    echo "$item"
done

# Iterate over array
arr=(apple banana cherry)
for fruit in "${arr[@]}"; do
    echo "$fruit"
done
```

## File Iteration

```bash
# Glob pattern
for file in *.txt; do
    [[ -f "$file" ]] || continue  # Skip if no match
    echo "Processing: $file"
done

# Multiple patterns
for file in *.{txt,md,log}; do
    [[ -f "$file" ]] || continue
    echo "$file"
done
```

## C-style For Loop

```bash
for ((i=0; i<10; i++)); do
    echo "$i"
done

# With step
for ((i=0; i<100; i+=10)); do
    echo "$i"
done
```

## Command Output Iteration

```bash
# Array from command (preferred)
mapfile -t files < <(find . -name "*.txt")
for file in "${files[@]}"; do
    echo "$file"
done

# Direct iteration (simple cases)
for line in $(cat file.txt); do
    echo "$line"
done
```

## Common Patterns

**Count files:**

```bash
count=0
for file in *.txt; do
    [[ -f "$file" ]] || continue
    ((count++))
done
echo "Found $count files"
```

**Check if glob matches:**

```bash
for file in *.txt; do
    [[ -f "$file" ]] || {
        echo "No .txt files found"
        break
    }
    # Process file
done
```

## Best Practices

1. Always quote variables: `"$var"`
2. Check file existence in glob loops
3. Use `"${arr[@]}"` for arrays
4. Prefer `mapfile` for command output
5. Use `((i++))` for arithmetic
