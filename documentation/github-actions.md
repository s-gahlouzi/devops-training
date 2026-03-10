## First: The Problem CI/CD Solves

Imagine you’re working on a project:

1. You write code
2. You push it to GitHub
3. Someone else pulls it
4. It **breaks**
5. You say: “It works on my machine 😅”

This happens because:

- Code isn’t tested consistently
- Builds are manual
- Deployments are manual
- Humans forget steps

👉 **CI/CD automates this entire process**

## What Is CI/CD?

**CI/CD = Continuous Integration + Continuous Delivery/Deployment**

---

## 1️⃣ Continuous Integration (CI)

### What it means

> Every time you change code, it is **automatically checked**.

### What happens in CI?

When you push code:

- ✅ Code is pulled from GitHub
- ✅ Dependencies are installed
- ✅ Tests are run
- ✅ Linting / formatting is checked
- ✅ Build is created

If something fails → 🚨 pipeline fails → you fix it early

### Why CI matters

- Bugs are caught **immediately**
- Team members don’t break each other’s code
- Main branch stays stable

### Simple example

```text
You push code →
GitHub Actions runs tests →
Tests fail →
You fix before merging
```

---

## 2️⃣ Continuous Delivery (CD)

### What it means

> Code is **always ready to be deployed**, but deployment may be manual.

After CI passes:

- App is built
- Artifacts are created
- Deployment is **one click away**

💡 Used when:

- You want human approval before deploying
- Production is sensitive

---

## 3️⃣ Continuous Deployment (Also CD 😄)

### What it means

> Every successful change is **automatically deployed**.

No button. No approval.

```text
Push code →
Tests pass →
Automatically deployed to production
```

💡 Used by:

- Startups
- SaaS products
- High-automation teams

---

## CI vs CD (Quick Table)

| Concept               | What it does           |
| --------------------- | ---------------------- |
| CI                    | Test & validate code   |
| Continuous Delivery   | Prepare for deployment |
| Continuous Deployment | Deploy automatically   |

---

## Where GitHub Actions Fits

GitHub Actions is the **tool** that does CI/CD **inside GitHub**.

- You push code
- GitHub Actions runs workflows
- Workflows automate CI/CD tasks

👉 GitHub Actions = **CI/CD engine**

---

## Mental Model (Very Important)

Think like this:

> **CI/CD = “Whenever code changes, machines do the boring work”**

### Github Actions

GitHub Actions is a popular CI/CD platform for automating your build, test, and deployment pipeline. Docker provides a set of official GitHub Actions for you to use in your workflows. These official actions are reusable, easy-to-use components for building, annotating, and pushing images.

- Key concepts:
  - **Workflow**
  - **Job**
  - **Step**
  - **Action**
  - **Runner**

---

# How GitHub Actions Works (Internally)

Think of GitHub Actions as **event → machine → instructions → result**

---

## Big Picture Flow

```text
Event happens in GitHub
        ↓
Workflow is triggered
        ↓
Runner (machine) is created
        ↓
Jobs run on the runner
        ↓
Steps execute one by one
        ↓
Result is reported back to GitHub
```

## 1️⃣ Events: What Starts Everything

GitHub Actions is **event-driven**.

Examples of events:

- `push`
- `pull_request`
- `release`
- `workflow_dispatch` (manual trigger)

### Internally:

- GitHub constantly listens for events
- When an event happens, GitHub checks:

  > “Do any workflows care about this event?”

If yes → workflow starts.

## 2️⃣ Workflow: The Blueprint

A **workflow** is a YAML file in:

```text
.github/workflows/ci.yml
```

### Internally:

- GitHub parses the YAML
- Validates syntax
- Builds an execution plan:
  - What jobs?
  - In what order?
  - On what machines?

💡 **Workflow = instruction manual**

## 3️⃣ Runner: The Machine That Does the Work

A **runner** is a virtual machine or container.

Types:

- 🟢 GitHub-hosted runners (`ubuntu-latest`, `windows-latest`)
- 🔵 Self-hosted runners (your own server)

### Internally:

- GitHub spins up a **fresh machine**
- Clones your repository
- Installs basic tools (Git, Node, Python, Docker, etc.)
- Registers the runner for **one job**

⚠️ Important:

- Runners are **stateless**
- After job finishes → runner is destroyed

## 4️⃣ Jobs: Units of Work

A **job**:

- Runs on **one runner**
- Contains multiple steps
- Can run in parallel with other jobs

### Internally:

- Each job gets its **own isolated runner**
- Jobs don’t share filesystem or memory
- Communication happens via:
  - Artifacts
  - Caches
  - Outputs

Example:

```text
Job A → ubuntu runner
Job B → ubuntu runner (different VM)
```

## 5️⃣ Steps: What Actually Runs

Steps are executed **top to bottom** inside a job.

Two types:

### 🟢 Run steps

```yaml
- run: npm test
```

Internally:

- GitHub opens a shell
- Runs the command
- Captures stdout/stderr
- Records exit code

Exit code ≠ 0 → ❌ step fails → job fails

### 🔵 Action steps

