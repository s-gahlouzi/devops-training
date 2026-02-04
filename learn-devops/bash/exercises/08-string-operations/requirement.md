# Exercise 08: String Operations

## Goal

Master string manipulation using parameter expansion.

## Requirements

Create `string-utils.sh` with functions:

1. `remove_prefix()` - Remove prefix from string

   - Input: "prefix-name-suffix"
   - Remove: "prefix-"
   - Output: "name-suffix"

2. `remove_suffix()` - Remove suffix from string

   - Input: "file.test.txt"
   - Remove: ".txt"
   - Output: "file.test"

3. `replace_text()` - Replace all occurrences

   - Input: "hello-world-hello"
   - Replace: "hello" with "hi"
   - Output: "hi-world-hi"

4. `to_uppercase()` - Convert to uppercase

   - Input: "hello"
   - Output: "HELLO"

5. `get_length()` - Get string length
   - Input: "testing"
   - Output: 7

Create `test-strings.sh` that tests all functions:

```bash
source string-utils.sh

str="prefix-myapp-v1.0.0"
echo "Original: $str"
echo "Remove prefix: $(remove_prefix "$str" "prefix-")"
echo "Remove suffix: $(remove_suffix "$str" "-v1.0.0")"

echo "Replace: $(replace_text "foo-bar-foo" "foo" "baz")"
echo "Uppercase: $(to_uppercase "hello world")"
echo "Length: $(get_length "testing")"
```

## Expected Output

```
Original: prefix-myapp-v1.0.0
Remove prefix: myapp-v1.0.0
Remove suffix: prefix-myapp
Replace: baz-bar-baz
Uppercase: HELLO WORLD
Length: 7
```

## Success Criteria

- Uses parameter expansion (not external tools)
- All functions work correctly
- Handles edge cases (empty strings)
- No use of sed/awk for basic operations
