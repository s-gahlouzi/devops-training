#!/usr/bin/env bash
set -euo pipefail

# Source utilities
source "$(dirname "$0")/string-utils.sh"

str="prefix-myapp-v1.0.0"
echo "Original: $str"
echo "Remove prefix: $(remove_prefix "$str" "prefix-")"
echo "Remove suffix: $(remove_suffix "$str" "-v1.0.0")"
echo

echo "Replace: $(replace_text "foo-bar-foo" "foo" "baz")"
echo "Uppercase: $(to_uppercase "hello world")"
echo "Length: $(get_length "testing")"
