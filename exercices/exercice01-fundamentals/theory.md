## What you’re learning

- GitHub Actions is event-driven automation (CI/CD) defined as YAML workflows in `.github/workflows/`.

## Core building blocks

- **Workflow**: the YAML file; runs when an event occurs.
- **Event triggers (`on:`)**:
  - `pull_request`: runs for PR activity (opened/synchronize/reopened by default).
  - `workflow_dispatch`: manual trigger from the Actions UI.
- **Job**: a group of steps that runs on a runner (`runs-on`). Jobs run in parallel by default.
- **Runner**: the machine executing your job (hosted like `ubuntu-latest`).
- **Step**: either a shell command (`run`) or an action (`uses`). Steps share the same workspace within a job.

## Useful runtime context

- **`github` context**: metadata about the repo/run/actor/sha/ref.
- **Common environment variables**:
  - `GITHUB_REPOSITORY`, `GITHUB_REF_NAME`, `GITHUB_SHA`.
- **`runner` context**: runner OS/arch.

## Job Summary

- `$GITHUB_STEP_SUMMARY` is a special file path. Appending Markdown text to it adds a “Summary” section on the run page.
- Summary is per-job (each job can write its own).

## Things that commonly trip people up

- `pull_request` vs `push`: PR workflows run on PR refs and can behave differently from `push` workflows.
- Branch name vs ref: `github.ref_name` is usually what you want for a simple branch/tag name.
- Actions only detects workflows placed under `.github/workflows/`.
