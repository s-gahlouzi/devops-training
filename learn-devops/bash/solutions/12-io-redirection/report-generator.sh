#!/usr/bin/env bash
set -euo pipefail

# Check arguments
if [[ $# -lt 3 ]]; then
    echo "Usage: $0 <title> <date> <status>" >&2
    exit 1
fi

title="$1"
date="$2"
status="$3"

# Generate HTML report using here-doc
cat > report.html <<EOF
<!DOCTYPE html>
<html>
<head>
    <title>${title}</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .status { font-weight: bold; color: ${status == "SUCCESS" && echo "green" || echo "red"}; }
    </style>
</head>
<body>
    <h1>${title}</h1>
    <p>Date: ${date}</p>
    <p>Status: <span class="status">${status}</span></p>
</body>
</html>
EOF

echo "Report generated: report.html"
