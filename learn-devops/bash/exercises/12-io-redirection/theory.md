# Theory: Input/Output Redirection

## Standard Streams

- `0` = stdin (input)
- `1` = stdout (output)
- `2` = stderr (errors)

## Output Redirection

```bash
command > file          # Stdout to file (overwrite)
command >> file         # Stdout to file (append)
command 2> file         # Stderr to file
command &> file         # Both stdout and stderr
command > out.log 2> err.log  # Separate files
command 2>&1            # Stderr to stdout
command &> /dev/null    # Discard all output
```

## Input Redirection

```bash
command < file          # File as stdin
command <<< "string"    # String as stdin (here-string)
```

## Pipes

```bash
command1 | command2     # Stdout of cmd1 to stdin of cmd2
command1 |& command2    # Both stdout and stderr
```

## Here-Documents

```bash
# Basic here-doc
cat <<EOF
line 1
line 2
EOF

# With variables expanded
cat <<EOF
Hello, $USER
Date: $(date)
EOF

# Literal (no expansion)
cat <<'EOF'
$VAR will not expand
EOF

# Indented here-doc
cat <<-EOF
	This works
	With tabs
EOF
```

## Here-Strings

```bash
# Pass string as stdin
grep "pattern" <<< "$variable"

# Multi-line variable
while IFS= read -r line; do
    echo "$line"
done <<< "$multi_line_var"
```

## Process Substitution

```bash
# Compare outputs of two commands
diff <(command1) <(command2)

# Read from command
while IFS= read -r line; do
    echo "$line"
done < <(find . -name "*.txt")

# Multiple inputs
paste <(ls dir1) <(ls dir2)
```

## Reading Input

```bash
# Read from file or stdin
input="${1:-/dev/stdin}"
while IFS= read -r line; do
    echo "$line"
done < "$input"

# Test if stdin has data
if [[ -p /dev/stdin ]]; then
    echo "Reading from pipe"
else
    echo "No pipe input"
fi
```

## Write to Multiple Files

```bash
# Using tee
command | tee file1.log file2.log

# Manually
while IFS= read -r line; do
    echo "$line" >> file1.log
    echo "$line" >> file2.log
done < input.txt
```

## Stderr Handling

```bash
# Print to stderr
echo "Error message" >&2

# Function that uses stderr
error() {
    echo "ERROR: $*" >&2
}

# Redirect stderr to stdout
command 2>&1 | grep "pattern"
```

## Real-World Examples

**Log everything:**

```bash
exec > >(tee -a script.log)
exec 2>&1
# Now all output goes to both terminal and log
```

**Separate errors:**

```bash
{
    command1
    command2
} 2> errors.log 1> output.log
```

**Generate config file:**

```bash
cat > config.yml <<EOF
app:
  name: ${APP_NAME}
  port: ${PORT}
  env: ${ENV}
EOF
```

**Process substitution for temp data:**

```bash
# No temp file needed
while IFS= read -r line; do
    process "$line"
done < <(curl -s https://api.example.com/data)
```

## Best Practices

1. Use `>&2` for error messages
2. Use `< file` instead of `cat file |`
3. Use process substitution to avoid temp files
4. Quote here-doc delimiter for literal content: `<<'EOF'`
5. Check if stdin is available before reading
6. Close file descriptors when done: `exec 3>&-`
