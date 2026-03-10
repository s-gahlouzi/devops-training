# GitHub Actions & CI/CD Quiz

Test your understanding of CI/CD concepts and GitHub Actions internals.

---

## Section 1: CI/CD Fundamentals

**Q1.** What does CI/CD stand for?

- A) Code Integration / Code Deployment
- B) Continuous Integration / Continuous Delivery (or Deployment)
- C) Central Infrastructure / Central Distribution
- D) Continuous Inspection / Continuous Distribution

<details><summary>Answer</summary>B</details>

---

**Q2.** What is the main difference between **Continuous Delivery** and **Continuous Deployment**?

- A) Continuous Delivery is faster
- B) Continuous Deployment requires manual approval; Continuous Delivery does not
- C) Continuous Delivery requires manual approval; Continuous Deployment is fully automatic
- D) There is no difference

<details><summary>Answer</summary>C — Continuous Delivery means the code is always *ready* to deploy but may require a manual step. Continuous Deployment automatically deploys every successful change.</details>

---

**Q3.** Which of the following is **NOT** a typical CI step?

- A) Installing dependencies
- B) Running tests
- C) Deploying to production
- D) Building the project

<details><summary>Answer</summary>C — Deploying to production is a CD concern, not CI.</details>

---

**Q4.** True or False: In CI, if the pipeline fails, you should fix the issue **before** merging.

<details><summary>Answer</summary>True</details>

---

**Q5.** Match each concept to its description:

| Concept               | Description |
| --------------------- | ----------- |
| CI                    | \_\_\_      |
| Continuous Delivery   | \_\_\_      |
| Continuous Deployment | \_\_\_      |

Options:

- A) Deploy automatically on every successful change
- B) Test & validate code on every change
- C) Prepare code for deployment (may require manual approval)

<details><summary>Answer</summary>CI → B, Continuous Delivery → C, Continuous Deployment → A</details>

---

## Section 2: GitHub Actions Core Concepts

**Q6.** What is the correct mental model for how GitHub Actions works?

- A) Developer → Deploy → Test → Build
- B) Event → Workflow → Runner → Job → Steps → Result
- C) Push → Merge → Release
- D) YAML → JSON → Execution

<details><summary>Answer</summary>B</details>

---

**Q7.** Where must workflow files be placed in your repository?

- A) `.actions/workflows/`
- B) `.github/actions/`
- C) `.github/workflows/`
- D) `workflows/`

<details><summary>Answer</summary>C</details>

---

**Q8.** List the five key concepts of GitHub Actions:

1. ***
2. ***
3. ***
4. ***
5. ***

<details><summary>Answer</summary>Workflow, Job, Step, Action, Runner</details>

---

**Q9.** What is a **Runner**?

- A) A YAML configuration file
- B) A virtual machine or container that executes jobs
- C) A GitHub API endpoint
- D) A type of webhook

<details><summary>Answer</summary>B</details>

---

**Q10.** True or False: GitHub-hosted runners retain state between jobs.

<details><summary>Answer</summary>False — Runners are stateless. After a job finishes, the runner is destroyed.</details>

---

## Section 3: Events & Triggers

**Q11.** GitHub Actions is described as:

- A) Schedule-driven
- B) Event-driven
- C) Polling-driven
- D) Manual-only

<details><summary>Answer</summary>B</details>

---

**Q12.** Which event allows you to **manually trigger** a workflow from the GitHub UI?

- A) `manual_trigger`
- B) `push`
- C) `workflow_dispatch`
- D) `on_demand`

<details><summary>Answer</summary>C</details>

---

**Q13.** Name at least 3 events that can trigger a GitHub Actions workflow.

<details><summary>Answer</summary>Any 3 of: push, pull_request, release, workflow_dispatch, schedule, issues, etc.</details>

---

## Section 4: Jobs & Steps

**Q14.** By default, how do jobs in a workflow execute?

- A) Sequentially, in YAML order
- B) In parallel
- C) One at a time, alphabetically
- D) Randomly

<details><summary>Answer</summary>B — Jobs run in parallel by default. Use `needs` to define ordering.</details>

---

**Q15.** What keyword controls the order of job execution?

- A) `depends_on`
- B) `after`
- C) `needs`
- D) `requires`

<details><summary>Answer</summary>C</details>

---

**Q16.** Given this configuration, what is the execution order?

```yaml
jobs:
  build:
  test:
    needs: build
  deploy:
    needs: [build, test]
```

