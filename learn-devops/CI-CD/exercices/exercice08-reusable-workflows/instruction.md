# Exercise 08 — Reuse and maintainability

## Goal

Reduce duplication across workflows by extracting common setup into a reusable unit.

## You will create (choose one)

- A composite action in `.github/actions/`, OR
- A reusable workflow called via `workflow_call`

## Requirements

- Must remove repeated Node setup + npm cache + install logic from at least 2 workflows
- Must still support per-package working directories (`components/api`, `components/core`, `components/web`)

## Done when

- The refactor reduces duplication and workflows still run successfully.

## What to share for review

- The extracted reusable file (action or reusable workflow)
- The updated workflows that call it

## Progress log

- Date:
- Notes:
- Result:
