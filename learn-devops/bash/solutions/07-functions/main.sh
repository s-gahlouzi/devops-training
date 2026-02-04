#!/usr/bin/env bash
set -euo pipefail

# Source utilities
source "$(dirname "$0")/utils.sh"

log "Starting script"

# Test validate_port with valid port
if validate_port 8080; then
    log "Port is valid"
fi

# Test validate_port with invalid port
if validate_port 70000; then
    log "Port is valid"
else
    log "Port is invalid"
fi

# Test get_file_extension
if ext=$(get_file_extension "test.txt"); then
    log "Extension: $ext"
else
    log "No extension found"
fi
