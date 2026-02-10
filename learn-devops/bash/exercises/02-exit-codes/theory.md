# Theory: Exit Codes

## Exit Code Basics

Every command returns an exit code:

- `0` = Success
- `1-255` = Failure

## Capturing Exit Codes

```bash
command
exit_code=$?
echo "Exit code: $exit_code"
```

## Conditional Execution

```bash
# Run if previous command succeeded
command1 && command2

# Run if previous command failed
command1 || command2

# Check explicitly
if command; then
    echo "Success"
else
    echo "Failed"
fi
```

## Script Exit Codes

```bash
exit 0    # Success
exit 1    # Generic failure
exit 2    # Misuse of shell command
```

## Testing Commands

```bash
# Silent success/failure check
if curl -f -s -o /dev/null https://example.com; then
    echo "URL reachable"
fi
```

## Arguments

```bash
$1        # First argument
$2        # Second argument
$@        # All arguments as separate words
$#        # Number of arguments
```

## Useful curl Flags

- `-f` - Fail silently on HTTP errors
- `-s` - Silent mode (no progress)
- `-o /dev/null` - Discard output
- `--connect-timeout` - Timeout in seconds
