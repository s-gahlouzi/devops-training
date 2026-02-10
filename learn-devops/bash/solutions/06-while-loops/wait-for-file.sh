#!/usr/bin/env bash
set -euo pipefail

# Check if filename provided
if [[ $# -eq 0 ]]; then
    echo "Usage: $0 <filename>" >&2
    exit 1
fi

filename="$1"
max_attempts=5
attempts=0

# Wait until file exists or timeout
until [[ -f "$filename" ]] || (( attempts >= max_attempts )); do
    echo "Waiting for $filename..."
    sleep 2
    ((attempts++))
done

# Check result
if [[ -f "$filename" ]]; then
    echo "File $filename appeared!"
    exit 0
else
    echo "Timeout: File $filename did not appear after ${max_attempts} attempts" >&2
    exit 1
fi
