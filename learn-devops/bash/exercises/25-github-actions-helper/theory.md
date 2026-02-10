# Theory: GitHub Actions Helper Scripts

## GitHub Actions Workflow Commands

GitHub Actions uses special commands to communicate with the runner.

### Setting Outputs

```bash
# Set output for use in later steps
echo "key=value" >> "$GITHUB_OUTPUT"

# In function
gh_output() {
    local key="$1"
    local value="$2"
    echo "${key}=${value}" >> "${GITHUB_OUTPUT:-/dev/null}"
}

# Usage in workflow
- name: Set Version
  id: version
  run: |
    VERSION="1.2.3"
    echo "version=$VERSION" >> $GITHUB_OUTPUT

- name: Use Version
  run: echo "Version is ${{ steps.version.outputs.version }}"
```

### Job Summary

Markdown content displayed on job summary page:

```bash
# Add to summary
echo "## Build Results" >> "$GITHUB_STEP_SUMMARY"
echo "Build successful!" >> "$GITHUB_STEP_SUMMARY"

# In function
gh_summary() {
    echo "$*" >> "${GITHUB_STEP_SUMMARY:-/dev/null}"
}

# Usage
gh_summary "## Test Results"
gh_summary "- Passed: 45"
gh_summary "- Failed: 2"
```

### Annotations

Create errors, warnings, and notices:

```bash
# Error annotation
echo "::error file=app.js,line=10,col=5::Missing semicolon"

# Warning
echo "::warning file=api.ts,line=42::Deprecated API"

# Notice
echo "::notice::Build cache hit"

# In functions
gh_error() {
    local message="$1"
    local file="${2:-}"
    local line="${3:-}"

    local annotation="::error"
    [[ -n "$file" ]] && annotation="${annotation} file=${file}"
    [[ -n "$line" ]] && annotation="${annotation},line=${line}"
    echo "${annotation}::${message}"
}

gh_warning() {
    local message="$1"
    local file="${2:-}"
    local line="${3:-}"

    local annotation="::warning"
    [[ -n "$file" ]] && annotation="${annotation} file=${file}"
    [[ -n "$line" ]] && annotation="${annotation},line=${line}"
    echo "${annotation}::${message}"
}

gh_notice() {
    local message="$1"
    echo "::notice::${message}"
}
```

### Log Groups

Collapsible sections in logs:

```bash
# Manual grouping
echo "::group::Group Title"
# commands
echo "::endgroup::"

# In function
gh_group() {
    local title="$1"
    shift
    local command=("$@")

    echo "::group::${title}"
    "${command[@]}"
    local exit_code=$?
    echo "::endgroup::"

    return $exit_code
}

# Usage
gh_group "Install Dependencies" npm ci
gh_group "Run Tests" npm test
```

### Environment Variables

Set variables for subsequent steps:

```bash
# Set environment variable
echo "VAR_NAME=value" >> "$GITHUB_ENV"

# In function
gh_set_env() {
    local key="$1"
    local value="$2"
    echo "${key}=${value}" >> "${GITHUB_ENV:-/dev/null}"
}

# Multi-line values
EOF_TOKEN=$(openssl rand -hex 8)
{
    echo "MULTI_LINE<<${EOF_TOKEN}"
    echo "line 1"
    echo "line 2"
    echo "${EOF_TOKEN}"
} >> "$GITHUB_ENV"
```

### PATH Modification

Add directories to PATH:

```bash
# Add to PATH
echo "/path/to/bin" >> "$GITHUB_PATH"

# In function
gh_add_path() {
    local path="$1"
    echo "$path" >> "${GITHUB_PATH:-/dev/null}"
}
```

### Masking Values

Hide sensitive values in logs:

```bash
# Mask value
echo "::add-mask::$SECRET_VALUE"

# In function
gh_mask() {
    echo "::add-mask::$1"
}
```

## CI Environment Detection

```bash
is_ci() {
    [[ "${CI:-false}" == "true" ]]
}

is_github_actions() {
    [[ -n "${GITHUB_ACTIONS:-}" ]]
}

is_pull_request() {
    [[ "${GITHUB_EVENT_NAME:-}" == "pull_request" ]]
}
```

## GitHub Context Access

