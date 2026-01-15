## What you’re learning

- Optimizing monorepo CI so only affected packages run, using change detection + a job matrix.

## The core idea

- **Change detection** decides which packages were modified in the PR.
- A **matrix** then runs the same job logic for each changed package (instead of hardcoding 3 nearly-identical jobs).

## Ways to detect changes

- **Path filters** match changed files against patterns like `components/web/**`.
- A common structure is:
  - A small “detect” job computes which packages changed.
  - It exposes results via **job outputs** for later jobs.

## Matrix fundamentals

- A **matrix** creates multiple job copies from a list.
- The selected package becomes a per-job variable used for:
  - Working directory
  - Cache dependency path (per-package lockfile)
  - Which commands to run
- If the list is empty, you should avoid running the CI job (usually via an `if:` condition).

## PR-specific detail

- “What changed” must be computed against the PR base branch, not only the head commit.

## Things that commonly trip people up

- Creating a matrix that always includes all packages (no actual optimization).
- Producing a list as a plain string and not converting it into structured data (matrix expects structured values).
- Forgetting to skip downstream jobs when nothing relevant changed.
