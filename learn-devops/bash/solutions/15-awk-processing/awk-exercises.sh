#!/usr/bin/env bash
set -euo pipefail

CSV="services.csv"

echo "=== Service Names ==="
awk -F',' 'NR>1 {print $1}' "$CSV"
echo

echo "=== High Ports (>5000) ==="
awk -F',' 'NR>1 && $2>5000 {print $1, $2}' "$CSV"
echo

echo "=== Total Memory (running services) ==="
awk -F',' 'NR>1 && $3=="running" {sum+=$4} END {print sum " MB"}' "$CSV"
echo

echo "=== Service Status Count ==="
awk -F',' 'NR>1 {count[$3]++} END {for (status in count) print status ": " count[status]}' "$CSV"
echo

echo "=== Formatted Output ==="
awk -F',' 'NR>1 {printf "Service: %s (port %s) - %s\n", $1, $2, $3}' "$CSV"
echo

echo "=== Highest Memory ==="
awk -F',' 'NR>1 {if ($4>max) {max=$4; service=$1}} END {print service ": " max " MB"}' "$CSV"