```bash
# Get PR number
get_pr_number() {
    if [[ -f "$GITHUB_EVENT_PATH" ]]; then
        jq -r '.pull_request.number // empty' "$GITHUB_EVENT_PATH"
    fi
}

# Get branch name
get_branch_name() {
    echo "${GITHUB_REF_NAME:-}"
}

# Get commit SHA
get_commit_sha() {
    echo "${GITHUB_SHA:-}"
}

# Get repository
get_repository() {
    echo "${GITHUB_REPOSITORY:-}"
}

# Get actor (user who triggered)
get_actor() {
    echo "${GITHUB_ACTOR:-}"
}
```

## Complete Utilities Library

```bash
#!/usr/bin/env bash
# gh-actions-utils.sh

set -euo pipefail

# Output
gh_output() {
    local key="$1"
    local value="$2"
    echo "${key}=${value}" >> "${GITHUB_OUTPUT:-/dev/null}"
}

# Summary
gh_summary() {
    echo "$*" >> "${GITHUB_STEP_SUMMARY:-/dev/null}"
}

# Annotations
gh_error() {
    local message="$1"
    local file="${2:-}"
    local line="${3:-}"
    local col="${4:-}"

    local annotation="::error"
    [[ -n "$file" ]] && annotation="${annotation} file=${file}"
    [[ -n "$line" ]] && annotation="${annotation},line=${line}"
    [[ -n "$col" ]] && annotation="${annotation},col=${col}"
    echo "${annotation}::${message}"
}

gh_warning() {
    local message="$1"
    local file="${2:-}"
    local line="${3:-}"

    local annotation="::warning"
    [[ -n "$file" ]] && annotation="${annotation} file=${file}"
    [[ -n "$line" ]] && annotation="${annotation},line=${line}"
    echo "${annotation}::${message}"
}

gh_notice() {
    local message="$1"
    echo "::notice::${message}"
}

# Log groups
gh_group() {
    local title="$1"
    shift
    local command=("$@")

    echo "::group::${title}"
    "${command[@]}"
    local exit_code=$?
    echo "::endgroup::"

    return $exit_code
}

gh_start_group() {
    echo "::group::$1"
}

gh_end_group() {
    echo "::endgroup::"
}

# Environment
gh_set_env() {
    local key="$1"
    local value="$2"
    echo "${key}=${value}" >> "${GITHUB_ENV:-/dev/null}"
}

gh_add_path() {
    local path="$1"
    echo "$path" >> "${GITHUB_PATH:-/dev/null}"
}

gh_mask() {
    echo "::add-mask::$1"
}

# CI Detection
is_ci() {
    [[ "${CI:-false}" == "true" ]]
}

is_github_actions() {
    [[ -n "${GITHUB_ACTIONS:-}" ]]
}

is_pull_request() {
    [[ "${GITHUB_EVENT_NAME:-}" == "pull_request" ]]
}

# Context
get_pr_number() {
    if [[ -f "${GITHUB_EVENT_PATH:-}" ]]; then
        jq -r '.pull_request.number // empty' "$GITHUB_EVENT_PATH"
    fi
}

get_branch_name() {
    echo "${GITHUB_REF_NAME:-$(git rev-parse --abbrev-ref HEAD)}"
}

get_commit_sha() {
    echo "${GITHUB_SHA:-$(git rev-parse HEAD)}"
}

get_short_sha() {
    echo "${GITHUB_SHA:0:7}"
}

get_repository() {
    echo "${GITHUB_REPOSITORY:-}"
}

get_actor() {
    echo "${GITHUB_ACTOR:-}"
}

# Status emoji
status_emoji() {
    local status="$1"
    case "$status" in
        success|pass|passed) echo "✅" ;;
        failure|fail|failed) echo "❌" ;;
        warning|warn) echo "⚠️" ;;
        skipped|skip) echo "⊘" ;;
        running) echo "🔄" ;;
        *) echo "•" ;;
    esac
}
```

## Test Reporter Example

