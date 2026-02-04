#!/usr/bin/env bash
set -euo pipefail

# Define array of services
services=(api web worker cache)

# Iterate over array
for service in "${services[@]}"; do
    echo "Checking service: $service"
done
