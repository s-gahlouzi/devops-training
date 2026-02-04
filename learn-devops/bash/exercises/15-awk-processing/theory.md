# Theory: awk

## Basic Syntax

```bash
awk 'pattern {action}' file
awk '{print $1}' file          # Print first column
awk -F: '{print $1}' file      # Custom delimiter
```

## Built-in Variables

```bash
$0      # Entire line
$1      # First field
$2      # Second field
$NF     # Last field
$(NF-1) # Second to last field
NR      # Current line number
NF      # Number of fields in current line
FS      # Field separator (input)
OFS     # Output field separator
RS      # Record separator (input)
ORS     # Output record separator
```

## Field Separator

```bash
awk -F: '{print $1}' file      # Colon separator
awk -F',' '{print $1}' file    # Comma separator
awk -F'[ ,]' '{print $1}' file # Space or comma
awk 'BEGIN {FS=":"} {print $1}' file  # In BEGIN block
```

## Patterns

```bash
# Match pattern
awk '/pattern/ {print}' file

# Numeric comparison
awk '$3 > 100' file

# String comparison
awk '$2 == "active"' file

# Regex match
awk '$1 ~ /^[0-9]+$/' file

# NOT match
awk '$1 !~ /pattern/' file

# Multiple conditions
awk '$3 > 100 && $4 == "ok"' file
awk '$3 > 100 || $4 == "ok"' file
```

## Actions

```bash
# Print
awk '{print $1, $2}' file      # Space separated
awk '{print $1 ":" $2}' file   # Custom format

# Calculations
awk '{sum += $1} END {print sum}' file
awk '{print $1 * 2}' file

# Assignments
awk '{$1 = $1 * 2; print}' file

# Functions
awk '{print toupper($1)}' file
awk '{print tolower($1)}' file
awk '{print length($1)}' file
awk '{print substr($1, 1, 3)}' file
```

## BEGIN and END

```bash
# BEGIN: Execute before processing
awk 'BEGIN {print "Header"} {print $1}' file

# END: Execute after processing
awk '{sum += $1} END {print "Total:", sum}' file

# Both
awk 'BEGIN {print "Start"} {count++} END {print "Total:", count}' file
```

## Conditionals

```bash
# If statement
awk '{if ($3 > 100) print $1}' file

# If-else
awk '{if ($3 > 100) print "high"; else print "low"}' file

# Ternary
awk '{print ($3 > 100) ? "high" : "low"}' file
```

## Loops

```bash
# For loop
awk '{for (i=1; i<=NF; i++) print $i}' file

# While loop
awk '{i=1; while (i<=NF) {print $i; i++}}' file
```

## Arrays

```bash
# Count occurrences
awk '{count[$1]++} END {for (i in count) print i, count[i]}' file

# Sum by key
awk '{sum[$1] += $2} END {for (i in sum) print i, sum[i]}' file

# Unique values
awk '{seen[$1]=1} END {for (i in seen) print i}' file
```

## Functions

```bash
length(str)              # String length
substr(str, start, len)  # Substring
index(str, search)       # Find substring position
split(str, arr, sep)     # Split string into array
tolower(str)             # To lowercase
toupper(str)             # To uppercase
gsub(regex, repl, str)   # Global substitution
sub(regex, repl, str)    # First substitution
match(str, regex)        # Match regex
```

## Real-World Examples

**Sum column:**

```bash
awk '{sum += $3} END {print sum}' file
```

**Average:**

```bash
awk '{sum += $1; count++} END {print sum/count}' file
```

**Count occurrences:**

```bash
awk '{count[$1]++} END {for (ip in count) print ip, count[ip]}' access.log
```

**Filter and transform:**

```bash
awk '$3 > 100 {print $1, $2, $3*1.1}' file
```

**CSV processing:**

```bash
awk -F',' 'NR>1 {print $1, $3}' file.csv  # Skip header
```

**Print with line numbers:**

```bash
awk '{print NR, $0}' file
```

**Column alignment:**

```bash
awk '{printf "%-10s %-10s %5d\n", $1, $2, $3}' file
```

**Multi-file processing:**

```bash
awk '{sum[FILENAME] += $1} END {for (f in sum) print f, sum[f]}' file1 file2
```

## Printf Formatting

```bash
%s      # String
%d      # Integer
%f      # Float
%.2f    # Float with 2 decimals
%10s    # Right-aligned 10 chars
%-10s   # Left-aligned 10 chars

awk '{printf "%-10s %5.2f\n", $1, $2}' file
```

## Common Patterns

**Skip header:**

```bash
awk 'NR>1 {print}' file
```

**Print specific line:**

```bash
awk 'NR==5' file
```

**Print range:**

```bash
awk 'NR>=10 && NR<=20' file
```

**Between patterns:**

```bash
awk '/START/,/END/' file
```

**Not empty lines:**

```bash
awk 'NF > 0' file
awk '/./' file
```

## When to Use awk vs sed vs grep

**Use awk for:**

- Column-based data
- Calculations and aggregations
- Complex filtering logic
- Formatted output

**Use sed for:**

- Simple substitutions
- Line-based editing
- In-place file modifications

**Use grep for:**

- Pattern matching
- Filtering lines
- Finding files with content
