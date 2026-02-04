## What you’re learning

- Publishing container images to GitHub Container Registry (GHCR) on merges to `main`.

## GHCR basics

- Registry host: `ghcr.io`.
- Image naming convention for this exercise: `ghcr.io/<owner>/<repo>/api`.
- An image name can have multiple **tags** that point to different image manifests.

## Authentication and permissions

- Workflows can authenticate to GHCR using `GITHUB_TOKEN`.
- You must set **explicit permissions** so the token can push packages:
  - Minimum needed: `contents: read` (checkout) and `packages: write` (push).

## Tagging strategy

- **`main`** tag: a moving tag representing the latest successful main build.
- **`sha-*`** tag: ties an image to a specific commit for traceability and rollback.

## Things that commonly trip people up

- Not setting `permissions:` (token ends up unable to push).
- Logging into the wrong registry host.
- Accidentally publishing from non-main events (this exercise should only publish on `push` to `main`).

## Notes

```bash
concurrency:
  group: exercice06-${{ github.ref }}
  cancel-in-progress: true
```

This controls how many runs of this workflow are allowed at the same time for the same “group”.

1. `group: exercice06-${{ github.ref }}`

- Defines the concurrency key.
- ${{ github.ref }} is the Git ref that triggered the run (for your case usually refs/heads/main).
- So all runs on the same ref share the same group (ex: exercice06-refs/heads/main).

2. `cancel-in-progress: true`

- If a new run starts for the same group, GitHub Actions cancels the currently running older one and keeps the newest.
