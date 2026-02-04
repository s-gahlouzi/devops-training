# Exercise 02: Exit Codes

## Goal

Create a script that properly handles exit codes and command success/failure.

## Requirements

Create `check-status.sh` that:

1. Takes a URL as first argument
2. Uses `curl` to check if URL is reachable (use `-f` flag for fail on error)
3. Captures the exit code with `$?`
4. Prints success or failure message based on exit code
5. Exits with appropriate code (0 for success, 1 for failure)

## Expected Behavior

```bash
./check-status.sh https://github.com
# Output: ✓ URL is reachable
# Exit code: 0

./check-status.sh https://invalid-url-that-does-not-exist.com
# Output: ✗ URL is not reachable
# Exit code: 1
```

## Success Criteria

- Script checks if argument is provided
- Captures curl exit code correctly
- Returns proper exit code
- Prints clear status messages
