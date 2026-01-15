# Exercise 02 — CI for Node/TS packages

## Goal

Build a basic CI that validates all packages in this repo.

## You will create

- `.github/workflows/exercice02-node-ci.yml`

## Requirements

- Trigger on `pull_request`
- Run checks for:
  - `components/api` (must run `npm ci` + `npm run build`)
  - `components/core` (must run `npm ci` + `npm run build`)
  - `components/web` (must run `npm ci` + `npm run lint` + `npm run build`)
- Use Node 20 via `actions/setup-node`
- Use npm cache (`setup-node` cache) per package lockfile

## Done when

- A PR run succeeds for all three packages.

## What to share for review

- The workflow file content
- Link to the Actions run (or logs pasted)

## Progress log

- Date:
- Notes:
- Result:
