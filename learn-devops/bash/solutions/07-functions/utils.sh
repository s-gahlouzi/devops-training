#!/usr/bin/env bash

# Timestamped logging function
log() {
    local message="$1"
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $message"
}

# Validate port number
validate_port() {
    local port="$1"
    
    # Check if it's a number and in valid range
    if [[ "$port" =~ ^[0-9]+$ ]] && (( port >= 1 && port <= 65535 )); then
        return 0
    else
        echo "Error: Invalid port: $port" >&2
        return 1
    fi
}

# Extract file extension
get_file_extension() {
    local filename="$1"
    
    # Check if filename has an extension
    if [[ "$filename" == *.* ]]; then
        echo "${filename##*.}"
        return 0
    else
        return 1
    fi
}
