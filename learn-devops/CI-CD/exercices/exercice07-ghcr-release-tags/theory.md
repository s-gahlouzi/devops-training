## What you’re learning

- Publishing immutable, versioned images when you push a git tag (release-style publishing).

## Git tags and why they matter

- A **git tag** is a named pointer to a specific commit.
- Tag-triggered workflows are good for releases because the source commit is immutable.

## Triggering on version tags

- A `push` trigger on tags matching `v*` means only tags like `v1.2.3` start the workflow.

## Tagging strategy

- **Version tag (`vX.Y.Z`)**: immutable and ideal for deployments.
- **`latest`**: moving tag pointing to the newest published version.
  - Convenient, but not immutable; many production setups prefer deploying by version or digest.

## Permissions and publishing

- Same GHCR rules apply as on main pushes: authenticate using `GITHUB_TOKEN` and grant `packages: write` explicitly.

## Things that commonly trip people up

- Using the wrong ref variable (you want the tag name in a tag workflow).
- Confusing tag name and commit SHA (they represent different identifiers).
