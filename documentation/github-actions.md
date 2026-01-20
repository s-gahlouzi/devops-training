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

## Common Beginner Misconceptions

❌ “My runner remembers previous runs”
✅ Every run is **clean**

❌ “Jobs share files automatically”
✅ They don’t — use artifacts

❌ “Actions are magic”
✅ Actions are just scripts

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

## 🔟 Failure Handling & Observability

### Advanced patterns

```yaml
- run: risky_command
  continue-on-error: true
```

```yaml
if: failure()
```

- Partial success pipelines
- Always-run cleanup jobs
- Notifications on failure

---

## 11️⃣ CI vs CD Separation (Design Principle)

**Good pipelines:**

- CI = fast, cheap, frequent
- CD = slow, gated, protected

Anti-pattern:

> Running deployment on every push to any branch

---

## 12️⃣ Cost Awareness (Often Ignored)

- Matrix explosion
- Long-running jobs
- Self-hosted vs GitHub-hosted runners

Advanced teams:

- Fail fast
- Split workflows
- Cache aggressively

# Designing a Production-Grade CI/CD Pipeline

This is **not** a toy pipeline. This is how pipelines are designed for real products.

---

## 1️⃣ Core Design Principles (Non-Negotiable)

Before YAML, you decide these:

### ✅ Fast feedback

- CI must finish in minutes, not 30+
- Developers shouldn’t wait to learn they broke something

### ✅ Clear trust boundaries

- Untrusted code ≠ access to secrets
- Production deploys must be protected

### ✅ Deterministic & reproducible

- Same input → same output
- No hidden state

### ✅ Observable & debuggable

- Logs, artifacts, traceability

---

## 2️⃣ Pipeline Stages (High-Level Architecture)

```text
PR → CI → Merge
          ↓
      Main branch
          ↓
        Build
          ↓
       Deploy
```

### Logical separation

| Stage  | Responsibility             |
| ------ | -------------------------- |
| PR CI  | Code quality & correctness |
| Build  | Produce immutable artifact |
| Deploy | Release artifact to env    |

---

## 3️⃣ CI (Pull Request) Pipeline

### Trigger

```yaml
on:
  pull_request:
```

### What runs here

- Lint
- Unit tests
- Type checks
- Lightweight security checks

### What does NOT run

- Deployments
- Heavy E2E
- Production secrets

### Why

- PRs may come from forks
- Fast feedback only

---

## 4️⃣ Build Pipeline (Main Branch Only)

### Trigger

```yaml
on:
  push:
    branches: [main]
```

### Responsibilities

- Build once
- Tag version
- Produce artifact
- Upload artifact

🧠 **Golden rule**

> Build **once**, deploy **many**

Artifacts:

- Docker images
- ZIP bundles
- Binaries

---

## 5️⃣ Deployment Pipelines (Environment-Based)

### Environments

- `staging`
- `production`

```yaml
environment:
  name: production
```

Each environment:

- Has scoped secrets
- Can require approvals
- Has deployment history

---

## 6️⃣ Promotion Strategy (This Is Key)

❌ Anti-pattern:

> Rebuild separately for staging and prod

✅ Correct pattern:

```text
Artifact → Staging → Production
```

Same artifact hash everywhere.

---

## 7️⃣ Example High-Level Workflow Layout

```text
ci.yml              → PR checks
build.yml           → main branch build
deploy-staging.yml  → auto
deploy-prod.yml     → gated
```

Each workflow has:

- Minimal permissions
- Single responsibility

---

## 8️⃣ Failure Handling & Safety Nets

### Required

- Fail fast
- Automatic rollback (if possible)
- Concurrency locks on deploy

```yaml
concurrency:
  group: production
```

---

## 9️⃣ Security Hardening (Often Missed)

- Explicit permissions
- No secrets in CI
- Environment-protected deployments
- Dependency pinning

```yaml
permissions:
  contents: read
```

---

# PART 2: How Big Companies Structure GitHub Actions

This is where scale changes everything.

---

## 1️⃣ Monorepo vs Multirepo Reality

### Monorepo

- Path-based triggers
- Selective workflows
- Shared pipelines

```yaml
on:
  push:
    paths:
      - services/api/**
```

---

### Multirepo

- Centralized CI templates
- Reusable workflows
- Strict standards

---

## 2️⃣ Central CI Platform Repo

Big companies usually have:

```text
org-ci/
 └── .github/workflows/
     ├── node-ci.yml
     ├── docker-build.yml
     └── deploy.yml
```

Used like:

```yaml
uses: org/org-ci/.github/workflows/node-ci.yml@v3
```

Benefits:

- Governance
- Consistency
- Easy updates

---

## 3️⃣ Reusable Workflows + Thin Repos

Application repos:

```yaml
uses: org/ci/.github/workflows/service.yml@v1
with:
  service_name: api
```

App teams don’t write CI logic.

---

## 4️⃣ Self-Hosted Runners at Scale

Why big companies use them:

- Cost control
- Custom tooling
- Network access
- Faster builds

Advanced setup:

- Autoscaling runners
- Ephemeral VMs
- Per-team isolation

---

## 5️⃣ Permissions & Compliance

Enterprise setups enforce:

- Org-level permissions
- Restricted actions
- Required approvals
- Audit logs

Security teams **care deeply** about this.

---

## 6️⃣ Observability & Metrics

They track:

- Pipeline duration
- Failure rate
- Flaky tests
- Cost per pipeline

CI/CD is treated as **production infrastructure**.

---

## 7️⃣ Release Strategy Patterns

Common patterns:

- Trunk-based development
- Feature flags
- Progressive rollout
- Canary deploys

CI/CD integrates with:

- Monitoring
- Alerting
- Incident response

---

## 8️⃣ What Juniors vs Seniors Miss

| Juniors          | Seniors                       |
| ---------------- | ----------------------------- |
| “Pipeline works” | “Pipeline is safe & scalable” |
| YAML focus       | System design                 |
| Fast once        | Fast always                   |
| Local fix        | Platform solution             |

---
