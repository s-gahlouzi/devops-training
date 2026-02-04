#!/usr/bin/env bash

# Remove prefix from string
remove_prefix() {
    local str="$1"
    local prefix="$2"
    echo "${str#"$prefix"}"
}

# Remove suffix from string
remove_suffix() {
    local str="$1"
    local suffix="$2"
    echo "${str%"$suffix"}"
}

# Replace all occurrences
replace_text() {
    local str="$1"
    local search="$2"
    local replace="$3"
    echo "${str//"$search"/"$replace"}"
}

# Convert to uppercase
to_uppercase() {
    local str="$1"
    echo "${str^^}"
}

# Get string length
get_length() {
    local str="$1"
    echo "${#str}"
}
