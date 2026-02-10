#!/usr/bin/env bash
set -euo pipefail

PKG="package.json"
SVC="services.json"

echo "=== Package Version ==="
jq -r '.version' "$PKG"
echo

echo "=== Script Names ==="
jq -r '.scripts | keys[]' "$PKG"
echo

echo "=== Dependencies ==="
jq -r '.dependencies | keys[]' "$PKG"
echo

echo "=== Updated Version ==="
jq '.version = "1.3.0"' "$PKG"
echo

echo "=== Running Services ==="
jq -r '.[] | select(.status == "running") | .name' "$SVC"
echo

echo "=== Service Names ==="
jq '[.[].name]' "$SVC"
echo

echo "=== Services v2+ ==="
jq -r '.[] | select(.version | startswith("2.")) | "\(.name) (\(.version))"' "$SVC"
echo

echo "=== CSV Format ==="
echo "name,port,status"
jq -r '.[] | [.name, .port, .status] | @csv' "$SVC"
echo

echo "=== Port Mapping ==="
jq 'reduce .[] as $item ({}; .[$item.name] = $item.port)' "$SVC"
