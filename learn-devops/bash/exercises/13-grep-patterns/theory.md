# Theory: grep

## Basic Usage

```bash
grep "pattern" file         # Search in file
grep "pattern" file1 file2  # Multiple files
grep -r "pattern" dir/      # Recursive search
```

## Common Flags

```bash
-i          # Case-insensitive
-v          # Invert match (lines NOT matching)
-c          # Count matching lines
-n          # Show line numbers
-l          # Show only filenames
-L          # Show files without match
-o          # Show only matching part
-w          # Match whole word
-x          # Match whole line
-A 3        # Show 3 lines after match
-B 3        # Show 3 lines before match
-C 3        # Show 3 lines context (before and after)
-E          # Extended regex (same as egrep)
-P          # Perl regex
-q          # Quiet mode (exit code only)
```

## Patterns

**Literal:**

```bash
grep "error" file
```

**Basic regex:**

```bash
grep "^ERROR" file          # Lines starting with ERROR
grep "error$" file          # Lines ending with error
grep "e.r" file             # . matches any char
grep "colou\?r" file        # Optional u
grep "[0-9]" file           # Any digit
grep "[a-z]" file           # Any lowercase letter
```

**Extended regex (-E):**

```bash
grep -E "error|warning" file    # OR
grep -E "fail(ed|ure)" file     # Groups
grep -E "[0-9]+" file           # One or more digits
grep -E "[0-9]{3}" file         # Exactly 3 digits
grep -E "^(INFO|ERROR)" file    # Start with INFO or ERROR
```

## Common Patterns

**IP addresses:**

```bash
grep -E "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}" file
```

**Email addresses:**

```bash
grep -E "[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}" file
```

**URLs:**

```bash
grep -E "https?://[^ ]+" file
```

**Dates (YYYY-MM-DD):**

```bash
grep -E "[0-9]{4}-[0-9]{2}-[0-9]{2}" file
```

## Combine with Other Commands

**Count unique values:**

```bash
grep -o "pattern" file | sort | uniq
```

**Case-insensitive unique:**

```bash
grep -io "pattern" file | sort -u
```

**Find files with pattern:**

```bash
grep -l "pattern" *.txt
```

**Filter then process:**

```bash
grep "ERROR" app.log | awk '{print $1, $2}'
```

## Exit Codes

- `0` = Pattern found
- `1` = Pattern not found
- `2` = Error occurred

```bash
if grep -q "ERROR" file; then
    echo "Errors found"
fi
```

## Real-World Examples

**Find errors in logs:**

```bash
grep -i "error\|fail\|exception" app.log
```

**Extract IPs from logs:**

```bash
grep -oE "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}" access.log | sort -u
```

**Count HTTP status codes:**

```bash
grep -oE "HTTP/[0-9.]+ [0-9]{3}" access.log | awk '{print $2}' | sort | uniq -c
```

**Find TODO comments:**

```bash
grep -rn "TODO\|FIXME" src/
```

**Show errors with context:**

```bash
grep -C 2 "ERROR" app.log
```

## Performance Tips

1. Use `-F` for literal strings (faster)
2. Use `-q` when you only need exit code
3. Filter early in pipelines
4. Use `--include` or `--exclude` for file types
5. Avoid `-r` on large directories, use `find` instead

## Alternatives

- `ripgrep` (rg) - Faster, respects .gitignore
- `ag` (silver searcher) - Fast code search
- `ack` - Perl-based grep alternative