```bash
#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/gh-actions-utils.sh"

# Parse test results
parse_test_results() {
    local results_file="$1"

    if [[ ! -f "$results_file" ]]; then
        gh_error "Test results file not found: $results_file"
        return 1
    fi

    local total passed failed skipped

    total=$(jq '.tests | length' "$results_file")
    passed=$(jq '[.tests[] | select(.status == "passed")] | length' "$results_file")
    failed=$(jq '[.tests[] | select(.status == "failed")] | length' "$results_file")
    skipped=$(jq '[.tests[] | select(.status == "skipped")] | length' "$results_file")

    # Set outputs
    gh_output "total" "$total"
    gh_output "passed" "$passed"
    gh_output "failed" "$failed"
    gh_output "skipped" "$skipped"

    # Generate summary
    gh_summary "## Test Results"
    gh_summary ""
    gh_summary "| Status | Passed | Failed | Skipped | Total |"
    gh_summary "|--------|--------|--------|---------|-------|"

    local status_emoji="✅"
    (( failed > 0 )) && status_emoji="❌"

    gh_summary "| $status_emoji | $passed | $failed | $skipped | $total |"
    gh_summary ""

    # Failed tests details
    if (( failed > 0 )); then
        gh_summary "### ❌ Failed Tests"
        gh_summary ""

        while IFS= read -r test; do
            local name=$(echo "$test" | jq -r '.name')
            local file=$(echo "$test" | jq -r '.file')
            local line=$(echo "$test" | jq -r '.line')
            local error=$(echo "$test" | jq -r '.error')

            gh_summary "- **$name** ($file:$line)"
            gh_summary "  \`\`\`"
            gh_summary "  $error"
            gh_summary "  \`\`\`"
            gh_summary ""

            # Create annotation
            gh_error "Test failed: $name" "$file" "$line"
        done < <(jq -c '.tests[] | select(.status == "failed")' "$results_file")
    fi

    # Return exit code
    (( failed == 0 ))
}

parse_test_results "$1"
```

## Deployment Summary Example

```bash
#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/gh-actions-utils.sh"

create_deployment_summary() {
    local environment="$1"
    local version="$2"
    local url="$3"

    gh_summary "## 🚀 Deployment Summary"
    gh_summary ""
    gh_summary "| Property | Value |"
    gh_summary "|----------|-------|"
    gh_summary "| Environment | \`$environment\` |"
    gh_summary "| Version | \`$version\` |"
    gh_summary "| URL | [$url]($url) |"
    gh_summary "| Commit | \`$(get_short_sha)\` |"
    gh_summary "| Branch | \`$(get_branch_name)\` |"
    gh_summary "| Deployed by | @$(get_actor) |"
    gh_summary "| Time | $(date -u +"%Y-%m-%d %H:%M:%S UTC") |"
    gh_summary ""

    # Set outputs
    gh_output "environment" "$environment"
    gh_output "version" "$version"
    gh_output "url" "$url"
}
```

## Real-World Usage

**In GitHub Actions workflow:**

```yaml
name: CI

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Setup
        run: |
          source ./scripts/gh-actions-utils.sh
          gh_notice "Setting up environment"

      - name: Run Tests
        id: tests
        run: |
          source ./scripts/gh-actions-utils.sh
          gh_group "Run Tests" npm test
          ./scripts/test-reporter.sh test-results.json

      - name: Build
        run: |
          source ./scripts/gh-actions-utils.sh
          gh_group "Build Application" npm run build

          VERSION=$(cat package.json | jq -r '.version')
          gh_output "version" "$VERSION"
          gh_set_env "BUILD_VERSION" "$VERSION"

      - name: Create Summary
        if: always()
        run: |
          source ./scripts/gh-actions-utils.sh
          gh_summary "## Build Complete"
          gh_summary "- Version: $BUILD_VERSION"
          gh_summary "- Tests: ${{ steps.tests.outputs.passed }}/${{ steps.tests.outputs.total }} passed"
```

## Best Practices

1. **Source utilities in each step:**

   ```bash
   source ./scripts/gh-actions-utils.sh
   ```

2. **Use log groups for organization:**

   ```bash
   gh_group "Step Name" command
   ```

3. **Set outputs for later steps:**

   ```bash
   gh_output "key" "value"
   ```

4. **Create comprehensive summaries:**

   ```bash
   gh_summary "## Results"
   gh_summary "| Metric | Value |"
   ```

5. **Add annotations for issues:**

   ```bash
   gh_error "Error message" "file.ts" 42
   ```

6. **Mask sensitive values:**

   ```bash
   gh_mask "$SECRET"
   ```

7. **Check CI environment:**
   ```bash
   if is_ci; then
       # CI-specific logic
   fi
   ```
