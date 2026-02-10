#!/usr/bin/env bash
set -euo pipefail

# Check if URL argument is provided
if [[ $# -eq 0 ]]; then
    echo "Usage: $0 <url>" >&2
    exit 1
fi

url="$1"

# Check if URL is reachable with curl
if curl -f -s -o /dev/null --connect-timeout 5 "$url"; then
    echo "✓ URL is reachable"
    exit 0
else
    echo "✗ URL is not reachable" >&2
    exit 1
fi
