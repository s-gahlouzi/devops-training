# Exercise 06: While and Until Loops

## Goal

Create scripts using while and until loops for different scenarios.

## Requirements

Create `read-file.sh` that:

1. Takes a filename as first argument
2. Reads the file line by line using a while loop
3. Numbers each line (1, 2, 3...)
4. Prints: "Line {number}: {content}"

Create `wait-for-file.sh` that:

1. Takes a filename as first argument
2. Uses an until loop to wait for file to exist
3. Checks every 2 seconds
4. Times out after 10 seconds (5 attempts)
5. Prints status messages

## Expected Output

```bash
# read-file.sh
./read-file.sh test.txt
Line 1: first line content
Line 2: second line content
Line 3: third line content

# wait-for-file.sh
./wait-for-file.sh data.txt
Waiting for data.txt...
Waiting for data.txt...
File data.txt appeared!
```

## Success Criteria

- While loop reads files correctly
- Preserves whitespace in lines
- Until loop works with timeout
- Clear status messages
- Proper error handling
