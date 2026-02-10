# Exercise 03: Conditionals (if/else)

## Goal

Create a validation script using if/else conditionals.

## Requirements

Create `validate-env.sh` that:

1. Checks if `NODE_ENV` environment variable is set
2. If not set, print error and exit with code 1
3. If set, validate it's one of: `development`, `staging`, `production`
4. Print appropriate message for valid/invalid values
5. Exit with 0 for valid, 1 for invalid

## Expected Behavior

```bash
# No NODE_ENV set
./validate-env.sh
# Output: Error: NODE_ENV is not set
# Exit code: 1

# Valid value
NODE_ENV=production ./validate-env.sh
# Output: ✓ Valid environment: production
# Exit code: 0

# Invalid value
NODE_ENV=test ./validate-env.sh
# Output: ✗ Invalid environment: test. Must be development, staging, or production
# Exit code: 1
```

## Success Criteria

- Checks if variable is set
- Validates against allowed values
- Clear error messages
- Proper exit codes
- Uses `[[ ]]` for tests
