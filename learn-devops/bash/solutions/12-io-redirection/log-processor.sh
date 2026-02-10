#!/usr/bin/env bash
set -euo pipefail

# Input from file or stdin
input="${1:-/dev/stdin}"

# Initialize counters
error_count=0
info_count=0
other_count=0

# Clear output files
> errors.log
> info.log
> other.log

# Process input
while IFS= read -r line; do
    if [[ "$line" =~ ^ERROR: ]]; then
        echo "$line" >> errors.log
        ((error_count++))
    elif [[ "$line" =~ ^INFO: ]]; then
        echo "$line" >> info.log
        ((info_count++))
    else
        echo "$line" >> other.log
        ((other_count++))
    fi
done < "$input"

# Print summary to stderr
echo "Summary: $info_count info, $error_count errors, $other_count other" >&2

# Exit code based on errors
if (( error_count > 0 )); then
    exit 1
else
    exit 0
fi
