#!/usr/bin/env bash
set -euo pipefail

# Declare associative array
declare -A ports=(
    [api]=3000
    [web]=8080
    [database]=5432
    [cache]=6379
)

# Functions
get_port() {
    local service="$1"
    echo "${ports[$service]}"
}

set_port() {
    local service="$1"
    local port="$2"
    ports[$service]=$port
}

list_services() {
    for service in "${!ports[@]}"; do
        echo "  $service: ${ports[$service]}"
    done
}

has_service() {
    local service="$1"
    [[ -v ports[$service] ]]
}

# Test
echo "Services:"
list_services
echo

echo "Port for 'api': $(get_port "api")"

set_port "web" 3001
echo "Updated 'web' port to 3001"

if has_service "metrics"; then
    echo "Service 'metrics' exists: yes"
else
    echo "Service 'metrics' exists: no"
fi

set_port "metrics" 9090
echo "Added service 'metrics' on port 9090"
echo

echo "All services:"
list_services
