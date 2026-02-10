# Exercise 25: GitHub Actions Helper Scripts

## Goal

Create helper scripts for GitHub Actions workflows.

## Requirements

Create `gh-actions-utils.sh` library with functions:

1. `gh_output` - Set GitHub Actions output
2. `gh_summary` - Add to job summary
3. `gh_error` - Create error annotation
4. `gh_warning` - Create warning annotation
5. `gh_notice` - Create notice annotation
6. `gh_group` - Create collapsible log group
7. `gh_set_env` - Set environment variable for subsequent steps
8. `gh_add_path` - Add directory to PATH
9. `is_ci` - Check if running in CI
10. `get_pr_number` - Get PR number from event

Create `deploy-helper.sh` that uses the library:

1. Validates deployment environment
2. Checks if commit is deployable
3. Creates deployment summary
4. Sets outputs for later steps
5. Uses log groups for organization

Create `test-reporter.sh` that:

1. Parses test results (JSON format)
2. Creates formatted summary table
3. Adds annotations for failures
4. Sets pass/fail outputs

## Expected Usage

```bash
# In GitHub Actions workflow
- name: Deploy
  run: |
    source ./scripts/gh-actions-utils.sh
    source ./scripts/deploy-helper.sh

    gh_group "Deployment" deploy_to_production

# Functions create:
# - Job outputs
# - Step summaries
# - Annotations
# - Environment variables

# gh-actions-utils.sh
source gh-actions-utils.sh

gh_output "version" "1.2.3"
gh_output "artifact" "dist/app.tar.gz"

gh_summary "## Build Summary"
gh_summary "- Version: 1.2.3"
gh_summary "- Duration: 45s"

gh_error "Build failed" "src/index.ts" 15
gh_warning "Deprecated API used" "src/api.ts" 42
gh_notice "Build cache hit"

gh_group "Install Dependencies" npm ci
gh_group "Run Tests" npm test

gh_set_env "DEPLOY_VERSION" "1.2.3"
gh_add_path "/opt/custom/bin"

if is_ci; then
    echo "Running in CI"
fi

pr_number=$(get_pr_number)
echo "PR: $pr_number"

# test-reporter.sh
./test-reporter.sh test-results.json

# Creates summary:
## Test Results
| Status | Passed | Failed | Skipped | Total |
|--------|--------|--------|---------|-------|
| ✓      | 45     | 2      | 1       | 48    |

### Failed Tests
- ❌ User Login Test (src/auth.test.ts:25)
  Error: Expected 200, got 401

### Skipped Tests
- ⊘ Performance Test (src/perf.test.ts:10)
```

## Success Criteria

- GitHub Actions commands work
- Outputs are set correctly
- Summary is formatted
- Annotations appear in UI
- Log groups work
- Environment variables persist
- CI detection works
