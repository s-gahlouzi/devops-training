# Exercise 05 — Docker build in CI (PR, no push)

## Goal

Build the API Docker image in PRs to validate the Dockerfile.

## You will create

- `.github/workflows/exercice05-docker-build-pr.yml`

## Requirements

- Trigger on `pull_request`
- Build Docker image from:
  - Dockerfile: `components/api/Dockerfile`
  - Context: `components/api`
- Do not push the image
- Use BuildKit/Buildx

## Done when

- The image build succeeds in Actions for PRs.

## What to share for review

- The workflow file content
- Logs showing build succeeded

## Progress log

- Date:
- Notes:
- Result:
