## What you’re learning

- Reducing duplication across workflows by extracting common setup into a reusable unit.

## Two reuse options (and when to use them)

- **Composite action (`.github/actions/...`)**:
  - Reuses a sequence of steps.
  - Runs inside an existing job (same runner, same workspace).
  - Best for shared “setup/install” logic.
- **Reusable workflow (`workflow_call`)**:
  - Reuses entire jobs (can define its own jobs, permissions, concurrency).
  - Called from another workflow.
  - Best when you want shared job structure, not just shared steps.

## Inputs you’ll need for this repo

- **Working directory**: each package has its own folder, so the reusable unit must accept a directory input.
- **Cache dependency path**: caches should be tied to each package’s lockfile.

## Secrets and permissions

- Composite actions inherit the caller job’s permissions and secrets.
- Reusable workflows can declare required inputs/secrets and can be granted permissions by the caller.

## Things that commonly trip people up

- Hardcoding paths inside the reusable unit (breaks per-package support).
- Trying to “persist” setup across jobs without artifacts/caches (each job is a fresh environment).
