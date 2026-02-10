# Exercise 04: Case Statements

## Goal

Create a command dispatcher using case statements.

## Requirements

Create `dispatcher.sh` that:

1. Takes a command as first argument: `build`, `test`, `deploy`, or `help`
2. Uses a case statement to handle each command
3. For `build`: echo "Building application..."
4. For `test`: echo "Running tests..."
5. For `deploy`: echo "Deploying to production..."
6. For `help`: print usage information
7. For unknown commands: print error and exit 1

## Expected Behavior

```bash
./dispatcher.sh build
# Output: Building application...

./dispatcher.sh unknown
# Output: Error: Unknown command: unknown
#         Usage: dispatcher.sh {build|test|deploy|help}
# Exit code: 1

./dispatcher.sh help
# Output: Usage: dispatcher.sh {build|test|deploy|help}
#         Commands:
#           build  - Build the application
#           test   - Run tests
#           deploy - Deploy to production
#           help   - Show this help message
```

## Success Criteria

- Uses case statement
- Handles all specified commands
- Clear error messages for invalid input
- Help command shows all options
- Proper exit codes
