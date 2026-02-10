# Theory: Associative Arrays

## Declaration

```bash
# Must declare before use
declare -A map

# With initial values
declare -A ports=(
    [api]=3000
    [web]=8080
    [database]=5432
)
```

## Access Elements

```bash
declare -A map
map[key]="value"

echo "${map[key]}"       # Get value
echo "${map[@]}"         # All values
echo "${!map[@]}"        # All keys
echo "${#map[@]}"        # Number of elements
```

## Set and Update

```bash
declare -A config

# Set
config[host]="localhost"
config[port]=8080

# Update
config[port]=3000
```

## Check Key Exists

```bash
declare -A map
map[key]="value"

# Method 1: test if set
if [[ -v map[key] ]]; then
    echo "Key exists"
fi

# Method 2: check value
if [[ -n "${map[key]:-}" ]]; then
    echo "Key exists and has value"
fi
```

## Iterate

```bash
declare -A services=(
    [api]=3000
    [web]=8080
)

# Iterate keys
for key in "${!services[@]}"; do
    echo "Service: $key, Port: ${services[$key]}"
done

# Iterate values only
for port in "${services[@]}"; do
    echo "Port: $port"
done
```

## Delete Element

```bash
declare -A map
map[key]="value"

# Delete key
unset 'map[key]'

# Clear all
map=()
# or
unset map
declare -A map
```

## Real-World Examples

**Environment config:**

```bash
declare -A config=(
    [DB_HOST]="localhost"
    [DB_PORT]="5432"
    [DB_NAME]="myapp"
)

echo "Connecting to ${config[DB_HOST]}:${config[DB_PORT]}"
```

**Service health:**

```bash
declare -A health

check_service() {
    local service="$1"
    # check logic
    health[$service]="healthy"
}

for service in api web worker; do
    check_service "$service"
done

for service in "${!health[@]}"; do
    echo "$service: ${health[$service]}"
done
```

**Count occurrences:**

```bash
declare -A counts

while IFS= read -r word; do
    ((counts[$word]++))
done < words.txt

for word in "${!counts[@]}"; do
    echo "$word: ${counts[$word]}"
done
```

## Best Practices

1. Always `declare -A` before use
2. Quote keys with spaces: `map["key with spaces"]`
3. Use `[[ -v map[key] ]]` to check existence
4. Use `"${!map[@]}"` for keys
5. Use `"${map[@]}"` for values
6. Quote variables: `"${map[$key]}"`
