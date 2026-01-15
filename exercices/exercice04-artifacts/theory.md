## What you’re learning

- Publishing build outputs from CI runs as downloadable artifacts.

## What artifacts are

- **Artifacts** are files uploaded from a workflow run and stored by GitHub.
- They’re useful for:
  - Debugging (inspect build output without rebuilding locally)
  - Verification (prove what CI produced)
  - Passing outputs between jobs (when paired with download)

## Upload behavior

- Artifacts are uploaded during the step that performs the upload.
- You choose:
  - **name**: clearly identify which package/output it is.
  - **path(s)**: directory/glob to upload.
  - (Optional) retention period.

## What to upload in this repo

- `dist/**` for Node/TS packages is typically the compiled output.
- Next.js `.next/**` can be large; uploading a smaller subset can be faster and more practical.

## Things that commonly trip people up

- Uploading paths that don’t exist because the build didn’t run or output directory differs.
- Uploading extremely large artifacts (slow, may hit limits).
- Artifacts are per-run; they don’t automatically become releases.
