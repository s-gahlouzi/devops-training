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
