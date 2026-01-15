## What you’re learning

- Basic workflow hardening: action pinning, least-privilege permissions, and vulnerability scanning.

## Pinning actions (supply chain safety)

- Using `uses: owner/action@vX` is convenient but mutable (the tag can move).
- **Pinning by commit SHA** makes the dependency immutable and auditable.

## Least privilege permissions

- Workflows should set `permissions:` explicitly.
- Start from `contents: read` and only add what you need.
- Minimizing permissions reduces blast radius if a workflow is abused.

## Container scanning (non-blocking)

- A vulnerability scan checks OS packages and language dependencies for known CVEs.
- “Non-blocking” means:
  - The scan runs and produces output
  - The workflow does not fail if vulnerabilities are found
- Scanning can target:
  - A built container image (best matches what you ship)
  - The repository filesystem/Docker context (earlier signal, but may differ from the built image)

## What scan output means

- Findings depend on vulnerability databases and can include false positives/negatives.
- Severity is typically categorized (LOW/MEDIUM/HIGH/CRITICAL); treat results as triage input.

## Things that commonly trip people up

- Forgetting to pin “official” actions too (they’re still dependencies).
- Granting broad permissions when not needed.
- Making the scan fail the pipeline when the requirement is explicitly non-blocking.
