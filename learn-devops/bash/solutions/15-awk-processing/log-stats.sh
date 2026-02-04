#!/usr/bin/env bash
set -euo pipefail

LOG="access.log"

echo "=== Requests per IP ==="
awk '{print $1}' "$LOG" | sort | uniq -c | awk '{printf "%s: %d\n", $2, $1}'
echo

echo "=== Status Codes ==="
awk '{print $9}' "$LOG" | sort | uniq -c | awk '{printf "%s: %d\n", $2, $1}'
echo

echo "=== Average Response Size ==="
awk '{sum+=$10; count++} END {printf "%.0f bytes\n", sum/count}' "$LOG"
echo

echo "=== Unique Endpoints ==="
awk '{print $7}' "$LOG" | sort -u