```yaml
- uses: actions/checkout@v4
```

Internally:

- GitHub downloads the action repo
- Executes it:
  - JavaScript action
  - Docker container
  - Composite steps

💡 Actions are just **reusable code**

## 6️⃣ Execution Order (Very Important)

### Inside a job:

```text
Step 1 → Step 2 → Step 3 → Stop if failure
```

### Between jobs:

- Default: parallel
- Controlled by `needs`

```yaml
job_b:
  needs: job_a
```

## 7️⃣ Secrets & Environment Variables

### Internally:

- Secrets are encrypted at rest
- Injected into runner **at runtime**
- Masked in logs (`***`)

```yaml
env:
  API_KEY: ${{ secrets.API_KEY }}
```

Secrets:

- Never written to disk
- Never visible in logs

## 8️⃣ Logs, Status, and Feedback

Internally GitHub:

- Streams logs in real time
- Stores logs for later viewing
- Marks:
  - Step status
  - Job status
  - Workflow status

This feeds into:

- PR checks
- Branch protection rules
- Notifications

# Advanced GitHub Actions & CI/CD Concepts

## 1️⃣ Dependency Graphs (DAG) & Job Orchestration

### What matters

- Jobs run **in parallel by default**
- Ordering is **explicit**, not implicit

### Key detail

```yaml
jobs:
  build:
  test:
    needs: build
  deploy:
    needs: [build, test]
```

Internally:

- GitHub builds a **DAG**
- Failure **short-circuits downstream jobs**

🔴 Common mistake: assuming job order = YAML order

---

## 2️⃣ Artifacts vs Cache (This Is Critical)

### Artifacts

- Move files **between jobs**
- Stored permanently (until retention expires)

```yaml
- uses: actions/upload-artifact@v4
```

Use for:

- Build outputs
- Test reports
- Binaries

---

### Cache

- Speed optimization only
- Not guaranteed to exist
- Key-based

```yaml
- uses: actions/cache@v4
```

Use for:

- `node_modules`
- `~/.m2`
- pip cache

🧠 Rule of thumb:

> **Artifacts = correctness** > **Cache = performance**

---

## 3️⃣ Runners Are Disposable (Design Implication)

### Advanced consequence

- You **must not rely on filesystem state**
- Everything needed must be:
  - Installed
  - Cached
  - Downloaded
  - Passed via artifact

💥 CI failures often come from hidden state assumptions.

---

## 4️⃣ Matrix Builds (Scale Without Duplication)

### Why this matters

- Multi-version testing
- Multi-OS testing
- Cost vs coverage tradeoffs

```yaml
strategy:
  matrix:
    node: [18, 20]
    os: [ubuntu-latest, windows-latest]
```

Internally:

- Each matrix combo = **separate job**
- Full isolation

⚠️ Matrices explode quickly → cost & time risk

---

## 5️⃣ Secrets, Environments & Trust Boundaries

### Key security rule

> **Never expose secrets to untrusted code**

#### Pull requests from forks:

- Secrets are **not injected**
- Write access is restricted

### Environments

```yaml
environment: production
```

Provides:

- Secret scoping
- Required reviewers
- Deployment history

💡 This is how you protect prod.

---

## 6️⃣ Reusable Workflows (Real-World Scale)

### Why important

- Avoid copy-paste pipelines
- Standardize CI across repos

```yaml
uses: org/ci/.github/workflows/build.yml@v1
```

Internally:

- Workflow is **expanded**
- Inputs & secrets passed explicitly

This is how large orgs run CI/CD.

---

## 7️⃣ Composite Actions vs Reusable Workflows

| Use case            | Choose            |
| ------------------- | ----------------- |
| Reusable step logic | Composite action  |
| Reusable pipelines  | Reusable workflow |

Composite actions:

- Run inside a job
- No jobs / runners

Reusable workflows:

- Full pipeline
- Own jobs & runners

---

## 8️⃣ Permissions Model (Often Missed)

### Default permissions are dangerous

```yaml
permissions:
  contents: read
```

Advanced practice:

- Least privilege per workflow
- Especially for:
  - `GITHUB_TOKEN`
  - Deployment workflows

💥 Security audits fail here often.

---

## 9️⃣ Concurrency & Race Conditions

### Problem

- Multiple deployments running at once
- Overwriting environments

### Solution

```yaml
concurrency:
  group: production
  cancel-in-progress: true
```

Internally:

- GitHub locks execution
- Cancels older runs

---

## 11️⃣ CI vs CD Separation (Design Principle)

**Good pipelines:**

- CI = fast, cheap, frequent
- CD = slow, gated, protected

Anti-pattern:

> Running deployment on every push to any branch

---

## 12️⃣ Cost Awareness (Often Ignored)

- Long-running jobs
- Self-hosted vs GitHub-hosted runners

Advanced teams:

- Fail fast
- Split workflows
- Cache aggressively

# Designing a Production-Grade CI/CD Pipeline

This is **not** a toy pipeline. This is how pipelines are designed for real products.

## 1️⃣ Core Design Principles (Non-Negotiable)

