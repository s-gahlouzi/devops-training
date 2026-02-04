#!/usr/bin/env bash

echo "=== Without set -e ==="
(
    false
    echo "Script continues..."
)
echo

echo "=== With set -e ==="
(
    set -e
    false
    echo "Never reached"
) || echo "Script exited"
echo

echo "=== Without set -u ==="
(
    echo "Value: $UNDEFINED_VAR"
)
echo

echo "=== With set -u ==="
(
    set -u
    echo "Value: $UNDEFINED_VAR"
) 2>&1 || echo "Script exited with unbound variable"
echo

echo "=== Without pipefail ==="
(
    false | true
    echo "Exit code: $?"
)
echo

echo "=== With pipefail ==="
(
    set -o pipefail
    false | true
    echo "Never reached"
) || echo "Pipeline failed (exit code: $?)"
