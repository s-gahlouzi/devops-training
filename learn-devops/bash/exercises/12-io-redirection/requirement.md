# Exercise 12: Input/Output Redirection

## Goal

Master I/O redirection, pipes, here-docs, and process substitution.

## Requirements

Create `log-processor.sh` that:

1. Reads from stdin or file (if provided as argument)
2. Separates errors and info messages to different files:
   - Lines starting with `ERROR:` → `errors.log`
   - Lines starting with `INFO:` → `info.log`
   - Other lines → `other.log`
3. Counts messages of each type
4. Prints summary to stderr
5. Returns exit code 1 if any errors found, 0 otherwise

Create `test-input.txt` with sample log lines:

```
INFO: Application started
ERROR: Database connection failed
INFO: Retry attempt 1
ERROR: Retry failed
DEBUG: Memory usage: 45%
INFO: Shutting down
```

Create `report-generator.sh` that:

1. Uses a here-doc to generate an HTML report
2. Variables: title, date, status
3. Outputs to `report.html`

## Expected Behavior

```bash
./log-processor.sh test-input.txt
# stderr: Summary: 3 info, 2 errors, 1 other
# Exit code: 1
# Creates: errors.log, info.log, other.log

cat test-input.txt | ./log-processor.sh
# Same behavior, reading from stdin

./report-generator.sh "Build Report" "2026-02-04" "SUCCESS"
# Creates: report.html
```

## Success Criteria

- Stdin and file input both work
- Output redirection to multiple files
- Stderr used for summary
- Here-doc with variable expansion
- Proper exit codes
