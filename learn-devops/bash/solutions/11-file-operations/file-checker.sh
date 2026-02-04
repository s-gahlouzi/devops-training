#!/usr/bin/env bash
set -euo pipefail

# Check if path argument provided
if [[ $# -eq 0 ]]; then
    echo "Usage: $0 <path>" >&2
    exit 1
fi

path="$1"

# Check if path exists
if [[ ! -e "$path" ]]; then
    echo "Path does not exist: $path" >&2
    exit 1
fi

echo "Path exists: yes"

# Determine type
if [[ -f "$path" ]]; then
    echo "Type: file"
    
    # Check permissions
    echo "Readable: $([[ -r "$path" ]] && echo "yes" || echo "no")"
    echo "Writable: $([[ -w "$path" ]] && echo "yes" || echo "no")"
    echo "Executable: $([[ -x "$path" ]] && echo "yes" || echo "no")"
    
    # File size
    if [[ -s "$path" ]]; then
        size=$(wc -c < "$path")
        echo "Size: $size bytes"
    else
        echo "Size: 0 bytes"
    fi
    
    # Last modified (Linux)
    if command -v stat >/dev/null 2>&1; then
        if stat -c%y "$path" >/dev/null 2>&1; then
            modified=$(stat -c%y "$path")
        else
            modified=$(stat -f%Sm "$path")
        fi
        echo "Last modified: $modified"
    fi
    
    # Create backup
    backup="${path}.backup"
    cp "$path" "$backup"
    echo "Backup created: $backup"
    
elif [[ -d "$path" ]]; then
    echo "Type: directory"
    
    # Count files
    file_count=$(find "$path" -maxdepth 1 -type f | wc -l)
    echo "Files inside: $file_count"
    
    # List .txt files
    txt_files=()
    while IFS= read -r file; do
        txt_files+=("$(basename "$file")")
    done < <(find "$path" -maxdepth 1 -name "*.txt" -type f)
    
    if (( ${#txt_files[@]} > 0 )); then
        echo "Text files: ${txt_files[*]}"
    fi
    
    # Create backup directory
    backup="${path}.backup"
    cp -r "$path" "$backup"
    echo "Backup created: $backup/"
fi
