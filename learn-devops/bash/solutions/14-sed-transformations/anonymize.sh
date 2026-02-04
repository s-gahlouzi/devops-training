#!/usr/bin/env bash
set -euo pipefail

# Check if file provided
if [[ $# -eq 0 ]]; then
    echo "Usage: $0 <logfile>" >&2
    exit 1
fi

logfile="$1"

# Anonymize data
sed -e 's/\[[^]]*\]/[REDACTED]/' \
    -e 's/User: [a-z]*/User: ***/' \
    "$logfile"
