# Theory: File Operations

## File Test Operators

```bash
[[ -e path ]]       # Exists (file or directory)
[[ -f path ]]       # Regular file
[[ -d path ]]       # Directory
[[ -L path ]]       # Symbolic link
[[ -r path ]]       # Readable
[[ -w path ]]       # Writable
[[ -x path ]]       # Executable
[[ -s path ]]       # Non-empty file
[[ -O path ]]       # Owned by current user
[[ -G path ]]       # Owned by current group
```

## File Comparison

```bash
[[ file1 -nt file2 ]]   # file1 newer than file2
[[ file1 -ot file2 ]]   # file1 older than file2
[[ file1 -ef file2 ]]   # Same file (hard links)
```

## File Info

```bash
# File size
stat -c%s file          # Linux
stat -f%z file          # macOS
# Portable
wc -c < file

# Last modified
stat -c%y file          # Linux
stat -f%Sm file         # macOS
# Portable
ls -l file

# Better: use date
date -r file "+%Y-%m-%d %H:%M:%S"  # Linux/macOS
```

## Create Files and Directories

```bash
# Create empty file
touch file.txt

# Create file with content
echo "content" > file.txt
cat > file.txt <<EOF
line1
line2
EOF

# Create directory
mkdir dir
mkdir -p path/to/dir    # Create parent dirs

# Create temp file
tmpfile=$(mktemp)
tmpdir=$(mktemp -d)
```

## Copy, Move, Delete

```bash
# Copy
cp source dest
cp -r dir1 dir2         # Recursive

# Move/rename
mv source dest

# Delete
rm file
rm -rf dir              # Recursive, force
```

## Check Before Operations

```bash
# Safe file creation
if [[ -f "$file" ]]; then
    echo "File exists, backing up"
    cp "$file" "$file.backup"
fi
echo "content" > "$file"

# Safe directory creation
if [[ ! -d "$dir" ]]; then
    mkdir -p "$dir"
fi
```

## Count Files

```bash
# Count files in directory
count=$(find dir -type f | wc -l)

# Count specific files
count=$(find dir -name "*.txt" -type f | wc -l)

# Using glob (includes current dir only)
files=(dir/*.txt)
count=${#files[@]}
[[ -f "${files[0]}" ]] && echo "$count files" || echo "0 files"
```

## Find Files

```bash
# Find by name
find dir -name "*.txt"

# Find and execute
find dir -name "*.log" -exec rm {} \;

# Find modified in last 7 days
find dir -mtime -7

# Find larger than 1MB
find dir -size +1M
```

## Real-World Patterns

**Backup with timestamp:**

```bash
backup_file() {
    local file="$1"
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local backup="${file}.${timestamp}.backup"
    cp "$file" "$backup"
    echo "Backed up to: $backup"
}
```

**Cleanup old files:**

```bash
find /tmp/logs -name "*.log" -mtime +7 -delete
```

**Check required files:**

```bash
required_files=(".env" "config.yml" "Dockerfile")
for file in "${required_files[@]}"; do
    [[ -f "$file" ]] || {
        echo "Missing required file: $file" >&2
        exit 1
    }
done
```

## Best Practices

1. Always quote file paths: `"$file"`
2. Check existence before operations
3. Use `-p` with mkdir for safety
4. Use `-f` or `-r` carefully with rm
5. Test operations in dry-run mode first
6. Create backups before destructive ops
