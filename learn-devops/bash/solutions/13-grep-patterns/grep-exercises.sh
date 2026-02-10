#!/usr/bin/env bash
set -euo pipefail

LOG_FILE="app.log"

echo "=== All Errors ==="
grep "ERROR" "$LOG_FILE"
echo

echo "=== Time Range 10:00:15 to 10:00:25 ==="
grep -E "10:00:(1[5-9]|2[0-5])" "$LOG_FILE"
echo

echo "=== Error Count ==="
error_count=$(grep -c "ERROR" "$LOG_FILE")
warn_count=$(grep -c "WARN" "$LOG_FILE")
echo "Errors: $error_count"
echo "Warnings: $warn_count"
echo

echo "=== Lines with numbers > 80 ==="
grep -E "[8-9][5-9]|[9][0-9]" "$LOG_FILE"
echo

echo "=== Unique Log Levels ==="
grep -oE "INFO|ERROR|WARN" "$LOG_FILE" | sort -u
echo

echo "=== Non-error Lines ==="
grep -v "ERROR" "$LOG_FILE"
echo

echo "=== User Mentions (case-insensitive) ==="
grep -i "user" "$LOG_FILE"
