# Exercise 01: Variables and Quoting

## Goal

Create a script that demonstrates proper variable handling and quoting.

## Requirements

Create `variables.sh` that:

1. Declares variables for name, version, and environment
2. Uses command substitution to capture current date
3. Demonstrates the difference between single and double quotes
4. Shows proper variable quoting in echo statements
5. Uses variable expansion `${var}` syntax

## Expected Output

```
Name: my-app
Version: 1.0.0
Environment: production
Date: 2026-02-04
Single quotes: $name
Double quotes: my-app
Unquoted spaces: one two three
Quoted spaces: one two three
```

## Success Criteria

- Script runs without errors
- All variables are properly quoted
- Demonstrates understanding of quote types
- Uses `${var}` expansion syntax
