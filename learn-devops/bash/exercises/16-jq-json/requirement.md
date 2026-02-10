# Exercise 16: JSON Processing with jq

## Goal

Parse and manipulate JSON data using jq in CI/CD contexts.

## Requirements

Create `package.json`:

```json
{
  "name": "my-app",
  "version": "1.2.3",
  "scripts": {
    "build": "webpack",
    "test": "jest",
    "deploy": "node deploy.js"
  },
  "dependencies": {
    "express": "^4.18.0",
    "axios": "^1.4.0"
  },
  "devDependencies": {
    "jest": "^29.0.0",
    "webpack": "^5.88.0"
  }
}
```

Create `services.json`:

```json
[
  {
    "name": "api",
    "port": 3000,
    "status": "running",
    "version": "2.1.0"
  },
  {
    "name": "web",
    "port": 8080,
    "status": "running",
    "version": "1.5.2"
  },
  {
    "name": "worker",
    "port": 3001,
    "status": "stopped",
    "version": "1.0.0"
  }
]
```

Create `jq-exercises.sh` that:

1. Extracts version from package.json
2. Lists all script names
3. Gets all dependency names (production only)
4. Updates version to "1.3.0" and outputs modified JSON
5. From services.json:
   - Lists all running services
   - Extracts service names only
   - Finds services with version >= "2.0.0"
   - Converts to CSV format: name,port,status
   - Creates object with service names as keys and ports as values

## Expected Output

```bash
./jq-exercises.sh

=== Package Version ===
1.2.3

=== Script Names ===
build
test
deploy

=== Dependencies ===
express
axios

=== Updated Version ===
{
  "name": "my-app",
  "version": "1.3.0",
  ...
}

=== Running Services ===
api
web

=== Service Names ===
["api", "web", "worker"]

=== Services v2+ ===
api (2.1.0)

=== CSV Format ===
name,port,status
api,3000,running
web,8080,running
worker,3001,stopped

=== Port Mapping ===
{
  "api": 3000,
  "web": 8080,
  "worker": 3001
}
```

## Success Criteria

- Correct jq queries
- Array and object manipulation
- Filtering works
- Output formatting (raw vs JSON)
- Complex transformations
