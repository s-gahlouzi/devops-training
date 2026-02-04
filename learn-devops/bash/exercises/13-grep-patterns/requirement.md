# Exercise 13: Text Processing with grep

## Goal

Use grep for pattern matching and text filtering.

## Requirements

Create sample `app.log` with content:

```
2026-02-04 10:00:01 INFO User login: user123
2026-02-04 10:00:15 ERROR Failed to connect to database
2026-02-04 10:00:16 INFO Retry attempt 1
2026-02-04 10:00:17 ERROR Connection timeout
2026-02-04 10:00:20 WARN High memory usage: 85%
2026-02-04 10:00:25 INFO Successfully connected
2026-02-04 10:01:00 ERROR Invalid token
2026-02-04 10:01:05 INFO Request processed
```

Create `grep-exercises.sh` that:

1. Extracts all ERROR lines
2. Extracts all lines from 10:00:15 to 10:00:25 (inclusive)
3. Counts number of ERROR and WARN messages
4. Finds all lines with numbers greater than 80
5. Extracts unique log levels (INFO, ERROR, WARN)
6. Shows lines NOT containing "ERROR"
7. Case-insensitive search for "user"

## Expected Output

```bash
./grep-exercises.sh

=== All Errors ===
2026-02-04 10:00:15 ERROR Failed to connect to database
2026-02-04 10:00:17 ERROR Connection timeout
2026-02-04 10:01:00 ERROR Invalid token

=== Time Range 10:00:15 to 10:00:25 ===
(lines in that time range)

=== Error Count ===
Errors: 3
Warnings: 1

=== Lines with numbers > 80 ===
2026-02-04 10:00:20 WARN High memory usage: 85%

=== Unique Log Levels ===
ERROR
INFO
WARN

=== Non-error Lines ===
(all lines without ERROR)

=== User Mentions (case-insensitive) ===
2026-02-04 10:00:01 INFO User login: user123
```

## Success Criteria

- Uses grep for all searches
- Correct regex patterns
- Proper use of grep flags (-i, -v, -o, -c, etc.)
- Handles extended regex where needed
