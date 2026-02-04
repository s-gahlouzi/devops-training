# Exercise 19: Traps and Cleanup

## Goal

Implement proper cleanup handlers using trap for reliable scripts.

## Requirements

Create `download-and-process.sh` that:

1. Creates a temporary directory
2. Downloads data into temp directory (simulate with echo)
3. Processes the data
4. Uses trap to cleanup temp directory on EXIT
5. Handles interruption (Ctrl+C) gracefully
6. Prints cleanup message

Create `deploy-with-rollback.sh` that:

1. Starts deployment
2. Sets trap to rollback on failure (ERR signal)
3. Performs deployment steps
4. If any step fails, trap triggers rollback
5. Cleanup runs regardless of success/failure

Create `lock-script.sh` that:

1. Creates a lock file to prevent concurrent runs
2. Uses trap to remove lock file
3. Checks if lock exists before running
4. Handles signals: INT, TERM, EXIT

Create `test-signals.sh` that:

1. Sets up handlers for multiple signals
2. Demonstrates different trap behaviors
3. Shows trap inheritance in subshells

## Expected Behavior

```bash
./download-and-process.sh
Created temp directory: /tmp/tmp.abc123
Downloading data...
Processing data...
Cleanup: Removing /tmp/tmp.abc123
Done!

# On Ctrl+C:
^C
Interrupted! Cleaning up...
Cleanup: Removing /tmp/tmp.abc123

./deploy-with-rollback.sh
Starting deployment...
Step 1: OK
Step 2: OK
Step 3: FAILED
Rolling back deployment...
Cleanup complete.
Exit code: 1

./lock-script.sh
Acquired lock
Running main process...
Released lock

# Second instance while first running:
./lock-script.sh
Error: Another instance is running
Exit code: 1
```

## Success Criteria

- Trap executes on EXIT
- Handles interruption (INT, TERM)
- Multiple traps can coexist
- Cleanup always runs
- Lock files work correctly
- Error traps work
