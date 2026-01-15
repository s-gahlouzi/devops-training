# Exercise 06 — CD to GHCR (push on main)

## Goal

On merges to `main`, build and push the API image to GitHub Container Registry (GHCR).

## You will create

- `.github/workflows/exercice06-ghcr-push-main.yml`

## Requirements

- Trigger on `push` to `main`
- Login to GHCR using `GITHUB_TOKEN`
- Build and push image from `components/api`
- Image name: `ghcr.io/<owner>/<repo>/api`
- Tags:
  - `sha-<shortsha>` (or `sha-<fullsha>`)
  - `main`
- Set workflow/job permissions explicitly (least privilege)

## Done when

- After a merge to `main`, a new image appears in GHCR packages for the repo.

## What to share for review

- The workflow file content
- Screenshot/text of the published tags in GHCR

## Progress log

- Date:
- Notes:
- Result:
