# Exercise 05: For Loops

## Goal

Create scripts that iterate over files and arrays using for loops.

## Requirements

Create `process-files.sh` that:

1. Iterates over all `.txt` files in the current directory
2. For each file:
   - Prints filename
   - Counts lines using `wc -l`
   - Prints line count

Create `process-services.sh` that:

1. Defines an array of service names: `api`, `web`, `worker`, `cache`
2. Iterates over the array
3. For each service, prints: "Checking service: {name}"

## Expected Output

```bash
# process-files.sh (assuming test1.txt and test2.txt exist)
Processing: test1.txt
Lines: 10
Processing: test2.txt
Lines: 25

# process-services.sh
Checking service: api
Checking service: web
Checking service: worker
Checking service: cache
```

## Success Criteria

- Correctly iterates over glob pattern
- Handles case when no files exist
- Array iteration works correctly
- Proper quoting of variables
