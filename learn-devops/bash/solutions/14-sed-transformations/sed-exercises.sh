#!/usr/bin/env bash
set -euo pipefail

INPUT="config.template"
OUTPUT="config.env"

# Process the file with sed
sed -e 's/placeholder/myapp/' \
    -e 's/APP_ENV=development/APP_ENV=production/' \
    -e '/^#/d' \
    -e '/APP_NAME=/a APP_VERSION=1.0.0' \
    -e 's/\([A-Z_]*\)=/\L\1=/' \
    "$INPUT" > "$OUTPUT"

echo "Transformed config saved to $OUTPUT"
cat "$OUTPUT"
