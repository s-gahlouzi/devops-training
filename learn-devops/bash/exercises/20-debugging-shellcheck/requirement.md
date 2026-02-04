# Exercise 20: Debugging and Shellcheck

## Goal

Learn debugging techniques and static analysis for bash scripts.

## Requirements

Create `buggy-script.sh` with intentional bugs:

```bash
#!/usr/bin/env bash

name=$1
count=5

for i in $(seq 1 $count); do
    echo "Processing $name iteration $i"

    files=$(ls *.txt)
    for file in $files; do
        cat $file | grep "error"
    done

    if [ $status == "ready" ]; then
        echo "Status is ready"
    fi
done

cd $WORK_DIR
rm -rf *
```

Create `debug-script.sh` that demonstrates:

1. Basic set -x tracing
2. Custom PS4 for better trace output
3. Selective debugging (only specific sections)
4. Trap DEBUG for step-by-step execution
5. Logging debug information to file

Create `fixed-script.sh` that fixes all issues:

1. Proper quoting
2. Safe variable handling
3. Proper conditionals
4. Avoid UUOC (Useless Use of Cat)
5. Safe glob usage
6. Variable checks

Create a script that runs shellcheck on buggy-script.sh and explains each issue.

## Expected Output

```bash
# Running with set -x
bash -x debug-script.sh
+ name=test
+ echo 'Name: test'
Name: test
...

# With custom PS4
./debug-script.sh
+ script.sh:5:main: echo 'Processing...'
Processing...

# Shellcheck output
./check-script.sh buggy-script.sh

Issues found:
Line 3: name=$1
        ^-- SC2086: Double quote to prevent globbing

Line 8: files=$(ls *.txt)
        ^-- SC2045: Iterating over ls output is fragile

Line 10: cat $file | grep "error"
         ^-- SC2086: Double quote to prevent globbing
         ^-- SC2002: Useless cat

Line 13: if [ $status == "ready" ]; then
            ^-- SC2086: Double quote to prevent globbing
            ^-- SC2039: Use = not == in [ ]

Line 18: cd $WORK_DIR
         ^-- SC2086: Double quote to prevent globbing
         ^-- SC2164: Use cd ... || exit in case cd fails
```

## Success Criteria

- Understands set -x and PS4
- Can enable/disable debug mode
- Fixes all shellcheck warnings
- Understands common pitfalls
- Writes shellcheck-clean scripts
