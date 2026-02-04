# Theory: Indexed Arrays

## Array Declaration

```bash
# Empty array
arr=()

# With values
arr=(value1 value2 value3)

# Multi-line
arr=(
    value1
    value2
    value3
)
```

## Access Elements

```bash
arr=(one two three)
echo "${arr[0]}"         # one (first element)
echo "${arr[1]}"         # two
echo "${arr[-1]}"        # three (last element)
echo "${arr[@]}"         # one two three (all elements)
echo "${#arr[@]}"        # 3 (array length)
```

## Modify Array

```bash
# Set element
arr[0]="new value"

# Append
arr+=("new item")
arr[${#arr[@]}]="another"

# Multiple append
arr+=("item1" "item2")
```

## Iterate with Index

```bash
arr=(a b c)

# Method 1: Index iteration
for i in "${!arr[@]}"; do
    echo "[$i] ${arr[$i]}"
done

# Method 2: Direct iteration
for item in "${arr[@]}"; do
    echo "$item"
done

# Method 3: C-style
for ((i=0; i<${#arr[@]}; i++)); do
    echo "[$i] ${arr[$i]}"
done
```

## Array Operations

**Check if element exists:**

```bash
array_contains() {
    local item="$1"
    shift
    local arr=("$@")

    for element in "${arr[@]}"; do
        [[ "$element" == "$item" ]] && return 0
    done
    return 1
}

if array_contains "web" "${services[@]}"; then
    echo "Found"
fi
```

**Remove element:**

```bash
# Remove by index
unset 'arr[2]'

# Remove by value (recreate array)
arr=(one two three two)
arr=("${arr[@]/two/}")  # Remove all "two"

# Better: filter array
new_arr=()
for item in "${arr[@]}"; do
    [[ "$item" != "unwanted" ]] && new_arr+=("$item")
done
arr=("${new_arr[@]}")
```

## Slicing

```bash
arr=(a b c d e)
echo "${arr[@]:1:3}"     # b c d (start:length)
echo "${arr[@]:2}"       # c d e (from index 2)
```

## Convert String to Array

```bash
# Word splitting
str="one two three"
arr=($str)               # arr=(one two three)

# Using read
IFS=',' read -ra arr <<< "one,two,three"

# From file
mapfile -t arr < file.txt
```

## Best Practices

1. Always quote: `"${arr[@]}"`
2. Use `"${!arr[@]}"` for indices
3. Use `"${#arr[@]}"` for length
4. Check if array is empty: `(( ${#arr[@]} == 0 ))`
5. Use `+=()` to append
