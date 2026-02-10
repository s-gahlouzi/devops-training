# Theory: jq (JSON Processor)

## Basic Usage

```bash
jq '.' file.json              # Pretty print
jq '.key' file.json           # Extract key
jq -r '.key' file.json        # Raw output (no quotes)
echo '{"a":1}' | jq '.a'      # From stdin
```

## Access Keys

```bash
# Object
jq '.name' file.json          # Get name
jq '.user.email' file.json    # Nested
jq '."key with spaces"' file.json  # Special chars

# Array
jq '.[0]' file.json           # First element
jq '.[-1]' file.json          # Last element
jq '.[2:4]' file.json         # Slice (index 2-3)
```

## Array Operations

```bash
# Iterate
jq '.[]' file.json            # All elements
jq '.items[]' file.json       # All items in array

# Extract field from each
jq '.[].name' file.json

# Length
jq '. | length' file.json
jq '.items | length' file.json
```

## Filters and Pipes

```bash
# Pipe
jq '.items[] | .name' file.json

# Select (filter)
jq '.[] | select(.status == "active")' file.json
jq '.[] | select(.age > 18)' file.json
jq '.[] | select(.name | startswith("A"))' file.json

# Map
jq '.items | map(.name)' file.json
jq 'map(select(.active)) | map(.id)' file.json
```

## Construct Objects

```bash
# New object
jq '{name: .name, id: .id}' file.json

# Array of objects
jq '.[] | {name, port}' file.json

# With computed values
jq '{name: .name, double: (.value * 2)}' file.json
```

## Arrays and Collections

```bash
# Collect into array
jq '[.[] | .name]' file.json

# Flatten
jq '.[] | .items[]' file.json
jq 'flatten' file.json        # Flatten nested arrays

# Unique
jq 'unique' file.json
jq '[.[] | .type] | unique' file.json

# Sort
jq 'sort' file.json
jq 'sort_by(.age)' file.json
jq 'sort_by(.name) | reverse' file.json
```

## Conditionals

```bash
# If-then-else
jq 'if .status == "ok" then "good" else "bad" end' file.json

# Ternary-like with select
jq '.[] | select(.active) // empty' file.json
```

## Functions

```bash
# String
jq '.name | length' file.json
jq '.name | tostring' file.json
jq '.name | tonumber' file.json
jq '.name | ascii_upcase' file.json
jq '.name | ascii_downcase' file.json
jq '.text | split(",")' file.json
jq '.items | join(", ")' file.json

# Test
jq '.email | test("@gmail.com$")' file.json
jq '.version | startswith("2.")' file.json
jq '.name | endswith(".txt")' file.json
jq '.value | contains("test")' file.json

# Type
jq '.value | type' file.json  # string, number, array, object, etc.

# Keys
jq 'keys' file.json           # Object keys or array indices
jq '.data | keys' file.json
```

## Aggregations

```bash
# Count
jq '.[] | length' file.json

# Sum
jq '.items | map(.price) | add' file.json

# Min/Max
jq '.[] | .age' file.json | jq -s 'max'
jq '.[] | .age' file.json | jq -s 'min'

# Group by
jq 'group_by(.category)' file.json
```

## Modify JSON

```bash
# Update value
jq '.version = "2.0.0"' file.json

# Add key
jq '. + {newKey: "value"}' file.json

# Delete key
jq 'del(.key)' file.json

# Update nested
jq '.config.port = 8080' file.json

# Update in array
jq '.items[0].name = "updated"' file.json
```

## Multiple Outputs

```bash
# Multiple values
jq '.name, .version' file.json

# Multiple queries
jq '.name' file.json
jq '.version' file.json
```

## Raw Output

```bash
jq -r '.name' file.json       # No quotes
jq -r '.items[] | .name' file.json  # Each on new line
```

## Compact Output

```bash
jq -c '.' file.json           # Compact (one line)
```

## Slurp (Multiple JSONs)

```bash
# Read multiple JSON objects into array
jq -s '.' file1.json file2.json

# Combine multiple
echo '{"a":1}' > f1.json
echo '{"b":2}' > f2.json
jq -s '.[0] + .[1]' f1.json f2.json  # Merge objects
```

## Real-World Examples

**Extract version from package.json:**

```bash
jq -r '.version' package.json
```

**Get all dependency names:**

```bash
jq -r '.dependencies | keys[]' package.json
```

**Find running services:**

```bash
jq -r '.[] | select(.status == "running") | .name' services.json
```

**Convert to CSV:**

```bash
jq -r '.[] | [.name, .port, .status] | @csv' services.json
```

**Create lookup object:**

```bash
jq 'reduce .[] as $item ({}; .[$item.name] = $item.port)' services.json
```

**Update and write back:**

```bash
jq '.version = "2.0.0"' package.json | sponge package.json
# or
jq '.version = "2.0.0"' package.json > tmp.json && mv tmp.json package.json
```

**Filter and transform:**

```bash
jq '.items | map(select(.active) | {id, name})' data.json
```

**Extract from GitHub API:**

```bash
curl -s https://api.github.com/repos/owner/repo | jq -r '.stargazers_count'
```

**Environment variables:**

```bash
jq --arg version "$VERSION" '.version = $version' package.json
```

## Common Patterns for CI/CD

**Get build info:**

```bash
version=$(jq -r '.version' package.json)
name=$(jq -r '.name' package.json)
```

**Check if key exists:**

```bash
has_tests=$(jq 'has("scripts") and .scripts | has("test")' package.json)
```

**Merge configs:**

```bash
jq -s '.[0] * .[1]' default.json custom.json
```

**Generate matrix:**

```bash
jq -c '.services[] | {name, version}' services.json
```

## Best Practices

1. Use `-r` for raw strings (no quotes)
2. Use `-c` for compact output in CI/CD
3. Always quote jq expressions
4. Test queries interactively first
5. Use `select()` for filtering
6. Use `map()` for transformations
7. Combine with other tools (grep, sed, etc.)
