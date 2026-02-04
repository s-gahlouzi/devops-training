#!/usr/bin/env bash
set -euo pipefail

# Create temp directory
TMPDIR=$(mktemp -d)

# Cleanup function
cleanup() {
    if [[ -d "$TMPDIR" ]]; then
        echo "Cleanup: Removing $TMPDIR"
        rm -rf "$TMPDIR"
    fi
}

# Handle interruption
handle_interrupt() {
    echo
    echo "Interrupted! Cleaning up..."
    cleanup
    exit 130
}

# Set traps
trap cleanup EXIT
trap handle_interrupt INT TERM

echo "Created temp directory: $TMPDIR"

# Simulate download
echo "Downloading data..."
echo "data" > "$TMPDIR/data.txt"
sleep 1

# Process data
echo "Processing data..."
cat "$TMPDIR/data.txt" > /dev/null
sleep 1

echo "Done!"
