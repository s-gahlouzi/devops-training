# Exercise 01 — GitHub Actions fundamentals

## Goal

Create your first workflow that runs on PRs and can be manually triggered.

pull request event means:

- PR opened
- PR synchronized (new commits pushed)
- PR reopened
- PR closed (merged or not)

## You will create

- `.github/workflows/exercice01-fundamentals.yml`

## Requirements

- Trigger on `pull_request` and `workflow_dispatch`
- One job on `ubuntu-latest`
- Print basic info (repo, branch, commit SHA, runner OS)
- Write a short Job Summary via `$GITHUB_STEP_SUMMARY`

## Done when

- A PR run succeeds and the Job Summary is visible in the run page.

## What to share for review

- The workflow file content
- A screenshot or text of the Job Summary

## Progress log

- Date:
- Notes:
- Result:
