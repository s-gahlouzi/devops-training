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

## Notes

### What `strategy` is (in GitHub Actions jobs)

`strategy` controls **how a job is executed when it has multiple “variations”** (like running the same job against multiple packages, OSes, Node versions, etc.).

In your file, `strategy` is used to enable a **matrix build**.

### What `matrix` is

`matrix` defines a set of values, and GitHub Actions will **run the same job once per value/combination**.

Here:

- `matrix.package: [api, core, web]` means GitHub Actions will create **3 separate runs of the `ci` job**:
  - one with `matrix.package = api`
  - one with `matrix.package = core`
  - one with `matrix.package = web`

That’s why later you can reference it as `${{ matrix.package }}` (see your `case` statement).

### What `fail-fast: false` does

By default, if one matrix run fails, GitHub may **cancel the other in-progress matrix runs** early.

- `fail-fast: false` means: **don’t cancel the others**; let all `api/core/web` runs finish even if one fails.

### What `$GITHUB_OUTPUT` is

`$GITHUB_OUTPUT` is an **environment variable set by GitHub Actions** that contains the path to a **temporary file**.

When a step writes lines like `name=value` into that file, GitHub Actions treats them as **outputs of that step**.

So in your workflow:

- This writes a step output:

```bash
echo "workdir=components/api" >> "$GITHUB_OUTPUT"
```

- And later you can read it as:

- `${{ steps.vars.outputs.workdir }}`

It’s the modern, recommended replacement for the old `::set-output` command.
