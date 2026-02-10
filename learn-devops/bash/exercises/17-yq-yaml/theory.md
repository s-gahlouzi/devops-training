# Theory: yq (YAML Processor)

## Installation

```bash
# Using go
go install github.com/mikefarah/yq/v4@latest

# Using binary
wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64
```

## Basic Usage

```bash
yq '.' file.yml               # Pretty print
yq '.key' file.yml            # Extract key
yq -r '.key' file.yml         # Raw output (v4+)
```

## Access Keys

```bash
# Simple key
yq '.name' file.yml

# Nested key
yq '.server.host' file.yml
yq '.database.pool.max' file.yml

# Array element
yq '.services[0]' file.yml
yq '.services[0].name' file.yml

# Last element
yq '.services[-1]' file.yml
```

## Array Operations

```bash
# All elements
yq '.services[]' file.yml

# Specific field from all
yq '.services[].name' file.yml

# Length
yq '.services | length' file.yml

# Filter
yq '.services[] | select(.enabled == true)' file.yml
yq '.services[] | select(.replicas > 1)' file.yml
```

## Filters and Select

```bash
# Select by condition
yq '.services[] | select(.enabled == true) | .name' file.yml

# Multiple conditions
yq '.services[] | select(.enabled == true and .replicas > 1)' file.yml

# String operations
yq '.services[] | select(.name | startswith("api"))' file.yml
```

## Modify YAML

```bash
# Update value
yq '.server.port = 8080' file.yml

# Update and save (in-place)
yq -i '.server.port = 8080' file.yml

# Add new key
yq '.newKey = "value"' file.yml

# Delete key
yq 'del(.key)' file.yml

# Update nested
yq '.database.pool.max = 20' file.yml
```

## Array Manipulation

```bash
# Add to array
yq '.services += {"name": "new", "enabled": true}' file.yml

# Update array element
yq '.services[0].enabled = false' file.yml

# Remove from array
yq 'del(.services[1])' file.yml

# Map over array
yq '.services |= map(select(.enabled == true))' file.yml
```

## Merge Files

```bash
# Merge two YAML files
yq eval-all '. as $item ireduce ({}; . * $item)' file1.yml file2.yml

# Merge specific keys
yq eval-all 'select(fileIndex == 0) * select(fileIndex == 1)' base.yml override.yml
```

## Convert Formats

```bash
# YAML to JSON
yq -o=json '.' file.yml

# JSON to YAML
yq -P '.' file.json

# Compact JSON
yq -o=json -I=0 '.' file.yml
```

## Multi-document YAML

```bash
# Select specific document
yq 'select(document_index == 0)' file.yml

# All documents
yq '.' file.yml
```

## Conditional Operations

```bash
# If-then-else
yq '.status = (if .enabled == true then "active" else "inactive" end)' file.yml

# Alternative operator
yq '.port // 3000' file.yml  # Use 3000 if port not set
```

## String Operations

```bash
# Concatenate
yq '.fullName = .firstName + " " + .lastName' file.yml

# String interpolation
yq '.url = "https://" + .domain + ":" + (.port | tostring)' file.yml
```

## Collect and Transform

```bash
# Collect specific fields
yq '[.services[] | .name]' file.yml

# Create object from array
yq '.services | map({(.name): .port}) | add' file.yml
```

## Environment Variables

```bash
# Use env var
yq '.version = env(VERSION)' file.yml

# With default
yq '.port = (env(PORT) // 3000)' file.yml
```

## Real-World Examples

**Extract Docker Compose services:**

```bash
yq '.services | keys' docker-compose.yml
```

**Get GitHub Actions job names:**

```bash
yq '.jobs | keys' .github/workflows/ci.yml
```

**Update Kubernetes replicas:**

```bash
yq -i '.spec.replicas = 3' deployment.yml
```

**Extract all environment variables:**

```bash
yq '.services[].environment[]' docker-compose.yml
```

**Find services using specific image:**

```bash
yq '.services[] | select(.image | contains("node")) | key' docker-compose.yml
```

**Generate env file from YAML:**

```bash
yq -r '.env | to_entries | .[] | .key + "=" + .value' config.yml > .env
```

**Check if key exists:**

```bash
yq 'has("scripts")' package.json
```

**Count jobs in workflow:**

```bash
yq '.jobs | length' .github/workflows/ci.yml
```

**List all workflow triggers:**

```bash
yq '.on | keys' .github/workflows/ci.yml
```

**Extract version from Helm chart:**

```bash
yq '.version' Chart.yaml
```

**Update multiple values:**

```bash
yq -i '
  .server.port = 8080 |
  .server.host = "0.0.0.0" |
  .database.pool.max = 20
' config.yml
```

## Common CI/CD Patterns

**Read app config:**

```bash
APP_NAME=$(yq '.app.name' config.yml)
VERSION=$(yq '.app.version' config.yml)
```

**Update version in config:**

```bash
yq -i ".version = \"$NEW_VERSION\"" config.yml
```

**Extract matrix values:**

```bash
yq -o=json '.strategy.matrix.node[]' .github/workflows/ci.yml
```

**Validate required fields:**

```bash
required_keys=("name" "version" "environment")
for key in "${required_keys[@]}"; do
    value=$(yq ".$key" config.yml)
    [[ "$value" == "null" ]] && echo "Missing: $key" && exit 1
done
```

**Merge environment configs:**

```bash
yq eval-all '. as $item ireduce ({}; . * $item)' base.yml env/$ENV.yml > final.yml
```

**Generate Kubernetes config:**

```bash
yq eval ".metadata.labels.version = \"$VERSION\" |
         .spec.replicas = $REPLICAS" template.yml > deployment.yml
```

## yq vs jq

**Similarities:**

- Similar query syntax
- Pipe operations
- Filtering and transformations

**Differences:**

- yq: YAML-native (can output JSON)
- jq: JSON-only
- yq: In-place editing with `-i`
- jq: Requires temp file for in-place edit

## Best Practices

1. Use `-i` for in-place modifications
2. Use `-o=json` for CI/CD pipelines (easier to parse)
3. Quote complex expressions
4. Test queries before in-place edit
5. Use `select()` for filtering
6. Use `env()` for environment variables
7. Validate YAML after modifications
