#!/usr/bin/env bash
set -euo pipefail

# Define array of services
services=(api web worker cache database)

# Print total
echo "Total services: ${#services[@]}"

# First and last
echo "First service: ${services[0]}"
echo "Last service: ${services[-1]}"

# Add metrics
services+=("metrics")
echo "After adding metrics: ${#services[@]} services"

# Remove cache (filter array)
new_services=()
for service in "${services[@]}"; do
    [[ "$service" != "cache" ]] && new_services+=("$service")
done
services=("${new_services[@]}")
echo "After removing cache: ${#services[@]} services"

# Iterate with indices
echo "Services:"
for i in "${!services[@]}"; do
    echo "  [$i] ${services[$i]}"
done

# Check if service exists
check_service() {
    local search="$1"
    for service in "${services[@]}"; do
        [[ "$service" == "$search" ]] && return 0
    done
    return 1
}

if check_service "web"; then
    echo "Service 'web' exists: yes"
else
    echo "Service 'web' exists: no"
fi

if check_service "redis"; then
    echo "Service 'redis' exists: yes"
else
    echo "Service 'redis' exists: no"
fi
