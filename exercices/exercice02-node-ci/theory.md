## What you’re learning

- Implementing CI checks for multiple Node/TypeScript packages in one repository.

## Node/TypeScript CI essentials

- **Deterministic installs**:
  - `npm ci` installs from `package-lock.json` and fails if the lockfile doesn’t match `package.json`.
  - It’s the standard choice for CI because it’s reproducible.
- **Scripts**:
  - `npm run build` / `npm run lint` run scripts declared in each package’s `package.json`.

## GitHub Actions concepts used here

- **Working directory**: each package is in a subfolder, so steps should run with that folder as the working directory (otherwise installs/builds happen in the wrong place).
- **`actions/setup-node`**:
  - Installs the Node runtime (Node 20 for this exercise).
  - Supports npm caching to speed up installs.

## Caching (why and how)

- **What gets cached**: npm’s package cache (not `node_modules`).
- **Cache key**: should be tied to the lockfile for the specific package so caches are isolated and invalidate correctly.

## Things that commonly trip people up

- Running `npm ci` at the repo root instead of inside each package directory.
- Sharing one cache key across packages (causes incorrect hits/misses).
- Treating lint/build requirements as “global” when they’re package-specific.

## Notes

##### `timeout-minutes`

- Prevents a job from hanging forever (useful if npm ci stalls, network issues, etc.). Not required, but good hygiene.

##### `defaults.run.working-directory`

it sets a default working directory for all run: steps in that job.
