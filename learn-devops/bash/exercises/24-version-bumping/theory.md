# Theory: Version Bumping and Release Management

## Semantic Versioning (semver)

Format: `MAJOR.MINOR.PATCH`

```
1.2.3
│ │ │
│ │ └─ PATCH: Bug fixes (backwards compatible)
│ └─── MINOR: New features (backwards compatible)
└───── MAJOR: Breaking changes
```

## Version Bumping

```bash
bump_version() {
    local current="$1"
    local type="$2"

    # Parse version
    if [[ ! "$current" =~ ^([0-9]+)\.([0-9]+)\.([0-9]+)$ ]]; then
        echo "Invalid version format: $current" >&2
        return 1
    fi

    local major="${BASH_REMATCH[1]}"
    local minor="${BASH_REMATCH[2]}"
    local patch="${BASH_REMATCH[3]}"

    # Bump based on type
    case "$type" in
        major)
            echo "$((major + 1)).0.0"
            ;;
        minor)
            echo "${major}.$((minor + 1)).0"
            ;;
        patch)
            echo "${major}.${minor}.$((patch + 1))"
            ;;
        *)
            echo "Invalid bump type: $type" >&2
            return 1
            ;;
    esac
}

# Usage
current="1.2.3"
new=$(bump_version "$current" "minor")
echo "$new"  # 1.3.0
```

## Read Version from package.json

```bash
get_version_from_package_json() {
    local file="package.json"

    if [[ ! -f "$file" ]]; then
        echo "package.json not found" >&2
        return 1
    fi

    # Using jq
    jq -r '.version' "$file"

    # Without jq
    grep -o '"version"[[:space:]]*:[[:space:]]*"[^"]*"' "$file" | \
        cut -d'"' -f4
}
```

## Update Version in package.json

```bash
update_package_json_version() {
    local new_version="$1"
    local file="package.json"

    # Using jq
    jq --arg version "$new_version" '.version = $version' "$file" > "$file.tmp"
    mv "$file.tmp" "$file"

    # Without jq (using sed)
    sed -i.bak "s/\"version\"[[:space:]]*:[[:space:]]*\"[^\"]*\"/\"version\": \"$new_version\"/" "$file"
    rm -f "$file.bak"
}
```

## Update Multiple Files

```bash
update_version_files() {
    local new_version="$1"
    local files=(
        "package.json"
        "package-lock.json"
        "version.txt"
    )

    for file in "${files[@]}"; do
        if [[ -f "$file" ]]; then
            case "$file" in
                package*.json)
                    update_package_json_version "$new_version"
                    echo "Updated: $file"
                    ;;
                version.txt)
                    echo "$new_version" > "$file"
                    echo "Updated: $file"
                    ;;
            esac
        fi
    done
}
```

## Git Commit and Tag

```bash
create_version_commit() {
    local version="$1"
    local files=(
        "package.json"
        "package-lock.json"
        "version.txt"
    )

    # Stage files
    for file in "${files[@]}"; do
        [[ -f "$file" ]] && git add "$file"
    done

    # Create commit
    git commit -m "chore: bump version to $version"

    # Create tag
    git tag -a "v$version" -m "Release version $version"

    echo "Created commit and tag for version $version"
}
```

## Conventional Commits

Format: `type(scope): description`

Types:

- `feat`: New feature → minor bump
- `fix`: Bug fix → patch bump
- `BREAKING CHANGE`: Breaking change → major bump
- `chore`, `docs`, `style`, `refactor`, `test` → no version bump

## Analyze Commits

```bash
analyze_commits() {
    local last_tag
    last_tag=$(git describe --tags --abbrev=0 2>/dev/null || echo "")

    local commit_range
    if [[ -n "$last_tag" ]]; then
        commit_range="${last_tag}..HEAD"
    else
        commit_range="HEAD"
    fi

    local feat_count=0
    local fix_count=0
    local breaking_count=0

    while IFS= read -r commit; do
        if [[ "$commit" =~ ^feat ]]; then
            ((feat_count++))
        elif [[ "$commit" =~ ^fix ]]; then
            ((fix_count++))
        elif [[ "$commit" =~ BREAKING[[:space:]]CHANGE ]]; then
            ((breaking_count++))
        fi
    done < <(git log "$commit_range" --pretty=format:"%s")

    echo "feat: $feat_count"
    echo "fix: $fix_count"
    echo "breaking: $breaking_count"

    # Determine bump type
    if (( breaking_count > 0 )); then
        echo "major"
    elif (( feat_count > 0 )); then
        echo "minor"
    elif (( fix_count > 0 )); then
        echo "patch"
    else
        echo "none"
    fi
}
```

## Get Latest Tag

```bash
get_latest_tag() {
    git describe --tags --abbrev=0 2>/dev/null || echo "v0.0.0"
}

get_latest_version() {
    local tag=$(get_latest_tag)
    # Remove 'v' prefix
    echo "${tag#v}"
}
```

## Dry Run Mode

```bash
DRY_RUN=false

dry_run_execute() {
    if [[ "$DRY_RUN" == "true" ]]; then
        echo "[DRY RUN] Would execute: $*"
    else
        "$@"
    fi
}

# Usage
dry_run_execute git commit -m "message"
dry_run_execute git tag v1.0.0
```

## Changelog Generation