- A) build → deploy → test
- B) All run in parallel
- C) build → test → deploy
- D) test → build → deploy

<details><summary>Answer</summary>C — `test` waits for `build`, then `deploy` waits for both `build` and `test`.</details>

---

**Q17.** True or False: Steps within a job run in parallel.

<details><summary>Answer</summary>False — Steps execute top to bottom, sequentially.</details>

---

**Q18.** What are the two types of steps?

- A) `build` steps and `deploy` steps
- B) `run` steps and `action` steps (using `uses`)
- C) `script` steps and `command` steps
- D) `inline` steps and `external` steps

<details><summary>Answer</summary>B</details>

---

**Q19.** What happens when a `run` step returns a non-zero exit code?

- A) The step is retried
- B) The step is skipped
- C) The step fails, causing the job to fail
- D) Nothing, execution continues

<details><summary>Answer</summary>C</details>

---

**Q20.** True or False: Each job runs on its own isolated runner, so jobs do **not** share filesystem or memory.

<details><summary>Answer</summary>True</details>

---

## Section 5: Artifacts vs Cache

**Q21.** What is the key difference between **artifacts** and **cache**?

- A) Artifacts are faster than cache
- B) Artifacts ensure correctness (pass files between jobs); cache improves performance (speed up installs)
- C) Cache is more reliable than artifacts
- D) There is no difference

<details><summary>Answer</summary>B — Artifacts = correctness, Cache = performance.</details>

---

**Q22.** Which action is used to upload artifacts?

- A) `actions/cache@v4`
- B) `actions/upload-artifact@v4`
- C) `actions/store@v4`
- D) `actions/save-artifact@v4`

<details><summary>Answer</summary>B</details>

---

**Q23.** True or False: Cache is **guaranteed** to exist on every run.

<details><summary>Answer</summary>False — Cache is not guaranteed to exist; it's a speed optimization only.</details>

---

**Q24.** Which of these should use **cache** and which should use **artifacts**?

| Item                | Cache or Artifact? |
| ------------------- | ------------------ |
| `node_modules`      | \_\_\_             |
| Build output binary | \_\_\_             |
| Test report HTML    | \_\_\_             |
| pip cache           | \_\_\_             |

<details><summary>Answer</summary>node_modules → Cache, Build output binary → Artifact, Test report HTML → Artifact, pip cache → Cache</details>

---

## Section 6: Matrix Builds

**Q25.** What does a matrix strategy do?

- A) Runs the same job multiple times with different parameter combinations
- B) Creates a single combined environment
- C) Merges multiple workflows
- D) Parallelizes steps within a job

<details><summary>Answer</summary>A</details>

---

**Q26.** Given this matrix, how many jobs will be created?

```yaml
strategy:
  matrix:
    node: [18, 20]
    os: [ubuntu-latest, windows-latest]
```

- A) 2
- B) 3
- C) 4
- D) 8

<details><summary>Answer</summary>C — 2 node versions × 2 OS = 4 jobs.</details>

---

**Q27.** True or False: Each combination in a matrix runs on the same shared runner.

<details><summary>Answer</summary>False — Each combination gets its own isolated runner.</details>

---

## Section 7: Secrets & Security

**Q28.** How do you reference a secret named `API_KEY` in a workflow?

- A) `$API_KEY`
- B) `${{ secrets.API_KEY }}`
- C) `${{ env.API_KEY }}`
- D) `secrets.API_KEY`

<details><summary>Answer</summary>B</details>

---

**Q29.** What happens to secret values in workflow logs?

- A) They are displayed in plain text
- B) They are masked with `***`
- C) They are base64-encoded
- D) They are omitted entirely

<details><summary>Answer</summary>B</details>

---

**Q30.** True or False: Secrets are injected into workflows triggered by pull requests from **forks**.

<details><summary>Answer</summary>False — Secrets are NOT injected for PRs from forks for security reasons.</details>

---

**Q31.** What does the `environment` keyword provide? (Select all that apply)

- A) Secret scoping
- B) Required reviewers before deployment
- C) Automatic rollback
- D) Deployment history

<details><summary>Answer</summary>A, B, D</details>

---

## Section 8: Permissions

**Q32.** What is the recommended security practice for `GITHUB_TOKEN` permissions?

- A) Grant full access to everything
- B) Use least privilege — only grant what the workflow needs
- C) Disable `GITHUB_TOKEN` entirely
- D) Use personal access tokens instead

