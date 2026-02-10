#!/usr/bin/env bash
set -euo pipefail

echo "Starting..."

# This will cause script to exit because UNDEFINED is not set
echo "test: $UNDEFINED"

# Never reached
echo "Done!"
