# Theory: sed (Stream Editor)

## Basic Syntax

```bash
sed 's/pattern/replacement/' file      # Replace first occurrence
sed 's/pattern/replacement/g' file     # Replace all occurrences
sed -i 's/pattern/replacement/g' file  # In-place edit
```

## Substitution

```bash
# Basic
sed 's/old/new/' file

# Global (all occurrences per line)
sed 's/old/new/g' file

# Case-insensitive
sed 's/old/new/gi' file
sed 's/old/new/gI' file

# Only nth occurrence
sed 's/old/new/2' file        # Replace 2nd occurrence

# From nth to end
sed 's/old/new/2g' file       # Replace from 2nd onward
```

## Addressing

```bash
# Specific line
sed '3s/old/new/' file        # Line 3 only

# Range of lines
sed '2,5s/old/new/' file      # Lines 2-5
sed '2,$s/old/new/' file      # Line 2 to end

# Pattern matching
sed '/pattern/s/old/new/' file    # Only lines matching pattern
sed '/start/,/end/s/old/new/' file  # Between patterns
```

## Deletion

```bash
sed 'd' file                  # Delete all lines
sed '3d' file                 # Delete line 3
sed '2,5d' file               # Delete lines 2-5
sed '/pattern/d' file         # Delete lines matching pattern
sed '/^$/d' file              # Delete empty lines
sed '/^#/d' file              # Delete comments
```

## Insertion and Appending

```bash
# Insert before line
sed '3i\New line' file        # Insert before line 3

# Append after line
sed '3a\New line' file        # Append after line 3

# Insert before pattern
sed '/pattern/i\New line' file

# Append after pattern
sed '/pattern/a\New line' file
```

## Print

```bash
sed -n 'p' file               # Print all (with -n)
sed -n '2,5p' file            # Print lines 2-5
sed -n '/pattern/p' file      # Print matching lines
```

## Multiple Commands

```bash
# Semicolon
sed 's/old/new/g; s/foo/bar/g' file

# -e flag
sed -e 's/old/new/g' -e 's/foo/bar/g' file

# Multiple lines
sed '
  s/old/new/g
  s/foo/bar/g
' file
```

## Capture Groups

```bash
# Backreferences
sed 's/\(pattern\)/\1-modified/' file
sed 's/\([0-9]\+\)/[\1]/' file

# Extended regex (-E or -r)
sed -E 's/([0-9]+)/[\1]/' file
sed -E 's/(ERROR|WARNING)/[\1]/' file
```

## Special Characters

```bash
^       # Start of line
$       # End of line
.       # Any character
*       # Zero or more
\+      # One or more (basic regex)
+       # One or more (extended regex)
\?      # Optional (basic regex)
?       # Optional (extended regex)
[...]   # Character class
\(...\) # Capture group (basic regex)
(...)   # Capture group (extended regex)
```

## In-Place Editing

```bash
# With backup
sed -i.bak 's/old/new/g' file    # Creates file.bak

# Without backup (Linux)
sed -i 's/old/new/g' file

# Without backup (macOS)
sed -i '' 's/old/new/g' file
```

## Real-World Examples

**Remove trailing whitespace:**

```bash
sed 's/[[:space:]]*$//' file
```

**Add prefix to non-empty lines:**

```bash
sed '/^$/!s/^/PREFIX: /' file
```

**Convert to lowercase:**

```bash
echo "HELLO" | sed 's/.*/\L&/'
```

**Remove HTML tags:**

```bash
sed 's/<[^>]*>//g' file
```

**Extract between patterns:**

```bash
sed -n '/START/,/END/p' file
```

**Comment out lines:**

```bash
sed 's/^/# /' file
```

**Uncomment lines:**

```bash
sed 's/^# //' file
```

**Replace with environment variable:**

```bash
sed "s/PORT/$PORT/g" file
```

**CSV to TSV:**

```bash
sed 's/,/\t/g' file.csv
```

## Performance Tips

1. Use `sed` for stream processing, not just substitution
2. Combine multiple operations in one command
3. Use `-n` with `p` to print specific lines (faster than grep sometimes)
4. For simple substitution, parameter expansion might be faster
5. For complex operations, consider `awk` or `perl`

## Common Pitfalls

1. Forgetting `g` flag (only replaces first occurrence)
2. Not escaping special characters in patterns
3. Using `-i` without testing first
4. macOS vs Linux `-i` syntax differences
5. Not quoting expressions with shell variables
