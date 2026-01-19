## codecov

- use irongut/CodeCoverageSummary@v1.3.0 to upload and display coverage report on PRs
- Artifacts are only useful if you need to manually download/review HTML reports (optional)

- Note that `CodeCoverageSummary` would output a `code-coverage-results.md` markdown file as a result.

- You can use ` marocchino/sticky-pull-request-comment@v2` to add Coverage PR comment

- Reuse workflows, use one single orchestration entry point

- Path-based filtering (only run affected components)
  Example: only run api-ci.yml if files in components/api/\*\* changed

use, `uses: dorny/paths-filter@v2`

```bash
jobs:
  changes:
    # Detect which components changed
    runs-on: ubuntu-latest
    outputs:
      core: ${{ steps.filter.outputs.core }}
      web: ${{ steps.filter.outputs.web }}
      api: ${{ steps.filter.outputs.api }}
    steps:
      - uses: actions/checkout@v4
      - uses: dorny/paths-filter@v2
        id: filter
        with:
          filters: |
            core:
              - 'components/core/**'
            web:
              - 'components/web/**'
            api:
              - 'components/api/**'

  core:
    needs: changes
    if: needs.changes.outputs.core == 'true'
    uses: ./.github/workflows/core-ci.yml

  web:
    needs: changes
    if: needs.changes.outputs.web == 'true'
    uses: ./.github/workflows/web-ci.yml
```
