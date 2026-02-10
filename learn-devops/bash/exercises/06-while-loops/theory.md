# Theory: While and Until Loops

## While Loop

```bash
# Basic while
while [[ condition ]]; do
    # code
done

# Counter example
counter=0
while (( counter < 10 )); do
    echo "$counter"
    ((counter++))
done
```

## Reading Files

```bash
# Read line by line (preserving whitespace)
while IFS= read -r line; do
    echo "$line"
done < file.txt

# With line numbers
line_num=1
while IFS= read -r line; do
    echo "Line $line_num: $line"
    ((line_num++))
done < file.txt
```

## Until Loop

Opposite of while - runs until condition becomes true:

```bash
until [[ condition ]]; do
    # code
done

# Wait for file
until [[ -f "$file" ]]; do
    echo "Waiting..."
    sleep 1
done
```

## With Timeout

```bash
attempts=0
max_attempts=5

until [[ -f "$file" ]] || (( attempts >= max_attempts )); do
    echo "Waiting... ($attempts/$max_attempts)"
    sleep 2
    ((attempts++))
done

if [[ -f "$file" ]]; then
    echo "File found!"
else
    echo "Timeout!"
    exit 1
fi
```

## Reading Command Output

```bash
# Process command output line by line
command | while IFS= read -r line; do
    echo "Processing: $line"
done

# Better: avoid subshell
while IFS= read -r line; do
    echo "Processing: $line"
done < <(command)
```

## Break and Continue

```bash
while true; do
    read -r input
    [[ "$input" == "quit" ]] && break
    [[ -z "$input" ]] && continue
    echo "Processing: $input"
done
```

## Best Practices

1. Use `IFS= read -r` to preserve whitespace
2. Redirect from file with `< file` not `cat file |`
3. Add timeout to prevent infinite loops
4. Use `until` for "wait for condition" patterns
5. Avoid variable assignment in pipe subshells
