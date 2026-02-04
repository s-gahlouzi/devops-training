#!/usr/bin/env bash
set -euo pipefail

# Check if filename provided
if [[ $# -eq 0 ]]; then
    echo "Usage: $0 <filename>" >&2
    exit 1
fi

filename="$1"

# Check if file exists
if [[ ! -f "$filename" ]]; then
    echo "Error: File not found: $filename" >&2
    exit 1
fi

# Read file line by line
line_num=1
while IFS= read -r line; do
    echo "Line $line_num: $line"
    ((line_num++))
done < "$filename"
