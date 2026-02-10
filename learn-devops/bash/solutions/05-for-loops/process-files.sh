#!/usr/bin/env bash
set -euo pipefail

# Iterate over all .txt files
for file in *.txt; do
    # Check if file exists (handles case when no .txt files exist)
    [[ -f "$file" ]] || {
        echo "No .txt files found"
        break
    }
    
    echo "Processing: $file"
    
    # Count lines
    line_count=$(wc -l < "$file")
    echo "Lines: $line_count"
    echo
done
