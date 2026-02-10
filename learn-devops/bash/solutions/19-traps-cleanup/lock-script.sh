#!/usr/bin/env bash
set -euo pipefail

LOCKFILE="/tmp/lock-script.lock"

# Cleanup function
cleanup() {
    if [[ -f "$LOCKFILE" ]]; then
        rm -f "$LOCKFILE"
        echo "Released lock"
    fi
}

trap cleanup EXIT INT TERM

# Check if lock exists
if [[ -f "$LOCKFILE" ]]; then
    echo "Error: Another instance is running" >&2
    exit 1
fi

# Create lock
echo $$ > "$LOCKFILE"
echo "Acquired lock"

# Simulate work
echo "Running main process..."
sleep 5

echo "Process complete"