<details><summary>Answer</summary>B</details>

---

**Q33.** Fill in the YAML to restrict a workflow to **read-only** content access:

```yaml
permissions:
  contents: ___
```

<details><summary>Answer</summary>`read`</details>

---

## Section 9: Concurrency

**Q34.** What problem does the `concurrency` keyword solve?

- A) Slow builds
- B) Multiple deployments running at once and overwriting each other
- C) Missing dependencies
- D) Large artifacts

<details><summary>Answer</summary>B</details>

---

**Q35.** What does `cancel-in-progress: true` do?

- A) Cancels the current run
- B) Cancels older runs in the same concurrency group when a new one starts
- C) Prevents any future runs
- D) Pauses the workflow

<details><summary>Answer</summary>B</details>

---

## Section 10: Reusable Workflows & Composite Actions

**Q36.** What is the difference between a **composite action** and a **reusable workflow**?

- A) They are the same thing
- B) Composite actions run inside a job (no own runner); reusable workflows have their own jobs and runners
- C) Reusable workflows are faster
- D) Composite actions can only run shell commands

<details><summary>Answer</summary>B</details>

---

**Q37.** Match the use case to the right approach:

| Use case                          | Composite Action or Reusable Workflow? |
| --------------------------------- | -------------------------------------- |
| Reusable step logic (e.g., setup) | \_\_\_                                 |
| Reusable full pipeline            | \_\_\_                                 |

<details><summary>Answer</summary>Reusable step logic → Composite Action, Reusable full pipeline → Reusable Workflow</details>

---

**Q38.** How do you call a reusable workflow from another repo?

```yaml
uses: ___
```

<details><summary>Answer</summary>`org/repo/.github/workflows/workflow.yml@version` (e.g., `org/ci/.github/workflows/build.yml@v1`)</details>

---

## Section 11: Design Principles

**Q39.** What is the "golden rule" of production CI/CD pipelines?

- A) Test everything manually
- B) Build once, deploy many
- C) Deploy first, test later
- D) Use one runner for all jobs

<details><summary>Answer</summary>B</details>

---

**Q40.** Which of the following is an **anti-pattern**?

- A) Caching dependencies
- B) Running deployment on every push to any branch
- C) Using matrix builds for multi-version testing
- D) Separating CI and CD stages

<details><summary>Answer</summary>B</details>

---

**Q41.** True or False: CI should be fast and cheap; CD should be gated and protected.

<details><summary>Answer</summary>True</details>

---

**Q42.** Why should you NOT rely on filesystem state in CI?

- A) File systems are read-only
- B) Runners are disposable and destroyed after each job — no state persists
- C) GitHub Actions doesn't support file operations
- D) Files are encrypted

<details><summary>Answer</summary>B</details>

---

## Section 12: Scenario-Based Questions

**Q43.** Your CI workflow takes 45 minutes. Name two strategies to speed it up.

<details><summary>Answer</summary>Any 2 of: Cache dependencies, fail fast, split workflows, use matrix builds to parallelize, only run CI for changed packages.</details>

---

**Q44.** You need to pass a built binary from a `build` job to a `deploy` job. What mechanism should you use and why?

<details><summary>Answer</summary>Artifacts (via `actions/upload-artifact` and `actions/download-artifact`), because jobs run on separate runners and don't share a filesystem. Artifacts ensure correctness when passing files between jobs.</details>

---

**Q45.** A teammate's PR from a fork fails because the workflow can't access `secrets.DEPLOY_KEY`. Why?

<details><summary>Answer</summary>Secrets are not injected into workflows triggered by pull requests from forks. This is a security boundary to prevent untrusted code from accessing secrets.</details>

---

**Q46.** Two developers push to `main` simultaneously and both trigger a deploy workflow. What could go wrong, and how do you prevent it?

<details><summary>Answer</summary>Both deployments could run at once and overwrite each other (race condition). Prevent it using the `concurrency` keyword with a group name and `cancel-in-progress: true`.</details>

---

**Q47.** You have 10 repositories that all need the same CI pipeline. What GitHub Actions feature should you use?

<details><summary>Answer</summary>Reusable Workflows — define the pipeline once in a central repo and reference it from all 10 repositories.</details>

---

## Scoring

| Score | Level         |
| ----- | ------------- |
| 40-47 | Expert        |
| 30-39 | Proficient    |
| 20-29 | Intermediate  |
| 10-19 | Beginner      |
| 0-9   | Review needed |
