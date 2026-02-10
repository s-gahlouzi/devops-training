#!/usr/bin/env bash
set -euo pipefail

CONFIG="config.yml"
WORKFLOW="github-workflow.yml"

echo "=== App Version ==="
yq '.app.version' "$CONFIG"
echo

echo "=== Database Config ==="
echo "Host: $(yq '.database.host' "$CONFIG")"
echo "Port: $(yq '.database.port' "$CONFIG")"
echo "Name: $(yq '.database.name' "$CONFIG")"
echo

echo "=== Enabled Services ==="
yq '.services[] | select(.enabled == true) | .name' "$CONFIG"
echo

echo "=== Updated Port (output only) ==="
yq '.server.port = 8080' "$CONFIG" | yq '.server'
echo

echo "=== With New Service ==="
yq '.services += [{"name": "metrics", "enabled": true, "replicas": 1}]' "$CONFIG" | yq '.services'
echo

echo "=== As JSON ==="
yq -o=json '.' "$CONFIG"
echo

echo "=== Workflow Jobs ==="
yq '.jobs | keys | .[]' "$WORKFLOW"
echo

echo "=== Job Steps ==="
for job in $(yq '.jobs | keys | .[]' "$WORKFLOW"); do
    steps=$(yq ".jobs.$job.steps | length" "$WORKFLOW")
    echo "$job: $steps steps"
done