```bash
generate_changelog_entry() {
    local version="$1"
    local date=$(date +%Y-%m-%d)
    local last_tag=$(git describe --tags --abbrev=0 2>/dev/null)

    cat <<EOF

## [$version] - $date

### Added
$(git log ${last_tag}..HEAD --pretty=format:"- %s" --grep="^feat")

### Fixed
$(git log ${last_tag}..HEAD --pretty=format:"- %s" --grep="^fix")

### Changed
$(git log ${last_tag}..HEAD --pretty=format:"- %s" --grep="^refactor")

EOF
}

# Append to CHANGELOG.md
append_changelog() {
    local version="$1"
    local entry=$(generate_changelog_entry "$version")

    if [[ -f "CHANGELOG.md" ]]; then
        # Insert after header
        sed -i "1,/^## /s/^## /\n$entry\n&/" CHANGELOG.md
    else
        # Create new
        echo "# Changelog" > CHANGELOG.md
        echo "$entry" >> CHANGELOG.md
    fi
}
```

## Complete Version Bump Script

```bash
#!/usr/bin/env bash
set -euo pipefail

# Configuration
DRY_RUN=false
VERBOSE=false

# Parse arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        major|minor|patch)
            BUMP_TYPE="$1"
            shift
            ;;
        *)
            echo "Usage: $0 {major|minor|patch} [--dry-run] [-v]"
            exit 1
            ;;
    esac
done

[[ -z "${BUMP_TYPE:-}" ]] && {
    echo "Error: Bump type required (major|minor|patch)"
    exit 1
}

# Functions
log() {
    echo "$*"
}

log_dry_run() {
    if [[ "$DRY_RUN" == "true" ]]; then
        echo "[DRY RUN] $*"
    else
        log "$*"
    fi
}

get_current_version() {
    jq -r '.version' package.json
}

bump_version() {
    local current="$1"
    local type="$2"

    IFS='.' read -r major minor patch <<< "$current"

    case "$type" in
        major)
            echo "$((major + 1)).0.0"
            ;;
        minor)
            echo "${major}.$((minor + 1)).0"
            ;;
        patch)
            echo "${major}.${minor}.$((patch + 1))"
            ;;
    esac
}

update_files() {
    local new_version="$1"

    if [[ "$DRY_RUN" == "false" ]]; then
        # Update package.json
        jq --arg v "$new_version" '.version = $v' package.json > package.json.tmp
        mv package.json.tmp package.json
        log "Updated: package.json"

        # Update package-lock.json
        if [[ -f "package-lock.json" ]]; then
            jq --arg v "$new_version" '.version = $v' package-lock.json > package-lock.json.tmp
            mv package-lock.json.tmp package-lock.json
            log "Updated: package-lock.json"
        fi

        # Update version.txt
        echo "$new_version" > version.txt
        log "Updated: version.txt"
    else
        log_dry_run "Would update: package.json"
        log_dry_run "Would update: package-lock.json"
        log_dry_run "Would update: version.txt"
    fi
}

create_release() {
    local version="$1"

    if [[ "$DRY_RUN" == "false" ]]; then
        git add package.json package-lock.json version.txt 2>/dev/null || true
        git commit -m "chore: bump version to $version"
        git tag -a "v$version" -m "Release version $version"
        log "Created commit and tag for v$version"
    else
        log_dry_run "Would create commit: chore: bump version to $version"
        log_dry_run "Would create tag: v$version"
    fi
}

# Main
main() {
    # Get current version
    current_version=$(get_current_version)
    log "Current version: $current_version"

    # Calculate new version
    new_version=$(bump_version "$current_version" "$BUMP_TYPE")
    log "New version: $new_version"

    # Update files
    update_files "$new_version"

    # Create git commit and tag
    create_release "$new_version"

    log "Done! New version: $new_version"
}

main
```

## GitHub Actions Integration

```yaml
name: Release

on:
  workflow_dispatch:
    inputs:
      version:
        description: "Version bump type"
        required: true
        type: choice
        options:
          - major
          - minor
          - patch

jobs:
  release:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
        with:
          token: ${{ secrets.GITHUB_TOKEN }}

      - name: Configure Git
        run: |
          git config user.name "github-actions[bot]"
          git config user.email "github-actions[bot]@users.noreply.github.com"

      - name: Bump Version
        run: |
          chmod +x ./scripts/bump-version.sh
          ./scripts/bump-version.sh ${{ inputs.version }}

      - name: Push Changes
        run: |
          git push origin main
          git push origin --tags

      - name: Create GitHub Release
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        run: |
          VERSION=$(cat version.txt)
          gh release create "v$VERSION" \
            --title "Release v$VERSION" \
            --generate-notes
```

## Best Practices

1. **Validate current version:**

   ```bash
   [[ "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]
   ```

2. **Check git status:**

   ```bash
   [[ -z $(git status --porcelain) ]]
   ```

3. **Support dry-run:**

   ```bash
   [[ "$DRY_RUN" == "true" ]] && return
   ```

4. **Update all version files:**

   - package.json
   - package-lock.json
   - version.txt
   - CHANGELOG.md

5. **Use conventional commits:**

   ```bash
   git commit -m "chore: bump version to $version"
   ```

6. **Create annotated tags:**

   ```bash
   git tag -a "v$version" -m "Release $version"
   ```

7. **Validate before pushing:**
   ```bash
   npm test
   npm run build
   ```
