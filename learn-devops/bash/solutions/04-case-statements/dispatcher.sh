#!/usr/bin/env bash
set -euo pipefail

show_usage() {
    cat <<EOF
Usage: dispatcher.sh {build|test|deploy|help}

Commands:
  build  - Build the application
  test   - Run tests
  deploy - Deploy to production
  help   - Show this help message
EOF
}

# Check if argument provided
if [[ $# -eq 0 ]]; then
    echo "Error: No command specified" >&2
    show_usage
    exit 1
fi

command="$1"

case "$command" in
    build)
        echo "Building application..."
        ;;
    test)
        echo "Running tests..."
        ;;
    deploy)
        echo "Deploying to production..."
        ;;
    help)
        show_usage
        ;;
    *)
        echo "Error: Unknown command: $command" >&2
        show_usage
        exit 1
        ;;
esac