Before YAML, you decide these:

### ✅ Fast feedback

- CI must finish in minutes, not 30+
- Developers shouldn’t wait to learn they broke something

### ✅ Observable & debuggable

- Logs, artifacts, traceability

### Responsibilities

- Build once
- Tag version
- Produce artifact
- Upload artifact

🧠 **Golden rule**

> Build **once**, deploy **many**

### wrap up with an Exercise

1. **Create a workflow that validates all components in this repo** :

- [x] Runs PRs and can be manually triggered
- [x] Does not allow commit / code change in the repo
- [x] Run checks for:
  - `components/api` (must run `npm ci` + `npm run build`)
  - `components/core` (must run `npm ci` + `npm run build`)
  - `components/web` (must run `npm ci` + `npm run lint` + `npm run build`)

- [x] Prevents a job from hanging forever
- [x] Setup Node 20 via `actions/setup-node`
- [x] Speed up and Optimize the workflow by Caching project dependencies
- [x] Detect changes under:
  - `components/api/**`
  - `components/core/**`
  - `components/web/**`
- [x] Run CI only for changed packages

2. **Test API CI** :

- [x] Ensure all integration tests are passed before building the API component

- [x] Publish useful build outputs from CI runs. use `actions/upload-artifact@v4`

- [x] upload and display coverage report on PRs. it must fail for coverage < 60. use `irongut/CodeCoverageSummary@v1.3.0`

3. **Image Delivery** :

#### Phase 1 — Build & Push

- [ ] Build and push the API docker image to GHCR. use `docker/build-push-action@v6`
- [ ] Authenticate to GHCR using `docker/login-action@v3` with the `GITHUB_TOKEN`
- [ ] Tag the image with the **git SHA** (`github.sha`) and, on `main`, `latest`. use the `tags` input on `docker/metadata-action@v5`. When pushing per PR, add a **PR-specific tag** (e.g. `pr-<number>-<sha>`) so each PR deployment has a unique, pullable image
- [ ] Add OCI labels to the image (source repo, commit, description, license). use `docker/metadata-action@v5`
- [ ] **Push strategy — Deploy every PR and on merge to `main`:** (1) On **PRs**, push with tags like `pr-<number>-<sha>` for deployable preview images; (2) on **merge to `main`**, push with `sha` and `latest` for production. Use conditional logic (e.g. `docker/metadata-action` with different `tags` for PR vs main). Plan **cleanup** of PR-tagged images when PRs are closed (see Bonus).

#### Phase 2 — Optimization & Performance

- [ ] Speed up Docker builds in CI by caching layers. use the `cache-from` / `cache-to` inputs on `docker/build-push-action@v6` with `type=gha`

#### Phase 3 — Security & Quality Gates

- [ ] Scan the built image for vulnerabilities **before** pushing. use `aquasecurity/trivy-action@master` with `severity: CRITICAL,HIGH` and fail the workflow on findings
- [ ] After pushing, run the container in CI and verify the health endpoint responds (`curl --fail http://localhost:3001/health`). This is a basic smoke test
- [ ] Ensure the workflow uses **least-privilege permissions** — only grant `packages: write` and `contents: read`

#### Phase 4 — DRY & Orchestration

- [ ] Reduce duplication across workflows by extracting common setup (checkout, Node setup, npm cache) into a **composite action** under `.github/actions/setup-node/action.yml`
- [ ] Reduce duplication in the CI triggers and use **one single orchestration workflow** that detects which components changed and fans out jobs accordingly. use `dorny/paths-filter@v3`
- [ ] Make the image delivery job **depend on** the test and build jobs (`needs: [test-api, build-api]`) so images are only produced for passing builds

#### Phase 5 — Extending the Pipeline

- [ ] Create a `Dockerfile` for the **web** component (multi-stage: deps → build → production with `node:20-alpine` and `next start`)
- [ ] Add an image delivery job for the **web** component that mirrors the API pipeline (build, scan, tag, push to GHCR)
- [ ] Implement a **concurrency guard** so parallel pushes to `main` don't produce conflicting images. use the `concurrency` key with `cancel-in-progress: true`
- [ ] **Multi-platform builds:** Set up QEMU and Buildx to build for `linux/amd64` and `linux/arm64` so the image runs on both x86 and ARM (e.g. Apple Silicon, AWS Graviton). use `docker/setup-qemu-action@v3` and `docker/setup-buildx-action@v3`

#### Bonus — Going Further

- [ ] Add a **cleanup workflow** that deletes untagged / old GHCR images on a schedule (`on: schedule`). Also delete or expire **PR-tagged images** when the PR is closed/merged. use `actions/delete-package-versions@v5` or a workflow triggered by `pull_request` with `types: [closed]`
- [ ] Post a **deployment summary** as a PR comment after the image is pushed (image name, tag, size, vulnerability count). use `actions/github-script@v7`
- [ ] Build a **promotion workflow** triggered by `workflow_dispatch` that re-tags an existing image from `sha-xxx` to `staging` or `production` without rebuilding, using `docker buildx imagetools create`
