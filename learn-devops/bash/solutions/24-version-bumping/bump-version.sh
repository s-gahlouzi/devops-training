#!/usr/bin/env bash
set -euo pipefail

DRY_RUN=false

# Parse arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        major|minor|patch)
            BUMP_TYPE="$1"
            shift
            ;;
        *)
            echo "Usage: $0 {major|minor|patch} [--dry-run]" >&2
            exit 1
            ;;
    esac
done

[[ -z "${BUMP_TYPE:-}" ]] && {
    echo "Error: Bump type required" >&2
    exit 1
}

# Get current version
get_version() {
    jq -r '.version' package.json
}

# Bump version
bump_version() {
    local current="$1"
    local type="$2"
    
    IFS='.' read -r major minor patch <<< "$current"
    
    case "$type" in
        major) echo "$((major + 1)).0.0" ;;
        minor) echo "${major}.$((minor + 1)).0" ;;
        patch) echo "${major}.${minor}.$((patch + 1))" ;;
    esac
}

# Update files
update_files() {
    local version="$1"
    
    if [[ "$DRY_RUN" == "false" ]]; then
        jq --arg v "$version" '.version = $v' package.json > package.json.tmp
        mv package.json.tmp package.json
        echo "Updated: package.json"
        
        if [[ -f "package-lock.json" ]]; then
            jq --arg v "$version" '.version = $v' package-lock.json > package-lock.json.tmp
            mv package-lock.json.tmp package-lock.json
            echo "Updated: package-lock.json"
        fi
        
        echo "$version" > version.txt
        echo "Updated: version.txt"
    else
        echo "[DRY RUN] Would update: package.json"
        echo "[DRY RUN] Would update: package-lock.json"
        echo "[DRY RUN] Would update: version.txt"
    fi
}

# Create release
create_release() {
    local version="$1"
    
    if [[ "$DRY_RUN" == "false" ]]; then
        git add package.json package-lock.json version.txt 2>/dev/null || true
        git commit -m "chore: bump version to $version"
        git tag -a "v$version" -m "Release version $version"
        echo "Created commit: chore: bump version to $version"
        echo "Created tag: v$version"
    else
        echo "[DRY RUN] Would create commit: chore: bump version to $version"
        echo "[DRY RUN] Would create tag: v$version"
    fi
}

# Main
current=$(get_version)
new=$(bump_version "$current" "$BUMP_TYPE")

if [[ "$DRY_RUN" == "true" ]]; then
    echo "[DRY RUN] Current version: $current"
    echo "[DRY RUN] Would bump to: $new"
else
    echo "Current version: $current"
    echo "New version: $new"
fi

update_files "$new"
create_release "$new"

echo "Done! New version: $new"
