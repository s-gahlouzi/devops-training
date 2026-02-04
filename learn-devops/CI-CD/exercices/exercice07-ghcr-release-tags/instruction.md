# Exercise 07 — Release workflow (version tags)

## Goal

Publish immutable, versioned container images when you create a git tag release.

## You will create

- `.github/workflows/exercice07-ghcr-release-tags.yml`

## Requirements

- Trigger on `push` tags matching `v*`
- Build and push API image to GHCR
- Tags:
  - `vX.Y.Z` (from the git tag)
  - `latest`
- Keep permissions least-privilege

## Done when

- Pushing a tag like `v1.2.3` publishes `:v1.2.3` and `:latest` to GHCR.

## What to share for review

- The workflow file content
- Output/logs showing created tags

## Progress log

- Date:
- Notes:
- Result:
