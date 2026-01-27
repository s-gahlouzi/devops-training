## What you’re learning

- Validating a Docker build in CI for pull requests without pushing images.

## Docker build fundamentals

- **Build context**: directory sent to the builder; only files in the context are available to `COPY`.
- **Dockerfile path**: separate input; can live inside the context, but still must be referenced correctly.
- If context/Dockerfile are mismatched, builds fail with missing files.

## BuildKit / Buildx

- **BuildKit** is the modern build engine (better caching, parallelism, features).
- **Buildx** is the interface commonly used in Actions to run BuildKit builds consistently. This action is essential for enabling advanced Docker build features, particularly in automated environments like GitHub Actions.

## CI goal for PRs

- In PRs you typically:
  - Build to ensure the Dockerfile and context are valid
  - Do **not** push (avoid publishing untrusted changes)

## Things that commonly trip people up

- Wrong context (`components/api` vs repo root) leading to `COPY` failures.
- Builds relying on local state that isn’t present in CI.
- Ignored files (`.dockerignore`) causing CI-only failures.
