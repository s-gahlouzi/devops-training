#!/usr/bin/env bash
set -euo pipefail

# Check if NODE_ENV is set
if [[ -z "${NODE_ENV:-}" ]]; then
    echo "Error: NODE_ENV is not set" >&2
    exit 1
fi

# Validate NODE_ENV value
if [[ "$NODE_ENV" == "development" || "$NODE_ENV" == "staging" || "$NODE_ENV" == "production" ]]; then
    echo "✓ Valid environment: $NODE_ENV"
    exit 0
else
    echo "✗ Invalid environment: $NODE_ENV. Must be development, staging, or production" >&2
    exit 1
fi
