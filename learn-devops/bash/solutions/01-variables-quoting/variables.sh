#!/usr/bin/env bash

# Declare variables
name="my-app"
version="1.0.0"
environment="production"

# Command substitution for current date
current_date=$(date +%Y-%m-%d)

# Output with proper quoting
echo "Name: ${name}"
echo "Version: ${version}"
echo "Environment: ${environment}"
echo "Date: ${current_date}"

# Demonstrate quote types
echo "Single quotes: '\$name'"
echo "Double quotes: \"${name}\""

# Word splitting demonstration
unquoted_spaces="one two three"
echo "Unquoted spaces: $unquoted_spaces"
echo "Quoted spaces: \"${unquoted_spaces}\""
