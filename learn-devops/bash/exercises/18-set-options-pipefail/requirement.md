# Exercise 18: Set Options and Pipefail

## Goal

Understand bash set options for safe scripting in CI/CD.

## Requirements

Create `unsafe-script.sh` without set options:

```bash
#!/usr/bin/env bash

echo "Starting..."
UNDEFINED_VAR="test: $UNDEFINED"
false | true
echo "This runs even after pipe failure"
curl https://invalid-url-that-fails.com | jq '.data'
echo "Done!"
```

Create `safe-script.sh` with proper set options:

```bash
#!/usr/bin/env bash
set -euo pipefail

echo "Starting..."
# ... rest of script
```

Create `test-set-options.sh` that demonstrates each option:

1. `set -e` demo: Show script exits on first error
2. `set -u` demo: Show script exits on undefined variable
3. `set -o pipefail` demo: Show pipeline failure detection
4. `set -x` demo: Show command tracing
5. Combining all options

Create `safe-pipeline.sh`:

1. Uses `set -euo pipefail`
2. Runs a pipeline: `cat data.txt | grep "ERROR" | wc -l`
3. Handles the case where grep finds nothing (exits 1)
4. Uses `|| true` pattern where appropriate

## Expected Behavior

```bash
# Unsafe script continues despite errors
./unsafe-script.sh
Starting...
test:
This runs even after pipe failure
(curl error but script continues)
Done!
Exit code: 0

# Safe script stops at first error
./safe-script.sh
Starting...
safe-script.sh: line 5: UNDEFINED: unbound variable
Exit code: 1

# Test set options
./test-set-options.sh
=== Without set -e ===
Error occurred
Script continues...

=== With set -e ===
Error occurred
(script exits)

=== Without set -u ===
Value:
(empty, no error)

=== With set -u ===
script: line X: VAR: unbound variable

=== Without pipefail ===
false | true
Exit code: 0

=== With pipefail ===
false | true
Exit code: 1
```

## Success Criteria

- Understands each set option
- Knows when to use `|| true`
- Handles pipeline failures
- Can disable options temporarily
- Writes safe CI/CD scripts
