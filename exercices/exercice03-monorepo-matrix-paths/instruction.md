# Exercise 03 — Monorepo optimization (matrix + paths)

## Goal

Speed up CI by only running checks for packages affected by the PR.

## You will create

- `.github/workflows/exercice03-monorepo-matrix-paths.yml`

## Requirements

- Trigger on `pull_request`
- Detect changes under:
  - `components/api/**`
  - `components/core/**`
  - `components/web/**`
- Run CI only for changed packages
- Use a matrix for the package jobs

## Done when

- If a PR changes only `components/web/**`, only web checks run.

## What to share for review

- The workflow file content
- Evidence from a PR run showing only the intended jobs ran

## Progress log

- Date:
- Notes:
- Result:
