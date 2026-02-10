# Exercise 14: Text Transformation with sed

## Goal

Use sed for text editing and transformation tasks.

## Requirements

Create `config.template`:

```
APP_NAME=placeholder
APP_ENV=development
APP_PORT=3000
APP_HOST=localhost
# Comment line
DEBUG=true
```

Create `sed-exercises.sh` that:

1. Replaces "placeholder" with "myapp" in config.template
2. Changes APP_ENV from "development" to "production"
3. Deletes all comment lines (starting with #)
4. Adds "APP_VERSION=1.0.0" after APP_NAME line
5. Prints lines 2-4 only
6. Converts all variable names to lowercase
7. Saves final result to `config.env`

Create `logs.txt`:

```
[2026-02-04] User: john logged in
[2026-02-04] User: jane logged out
[2026-02-04] User: bob failed login
```

Create `anonymize.sh` that:

1. Uses sed to replace all usernames with "\*\*\*"
2. Changes dates to "REDACTED"
3. Outputs anonymized version

## Expected Output

```bash
./sed-exercises.sh
# Creates config.env with transformed content:
app_name=myapp
app_version=1.0.0
app_env=production
app_port=3000
app_host=localhost
debug=true

./anonymize.sh logs.txt
[REDACTED] User: *** logged in
[REDACTED] User: *** logged out
[REDACTED] User: *** failed login
```

## Success Criteria

- All sed transformations work correctly
- In-place editing understood
- Pattern matching and substitution
- Line insertion and deletion
- Multiple sed operations chained
