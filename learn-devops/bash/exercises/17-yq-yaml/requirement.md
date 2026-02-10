# Exercise 17: YAML Processing with yq

## Goal

Parse and manipulate YAML configuration files (common in CI/CD).

## Requirements

Create `config.yml`:

```yaml
app:
  name: my-application
  version: 1.0.0
  environment: development

server:
  host: localhost
  port: 3000
  timeout: 30

database:
  host: db.example.com
  port: 5432
  name: myapp_db
  pool:
    min: 2
    max: 10

services:
  - name: api
    enabled: true
    replicas: 2
  - name: worker
    enabled: false
    replicas: 1
  - name: cache
    enabled: true
    replicas: 1
```

Create `github-workflow.yml`:

```yaml
name: CI
on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Build
        run: npm run build

  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Test
        run: npm test
```

Create `yq-exercises.sh` that:

1. Extracts app version
2. Gets database connection string parts (host, port, name)
3. Lists all enabled services
4. Updates server port to 8080
5. Adds new service to services array
6. Converts config.yml to JSON
7. Extracts all job names from github-workflow.yml
8. Counts number of steps in each job

## Expected Output

```bash
./yq-exercises.sh

=== App Version ===
1.0.0

=== Database Config ===
Host: db.example.com
Port: 5432
Name: myapp_db

=== Enabled Services ===
api
cache

=== Updated Port (output only, not saved) ===
server:
  host: localhost
  port: 8080
  ...

=== With New Service ===
services:
  - name: api
    ...
  - name: metrics
    enabled: true
    replicas: 1

=== As JSON ===
{
  "app": {
    "name": "my-application",
    ...
  }
}

=== Workflow Jobs ===
build
test

=== Job Steps ===
build: 2 steps
test: 2 steps
```

## Success Criteria

- Correct yq queries
- Nested path navigation
- Array filtering
- Modifications work
- YAML to JSON conversion
- GitHub Actions workflow parsing
