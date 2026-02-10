# Exercise 07: Functions

## Goal

Create reusable functions with proper argument handling and return values.

## Requirements

Create `utils.sh` that contains three functions:

1. `log()` - Prints timestamped messages

   - Takes message as argument
   - Prints: `[YYYY-MM-DD HH:MM:SS] message`

2. `validate_port()` - Validates port number

   - Takes port as argument
   - Returns 0 if valid (1-65535)
   - Returns 1 if invalid
   - No output for valid ports
   - Prints error for invalid

3. `get_file_extension()` - Extracts file extension
   - Takes filename as argument
   - Outputs extension (without dot)
   - Returns 1 if no extension

Create `main.sh` that sources `utils.sh` and tests all functions:

```bash
source utils.sh

log "Starting script"

if validate_port 8080; then
    log "Port is valid"
fi

if validate_port 70000; then
    log "Port is valid"
else
    log "Port is invalid"
fi

ext=$(get_file_extension "test.txt")
log "Extension: $ext"
```

## Expected Output

```
[2026-02-04 10:30:45] Starting script
[2026-02-04 10:30:45] Port is valid
Error: Invalid port: 70000
[2026-02-04 10:30:45] Port is invalid
[2026-02-04 10:30:45] Extension: txt
```

## Success Criteria

- Functions use local variables
- Proper argument handling
- Return codes used correctly
- Output captured with $()
- Source file works correctly
