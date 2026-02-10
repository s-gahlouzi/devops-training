# Exercise 11: File Operations

## Goal

Perform common file testing and manipulation operations.

## Requirements

Create `file-checker.sh` that takes a path as argument and:

1. Checks if path exists
2. Determines if it's a file or directory
3. If file:
   - Check if readable, writable, executable
   - Print file size
   - Print last modified time
4. If directory:
   - Count files inside
   - List all .txt files
5. Creates a backup: adds `.backup` suffix if file, or creates `{dir}.backup` directory

## Expected Output

```bash
./file-checker.sh test.txt
Path exists: yes
Type: file
Readable: yes
Writable: yes
Executable: no
Size: 1234 bytes
Last modified: 2026-02-04 10:30:45
Backup created: test.txt.backup

./file-checker.sh mydir
Path exists: yes
Type: directory
Files inside: 5
Text files: file1.txt, file2.txt
Backup created: mydir.backup/
```

## Success Criteria

- All file tests work correctly
- Handles both files and directories
- Backup creation works
- Proper error messages for non-existent paths
- Uses file test operators
