# Theory: String Operations

## Parameter Expansion

### Length

```bash
str="hello"
echo "${#str}"           # 5
```

### Remove Prefix

```bash
str="prefix-name"
echo "${str#prefix-}"    # name (shortest match)
echo "${str##prefix-}"   # name (longest match)

# Example: remove path
path="/usr/local/bin/app"
echo "${path##*/}"       # app
```

### Remove Suffix

```bash
str="file.txt"
echo "${str%.txt}"       # file (shortest match)
echo "${str%%.txt}"      # file (longest match)

# Example: remove extension
file="archive.tar.gz"
echo "${file%.gz}"       # archive.tar (one extension)
echo "${file%%.*}"       # archive (all extensions)
```

### Replace

```bash
str="hello world hello"
echo "${str/hello/hi}"   # hi world hello (first match)
echo "${str//hello/hi}"  # hi world hi (all matches)

# Remove (replace with empty)
echo "${str//hello/}"    # world
```

### Case Conversion

```bash
str="Hello World"
echo "${str^^}"          # HELLO WORLD (uppercase)
echo "${str,,}"          # hello world (lowercase)
echo "${str^}"           # Hello World (first char upper)
echo "${str,}"           # hello World (first char lower)
```

### Substrings

```bash
str="hello world"
echo "${str:0:5}"        # hello (offset:length)
echo "${str:6}"          # world (from offset to end)
echo "${str: -5}"        # world (last 5 chars, note space)
```

## Default Values

```bash
${var:-default}          # Use default if unset/empty
${var:=default}          # Assign default if unset/empty
${var:?error}            # Error if unset/empty
${var:+alternate}        # Use alternate if set
```

## Pattern Matching

```bash
# Glob patterns work in # and %
str="test.backup.txt"
echo "${str#*.}"         # backup.txt (remove shortest .*)
echo "${str##*.}"        # txt (remove longest .*)
echo "${str%.*}"         # test.backup (remove shortest .*)
echo "${str%%.*}"        # test (remove longest .*)
```

## Real-World Examples

**Extract filename:**

```bash
path="/path/to/file.txt"
filename="${path##*/}"   # file.txt
```

**Extract directory:**

```bash
path="/path/to/file.txt"
dir="${path%/*}"         # /path/to
```

**Extract extension:**

```bash
file="archive.tar.gz"
ext="${file##*.}"        # gz
```

**Version manipulation:**

```bash
version="v1.2.3"
version="${version#v}"   # 1.2.3
```

## When to Use External Tools

Use parameter expansion for:

- Simple prefix/suffix removal
- Case conversion
- Length checks
- Replace operations

Use sed/awk for:

- Complex regex patterns
- Multi-line operations
- Multiple transformations
- Large file processing
